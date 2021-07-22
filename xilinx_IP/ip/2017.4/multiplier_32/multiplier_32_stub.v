// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed Jul 21 14:24:28 2021
// Host        : LAPTOP-MO0UL85T running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/ami73/Desktop/gyro_FPGA/miniFOG_closeLoop_v3/miniFOG_openLoop.srcs/sources_1/ip/multiplier_32/multiplier_32_stub.v
// Design      : multiplier_32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a50tcsg325-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_13,Vivado 2017.4" *)
module multiplier_32(CLK, A, B, SCLR, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[31:0],B[31:0],SCLR,P[63:0]" */;
  input CLK;
  input [31:0]A;
  input [31:0]B;
  input SCLR;
  output [63:0]P;
endmodule
