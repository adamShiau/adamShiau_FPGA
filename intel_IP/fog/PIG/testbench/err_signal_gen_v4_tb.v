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
// Generated on "11/11/2023 01:26:19"
                                                                                
// Verilog Test Bench template for design : err_signal_gen_v4
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module err_signal_gen_v4_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [13:0] i_adc_data;
reg [31:0] i_avg_sel;
reg i_clk;
reg [31:0] i_err_offset;
reg i_polarity;
reg i_rst_n;
reg i_status;
reg i_trig;
reg [31:0] i_wait_cnt;
// wires                                               
wire [31:0]  o_adc;
wire [31:0]  o_adc_sum;
wire [3:0]  o_cstate;
wire [31:0]  o_err;
wire [3:0]  o_nstate;
wire o_ramp_sync;
wire o_rate_sync;
wire [31:0]  o_stable_cnt;
wire o_step_sync;
wire o_step_sync_dly;

// assign statements (if any)                          
err_signal_gen_v4 i1 (
// port map - connection between master ports and signals/registers   
	.i_adc_data(i_adc_data),
	.i_avg_sel(i_avg_sel),
	.i_clk(i_clk),
	.i_err_offset(i_err_offset),
	.i_polarity(i_polarity),
	.i_rst_n(i_rst_n),
	.i_status(i_status),
	.i_trig(i_trig),
	.i_wait_cnt(i_wait_cnt),
	.o_adc(o_adc),
	.o_adc_sum(o_adc_sum),
	.o_cstate(o_cstate),
	.o_err(o_err),
	.o_nstate(o_nstate),
	.o_ramp_sync(o_ramp_sync),
	.o_rate_sync(o_rate_sync),
	.o_stable_cnt(o_stable_cnt),
	.o_step_sync(o_step_sync),
	.o_step_sync_dly(o_step_sync_dly)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
                                                       
// --> end                                             
$display("Running testbench");                       
end                                                    
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
                                                       
@eachvec;                                              
// --> end                                             
end                                                    
endmodule

