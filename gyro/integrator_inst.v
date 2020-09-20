integrator 
#(.EXT_SIG_BIT(16))
u0
(
.i_clk(),
.i_rst_n(),
/*** 0~15 for gain decrease by 2^0 ~ 2^-15 ***/
.i_gain_sel(), 	// [5:0] 
.i_err(),		//[31:0]
.i_en(),
.i_zero(),
.i_add_sig_en(),
.i_gain_mode(),
.i_ext_sig(),	//[EXT_SIG_BIT-1:0]
.i_saturation(),//[31:0]
.o_int()		//[31:0]

/*** for simulation ***/
, .o_sat_p() 	//[31:0]
, .o_sat_n() 	//[31:0]
, .o_cstate() 	//[3:0]
, .o_nstate() 	//[3:0]
, .o_dv() 		//[31:0]
, .o_vo() 		//[31:0]
, .o_change() 
, .o_shift_idx() //[4:0]
, .o_sat_flag_p()
, .o_sat_flag_n()
, .o_limit_flag_p()
, .o_limit_flag_n()
, .o_err_pol_change()
, .o_zero_flag()
);