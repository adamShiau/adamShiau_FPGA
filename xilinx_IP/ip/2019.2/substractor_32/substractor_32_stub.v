// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Jul 25 15:57:40 2021
// Host        : LAPTOP-O3DIP64G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/adam/Documents/GitHub/adamShiau_FPGA/xilinx_IP/ip/2019.2/substractor_32/substractor_32_stub.v
// Design      : substractor_32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_addsub_v12_0_14,Vivado 2019.2" *)
module substractor_32(A, B, CLK, SCLR, S)
/* synthesis syn_black_box black_box_pad_pin="A[31:0],B[31:0],CLK,SCLR,S[31:0]" */;
  input [31:0]A;
  input [31:0]B;
  input CLK;
  input SCLR;
  output [31:0]S;
endmodule
