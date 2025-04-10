-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
-- Date        : Thu Jul 29 15:16:30 2021
-- Host        : LAPTOP-MO0UL85T running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               D:/github/adamShiau_FPGA/xilinx_IP/ip/2017.4/div32_kal_v2/div32_kal_v2_stub.vhdl
-- Design      : div32_kal_v2
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a50tcsg325-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity div32_kal_v2 is
  Port ( 
    aclk : in STD_LOGIC;
    aclken : in STD_LOGIC;
    aresetn : in STD_LOGIC;
    s_axis_divisor_tvalid : in STD_LOGIC;
    s_axis_divisor_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axis_dividend_tvalid : in STD_LOGIC;
    s_axis_dividend_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    m_axis_dout_tvalid : out STD_LOGIC;
    m_axis_dout_tdata : out STD_LOGIC_VECTOR ( 63 downto 0 )
  );

end div32_kal_v2;

architecture stub of div32_kal_v2 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "aclk,aclken,aresetn,s_axis_divisor_tvalid,s_axis_divisor_tdata[31:0],s_axis_dividend_tvalid,s_axis_dividend_tdata[31:0],m_axis_dout_tvalid,m_axis_dout_tdata[63:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "div_gen_v5_1_12,Vivado 2017.4";
begin
end;
