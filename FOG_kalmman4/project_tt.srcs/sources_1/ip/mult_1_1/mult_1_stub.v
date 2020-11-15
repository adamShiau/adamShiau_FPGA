// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Thu Feb 14 17:14:53 2019
// Host        : DESKTOP-L7VH7BR running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/adam/Desktop/FOG/project_tt.srcs/sources_1/ip/mult_1_1/mult_1_stub.v
// Design      : mult_1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_12,Vivado 2017.2" *)
module mult_1(CLK, A, B, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[13:0],B[2:0],P[16:0]" */;
  input CLK;
  input [13:0]A;
  input [2:0]B;
  output [16:0]P;
endmodule
