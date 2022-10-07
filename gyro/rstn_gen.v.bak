module rstn_gen
#(parameter RST_CNT = 2500000) //50ms= 2500000
(
	input i_clk,
	output o_reset_n
);

reg [3:0] rst_sm;
reg rst_n;
reg [31:0] rst_cnt;

assign o_reset_n = rst_n;


initial begin 
    rst_n <= 1'b0;
    rst_cnt <= RST_CNT;
    rst_sm <= 4'd0;
end

always@(posedge i_clk) begin
    case(rst_sm)
        0: begin
            rst_sm <= 1;
            rst_n <= 1'b0;
        end
        1: begin
            if(rst_cnt != 0) begin
                rst_cnt <= rst_cnt - 1'b1;
            end
            else begin
                rst_n <= 1'b1;
            end
        end
    endcase
end


endmodule