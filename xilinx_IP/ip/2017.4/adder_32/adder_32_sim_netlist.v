// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed Jul 21 14:19:22 2021
// Host        : LAPTOP-MO0UL85T running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/ami73/Desktop/gyro_FPGA/miniFOG_closeLoop_v3/miniFOG_openLoop.srcs/sources_1/ip/adder_32/adder_32_sim_netlist.v
// Design      : adder_32
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a50tcsg325-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "adder_32,c_addsub_v12_0_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_11,Vivado 2017.4" *) 
(* NotValidForBitStream *)
module adder_32
   (A,
    B,
    CLK,
    SCLR,
    S);
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [31:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [31:0]B;
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF s_intf:c_out_intf:sinit_intf:sset_intf:bypass_intf:c_in_intf:add_intf:b_intf:a_intf, ASSOCIATED_RESET SCLR, ASSOCIATED_CLKEN CE, FREQ_HZ 100000000, PHASE 0.000" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH" *) input SCLR;
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
  adder_32_c_addsub_v12_0_11 U0
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_11" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module adder_32_c_addsub_v12_0_11
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
  adder_32_c_addsub_v12_0_11_viv xst_addsub
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
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2015"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
iO2Bdkfy0dqqValMR4KhTWXpD0gDQF+kyoly3tZBTZTVs0CbWJ4Owhu4jxMCf8X2gbWR6iweF6Ks
B5dmLHZTDA==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
dbcEbgyZfx3YLmYpvjegvD9sRQCV1qBv0GqFBvCakC3SMR/H82zqo5uv5MZldBGUVmNHnxF3Vejx
zSqxUKfTNc90CS6quuoQe0eeq3T5XSdgwbNtjPZKvJuJTmQKT96yB3CfQOz13fGjaLrn/8NBUBBh
I7OEoGGg7ADph9V3vRg=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
bD3a4YgAnaoJx9/hljj2C1rODcUhawTVE1gtdPkNj8/YjemaFM6/sF7Q0CXbDJ7a+OBrB5pUgj3O
Vesi4yVmFp+mGmFarftWat5KmZiP3RVWrXwdzMj+f8T7p+lE3iD4njqUxIUz0TsUaNvFeW0xVNNb
OwTEX04nyt5HrU82dltJCclpFxE6yrP9YvI7l328bphwnC63xxk8T3yXwCrvj3VrIYuDT2yMRxrB
TBCv/Fe2f07JQyV73J7+DGAeJG0B1dTHeu48auQT63g1HsYaUXREihEUKgZe70QlOqlPbrr6Quhx
2LXE8LSdCA+FbJ7LlQc/Sgasj3ZYjM5lhEKleQ==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GCfR7acMSeEtOw1DhZKkUXjh9Uw/vUar7CGDRG9rZcB9NFDtQTltJeuKjFg8eaeKH9HFBMryuX72
/tmzhtFaiSTjr2na4ncL2XV3QRXe7nQaiHdc7cKBcZDvdSSMzOSYcIxLunwLwQTLC7sCvINmlxO1
NXnYzJVL1xb9HP8QVnSYpo1p+gCXcRBZzrOjZjCUnl7F2t3ZZStSGjBEyXVLnV+ouU3+247oJAOa
kC7v+pOtG2ho4KclIg0MGijjPs+jyOFU+b5C+ufQp/zL9GiZ5waCjb/0Y1vkBc9jZKR7YRnv+ASG
ju1uP8oqEXR9742kXRnW4HkMKkCK1MLDgWYdqw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2017_05", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
L+AGKmFZ1zoRJFd2cA+zxJhkgQ1R0aEjGQCGRFLNNhLHZXpzGDIjdSLjralBVRJ2rD6UcJutapF5
YaMoV9kphGGG2B07dxBuIimVjOxS3ZQJ7ru59ddfGBxUe9EHrv00Q5hTwoxig0lxqnmjSSnfsDeF
weTIqNnXkG5kqqezKC8a2FvUD5QWQBibhK69OAdmhhIOwZmpfvQKbEKgLX70BzcNlmLnttRL7G+q
XZ3fabZ42+JJHDLiIfveB3Gp2Lf2tzTH1u2xx5aEUr9154pnC9PWIwL3y3VBAT1oHR7ScdoGDOEy
HoYUiDibldOidIeKW0KrTeAIuBNmtM4R0R+RSA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
V5ClnklUs5Wo++EDemG/KeowZlAfqB8SUrvSxPQGrdIwGfUvoCajhuABAWdS/L/pQl7Eyz51aiuw
KzPMrWtQozAEITf1xzvzgKbWZqoi4PQD3rThywFsFq60u8DdvHYM/kEvit0cZVFvG8rAbtlseHLu
0vU1kbrNgxb3bxjOovg=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
cRqAgScIUeXUwYGfCC0XDtpcc+mFNm3p8oTcFdtIU1nnlMagpBMqRm5ELc+m/Yw8jBwvcvt4tUFv
u/ypEEw+y12B+5Pr6SmnLJ+NVB3Q3Eyh4Q/d7p3jReIIsUxrlENpCTi4PVXMKr1B1Htzm8F8mXDq
y2UV+0SC+4yrBIntsdS0S8jPBERhfJhzNC5z38pPHANtM4wGGIUuKxIALLz1aq+2AjLbEgFHNrzw
2bJiDwRSTwrY4Yx2MSzYJk3O+cQBUe8nJDPx+aGEvDzQ4ZdJMNg2z+iaiE7OTaqK492Jb/1jvU0j
wlI+n35s2rrnc9QgfljdOJuueruPuYDi5vTTxA==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
osKNSP00UgFcek9koOfdEbQfuQJYQOoCcD5fQ6KxJuwFmpgrt6QR/LroOxEBn6/CkNWkigA3IrmE
nzMPPjgBpBvKL07sgapR7wLFIk/1axvzcb1wUTwOWYP1Q2A/iDj0S/z3K9HZRsF227s2M34egtTp
0AUt3TkzBOK9KUkE3qCHadqDOrvGNA1X2dVlbsYzulj6LP9h92HA4XVrMTvlhUNHug9Vz2Ianje2
jr28KG1Nc+CBIZ/vlLuA8PDBzvlHGKPIre4eRxUpE875jDgMnv3CCHzrFTp4W9CyVx+KB/NDnZxy
lG+5X1Qypll8B3g3F3Tp2BVKWOhNHadfrhIXbw==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
N9ddkr8BVj9N+pmyhKluXGpUMuBuCDmAfEitTMLFt+uY/1FdhD/MpCAnChI97idnOJzYh2hXM0zD
snZ2ZZxH+QPa5z6d/EsFoGkio83S1D0xFcy6/1ogEn1Iz00z2nKilEHZ0ON0C8HSOwh2Ok5Q9XTn
ogfQIEGKrlOVna6tdgYJlVRQHjeiyR7izcCAs6I/JhNfDLd0DGV2Hy+p62uVIo+ibj1Jvwv0T61d
Zrp4+rKu9li9NUlIKZu06z5ZlWBxd6v3FDAN9m5wJBO1SwJ154G+7OyP2j9Isg/dFT0fxK2gODhX
MMIoaWPJDKMALgLTSoDrPn/hoTUk3Ua3HA6iGg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 23200)
`pragma protect data_block
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
Hg==
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
