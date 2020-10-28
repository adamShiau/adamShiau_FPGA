`timescale 1ns/1ns

module gyro_top_tb();

reg clk;
wire rst_n;
wire status;
wire err_done;
wire [31:0] o_int_1;
wire [31:0] o_int_2;
/***err***/ 
reg [31:0] err_offset;
reg [31:0] freq;
reg [2:0] avg_sel;
reg [31:0] wait_cnt;
reg polarity;

/***int_1***/
reg gain_mode_1;
reg [5:0] gain_sel_1;
reg zero_1;
reg [31:0] saturation_1;
wire [31:0] err;
/***int_2***/
reg gain_mode_2;
reg [5:0] gain_sel_2;
reg zero_2;
reg [31:0] saturation_2;
reg add_sig_en;
reg [31:0] vth;
reg vth_mode;

gyro_top u_gyro_top
(
.clk(clk),
.o_rst_n(rst_n),
.err_done(err_done),
.o_int_1(o_int_1),
.o_int_2(o_int_2),
.status(status),
.err_offset(err_offset),
.freq(freq),
.avg_sel(avg_sel),
.wait_cnt(wait_cnt),
.gain_mode_1(gain_mode_1),
.gain_sel_1(gain_sel_1),
.zero_1(zero_1),
.saturation_1(saturation_1),
.polarity(polarity),
.err(err),
.gain_mode_2(gain_mode_2),
.gain_sel_2(gain_sel_2),
.zero_2(zero_2),
.saturation_2(saturation_2),
.add_sig_en(add_sig_en),
.vth(vth),
.vth_mode(vth_mode)
);

initial begin
clk = 0;
err_offset = 32'd1;
freq = 32'd50;
avg_sel = 3'd2;
wait_cnt = 32'd10;
gain_mode_1 = 0;
gain_sel_1 = 6'd0;
zero_1 = 0;
saturation_1 = 32'd1000;
polarity = 0;
gain_mode_2 = 0;
gain_sel_2 = 6'd0;
zero_2 = 0;
saturation_2 = 32'd1_000_000;
add_sig_en = 0;
vth = 32'd8000;
vth_mode = 1;
#150_000;
$stop;

end

always #10 clk = ~clk;

endmodule