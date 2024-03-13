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
// Generated on "03/13/2024 10:31:08"
                                                                                
// Verilog Test Bench template for design : mySMA_TOP
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ps/ 1 ps
module mySMA_TOP_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg i_clk;
reg [31:0] i_data;
reg i_rst_n;
reg i_update_strobe;
reg [31:0] i_window_sel;
// wires                                               
wire [31:0]  o_data;

// assign statements (if any)                          
mySMA_TOP i1 (
// port map - connection between master ports and signals/registers   
	.i_clk(i_clk),
	.i_data(i_data),
	.i_rst_n(i_rst_n),
	.i_update_strobe(i_update_strobe),
	.i_window_sel(i_window_sel),
	.o_data(o_data)
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

