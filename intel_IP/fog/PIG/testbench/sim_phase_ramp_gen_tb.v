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
// Generated on "10/06/2022 09:33:14"
                                                                                
// Verilog Test Bench template for design : sim_phase_ramp_gen
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 100 ps
module sim_phase_ramp_gen_tb();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [31:0] i_amp_H;
reg [31:0] i_amp_L;
reg i_clk;
reg [31:0] i_fb_ON;
reg [31:0] i_freq_cnt;
reg [31:0] i_gain_sel;
reg [31:0] i_mod;
reg i_rst_n;
reg [31:0] i_step;
// wires                                               
wire o_SM;
wire o_change;
wire [31:0]  o_gain_sel;
wire [31:0]  o_gain_sel2;
wire [31:0]  o_mod_out;
wire [31:0]  o_phaseRamp;
wire [31:0]  o_phaseRamp_pre;
wire [31:0]  o_ramp_init;
wire o_status;
wire o_stepTrig;

wire signed [15:0] DACP, DACN;
wire signed [16:0] DAC_diff;

reg[31:0] cnt;

assign DACP = o_phaseRamp[15:0] + o_mod_out[15:0];
assign DACN = ~(o_phaseRamp[15:0] + o_mod_out[15:0]);
assign DAC_diff = DACP - DACN;

// assign statements (if any)                          
sim_phase_ramp_gen i1 (
// port map - connection between master ports and signals/registers   
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_fb_ON(i_fb_ON),
	.i_freq_cnt(i_freq_cnt),
	.i_gain_sel(i_gain_sel),
	.i_mod(i_mod),
	.i_rst_n(i_rst_n),
	.i_step(i_step),
	.o_SM(o_SM),
	.o_change(o_change),
	.o_gain_sel(o_gain_sel),
	.o_gain_sel2(o_gain_sel2),
	.o_mod_out(o_mod_out),
	.o_phaseRamp(o_phaseRamp),
	.o_phaseRamp_pre(o_phaseRamp_pre),
	.o_ramp_init(o_ramp_init),
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
i_fb_ON = 32'd0; 
i_mod = 32'd0; 
i_step = 32'd1000; 
i_gain_sel = 0;  
i_rst_n = 1'b0;
cnt = 0;

#50 
i_rst_n = 1'b1; 
i_fb_ON = 1;

repeat(2000) begin
	@(posedge o_stepTrig) begin
		cnt = cnt + 1;
		
		if(cnt > 200 && cnt < 400) begin
			#50;
			i_gain_sel = 2;
		end
		else if(cnt > 400 && cnt < 1200) begin
			#50;
			i_gain_sel = 4;
		end
		else if (cnt > 1200 && cnt < 1300) begin
			#50;
			i_fb_ON = 0;
			i_gain_sel = 0;
		end
		else if (cnt > 1300 && cnt < 2000) begin
			#50;
			i_gain_sel = 3;
			i_step = -32'd1000; 
//			i_fb_on = 2;
		end
//		else if (cnt > 900 && cnt < 1000) begin
//			#50;
//			i_const_step = 32'd8000; 
//		end
//		else if (cnt > 1000 && cnt < 1200) begin
//			#50;
//			i_fb_on = 0;
//		end
//		else if (cnt > 1200 && cnt < 1400) begin
//			#50;
//			i_fb_on = 1;
//		end
		
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

