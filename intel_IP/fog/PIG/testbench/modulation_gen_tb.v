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
// Generated on "10/05/2022 10:37:56"
                                                                                
// Verilog Test Bench template for design : modulation_gen
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1ns / 100ps
module modulation_gen_tb();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [31:0] i_amp_H;
reg [31:0] i_amp_L;
reg i_clk;
reg [31:0] i_freq_cnt;
reg i_rst_n;
// wires                                               
wire o_SM;
wire [31:0]  o_mod_out;
wire o_status;
wire o_stepTrig;

// assign statements (if any)                          
modulation_gen i1 (
// port map - connection between master ports and signals/registers   
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_freq_cnt(i_freq_cnt),
	.i_rst_n(i_rst_n),
	.o_SM(o_SM),
	.o_mod_out(o_mod_out),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
      
i_clk = 1'b0;
i_freq_cnt = 32'd100;
i_amp_H = 32'd3000;
i_amp_L = -32'd3000;
i_rst_n = 1'b0;
#50
i_rst_n = 1'b1;
#50000	
// --> end                                             
$display("Running testbench");  
$stop;                     
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

always#5 i_clk = ~i_clk;
                                              
endmodule

