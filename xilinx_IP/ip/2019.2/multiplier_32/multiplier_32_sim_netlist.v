// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sat Jul 31 22:11:05 2021
// Host        : LAPTOP-O3DIP64G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               C:/Users/adam/Documents/GitHub/adamShiau_FPGA/xilinx_IP/ip/2019.2/multiplier_32/multiplier_32_sim_netlist.v
// Design      : multiplier_32
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "multiplier_32,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module multiplier_32
   (CLK,
    A,
    B,
    SCLR,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [63:0]P;

  wire [31:0]A;
  wire [31:0]B;
  wire CLK;
  wire [63:0]P;
  wire SCLR;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "63" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  multiplier_32_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(1'b1),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(SCLR),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "63" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_16" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module multiplier_32_mult_gen_v12_0_16
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [31:0]A;
  input [31:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [63:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [31:0]A;
  wire [31:0]B;
  wire CLK;
  wire [63:0]P;
  wire [47:0]PCASC;
  wire SCLR;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "32" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "32" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "1" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "63" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  multiplier_32_mult_gen_v12_0_16_viv i_mult
       (.A(A),
        .B(B),
        .CE(1'b0),
        .CLK(CLK),
        .P(P),
        .PCASC(PCASC),
        .SCLR(SCLR),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
HPMPLvpmoX7LOmPj78BMT9X1rCnPz6PdhVGZQ307N9haGfAdMGVirvGR3e0Glyn2ieoWqXA6qOQL
t0xn28+h0g==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Nxv/BnutRgdmHnLyK7kvDGjm7WGfFKW2mxQ6xUKF14zS4ziz5pSV0ueW4VqAzUyEPsErIAEuyV6F
m5KCqRBB197Q2NbZa7O7tdAqboX6tPAJzbB6u4U/MmNS1AQcSgtfj5srMbdBzDa5pR4V3HrI0MRj
0xhV1BWf725FYPP4av0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F5KGJgEDQsX2btdjtRUlSmNtuyodIhGXEa3/AXv1Y7qgSO8gknBfiqj5HcIaVA9b4npQpDnNcmq+
1ONAqLeLhdOm9TES+GsTAkh/lClvl89bzfqgOV33iqwQHYIHwSsWMRXT9JSUx+YWu+g6xKpT1Ycn
8BCPsq4QUJIqL6W16fheEHB/lkMgnespIWEYJJG6R6zvv2zG8GiU6cG8zHrRjdvAj8kOkhmiMvSd
YjGXJSMfjw7ojCPSUF+nb6WWhUEmoMA/6lgSVaXRm00YHSZ09k7rKTJWSXFSpTmkL2WOsQhNS0ek
jdTK2KF5K6z2YOK4zkfHgZ+fB0KJyANaLLJH/Q==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lFuQXeJ0hi7qnIKAR+37XCSOwp8bGLukonngcICceOVpL87+rxvhP5TyNJ/zXpAWDF0BaRYlGr7d
isPiUStrvUthNyOqCr4vFZyhCdY8n+Mrv3OCvLoLQSarxVXbaKbXb0tPsXJCUdXTrCt9mr5x0Nda
6DAI8FBPlFMAiqnFXnYMwlUiSlkNWUpInuNw7+1eD8kUdckEUV1PDwZ0yjpFqMokMH9oJjN6z0Yy
65D8Tqo288ZMfZQuIimjski+X6EK157XbpyuoZIuYLJ7j6oaATdintgfZpgGzVvhCZtMbx6/SJtR
efW5vLBGiGs7rPBPE2T8fosHGOvmeC9QBSj8Ww==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q8VVvHzTNgU3tZr4+8ia7ylST+kbNPWskONHDOT1dTkB7cHZIAWyzXpQZPuEgk2wJq21PoqmVlG9
t08IYzkfC8vYQ2LRf2Co3SXc7p3gF2OFMC68J9Nf9D+/PXJCJy3QO4H8oO39l6bn8c56K2ARnK0R
mMIALbCWSBDGCWGQmXWZJ+xmDGs1KgTeiSW3bZRftWJ6K8l8BhMit8BLOY2Mi3jJ0WRhN8kKd6JT
D4NU1jTZT6jEtmI7Gnj/AXG6auTqDPHsVQzf+ZzBsLTfw83CFoO70xM997L5cZXlqz8fEDmxezkr
wWxPwJbJeVkRV3tUxlo2Bs2x1uVkXQeNVMI8jg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oUeTLA0HA2uKORUHo1HidNC3lw54gxwlLUkv28qRPv1pz7AEVUbIJ7wsyu2Scju+EkC2Ivi8HbBn
jxkeqRDTAwAbAqIKnY3AdyfojN9Hb8SMLcLnpWLLCpb6E0vwA09r7uqKRZ8wYAgT9CPFvzpQ3zKt
9DTLgQ3rZtFxx2nfCug=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Fayrlym1l14Y48yZ195XboT9ZQmp/mAzUyHby3Y9qJTzDF+m6mRQ/ZbebObo8bu4VAm45JeETPx1
YI4UZNOK4IqKv0BZsAlzUfAYAmqmkmIJYbn2gWUCwXyKX5AoA4ONnlxEHxzZhqtsmEXvxwTEs25/
R7iLzeoMfmwwNHgPNQkteiR4zDlB76CYmgu6EOSUX5Nnitq1oh7qRuU8WqWN7lLfgIC6T7qNHwGD
RPze2yiP06fSG45jPrOn2fvBX9SRbUXjNtiFgmqim4anwJU46v7y3ubit/I6giZhz5PJMZfkDaFX
ag+uCMq4Q8ZEolqMBmjUjat86BdVd4Nmr0yUaA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kIpxh3qIIkWUg8aLJSPKvKhKTPFH7T8fisti5RtNaftS7xh3KDsGLYnF1lYhH2RVXgzbdaVqvtED
5QJazVo6wUFI91xgFeOR5jX+Ny5UBUX2MngsK+UZyZg5+EdtSiDtiJNtQqgjq1Rn+XQCGF3xP80n
7YvuVMbgRHCAfWrWw7ZJ7Y3raRzeIkx+koPFio7XnC+QdRJ0ItO1YtQgF4Sg1Ihr5TH8/RrNn903
kPa+anH9spo3SFCf2Ts11UXAGLdIBmOLMtEAKjjCUbtmjGSeSc0gn2q2I+xRTFcegLevlr/iuLTw
3lFndBAoW40xOiCDjWZ6Rz7J+jZhsRl3D0Bhwg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
gd5ihCJLDbLpayaqNvmjW+Huz3bw0j+r2k+K8yP0oncQvVNpRk2yYVJO9zeOpGMiMdhzPowKiL5y
DNvgqbTcf+3Gvy40TwUYIjca74WCWxw92wYUXP17HAOerUXZAlVsLp6okH1w7VQNvSaMyDBJjr4x
0C7kqNh0xbORQPuxJWpjkdifjnk7mLjbtKbB5M355eV/VhRaS02axYirTeocuXfg1Rh4eK/3LiP6
Q5xkNzRnGWxZAbWmx+usiKbZqssS9XgfVArRT7bW0i4wo696HpfN+Vf99gN2fYSDo+XoeURkRE6u
P8KvKAb7QXojewgNFrogx7Uza59C5ZqtbAIukw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
0Lob+IgvKDxIb7mH8NT/MKkdbZkOENM7qDD3KCsSD5XId+pTAAqXrV3LIYq+aKB/SmDX8/9fxbOf
x4V3wP0OeuggICHF1jN0hOemJD1fVCM0OSA64Z2e0PnMZ8pzBheRINLHbOyBBu0EHFV1AGcZyoHx
Bg9WevVUfoKBFvr1BSO62NraEE8sGGeY276faotvi7shzBdXKtPsyISbCMeff9j2R2edw0kdzx5o
e9HdAQUb4oQh8FcGcWFy7I1XwMXMTT01lJhWt01a0SaFOiBATIacocLdNRKfLmHwCK/GkhmajaFv
nMNshDjopoC2FFFLjSc2fRgNnSgTK7l5nLbw8Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 26880)
`pragma protect data_block
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
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
