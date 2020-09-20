`timescale 1ns/1ns

`define period 8

module modulation_tb();

reg i_clk;
reg i_rst_n;
reg [31:0] i_freq_cnt;
reg [15:0] i_amp_H;
reg [15:0] i_amp_L; 
wire [15:0] o_mod_out;
wire o_status;

modulation_gen u
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
/*** modulation half period clk cnt ***/
.i_freq_cnt(i_freq_cnt), 	//[31:0] 
.i_amp_H(i_amp_H), 	//[15:0] 
.i_amp_L(i_amp_L), 	//[15:0] 
.o_mod_out(o_mod_out), 	//[15:0] 
/*** modulation H/L status***/
.o_status(o_status)
);

initial begin
i_clk = 0;
i_rst_n = 0;
i_freq_cnt = 32'd125;
i_amp_H = 16'd16384;
i_amp_L = $signed(-16'd32768);
#50;
i_rst_n = 1;

repeat(2500) #`period;

$stop;
end


always #4 i_clk = ~i_clk;

endmodule