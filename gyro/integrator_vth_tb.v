`timescale 1ns/1ns

module integrator_vth_tb();

reg i_clk;
reg i_rst_n;
reg i_gain_mode;
reg [5:0] i_gain_sel;
wire [4:0] o_shift_idx;
wire o_change;
reg [31:0] i_err;
reg i_en;
reg i_zero;
reg i_add_sig_en;
reg [31:0] i_ext_sig;

reg [31:0] i_saturation;
wire [31:0] o_sat_p;
wire [31:0] o_sat_n;

reg [31:0] i_vth;
reg [31:0] i_vth_cut;

wire [31:0] o_vth_cut_p;
wire [31:0] o_vth_cut_n;

wire [3:0] o_nstate;
wire [3:0] o_cstate;
wire [31:0] o_dv;
wire [31:0] o_vo;
wire [31:0] o_int;

wire o_vth_flag_p;
wire o_vth_flag_n;
wire o_sat_flag_p;
wire o_sat_flag_n;
wire o_err_pol;
wire o_err_pol_change;
wire o_zero_flag;




`define period 20


integrator_vth u0
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_gain_mode(i_gain_mode),
.i_gain_sel(i_gain_sel),
.i_err(i_err),
.i_en(i_en),
.i_zero(i_zero),
.i_saturation(i_saturation),
.i_add_sig_en(i_add_sig_en),
.i_ext_sig(i_ext_sig),
.i_vth(i_vth),
.i_vth_cut(i_vth_cut),

.o_int(o_int)

/*** for simulation ***/
, .o_sat_p(o_sat_p)
, .o_sat_n(o_sat_n)
, .o_cstate(o_cstate)
, .o_nstate(o_nstate)
, .o_dv(o_dv)
, .o_vo(o_vo)
, .o_change(o_change)
, .o_shift_idx(o_shift_idx)
, .o_sat_flag_p(o_sat_flag_p)
, .o_sat_flag_n(o_sat_flag_n)
, .o_err_pol(o_err_pol)
, .o_err_pol_change(o_err_pol_change)
, .o_zero_flag(o_zero_flag)
, .o_vth_cut_p(o_vth_cut_p)
, .o_vth_cut_n(o_vth_cut_n)
, .o_vth_flag_p(o_vth_flag_p)
, .o_vth_flag_n(o_vth_flag_n)
);

initial begin
i_clk = 0;
i_rst_n = 0;
i_en = 1;
i_zero = 0;
i_gain_mode = 0;
i_saturation = 32'd1_000_000;
i_vth = 32'd1000;
i_vth_cut = 32'd1000;
i_gain_sel = 0; 
i_add_sig_en = 0;
i_err = -32'd30;
#50;
i_rst_n = 1;
repeat(20) #`period;

// repeat(500) #`period;

i_gain_sel = 1;
repeat(100) #`period;

i_gain_sel = 2;
repeat(100) #`period;

i_gain_sel = 0;
repeat(100) #`period;


/***err inverse ***/
i_err = 32'd30;
repeat(100) #`period;

i_gain_sel = 1;
repeat(100) #`period;
i_en = 0;
repeat(20) #`period;
i_en = 1;
repeat(20) #`period;

i_gain_sel = 2;
repeat(100) #`period;

i_gain_sel = 0;
repeat(100) #`period;

i_zero = 0;
repeat(20) #`period;
i_zero = 0;
repeat(20) #`period;



$stop;
end



always #10 i_clk = ~i_clk;

endmodule