// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Jul 25 16:24:30 2021
// Host        : LAPTOP-O3DIP64G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/Users/adam/Documents/GitHub/adamShiau_FPGA/xilinx_IP/ip/2019.2/multiplier_32/multiplier_32_stub.v
// Design      : multiplier_32
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *)
module multiplier_32(CLK, A, B, SCLR, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[31:0],B[31:0],SCLR,P[63:0]" */;
  input CLK;
  input [31:0]A;
  input [31:0]B;
  input SCLR;
  output [63:0]P;
endmodule
