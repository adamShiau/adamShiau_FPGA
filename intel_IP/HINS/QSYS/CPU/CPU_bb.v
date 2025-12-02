
module CPU (
	clk_clk,
	dac_rst_export,
	epcs_dclk,
	epcs_sce,
	epcs_sdo,
	epcs_data0,
	reset_reset_n,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	spi_adc_MISO,
	spi_adc_MOSI,
	spi_adc_SCLK,
	spi_adc_SS_n,
	spi_dac_MISO,
	spi_dac_MOSI,
	spi_dac_SCLK,
	spi_dac_SS_n,
	sync_in_export,
	uart_rxd,
	uart_txd,
	uart_dbg_rxd,
	uart_dbg_txd,
	varset_1_i_var0,
	varset_1_i_var1,
	varset_1_i_var2,
	varset_1_i_var3,
	varset_1_i_var4,
	varset_1_i_var5,
	varset_1_i_var6,
	varset_1_i_var7,
	varset_1_i_var8,
	varset_1_i_var9,
	varset_1_i_var10,
	varset_1_i_var11,
	varset_1_i_var12,
	varset_1_i_var13,
	varset_1_i_var14,
	varset_1_i_var15,
	varset_1_i_var16,
	varset_1_i_var17,
	varset_1_i_var18,
	varset_1_i_var19,
	varset_1_i_var20,
	varset_1_i_var21,
	varset_1_i_var22,
	varset_1_i_var23,
	varset_1_i_var24,
	varset_1_i_var25,
	varset_1_i_var26,
	varset_1_i_var27,
	varset_1_i_var28,
	varset_1_i_var29,
	varset_1_i_var30,
	varset_1_i_var31,
	varset_1_i_var32,
	varset_1_i_var33,
	varset_1_i_var34,
	varset_1_i_var35,
	varset_1_i_var36,
	varset_1_i_var37,
	varset_1_i_var38,
	varset_1_i_var39,
	varset_1_i_var40,
	varset_1_i_var41,
	varset_1_i_var42,
	varset_1_i_var43,
	varset_1_i_var44,
	varset_1_i_var45,
	varset_1_i_var46,
	varset_1_i_var47,
	varset_1_i_var48,
	varset_1_i_var49,
	varset_1_i_var50,
	varset_1_i_var51,
	varset_1_i_var52,
	varset_1_i_var53,
	varset_1_i_var54,
	varset_1_i_var55,
	varset_1_i_var56,
	varset_1_i_var57,
	varset_1_i_var58,
	varset_1_i_var59,
	varset_1_o_reg0,
	varset_1_o_reg1,
	varset_1_o_reg2,
	varset_1_o_reg3,
	varset_1_o_reg4,
	varset_1_o_reg5,
	varset_1_o_reg6,
	varset_1_o_reg7,
	varset_1_o_reg8,
	varset_1_o_reg9,
	varset_1_o_reg10,
	varset_1_o_reg11,
	varset_1_o_reg12,
	varset_1_o_reg13,
	varset_1_o_reg14,
	varset_1_o_reg15,
	varset_1_o_reg16,
	varset_1_o_reg17,
	varset_1_o_reg18,
	varset_1_o_reg19,
	varset_1_o_reg20,
	varset_1_o_reg21,
	varset_1_o_reg22,
	varset_1_o_reg23,
	varset_1_o_reg24,
	varset_1_o_reg25,
	varset_1_o_reg26,
	varset_1_o_reg27,
	varset_1_o_reg28,
	varset_1_o_reg29,
	varset_1_o_reg30,
	varset_1_o_reg31,
	varset_1_o_reg32,
	varset_1_o_reg33,
	varset_1_o_reg34,
	varset_1_o_reg35,
	varset_1_o_reg36,
	varset_1_o_reg37,
	varset_1_o_reg38,
	varset_1_o_reg39,
	varset_1_o_reg40,
	varset_1_o_reg41,
	varset_1_o_reg42,
	varset_1_o_reg43,
	varset_1_o_reg44,
	varset_1_o_reg45,
	varset_1_o_reg46,
	varset_1_o_reg47,
	varset_1_o_reg48,
	varset_1_o_reg49,
	varset_1_o_reg50,
	varset_1_o_reg51,
	varset_1_o_reg52,
	varset_1_o_reg53,
	varset_1_o_reg54,
	varset_1_o_reg55,
	varset_1_o_reg56,
	varset_1_o_reg57,
	varset_1_o_reg58,
	varset_1_o_reg59);	

	input		clk_clk;
	output		dac_rst_export;
	output		epcs_dclk;
	output		epcs_sce;
	output		epcs_sdo;
	input		epcs_data0;
	input		reset_reset_n;
	output	[11:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	input		spi_adc_MISO;
	output		spi_adc_MOSI;
	output		spi_adc_SCLK;
	output		spi_adc_SS_n;
	input		spi_dac_MISO;
	output		spi_dac_MOSI;
	output		spi_dac_SCLK;
	output		spi_dac_SS_n;
	input		sync_in_export;
	input		uart_rxd;
	output		uart_txd;
	input		uart_dbg_rxd;
	output		uart_dbg_txd;
	input	[31:0]	varset_1_i_var0;
	input	[31:0]	varset_1_i_var1;
	input	[31:0]	varset_1_i_var2;
	input	[31:0]	varset_1_i_var3;
	input	[31:0]	varset_1_i_var4;
	input	[31:0]	varset_1_i_var5;
	input	[31:0]	varset_1_i_var6;
	input	[31:0]	varset_1_i_var7;
	input	[31:0]	varset_1_i_var8;
	input	[31:0]	varset_1_i_var9;
	input	[31:0]	varset_1_i_var10;
	input	[31:0]	varset_1_i_var11;
	input	[31:0]	varset_1_i_var12;
	input	[31:0]	varset_1_i_var13;
	input	[31:0]	varset_1_i_var14;
	input	[31:0]	varset_1_i_var15;
	input	[31:0]	varset_1_i_var16;
	input	[31:0]	varset_1_i_var17;
	input	[31:0]	varset_1_i_var18;
	input	[31:0]	varset_1_i_var19;
	input	[31:0]	varset_1_i_var20;
	input	[31:0]	varset_1_i_var21;
	input	[31:0]	varset_1_i_var22;
	input	[31:0]	varset_1_i_var23;
	input	[31:0]	varset_1_i_var24;
	input	[31:0]	varset_1_i_var25;
	input	[31:0]	varset_1_i_var26;
	input	[31:0]	varset_1_i_var27;
	input	[31:0]	varset_1_i_var28;
	input	[31:0]	varset_1_i_var29;
	input	[31:0]	varset_1_i_var30;
	input	[31:0]	varset_1_i_var31;
	input	[31:0]	varset_1_i_var32;
	input	[31:0]	varset_1_i_var33;
	input	[31:0]	varset_1_i_var34;
	input	[31:0]	varset_1_i_var35;
	input	[31:0]	varset_1_i_var36;
	input	[31:0]	varset_1_i_var37;
	input	[31:0]	varset_1_i_var38;
	input	[31:0]	varset_1_i_var39;
	input	[31:0]	varset_1_i_var40;
	input	[31:0]	varset_1_i_var41;
	input	[31:0]	varset_1_i_var42;
	input	[31:0]	varset_1_i_var43;
	input	[31:0]	varset_1_i_var44;
	input	[31:0]	varset_1_i_var45;
	input	[31:0]	varset_1_i_var46;
	input	[31:0]	varset_1_i_var47;
	input	[31:0]	varset_1_i_var48;
	input	[31:0]	varset_1_i_var49;
	input	[31:0]	varset_1_i_var50;
	input	[31:0]	varset_1_i_var51;
	input	[31:0]	varset_1_i_var52;
	input	[31:0]	varset_1_i_var53;
	input	[31:0]	varset_1_i_var54;
	input	[31:0]	varset_1_i_var55;
	input	[31:0]	varset_1_i_var56;
	input	[31:0]	varset_1_i_var57;
	input	[31:0]	varset_1_i_var58;
	input	[31:0]	varset_1_i_var59;
	output	[31:0]	varset_1_o_reg0;
	output	[31:0]	varset_1_o_reg1;
	output	[31:0]	varset_1_o_reg2;
	output	[31:0]	varset_1_o_reg3;
	output	[31:0]	varset_1_o_reg4;
	output	[31:0]	varset_1_o_reg5;
	output	[31:0]	varset_1_o_reg6;
	output	[31:0]	varset_1_o_reg7;
	output	[31:0]	varset_1_o_reg8;
	output	[31:0]	varset_1_o_reg9;
	output	[31:0]	varset_1_o_reg10;
	output	[31:0]	varset_1_o_reg11;
	output	[31:0]	varset_1_o_reg12;
	output	[31:0]	varset_1_o_reg13;
	output	[31:0]	varset_1_o_reg14;
	output	[31:0]	varset_1_o_reg15;
	output	[31:0]	varset_1_o_reg16;
	output	[31:0]	varset_1_o_reg17;
	output	[31:0]	varset_1_o_reg18;
	output	[31:0]	varset_1_o_reg19;
	output	[31:0]	varset_1_o_reg20;
	output	[31:0]	varset_1_o_reg21;
	output	[31:0]	varset_1_o_reg22;
	output	[31:0]	varset_1_o_reg23;
	output	[31:0]	varset_1_o_reg24;
	output	[31:0]	varset_1_o_reg25;
	output	[31:0]	varset_1_o_reg26;
	output	[31:0]	varset_1_o_reg27;
	output	[31:0]	varset_1_o_reg28;
	output	[31:0]	varset_1_o_reg29;
	output	[31:0]	varset_1_o_reg30;
	output	[31:0]	varset_1_o_reg31;
	output	[31:0]	varset_1_o_reg32;
	output	[31:0]	varset_1_o_reg33;
	output	[31:0]	varset_1_o_reg34;
	output	[31:0]	varset_1_o_reg35;
	output	[31:0]	varset_1_o_reg36;
	output	[31:0]	varset_1_o_reg37;
	output	[31:0]	varset_1_o_reg38;
	output	[31:0]	varset_1_o_reg39;
	output	[31:0]	varset_1_o_reg40;
	output	[31:0]	varset_1_o_reg41;
	output	[31:0]	varset_1_o_reg42;
	output	[31:0]	varset_1_o_reg43;
	output	[31:0]	varset_1_o_reg44;
	output	[31:0]	varset_1_o_reg45;
	output	[31:0]	varset_1_o_reg46;
	output	[31:0]	varset_1_o_reg47;
	output	[31:0]	varset_1_o_reg48;
	output	[31:0]	varset_1_o_reg49;
	output	[31:0]	varset_1_o_reg50;
	output	[31:0]	varset_1_o_reg51;
	output	[31:0]	varset_1_o_reg52;
	output	[31:0]	varset_1_o_reg53;
	output	[31:0]	varset_1_o_reg54;
	output	[31:0]	varset_1_o_reg55;
	output	[31:0]	varset_1_o_reg56;
	output	[31:0]	varset_1_o_reg57;
	output	[31:0]	varset_1_o_reg58;
	output	[31:0]	varset_1_o_reg59;
endmodule
