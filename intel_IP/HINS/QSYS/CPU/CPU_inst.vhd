	component CPU is
		port (
			clk_clk                  : in    std_logic                     := 'X';             -- clk
			dac_rst_export           : out   std_logic;                                        -- export
			epcs_dclk                : out   std_logic;                                        -- dclk
			epcs_sce                 : out   std_logic;                                        -- sce
			epcs_sdo                 : out   std_logic;                                        -- sdo
			epcs_data0               : in    std_logic                     := 'X';             -- data0
			reset_reset_n            : in    std_logic                     := 'X';             -- reset_n
			sdram_addr               : out   std_logic_vector(11 downto 0);                    -- addr
			sdram_ba                 : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n              : out   std_logic;                                        -- cas_n
			sdram_cke                : out   std_logic;                                        -- cke
			sdram_cs_n               : out   std_logic;                                        -- cs_n
			sdram_dq                 : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_dqm                : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_ras_n              : out   std_logic;                                        -- ras_n
			sdram_we_n               : out   std_logic;                                        -- we_n
			spi_adc_MISO             : in    std_logic                     := 'X';             -- MISO
			spi_adc_MOSI             : out   std_logic;                                        -- MOSI
			spi_adc_SCLK             : out   std_logic;                                        -- SCLK
			spi_adc_SS_n             : out   std_logic;                                        -- SS_n
			spi_dac_MISO             : in    std_logic                     := 'X';             -- MISO
			spi_dac_MOSI             : out   std_logic;                                        -- MOSI
			spi_dac_SCLK             : out   std_logic;                                        -- SCLK
			spi_dac_SS_n             : out   std_logic;                                        -- SS_n
			sync_in_export           : in    std_logic                     := 'X';             -- export
			uart_rxd                 : in    std_logic                     := 'X';             -- rxd
			uart_txd                 : out   std_logic;                                        -- txd
			uart_dbg_rxd             : in    std_logic                     := 'X';             -- rxd
			uart_dbg_txd             : out   std_logic;                                        -- txd
			varset_1_i_var0          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var0
			varset_1_i_var1          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var1
			varset_1_i_var2          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var2
			varset_1_i_var3          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var3
			varset_1_i_var4          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var4
			varset_1_i_var5          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var5
			varset_1_i_var6          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var6
			varset_1_i_var7          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var7
			varset_1_i_var8          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var8
			varset_1_i_var9          : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var9
			varset_1_i_var10         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var10
			varset_1_i_var11         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var11
			varset_1_i_var12         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var12
			varset_1_i_var13         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var13
			varset_1_i_var14         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var14
			varset_1_i_var15         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var15
			varset_1_i_var16         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var16
			varset_1_i_var17         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var17
			varset_1_i_var18         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var18
			varset_1_i_var19         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var19
			varset_1_i_var20         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var20
			varset_1_i_var21         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var21
			varset_1_i_var22         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var22
			varset_1_i_var23         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var23
			varset_1_i_var24         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var24
			varset_1_i_var25         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var25
			varset_1_i_var26         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var26
			varset_1_i_var27         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var27
			varset_1_i_var28         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var28
			varset_1_i_var29         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var29
			varset_1_i_var30         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var30
			varset_1_i_var31         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var31
			varset_1_i_var32         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var32
			varset_1_i_var33         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var33
			varset_1_i_var34         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var34
			varset_1_i_var35         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var35
			varset_1_i_var36         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var36
			varset_1_i_var37         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var37
			varset_1_i_var38         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var38
			varset_1_i_var39         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var39
			varset_1_i_var40         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var40
			varset_1_i_var41         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var41
			varset_1_i_var42         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var42
			varset_1_i_var43         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var43
			varset_1_i_var44         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var44
			varset_1_i_var45         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var45
			varset_1_i_var46         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var46
			varset_1_i_var47         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var47
			varset_1_i_var48         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var48
			varset_1_i_var49         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var49
			varset_1_i_var50         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var50
			varset_1_i_var51         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var51
			varset_1_i_var52         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var52
			varset_1_i_var53         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var53
			varset_1_i_var54         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var54
			varset_1_i_var55         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var55
			varset_1_i_var56         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var56
			varset_1_i_var57         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var57
			varset_1_i_var58         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var58
			varset_1_i_var59         : in    std_logic_vector(31 downto 0) := (others => 'X'); -- i_var59
			varset_1_o_reg0          : out   std_logic_vector(31 downto 0);                    -- o_reg0
			varset_1_o_reg1          : out   std_logic_vector(31 downto 0);                    -- o_reg1
			varset_1_o_reg2          : out   std_logic_vector(31 downto 0);                    -- o_reg2
			varset_1_o_reg3          : out   std_logic_vector(31 downto 0);                    -- o_reg3
			varset_1_o_reg4          : out   std_logic_vector(31 downto 0);                    -- o_reg4
			varset_1_o_reg5          : out   std_logic_vector(31 downto 0);                    -- o_reg5
			varset_1_o_reg6          : out   std_logic_vector(31 downto 0);                    -- o_reg6
			varset_1_o_reg7          : out   std_logic_vector(31 downto 0);                    -- o_reg7
			varset_1_o_reg8          : out   std_logic_vector(31 downto 0);                    -- o_reg8
			varset_1_o_reg9          : out   std_logic_vector(31 downto 0);                    -- o_reg9
			varset_1_o_reg10         : out   std_logic_vector(31 downto 0);                    -- o_reg10
			varset_1_o_reg11         : out   std_logic_vector(31 downto 0);                    -- o_reg11
			varset_1_o_reg12         : out   std_logic_vector(31 downto 0);                    -- o_reg12
			varset_1_o_reg13         : out   std_logic_vector(31 downto 0);                    -- o_reg13
			varset_1_o_reg14         : out   std_logic_vector(31 downto 0);                    -- o_reg14
			varset_1_o_reg15         : out   std_logic_vector(31 downto 0);                    -- o_reg15
			varset_1_o_reg16         : out   std_logic_vector(31 downto 0);                    -- o_reg16
			varset_1_o_reg17         : out   std_logic_vector(31 downto 0);                    -- o_reg17
			varset_1_o_reg18         : out   std_logic_vector(31 downto 0);                    -- o_reg18
			varset_1_o_reg19         : out   std_logic_vector(31 downto 0);                    -- o_reg19
			varset_1_o_reg20         : out   std_logic_vector(31 downto 0);                    -- o_reg20
			varset_1_o_reg21         : out   std_logic_vector(31 downto 0);                    -- o_reg21
			varset_1_o_reg22         : out   std_logic_vector(31 downto 0);                    -- o_reg22
			varset_1_o_reg23         : out   std_logic_vector(31 downto 0);                    -- o_reg23
			varset_1_o_reg24         : out   std_logic_vector(31 downto 0);                    -- o_reg24
			varset_1_o_reg25         : out   std_logic_vector(31 downto 0);                    -- o_reg25
			varset_1_o_reg26         : out   std_logic_vector(31 downto 0);                    -- o_reg26
			varset_1_o_reg27         : out   std_logic_vector(31 downto 0);                    -- o_reg27
			varset_1_o_reg28         : out   std_logic_vector(31 downto 0);                    -- o_reg28
			varset_1_o_reg29         : out   std_logic_vector(31 downto 0);                    -- o_reg29
			varset_1_o_reg30         : out   std_logic_vector(31 downto 0);                    -- o_reg30
			varset_1_o_reg31         : out   std_logic_vector(31 downto 0);                    -- o_reg31
			varset_1_o_reg32         : out   std_logic_vector(31 downto 0);                    -- o_reg32
			varset_1_o_reg33         : out   std_logic_vector(31 downto 0);                    -- o_reg33
			varset_1_o_reg34         : out   std_logic_vector(31 downto 0);                    -- o_reg34
			varset_1_o_reg35         : out   std_logic_vector(31 downto 0);                    -- o_reg35
			varset_1_o_reg36         : out   std_logic_vector(31 downto 0);                    -- o_reg36
			varset_1_o_reg37         : out   std_logic_vector(31 downto 0);                    -- o_reg37
			varset_1_o_reg38         : out   std_logic_vector(31 downto 0);                    -- o_reg38
			varset_1_o_reg39         : out   std_logic_vector(31 downto 0);                    -- o_reg39
			varset_1_o_reg40         : out   std_logic_vector(31 downto 0);                    -- o_reg40
			varset_1_o_reg41         : out   std_logic_vector(31 downto 0);                    -- o_reg41
			varset_1_o_reg42         : out   std_logic_vector(31 downto 0);                    -- o_reg42
			varset_1_o_reg43         : out   std_logic_vector(31 downto 0);                    -- o_reg43
			varset_1_o_reg44         : out   std_logic_vector(31 downto 0);                    -- o_reg44
			varset_1_o_reg45         : out   std_logic_vector(31 downto 0);                    -- o_reg45
			varset_1_o_reg46         : out   std_logic_vector(31 downto 0);                    -- o_reg46
			varset_1_o_reg47         : out   std_logic_vector(31 downto 0);                    -- o_reg47
			varset_1_o_reg48         : out   std_logic_vector(31 downto 0);                    -- o_reg48
			varset_1_o_reg49         : out   std_logic_vector(31 downto 0);                    -- o_reg49
			varset_1_o_reg50         : out   std_logic_vector(31 downto 0);                    -- o_reg50
			varset_1_o_reg51         : out   std_logic_vector(31 downto 0);                    -- o_reg51
			varset_1_o_reg52         : out   std_logic_vector(31 downto 0);                    -- o_reg52
			varset_1_o_reg53         : out   std_logic_vector(31 downto 0);                    -- o_reg53
			varset_1_o_reg54         : out   std_logic_vector(31 downto 0);                    -- o_reg54
			varset_1_o_reg55         : out   std_logic_vector(31 downto 0);                    -- o_reg55
			varset_1_o_reg56         : out   std_logic_vector(31 downto 0);                    -- o_reg56
			varset_1_o_reg57         : out   std_logic_vector(31 downto 0);                    -- o_reg57
			varset_1_o_reg58         : out   std_logic_vector(31 downto 0);                    -- o_reg58
			varset_1_o_reg59         : out   std_logic_vector(31 downto 0);                    -- o_reg59
			varset_1_o_latch_trigger : out   std_logic                                         -- o_latch_trigger
		);
	end component CPU;

	u0 : component CPU
		port map (
			clk_clk                  => CONNECTED_TO_clk_clk,                  --      clk.clk
			dac_rst_export           => CONNECTED_TO_dac_rst_export,           --  dac_rst.export
			epcs_dclk                => CONNECTED_TO_epcs_dclk,                --     epcs.dclk
			epcs_sce                 => CONNECTED_TO_epcs_sce,                 --         .sce
			epcs_sdo                 => CONNECTED_TO_epcs_sdo,                 --         .sdo
			epcs_data0               => CONNECTED_TO_epcs_data0,               --         .data0
			reset_reset_n            => CONNECTED_TO_reset_reset_n,            --    reset.reset_n
			sdram_addr               => CONNECTED_TO_sdram_addr,               --    sdram.addr
			sdram_ba                 => CONNECTED_TO_sdram_ba,                 --         .ba
			sdram_cas_n              => CONNECTED_TO_sdram_cas_n,              --         .cas_n
			sdram_cke                => CONNECTED_TO_sdram_cke,                --         .cke
			sdram_cs_n               => CONNECTED_TO_sdram_cs_n,               --         .cs_n
			sdram_dq                 => CONNECTED_TO_sdram_dq,                 --         .dq
			sdram_dqm                => CONNECTED_TO_sdram_dqm,                --         .dqm
			sdram_ras_n              => CONNECTED_TO_sdram_ras_n,              --         .ras_n
			sdram_we_n               => CONNECTED_TO_sdram_we_n,               --         .we_n
			spi_adc_MISO             => CONNECTED_TO_spi_adc_MISO,             --  spi_adc.MISO
			spi_adc_MOSI             => CONNECTED_TO_spi_adc_MOSI,             --         .MOSI
			spi_adc_SCLK             => CONNECTED_TO_spi_adc_SCLK,             --         .SCLK
			spi_adc_SS_n             => CONNECTED_TO_spi_adc_SS_n,             --         .SS_n
			spi_dac_MISO             => CONNECTED_TO_spi_dac_MISO,             --  spi_dac.MISO
			spi_dac_MOSI             => CONNECTED_TO_spi_dac_MOSI,             --         .MOSI
			spi_dac_SCLK             => CONNECTED_TO_spi_dac_SCLK,             --         .SCLK
			spi_dac_SS_n             => CONNECTED_TO_spi_dac_SS_n,             --         .SS_n
			sync_in_export           => CONNECTED_TO_sync_in_export,           --  sync_in.export
			uart_rxd                 => CONNECTED_TO_uart_rxd,                 --     uart.rxd
			uart_txd                 => CONNECTED_TO_uart_txd,                 --         .txd
			uart_dbg_rxd             => CONNECTED_TO_uart_dbg_rxd,             -- uart_dbg.rxd
			uart_dbg_txd             => CONNECTED_TO_uart_dbg_txd,             --         .txd
			varset_1_i_var0          => CONNECTED_TO_varset_1_i_var0,          -- varset_1.i_var0
			varset_1_i_var1          => CONNECTED_TO_varset_1_i_var1,          --         .i_var1
			varset_1_i_var2          => CONNECTED_TO_varset_1_i_var2,          --         .i_var2
			varset_1_i_var3          => CONNECTED_TO_varset_1_i_var3,          --         .i_var3
			varset_1_i_var4          => CONNECTED_TO_varset_1_i_var4,          --         .i_var4
			varset_1_i_var5          => CONNECTED_TO_varset_1_i_var5,          --         .i_var5
			varset_1_i_var6          => CONNECTED_TO_varset_1_i_var6,          --         .i_var6
			varset_1_i_var7          => CONNECTED_TO_varset_1_i_var7,          --         .i_var7
			varset_1_i_var8          => CONNECTED_TO_varset_1_i_var8,          --         .i_var8
			varset_1_i_var9          => CONNECTED_TO_varset_1_i_var9,          --         .i_var9
			varset_1_i_var10         => CONNECTED_TO_varset_1_i_var10,         --         .i_var10
			varset_1_i_var11         => CONNECTED_TO_varset_1_i_var11,         --         .i_var11
			varset_1_i_var12         => CONNECTED_TO_varset_1_i_var12,         --         .i_var12
			varset_1_i_var13         => CONNECTED_TO_varset_1_i_var13,         --         .i_var13
			varset_1_i_var14         => CONNECTED_TO_varset_1_i_var14,         --         .i_var14
			varset_1_i_var15         => CONNECTED_TO_varset_1_i_var15,         --         .i_var15
			varset_1_i_var16         => CONNECTED_TO_varset_1_i_var16,         --         .i_var16
			varset_1_i_var17         => CONNECTED_TO_varset_1_i_var17,         --         .i_var17
			varset_1_i_var18         => CONNECTED_TO_varset_1_i_var18,         --         .i_var18
			varset_1_i_var19         => CONNECTED_TO_varset_1_i_var19,         --         .i_var19
			varset_1_i_var20         => CONNECTED_TO_varset_1_i_var20,         --         .i_var20
			varset_1_i_var21         => CONNECTED_TO_varset_1_i_var21,         --         .i_var21
			varset_1_i_var22         => CONNECTED_TO_varset_1_i_var22,         --         .i_var22
			varset_1_i_var23         => CONNECTED_TO_varset_1_i_var23,         --         .i_var23
			varset_1_i_var24         => CONNECTED_TO_varset_1_i_var24,         --         .i_var24
			varset_1_i_var25         => CONNECTED_TO_varset_1_i_var25,         --         .i_var25
			varset_1_i_var26         => CONNECTED_TO_varset_1_i_var26,         --         .i_var26
			varset_1_i_var27         => CONNECTED_TO_varset_1_i_var27,         --         .i_var27
			varset_1_i_var28         => CONNECTED_TO_varset_1_i_var28,         --         .i_var28
			varset_1_i_var29         => CONNECTED_TO_varset_1_i_var29,         --         .i_var29
			varset_1_i_var30         => CONNECTED_TO_varset_1_i_var30,         --         .i_var30
			varset_1_i_var31         => CONNECTED_TO_varset_1_i_var31,         --         .i_var31
			varset_1_i_var32         => CONNECTED_TO_varset_1_i_var32,         --         .i_var32
			varset_1_i_var33         => CONNECTED_TO_varset_1_i_var33,         --         .i_var33
			varset_1_i_var34         => CONNECTED_TO_varset_1_i_var34,         --         .i_var34
			varset_1_i_var35         => CONNECTED_TO_varset_1_i_var35,         --         .i_var35
			varset_1_i_var36         => CONNECTED_TO_varset_1_i_var36,         --         .i_var36
			varset_1_i_var37         => CONNECTED_TO_varset_1_i_var37,         --         .i_var37
			varset_1_i_var38         => CONNECTED_TO_varset_1_i_var38,         --         .i_var38
			varset_1_i_var39         => CONNECTED_TO_varset_1_i_var39,         --         .i_var39
			varset_1_i_var40         => CONNECTED_TO_varset_1_i_var40,         --         .i_var40
			varset_1_i_var41         => CONNECTED_TO_varset_1_i_var41,         --         .i_var41
			varset_1_i_var42         => CONNECTED_TO_varset_1_i_var42,         --         .i_var42
			varset_1_i_var43         => CONNECTED_TO_varset_1_i_var43,         --         .i_var43
			varset_1_i_var44         => CONNECTED_TO_varset_1_i_var44,         --         .i_var44
			varset_1_i_var45         => CONNECTED_TO_varset_1_i_var45,         --         .i_var45
			varset_1_i_var46         => CONNECTED_TO_varset_1_i_var46,         --         .i_var46
			varset_1_i_var47         => CONNECTED_TO_varset_1_i_var47,         --         .i_var47
			varset_1_i_var48         => CONNECTED_TO_varset_1_i_var48,         --         .i_var48
			varset_1_i_var49         => CONNECTED_TO_varset_1_i_var49,         --         .i_var49
			varset_1_i_var50         => CONNECTED_TO_varset_1_i_var50,         --         .i_var50
			varset_1_i_var51         => CONNECTED_TO_varset_1_i_var51,         --         .i_var51
			varset_1_i_var52         => CONNECTED_TO_varset_1_i_var52,         --         .i_var52
			varset_1_i_var53         => CONNECTED_TO_varset_1_i_var53,         --         .i_var53
			varset_1_i_var54         => CONNECTED_TO_varset_1_i_var54,         --         .i_var54
			varset_1_i_var55         => CONNECTED_TO_varset_1_i_var55,         --         .i_var55
			varset_1_i_var56         => CONNECTED_TO_varset_1_i_var56,         --         .i_var56
			varset_1_i_var57         => CONNECTED_TO_varset_1_i_var57,         --         .i_var57
			varset_1_i_var58         => CONNECTED_TO_varset_1_i_var58,         --         .i_var58
			varset_1_i_var59         => CONNECTED_TO_varset_1_i_var59,         --         .i_var59
			varset_1_o_reg0          => CONNECTED_TO_varset_1_o_reg0,          --         .o_reg0
			varset_1_o_reg1          => CONNECTED_TO_varset_1_o_reg1,          --         .o_reg1
			varset_1_o_reg2          => CONNECTED_TO_varset_1_o_reg2,          --         .o_reg2
			varset_1_o_reg3          => CONNECTED_TO_varset_1_o_reg3,          --         .o_reg3
			varset_1_o_reg4          => CONNECTED_TO_varset_1_o_reg4,          --         .o_reg4
			varset_1_o_reg5          => CONNECTED_TO_varset_1_o_reg5,          --         .o_reg5
			varset_1_o_reg6          => CONNECTED_TO_varset_1_o_reg6,          --         .o_reg6
			varset_1_o_reg7          => CONNECTED_TO_varset_1_o_reg7,          --         .o_reg7
			varset_1_o_reg8          => CONNECTED_TO_varset_1_o_reg8,          --         .o_reg8
			varset_1_o_reg9          => CONNECTED_TO_varset_1_o_reg9,          --         .o_reg9
			varset_1_o_reg10         => CONNECTED_TO_varset_1_o_reg10,         --         .o_reg10
			varset_1_o_reg11         => CONNECTED_TO_varset_1_o_reg11,         --         .o_reg11
			varset_1_o_reg12         => CONNECTED_TO_varset_1_o_reg12,         --         .o_reg12
			varset_1_o_reg13         => CONNECTED_TO_varset_1_o_reg13,         --         .o_reg13
			varset_1_o_reg14         => CONNECTED_TO_varset_1_o_reg14,         --         .o_reg14
			varset_1_o_reg15         => CONNECTED_TO_varset_1_o_reg15,         --         .o_reg15
			varset_1_o_reg16         => CONNECTED_TO_varset_1_o_reg16,         --         .o_reg16
			varset_1_o_reg17         => CONNECTED_TO_varset_1_o_reg17,         --         .o_reg17
			varset_1_o_reg18         => CONNECTED_TO_varset_1_o_reg18,         --         .o_reg18
			varset_1_o_reg19         => CONNECTED_TO_varset_1_o_reg19,         --         .o_reg19
			varset_1_o_reg20         => CONNECTED_TO_varset_1_o_reg20,         --         .o_reg20
			varset_1_o_reg21         => CONNECTED_TO_varset_1_o_reg21,         --         .o_reg21
			varset_1_o_reg22         => CONNECTED_TO_varset_1_o_reg22,         --         .o_reg22
			varset_1_o_reg23         => CONNECTED_TO_varset_1_o_reg23,         --         .o_reg23
			varset_1_o_reg24         => CONNECTED_TO_varset_1_o_reg24,         --         .o_reg24
			varset_1_o_reg25         => CONNECTED_TO_varset_1_o_reg25,         --         .o_reg25
			varset_1_o_reg26         => CONNECTED_TO_varset_1_o_reg26,         --         .o_reg26
			varset_1_o_reg27         => CONNECTED_TO_varset_1_o_reg27,         --         .o_reg27
			varset_1_o_reg28         => CONNECTED_TO_varset_1_o_reg28,         --         .o_reg28
			varset_1_o_reg29         => CONNECTED_TO_varset_1_o_reg29,         --         .o_reg29
			varset_1_o_reg30         => CONNECTED_TO_varset_1_o_reg30,         --         .o_reg30
			varset_1_o_reg31         => CONNECTED_TO_varset_1_o_reg31,         --         .o_reg31
			varset_1_o_reg32         => CONNECTED_TO_varset_1_o_reg32,         --         .o_reg32
			varset_1_o_reg33         => CONNECTED_TO_varset_1_o_reg33,         --         .o_reg33
			varset_1_o_reg34         => CONNECTED_TO_varset_1_o_reg34,         --         .o_reg34
			varset_1_o_reg35         => CONNECTED_TO_varset_1_o_reg35,         --         .o_reg35
			varset_1_o_reg36         => CONNECTED_TO_varset_1_o_reg36,         --         .o_reg36
			varset_1_o_reg37         => CONNECTED_TO_varset_1_o_reg37,         --         .o_reg37
			varset_1_o_reg38         => CONNECTED_TO_varset_1_o_reg38,         --         .o_reg38
			varset_1_o_reg39         => CONNECTED_TO_varset_1_o_reg39,         --         .o_reg39
			varset_1_o_reg40         => CONNECTED_TO_varset_1_o_reg40,         --         .o_reg40
			varset_1_o_reg41         => CONNECTED_TO_varset_1_o_reg41,         --         .o_reg41
			varset_1_o_reg42         => CONNECTED_TO_varset_1_o_reg42,         --         .o_reg42
			varset_1_o_reg43         => CONNECTED_TO_varset_1_o_reg43,         --         .o_reg43
			varset_1_o_reg44         => CONNECTED_TO_varset_1_o_reg44,         --         .o_reg44
			varset_1_o_reg45         => CONNECTED_TO_varset_1_o_reg45,         --         .o_reg45
			varset_1_o_reg46         => CONNECTED_TO_varset_1_o_reg46,         --         .o_reg46
			varset_1_o_reg47         => CONNECTED_TO_varset_1_o_reg47,         --         .o_reg47
			varset_1_o_reg48         => CONNECTED_TO_varset_1_o_reg48,         --         .o_reg48
			varset_1_o_reg49         => CONNECTED_TO_varset_1_o_reg49,         --         .o_reg49
			varset_1_o_reg50         => CONNECTED_TO_varset_1_o_reg50,         --         .o_reg50
			varset_1_o_reg51         => CONNECTED_TO_varset_1_o_reg51,         --         .o_reg51
			varset_1_o_reg52         => CONNECTED_TO_varset_1_o_reg52,         --         .o_reg52
			varset_1_o_reg53         => CONNECTED_TO_varset_1_o_reg53,         --         .o_reg53
			varset_1_o_reg54         => CONNECTED_TO_varset_1_o_reg54,         --         .o_reg54
			varset_1_o_reg55         => CONNECTED_TO_varset_1_o_reg55,         --         .o_reg55
			varset_1_o_reg56         => CONNECTED_TO_varset_1_o_reg56,         --         .o_reg56
			varset_1_o_reg57         => CONNECTED_TO_varset_1_o_reg57,         --         .o_reg57
			varset_1_o_reg58         => CONNECTED_TO_varset_1_o_reg58,         --         .o_reg58
			varset_1_o_reg59         => CONNECTED_TO_varset_1_o_reg59,         --         .o_reg59
			varset_1_o_latch_trigger => CONNECTED_TO_varset_1_o_latch_trigger  --         .o_latch_trigger
		);

