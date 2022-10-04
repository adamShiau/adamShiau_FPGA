/***
V4 remove i_trig_delay,
add ramp_trig
***/

module modulation_gen_v4
#(parameter OUTPUT_BIT = 16)
(
    input i_clk,
    input i_rst_n,
    input [31:0] i_freq_cnt,
    input [OUTPUT_BIT-1:0] i_amp_H,
    input [OUTPUT_BIT-1:0] i_amp_L, 
	input [31:0] i_ramp_trig_cnt,
    output reg signed [OUTPUT_BIT-1:0] o_mod_out,
    output reg o_status,
	output reg o_stepTrig,
	/*** simulation***/
	output o_SM
	, output [31:0] sim_ramp_trig_cnt
);

localparam LOW = 0;
localparam HIGH = 1;
localparam TRIGHOLD = 32'd1;

reg SM = LOW;
reg [31:0] freq_cnt = 32'd5000000;
reg [31:0] ramp_trig_cnt = 0;

assign o_SM = SM;
assign sim_ramp_trig_cnt = ramp_trig_cnt;
wire signed [OUTPUT_BIT-1:0] amp_H = $signed(i_amp_H);
wire signed [OUTPUT_BIT-1:0] amp_L = $signed(i_amp_L);


always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
        o_status <= LOW;
		o_stepTrig <= 1'b0;
        o_mod_out <= 0;
        SM <= LOW;
        freq_cnt <= 32'd125;
		ramp_trig_cnt <= 32'd0;
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
				if(freq_cnt == i_freq_cnt) begin
					if(ramp_trig_cnt == 32'd0) begin
						o_stepTrig <= 1'b1;
						ramp_trig_cnt <= i_ramp_trig_cnt;
					end
					else ramp_trig_cnt <= ramp_trig_cnt - 1'b1;
				end
				else o_stepTrig <= 1'b0;
            end
            
            HIGH: begin
                o_status <= HIGH;
                o_mod_out <= amp_H;
                if(freq_cnt != 32'd0) freq_cnt <= freq_cnt - 1'b1;
                else begin
                    SM <= LOW;
                    freq_cnt <= i_freq_cnt;
                end
				if(freq_cnt == i_freq_cnt) begin
					if(ramp_trig_cnt == 32'd0) begin
						o_stepTrig <= 1'b1;
						ramp_trig_cnt <= i_ramp_trig_cnt;
					end
					else ramp_trig_cnt <= ramp_trig_cnt - 1'b1;
				end
				else o_stepTrig <= 1'b0;
            end
        
        endcase
    end
end

endmodule