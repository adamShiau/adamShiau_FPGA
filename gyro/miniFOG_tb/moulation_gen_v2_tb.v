`timescale 1ns / 100ps

module modulation_gen_v2_tb();

reg clk;
reg rst_n;
reg [31:0] freq_cnt;
reg [15:0] amp;
wire [15:0] mod_out;
wire status;
wire stepTrig;
wire SM;

modulation_gen_v2 
#(.OUTPUT_BIT(16))
umod
(
.i_clk(clk),
.i_rst_n(rst_n),
.i_freq_cnt(freq_cnt), //[31:0] i_freq_cnt
.i_amp_H(amp), //[OUTPUT_BIT-1:0] i_amp_H
.i_amp_L(-amp), //[OUTPUT_BIT-1:0] i_amp_L
.o_mod_out(mod_out), //[OUTPUT_BIT-1:0] o_mod_out
.o_status(status),
.o_stepTrig(stepTrig),
.o_SM(SM)
);

initial begin
clk = 0;
rst_n = 0;
freq_cnt = 32'd100;
amp = 16'd16383;
#50;
rst_n = 1;
repeat(6) begin
	@(posedge stepTrig);
end
$stop;
end

always#5 clk = ~clk;

endmodule