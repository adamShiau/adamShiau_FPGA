
`timescale 1 ns / 1 ps

	module myAXI_2017P4_50reg_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 8
	)
	(
		// Users to add ports here
		output [31:0] o_var0,
		output [31:0] o_var1,
		output [31:0] o_var2,
		output [31:0] o_var3,
		output [31:0] o_var4,
		output [31:0] o_var5,
		output [31:0] o_var6,
		output [31:0] o_var7,
		output [31:0] o_var8,
		output [31:0] o_var9,
		output [31:0] o_var10,
		output [31:0] o_var11,
		output [31:0] o_var12,
		output [31:0] o_var13,
		output [31:0] o_var14,
		output [31:0] o_var15,
		output [31:0] o_var16,
		output [31:0] o_var17,
		output [31:0] o_var18,
		output [31:0] o_var19,
		output [31:0] o_var20,
		output [31:0] o_var21,
		output [31:0] o_var22,
		output [31:0] o_var23,
		output [31:0] o_var24,
		input  [31:0] i_var0,
		input  [31:0] i_var1,
		input  [31:0] i_var2,
		input  [31:0] i_var3,
		input  [31:0] i_var4,
		input  [31:0] i_var5,
		input  [31:0] i_var6,
		input  [31:0] i_var7,
		input  [31:0] i_var8,
		input  [31:0] i_var9,
		input  [31:0] i_var10,
		input  [31:0] i_var11,
		input  [31:0] i_var12,
		input  [31:0] i_var13,
		input  [31:0] i_var14,
		input  [31:0] i_var15,
		input  [31:0] i_var16,
		input  [31:0] i_var17,
		input  [31:0] i_var18,
		input  [31:0] i_var19,
		input  [31:0] i_var20,
		input  [31:0] i_var21,
		input  [31:0] i_var22,
		input  [31:0] i_var23,
		input  [31:0] i_var24,
		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
	);
// Instantiation of Axi Bus Interface S00_AXI
	myAXI_2017P4_50reg_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) myAXI_2017P4_50reg_v1_0_S00_AXI_inst (
		.o_var0(o_var0),
		.o_var1(o_var1),
		.o_var2(o_var2),
		.o_var3(o_var3),
		.o_var4(o_var4),
		.o_var5(o_var5),
		.o_var6(o_var6),
		.o_var7(o_var7),
		.o_var8(o_var8),
		.o_var9(o_var9),
		.o_var10(o_var10),
		.o_var11(o_var11),
		.o_var12(o_var12),
		.o_var13(o_var13),
		.o_var14(o_var14),
		.o_var15(o_var15),
		.o_var16(o_var16),
		.o_var17(o_var17),
		.o_var18(o_var18),
		.o_var19(o_var19),
		.o_var20(o_var20),
		.o_var21(o_var21),
		.o_var22(o_var22),
		.o_var23(o_var23),
		.o_var24(o_var24),
		.i_var0(i_var0),
		.i_var1(i_var1),
		.i_var2(i_var2),
		.i_var3(i_var3),
		.i_var4(i_var4),
		.i_var5(i_var5),
		.i_var6(i_var6),
		.i_var7(i_var7),
		.i_var8(i_var8),
		.i_var9(i_var9),
		.i_var10(i_var10),
		.i_var11(i_var11),
		.i_var12(i_var12),
		.i_var13(i_var13),
		.i_var14(i_var14),
		.i_var15(i_var15),
		.i_var16(i_var16),
		.i_var17(i_var17),
		.i_var18(i_var18),
		.i_var19(i_var19),
		.i_var20(i_var20),
		.i_var21(i_var21),
		.i_var22(i_var22),
		.i_var23(i_var23),
		.i_var24(i_var24),
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);

	// Add user logic here

	// User logic ends

	endmodule
