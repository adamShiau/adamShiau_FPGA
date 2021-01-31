`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/01/21 12:53:19
// Design Name: 
// Module Name: openLoop_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module closeLoop_top(
/*** DAC***/
    DAC_CLK,
    DAC_PD,
    DAC_DATA,
/*** ADC***/
    ADC_CLK,
    ADC_SHDN,
    ADC_OE_N, 
    ADC_DATA,
    diff_clock_rtl_0_clk_n,
    diff_clock_rtl_0_clk_p,
    uart_rxd,
    uart_txd
    );

/*** DAC***/
output [15:0]DAC_DATA;
output DAC_CLK;
output [0:0]DAC_PD;
/*** ADC***/
output ADC_CLK;
output ADC_SHDN;
output ADC_OE_N; 
input [13:0] ADC_DATA;
/*** diff clk input ***/
input diff_clock_rtl_0_clk_n;
input diff_clock_rtl_0_clk_p;
input uart_rxd;
output uart_txd;

localparam LOW = 0;
localparam HIGH = 1;
localparam COUNTER_100u = 10000;

wire rst_n;
/*** timer***/
reg [31:0] timer, timer_cnt; 
wire timer_rst;

/*** mod ***/
wire [15:0] mod_out;
wire mod_status;
reg [31:0] freq_cnt;
wire signed [31:0] mod_freq;
wire [31:0] mod_H, mod_L;
wire stepTrig;

/*** err ***/
wire [31:0] o_err;
wire o_err_done;
wire [31:0] err_offset_H;
wire [31:0] adc_reg_H, adc_reg_L;
wire polarity;
wire [31:0] wait_cnt;
wire [2:0] err_avg_sel;
wire [31:0] err_th;

/*** feedback_step_gen ***/
wire [3:0] gain_sel;
wire [31:0] i_step_max;
wire fb_on;
wire [31:0] step;

//phase_ramp_gen
wire [31:0] v2pi;
wire [15:0] ladderWave;
wire [15:0] square_mod;
wire [15:0] phaseRamp;

/*** input reg***/
reg signed [31:0] i_var0, i_var1, i_var2, i_var3, i_var4, i_var5, i_var6, i_var7, i_var8, i_var9,
i_var10, i_var11, i_var12, i_var13, i_var14, i_var15, i_var16, i_var17, i_var18, i_var19,
i_var20, i_var21, i_var22, i_var23, i_var24;

/*** output reg***/      
wire signed [31:0] o_var0, o_var1, o_var2, o_var3, o_var4, o_var5, o_var6, o_var7, o_var8, o_var9,
o_var10, o_var11, o_var12, o_var13, o_var14, o_var15, o_var16, o_var17, o_var18, o_var19,
o_var20, o_var21, o_var22, o_var23, o_var24;

reg SM;
reg [31:0] test = 32'd100;
reg [31:0] freq_reg0 = 32'd100; //1us

reg signed [13:0] ADC;


assign DAC_DATA = phaseRamp; 

assign ADC_CLK = DAC_CLK; 
assign ADC_SHDN = 1'b0;
assign ADC_OE_N = 1'b0;

always@(posedge DAC_CLK) begin
    ADC <= ADC_DATA;
end


/*** timer ***/
always@(posedge DAC_CLK or negedge rst_n) begin
    if(~rst_n) begin
        timer_cnt <= COUNTER_100u;
        timer <= 32'd0;
    end
    else begin
        if(timer_rst) begin
            timer_cnt <= COUNTER_100u;
            timer <= 32'd0;
        end
        else begin
            if(timer_cnt != 32'd1) timer_cnt <= timer_cnt - 1'b1;
            else begin
                timer_cnt <= COUNTER_100u;
                timer <= timer + 1'b1;
            end
        end
    end
end

/*** modulation ***/
modulation_gen_v2 
#(.OUTPUT_BIT(16))
u_mod
(
.i_clk(DAC_CLK),
.i_rst_n(rst_n),
.i_freq_cnt(mod_freq),
.i_amp_H(mod_H),
.i_amp_L(mod_L), 
.o_mod_out(mod_out),
.o_status(mod_status),
.o_stepTrig(stepTrig)
);

// /*** err signal***/
err_signal_gen uerr
(
.i_clk(DAC_CLK),
.i_rst_n(rst_n),
.i_adc_data(ADC),			//[13:0]
/*** modulation H/L status for input signal acquisition***/
.i_status(mod_status),
/*** err = H-L if polarity = 1, otherwise L-H ***/
.i_polarity(polarity),
/*** latch input data after wait cnt ***/
.i_wait_cnt(wait_cnt), 			//[31:0]
.i_err_offset_H(err_offset_H),		//[31:0]
/*** 0~6 for avg times 1~64 ***/
.i_avg_sel(err_avg_sel), 			//[2:0]
/*** error signal vth ***/
.i_err_th(err_th), 			//[31:0]
.o_errsignal(), 		//[31:0]
.o_errsignal_w_th(o_err), 	//[31:0]
/*** error signal ready flag ***/
.o_err_done(o_err_done),

/*** for simulation ***/
.o_mv_cnt(), 			//[31:0]
.o_adc_reg_H(adc_reg_H), 		//[31:0]
.o_adc_reg_L(adc_reg_L), 		//[31:0]
.o_adc_H_sum(), 		//[31:0]
.o_adc_L_sum() 			//[31:0]
);

feedback_step_gen_v4 u_fb
(
.i_clk(DAC_CLK),
.i_rst_n(rst_n),
.i_trig(stepTrig),
.i_err(o_err), //[31:0] i_err
.i_gain_sel(gain_sel),  //[3:0] i_gain_sel
.i_step_max(i_step_max), //[31:0] i_step_max,
.o_fb_ON(fb_on),
.o_step(step), //[31:0] o_step
.o_shift_idx(),
.o_step_max(),
.o_step_min()
);

phase_ramp_gen 
#(.OUTPUT_BIT(16))
u1(
.i_clk(DAC_CLK),
.i_rst_n(rst_n),
.i_trig(stepTrig),
.i_step(step), //[31:0] i_step
.i_v2pi(v2pi), //[31:0] i_v2pi,
.i_fb_on(fb_on),
.i_mod(mod_out), //[OUTPUT_BIT-1:0] i_mod
.o_ladderWave(ladderWave), //[OUTPUT_BIT-1:0] o_ladderWave
.o_phaseRamp(phaseRamp) //[OUTPUT_BIT-1:0] o_phaseRamp
);

sys sys_i
(.DAC_CLK(DAC_CLK),
.DAC_PD(DAC_PD),
.diff_clock_rtl_0_clk_n(diff_clock_rtl_0_clk_n),
.diff_clock_rtl_0_clk_p(diff_clock_rtl_0_clk_p),
.locked(),
.reset_rtl_0(1'b1),
.VIO_IN(mod_H),
.o_var0_0(mod_freq),
.o_var1_0(mod_H),
.o_var2_0(mod_L),
.o_var3_0(err_offset_H),
.o_var4_0(polarity),
.o_var5_0(wait_cnt),
.o_var6_0(err_th),
.o_var7_0(err_avg_sel),
.o_var8_0(timer_rst),
.o_var9_0(gain_sel),
.o_var10_0(i_step_max),
.o_var11_0(v2pi),
.o_var12_0(rst_n),
.o_var13_0(o_var13),
.o_var14_0(o_var14),
.o_var15_0(o_var15),
.o_var16_0(o_var16),
.o_var17_0(o_var17),
.o_var18_0(o_var18),
.o_var19_0(o_var19),        
.o_var20_0(o_var20),
.o_var21_0(o_var21),
.o_var22_0(o_var22),
.o_var23_0(o_var23),
.o_var24_0(o_var24),
.i_var0_0(o_err),
.i_var1_0(adc_reg_H),
.i_var2_0(adc_reg_L),
.i_var3_0(timer),
.i_var4_0(step),
.i_var5_0(i_var5),
.i_var6_0(i_var6),
.i_var7_0(i_var7),
.i_var8_0(i_var8),
.i_var9_0(i_var9),
.i_var10_0(i_var10),
.i_var11_0(i_var11),
.i_var12_0(i_var12),
.i_var13_0(i_var13),
.i_var14_0(i_var14),
.i_var15_0(i_var15),
.i_var16_0(i_var16),
.i_var17_0(i_var17),
.i_var18_0(i_var18),
.i_var19_0(i_var19),
.i_var20_0(i_var20),
.i_var21_0(i_var21),
.i_var22_0(i_var22),
.i_var23_0(i_var23),
.i_var24_0(i_var24),  
.uart_rtl_0_rxd(uart_rxd),
.uart_rtl_0_txd(uart_txd));

endmodule
