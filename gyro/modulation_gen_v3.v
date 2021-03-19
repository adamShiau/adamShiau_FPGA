module modulation_gen_v3
#(parameter OUTPUT_BIT = 14)
(
    input i_clk,
    input i_rst_n,
    input [31:0] i_freq_cnt,
    input [OUTPUT_BIT-1:0] i_amp_H,
    input [OUTPUT_BIT-1:0] i_amp_L, 
	input [31:0] i_trig_delay,
    output reg signed [OUTPUT_BIT-1:0] o_mod_out,
    output reg o_status,
	output reg o_stepTrig,
	output o_SM
);

localparam LOW = 0;
localparam HIGH = 1;
localparam TRIGHOLD = 32'd1;

assign o_SM = SM;

reg SM = LOW;
reg [31:0] freq_cnt = 32'd5000000;
reg [31:0] trig_delay = 0;

wire signed [OUTPUT_BIT-1:0] amp_H = $signed(i_amp_H);
wire signed [OUTPUT_BIT-1:0] amp_L = $signed(i_amp_L);

always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) trig_delay <= 32'd0;
	else trig_delay <= i_trig_delay;
end

always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
        o_status <= LOW;
		o_stepTrig <= 1'b0;
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
				// if(freq_cnt != (i_freq_cnt - TRIGHOLD)) o_stepTrig <= 1'b0;
				// else o_stepTrig <= 1'b1;
				if(freq_cnt == (i_freq_cnt - trig_delay)) o_stepTrig <= 1'b1;
				else o_stepTrig <= 1'b0;
            end
            
            HIGH: begin
                o_status <= HIGH;
                o_mod_out <= amp_H;
                if(freq_cnt != 32'd1) freq_cnt <= freq_cnt - 1'b1;
                else begin
                    SM <= LOW;
                    freq_cnt <= i_freq_cnt;
                end
				if(freq_cnt == (i_freq_cnt - trig_delay)) o_stepTrig <= 1'b1;
				else o_stepTrig <= 1'b0;
            end
        
        endcase
    end
end

endmodule