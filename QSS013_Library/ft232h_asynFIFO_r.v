module ft232h_asynFIFO_r
(
	input i_clk,
	input i_rst_n,
	input i_rxf_n,
    input [7:0] i_data_in, 
    output o_rd_n,
	output reg [7:0] o_data_read,
    output reg o_read_done
);

`define FT_WAIT_CNT 1

/***FT232H asynFIFO read SM ***/
localparam FT_IDLE = 0;
localparam FT_READ_DATA = 1;
localparam FT_READ_WAIT = 2;
localparam FT_READ_DONE = 3;

reg r_rd_n;
reg[5:0] curent_state, next_state;
reg [3:0] r_ft_wait;
reg r_ftWait_done;


assign o_rd_n = r_rd_n;

/***current state generator ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) 
        curent_state <= FT_IDLE;
    else 
        curent_state <= next_state;
end

/***next state generator ***/
always@(*) begin
    case(curent_state)
        FT_IDLE: begin
            if(!i_rxf_n) next_state = FT_READ_DATA;
            else next_state = FT_IDLE;
        end
        
        FT_READ_DATA: next_state = FT_READ_WAIT;
        
        FT_READ_WAIT: begin 
            if(r_ftWait_done) next_state = FT_READ_DONE;
            else next_state = FT_READ_WAIT;
        end
        
        FT_READ_DONE: next_state = FT_IDLE;
        
    
    endcase
end


/*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r_rd_n <= 1'b1;
        r_ft_wait <= `FT_WAIT_CNT;
        r_ftWait_done <= 1'b0;
    end
    else begin
    o_read_done <= 1'b0;
        case(curent_state)
            FT_IDLE: begin
                r_ft_wait <= `FT_WAIT_CNT;
                r_ftWait_done <= 1'b0;
                o_read_done <= 1'b0; 
                if(!i_rxf_n) r_rd_n <= 1'b0;
                else r_rd_n <= 1'b1;
            end
            
            FT_READ_DATA: begin
				o_data_read <= i_data_in;
                o_read_done <= 1'b1;
            end
        
            FT_READ_WAIT: begin
                if(r_ft_wait != 0) r_ft_wait <= r_ft_wait - 1'b1;
                else r_ftWait_done <= 1'b1;
            end
            
            FT_READ_DONE: begin
                r_rd_n <= 1'b1;
            end
            
        endcase
    end
end

endmodule