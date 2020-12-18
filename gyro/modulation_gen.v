module modulation_gen
#(parameter OUTPUT_BIT = 14)
(
    input i_clk,
    input i_rst_n,
    input [31:0] i_freq_cnt,
    input [OUTPUT_BIT-1:0] i_amp_H,
    input [OUTPUT_BIT-1:0] i_amp_L, 
    output reg signed [OUTPUT_BIT-1:0] o_mod_out,
    output reg o_status,
	output o_SM
);

localparam LOW = 0;
localparam HIGH = 1;

assign o_SM = SM;

reg SM = LOW;
reg [31:0] freq_cnt = 32'd5000000;

wire signed [OUTPUT_BIT-1:0] amp_H = $signed(i_amp_H);
wire signed [OUTPUT_BIT-1:0] amp_L = $signed(i_amp_L);

always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
        o_status <= LOW;
        o_mod_out <= 0;
        SM <= LOW;
        freq_cnt <= 32'd125;
    end
    else begin
        case(SM)
            LOW: begin
                o_status <= LOW;
                o_mod_out <= amp_L;
                if(freq_cnt != 32'd0) freq_cnt <= freq_cnt - 1'b1;
                else begin
                    SM <= HIGH;
                    freq_cnt <= i_freq_cnt;
                end
            end
            
            HIGH: begin
                o_status <= HIGH;
                o_mod_out <= amp_H;
                if(freq_cnt != 32'd1) freq_cnt <= freq_cnt - 1'b1;
                else begin
                    SM <= LOW;
                    freq_cnt <= i_freq_cnt;
                end
            end
        
        endcase
    end
end

endmodule