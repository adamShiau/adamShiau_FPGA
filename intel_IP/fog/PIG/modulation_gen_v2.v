/***
2022-10-05
***/

module modulation_gen_v2
#(parameter OUTPUT_BIT = 32)
(
    input i_clk,
    input i_rst_n,
    input [31:0] i_freq_cnt,
    input [OUTPUT_BIT-1:0] i_amp_H,
    input [OUTPUT_BIT-1:0] i_amp_L, 
    output reg signed [OUTPUT_BIT-1:0] o_mod_out,
    output reg o_status,
	 output reg o_stepTrig,
	/*** simulation***/
	output o_SM
);

localparam LOW = 1'b0;
localparam HIGH = 1'b1;

reg SM, r_status, r_status_2;
reg [31:0] r_freq_cnt;
reg signed [31:0] r_amp_H, r_amp_L;
wire change;

assign o_SM = SM;
assign change = r_status_2 ^ o_status; //generate two clock pulse at both rising edge and falling edge



always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		o_status <= LOW;
		o_stepTrig <= 1'b0;
		o_mod_out <= 0;
		SM <= LOW;
		r_freq_cnt <= 32'd100;
		r_amp_H <= 32'd0;
		r_amp_L <= 32'd0;
		// ramp_trig_cnt <= 32'd0;
    end
    else begin
		r_amp_H <= i_amp_H;
		r_amp_L <= i_amp_L;
		o_stepTrig <= change;
        case(SM)
            LOW: begin
                o_status <= LOW;
                o_mod_out <= r_amp_L;
                if(r_freq_cnt != 32'd0) r_freq_cnt <= r_freq_cnt - 1'b1;
                else begin
                    SM <= HIGH;
                    r_freq_cnt <= i_freq_cnt;
                end
            end
            
            HIGH: begin
                o_status <= HIGH;
                o_mod_out <= r_amp_H;
                if(r_freq_cnt != 32'd0) r_freq_cnt <= r_freq_cnt - 1'b1;
                else begin
                    SM <= LOW;
                    r_freq_cnt <= i_freq_cnt;
                end
            end
        endcase
		  r_status <= o_status;
		  r_status_2 <= r_status;
    end
end

endmodule