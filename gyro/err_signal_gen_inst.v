err_signal_gen u2
(
.i_clk(),
.i_rst_n(),
.i_adc_data(),			//[13:0]
/*** modulation H/L status for input signal acquisition***/
.i_status(),
/*** err = H-L if polarity = 1, otherwise L-H ***/
.i_polarity(),
/*** latch input data after wait cnt ***/
.i_wait_cnt(), 			//[31:0]
.i_err_offset_H(),		//[31:0]
/*** 0~6 for avg times 1~64 ***/
.i_avg_sel(), 			//[2:0]
/*** error signal vth ***/
.i_err_th(), 			//[31:0]
.o_errsignal(), 		//[31:0]
.o_errsignal_w_th(), 	//[31:0]
/*** error signal ready flag ***/
.o_err_done(),

/*** for simulation ***/
.o_mv_cnt(), 			//[31:0]
.o_adc_reg_H(), 		//[31:0]
.o_adc_reg_L(), 		//[31:0]
.o_adc_H_sum(), 		//[31:0]
.o_adc_L_sum() 			//[31:0]
);