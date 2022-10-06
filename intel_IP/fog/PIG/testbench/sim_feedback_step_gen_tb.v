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
// Generated on "10/05/2022 12:56:16"
                                                                                
// Verilog Test Bench template for design : sim_feedback_step_gen
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 100 ps
module sim_feedback_step_gen_tb();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [31:0] i_amp_H;
reg [31:0] i_amp_L;
reg i_clk;
reg [31:0] i_const_step;
reg [31:0] i_err;
reg [31:0] i_fb_ON;
reg [31:0] i_freq_cnt;
reg [31:0] i_gain_sel;
reg i_rst_n;
// wires                                               
wire o_SM;
wire [31:0]  o_fb_ON;
wire [31:0]  o_gain_sel;
wire [31:0]  o_gain_sel2;
wire [31:0]  o_mod_out;
wire o_status;
wire [1:0] o_status_step;
wire [31:0]  o_step;
wire o_stepTrig;
wire [31:0] o_step_pre;
wire o_change;
wire [31:0] o_step_init; 

reg[31:0] cnt;

// assign statements (if any)                          
sim_feedback_step_gen i1 (
// port map - connection between master ports and signals/registers   
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_const_step(i_const_step),
	.i_err(i_err),
	.i_fb_ON(i_fb_ON),
	.i_freq_cnt(i_freq_cnt),
	.i_gain_sel(i_gain_sel),
	.i_rst_n(i_rst_n),
	.o_SM(o_SM),
	.o_fb_ON(o_fb_ON),
	.o_gain_sel(o_gain_sel),
	.o_gain_sel2(o_gain_sel2),
	.o_mod_out(o_mod_out),
	.o_status(o_status),
	.o_status_step(o_status_step),
	.o_step(o_step),
	.o_stepTrig(o_stepTrig),
	.o_step_pre(o_step_pre),
	.o_change(o_change),
	.o_step_init(o_step_init) 
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
      
i_clk = 1'b0;  
i_freq_cnt = 32'd100;
i_amp_H = 32'd3000;
i_amp_L = -32'd3000;
i_fb_ON = 32'd0; 
i_const_step = 32'd6000; 
i_err = 0; 
i_gain_sel = 0;  
i_rst_n = 1'b0;
cnt = 0;

#50 
i_rst_n = 1'b1; 
i_fb_ON = 1;
i_err = 10; 

repeat(1400) begin
	@(posedge o_stepTrig) begin
		cnt = cnt + 1;
		
		if(cnt > 200 && cnt < 400) begin
			#50;
			i_gain_sel = 2;
		end
		else if(cnt > 400 && cnt < 600) begin
			#50;
			i_gain_sel = 4;
		end
		else if (cnt > 600 && cnt < 800) begin
			#50;
			i_gain_sel = 0;
		end
		else if (cnt > 800 && cnt < 900) begin
			#50;
			i_fb_ON = 2;
		end
		else if (cnt > 900 && cnt < 1000) begin
			#50;
			i_const_step = 32'd6000; 
		end
		else if (cnt > 1000 && cnt < 1200) begin
			#50;
			i_fb_ON = 0;
		end
		else if (cnt > 1200 && cnt < 1400) begin
			#50;
			i_fb_ON = 1;
		end
		
	end
end 

		
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

