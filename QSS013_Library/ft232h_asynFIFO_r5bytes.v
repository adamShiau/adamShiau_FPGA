module ft232h_asynFIFO_r5bytes
(
	input i_clk,
	input i_rst_n,
	input i_rxf_n,
    input [7:0] i_data_in, 
    output o_rd_n,
	output reg [31:0] o_data_read,
    output reg [7:0] o_cmd,
    output reg o_data_ready
    /*** debug ***/
    ,output read_done 
    ,output [7:0] byte_cmd
    ,output reg [4:0] read_SM
);

`define HOLD_CLK 2

localparam WAIT_FIRST_BYTE = 0;
localparam READ_FIRST_BYTE = 1;
localparam WAIT_SECOND_BYTE = 2;
localparam READ_SECOND_BYTE = 3;
localparam WAIT_THIRD_BYTE = 4;
localparam READ_THIRD_BYTE = 5;
localparam WAIT_FOURTH_BYTE = 6;
localparam READ_FOURTH_BYTE = 7;
localparam WAIT_FIFTH_BYTE = 8;
localparam READ_FIFTH_BYTE = 9;

reg [4:0] read_SM;

wire [7:0] byte_cmd;
wire read_done;

always@(posedge i_clk) begin
    if(!i_rst_n) begin
        o_data_read <= 32'd0;
        read_SM <= 5'd0;
        o_data_ready <= 1'b0;
    end
    else begin
        o_data_ready <= 1'b0;
        case(read_SM)
            WAIT_FIRST_BYTE: 
                if(!o_rd_n & read_done) read_SM <= READ_FIRST_BYTE;
                else read_SM <= WAIT_FIRST_BYTE;
                
            READ_FIRST_BYTE: begin
                o_cmd <= byte_cmd;
                read_SM <= WAIT_SECOND_BYTE;
            end
            
            WAIT_SECOND_BYTE: 
                if(!o_rd_n & read_done) read_SM <= READ_SECOND_BYTE;
                else read_SM <= WAIT_SECOND_BYTE;
                
            READ_SECOND_BYTE: begin
                o_data_read[31:24] <= byte_cmd;
                read_SM <= WAIT_THIRD_BYTE;
            end
             
            WAIT_THIRD_BYTE: 
                if(!o_rd_n & read_done) read_SM <= READ_THIRD_BYTE;
                else read_SM <= WAIT_THIRD_BYTE;
                
            READ_THIRD_BYTE: begin
                o_data_read[23:16] <= byte_cmd;
                read_SM <= WAIT_FOURTH_BYTE;
            end
            
            WAIT_FOURTH_BYTE: 
                if(!o_rd_n & read_done) read_SM <= READ_FOURTH_BYTE;
                else read_SM <= WAIT_FOURTH_BYTE;
                
            READ_FOURTH_BYTE: begin
                o_data_read[15:8] <= byte_cmd;
                read_SM <= WAIT_FIFTH_BYTE;
            end
            
            WAIT_FIFTH_BYTE: 
                if(!o_rd_n & read_done) read_SM <= READ_FIFTH_BYTE;
                else read_SM <= WAIT_FIFTH_BYTE;
                
            READ_FIFTH_BYTE: begin
                o_data_read[7:0] <= byte_cmd;
                read_SM <= WAIT_FIRST_BYTE;
                o_data_ready <= 1'b1;
            end
            
        endcase
    end

end

ft232h_asynFIFO_r ft232h_r
(
    .i_clk(i_clk),
    .i_rst_n(i_rst_n),
    .i_rxf_n(i_rxf_n),
    .i_data_in(i_data_in),
    .o_rd_n(o_rd_n),
    .o_data_read(byte_cmd),
    .o_read_done(read_done)
);

endmodule