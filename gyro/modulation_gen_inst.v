modulation_gen u
(
.i_clk(),
.i_rst_n(),
/*** modulation half period clk cnt ***/
.i_freq_cnt(), 	//[31:0] 
.i_amp_H(), 	//[15:0] 
.i_amp_L(), 	//[15:0] 
.o_mod_out(), 	//[15:0] 
/*** modulation H/L status***/
.o_status()
);