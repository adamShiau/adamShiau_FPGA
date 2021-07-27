// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Jul 25 15:52:14 2021
// Host        : LAPTOP-O3DIP64G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/adam/Documents/GitHub/adamShiau_FPGA/xilinx_IP/ip/2019.2/adder_32/adder_32_sim_netlist.v
// Design      : adder_32
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "adder_32,c_addsub_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_14,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module adder_32
   (A,
    B,
    CLK,
    SCLR,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 s_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME s_intf, LAYERED_METADATA undef" *) output [31:0]S;

  wire [31:0]A;
  wire [31:0]B;
  wire CLK;
  wire [31:0]S;
  wire SCLR;
  wire NLW_U0_C_OUT_UNCONNECTED;

  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* c_a_type = "0" *) 
  (* c_a_width = "32" *) 
  (* c_add_mode = "0" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_value = "00000000000000000000000000000000" *) 
  (* c_b_width = "32" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "32" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  adder_32_c_addsub_v12_0_14 U0
       (.A(A),
        .ADD(1'b1),
        .B(B),
        .BYPASS(1'b0),
        .CE(1'b1),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_U0_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule

(* C_ADD_MODE = "0" *) (* C_AINIT_VAL = "0" *) (* C_A_TYPE = "0" *) 
(* C_A_WIDTH = "32" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "0" *) (* C_B_VALUE = "00000000000000000000000000000000" *) 
(* C_B_WIDTH = "32" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "1" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) 
(* C_OUT_WIDTH = "32" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_14" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module adder_32_c_addsub_v12_0_14
   (A,
    B,
    CLK,
    ADD,
    C_IN,
    CE,
    BYPASS,
    SCLR,
    SSET,
    SINIT,
    C_OUT,
    S);
  input [31:0]A;
  input [31:0]B;
  input CLK;
  input ADD;
  input C_IN;
  input CE;
  input BYPASS;
  input SCLR;
  input SSET;
  input SINIT;
  output C_OUT;
  output [31:0]S;

  wire \<const0> ;
  wire [31:0]A;
  wire [31:0]B;
  wire CLK;
  wire [31:0]S;
  wire SCLR;
  wire NLW_xst_addsub_C_OUT_UNCONNECTED;

  assign C_OUT = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_AINIT_VAL = "0" *) 
  (* C_BORROW_LOW = "1" *) 
  (* C_CE_OVERRIDES_BYPASS = "1" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "0" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_SINIT = "0" *) 
  (* C_HAS_SSET = "0" *) 
  (* C_IMPLEMENTATION = "0" *) 
  (* C_SCLR_OVERRIDES_SSET = "1" *) 
  (* C_SINIT_VAL = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* c_a_type = "0" *) 
  (* c_a_width = "32" *) 
  (* c_add_mode = "0" *) 
  (* c_b_constant = "0" *) 
  (* c_b_type = "0" *) 
  (* c_b_value = "00000000000000000000000000000000" *) 
  (* c_b_width = "32" *) 
  (* c_bypass_low = "0" *) 
  (* c_has_bypass = "0" *) 
  (* c_has_c_in = "0" *) 
  (* c_has_c_out = "0" *) 
  (* c_latency = "1" *) 
  (* c_out_width = "32" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  adder_32_c_addsub_v12_0_14_viv xst_addsub
       (.A(A),
        .ADD(1'b0),
        .B(B),
        .BYPASS(1'b0),
        .CE(1'b0),
        .CLK(CLK),
        .C_IN(1'b0),
        .C_OUT(NLW_xst_addsub_C_OUT_UNCONNECTED),
        .S(S),
        .SCLR(SCLR),
        .SINIT(1'b0),
        .SSET(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
dmmXCzwxW2FLu/vVGpJzoQ/uTl0t/oirVzDN8rGCQ/cshHIr5KZa8hMP1zjDcrW6js/9tSBuCaB1
Ioj63zjqZA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
N9Ijk+dhcsedFOz7GhClRR68iRquy2ZzjVLVhi5GByFuPpr/oGFn021AFcKE54GT1hqizIMvWGS0
qRbWSO/aiWGT8c930WMeayc4xm2b65tzi7UyXSjcZqyZqk5spgPewfSuL0LKD5R4+zccn3yeTyAR
Cpi6LZ2KmpRW5biXvss=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
M8NGALCMec7MmW5uPCxfU8HATjWU2XqyPU8phSDe3mtyor4pgfPtg5TJdKOytKhxa+fQwJxytwzI
KPxtYmaRH/KFiGrOvm7jO78NIlt31qN95S7sMYrLxORaZ4bbNMg4RfwEB0haV15qORczgxWEpvBX
6Qukl64ihp4NiBjXt4YYGoDiNMSczgOe3tLn7UWjfPQnsJ8aMxugelO5AciSBxAdohgLMRE3cu6p
gwakO6ytq1vAR8bqHLT8g/Kdsxn72SBHYdpkba0NfEvzzheOlZY7fNuWD48V6QefMjsX1taMkmQH
m38VdXlC6Ocia7H3zT8LvNLtxrpG8zyD+UI+sg==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
I1BukTJgP0oEpI/mdw6jwrYhUTr7MTzY5G/EvfuPKQfGzYRI1qLG+aEQeclA1P65+tkbstBEIIg8
ZhiouPVaom8KwKZHBX7eLpxvNBcYVFfnJb1ES5wdcph3sgGtaYKSpspp51oYPM6ZD7DmMGdoc/Wg
JVIUuIfRpo8AnEMfkayPkbwuB0VUKpz5BXS50B+5jvgK7cFe2gUp2ckThqzKUjViVB56Swsz+IQe
l7GvtTbuNcSwapfPtNHH0bWSQStfIzPZZm1A2IZ2WCYafRPkj7uibtKNgnKgIZs1197qomgXbb+b
fDx1iikgF8snJsPchukmgxkMSQtLntwbLs6H+w==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
UNzBll4hVdQjkp7KJChMHZ9agdKjtTu8+3O75Phz7SpwUZ73Z533+9pCfaH7QI/cwqaVREb20HXT
ji2kU1DV7+Cwbshd08hvUBl23F60ITYS+3rluBLIFX3pzXhjjSu8HQpnxXppbCODvCiWrDLqRU/y
lcFf7B+yp5jK6vEY5xuh8is/oxSPNFwip6GSMqDnE45GU6kU+6n8FTk8pAZUNKnh3j0t6YzcwS3J
wYUhnJpEQYd7+0D/NPjEz0YFqzB8WCh70MxBRJzwdXpuRLiFzplysvw+eHjMPVeU/UPKJWuwWuwc
Bfxw0ThSXZit/SSD+BGhxjbEI9T6rh66FpqbTg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
F7AZy6dB5VKzcudhyRSKWKUbVrSs4vS9jtgDkM6KrVPs3ghP3AF2TeIDyl03EesBxeIQxHqq8thx
uVIGQN5wt92jkzGo61VyUoF2dYHY2dkK9PY4bicayI6rppCS18HnyCC5ODrTMKgOpoj+PEmghCZl
j8+i3NFWPAo6M/MAtVI=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
NQpRHEO/CEh2TWVl2zAKLb4TTDP4G4mQHrGzJeErDNbJ2L2B4iz3unsCjzHkoDagHoU9jeHYNzw1
EdgeGwokAwsWnHc0V18iEu5CZPPLrncpORhuc7qe0zJvoIFW4tgNZuIjFZI6bkrWzgxNYlkitGJ7
wQxgR+6ZenldybAjVF7d1R8FQmrEKWQ9ztmGHKMd9PfWD1VsbOoxbNA1tkQ3Suq2M9HDzUONaPQq
yMnGxLE4+4xTZZFVVFZeizNxqQcM1Y6s2MEUyS89U6rdAH95x9zDN8PGrif1SUWhpoz33cYp/IL8
acGyIWDbmuS0X+xsLC8cWcrO/MxKDk8bj12S7g==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
W2ZLxVMM2bO/6hqe8KRsBOYby+akb1JiKHhCv9fhS2DK483JVHKKDFtV5ZylpQSPfpmWVI6nDnNm
XtxOYqhOdd9wAHIVXly/nJQ3BORIgR42ZfKk3tkiYQd75XwTJmWjvIda5LTjKISy58Rg+7/yc6kX
SAKkQWzcaHy0VIrsbeLAK7Rz2vPrBQAwZijqUO1uD9pTa1ID2lBqRKOaN/lex50cPJ7PNmyesOUe
aisZi7+ubKWoKmZJmdUy4nKUk4a0FLkIqdFpmX+Bu5UVgWOF47nrEwh3c1MVRxWa1uvngQGGl026
FTa0G+nc1Q9KslAvMQ+fMbz+FbnTF3u/A9gizA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bvKge04AUkNrCv0Lf72v2M9DyTuyKVXxnnDRdHei8BNUgaiiU2cNPnHi+AsPeyhKjCAr8oOc0S20
+gqqid1LVqLN81iwHbZTi/ZfGZ/82zyZJB7lIek2dm3SI2xlaXz4Qq8aWuoBuF96cZZeidPfQDv6
MOj+XoLh7ht5U3/FyegeXtWXOm3M6WQnOjkQItVoydnkjdSZprGrpwlxlMvUAlqbWh6eE6YP6fYS
9SluLdMR38JRGtyqQKLH84P7TCipbtQR/0h0ckqN9cHTurlbRrxddVL5OK5/2d+/ofUNVnwAVYdZ
NcNgj8MLia8oCQf7AwrI2sE/EP1Euq/avwEG6A==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
hwPkV1ZoeiS4OUTvQh7XAwC2wiv/3GclRDrW39cvI4moo8HvB0SoFojWCjqYaosrp93ZCoe5nZWr
WDh4C8LZ7X+Q/RavfgyGB+mPL2v/ZMqIQ06vW57Rr5k23YdzhXRXjVKkq5IV7jzqVp5kiNnrNgPi
YfO0plIy5TFOnMjudg7O/4Q6568xGsTS6stwdn37he7OIn0DGrDcbWFmxOov1xkx1aLDchrtiSZN
a9IZXPbLBJUIyDKbdiAgFWnda6uNf+my1WcaDqqoX3l7PvhMKULqi3x8V+fu2pLkdGWEhzBgy2BA
gjoGRNs9xntvNCiP4H+jU/EahuzOCn7IBF5fBg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22304)
`pragma protect data_block
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
cwDNIEtl461sW6GnrtOjhvU=
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
