// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Wed Jul 21 14:21:42 2021
// Host        : LAPTOP-MO0UL85T running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/ami73/Desktop/gyro_FPGA/miniFOG_closeLoop_v3/miniFOG_openLoop.srcs/sources_1/ip/substractor_32/substractor_32_sim_netlist.v
// Design      : substractor_32
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a50tcsg325-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "substractor_32,c_addsub_v12_0_11,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "c_addsub_v12_0_11,Vivado 2017.4" *) 
(* NotValidForBitStream *)
module substractor_32
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
  substractor_32_c_addsub_v12_0_11 U0
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "c_addsub_v12_0_11" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module substractor_32_c_addsub_v12_0_11
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
  substractor_32_c_addsub_v12_0_11_viv xst_addsub
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
mtU3lJFO5Ot+JwsMuX7qZL6MdiqcRWT7r5los2EW9fzhuH5ycyEHPqZfb2ytlXtzLsxiCw3ZWOX7
YiWLQV1GE06HiwGjlqhJiHzGRCjq2mWZ8xJxfiqgphUEWHXDTzsI8S9PaScCKGrtbIvLbaHt+Y05
y8rT2u4siqCvbEmGZZZNAjkUqKNgfquLOVO8wXBgCCDRYXRqzZ3y+3klBYIeHPNbte4OceIbPCHA
6yws7fYuBe2yQix2etn7kWMGK9tNZkTZTBWEEf5NSN0CpGEZPvAfrnLrj/Smq6t35D5NErkQL9+1
HYtbAIsNrCq3I0YUAYSPwMaXfdtzD628FmQfbA==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F6MzFRwOn7VJWlhRhzV2JFyqDfeFK7TeOnH9w9vtiscdneymc003Kd69z//ekx59/d7iW+PuvEXs
0maDbVRCMNOL01mwhCqeS4nSSs4OtBLxUrak/BFAc8ZhceQG65x4MPk3gu35mlgfaXrkwgGs4G3G
4IG8dvDE78qr5PUS6bWGOAa5fk/slCic2k7vmAxlOL+qW1CmdVbHJTl3hTyEw0Wczwbkjpm2OzVR
hV6m4Xs5lMw0ik53DXW/IniMcCoYB+6bYhvuB0Wwv+2Q6UIeZC8uORdW+dSl9siISnpUY9qNNwXT
XsSFzyAvieuTht4r8o4G6n9oeBkEf0fIx/ko0A==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 23472)
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
