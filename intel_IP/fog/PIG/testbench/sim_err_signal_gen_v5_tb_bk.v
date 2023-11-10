// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "10/06/2022 20:32:24"
                                                                                
// Verilog Test Bench template for design : sim_err_signal_gen
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 100 ps
module sim_err_signal_gen_v5_tb();
// constants                                           
// general purpose registers
//reg eachvec;
// test vector input registers
reg [13:0] i_adc_data;
reg [31:0] i_amp_H;
reg [31:0] i_amp_L;
reg [31:0] i_avg_sel;
reg i_clk;
reg [31:0] i_err_offset;
reg [31:0] i_freq_cnt;
reg i_polarity;
reg i_rst_n;
// wires                                               
wire o_SM;
wire [31:0]  o_adc;
wire [31:0]  o_adc_sum;
wire o_pol_change;
wire [3:0]  o_cstate;
wire [31:0]  o_err;
wire [31:0]  o_mod_out;
wire [31:0]  o_adc_new;
wire [3:0]  o_nstate;
wire [31:0]  o_adc_old;
wire o_status;
wire o_step_sync;
wire o_rate_sync;
wire o_ramp_sync;
wire o_stepTrig;
wire o_flip_flag;
wire [31:0] o_stable_cnt;
reg[31:0] cnt;

// assign statements (if any)                          
sim_err_signal_gen_v5 i1 (
// port map - connection be;0tween master ports and signals/registers   
	.i_adc_data(o_mod_out[13:0]),
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	// .i_avg_sel(i_avg_sel),
	.i_clk(i_clk),
	.i_err_offset(i_err_offset),
	.i_freq_cnt(i_freq_cnt),
	.i_polarity(i_polarity),
	.i_rst_n(i_rst_n),
	.o_SM(o_SM),
	.o_adc(o_adc),
	.o_adc_sum(o_adc_sum),
	.o_pol_change(o_pol_change),
	.o_cstate(o_cstate),
	.o_err(o_err),
	.o_mod_out(o_mod_out),
	.o_adc_new(o_adc_new),
	.o_nstate(o_nstate),
	.o_adc_old(o_adc_old),
	.o_status(o_status),
	.o_flip_flag(o_flip_flag),
	.o_step_sync(o_step_sync),
	.o_rate_sync(o_rate_sync),
	.o_ramp_sync(o_ramp_sync),
	.o_stepTrig(o_stepTrig),
	.o_stable_cnt(o_stable_cnt)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
    

	 
i_clk = 1'b0;  
i_freq_cnt = 32'd100;
i_amp_H = 32'd50;
i_amp_L = -32'd10;
i_polarity = 1'b1;
i_err_offset = 32'd0;
i_avg_sel = 4;
i_adc_data = 14'b0;

i_rst_n = 1'b0;
cnt = 0;

#50 
i_rst_n = 1'b1; 

repeat(2000) begin
	@(posedge o_stepTrig) begin
		cnt = cnt + 1;
		
		// if(cnt > 200 && cnt < 400) begin
			// i_amp_H = 32'd60;
			// i_amp_L = -32'd20;
		// end
		// else if(cnt > 400 && cnt < 1200) begin
			// i_amp_H = 32'd70;
			// i_amp_L = -32'd20;
		// endooo
		// else if (cnt > 1200 && cnt < 1300) begin
			// i_amp_H = 32'd60;
			// i_amp_L = -32'd30;
		// end
		// else if (cnt > 1300 && cnt < 2000) begin
			// i_amp_H = 32'd90;
			// i_amp_L = -32'd20;

		// end
		
	end
end
	
		
// --> end                                             
$display("Running testbench");   
$stop;                    
end                                                    

always#5 i_clk = ~i_clk; 
                                                   
endmodule

