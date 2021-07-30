// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed Jul 28 16:59:37 2021
// Host        : LAPTOP-MO0UL85T running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/github/adamShiau_FPGA/xilinx_IP/ip/2017.4/mult32_kal_v2/mult32_kal_v2_sim_netlist.v
// Design      : mult32_kal_v2
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a50tcsg325-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "mult32_kal_v2,mult_gen_v12_0_13,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_13,Vivado 2017.4" *) 
(* NotValidForBitStream *)
module mult32_kal_v2
   (CLK,
    A,
    B,
    CE,
    SCLR,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_LOW" *) input CE;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [63:0]P;

  wire [31:0]A;
  wire [31:0]B;
  wire CE;
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
  (* C_HAS_CE = "1" *) 
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
  mult32_kal_v2_mult_gen_v12_0_13 U0
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(SCLR),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "32" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "32" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "1" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "63" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_13" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module mult32_kal_v2_mult_gen_v12_0_13
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
  wire CE;
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
  (* C_HAS_CE = "1" *) 
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
  mult32_kal_v2_mult_gen_v12_0_13_viv i_mult
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(PCASC),
        .SCLR(SCLR),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
CvmaYyJzAT4gGJRlCkE1yXt5Lv9gJbr2gC0wBzixkhI3TupXRLTg9s4Z9WVWp43QDkUuM3VRZjAj
RVnqESt3JA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
hHyS2uxRkJ6sHR79RwG8dxYfMwySDoNzo0ZpVSoiAp/93R212I5J1LxM+7EujDw/cO/x9djlyxbz
erzC6/tIqQ2nS2hUZANmmER9YkiA1RlXlIqDOWo8pOFHNj1c4jf7Zdq7OJMDPvKF+fLgmk5Lu9Y0
15oIyfQw7L+gXpW1qEU=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Cfhh7YIOGyVJiZpd5j8xa2ugbHZdDDpkNcw6vvVCCgnGCfzlen3wlGk0omzzJqyVapnfg0aPFCVf
eH/noQVGu1bQkowx0JKcNE5x1v5DKH//UNI+lq09SNF0WKlMcTAGlNSUzO8kgVv9uNbKUHDXodcD
5iGh6bHMhVPSu1QKpTfJlIMd2CMz0JfDQiVbfTaAGKvrQhaqVte7pYpnqiXM7povPwt/ntWHBH4s
XSF4J4eDVLMuQmQNy3vrqFdEUqmQFtLWgNRpG2fwo19Y2lRzT3ux5SiA0Iv55uR6x7AG21x8BZlD
JC102ufirdrREfWUzlClY8zmr+TUHpTF/SgPMw==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UWceDgHVHZAg17Yudaw03bncVn75AJ6y0RYlYeqdZU3kMG9E1W6q5REaQAI7sMZSrC2g0zavsx4w
utskoq80P2avoebtdvBfjr/nBCQqUN3AvM3GSk85froboZgk4fCQ8UtEj2Qk7ob+ox/md7d9P9dw
2YULi+eG04dUc1g45wwF0ZoZdARk7Ml+fXMnm7zxmvqVieAEsVq6ETZN/P0pwvIpAakLTayKriGC
qcrb1S28bOuV+Na/FX9rxN6hM5aK7vSdFqja5GGs32r9UVRIkX6i7uqS9pWQDR0Qa31W3z6wrRrT
+2wzEwNMDKYuWVIM1FQo/Tp0NKa1Y+kyjahSGA==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
tLsJPLnIUk5FSxPTGLkNhAFldHrP7oFH8h39nfqyEmnC/AmGzR3fePfCEcee3I4TYySABpWhyXIf
m1jGiCuHfIpFkF2EJqjWmBev0bD33cbw1av2xtJRFa5gaQjxChO9URfjedFvCQWWwjlxejc9nD0N
O0V2XUDQxd573YmSBuByzshlxt3bujEd6Xeeb8N8NI8c2ZsfY4693LGdb3k6gtY9ZEoo4XuYVt6n
S2tNFVJTfQjyBEXbuCPqpwGf6bPdy2SKvTE/s4rSIVTO08J6bXDaEOBUGg13XVoJJqrayiJRVuQL
LhoiPzgOqS6ude1uUaMHE/SN9X/vt/6uOsOl2w==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
jgk19ieS+ZYiySHKvgAHMus0OAx0HPJ59p64LMaYK8CyW0wSM8LIn++sFz9tsOBdLj2gb8IKpSVr
SOX9XXXM2pQFSME7x8q0m+EPg9m1+ghIpW4bU/w4zVq4NBjYydZCI0Hpy+X3op0a3+eENVEw5SoK
4R/zOL7aV/2nZ//wkaw=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L/BPRr/PHH5da1O06dKRr5ST8eskM6lzR1UPuTvZQ6RCsFEjTD1HgyqjW7/ypnIq7V5TYDC553+Y
rJnEENzDc6RSpzenrYxw7NrURpUedIWlCc/PEf5Zq9gu1ESkpND7t98rc+uiAz7zsn/pHD/K50NR
q9l/gcWkOCgArmADo1Lw9usrfZ8ECIPKY2kLxeTYbh4fsrCpPQsQUk4NxX3N1Q0h3RRUCdHSFc0O
lvGip/vd24OK8zXDMaQv4fPmgToFQMUvLrJXErEUeRlkpxkcX6g6Zu4RMWwwmkNIfZHpc5K8Q3RL
MMc5rARUSXbNbpf28H3iyAMZ0y+EgI0CrKwooA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
D5C8P1OFldtpzJq1T3mSjb5ctG8uEBHnDEaLFzhA5MmbEYufsP/8IodNdiPf1/2RjLxnjoY6pwRi
y/FOcwMxTFUwPKmnCoUeaHWZWJ7FhG9qVc6HOxs35y7h+boRX27MfW3IjP/EBzGp3JOtYXtF2f/N
XS2KwYbTy0AuPeC84ZmMNUUUwpSUn6R5elOmK8J3xGOmJ5eKhbKKWExqu4f08+do9rItQq6oDYtz
pecuzd3VXNKxjcc2h98Kih2Lmfl+oy6dHjBErBcsPqInZgctpTZG8ADiOwYQy6bhnt7VCcBxAI9t
LAHpqT6oTEUoju1nd6P30e7GCjGCBViY4g/L6g==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lEiBFRGednqP2z/XCAPbOWo1hX4nE9H2D0ZNj3bCZQlLbGnrhusAgnktGYl7NdFXW4DK/n0VflpQ
C9XQ0IE2G7LczaLj8NeuIiB0eojPErgMGtx1IaEa1W44EogHy6nIPNmOgN1eTa/ChUITKUqw7wFh
HexzycLYuhDWF9kHeO+UHjWZVtj8Evlw3/WG8PYS0fXtWfL0hOgQ9B9tO1h70PAdW8L+AM06kqSI
4jFdZsuAPVStgHIHuoNZulyy31UOe5jpUqo70iUa0pJY6lHyxF74snZ+QgepZpcHm4LnFLO6ye8f
5R+bXmj6pjFEEHDNl9WjzEzf3ciV+BmNbpcr8Q==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 27008)
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
