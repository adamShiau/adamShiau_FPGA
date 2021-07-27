// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
// Date        : Sun Jul 25 15:57:40 2021
// Host        : LAPTOP-O3DIP64G running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/adam/Documents/GitHub/adamShiau_FPGA/xilinx_IP/ip/2019.2/substractor_32/substractor_32_sim_netlist.v
// Design      : substractor_32
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a35tfgg484-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "substractor_32,c_addsub_v12_0_14,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_14,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module substractor_32
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
  (* c_add_mode = "1" *) 
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
  substractor_32_c_addsub_v12_0_14 U0
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

(* C_ADD_MODE = "1" *) (* C_AINIT_VAL = "0" *) (* C_A_TYPE = "0" *) 
(* C_A_WIDTH = "32" *) (* C_BORROW_LOW = "1" *) (* C_BYPASS_LOW = "0" *) 
(* C_B_CONSTANT = "0" *) (* C_B_TYPE = "0" *) (* C_B_VALUE = "00000000000000000000000000000000" *) 
(* C_B_WIDTH = "32" *) (* C_CE_OVERRIDES_BYPASS = "1" *) (* C_CE_OVERRIDES_SCLR = "0" *) 
(* C_HAS_BYPASS = "0" *) (* C_HAS_CE = "0" *) (* C_HAS_C_IN = "0" *) 
(* C_HAS_C_OUT = "0" *) (* C_HAS_SCLR = "1" *) (* C_HAS_SINIT = "0" *) 
(* C_HAS_SSET = "0" *) (* C_IMPLEMENTATION = "0" *) (* C_LATENCY = "1" *) 
(* C_OUT_WIDTH = "32" *) (* C_SCLR_OVERRIDES_SSET = "1" *) (* C_SINIT_VAL = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_14" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module substractor_32_c_addsub_v12_0_14
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
  (* c_add_mode = "1" *) 
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
  substractor_32_c_addsub_v12_0_14_viv xst_addsub
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
Qdxn4KeHDBmAehOH6HEaHMqlPJDUbV0bFY2E/8vQJ6rDXVGQFzkoV8z2CpMu76O7NAYprSFwYXQ0
k12CZjieJVJXbAqFaOTx+yneUKcJ0UUb7xBEvh00kIiHiaflW8yibW1JuyB2jzepcKCgXQqHLUNH
KTqSBODrHmbvgt93NHHNPhyTnyV57ReMu9ZFAza3BE2rVJEF2QJwqA6V1FCadwx1a9vLwMASXU8g
PX+B/2+w+Zq58h76ICdr47cZo1ICOKmzj5Jqu5eBlI4aV36hHrWTHiLv1DsmN//Dx9m9hvmrRSDF
w3ZHRhqnotR9ycjGJqLCC5JAxmhJEgVxR5L3wg==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bPBSuYWLbxhIyqyOu7qjIIwl5JfbCwcyRKEVMHsQFb5bexeJXQfTpvJlIHAqWtLMegxjyb+0xAU9
DwB9CED4kGmv3wivLJ9TxyzX+TZ1BPDMYInv1HUbrgwJf52hhCn+tOoYNDd5TgjPD7rze+IUmgZa
isXJ26mwee4LMH419/C+63kajwjo7LGKWymCWdVKZhM3h0VqsDMYxP4v4tua2GDR3+L1CusCDSRu
FKfDTZ05ezBklKzXC5C8w626bt+HV++YSSULgsZ4hFS2GUtd+2GNODJ4j4XVx1K7yUVJRMJUHw+U
t9W1zO1GvLQyiOdLWe5YSpuyruDdVuyhTkTDDw==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 22368)
`pragma protect data_block
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
53HaAZnbjpdLN28RMsLyXVH+HJ7l2scT
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
