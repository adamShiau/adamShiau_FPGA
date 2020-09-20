module ft232h_asynFIFO_w
(
	input i_clk,
	input i_rst_n,
	input i_txe_n,
	output o_wr_n,
	input i_rx_dv,
	input [15:0] i_adc_data,
	output reg [7:0] o_r_data_out
);
/***FT232H asynFIFO write SM ***/
localparam FT_IDLE = 0;
localparam FT_PREPARE_DATA = 1;
localparam FT_WRITE_DATA = 2;
localparam FT_WAIT = 3;
localparam FT_WRITE_DONE = 4;
localparam FT_MIDDLE = 5;
localparam FT_PREPARE_DATA_2 = 6;
localparam FT_WRITE_DATA_2 = 7;
localparam FT_WAIT_2 = 8;
localparam FT_WRITE_DONE_2 = 9;

`define FT_WAIT_CNT 1

reg[5:0] curent_state, next_state;
reg [3:0] r_ft_wait;
reg r_ftWait_done;
reg r_wr_n;

assign o_wr_n = r_wr_n;

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
            if(!i_txe_n && i_rx_dv) next_state = FT_PREPARE_DATA;
            else next_state = FT_IDLE;
        end
        
        FT_PREPARE_DATA: next_state = FT_WRITE_DATA;
        
        FT_WRITE_DATA: next_state = FT_WAIT;
        
        FT_WAIT:begin
            if(r_ftWait_done)
                next_state = FT_WRITE_DONE;
            else next_state = FT_WAIT;
        end
        
        FT_WRITE_DONE: begin
            if(r_wr_n) next_state = FT_MIDDLE;
            else next_state = FT_WRITE_DONE;
        end
		
		FT_MIDDLE: begin
            if(!i_txe_n) next_state = FT_PREPARE_DATA_2;
            else next_state = FT_MIDDLE;
        end
        
        FT_PREPARE_DATA_2: next_state = FT_WRITE_DATA_2;
        
        FT_WRITE_DATA_2: next_state = FT_WAIT_2;
        
        FT_WAIT_2:begin
            if(r_ftWait_done)
                next_state = FT_WRITE_DONE_2;
            else next_state = FT_WAIT_2;
        end
        
        FT_WRITE_DONE_2: begin
            if(r_wr_n) next_state = FT_IDLE;
            else next_state = FT_WRITE_DONE_2;
        end
    
    endcase
end


/*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r_wr_n <= 1'b1;
        o_r_data_out <= 0;
        r_ft_wait <= `FT_WAIT_CNT;
        r_ftWait_done <= 1'b0;
    end
    else begin
        case(curent_state)
            FT_IDLE: begin
                r_wr_n <= 1'b1;
                r_ft_wait <= `FT_WAIT_CNT;
                r_ftWait_done <= 1'b0;
				
            end
            
            FT_PREPARE_DATA: begin
				o_r_data_out <= i_adc_data[15:8];
            end
        
            FT_WRITE_DATA: begin
                r_wr_n <= 1'b0;
            end
            
            FT_WAIT: begin
                if(r_ft_wait != 0) r_ft_wait <= r_ft_wait - 1'b1;
                else r_ftWait_done <= 1'b1;
            end
            
            FT_WRITE_DONE: begin
                r_wr_n <= 1'b1; 
            end
			
			FT_MIDDLE: begin
                r_wr_n <= 1'b1;
                r_ft_wait <= `FT_WAIT_CNT;
                r_ftWait_done <= 1'b0;
            end
            
            FT_PREPARE_DATA_2: begin
				o_r_data_out <= i_adc_data[7:0];
            end
        
            FT_WRITE_DATA_2: begin
                r_wr_n <= 1'b0;
            end
            
            FT_WAIT_2: begin
                if(r_ft_wait != 0) r_ft_wait <= r_ft_wait - 1'b1;
                else r_ftWait_done <= 1'b1;
            end
            
            FT_WRITE_DONE_2: begin
                r_wr_n <= 1'b1; 
            end
        
        endcase
    end
end

endmodule