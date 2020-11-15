//Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2017.2 (lin64) Build 1909853 Thu Jun 15 18:39:10 MDT 2017
//Date        : Wed Aug 29 15:42:43 2018
//Host        : quantaser-VirtualBox running 64-bit Ubuntu 16.04.5 LTS
//Command     : generate_target system_wrapper.bd
//Design      : system_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module system_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FCLK_CLK0,
    FCLK_CLK1,
    FCLK_CLK2,
    FCLK_CLK3,
    FCLK_RESET0_N,
    FCLK_RESET1_N,
    FCLK_RESET2_N,
    FCLK_RESET3_N,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    M_AXI_GP0_ACLK,
    M_AXI_GP0_araddr,
    M_AXI_GP0_arburst,
    M_AXI_GP0_arcache,
    M_AXI_GP0_arid,
    M_AXI_GP0_arlen,
    M_AXI_GP0_arlock,
    M_AXI_GP0_arprot,
    M_AXI_GP0_arqos,
    M_AXI_GP0_arready,
    M_AXI_GP0_arsize,
    M_AXI_GP0_arvalid,
    M_AXI_GP0_awaddr,
    M_AXI_GP0_awburst,
    M_AXI_GP0_awcache,
    M_AXI_GP0_awid,
    M_AXI_GP0_awlen,
    M_AXI_GP0_awlock,
    M_AXI_GP0_awprot,
    M_AXI_GP0_awqos,
    M_AXI_GP0_awready,
    M_AXI_GP0_awsize,
    M_AXI_GP0_awvalid,
    M_AXI_GP0_bid,
    M_AXI_GP0_bready,
    M_AXI_GP0_bresp,
    M_AXI_GP0_bvalid,
    M_AXI_GP0_rdata,
    M_AXI_GP0_rid,
    M_AXI_GP0_rlast,
    M_AXI_GP0_rready,
    M_AXI_GP0_rresp,
    M_AXI_GP0_rvalid,
    M_AXI_GP0_wdata,
    M_AXI_GP0_wid,
    M_AXI_GP0_wlast,
    M_AXI_GP0_wready,
    M_AXI_GP0_wstrb,
    M_AXI_GP0_wvalid,
    Vaux0_v_n,
    Vaux0_v_p,
    Vaux1_v_n,
    Vaux1_v_p,
    Vaux8_v_n,
    Vaux8_v_p,
    Vaux9_v_n,
    Vaux9_v_p,
    Vp_Vn_v_n,
    Vp_Vn_v_p,
    gpio_tri_io,
    spi0_io0_io,
    spi0_io1_io,
    spi0_sck_io,
    spi0_ss1_o,
    spi0_ss2_o,
    spi0_ss_io);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  output FCLK_CLK0;
  output FCLK_CLK1;
  output FCLK_CLK2;
  output FCLK_CLK3;
  output FCLK_RESET0_N;
  output FCLK_RESET1_N;
  output FCLK_RESET2_N;
  output FCLK_RESET3_N;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input M_AXI_GP0_ACLK;
  output [31:0]M_AXI_GP0_araddr;
  output [1:0]M_AXI_GP0_arburst;
  output [3:0]M_AXI_GP0_arcache;
  output [11:0]M_AXI_GP0_arid;
  output [3:0]M_AXI_GP0_arlen;
  output [1:0]M_AXI_GP0_arlock;
  output [2:0]M_AXI_GP0_arprot;
  output [3:0]M_AXI_GP0_arqos;
  input M_AXI_GP0_arready;
  output [2:0]M_AXI_GP0_arsize;
  output M_AXI_GP0_arvalid;
  output [31:0]M_AXI_GP0_awaddr;
  output [1:0]M_AXI_GP0_awburst;
  output [3:0]M_AXI_GP0_awcache;
  output [11:0]M_AXI_GP0_awid;
  output [3:0]M_AXI_GP0_awlen;
  output [1:0]M_AXI_GP0_awlock;
  output [2:0]M_AXI_GP0_awprot;
  output [3:0]M_AXI_GP0_awqos;
  input M_AXI_GP0_awready;
  output [2:0]M_AXI_GP0_awsize;
  output M_AXI_GP0_awvalid;
  input [11:0]M_AXI_GP0_bid;
  output M_AXI_GP0_bready;
  input [1:0]M_AXI_GP0_bresp;
  input M_AXI_GP0_bvalid;
  input [31:0]M_AXI_GP0_rdata;
  input [11:0]M_AXI_GP0_rid;
  input M_AXI_GP0_rlast;
  output M_AXI_GP0_rready;
  input [1:0]M_AXI_GP0_rresp;
  input M_AXI_GP0_rvalid;
  output [31:0]M_AXI_GP0_wdata;
  output [11:0]M_AXI_GP0_wid;
  output M_AXI_GP0_wlast;
  input M_AXI_GP0_wready;
  output [3:0]M_AXI_GP0_wstrb;
  output M_AXI_GP0_wvalid;
  input Vaux0_v_n;
  input Vaux0_v_p;
  input Vaux1_v_n;
  input Vaux1_v_p;
  input Vaux8_v_n;
  input Vaux8_v_p;
  input Vaux9_v_n;
  input Vaux9_v_p;
  input Vp_Vn_v_n;
  input Vp_Vn_v_p;
  inout [23:0]gpio_tri_io;
  inout spi0_io0_io;
  inout spi0_io1_io;
  inout spi0_sck_io;
  output spi0_ss1_o;
  output spi0_ss2_o;
  inout spi0_ss_io;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FCLK_CLK0;
  wire FCLK_CLK1;
  wire FCLK_CLK2;
  wire FCLK_CLK3;
  wire FCLK_RESET0_N;
  wire FCLK_RESET1_N;
  wire FCLK_RESET2_N;
  wire FCLK_RESET3_N;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire M_AXI_GP0_ACLK;
  wire [31:0]M_AXI_GP0_araddr;
  wire [1:0]M_AXI_GP0_arburst;
  wire [3:0]M_AXI_GP0_arcache;
  wire [11:0]M_AXI_GP0_arid;
  wire [3:0]M_AXI_GP0_arlen;
  wire [1:0]M_AXI_GP0_arlock;
  wire [2:0]M_AXI_GP0_arprot;
  wire [3:0]M_AXI_GP0_arqos;
  wire M_AXI_GP0_arready;
  wire [2:0]M_AXI_GP0_arsize;
  wire M_AXI_GP0_arvalid;
  wire [31:0]M_AXI_GP0_awaddr;
  wire [1:0]M_AXI_GP0_awburst;
  wire [3:0]M_AXI_GP0_awcache;
  wire [11:0]M_AXI_GP0_awid;
  wire [3:0]M_AXI_GP0_awlen;
  wire [1:0]M_AXI_GP0_awlock;
  wire [2:0]M_AXI_GP0_awprot;
  wire [3:0]M_AXI_GP0_awqos;
  wire M_AXI_GP0_awready;
  wire [2:0]M_AXI_GP0_awsize;
  wire M_AXI_GP0_awvalid;
  wire [11:0]M_AXI_GP0_bid;
  wire M_AXI_GP0_bready;
  wire [1:0]M_AXI_GP0_bresp;
  wire M_AXI_GP0_bvalid;
  wire [31:0]M_AXI_GP0_rdata;
  wire [11:0]M_AXI_GP0_rid;
  wire M_AXI_GP0_rlast;
  wire M_AXI_GP0_rready;
  wire [1:0]M_AXI_GP0_rresp;
  wire M_AXI_GP0_rvalid;
  wire [31:0]M_AXI_GP0_wdata;
  wire [11:0]M_AXI_GP0_wid;
  wire M_AXI_GP0_wlast;
  wire M_AXI_GP0_wready;
  wire [3:0]M_AXI_GP0_wstrb;
  wire M_AXI_GP0_wvalid;
  wire Vaux0_v_n;
  wire Vaux0_v_p;
  wire Vaux1_v_n;
  wire Vaux1_v_p;
  wire Vaux8_v_n;
  wire Vaux8_v_p;
  wire Vaux9_v_n;
  wire Vaux9_v_p;
  wire Vp_Vn_v_n;
  wire Vp_Vn_v_p;
  wire [0:0]gpio_tri_i_0;
  wire [1:1]gpio_tri_i_1;
  wire [10:10]gpio_tri_i_10;
  wire [11:11]gpio_tri_i_11;
  wire [12:12]gpio_tri_i_12;
  wire [13:13]gpio_tri_i_13;
  wire [14:14]gpio_tri_i_14;
  wire [15:15]gpio_tri_i_15;
  wire [16:16]gpio_tri_i_16;
  wire [17:17]gpio_tri_i_17;
  wire [18:18]gpio_tri_i_18;
  wire [19:19]gpio_tri_i_19;
  wire [2:2]gpio_tri_i_2;
  wire [20:20]gpio_tri_i_20;
  wire [21:21]gpio_tri_i_21;
  wire [22:22]gpio_tri_i_22;
  wire [23:23]gpio_tri_i_23;
  wire [3:3]gpio_tri_i_3;
  wire [4:4]gpio_tri_i_4;
  wire [5:5]gpio_tri_i_5;
  wire [6:6]gpio_tri_i_6;
  wire [7:7]gpio_tri_i_7;
  wire [8:8]gpio_tri_i_8;
  wire [9:9]gpio_tri_i_9;
  wire [0:0]gpio_tri_io_0;
  wire [1:1]gpio_tri_io_1;
  wire [10:10]gpio_tri_io_10;
  wire [11:11]gpio_tri_io_11;
  wire [12:12]gpio_tri_io_12;
  wire [13:13]gpio_tri_io_13;
  wire [14:14]gpio_tri_io_14;
  wire [15:15]gpio_tri_io_15;
  wire [16:16]gpio_tri_io_16;
  wire [17:17]gpio_tri_io_17;
  wire [18:18]gpio_tri_io_18;
  wire [19:19]gpio_tri_io_19;
  wire [2:2]gpio_tri_io_2;
  wire [20:20]gpio_tri_io_20;
  wire [21:21]gpio_tri_io_21;
  wire [22:22]gpio_tri_io_22;
  wire [23:23]gpio_tri_io_23;
  wire [3:3]gpio_tri_io_3;
  wire [4:4]gpio_tri_io_4;
  wire [5:5]gpio_tri_io_5;
  wire [6:6]gpio_tri_io_6;
  wire [7:7]gpio_tri_io_7;
  wire [8:8]gpio_tri_io_8;
  wire [9:9]gpio_tri_io_9;
  wire [0:0]gpio_tri_o_0;
  wire [1:1]gpio_tri_o_1;
  wire [10:10]gpio_tri_o_10;
  wire [11:11]gpio_tri_o_11;
  wire [12:12]gpio_tri_o_12;
  wire [13:13]gpio_tri_o_13;
  wire [14:14]gpio_tri_o_14;
  wire [15:15]gpio_tri_o_15;
  wire [16:16]gpio_tri_o_16;
  wire [17:17]gpio_tri_o_17;
  wire [18:18]gpio_tri_o_18;
  wire [19:19]gpio_tri_o_19;
  wire [2:2]gpio_tri_o_2;
  wire [20:20]gpio_tri_o_20;
  wire [21:21]gpio_tri_o_21;
  wire [22:22]gpio_tri_o_22;
  wire [23:23]gpio_tri_o_23;
  wire [3:3]gpio_tri_o_3;
  wire [4:4]gpio_tri_o_4;
  wire [5:5]gpio_tri_o_5;
  wire [6:6]gpio_tri_o_6;
  wire [7:7]gpio_tri_o_7;
  wire [8:8]gpio_tri_o_8;
  wire [9:9]gpio_tri_o_9;
  wire [0:0]gpio_tri_t_0;
  wire [1:1]gpio_tri_t_1;
  wire [10:10]gpio_tri_t_10;
  wire [11:11]gpio_tri_t_11;
  wire [12:12]gpio_tri_t_12;
  wire [13:13]gpio_tri_t_13;
  wire [14:14]gpio_tri_t_14;
  wire [15:15]gpio_tri_t_15;
  wire [16:16]gpio_tri_t_16;
  wire [17:17]gpio_tri_t_17;
  wire [18:18]gpio_tri_t_18;
  wire [19:19]gpio_tri_t_19;
  wire [2:2]gpio_tri_t_2;
  wire [20:20]gpio_tri_t_20;
  wire [21:21]gpio_tri_t_21;
  wire [22:22]gpio_tri_t_22;
  wire [23:23]gpio_tri_t_23;
  wire [3:3]gpio_tri_t_3;
  wire [4:4]gpio_tri_t_4;
  wire [5:5]gpio_tri_t_5;
  wire [6:6]gpio_tri_t_6;
  wire [7:7]gpio_tri_t_7;
  wire [8:8]gpio_tri_t_8;
  wire [9:9]gpio_tri_t_9;
  wire spi0_io0_i;
  wire spi0_io0_io;
  wire spi0_io0_o;
  wire spi0_io0_t;
  wire spi0_io1_i;
  wire spi0_io1_io;
  wire spi0_io1_o;
  wire spi0_io1_t;
  wire spi0_sck_i;
  wire spi0_sck_io;
  wire spi0_sck_o;
  wire spi0_sck_t;
  wire spi0_ss1_o;
  wire spi0_ss2_o;
  wire spi0_ss_i;
  wire spi0_ss_io;
  wire spi0_ss_o;
  wire spi0_ss_t;

  IOBUF gpio_tri_iobuf_0
       (.I(gpio_tri_o_0),
        .IO(gpio_tri_io[0]),
        .O(gpio_tri_i_0),
        .T(gpio_tri_t_0));
  IOBUF gpio_tri_iobuf_1
       (.I(gpio_tri_o_1),
        .IO(gpio_tri_io[1]),
        .O(gpio_tri_i_1),
        .T(gpio_tri_t_1));
  IOBUF gpio_tri_iobuf_10
       (.I(gpio_tri_o_10),
        .IO(gpio_tri_io[10]),
        .O(gpio_tri_i_10),
        .T(gpio_tri_t_10));
  IOBUF gpio_tri_iobuf_11
       (.I(gpio_tri_o_11),
        .IO(gpio_tri_io[11]),
        .O(gpio_tri_i_11),
        .T(gpio_tri_t_11));
  IOBUF gpio_tri_iobuf_12
       (.I(gpio_tri_o_12),
        .IO(gpio_tri_io[12]),
        .O(gpio_tri_i_12),
        .T(gpio_tri_t_12));
  IOBUF gpio_tri_iobuf_13
       (.I(gpio_tri_o_13),
        .IO(gpio_tri_io[13]),
        .O(gpio_tri_i_13),
        .T(gpio_tri_t_13));
  IOBUF gpio_tri_iobuf_14
       (.I(gpio_tri_o_14),
        .IO(gpio_tri_io[14]),
        .O(gpio_tri_i_14),
        .T(gpio_tri_t_14));
  IOBUF gpio_tri_iobuf_15
       (.I(gpio_tri_o_15),
        .IO(gpio_tri_io[15]),
        .O(gpio_tri_i_15),
        .T(gpio_tri_t_15));
  IOBUF gpio_tri_iobuf_16
       (.I(gpio_tri_o_16),
        .IO(gpio_tri_io[16]),
        .O(gpio_tri_i_16),
        .T(gpio_tri_t_16));
  IOBUF gpio_tri_iobuf_17
       (.I(gpio_tri_o_17),
        .IO(gpio_tri_io[17]),
        .O(gpio_tri_i_17),
        .T(gpio_tri_t_17));
  IOBUF gpio_tri_iobuf_18
       (.I(gpio_tri_o_18),
        .IO(gpio_tri_io[18]),
        .O(gpio_tri_i_18),
        .T(gpio_tri_t_18));
  IOBUF gpio_tri_iobuf_19
       (.I(gpio_tri_o_19),
        .IO(gpio_tri_io[19]),
        .O(gpio_tri_i_19),
        .T(gpio_tri_t_19));
  IOBUF gpio_tri_iobuf_2
       (.I(gpio_tri_o_2),
        .IO(gpio_tri_io[2]),
        .O(gpio_tri_i_2),
        .T(gpio_tri_t_2));
  IOBUF gpio_tri_iobuf_20
       (.I(gpio_tri_o_20),
        .IO(gpio_tri_io[20]),
        .O(gpio_tri_i_20),
        .T(gpio_tri_t_20));
  IOBUF gpio_tri_iobuf_21
       (.I(gpio_tri_o_21),
        .IO(gpio_tri_io[21]),
        .O(gpio_tri_i_21),
        .T(gpio_tri_t_21));
  IOBUF gpio_tri_iobuf_22
       (.I(gpio_tri_o_22),
        .IO(gpio_tri_io[22]),
        .O(gpio_tri_i_22),
        .T(gpio_tri_t_22));
  IOBUF gpio_tri_iobuf_23
       (.I(gpio_tri_o_23),
        .IO(gpio_tri_io[23]),
        .O(gpio_tri_i_23),
        .T(gpio_tri_t_23));
  IOBUF gpio_tri_iobuf_3
       (.I(gpio_tri_o_3),
        .IO(gpio_tri_io[3]),
        .O(gpio_tri_i_3),
        .T(gpio_tri_t_3));
  IOBUF gpio_tri_iobuf_4
       (.I(gpio_tri_o_4),
        .IO(gpio_tri_io[4]),
        .O(gpio_tri_i_4),
        .T(gpio_tri_t_4));
  IOBUF gpio_tri_iobuf_5
       (.I(gpio_tri_o_5),
        .IO(gpio_tri_io[5]),
        .O(gpio_tri_i_5),
        .T(gpio_tri_t_5));
  IOBUF gpio_tri_iobuf_6
       (.I(gpio_tri_o_6),
        .IO(gpio_tri_io[6]),
        .O(gpio_tri_i_6),
        .T(gpio_tri_t_6));
  IOBUF gpio_tri_iobuf_7
       (.I(gpio_tri_o_7),
        .IO(gpio_tri_io[7]),
        .O(gpio_tri_i_7),
        .T(gpio_tri_t_7));
  IOBUF gpio_tri_iobuf_8
       (.I(gpio_tri_o_8),
        .IO(gpio_tri_io[8]),
        .O(gpio_tri_i_8),
        .T(gpio_tri_t_8));
  IOBUF gpio_tri_iobuf_9
       (.I(gpio_tri_o_9),
        .IO(gpio_tri_io[9]),
        .O(gpio_tri_i_9),
        .T(gpio_tri_t_9));
  IOBUF spi0_io0_iobuf
       (.I(spi0_io0_o),
        .IO(spi0_io0_io),
        .O(spi0_io0_i),
        .T(spi0_io0_t));
  IOBUF spi0_io1_iobuf
       (.I(spi0_io1_o),
        .IO(spi0_io1_io),
        .O(spi0_io1_i),
        .T(spi0_io1_t));
  IOBUF spi0_sck_iobuf
       (.I(spi0_sck_o),
        .IO(spi0_sck_io),
        .O(spi0_sck_i),
        .T(spi0_sck_t));
  IOBUF spi0_ss_iobuf
       (.I(spi0_ss_o),
        .IO(spi0_ss_io),
        .O(spi0_ss_i),
        .T(spi0_ss_t));
  system system_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK0(FCLK_CLK0),
        .FCLK_CLK1(FCLK_CLK1),
        .FCLK_CLK2(FCLK_CLK2),
        .FCLK_CLK3(FCLK_CLK3),
        .FCLK_RESET0_N(FCLK_RESET0_N),
        .FCLK_RESET1_N(FCLK_RESET1_N),
        .FCLK_RESET2_N(FCLK_RESET2_N),
        .FCLK_RESET3_N(FCLK_RESET3_N),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .GPIO_tri_i({gpio_tri_i_23,gpio_tri_i_22,gpio_tri_i_21,gpio_tri_i_20,gpio_tri_i_19,gpio_tri_i_18,gpio_tri_i_17,gpio_tri_i_16,gpio_tri_i_15,gpio_tri_i_14,gpio_tri_i_13,gpio_tri_i_12,gpio_tri_i_11,gpio_tri_i_10,gpio_tri_i_9,gpio_tri_i_8,gpio_tri_i_7,gpio_tri_i_6,gpio_tri_i_5,gpio_tri_i_4,gpio_tri_i_3,gpio_tri_i_2,gpio_tri_i_1,gpio_tri_i_0}),
        .GPIO_tri_o({gpio_tri_o_23,gpio_tri_o_22,gpio_tri_o_21,gpio_tri_o_20,gpio_tri_o_19,gpio_tri_o_18,gpio_tri_o_17,gpio_tri_o_16,gpio_tri_o_15,gpio_tri_o_14,gpio_tri_o_13,gpio_tri_o_12,gpio_tri_o_11,gpio_tri_o_10,gpio_tri_o_9,gpio_tri_o_8,gpio_tri_o_7,gpio_tri_o_6,gpio_tri_o_5,gpio_tri_o_4,gpio_tri_o_3,gpio_tri_o_2,gpio_tri_o_1,gpio_tri_o_0}),
        .GPIO_tri_t({gpio_tri_t_23,gpio_tri_t_22,gpio_tri_t_21,gpio_tri_t_20,gpio_tri_t_19,gpio_tri_t_18,gpio_tri_t_17,gpio_tri_t_16,gpio_tri_t_15,gpio_tri_t_14,gpio_tri_t_13,gpio_tri_t_12,gpio_tri_t_11,gpio_tri_t_10,gpio_tri_t_9,gpio_tri_t_8,gpio_tri_t_7,gpio_tri_t_6,gpio_tri_t_5,gpio_tri_t_4,gpio_tri_t_3,gpio_tri_t_2,gpio_tri_t_1,gpio_tri_t_0}),
        .M_AXI_GP0_ACLK(M_AXI_GP0_ACLK),
        .M_AXI_GP0_araddr(M_AXI_GP0_araddr),
        .M_AXI_GP0_arburst(M_AXI_GP0_arburst),
        .M_AXI_GP0_arcache(M_AXI_GP0_arcache),
        .M_AXI_GP0_arid(M_AXI_GP0_arid),
        .M_AXI_GP0_arlen(M_AXI_GP0_arlen),
        .M_AXI_GP0_arlock(M_AXI_GP0_arlock),
        .M_AXI_GP0_arprot(M_AXI_GP0_arprot),
        .M_AXI_GP0_arqos(M_AXI_GP0_arqos),
        .M_AXI_GP0_arready(M_AXI_GP0_arready),
        .M_AXI_GP0_arsize(M_AXI_GP0_arsize),
        .M_AXI_GP0_arvalid(M_AXI_GP0_arvalid),
        .M_AXI_GP0_awaddr(M_AXI_GP0_awaddr),
        .M_AXI_GP0_awburst(M_AXI_GP0_awburst),
        .M_AXI_GP0_awcache(M_AXI_GP0_awcache),
        .M_AXI_GP0_awid(M_AXI_GP0_awid),
        .M_AXI_GP0_awlen(M_AXI_GP0_awlen),
        .M_AXI_GP0_awlock(M_AXI_GP0_awlock),
        .M_AXI_GP0_awprot(M_AXI_GP0_awprot),
        .M_AXI_GP0_awqos(M_AXI_GP0_awqos),
        .M_AXI_GP0_awready(M_AXI_GP0_awready),
        .M_AXI_GP0_awsize(M_AXI_GP0_awsize),
        .M_AXI_GP0_awvalid(M_AXI_GP0_awvalid),
        .M_AXI_GP0_bid(M_AXI_GP0_bid),
        .M_AXI_GP0_bready(M_AXI_GP0_bready),
        .M_AXI_GP0_bresp(M_AXI_GP0_bresp),
        .M_AXI_GP0_bvalid(M_AXI_GP0_bvalid),
        .M_AXI_GP0_rdata(M_AXI_GP0_rdata),
        .M_AXI_GP0_rid(M_AXI_GP0_rid),
        .M_AXI_GP0_rlast(M_AXI_GP0_rlast),
        .M_AXI_GP0_rready(M_AXI_GP0_rready),
        .M_AXI_GP0_rresp(M_AXI_GP0_rresp),
        .M_AXI_GP0_rvalid(M_AXI_GP0_rvalid),
        .M_AXI_GP0_wdata(M_AXI_GP0_wdata),
        .M_AXI_GP0_wid(M_AXI_GP0_wid),
        .M_AXI_GP0_wlast(M_AXI_GP0_wlast),
        .M_AXI_GP0_wready(M_AXI_GP0_wready),
        .M_AXI_GP0_wstrb(M_AXI_GP0_wstrb),
        .M_AXI_GP0_wvalid(M_AXI_GP0_wvalid),
        .SPI0_io0_i(spi0_io0_i),
        .SPI0_io0_o(spi0_io0_o),
        .SPI0_io0_t(spi0_io0_t),
        .SPI0_io1_i(spi0_io1_i),
        .SPI0_io1_o(spi0_io1_o),
        .SPI0_io1_t(spi0_io1_t),
        .SPI0_sck_i(spi0_sck_i),
        .SPI0_sck_o(spi0_sck_o),
        .SPI0_sck_t(spi0_sck_t),
        .SPI0_ss1_o(spi0_ss1_o),
        .SPI0_ss2_o(spi0_ss2_o),
        .SPI0_ss_i(spi0_ss_i),
        .SPI0_ss_o(spi0_ss_o),
        .SPI0_ss_t(spi0_ss_t),
        .Vaux0_v_n(Vaux0_v_n),
        .Vaux0_v_p(Vaux0_v_p),
        .Vaux1_v_n(Vaux1_v_n),
        .Vaux1_v_p(Vaux1_v_p),
        .Vaux8_v_n(Vaux8_v_n),
        .Vaux8_v_p(Vaux8_v_p),
        .Vaux9_v_n(Vaux9_v_n),
        .Vaux9_v_p(Vaux9_v_p),
        .Vp_Vn_v_n(Vp_Vn_v_n),
        .Vp_Vn_v_p(Vp_Vn_v_p));
endmodule
