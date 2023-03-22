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
// Generated on "03/16/2023 16:16:56"
                                                                                
// Verilog Test Bench template for design : sim_phase_ramp_gen
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module sim_phase_ramp_gen_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [13:0] i_adc_data;
reg [31:0] i_amp_H;
reg [31:0] i_amp_L;
reg i_clk;
reg [31:0] i_err_offset;
reg [31:0] i_fb_ON;
reg [31:0] i_gain_sel;
reg i_polarity;
reg i_rst_n;
reg [31:0] i_step;
// wires                                               
wire o_change;
wire [31:0]  o_err;
wire [31:0]  o_mod_out;
wire [31:0]  o_phaseRamp;
wire [31:0]  o_phaseRamp_pre;
wire[31:0] o_gain_sel;
wire o_ramp_sync;
wire o_rate_sync;
wire o_status;
wire o_stepTrig;
wire o_step_sync;
wire o_step_sync_dly;

// assign statements (if any)                          
sim_phase_ramp_gen i1 (
// port map - connection between master ports and signals/registers   
	.i_adc_data(i_adc_data),
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_err_offset(i_err_offset),
	.i_fb_ON(i_fb_ON),
	.i_gain_sel(i_gain_sel),
	.i_polarity(i_polarity),
	.i_rst_n(i_rst_n),
	.i_step(i_step),
	.o_err(o_err),
	.o_mod_out(o_mod_out),
	.o_phaseRamp(o_phaseRamp),
	.o_phaseRamp_pre(o_phaseRamp_pre),
	.o_ramp_sync(o_ramp_sync),
	.o_rate_sync(o_rate_sync),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig),
	.o_step_sync(o_step_sync),
	.o_step_sync_dly(o_step_sync_dly)
);
initial                                                
begin                                                  

i_clk = 1'b0;  
i_rst_n = 1;
i_adc_data = 0;
i_amp_H = 32'd3000;
i_amp_L = -32'd3000;
i_err_offset = 10;
i_fb_ON = 1;
i_step = -100;
i_gain_sel = 0;
i_polarity = 0;

#50
i_rst_n = 0;
#50
i_rst_n = 1;

repeat(2000) begin
	@(posedge o_stepTrig) begin
	end
	
end


$display("Running testbench");                       
$stop;
end                                                    

always#5 i_clk = ~i_clk; 

endmodule

