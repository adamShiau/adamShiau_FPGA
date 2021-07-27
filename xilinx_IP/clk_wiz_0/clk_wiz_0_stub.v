// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Apr 25 16:39:37 2021
// Host        : LAPTOP-O3DIP64G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top clk_wiz_0 -prefix
//               clk_wiz_0_ clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(clk_100m, clk_100m_180, clk_50m, clk_25m, resetn, 
  locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_100m,clk_100m_180,clk_50m,clk_25m,resetn,locked,clk_in1" */;
  output clk_100m;
  output clk_100m_180;
  output clk_50m;
  output clk_25m;
  input resetn;
  output locked;
  input clk_in1;
endmodule
