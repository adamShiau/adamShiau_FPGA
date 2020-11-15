// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.2 (win64) Build 1909853 Thu Jun 15 18:39:09 MDT 2017
// Date        : Thu Feb 14 17:14:53 2019
// Host        : DESKTOP-L7VH7BR running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/adam/Desktop/FOG/project_tt.srcs/sources_1/ip/mult_1_1/mult_1_sim_netlist.v
// Design      : mult_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z010clg400-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult_1,mult_gen_v12_0_12,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_12,Vivado 2017.2" *) 
(* NotValidForBitStream *)
module mult_1
   (CLK,
    A,
    B,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) input [13:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) input [2:0]B;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) output [16:0]P;

  wire [13:0]A;
  wire [2:0]B;
  wire CLK;
  wire [16:0]P;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "14" *) 
  (* C_B_TYPE = "1" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "3" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "0" *) 
  (* C_OUT_HIGH = "16" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* c_optimize_goal = "1" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_1_mult_gen_v12_0_12 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "14" *) (* C_B_TYPE = "1" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "3" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "0" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "0" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "16" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "zynq" *) (* ORIG_REF_NAME = "mult_gen_v12_0_12" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult_1_mult_gen_v12_0_12
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [13:0]A;
  input [2:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [16:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [13:0]A;
  wire [2:0]B;
  wire CLK;
  wire [16:0]P;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "14" *) 
  (* C_B_TYPE = "1" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "3" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "0" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "0" *) 
  (* C_OUT_HIGH = "16" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "zynq" *) 
  (* c_optimize_goal = "1" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  mult_1_mult_gen_v12_0_12_viv i_mult
       (.A(A),
        .B(B),
        .CE(1'b0),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(1'b0),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
lEAWhwyix5jBGG66vdOS8nJpVNdFrJkI8qYgE8UK5+7avncLp8v54uPGoRWR36jLWh6ehDkiSjec
BS6Kf+NkuQ==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
pIREr1/dqaPvd4j2lTxOBSnAy2Ra6DuJsnP63kEHv0IS6up5E7T2izznuVUSTCTOb47ap4dcNzFs
VunReb3wPh7pLPeb7xw5iV9uBkd/TpxZM73yc3k1Rpf+4J2IVlTVOAQ5OEjaorVixNlt8NiWGqzH
R/d96oqeazauoI3oOnQ=

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
DELvK5o++4pE4MCoxr5fui0H5JI8L1lrkSphbogK2GjTRYuCaX9esyobvkVAA3D3d9tJqaP3hGDO
abwxN4b4ezNtusv1gy6cglGx/GN3jUuKSbgskyfUxDvL7LrGyqNFVNMUu2E9m+BfM4Ntpn0n9FIV
ziDzomLe9jJOEfua5U0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
V5WVwaxzoZCaNjBtQkebL2emEOYwtLrt2YC/Nhjv+maBGQv/B4iXQaCQdVt72XysdOqpG+W7acY4
LQoDKOXjpn3NnQIeXe5yNHpeBxy0UeQS9x3LKwyD7PTy2e6Psu8FyrhI0YZfF7izMLFdHz6hGOSF
AIMgUa/N0UmNtXEjM3DkfZLqoYQAht0o6JFtiqajvc59tPsvMZCCtiKwhXu7PlN11ghLauG7TulD
K2KfLDkX0cfwDA2TPyp16kT6EIfZoCRnafITvpKhHXZv+NQc+XN9PbcRpp9BOAC79WhsNkBBXYhL
PABV65LzYa8+x5tqKdf3v0X46IAMWJ1e3wS5UA==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
U33OFhvyDr6TZQknmG9CiJblHCnuyjNFktguLuIFzd/VYuPGNPUXzm3pNVHAmifAJrPB2CT7TAF6
SpBdgM2KIeON3LRhsrRAbVtPF8PLeYtYTgU5BOY8SIKKoSu1FY2Gr1zMrTO/nd+RiZegYkT/1u27
xI0aTCkoWlFt3amFg2MasqdnOSk77Lt/DgM2JPd9muhj3QoSr10ZjlsDKpO31B9RZyxGfIMIft8A
zXeFtxJQH+1UZmzli9TNedfnlc4Etx1ofsn10PXyAOJjpszIhUCVPKZIY14gmxL8f+2bLkbtbsCM
BVqE9L8J6oKTduRVz5WGnDuPWMDwM24T9TA/dA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinx_2016_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
j6YL/khcx2/CEaOFv1YeHhnfPBfzoLLf3YocgJW2UWv3fiNKR3/XVXrjS7WsQlB+PoA6wradLkll
gsCEiQrgYuwxUEkrZPREX1CG/XJwUl9PKDBg75CevIh9+3qKHJGSxr9GydBxI8A2Bl+6FCqWp+ji
fmjdmpZhDdGqO9F7NIOUIknT0jWHS4jX/6J6w3BhZ/5VtUKxAeh4CNotWM+2fGo67UsEmFovMSdb
AWdoeaA+uo+Nh0kX6bc0yzej6R0ECeV3uzW4Gr9HgZtmqiZ4XMox/30Qmatsy8mCmeKd4pCcCVaP
xJ2QjwO5By08VArjkqF+F5MjSBTB2AgEgKQm4g==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
l6VRJPCYtK/8+w7fVYezDkwKdtmhq8w/oqv6nG7q/kdV0DxbrnxDiwI3fRsLuzqRaFzB7M/Bp6me
dlIv+CxJJ5+ytezBmXKzstBJ0pQvQEYNC8V9nP5srtMyzV/uZisUtiJpZ4PY9LCMpogJ6fl2AJ63
w76C/HJ492Gi7JLWIb4oicXLZskZXakB/eCv0oiqYLDvWYxN29k/Oo86gvifNbUVsbYq28fJXbbY
rJcngSBBVosze7bkeJBcF5hPgZNogQ2BDzDt1xfJoFDZGrjhYIcXRVcty4JoQa94VlnJW8kzHoEN
030iu7Nx7nQrr5xRiIId/NmYwFApyZ4NbNgtQw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="base64", line_length=76, bytes=256)
`pragma protect key_block
tVXz3t4ZGjBZtcc9MtPamStRYCw+/wda5oThHiV3pRfmG+l1q+eGihvtPB7e/6+Dn4kO1flbX78u
PZkKpR/HAVOX1GWQVA04SBJ50L6Cl0jZAH14X8zFznCmA5qztX1awy1erPqQIpytA6FejJc9DQqP
D3JGVyIaxpg0kUyfn6YtiyKu2oKAfb4p6VWLtn1SwQY8tQyeewc1ttykF9/JgC+8yQ2im7aiQXpy
alklknJjp+IrLttmNSrTIDQQt9OoSuNhioK4QL/Neem7tnguDwzY0koIvUQoLR4OGBB4NWQ6yQrf
lXf4OHK3B24hLtKuHkAtVRamymmy3A2mF2sihw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 29776)
`pragma protect data_block
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
FU8jHg7hageAU/sTXNiR56kEQQz5UA==
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
