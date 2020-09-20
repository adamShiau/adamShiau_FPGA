integrator_vth u1
(
.i_clk(),
.i_rst_n(),
/*** 0~15 for gain decrease by 2^0 ~ 2^-15 ***/
.i_gain_sel(), 	// [5:0] 
.i_err(), 		//[31:0]
.i_en(),
.i_zero(),
.i_add_sig_en(),
.i_gain_mode(),
.i_ext_sig(), 	//[EXT_SIG_BIT-1:0]
.i_saturation(),//[31:0]
.i_vth(), 		//[31:0]
/*** 1: vth cut = 2* vth 
     0: vth cut = vth   ***/
.i_vth_cut_mode(), 	
.o_int()		//[31:0]

/*** for simulation ***/
, .o_sat_p()		//[31:0]
, .o_sat_n()		//[31:0]
, .o_cstate()		//[3:0]
, .o_nstate()		//[3:0]
, .o_dv()			//[31:0]
, .o_vo()			//[31:0]
, .o_change() 
, .o_shift_idx()	//[4:0]
, .o_sat_flag_p()
, .o_sat_flag_n()
, .o_err_pol_change()
, .o_zero_flag()
, .o_vth_flag_p()
, .o_vth_flag_n()
, .o_vth_cut_p()	//[31:0]
, .o_vth_cut_n()	//[31:0]
);