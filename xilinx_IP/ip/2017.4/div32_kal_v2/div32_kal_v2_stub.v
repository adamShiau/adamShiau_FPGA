// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Thu Jul 29 15:16:30 2021
// Host        : LAPTOP-MO0UL85T running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/github/adamShiau_FPGA/xilinx_IP/ip/2017.4/div32_kal_v2/div32_kal_v2_stub.v
// Design      : div32_kal_v2
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a50tcsg325-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "div_gen_v5_1_12,Vivado 2017.4" *)
module div32_kal_v2(aclk, aclken, aresetn, s_axis_divisor_tvalid, 
  s_axis_divisor_tdata, s_axis_dividend_tvalid, s_axis_dividend_tdata, 
  m_axis_dout_tvalid, m_axis_dout_tdata)
/* synthesis syn_black_box black_box_pad_pin="aclk,aclken,aresetn,s_axis_divisor_tvalid,s_axis_divisor_tdata[31:0],s_axis_dividend_tvalid,s_axis_dividend_tdata[31:0],m_axis_dout_tvalid,m_axis_dout_tdata[63:0]" */;
  input aclk;
  input aclken;
  input aresetn;
  input s_axis_divisor_tvalid;
  input [31:0]s_axis_divisor_tdata;
  input s_axis_dividend_tvalid;
  input [31:0]s_axis_dividend_tdata;
  output m_axis_dout_tvalid;
  output [63:0]m_axis_dout_tdata;
endmodule
