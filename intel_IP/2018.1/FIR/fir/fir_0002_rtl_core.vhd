-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 18.1 (Release Build #625)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2018 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from fir_0002_rtl_core
-- VHDL created on Thu Oct 13 16:21:29 2022


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity fir_0002_rtl_core is
    port (
        xIn_v : in std_logic_vector(0 downto 0);  -- sfix1
        xIn_c : in std_logic_vector(7 downto 0);  -- sfix8
        xIn_0 : in std_logic_vector(13 downto 0);  -- sfix14
        xOut_v : out std_logic_vector(0 downto 0);  -- ufix1
        xOut_c : out std_logic_vector(7 downto 0);  -- ufix8
        xOut_0 : out std_logic_vector(31 downto 0);  -- sfix32
        clk : in std_logic;
        areset : in std_logic
    );
end fir_0002_rtl_core;

architecture normal of fir_0002_rtl_core is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_memread_q_11_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_11_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_17_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_wi0_r0_phasedelay0_q_15_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr1_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr1_q_13_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr1_q_14_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr2_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr3_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr3_q_12_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr3_q_13_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr4_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr4_q_12_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr5_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr5_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr6_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr7_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr8_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr8_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr9_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr9_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr10_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr11_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr12_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr13_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr13_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr13_q_12_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr14_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr15_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr16_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr17_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr18_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr18_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr19_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr20_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr21_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr21_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr22_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr23_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr23_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr24_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr25_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr25_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr25_q_12_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr26_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr27_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr28_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr28_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr29_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr29_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr30_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr31_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr32_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr33_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr33_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr33_q_12_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr34_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr35_q : STD_LOGIC_VECTOR (13 downto 0);
    signal d_u0_m0_wo0_wi0_r0_delayr35_q_11_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_delayr36_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_cm15_q : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_cm16_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_cm17_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_mtree_mult1_21_a0 : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_mtree_mult1_21_b0 : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_mtree_mult1_21_s1 : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_21_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_21_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_20_a0 : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_mtree_mult1_20_b0 : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_mtree_mult1_20_s1 : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_20_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_20_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_19_a0 : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_mtree_mult1_19_b0 : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_mtree_mult1_19_s1 : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_19_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_19_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_17_a0 : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_mtree_mult1_17_b0 : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_mtree_mult1_17_s1 : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_17_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_17_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_16_a0 : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_mtree_mult1_16_b0 : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_mtree_mult1_16_s1 : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_16_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_16_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_15_a0 : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_mtree_mult1_15_b0 : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_mtree_mult1_15_s1 : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_15_reset : std_logic;
    signal u0_m0_wo0_mtree_mult1_15_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_0_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_add0_0_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_add0_0_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_add0_0_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_add0_2_a : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_2_b : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_2_o : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_2_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_4_a : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_4_b : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_4_o : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_4_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_6_a : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_6_b : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_6_o : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_6_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_8_a : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_8_b : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_8_o : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_8_q : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_9_a : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_9_b : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_9_o : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_9_q : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_10_a : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_10_b : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_10_o : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_10_q : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add0_12_a : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_12_b : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_12_o : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_12_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add0_14_a : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_14_b : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_14_o : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_14_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_16_a : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_16_b : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_16_o : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add0_16_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_add1_0_a : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_0_b : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_0_o : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_0_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_1_a : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_1_b : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_1_o : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_1_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_2_a : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_2_b : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_2_o : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_2_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_3_a : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add1_3_b : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add1_3_o : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add1_3_q : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add1_4_a : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_4_b : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_4_o : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_4_q : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_5_a : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_5_b : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_5_o : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_5_q : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add1_6_a : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_6_b : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_6_o : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_6_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_7_a : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_7_b : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_7_o : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_7_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add1_8_a : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_8_b : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_8_o : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add1_8_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_add2_0_a : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add2_0_b : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add2_0_o : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add2_0_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add2_1_a : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add2_1_b : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add2_1_o : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add2_1_q : STD_LOGIC_VECTOR (27 downto 0);
    signal u0_m0_wo0_mtree_add2_2_a : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add2_2_b : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add2_2_o : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add2_2_q : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add2_3_a : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add2_3_b : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add2_3_o : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add2_3_q : STD_LOGIC_VECTOR (26 downto 0);
    signal u0_m0_wo0_mtree_add2_4_a : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add2_4_b : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add2_4_o : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add2_4_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_add3_0_a : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add3_0_b : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add3_0_o : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add3_0_q : STD_LOGIC_VECTOR (28 downto 0);
    signal u0_m0_wo0_mtree_add3_1_a : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add3_1_b : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add3_1_o : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add3_1_q : STD_LOGIC_VECTOR (29 downto 0);
    signal u0_m0_wo0_mtree_add4_0_a : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_add4_0_b : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_add4_0_o : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_add4_0_q : STD_LOGIC_VECTOR (30 downto 0);
    signal u0_m0_wo0_mtree_add5_0_a : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_mtree_add5_0_b : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_mtree_add5_0_o : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_mtree_add5_0_q : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_oseq_gated_reg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_add_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_add_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_add_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_add_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_add_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_add_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_add_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_add_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_sub_3_a : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_sub_3_b : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_sub_3_o : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_sub_3_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_3_a : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_3_b : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_3_o : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_sub_3_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_3_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_3_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_3_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_sub_3_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_add_5_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_add_5_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_add_5_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_add_5_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_add_3_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_add_3_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_add_3_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_add_3_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_5_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_5_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_5_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_sub_5_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_sub_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_sub_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_sub_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_sub_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_3_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_3_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_3_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_3_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_5_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_5_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_5_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_add_5_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_add_1_a : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_add_1_b : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_add_1_o : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_add_1_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_1_a : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_1_b : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_1_o : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_1_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_3_a : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_3_b : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_3_o : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_3_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_5_a : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_5_b : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_5_o : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_add_5_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_3_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_3_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_3_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_sub_3_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_3_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_3_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_3_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_sub_3_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_add_5_a : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_add_5_b : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_add_5_o : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_add_5_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_add_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_add_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_add_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_add_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_sub_3_a : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_sub_3_b : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_sub_3_o : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_sub_3_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_18_sub_1_a : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_18_sub_1_b : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_18_sub_1_o : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_18_sub_1_q : STD_LOGIC_VECTOR (25 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_add_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_add_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_add_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_add_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_sub_3_a : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_sub_3_b : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_sub_3_o : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_sub_3_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_3_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_3_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_3_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_sub_3_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_add_5_a : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_add_5_b : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_add_5_o : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_add_5_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_3_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_3_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_3_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_sub_3_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_1_a : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_1_b : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_1_o : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_1_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_3_a : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_3_b : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_3_o : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_3_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_5_a : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_5_b : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_5_o : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_add_5_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_add_1_a : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_add_1_b : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_add_1_o : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_add_1_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_sub_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_sub_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_sub_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_sub_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_3_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_3_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_3_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_3_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_5_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_5_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_5_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_add_5_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_add_3_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_add_3_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_add_3_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_add_3_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_5_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_5_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_5_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_sub_5_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_3_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_3_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_3_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_sub_3_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_add_5_a : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_add_5_b : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_add_5_o : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_add_5_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_3_a : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_3_b : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_3_o : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_sub_3_q : STD_LOGIC_VECTOR (20 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_add_1_a : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_add_1_b : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_add_1_o : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_add_1_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_sub_3_a : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_sub_3_b : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_sub_3_o : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_sub_3_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_add_1_a : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_add_1_b : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_add_1_o : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_add_1_q : STD_LOGIC_VECTOR (17 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_shift2_q : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_shift2_qint : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_shift2_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_shift2_qint : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift2_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift2_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_shift2_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_shift2_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_shift2_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_shift2_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_shift0_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_shift0_qint : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift0_q : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift0_qint : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift2_q : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift2_qint : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_shift2_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_25_shift2_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift2_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift2_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_shift2_q : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_shift2_qint : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_18_shift0_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_18_shift0_qint : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_shift2_q : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_shift2_qint : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift2_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift2_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_shift2_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_11_shift2_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift0_q : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift0_qint : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift2_q : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift2_qint : STD_LOGIC_VECTOR (14 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_shift0_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_shift0_qint : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_shift2_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_shift2_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_shift2_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_shift2_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift2_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift2_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_shift2_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_shift2_qint : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_shift0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_shift0_qint : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_shift2_q : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_shift2_qint : STD_LOGIC_VECTOR (18 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_shift0_q : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_shift0_qint : STD_LOGIC_VECTOR (16 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_shift2_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_36_shift2_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_35_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_33_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift6_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_32_shift6_qint : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_31_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_29_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_shift2_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_28_shift2_qint : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift4_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift4_qint : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift6_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_27_shift6_qint : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift4_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift4_qint : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift6_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_24_shift6_qint : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_shift4_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_23_shift4_qint : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_shift4_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_13_shift4_qint : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift4_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift4_qint : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift6_q : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_12_shift6_qint : STD_LOGIC_VECTOR (24 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift4_q : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift4_qint : STD_LOGIC_VECTOR (19 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift6_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_9_shift6_qint : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_shift2_q : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_8_shift2_qint : STD_LOGIC_VECTOR (22 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_7_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_5_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift6_q : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_4_shift6_qint : STD_LOGIC_VECTOR (23 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_3_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_shift4_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_1_shift4_qint : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_shift2_q : STD_LOGIC_VECTOR (21 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_shift2_qint : STD_LOGIC_VECTOR (21 downto 0);

begin


    -- VCC(CONSTANT,1)@0
    VCC_q <= "1";

    -- u0_m0_wo0_mtree_mult1_36_shift0(BITSHIFT,183)@15
    u0_m0_wo0_mtree_mult1_36_shift0_qint <= d_u0_m0_wo0_wi0_r0_phasedelay0_q_15_q & "000";
    u0_m0_wo0_mtree_mult1_36_shift0_q <= u0_m0_wo0_mtree_mult1_36_shift0_qint(16 downto 0);

    -- d_u0_m0_wo0_wi0_r0_phasedelay0_q_15(DELAY,460)@10 + 5
    d_u0_m0_wo0_wi0_r0_phasedelay0_q_15 : dspba_delay
    GENERIC MAP ( width => 14, depth => 5, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_0, xout => d_u0_m0_wo0_wi0_r0_phasedelay0_q_15_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_36_add_1(ADD,184)@15 + 1
    u0_m0_wo0_mtree_mult1_36_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => d_u0_m0_wo0_wi0_r0_phasedelay0_q_15_q(13)) & d_u0_m0_wo0_wi0_r0_phasedelay0_q_15_q));
    u0_m0_wo0_mtree_mult1_36_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_36_shift0_q(16)) & u0_m0_wo0_mtree_mult1_36_shift0_q));
    u0_m0_wo0_mtree_mult1_36_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_36_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_36_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_36_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_36_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_36_add_1_q <= u0_m0_wo0_mtree_mult1_36_add_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_36_shift2(BITSHIFT,185)@16
    u0_m0_wo0_mtree_mult1_36_shift2_qint <= u0_m0_wo0_mtree_mult1_36_add_1_q & "0000";
    u0_m0_wo0_mtree_mult1_36_shift2_q <= u0_m0_wo0_mtree_mult1_36_shift2_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_35_shift0(BITSHIFT,186)@13
    u0_m0_wo0_mtree_mult1_35_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr1_q_13_q & "00";
    u0_m0_wo0_mtree_mult1_35_shift0_q <= u0_m0_wo0_mtree_mult1_35_shift0_qint(15 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr1(DELAY,20)@10
    u0_m0_wo0_wi0_r0_delayr1 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_0, xout => u0_m0_wo0_wi0_r0_delayr1_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr1_q_13(DELAY,461)@10 + 3
    d_u0_m0_wo0_wi0_r0_delayr1_q_13 : dspba_delay
    GENERIC MAP ( width => 14, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr1_q, xout => d_u0_m0_wo0_wi0_r0_delayr1_q_13_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_35_add_1(ADD,187)@13 + 1
    u0_m0_wo0_mtree_mult1_35_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => d_u0_m0_wo0_wi0_r0_delayr1_q_13_q(13)) & d_u0_m0_wo0_wi0_r0_delayr1_q_13_q));
    u0_m0_wo0_mtree_mult1_35_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_35_shift0_q(15)) & u0_m0_wo0_mtree_mult1_35_shift0_q));
    u0_m0_wo0_mtree_mult1_35_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_35_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_35_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_35_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_35_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_35_add_1_q <= u0_m0_wo0_mtree_mult1_35_add_1_o(16 downto 0);

    -- d_u0_m0_wo0_wi0_r0_delayr1_q_14(DELAY,462)@13 + 1
    d_u0_m0_wo0_wi0_r0_delayr1_q_14 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_wi0_r0_delayr1_q_13_q, xout => d_u0_m0_wo0_wi0_r0_delayr1_q_14_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_35_shift2(BITSHIFT,188)@14
    u0_m0_wo0_mtree_mult1_35_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr1_q_14_q & "00000";
    u0_m0_wo0_mtree_mult1_35_shift2_q <= u0_m0_wo0_mtree_mult1_35_shift2_qint(18 downto 0);

    -- u0_m0_wo0_mtree_mult1_35_sub_3(SUB,189)@14 + 1
    u0_m0_wo0_mtree_mult1_35_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 19 => u0_m0_wo0_mtree_mult1_35_shift2_q(18)) & u0_m0_wo0_mtree_mult1_35_shift2_q));
    u0_m0_wo0_mtree_mult1_35_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 17 => u0_m0_wo0_mtree_mult1_35_add_1_q(16)) & u0_m0_wo0_mtree_mult1_35_add_1_q));
    u0_m0_wo0_mtree_mult1_35_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_35_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_35_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_35_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_35_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_35_sub_3_q <= u0_m0_wo0_mtree_mult1_35_sub_3_o(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_35_shift4(BITSHIFT,190)@15
    u0_m0_wo0_mtree_mult1_35_shift4_qint <= u0_m0_wo0_mtree_mult1_35_sub_3_q & "00";
    u0_m0_wo0_mtree_mult1_35_shift4_q <= u0_m0_wo0_mtree_mult1_35_shift4_qint(21 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr2(DELAY,21)@10
    u0_m0_wo0_wi0_r0_delayr2 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr1_q, xout => u0_m0_wo0_wi0_r0_delayr2_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr3(DELAY,22)@10
    u0_m0_wo0_wi0_r0_delayr3 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr2_q, xout => u0_m0_wo0_wi0_r0_delayr3_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr3_q_12(DELAY,463)@10 + 2
    d_u0_m0_wo0_wi0_r0_delayr3_q_12 : dspba_delay
    GENERIC MAP ( width => 14, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr3_q, xout => d_u0_m0_wo0_wi0_r0_delayr3_q_12_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr3_q_13(DELAY,464)@12 + 1
    d_u0_m0_wo0_wi0_r0_delayr3_q_13 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_wi0_r0_delayr3_q_12_q, xout => d_u0_m0_wo0_wi0_r0_delayr3_q_13_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_33_shift2(BITSHIFT,193)@13
    u0_m0_wo0_mtree_mult1_33_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr3_q_13_q & "000000";
    u0_m0_wo0_mtree_mult1_33_shift2_q <= u0_m0_wo0_mtree_mult1_33_shift2_qint(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_33_shift0(BITSHIFT,191)@12
    u0_m0_wo0_mtree_mult1_33_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr3_q_12_q & "00";
    u0_m0_wo0_mtree_mult1_33_shift0_q <= u0_m0_wo0_mtree_mult1_33_shift0_qint(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_33_sub_1(SUB,192)@12 + 1
    u0_m0_wo0_mtree_mult1_33_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_33_shift0_q(15)) & u0_m0_wo0_mtree_mult1_33_shift0_q));
    u0_m0_wo0_mtree_mult1_33_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => d_u0_m0_wo0_wi0_r0_delayr3_q_12_q(13)) & d_u0_m0_wo0_wi0_r0_delayr3_q_12_q));
    u0_m0_wo0_mtree_mult1_33_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_33_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_33_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_33_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_33_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_33_sub_1_q <= u0_m0_wo0_mtree_mult1_33_sub_1_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_33_sub_3(SUB,194)@13 + 1
    u0_m0_wo0_mtree_mult1_33_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 17 => u0_m0_wo0_mtree_mult1_33_sub_1_q(16)) & u0_m0_wo0_mtree_mult1_33_sub_1_q));
    u0_m0_wo0_mtree_mult1_33_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 20 => u0_m0_wo0_mtree_mult1_33_shift2_q(19)) & u0_m0_wo0_mtree_mult1_33_shift2_q));
    u0_m0_wo0_mtree_mult1_33_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_33_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_33_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_33_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_33_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_33_sub_3_q <= u0_m0_wo0_mtree_mult1_33_sub_3_o(20 downto 0);

    -- u0_m0_wo0_mtree_mult1_33_shift4(BITSHIFT,195)@14
    u0_m0_wo0_mtree_mult1_33_shift4_qint <= u0_m0_wo0_mtree_mult1_33_sub_3_q & "0";
    u0_m0_wo0_mtree_mult1_33_shift4_q <= u0_m0_wo0_mtree_mult1_33_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_32_shift2(BITSHIFT,198)@12
    u0_m0_wo0_mtree_mult1_32_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr4_q_12_q & "00";
    u0_m0_wo0_mtree_mult1_32_shift2_q <= u0_m0_wo0_mtree_mult1_32_shift2_qint(15 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr4(DELAY,23)@10
    u0_m0_wo0_wi0_r0_delayr4 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr3_q, xout => u0_m0_wo0_wi0_r0_delayr4_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr4_q_12(DELAY,465)@10 + 2
    d_u0_m0_wo0_wi0_r0_delayr4_q_12 : dspba_delay
    GENERIC MAP ( width => 14, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr4_q, xout => d_u0_m0_wo0_wi0_r0_delayr4_q_12_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_32_sub_3(SUB,199)@12 + 1
    u0_m0_wo0_mtree_mult1_32_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => d_u0_m0_wo0_wi0_r0_delayr4_q_12_q(13)) & d_u0_m0_wo0_wi0_r0_delayr4_q_12_q));
    u0_m0_wo0_mtree_mult1_32_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_32_shift2_q(15)) & u0_m0_wo0_mtree_mult1_32_shift2_q));
    u0_m0_wo0_mtree_mult1_32_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_32_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_32_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_32_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_32_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_32_sub_3_q <= u0_m0_wo0_mtree_mult1_32_sub_3_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_32_shift4(BITSHIFT,200)@13
    u0_m0_wo0_mtree_mult1_32_shift4_qint <= u0_m0_wo0_mtree_mult1_32_sub_3_q & "00000";
    u0_m0_wo0_mtree_mult1_32_shift4_q <= u0_m0_wo0_mtree_mult1_32_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_32_shift0(BITSHIFT,196)@12
    u0_m0_wo0_mtree_mult1_32_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr4_q_12_q & "00";
    u0_m0_wo0_mtree_mult1_32_shift0_q <= u0_m0_wo0_mtree_mult1_32_shift0_qint(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_32_sub_1(SUB,197)@12 + 1
    u0_m0_wo0_mtree_mult1_32_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_32_shift0_q(15)) & u0_m0_wo0_mtree_mult1_32_shift0_q));
    u0_m0_wo0_mtree_mult1_32_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => d_u0_m0_wo0_wi0_r0_delayr4_q_12_q(13)) & d_u0_m0_wo0_wi0_r0_delayr4_q_12_q));
    u0_m0_wo0_mtree_mult1_32_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_32_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_32_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_32_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_32_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_32_sub_1_q <= u0_m0_wo0_mtree_mult1_32_sub_1_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_32_add_5(ADD,201)@13 + 1
    u0_m0_wo0_mtree_mult1_32_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 17 => u0_m0_wo0_mtree_mult1_32_sub_1_q(16)) & u0_m0_wo0_mtree_mult1_32_sub_1_q));
    u0_m0_wo0_mtree_mult1_32_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_32_shift4_q(21)) & u0_m0_wo0_mtree_mult1_32_shift4_q));
    u0_m0_wo0_mtree_mult1_32_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_32_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_32_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_32_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_32_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_32_add_5_q <= u0_m0_wo0_mtree_mult1_32_add_5_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_32_shift6(BITSHIFT,202)@14
    u0_m0_wo0_mtree_mult1_32_shift6_qint <= u0_m0_wo0_mtree_mult1_32_add_5_q & "0";
    u0_m0_wo0_mtree_mult1_32_shift6_q <= u0_m0_wo0_mtree_mult1_32_shift6_qint(23 downto 0);

    -- u0_m0_wo0_mtree_add0_16(ADD,149)@14 + 1
    u0_m0_wo0_mtree_add0_16_a <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_32_shift6_q);
    u0_m0_wo0_mtree_add0_16_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 22 => u0_m0_wo0_mtree_mult1_33_shift4_q(21)) & u0_m0_wo0_mtree_mult1_33_shift4_q));
    u0_m0_wo0_mtree_add0_16_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_16_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_16_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_16_a) + SIGNED(u0_m0_wo0_mtree_add0_16_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_16_q <= u0_m0_wo0_mtree_add0_16_o(23 downto 0);

    -- u0_m0_wo0_mtree_add1_8(ADD,159)@15 + 1
    u0_m0_wo0_mtree_add1_8_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 24 => u0_m0_wo0_mtree_add0_16_q(23)) & u0_m0_wo0_mtree_add0_16_q));
    u0_m0_wo0_mtree_add1_8_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 22 => u0_m0_wo0_mtree_mult1_35_shift4_q(21)) & u0_m0_wo0_mtree_mult1_35_shift4_q));
    u0_m0_wo0_mtree_add1_8_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_8_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_8_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_8_a) + SIGNED(u0_m0_wo0_mtree_add1_8_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_8_q <= u0_m0_wo0_mtree_add1_8_o(24 downto 0);

    -- u0_m0_wo0_mtree_add2_4(ADD,164)@16 + 1
    u0_m0_wo0_mtree_add2_4_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 25 => u0_m0_wo0_mtree_add1_8_q(24)) & u0_m0_wo0_mtree_add1_8_q));
    u0_m0_wo0_mtree_add2_4_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 22 => u0_m0_wo0_mtree_mult1_36_shift2_q(21)) & u0_m0_wo0_mtree_mult1_36_shift2_q));
    u0_m0_wo0_mtree_add2_4_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add2_4_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add2_4_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add2_4_a) + SIGNED(u0_m0_wo0_mtree_add2_4_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add2_4_q <= u0_m0_wo0_mtree_add2_4_o(25 downto 0);

    -- u0_m0_wo0_mtree_mult1_31_shift2(BITSHIFT,205)@11
    u0_m0_wo0_mtree_mult1_31_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr5_q_11_q & "000";
    u0_m0_wo0_mtree_mult1_31_shift2_q <= u0_m0_wo0_mtree_mult1_31_shift2_qint(16 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr5(DELAY,24)@10
    u0_m0_wo0_wi0_r0_delayr5 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr4_q, xout => u0_m0_wo0_wi0_r0_delayr5_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr5_q_11(DELAY,466)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr5_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr5_q, xout => d_u0_m0_wo0_wi0_r0_delayr5_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_31_add_3(ADD,206)@11 + 1
    u0_m0_wo0_mtree_mult1_31_add_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => d_u0_m0_wo0_wi0_r0_delayr5_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr5_q_11_q));
    u0_m0_wo0_mtree_mult1_31_add_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_31_shift2_q(16)) & u0_m0_wo0_mtree_mult1_31_shift2_q));
    u0_m0_wo0_mtree_mult1_31_add_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_31_add_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_31_add_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_31_add_3_a) + SIGNED(u0_m0_wo0_mtree_mult1_31_add_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_31_add_3_q <= u0_m0_wo0_mtree_mult1_31_add_3_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_31_shift4(BITSHIFT,207)@12
    u0_m0_wo0_mtree_mult1_31_shift4_qint <= u0_m0_wo0_mtree_mult1_31_add_3_q & "0000";
    u0_m0_wo0_mtree_mult1_31_shift4_q <= u0_m0_wo0_mtree_mult1_31_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_31_shift0(BITSHIFT,203)@11
    u0_m0_wo0_mtree_mult1_31_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr5_q_11_q & "00";
    u0_m0_wo0_mtree_mult1_31_shift0_q <= u0_m0_wo0_mtree_mult1_31_shift0_qint(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_31_sub_1(SUB,204)@11 + 1
    u0_m0_wo0_mtree_mult1_31_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_31_shift0_q(15)) & u0_m0_wo0_mtree_mult1_31_shift0_q));
    u0_m0_wo0_mtree_mult1_31_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => d_u0_m0_wo0_wi0_r0_delayr5_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr5_q_11_q));
    u0_m0_wo0_mtree_mult1_31_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_31_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_31_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_31_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_31_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_31_sub_1_q <= u0_m0_wo0_mtree_mult1_31_sub_1_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_31_sub_5(SUB,208)@12 + 1
    u0_m0_wo0_mtree_mult1_31_sub_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 17 => u0_m0_wo0_mtree_mult1_31_sub_1_q(16)) & u0_m0_wo0_mtree_mult1_31_sub_1_q));
    u0_m0_wo0_mtree_mult1_31_sub_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_31_shift4_q(21)) & u0_m0_wo0_mtree_mult1_31_shift4_q));
    u0_m0_wo0_mtree_mult1_31_sub_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_31_sub_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_31_sub_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_31_sub_5_a) - SIGNED(u0_m0_wo0_mtree_mult1_31_sub_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_31_sub_5_q <= u0_m0_wo0_mtree_mult1_31_sub_5_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_29_shift2(BITSHIFT,211)@10
    u0_m0_wo0_mtree_mult1_29_shift2_qint <= u0_m0_wo0_wi0_r0_delayr7_q & "00";
    u0_m0_wo0_mtree_mult1_29_shift2_q <= u0_m0_wo0_mtree_mult1_29_shift2_qint(15 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr6(DELAY,25)@10
    u0_m0_wo0_wi0_r0_delayr6 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr5_q, xout => u0_m0_wo0_wi0_r0_delayr6_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr7(DELAY,26)@10
    u0_m0_wo0_wi0_r0_delayr7 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr6_q, xout => u0_m0_wo0_wi0_r0_delayr7_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_29_add_3(ADD,212)@10 + 1
    u0_m0_wo0_mtree_mult1_29_add_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => u0_m0_wo0_wi0_r0_delayr7_q(13)) & u0_m0_wo0_wi0_r0_delayr7_q));
    u0_m0_wo0_mtree_mult1_29_add_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_29_shift2_q(15)) & u0_m0_wo0_mtree_mult1_29_shift2_q));
    u0_m0_wo0_mtree_mult1_29_add_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_29_add_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_29_add_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_29_add_3_a) + SIGNED(u0_m0_wo0_mtree_mult1_29_add_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_29_add_3_q <= u0_m0_wo0_mtree_mult1_29_add_3_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_29_shift4(BITSHIFT,213)@11
    u0_m0_wo0_mtree_mult1_29_shift4_qint <= u0_m0_wo0_mtree_mult1_29_add_3_q & "00000";
    u0_m0_wo0_mtree_mult1_29_shift4_q <= u0_m0_wo0_mtree_mult1_29_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_29_shift0(BITSHIFT,209)@10
    u0_m0_wo0_mtree_mult1_29_shift0_qint <= u0_m0_wo0_wi0_r0_delayr7_q & "000";
    u0_m0_wo0_mtree_mult1_29_shift0_q <= u0_m0_wo0_mtree_mult1_29_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_29_sub_1(SUB,210)@10 + 1
    u0_m0_wo0_mtree_mult1_29_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_29_shift0_q(16)) & u0_m0_wo0_mtree_mult1_29_shift0_q));
    u0_m0_wo0_mtree_mult1_29_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr7_q(13)) & u0_m0_wo0_wi0_r0_delayr7_q));
    u0_m0_wo0_mtree_mult1_29_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_29_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_29_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_29_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_29_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_29_sub_1_q <= u0_m0_wo0_mtree_mult1_29_sub_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_29_add_5(ADD,214)@11 + 1
    u0_m0_wo0_mtree_mult1_29_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 18 => u0_m0_wo0_mtree_mult1_29_sub_1_q(17)) & u0_m0_wo0_mtree_mult1_29_sub_1_q));
    u0_m0_wo0_mtree_mult1_29_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_29_shift4_q(21)) & u0_m0_wo0_mtree_mult1_29_shift4_q));
    u0_m0_wo0_mtree_mult1_29_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_29_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_29_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_29_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_29_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_29_add_5_q <= u0_m0_wo0_mtree_mult1_29_add_5_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_28_shift0(BITSHIFT,215)@11
    u0_m0_wo0_mtree_mult1_28_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr8_q_11_q & "000000";
    u0_m0_wo0_mtree_mult1_28_shift0_q <= u0_m0_wo0_mtree_mult1_28_shift0_qint(19 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr8(DELAY,27)@10
    u0_m0_wo0_wi0_r0_delayr8 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr7_q, xout => u0_m0_wo0_wi0_r0_delayr8_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr8_q_11(DELAY,467)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr8_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr8_q, xout => d_u0_m0_wo0_wi0_r0_delayr8_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_28_add_1(ADD,216)@11 + 1
    u0_m0_wo0_mtree_mult1_28_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 14 => d_u0_m0_wo0_wi0_r0_delayr8_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr8_q_11_q));
    u0_m0_wo0_mtree_mult1_28_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 20 => u0_m0_wo0_mtree_mult1_28_shift0_q(19)) & u0_m0_wo0_mtree_mult1_28_shift0_q));
    u0_m0_wo0_mtree_mult1_28_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_28_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_28_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_28_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_28_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_28_add_1_q <= u0_m0_wo0_mtree_mult1_28_add_1_o(20 downto 0);

    -- u0_m0_wo0_mtree_mult1_28_shift2(BITSHIFT,217)@12
    u0_m0_wo0_mtree_mult1_28_shift2_qint <= u0_m0_wo0_mtree_mult1_28_add_1_q & "00";
    u0_m0_wo0_mtree_mult1_28_shift2_q <= u0_m0_wo0_mtree_mult1_28_shift2_qint(22 downto 0);

    -- u0_m0_wo0_mtree_add0_14(ADD,147)@12 + 1
    u0_m0_wo0_mtree_add0_14_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 23 => u0_m0_wo0_mtree_mult1_28_shift2_q(22)) & u0_m0_wo0_mtree_mult1_28_shift2_q));
    u0_m0_wo0_mtree_add0_14_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 23 => u0_m0_wo0_mtree_mult1_29_add_5_q(22)) & u0_m0_wo0_mtree_mult1_29_add_5_q));
    u0_m0_wo0_mtree_add0_14_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_14_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_14_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_14_a) + SIGNED(u0_m0_wo0_mtree_add0_14_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_14_q <= u0_m0_wo0_mtree_add0_14_o(23 downto 0);

    -- u0_m0_wo0_mtree_add1_7(ADD,158)@13 + 1
    u0_m0_wo0_mtree_add1_7_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 24 => u0_m0_wo0_mtree_add0_14_q(23)) & u0_m0_wo0_mtree_add0_14_q));
    u0_m0_wo0_mtree_add1_7_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 23 => u0_m0_wo0_mtree_mult1_31_sub_5_q(22)) & u0_m0_wo0_mtree_mult1_31_sub_5_q));
    u0_m0_wo0_mtree_add1_7_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_7_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_7_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_7_a) + SIGNED(u0_m0_wo0_mtree_add1_7_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_7_q <= u0_m0_wo0_mtree_add1_7_o(25 downto 0);

    -- u0_m0_wo0_mtree_mult1_27_shift2(BITSHIFT,220)@11
    u0_m0_wo0_mtree_mult1_27_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr9_q_11_q & "0";
    u0_m0_wo0_mtree_mult1_27_shift2_q <= u0_m0_wo0_mtree_mult1_27_shift2_qint(14 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr9(DELAY,28)@10
    u0_m0_wo0_wi0_r0_delayr9 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr8_q, xout => u0_m0_wo0_wi0_r0_delayr9_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr9_q_11(DELAY,468)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr9_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr9_q, xout => d_u0_m0_wo0_wi0_r0_delayr9_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_27_add_3(ADD,221)@11 + 1
    u0_m0_wo0_mtree_mult1_27_add_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 14 => d_u0_m0_wo0_wi0_r0_delayr9_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr9_q_11_q));
    u0_m0_wo0_mtree_mult1_27_add_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 15 => u0_m0_wo0_mtree_mult1_27_shift2_q(14)) & u0_m0_wo0_mtree_mult1_27_shift2_q));
    u0_m0_wo0_mtree_mult1_27_add_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_27_add_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_27_add_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_27_add_3_a) + SIGNED(u0_m0_wo0_mtree_mult1_27_add_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_27_add_3_q <= u0_m0_wo0_mtree_mult1_27_add_3_o(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_27_shift4(BITSHIFT,222)@12
    u0_m0_wo0_mtree_mult1_27_shift4_qint <= u0_m0_wo0_mtree_mult1_27_add_3_q & "0000";
    u0_m0_wo0_mtree_mult1_27_shift4_q <= u0_m0_wo0_mtree_mult1_27_shift4_qint(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_27_shift0(BITSHIFT,218)@11
    u0_m0_wo0_mtree_mult1_27_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr9_q_11_q & "0";
    u0_m0_wo0_mtree_mult1_27_shift0_q <= u0_m0_wo0_mtree_mult1_27_shift0_qint(14 downto 0);

    -- u0_m0_wo0_mtree_mult1_27_add_1(ADD,219)@11 + 1
    u0_m0_wo0_mtree_mult1_27_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 14 => d_u0_m0_wo0_wi0_r0_delayr9_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr9_q_11_q));
    u0_m0_wo0_mtree_mult1_27_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 15 => u0_m0_wo0_mtree_mult1_27_shift0_q(14)) & u0_m0_wo0_mtree_mult1_27_shift0_q));
    u0_m0_wo0_mtree_mult1_27_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_27_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_27_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_27_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_27_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_27_add_1_q <= u0_m0_wo0_mtree_mult1_27_add_1_o(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_27_add_5(ADD,223)@12 + 1
    u0_m0_wo0_mtree_mult1_27_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 16 => u0_m0_wo0_mtree_mult1_27_add_1_q(15)) & u0_m0_wo0_mtree_mult1_27_add_1_q));
    u0_m0_wo0_mtree_mult1_27_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 20 => u0_m0_wo0_mtree_mult1_27_shift4_q(19)) & u0_m0_wo0_mtree_mult1_27_shift4_q));
    u0_m0_wo0_mtree_mult1_27_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_27_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_27_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_27_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_27_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_27_add_5_q <= u0_m0_wo0_mtree_mult1_27_add_5_o(20 downto 0);

    -- u0_m0_wo0_mtree_mult1_27_shift6(BITSHIFT,224)@13
    u0_m0_wo0_mtree_mult1_27_shift6_qint <= u0_m0_wo0_mtree_mult1_27_add_5_q & "00";
    u0_m0_wo0_mtree_mult1_27_shift6_q <= u0_m0_wo0_mtree_mult1_27_shift6_qint(22 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr10(DELAY,29)@10
    u0_m0_wo0_wi0_r0_delayr10 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr9_q, xout => u0_m0_wo0_wi0_r0_delayr10_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr11(DELAY,30)@10
    u0_m0_wo0_wi0_r0_delayr11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr10_q, xout => u0_m0_wo0_wi0_r0_delayr11_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr11_q_11(DELAY,469)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr11_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr11_q, xout => d_u0_m0_wo0_wi0_r0_delayr11_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_25_shift2(BITSHIFT,227)@11
    u0_m0_wo0_mtree_mult1_25_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr11_q_11_q & "00000000";
    u0_m0_wo0_mtree_mult1_25_shift2_q <= u0_m0_wo0_mtree_mult1_25_shift2_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_25_shift0(BITSHIFT,225)@10
    u0_m0_wo0_mtree_mult1_25_shift0_qint <= u0_m0_wo0_wi0_r0_delayr11_q & "000";
    u0_m0_wo0_mtree_mult1_25_shift0_q <= u0_m0_wo0_mtree_mult1_25_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_25_sub_1(SUB,226)@10 + 1
    u0_m0_wo0_mtree_mult1_25_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr11_q(13)) & u0_m0_wo0_wi0_r0_delayr11_q));
    u0_m0_wo0_mtree_mult1_25_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_25_shift0_q(16)) & u0_m0_wo0_mtree_mult1_25_shift0_q));
    u0_m0_wo0_mtree_mult1_25_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_25_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_25_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_25_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_25_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_25_sub_1_q <= u0_m0_wo0_mtree_mult1_25_sub_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_25_sub_3(SUB,228)@11 + 1
    u0_m0_wo0_mtree_mult1_25_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 18 => u0_m0_wo0_mtree_mult1_25_sub_1_q(17)) & u0_m0_wo0_mtree_mult1_25_sub_1_q));
    u0_m0_wo0_mtree_mult1_25_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_25_shift2_q(21)) & u0_m0_wo0_mtree_mult1_25_shift2_q));
    u0_m0_wo0_mtree_mult1_25_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_25_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_25_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_25_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_25_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_25_sub_3_q <= u0_m0_wo0_mtree_mult1_25_sub_3_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_24_shift2(BITSHIFT,231)@10
    u0_m0_wo0_mtree_mult1_24_shift2_qint <= u0_m0_wo0_wi0_r0_delayr12_q & "000";
    u0_m0_wo0_mtree_mult1_24_shift2_q <= u0_m0_wo0_mtree_mult1_24_shift2_qint(16 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr12(DELAY,31)@10
    u0_m0_wo0_wi0_r0_delayr12 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr11_q, xout => u0_m0_wo0_wi0_r0_delayr12_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_24_sub_3(SUB,232)@10 + 1
    u0_m0_wo0_mtree_mult1_24_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr12_q(13)) & u0_m0_wo0_wi0_r0_delayr12_q));
    u0_m0_wo0_mtree_mult1_24_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_24_shift2_q(16)) & u0_m0_wo0_mtree_mult1_24_shift2_q));
    u0_m0_wo0_mtree_mult1_24_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_24_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_24_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_24_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_24_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_24_sub_3_q <= u0_m0_wo0_mtree_mult1_24_sub_3_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_24_shift4(BITSHIFT,233)@11
    u0_m0_wo0_mtree_mult1_24_shift4_qint <= u0_m0_wo0_mtree_mult1_24_sub_3_q & "00000";
    u0_m0_wo0_mtree_mult1_24_shift4_q <= u0_m0_wo0_mtree_mult1_24_shift4_qint(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_24_shift0(BITSHIFT,229)@10
    u0_m0_wo0_mtree_mult1_24_shift0_qint <= u0_m0_wo0_wi0_r0_delayr12_q & "000";
    u0_m0_wo0_mtree_mult1_24_shift0_q <= u0_m0_wo0_mtree_mult1_24_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_24_sub_1(SUB,230)@10 + 1
    u0_m0_wo0_mtree_mult1_24_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_24_shift0_q(16)) & u0_m0_wo0_mtree_mult1_24_shift0_q));
    u0_m0_wo0_mtree_mult1_24_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr12_q(13)) & u0_m0_wo0_wi0_r0_delayr12_q));
    u0_m0_wo0_mtree_mult1_24_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_24_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_24_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_24_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_24_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_24_sub_1_q <= u0_m0_wo0_mtree_mult1_24_sub_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_24_add_5(ADD,234)@11 + 1
    u0_m0_wo0_mtree_mult1_24_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 18 => u0_m0_wo0_mtree_mult1_24_sub_1_q(17)) & u0_m0_wo0_mtree_mult1_24_sub_1_q));
    u0_m0_wo0_mtree_mult1_24_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 23 => u0_m0_wo0_mtree_mult1_24_shift4_q(22)) & u0_m0_wo0_mtree_mult1_24_shift4_q));
    u0_m0_wo0_mtree_mult1_24_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_24_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_24_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_24_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_24_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_24_add_5_q <= u0_m0_wo0_mtree_mult1_24_add_5_o(23 downto 0);

    -- u0_m0_wo0_mtree_mult1_24_shift6(BITSHIFT,235)@12
    u0_m0_wo0_mtree_mult1_24_shift6_qint <= u0_m0_wo0_mtree_mult1_24_add_5_q & "0";
    u0_m0_wo0_mtree_mult1_24_shift6_q <= u0_m0_wo0_mtree_mult1_24_shift6_qint(24 downto 0);

    -- u0_m0_wo0_mtree_add0_12(ADD,145)@12 + 1
    u0_m0_wo0_mtree_add0_12_a <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_24_shift6_q);
    u0_m0_wo0_mtree_add0_12_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 23 => u0_m0_wo0_mtree_mult1_25_sub_3_q(22)) & u0_m0_wo0_mtree_mult1_25_sub_3_q));
    u0_m0_wo0_mtree_add0_12_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_12_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_12_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_12_a) + SIGNED(u0_m0_wo0_mtree_add0_12_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_12_q <= u0_m0_wo0_mtree_add0_12_o(24 downto 0);

    -- u0_m0_wo0_mtree_add1_6(ADD,157)@13 + 1
    u0_m0_wo0_mtree_add1_6_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 25 => u0_m0_wo0_mtree_add0_12_q(24)) & u0_m0_wo0_mtree_add0_12_q));
    u0_m0_wo0_mtree_add1_6_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 23 => u0_m0_wo0_mtree_mult1_27_shift6_q(22)) & u0_m0_wo0_mtree_mult1_27_shift6_q));
    u0_m0_wo0_mtree_add1_6_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_6_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_6_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_6_a) + SIGNED(u0_m0_wo0_mtree_add1_6_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_6_q <= u0_m0_wo0_mtree_add1_6_o(25 downto 0);

    -- u0_m0_wo0_mtree_add2_3(ADD,163)@14 + 1
    u0_m0_wo0_mtree_add2_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 26 => u0_m0_wo0_mtree_add1_6_q(25)) & u0_m0_wo0_mtree_add1_6_q));
    u0_m0_wo0_mtree_add2_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 26 => u0_m0_wo0_mtree_add1_7_q(25)) & u0_m0_wo0_mtree_add1_7_q));
    u0_m0_wo0_mtree_add2_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add2_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add2_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add2_3_a) + SIGNED(u0_m0_wo0_mtree_add2_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add2_3_q <= u0_m0_wo0_mtree_add2_3_o(26 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr13(DELAY,32)@10
    u0_m0_wo0_wi0_r0_delayr13 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr12_q, xout => u0_m0_wo0_wi0_r0_delayr13_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr13_q_11(DELAY,470)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr13_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr13_q, xout => d_u0_m0_wo0_wi0_r0_delayr13_q_11_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr13_q_12(DELAY,471)@11 + 1
    d_u0_m0_wo0_wi0_r0_delayr13_q_12 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_wi0_r0_delayr13_q_11_q, xout => d_u0_m0_wo0_wi0_r0_delayr13_q_12_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_23_shift2(BITSHIFT,238)@12
    u0_m0_wo0_mtree_mult1_23_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr13_q_12_q & "00000";
    u0_m0_wo0_mtree_mult1_23_shift2_q <= u0_m0_wo0_mtree_mult1_23_shift2_qint(18 downto 0);

    -- u0_m0_wo0_mtree_mult1_23_shift0(BITSHIFT,236)@11
    u0_m0_wo0_mtree_mult1_23_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr13_q_11_q & "000";
    u0_m0_wo0_mtree_mult1_23_shift0_q <= u0_m0_wo0_mtree_mult1_23_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_23_add_1(ADD,237)@11 + 1
    u0_m0_wo0_mtree_mult1_23_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => d_u0_m0_wo0_wi0_r0_delayr13_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr13_q_11_q));
    u0_m0_wo0_mtree_mult1_23_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_23_shift0_q(16)) & u0_m0_wo0_mtree_mult1_23_shift0_q));
    u0_m0_wo0_mtree_mult1_23_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_23_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_23_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_23_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_23_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_23_add_1_q <= u0_m0_wo0_mtree_mult1_23_add_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_23_sub_3(SUB,239)@12 + 1
    u0_m0_wo0_mtree_mult1_23_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 18 => u0_m0_wo0_mtree_mult1_23_add_1_q(17)) & u0_m0_wo0_mtree_mult1_23_add_1_q));
    u0_m0_wo0_mtree_mult1_23_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 19 => u0_m0_wo0_mtree_mult1_23_shift2_q(18)) & u0_m0_wo0_mtree_mult1_23_shift2_q));
    u0_m0_wo0_mtree_mult1_23_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_23_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_23_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_23_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_23_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_23_sub_3_q <= u0_m0_wo0_mtree_mult1_23_sub_3_o(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_23_shift4(BITSHIFT,240)@13
    u0_m0_wo0_mtree_mult1_23_shift4_qint <= u0_m0_wo0_mtree_mult1_23_sub_3_q & "0000";
    u0_m0_wo0_mtree_mult1_23_shift4_q <= u0_m0_wo0_mtree_mult1_23_shift4_qint(23 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr14(DELAY,33)@10
    u0_m0_wo0_wi0_r0_delayr14 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr13_q, xout => u0_m0_wo0_wi0_r0_delayr14_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr15(DELAY,34)@10
    u0_m0_wo0_wi0_r0_delayr15 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr14_q, xout => u0_m0_wo0_wi0_r0_delayr15_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_cm15(CONSTANT,74)@0
    u0_m0_wo0_cm15_q <= "01001100110";

    -- u0_m0_wo0_mtree_mult1_21(MULT,111)@10 + 2
    u0_m0_wo0_mtree_mult1_21_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_cm15_q);
    u0_m0_wo0_mtree_mult1_21_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_delayr15_q);
    u0_m0_wo0_mtree_mult1_21_reset <= areset;
    u0_m0_wo0_mtree_mult1_21_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 11,
        lpm_widthb => 14,
        lpm_widthp => 25,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_21_a0,
        datab => u0_m0_wo0_mtree_mult1_21_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_21_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_21_s1
    );
    u0_m0_wo0_mtree_mult1_21_q <= u0_m0_wo0_mtree_mult1_21_s1;

    -- u0_m0_wo0_wi0_r0_delayr16(DELAY,35)@10
    u0_m0_wo0_wi0_r0_delayr16 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr15_q, xout => u0_m0_wo0_wi0_r0_delayr16_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_cm16(CONSTANT,75)@0
    u0_m0_wo0_cm16_q <= "010100010111";

    -- u0_m0_wo0_mtree_mult1_20(MULT,112)@10 + 2
    u0_m0_wo0_mtree_mult1_20_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_cm16_q);
    u0_m0_wo0_mtree_mult1_20_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_delayr16_q);
    u0_m0_wo0_mtree_mult1_20_reset <= areset;
    u0_m0_wo0_mtree_mult1_20_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 12,
        lpm_widthb => 14,
        lpm_widthp => 26,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_20_a0,
        datab => u0_m0_wo0_mtree_mult1_20_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_20_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_20_s1
    );
    u0_m0_wo0_mtree_mult1_20_q <= u0_m0_wo0_mtree_mult1_20_s1;

    -- u0_m0_wo0_mtree_add0_10(ADD,143)@12 + 1
    u0_m0_wo0_mtree_add0_10_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 26 => u0_m0_wo0_mtree_mult1_20_q(25)) & u0_m0_wo0_mtree_mult1_20_q));
    u0_m0_wo0_mtree_add0_10_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 25 => u0_m0_wo0_mtree_mult1_21_q(24)) & u0_m0_wo0_mtree_mult1_21_q));
    u0_m0_wo0_mtree_add0_10_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_10_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_10_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_10_a) + SIGNED(u0_m0_wo0_mtree_add0_10_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_10_q <= u0_m0_wo0_mtree_add0_10_o(26 downto 0);

    -- u0_m0_wo0_mtree_add1_5(ADD,156)@13 + 1
    u0_m0_wo0_mtree_add1_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((27 downto 27 => u0_m0_wo0_mtree_add0_10_q(26)) & u0_m0_wo0_mtree_add0_10_q));
    u0_m0_wo0_mtree_add1_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((27 downto 24 => u0_m0_wo0_mtree_mult1_23_shift4_q(23)) & u0_m0_wo0_mtree_mult1_23_shift4_q));
    u0_m0_wo0_mtree_add1_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_5_a) + SIGNED(u0_m0_wo0_mtree_add1_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_5_q <= u0_m0_wo0_mtree_add1_5_o(27 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr17(DELAY,36)@10
    u0_m0_wo0_wi0_r0_delayr17 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr16_q, xout => u0_m0_wo0_wi0_r0_delayr17_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_cm17(CONSTANT,76)@0
    u0_m0_wo0_cm17_q <= "011100110010";

    -- u0_m0_wo0_mtree_mult1_19(MULT,113)@10 + 2
    u0_m0_wo0_mtree_mult1_19_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_cm17_q);
    u0_m0_wo0_mtree_mult1_19_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_delayr17_q);
    u0_m0_wo0_mtree_mult1_19_reset <= areset;
    u0_m0_wo0_mtree_mult1_19_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 12,
        lpm_widthb => 14,
        lpm_widthp => 26,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_19_a0,
        datab => u0_m0_wo0_mtree_mult1_19_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_19_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_19_s1
    );
    u0_m0_wo0_mtree_mult1_19_q <= u0_m0_wo0_mtree_mult1_19_s1;

    -- u0_m0_wo0_wi0_r0_delayr18(DELAY,37)@10
    u0_m0_wo0_wi0_r0_delayr18 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr17_q, xout => u0_m0_wo0_wi0_r0_delayr18_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr18_q_11(DELAY,472)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr18_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr18_q, xout => d_u0_m0_wo0_wi0_r0_delayr18_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_18_shift0(BITSHIFT,267)@11
    u0_m0_wo0_mtree_mult1_18_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr18_q_11_q & "00000000000";
    u0_m0_wo0_mtree_mult1_18_shift0_q <= u0_m0_wo0_mtree_mult1_18_shift0_qint(24 downto 0);

    -- u0_m0_wo0_mtree_mult1_18_sub_1(SUB,268)@11 + 1
    u0_m0_wo0_mtree_mult1_18_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 25 => u0_m0_wo0_mtree_mult1_18_shift0_q(24)) & u0_m0_wo0_mtree_mult1_18_shift0_q));
    u0_m0_wo0_mtree_mult1_18_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 14 => d_u0_m0_wo0_wi0_r0_delayr18_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr18_q_11_q));
    u0_m0_wo0_mtree_mult1_18_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_18_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_18_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_18_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_18_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_18_sub_1_q <= u0_m0_wo0_mtree_mult1_18_sub_1_o(25 downto 0);

    -- u0_m0_wo0_mtree_add0_9(ADD,142)@12 + 1
    u0_m0_wo0_mtree_add0_9_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 26 => u0_m0_wo0_mtree_mult1_18_sub_1_q(25)) & u0_m0_wo0_mtree_mult1_18_sub_1_q));
    u0_m0_wo0_mtree_add0_9_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 26 => u0_m0_wo0_mtree_mult1_19_q(25)) & u0_m0_wo0_mtree_mult1_19_q));
    u0_m0_wo0_mtree_add0_9_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_9_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_9_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_9_a) + SIGNED(u0_m0_wo0_mtree_add0_9_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_9_q <= u0_m0_wo0_mtree_add0_9_o(26 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr19(DELAY,38)@10
    u0_m0_wo0_wi0_r0_delayr19 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr18_q, xout => u0_m0_wo0_wi0_r0_delayr19_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_17(MULT,115)@10 + 2
    u0_m0_wo0_mtree_mult1_17_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_cm17_q);
    u0_m0_wo0_mtree_mult1_17_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_delayr19_q);
    u0_m0_wo0_mtree_mult1_17_reset <= areset;
    u0_m0_wo0_mtree_mult1_17_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 12,
        lpm_widthb => 14,
        lpm_widthp => 26,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_17_a0,
        datab => u0_m0_wo0_mtree_mult1_17_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_17_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_17_s1
    );
    u0_m0_wo0_mtree_mult1_17_q <= u0_m0_wo0_mtree_mult1_17_s1;

    -- u0_m0_wo0_wi0_r0_delayr20(DELAY,39)@10
    u0_m0_wo0_wi0_r0_delayr20 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr19_q, xout => u0_m0_wo0_wi0_r0_delayr20_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_16(MULT,116)@10 + 2
    u0_m0_wo0_mtree_mult1_16_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_cm16_q);
    u0_m0_wo0_mtree_mult1_16_b0 <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_delayr20_q);
    u0_m0_wo0_mtree_mult1_16_reset <= areset;
    u0_m0_wo0_mtree_mult1_16_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 12,
        lpm_widthb => 14,
        lpm_widthp => 26,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_16_a0,
        datab => u0_m0_wo0_mtree_mult1_16_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_16_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_16_s1
    );
    u0_m0_wo0_mtree_mult1_16_q <= u0_m0_wo0_mtree_mult1_16_s1;

    -- u0_m0_wo0_mtree_add0_8(ADD,141)@12 + 1
    u0_m0_wo0_mtree_add0_8_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 26 => u0_m0_wo0_mtree_mult1_16_q(25)) & u0_m0_wo0_mtree_mult1_16_q));
    u0_m0_wo0_mtree_add0_8_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 26 => u0_m0_wo0_mtree_mult1_17_q(25)) & u0_m0_wo0_mtree_mult1_17_q));
    u0_m0_wo0_mtree_add0_8_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_8_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_8_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_8_a) + SIGNED(u0_m0_wo0_mtree_add0_8_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_8_q <= u0_m0_wo0_mtree_add0_8_o(26 downto 0);

    -- u0_m0_wo0_mtree_add1_4(ADD,155)@13 + 1
    u0_m0_wo0_mtree_add1_4_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((27 downto 27 => u0_m0_wo0_mtree_add0_8_q(26)) & u0_m0_wo0_mtree_add0_8_q));
    u0_m0_wo0_mtree_add1_4_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((27 downto 27 => u0_m0_wo0_mtree_add0_9_q(26)) & u0_m0_wo0_mtree_add0_9_q));
    u0_m0_wo0_mtree_add1_4_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_4_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_4_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_4_a) + SIGNED(u0_m0_wo0_mtree_add1_4_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_4_q <= u0_m0_wo0_mtree_add1_4_o(27 downto 0);

    -- u0_m0_wo0_mtree_add2_2(ADD,162)@14 + 1
    u0_m0_wo0_mtree_add2_2_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 28 => u0_m0_wo0_mtree_add1_4_q(27)) & u0_m0_wo0_mtree_add1_4_q));
    u0_m0_wo0_mtree_add2_2_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 28 => u0_m0_wo0_mtree_add1_5_q(27)) & u0_m0_wo0_mtree_add1_5_q));
    u0_m0_wo0_mtree_add2_2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add2_2_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add2_2_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add2_2_a) + SIGNED(u0_m0_wo0_mtree_add2_2_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add2_2_q <= u0_m0_wo0_mtree_add2_2_o(28 downto 0);

    -- u0_m0_wo0_mtree_add3_1(ADD,166)@15 + 1
    u0_m0_wo0_mtree_add3_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 29 => u0_m0_wo0_mtree_add2_2_q(28)) & u0_m0_wo0_mtree_add2_2_q));
    u0_m0_wo0_mtree_add3_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((29 downto 27 => u0_m0_wo0_mtree_add2_3_q(26)) & u0_m0_wo0_mtree_add2_3_q));
    u0_m0_wo0_mtree_add3_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add3_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add3_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add3_1_a) + SIGNED(u0_m0_wo0_mtree_add3_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add3_1_q <= u0_m0_wo0_mtree_add3_1_o(29 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr21(DELAY,40)@10
    u0_m0_wo0_wi0_r0_delayr21 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr20_q, xout => u0_m0_wo0_wi0_r0_delayr21_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr21_q_11(DELAY,473)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr21_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr21_q, xout => d_u0_m0_wo0_wi0_r0_delayr21_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_15(MULT,117)@11 + 2
    u0_m0_wo0_mtree_mult1_15_a0 <= STD_LOGIC_VECTOR(u0_m0_wo0_cm15_q);
    u0_m0_wo0_mtree_mult1_15_b0 <= STD_LOGIC_VECTOR(d_u0_m0_wo0_wi0_r0_delayr21_q_11_q);
    u0_m0_wo0_mtree_mult1_15_reset <= areset;
    u0_m0_wo0_mtree_mult1_15_component : lpm_mult
    GENERIC MAP (
        lpm_widtha => 11,
        lpm_widthb => 14,
        lpm_widthp => 25,
        lpm_widths => 1,
        lpm_type => "LPM_MULT",
        lpm_representation => "SIGNED",
        lpm_hint => "DEDICATED_MULTIPLIER_CIRCUITRY=YES, MAXIMIZE_SPEED=5",
        lpm_pipeline => 2
    )
    PORT MAP (
        dataa => u0_m0_wo0_mtree_mult1_15_a0,
        datab => u0_m0_wo0_mtree_mult1_15_b0,
        clken => VCC_q(0),
        aclr => u0_m0_wo0_mtree_mult1_15_reset,
        clock => clk,
        result => u0_m0_wo0_mtree_mult1_15_s1
    );
    u0_m0_wo0_mtree_mult1_15_q <= u0_m0_wo0_mtree_mult1_15_s1;

    -- u0_m0_wo0_wi0_r0_delayr22(DELAY,41)@10
    u0_m0_wo0_wi0_r0_delayr22 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr21_q, xout => u0_m0_wo0_wi0_r0_delayr22_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr23(DELAY,42)@10
    u0_m0_wo0_wi0_r0_delayr23 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr22_q, xout => u0_m0_wo0_wi0_r0_delayr23_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr23_q_11(DELAY,474)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr23_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr23_q, xout => d_u0_m0_wo0_wi0_r0_delayr23_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_13_shift2(BITSHIFT,297)@11
    u0_m0_wo0_mtree_mult1_13_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr23_q_11_q & "00000";
    u0_m0_wo0_mtree_mult1_13_shift2_q <= u0_m0_wo0_mtree_mult1_13_shift2_qint(18 downto 0);

    -- u0_m0_wo0_mtree_mult1_13_shift0(BITSHIFT,295)@10
    u0_m0_wo0_mtree_mult1_13_shift0_qint <= u0_m0_wo0_wi0_r0_delayr23_q & "000";
    u0_m0_wo0_mtree_mult1_13_shift0_q <= u0_m0_wo0_mtree_mult1_13_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_13_add_1(ADD,296)@10 + 1
    u0_m0_wo0_mtree_mult1_13_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr23_q(13)) & u0_m0_wo0_wi0_r0_delayr23_q));
    u0_m0_wo0_mtree_mult1_13_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_13_shift0_q(16)) & u0_m0_wo0_mtree_mult1_13_shift0_q));
    u0_m0_wo0_mtree_mult1_13_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_13_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_13_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_13_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_13_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_13_add_1_q <= u0_m0_wo0_mtree_mult1_13_add_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_13_sub_3(SUB,298)@11 + 1
    u0_m0_wo0_mtree_mult1_13_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 18 => u0_m0_wo0_mtree_mult1_13_add_1_q(17)) & u0_m0_wo0_mtree_mult1_13_add_1_q));
    u0_m0_wo0_mtree_mult1_13_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 19 => u0_m0_wo0_mtree_mult1_13_shift2_q(18)) & u0_m0_wo0_mtree_mult1_13_shift2_q));
    u0_m0_wo0_mtree_mult1_13_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_13_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_13_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_13_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_13_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_13_sub_3_q <= u0_m0_wo0_mtree_mult1_13_sub_3_o(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_13_shift4(BITSHIFT,299)@12
    u0_m0_wo0_mtree_mult1_13_shift4_qint <= u0_m0_wo0_mtree_mult1_13_sub_3_q & "0000";
    u0_m0_wo0_mtree_mult1_13_shift4_q <= u0_m0_wo0_mtree_mult1_13_shift4_qint(23 downto 0);

    -- u0_m0_wo0_mtree_mult1_12_shift2(BITSHIFT,302)@10
    u0_m0_wo0_mtree_mult1_12_shift2_qint <= u0_m0_wo0_wi0_r0_delayr24_q & "000";
    u0_m0_wo0_mtree_mult1_12_shift2_q <= u0_m0_wo0_mtree_mult1_12_shift2_qint(16 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr24(DELAY,43)@10
    u0_m0_wo0_wi0_r0_delayr24 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr23_q, xout => u0_m0_wo0_wi0_r0_delayr24_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_12_sub_3(SUB,303)@10 + 1
    u0_m0_wo0_mtree_mult1_12_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr24_q(13)) & u0_m0_wo0_wi0_r0_delayr24_q));
    u0_m0_wo0_mtree_mult1_12_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_12_shift2_q(16)) & u0_m0_wo0_mtree_mult1_12_shift2_q));
    u0_m0_wo0_mtree_mult1_12_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_12_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_12_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_12_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_12_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_12_sub_3_q <= u0_m0_wo0_mtree_mult1_12_sub_3_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_12_shift4(BITSHIFT,304)@11
    u0_m0_wo0_mtree_mult1_12_shift4_qint <= u0_m0_wo0_mtree_mult1_12_sub_3_q & "00000";
    u0_m0_wo0_mtree_mult1_12_shift4_q <= u0_m0_wo0_mtree_mult1_12_shift4_qint(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_12_shift0(BITSHIFT,300)@10
    u0_m0_wo0_mtree_mult1_12_shift0_qint <= u0_m0_wo0_wi0_r0_delayr24_q & "000";
    u0_m0_wo0_mtree_mult1_12_shift0_q <= u0_m0_wo0_mtree_mult1_12_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_12_sub_1(SUB,301)@10 + 1
    u0_m0_wo0_mtree_mult1_12_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_12_shift0_q(16)) & u0_m0_wo0_mtree_mult1_12_shift0_q));
    u0_m0_wo0_mtree_mult1_12_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr24_q(13)) & u0_m0_wo0_wi0_r0_delayr24_q));
    u0_m0_wo0_mtree_mult1_12_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_12_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_12_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_12_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_12_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_12_sub_1_q <= u0_m0_wo0_mtree_mult1_12_sub_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_12_add_5(ADD,305)@11 + 1
    u0_m0_wo0_mtree_mult1_12_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 18 => u0_m0_wo0_mtree_mult1_12_sub_1_q(17)) & u0_m0_wo0_mtree_mult1_12_sub_1_q));
    u0_m0_wo0_mtree_mult1_12_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 23 => u0_m0_wo0_mtree_mult1_12_shift4_q(22)) & u0_m0_wo0_mtree_mult1_12_shift4_q));
    u0_m0_wo0_mtree_mult1_12_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_12_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_12_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_12_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_12_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_12_add_5_q <= u0_m0_wo0_mtree_mult1_12_add_5_o(23 downto 0);

    -- u0_m0_wo0_mtree_mult1_12_shift6(BITSHIFT,306)@12
    u0_m0_wo0_mtree_mult1_12_shift6_qint <= u0_m0_wo0_mtree_mult1_12_add_5_q & "0";
    u0_m0_wo0_mtree_mult1_12_shift6_q <= u0_m0_wo0_mtree_mult1_12_shift6_qint(24 downto 0);

    -- u0_m0_wo0_mtree_add0_6(ADD,139)@12 + 1
    u0_m0_wo0_mtree_add0_6_a <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_12_shift6_q);
    u0_m0_wo0_mtree_add0_6_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 24 => u0_m0_wo0_mtree_mult1_13_shift4_q(23)) & u0_m0_wo0_mtree_mult1_13_shift4_q));
    u0_m0_wo0_mtree_add0_6_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_6_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_6_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_6_a) + SIGNED(u0_m0_wo0_mtree_add0_6_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_6_q <= u0_m0_wo0_mtree_add0_6_o(24 downto 0);

    -- u0_m0_wo0_mtree_add1_3(ADD,154)@13 + 1
    u0_m0_wo0_mtree_add1_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 25 => u0_m0_wo0_mtree_add0_6_q(24)) & u0_m0_wo0_mtree_add0_6_q));
    u0_m0_wo0_mtree_add1_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((26 downto 25 => u0_m0_wo0_mtree_mult1_15_q(24)) & u0_m0_wo0_mtree_mult1_15_q));
    u0_m0_wo0_mtree_add1_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_3_a) + SIGNED(u0_m0_wo0_mtree_add1_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_3_q <= u0_m0_wo0_mtree_add1_3_o(26 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr25(DELAY,44)@10
    u0_m0_wo0_wi0_r0_delayr25 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr24_q, xout => u0_m0_wo0_wi0_r0_delayr25_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr25_q_11(DELAY,475)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr25_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr25_q, xout => d_u0_m0_wo0_wi0_r0_delayr25_q_11_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr25_q_12(DELAY,476)@11 + 1
    d_u0_m0_wo0_wi0_r0_delayr25_q_12 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_wi0_r0_delayr25_q_11_q, xout => d_u0_m0_wo0_wi0_r0_delayr25_q_12_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_11_shift2(BITSHIFT,309)@12
    u0_m0_wo0_mtree_mult1_11_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr25_q_12_q & "00000000";
    u0_m0_wo0_mtree_mult1_11_shift2_q <= u0_m0_wo0_mtree_mult1_11_shift2_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_11_shift0(BITSHIFT,307)@11
    u0_m0_wo0_mtree_mult1_11_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr25_q_11_q & "000";
    u0_m0_wo0_mtree_mult1_11_shift0_q <= u0_m0_wo0_mtree_mult1_11_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_11_sub_1(SUB,308)@11 + 1
    u0_m0_wo0_mtree_mult1_11_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => d_u0_m0_wo0_wi0_r0_delayr25_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr25_q_11_q));
    u0_m0_wo0_mtree_mult1_11_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_11_shift0_q(16)) & u0_m0_wo0_mtree_mult1_11_shift0_q));
    u0_m0_wo0_mtree_mult1_11_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_11_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_11_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_11_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_11_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_11_sub_1_q <= u0_m0_wo0_mtree_mult1_11_sub_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_11_sub_3(SUB,310)@12 + 1
    u0_m0_wo0_mtree_mult1_11_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 18 => u0_m0_wo0_mtree_mult1_11_sub_1_q(17)) & u0_m0_wo0_mtree_mult1_11_sub_1_q));
    u0_m0_wo0_mtree_mult1_11_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_11_shift2_q(21)) & u0_m0_wo0_mtree_mult1_11_shift2_q));
    u0_m0_wo0_mtree_mult1_11_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_11_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_11_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_11_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_11_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_11_sub_3_q <= u0_m0_wo0_mtree_mult1_11_sub_3_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_9_shift2(BITSHIFT,313)@10
    u0_m0_wo0_mtree_mult1_9_shift2_qint <= u0_m0_wo0_wi0_r0_delayr27_q & "0";
    u0_m0_wo0_mtree_mult1_9_shift2_q <= u0_m0_wo0_mtree_mult1_9_shift2_qint(14 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr26(DELAY,45)@10
    u0_m0_wo0_wi0_r0_delayr26 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr25_q, xout => u0_m0_wo0_wi0_r0_delayr26_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr27(DELAY,46)@10
    u0_m0_wo0_wi0_r0_delayr27 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr26_q, xout => u0_m0_wo0_wi0_r0_delayr27_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_9_add_3(ADD,314)@10 + 1
    u0_m0_wo0_mtree_mult1_9_add_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 14 => u0_m0_wo0_wi0_r0_delayr27_q(13)) & u0_m0_wo0_wi0_r0_delayr27_q));
    u0_m0_wo0_mtree_mult1_9_add_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 15 => u0_m0_wo0_mtree_mult1_9_shift2_q(14)) & u0_m0_wo0_mtree_mult1_9_shift2_q));
    u0_m0_wo0_mtree_mult1_9_add_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_9_add_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_9_add_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_9_add_3_a) + SIGNED(u0_m0_wo0_mtree_mult1_9_add_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_9_add_3_q <= u0_m0_wo0_mtree_mult1_9_add_3_o(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_9_shift4(BITSHIFT,315)@11
    u0_m0_wo0_mtree_mult1_9_shift4_qint <= u0_m0_wo0_mtree_mult1_9_add_3_q & "0000";
    u0_m0_wo0_mtree_mult1_9_shift4_q <= u0_m0_wo0_mtree_mult1_9_shift4_qint(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_9_shift0(BITSHIFT,311)@10
    u0_m0_wo0_mtree_mult1_9_shift0_qint <= u0_m0_wo0_wi0_r0_delayr27_q & "0";
    u0_m0_wo0_mtree_mult1_9_shift0_q <= u0_m0_wo0_mtree_mult1_9_shift0_qint(14 downto 0);

    -- u0_m0_wo0_mtree_mult1_9_add_1(ADD,312)@10 + 1
    u0_m0_wo0_mtree_mult1_9_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 14 => u0_m0_wo0_wi0_r0_delayr27_q(13)) & u0_m0_wo0_wi0_r0_delayr27_q));
    u0_m0_wo0_mtree_mult1_9_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((15 downto 15 => u0_m0_wo0_mtree_mult1_9_shift0_q(14)) & u0_m0_wo0_mtree_mult1_9_shift0_q));
    u0_m0_wo0_mtree_mult1_9_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_9_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_9_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_9_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_9_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_9_add_1_q <= u0_m0_wo0_mtree_mult1_9_add_1_o(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_9_add_5(ADD,316)@11 + 1
    u0_m0_wo0_mtree_mult1_9_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 16 => u0_m0_wo0_mtree_mult1_9_add_1_q(15)) & u0_m0_wo0_mtree_mult1_9_add_1_q));
    u0_m0_wo0_mtree_mult1_9_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 20 => u0_m0_wo0_mtree_mult1_9_shift4_q(19)) & u0_m0_wo0_mtree_mult1_9_shift4_q));
    u0_m0_wo0_mtree_mult1_9_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_9_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_9_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_9_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_9_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_9_add_5_q <= u0_m0_wo0_mtree_mult1_9_add_5_o(20 downto 0);

    -- u0_m0_wo0_mtree_mult1_9_shift6(BITSHIFT,317)@12
    u0_m0_wo0_mtree_mult1_9_shift6_qint <= u0_m0_wo0_mtree_mult1_9_add_5_q & "00";
    u0_m0_wo0_mtree_mult1_9_shift6_q <= u0_m0_wo0_mtree_mult1_9_shift6_qint(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_8_shift0(BITSHIFT,318)@11
    u0_m0_wo0_mtree_mult1_8_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr28_q_11_q & "000000";
    u0_m0_wo0_mtree_mult1_8_shift0_q <= u0_m0_wo0_mtree_mult1_8_shift0_qint(19 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr28(DELAY,47)@10
    u0_m0_wo0_wi0_r0_delayr28 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr27_q, xout => u0_m0_wo0_wi0_r0_delayr28_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr28_q_11(DELAY,477)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr28_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr28_q, xout => d_u0_m0_wo0_wi0_r0_delayr28_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_8_add_1(ADD,319)@11 + 1
    u0_m0_wo0_mtree_mult1_8_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 14 => d_u0_m0_wo0_wi0_r0_delayr28_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr28_q_11_q));
    u0_m0_wo0_mtree_mult1_8_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 20 => u0_m0_wo0_mtree_mult1_8_shift0_q(19)) & u0_m0_wo0_mtree_mult1_8_shift0_q));
    u0_m0_wo0_mtree_mult1_8_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_8_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_8_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_8_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_8_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_8_add_1_q <= u0_m0_wo0_mtree_mult1_8_add_1_o(20 downto 0);

    -- u0_m0_wo0_mtree_mult1_8_shift2(BITSHIFT,320)@12
    u0_m0_wo0_mtree_mult1_8_shift2_qint <= u0_m0_wo0_mtree_mult1_8_add_1_q & "00";
    u0_m0_wo0_mtree_mult1_8_shift2_q <= u0_m0_wo0_mtree_mult1_8_shift2_qint(22 downto 0);

    -- u0_m0_wo0_mtree_add0_4(ADD,137)@12 + 1
    u0_m0_wo0_mtree_add0_4_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 23 => u0_m0_wo0_mtree_mult1_8_shift2_q(22)) & u0_m0_wo0_mtree_mult1_8_shift2_q));
    u0_m0_wo0_mtree_add0_4_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 23 => u0_m0_wo0_mtree_mult1_9_shift6_q(22)) & u0_m0_wo0_mtree_mult1_9_shift6_q));
    u0_m0_wo0_mtree_add0_4_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_4_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_4_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_4_a) + SIGNED(u0_m0_wo0_mtree_add0_4_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_4_q <= u0_m0_wo0_mtree_add0_4_o(23 downto 0);

    -- u0_m0_wo0_mtree_add1_2(ADD,153)@13 + 1
    u0_m0_wo0_mtree_add1_2_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 24 => u0_m0_wo0_mtree_add0_4_q(23)) & u0_m0_wo0_mtree_add0_4_q));
    u0_m0_wo0_mtree_add1_2_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 23 => u0_m0_wo0_mtree_mult1_11_sub_3_q(22)) & u0_m0_wo0_mtree_mult1_11_sub_3_q));
    u0_m0_wo0_mtree_add1_2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_2_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_2_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_2_a) + SIGNED(u0_m0_wo0_mtree_add1_2_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_2_q <= u0_m0_wo0_mtree_add1_2_o(25 downto 0);

    -- u0_m0_wo0_mtree_add2_1(ADD,161)@14 + 1
    u0_m0_wo0_mtree_add2_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((27 downto 26 => u0_m0_wo0_mtree_add1_2_q(25)) & u0_m0_wo0_mtree_add1_2_q));
    u0_m0_wo0_mtree_add2_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((27 downto 27 => u0_m0_wo0_mtree_add1_3_q(26)) & u0_m0_wo0_mtree_add1_3_q));
    u0_m0_wo0_mtree_add2_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add2_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add2_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add2_1_a) + SIGNED(u0_m0_wo0_mtree_add2_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add2_1_q <= u0_m0_wo0_mtree_add2_1_o(27 downto 0);

    -- u0_m0_wo0_mtree_mult1_7_shift2(BITSHIFT,323)@11
    u0_m0_wo0_mtree_mult1_7_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr29_q_11_q & "00";
    u0_m0_wo0_mtree_mult1_7_shift2_q <= u0_m0_wo0_mtree_mult1_7_shift2_qint(15 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr29(DELAY,48)@10
    u0_m0_wo0_wi0_r0_delayr29 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr28_q, xout => u0_m0_wo0_wi0_r0_delayr29_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr29_q_11(DELAY,478)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr29_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr29_q, xout => d_u0_m0_wo0_wi0_r0_delayr29_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_7_add_3(ADD,324)@11 + 1
    u0_m0_wo0_mtree_mult1_7_add_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => d_u0_m0_wo0_wi0_r0_delayr29_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr29_q_11_q));
    u0_m0_wo0_mtree_mult1_7_add_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_7_shift2_q(15)) & u0_m0_wo0_mtree_mult1_7_shift2_q));
    u0_m0_wo0_mtree_mult1_7_add_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_7_add_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_7_add_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_7_add_3_a) + SIGNED(u0_m0_wo0_mtree_mult1_7_add_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_7_add_3_q <= u0_m0_wo0_mtree_mult1_7_add_3_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_7_shift4(BITSHIFT,325)@12
    u0_m0_wo0_mtree_mult1_7_shift4_qint <= u0_m0_wo0_mtree_mult1_7_add_3_q & "00000";
    u0_m0_wo0_mtree_mult1_7_shift4_q <= u0_m0_wo0_mtree_mult1_7_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_7_shift0(BITSHIFT,321)@11
    u0_m0_wo0_mtree_mult1_7_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr29_q_11_q & "000";
    u0_m0_wo0_mtree_mult1_7_shift0_q <= u0_m0_wo0_mtree_mult1_7_shift0_qint(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_7_sub_1(SUB,322)@11 + 1
    u0_m0_wo0_mtree_mult1_7_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_7_shift0_q(16)) & u0_m0_wo0_mtree_mult1_7_shift0_q));
    u0_m0_wo0_mtree_mult1_7_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => d_u0_m0_wo0_wi0_r0_delayr29_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr29_q_11_q));
    u0_m0_wo0_mtree_mult1_7_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_7_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_7_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_7_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_7_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_7_sub_1_q <= u0_m0_wo0_mtree_mult1_7_sub_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_7_add_5(ADD,326)@12 + 1
    u0_m0_wo0_mtree_mult1_7_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 18 => u0_m0_wo0_mtree_mult1_7_sub_1_q(17)) & u0_m0_wo0_mtree_mult1_7_sub_1_q));
    u0_m0_wo0_mtree_mult1_7_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_7_shift4_q(21)) & u0_m0_wo0_mtree_mult1_7_shift4_q));
    u0_m0_wo0_mtree_mult1_7_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_7_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_7_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_7_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_7_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_7_add_5_q <= u0_m0_wo0_mtree_mult1_7_add_5_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_5_shift2(BITSHIFT,329)@10
    u0_m0_wo0_mtree_mult1_5_shift2_qint <= u0_m0_wo0_wi0_r0_delayr31_q & "000";
    u0_m0_wo0_mtree_mult1_5_shift2_q <= u0_m0_wo0_mtree_mult1_5_shift2_qint(16 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr30(DELAY,49)@10
    u0_m0_wo0_wi0_r0_delayr30 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr29_q, xout => u0_m0_wo0_wi0_r0_delayr30_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr31(DELAY,50)@10
    u0_m0_wo0_wi0_r0_delayr31 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr30_q, xout => u0_m0_wo0_wi0_r0_delayr31_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_5_add_3(ADD,330)@10 + 1
    u0_m0_wo0_mtree_mult1_5_add_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr31_q(13)) & u0_m0_wo0_wi0_r0_delayr31_q));
    u0_m0_wo0_mtree_mult1_5_add_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_5_shift2_q(16)) & u0_m0_wo0_mtree_mult1_5_shift2_q));
    u0_m0_wo0_mtree_mult1_5_add_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_5_add_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_5_add_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_5_add_3_a) + SIGNED(u0_m0_wo0_mtree_mult1_5_add_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_5_add_3_q <= u0_m0_wo0_mtree_mult1_5_add_3_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_5_shift4(BITSHIFT,331)@11
    u0_m0_wo0_mtree_mult1_5_shift4_qint <= u0_m0_wo0_mtree_mult1_5_add_3_q & "0000";
    u0_m0_wo0_mtree_mult1_5_shift4_q <= u0_m0_wo0_mtree_mult1_5_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_5_shift0(BITSHIFT,327)@10
    u0_m0_wo0_mtree_mult1_5_shift0_qint <= u0_m0_wo0_wi0_r0_delayr31_q & "00";
    u0_m0_wo0_mtree_mult1_5_shift0_q <= u0_m0_wo0_mtree_mult1_5_shift0_qint(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_5_sub_1(SUB,328)@10 + 1
    u0_m0_wo0_mtree_mult1_5_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_5_shift0_q(15)) & u0_m0_wo0_mtree_mult1_5_shift0_q));
    u0_m0_wo0_mtree_mult1_5_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => u0_m0_wo0_wi0_r0_delayr31_q(13)) & u0_m0_wo0_wi0_r0_delayr31_q));
    u0_m0_wo0_mtree_mult1_5_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_5_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_5_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_5_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_5_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_5_sub_1_q <= u0_m0_wo0_mtree_mult1_5_sub_1_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_5_sub_5(SUB,332)@11 + 1
    u0_m0_wo0_mtree_mult1_5_sub_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 17 => u0_m0_wo0_mtree_mult1_5_sub_1_q(16)) & u0_m0_wo0_mtree_mult1_5_sub_1_q));
    u0_m0_wo0_mtree_mult1_5_sub_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_5_shift4_q(21)) & u0_m0_wo0_mtree_mult1_5_shift4_q));
    u0_m0_wo0_mtree_mult1_5_sub_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_5_sub_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_5_sub_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_5_sub_5_a) - SIGNED(u0_m0_wo0_mtree_mult1_5_sub_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_5_sub_5_q <= u0_m0_wo0_mtree_mult1_5_sub_5_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_4_shift2(BITSHIFT,335)@10
    u0_m0_wo0_mtree_mult1_4_shift2_qint <= u0_m0_wo0_wi0_r0_delayr32_q & "00";
    u0_m0_wo0_mtree_mult1_4_shift2_q <= u0_m0_wo0_mtree_mult1_4_shift2_qint(15 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr32(DELAY,51)@10
    u0_m0_wo0_wi0_r0_delayr32 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr31_q, xout => u0_m0_wo0_wi0_r0_delayr32_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_4_sub_3(SUB,336)@10 + 1
    u0_m0_wo0_mtree_mult1_4_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => u0_m0_wo0_wi0_r0_delayr32_q(13)) & u0_m0_wo0_wi0_r0_delayr32_q));
    u0_m0_wo0_mtree_mult1_4_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_4_shift2_q(15)) & u0_m0_wo0_mtree_mult1_4_shift2_q));
    u0_m0_wo0_mtree_mult1_4_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_4_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_4_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_4_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_4_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_4_sub_3_q <= u0_m0_wo0_mtree_mult1_4_sub_3_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_4_shift4(BITSHIFT,337)@11
    u0_m0_wo0_mtree_mult1_4_shift4_qint <= u0_m0_wo0_mtree_mult1_4_sub_3_q & "00000";
    u0_m0_wo0_mtree_mult1_4_shift4_q <= u0_m0_wo0_mtree_mult1_4_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_4_shift0(BITSHIFT,333)@10
    u0_m0_wo0_mtree_mult1_4_shift0_qint <= u0_m0_wo0_wi0_r0_delayr32_q & "00";
    u0_m0_wo0_mtree_mult1_4_shift0_q <= u0_m0_wo0_mtree_mult1_4_shift0_qint(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_4_sub_1(SUB,334)@10 + 1
    u0_m0_wo0_mtree_mult1_4_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_4_shift0_q(15)) & u0_m0_wo0_mtree_mult1_4_shift0_q));
    u0_m0_wo0_mtree_mult1_4_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => u0_m0_wo0_wi0_r0_delayr32_q(13)) & u0_m0_wo0_wi0_r0_delayr32_q));
    u0_m0_wo0_mtree_mult1_4_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_4_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_4_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_4_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_4_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_4_sub_1_q <= u0_m0_wo0_mtree_mult1_4_sub_1_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_4_add_5(ADD,338)@11 + 1
    u0_m0_wo0_mtree_mult1_4_add_5_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 17 => u0_m0_wo0_mtree_mult1_4_sub_1_q(16)) & u0_m0_wo0_mtree_mult1_4_sub_1_q));
    u0_m0_wo0_mtree_mult1_4_add_5_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_4_shift4_q(21)) & u0_m0_wo0_mtree_mult1_4_shift4_q));
    u0_m0_wo0_mtree_mult1_4_add_5_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_4_add_5_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_4_add_5_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_4_add_5_a) + SIGNED(u0_m0_wo0_mtree_mult1_4_add_5_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_4_add_5_q <= u0_m0_wo0_mtree_mult1_4_add_5_o(22 downto 0);

    -- u0_m0_wo0_mtree_mult1_4_shift6(BITSHIFT,339)@12
    u0_m0_wo0_mtree_mult1_4_shift6_qint <= u0_m0_wo0_mtree_mult1_4_add_5_q & "0";
    u0_m0_wo0_mtree_mult1_4_shift6_q <= u0_m0_wo0_mtree_mult1_4_shift6_qint(23 downto 0);

    -- u0_m0_wo0_mtree_add0_2(ADD,135)@12 + 1
    u0_m0_wo0_mtree_add0_2_a <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_4_shift6_q);
    u0_m0_wo0_mtree_add0_2_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((23 downto 23 => u0_m0_wo0_mtree_mult1_5_sub_5_q(22)) & u0_m0_wo0_mtree_mult1_5_sub_5_q));
    u0_m0_wo0_mtree_add0_2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_2_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_2_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_2_a) + SIGNED(u0_m0_wo0_mtree_add0_2_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_2_q <= u0_m0_wo0_mtree_add0_2_o(23 downto 0);

    -- u0_m0_wo0_mtree_add1_1(ADD,152)@13 + 1
    u0_m0_wo0_mtree_add1_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 24 => u0_m0_wo0_mtree_add0_2_q(23)) & u0_m0_wo0_mtree_add0_2_q));
    u0_m0_wo0_mtree_add1_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 23 => u0_m0_wo0_mtree_mult1_7_add_5_q(22)) & u0_m0_wo0_mtree_mult1_7_add_5_q));
    u0_m0_wo0_mtree_add1_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_1_a) + SIGNED(u0_m0_wo0_mtree_add1_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_1_q <= u0_m0_wo0_mtree_add1_1_o(24 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr33(DELAY,52)@10
    u0_m0_wo0_wi0_r0_delayr33 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr32_q, xout => u0_m0_wo0_wi0_r0_delayr33_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr33_q_11(DELAY,479)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr33_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr33_q, xout => d_u0_m0_wo0_wi0_r0_delayr33_q_11_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_delayr33_q_12(DELAY,480)@11 + 1
    d_u0_m0_wo0_wi0_r0_delayr33_q_12 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_wi0_r0_delayr33_q_11_q, xout => d_u0_m0_wo0_wi0_r0_delayr33_q_12_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_3_shift2(BITSHIFT,342)@12
    u0_m0_wo0_mtree_mult1_3_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr33_q_12_q & "000000";
    u0_m0_wo0_mtree_mult1_3_shift2_q <= u0_m0_wo0_mtree_mult1_3_shift2_qint(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_3_shift0(BITSHIFT,340)@11
    u0_m0_wo0_mtree_mult1_3_shift0_qint <= d_u0_m0_wo0_wi0_r0_delayr33_q_11_q & "00";
    u0_m0_wo0_mtree_mult1_3_shift0_q <= u0_m0_wo0_mtree_mult1_3_shift0_qint(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_3_sub_1(SUB,341)@11 + 1
    u0_m0_wo0_mtree_mult1_3_sub_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_3_shift0_q(15)) & u0_m0_wo0_mtree_mult1_3_shift0_q));
    u0_m0_wo0_mtree_mult1_3_sub_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => d_u0_m0_wo0_wi0_r0_delayr33_q_11_q(13)) & d_u0_m0_wo0_wi0_r0_delayr33_q_11_q));
    u0_m0_wo0_mtree_mult1_3_sub_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_3_sub_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_3_sub_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_3_sub_1_a) - SIGNED(u0_m0_wo0_mtree_mult1_3_sub_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_3_sub_1_q <= u0_m0_wo0_mtree_mult1_3_sub_1_o(16 downto 0);

    -- u0_m0_wo0_mtree_mult1_3_sub_3(SUB,343)@12 + 1
    u0_m0_wo0_mtree_mult1_3_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 17 => u0_m0_wo0_mtree_mult1_3_sub_1_q(16)) & u0_m0_wo0_mtree_mult1_3_sub_1_q));
    u0_m0_wo0_mtree_mult1_3_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((20 downto 20 => u0_m0_wo0_mtree_mult1_3_shift2_q(19)) & u0_m0_wo0_mtree_mult1_3_shift2_q));
    u0_m0_wo0_mtree_mult1_3_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_3_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_3_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_3_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_3_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_3_sub_3_q <= u0_m0_wo0_mtree_mult1_3_sub_3_o(20 downto 0);

    -- u0_m0_wo0_mtree_mult1_3_shift4(BITSHIFT,344)@13
    u0_m0_wo0_mtree_mult1_3_shift4_qint <= u0_m0_wo0_mtree_mult1_3_sub_3_q & "0";
    u0_m0_wo0_mtree_mult1_3_shift4_q <= u0_m0_wo0_mtree_mult1_3_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_1_shift0(BITSHIFT,345)@10
    u0_m0_wo0_mtree_mult1_1_shift0_qint <= u0_m0_wo0_wi0_r0_delayr35_q & "00";
    u0_m0_wo0_mtree_mult1_1_shift0_q <= u0_m0_wo0_mtree_mult1_1_shift0_qint(15 downto 0);

    -- u0_m0_wo0_wi0_r0_delayr34(DELAY,53)@10
    u0_m0_wo0_wi0_r0_delayr34 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr33_q, xout => u0_m0_wo0_wi0_r0_delayr34_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr35(DELAY,54)@10
    u0_m0_wo0_wi0_r0_delayr35 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr34_q, xout => u0_m0_wo0_wi0_r0_delayr35_q, ena => xIn_v(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_1_add_1(ADD,346)@10 + 1
    u0_m0_wo0_mtree_mult1_1_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 14 => u0_m0_wo0_wi0_r0_delayr35_q(13)) & u0_m0_wo0_wi0_r0_delayr35_q));
    u0_m0_wo0_mtree_mult1_1_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((16 downto 16 => u0_m0_wo0_mtree_mult1_1_shift0_q(15)) & u0_m0_wo0_mtree_mult1_1_shift0_q));
    u0_m0_wo0_mtree_mult1_1_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_1_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_1_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_1_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_1_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_1_add_1_q <= u0_m0_wo0_mtree_mult1_1_add_1_o(16 downto 0);

    -- d_u0_m0_wo0_wi0_r0_delayr35_q_11(DELAY,481)@10 + 1
    d_u0_m0_wo0_wi0_r0_delayr35_q_11 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_delayr35_q, xout => d_u0_m0_wo0_wi0_r0_delayr35_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_1_shift2(BITSHIFT,347)@11
    u0_m0_wo0_mtree_mult1_1_shift2_qint <= d_u0_m0_wo0_wi0_r0_delayr35_q_11_q & "00000";
    u0_m0_wo0_mtree_mult1_1_shift2_q <= u0_m0_wo0_mtree_mult1_1_shift2_qint(18 downto 0);

    -- u0_m0_wo0_mtree_mult1_1_sub_3(SUB,348)@11 + 1
    u0_m0_wo0_mtree_mult1_1_sub_3_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 19 => u0_m0_wo0_mtree_mult1_1_shift2_q(18)) & u0_m0_wo0_mtree_mult1_1_shift2_q));
    u0_m0_wo0_mtree_mult1_1_sub_3_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((19 downto 17 => u0_m0_wo0_mtree_mult1_1_add_1_q(16)) & u0_m0_wo0_mtree_mult1_1_add_1_q));
    u0_m0_wo0_mtree_mult1_1_sub_3_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_1_sub_3_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_1_sub_3_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_1_sub_3_a) - SIGNED(u0_m0_wo0_mtree_mult1_1_sub_3_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_1_sub_3_q <= u0_m0_wo0_mtree_mult1_1_sub_3_o(19 downto 0);

    -- u0_m0_wo0_mtree_mult1_1_shift4(BITSHIFT,349)@12
    u0_m0_wo0_mtree_mult1_1_shift4_qint <= u0_m0_wo0_mtree_mult1_1_sub_3_q & "00";
    u0_m0_wo0_mtree_mult1_1_shift4_q <= u0_m0_wo0_mtree_mult1_1_shift4_qint(21 downto 0);

    -- u0_m0_wo0_mtree_mult1_0_shift0(BITSHIFT,350)@11
    u0_m0_wo0_mtree_mult1_0_shift0_qint <= u0_m0_wo0_wi0_r0_delayr36_q & "000";
    u0_m0_wo0_mtree_mult1_0_shift0_q <= u0_m0_wo0_mtree_mult1_0_shift0_qint(16 downto 0);

    -- d_u0_m0_wo0_memread_q_11(DELAY,457)@10 + 1
    d_u0_m0_wo0_memread_q_11 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_v, xout => d_u0_m0_wo0_memread_q_11_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_11(DELAY,458)@10 + 1
    d_u0_m0_wo0_compute_q_11 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_v, xout => d_u0_m0_wo0_compute_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_delayr36(DELAY,55)@11
    u0_m0_wo0_wi0_r0_delayr36 : dspba_delay
    GENERIC MAP ( width => 14, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_wi0_r0_delayr35_q_11_q, xout => u0_m0_wo0_wi0_r0_delayr36_q, ena => d_u0_m0_wo0_compute_q_11_q(0), clk => clk, aclr => areset );

    -- u0_m0_wo0_mtree_mult1_0_add_1(ADD,351)@11 + 1
    u0_m0_wo0_mtree_mult1_0_add_1_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 14 => u0_m0_wo0_wi0_r0_delayr36_q(13)) & u0_m0_wo0_wi0_r0_delayr36_q));
    u0_m0_wo0_mtree_mult1_0_add_1_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((17 downto 17 => u0_m0_wo0_mtree_mult1_0_shift0_q(16)) & u0_m0_wo0_mtree_mult1_0_shift0_q));
    u0_m0_wo0_mtree_mult1_0_add_1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_0_add_1_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_0_add_1_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_mult1_0_add_1_a) + SIGNED(u0_m0_wo0_mtree_mult1_0_add_1_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_0_add_1_q <= u0_m0_wo0_mtree_mult1_0_add_1_o(17 downto 0);

    -- u0_m0_wo0_mtree_mult1_0_shift2(BITSHIFT,352)@12
    u0_m0_wo0_mtree_mult1_0_shift2_qint <= u0_m0_wo0_mtree_mult1_0_add_1_q & "0000";
    u0_m0_wo0_mtree_mult1_0_shift2_q <= u0_m0_wo0_mtree_mult1_0_shift2_qint(21 downto 0);

    -- u0_m0_wo0_mtree_add0_0(ADD,133)@12 + 1
    u0_m0_wo0_mtree_add0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_0_shift2_q(21)) & u0_m0_wo0_mtree_mult1_0_shift2_q));
    u0_m0_wo0_mtree_add0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((22 downto 22 => u0_m0_wo0_mtree_mult1_1_shift4_q(21)) & u0_m0_wo0_mtree_mult1_1_shift4_q));
    u0_m0_wo0_mtree_add0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_0_a) + SIGNED(u0_m0_wo0_mtree_add0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_0_q <= u0_m0_wo0_mtree_add0_0_o(22 downto 0);

    -- u0_m0_wo0_mtree_add1_0(ADD,151)@13 + 1
    u0_m0_wo0_mtree_add1_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 23 => u0_m0_wo0_mtree_add0_0_q(22)) & u0_m0_wo0_mtree_add0_0_q));
    u0_m0_wo0_mtree_add1_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((24 downto 22 => u0_m0_wo0_mtree_mult1_3_shift4_q(21)) & u0_m0_wo0_mtree_mult1_3_shift4_q));
    u0_m0_wo0_mtree_add1_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add1_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add1_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add1_0_a) + SIGNED(u0_m0_wo0_mtree_add1_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add1_0_q <= u0_m0_wo0_mtree_add1_0_o(24 downto 0);

    -- u0_m0_wo0_mtree_add2_0(ADD,160)@14 + 1
    u0_m0_wo0_mtree_add2_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 25 => u0_m0_wo0_mtree_add1_0_q(24)) & u0_m0_wo0_mtree_add1_0_q));
    u0_m0_wo0_mtree_add2_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((25 downto 25 => u0_m0_wo0_mtree_add1_1_q(24)) & u0_m0_wo0_mtree_add1_1_q));
    u0_m0_wo0_mtree_add2_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add2_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add2_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add2_0_a) + SIGNED(u0_m0_wo0_mtree_add2_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add2_0_q <= u0_m0_wo0_mtree_add2_0_o(25 downto 0);

    -- u0_m0_wo0_mtree_add3_0(ADD,165)@15 + 1
    u0_m0_wo0_mtree_add3_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 26 => u0_m0_wo0_mtree_add2_0_q(25)) & u0_m0_wo0_mtree_add2_0_q));
    u0_m0_wo0_mtree_add3_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((28 downto 28 => u0_m0_wo0_mtree_add2_1_q(27)) & u0_m0_wo0_mtree_add2_1_q));
    u0_m0_wo0_mtree_add3_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add3_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add3_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add3_0_a) + SIGNED(u0_m0_wo0_mtree_add3_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add3_0_q <= u0_m0_wo0_mtree_add3_0_o(28 downto 0);

    -- u0_m0_wo0_mtree_add4_0(ADD,167)@16 + 1
    u0_m0_wo0_mtree_add4_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 29 => u0_m0_wo0_mtree_add3_0_q(28)) & u0_m0_wo0_mtree_add3_0_q));
    u0_m0_wo0_mtree_add4_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((30 downto 30 => u0_m0_wo0_mtree_add3_1_q(29)) & u0_m0_wo0_mtree_add3_1_q));
    u0_m0_wo0_mtree_add4_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add4_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add4_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add4_0_a) + SIGNED(u0_m0_wo0_mtree_add4_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add4_0_q <= u0_m0_wo0_mtree_add4_0_o(30 downto 0);

    -- u0_m0_wo0_mtree_add5_0(ADD,168)@17 + 1
    u0_m0_wo0_mtree_add5_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 31 => u0_m0_wo0_mtree_add4_0_q(30)) & u0_m0_wo0_mtree_add4_0_q));
    u0_m0_wo0_mtree_add5_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((31 downto 26 => u0_m0_wo0_mtree_add2_4_q(25)) & u0_m0_wo0_mtree_add2_4_q));
    u0_m0_wo0_mtree_add5_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add5_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add5_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add5_0_a) + SIGNED(u0_m0_wo0_mtree_add5_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add5_0_q <= u0_m0_wo0_mtree_add5_0_o(31 downto 0);

    -- GND(CONSTANT,0)@0
    GND_q <= "0";

    -- d_u0_m0_wo0_compute_q_17(DELAY,459)@11 + 6
    d_u0_m0_wo0_compute_q_17 : dspba_delay
    GENERIC MAP ( width => 1, depth => 6, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_11_q, xout => d_u0_m0_wo0_compute_q_17_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_oseq_gated_reg(REG,169)@17 + 1
    u0_m0_wo0_oseq_gated_reg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= STD_LOGIC_VECTOR(d_u0_m0_wo0_compute_q_17_q);
        END IF;
    END PROCESS;

    -- xOut(PORTOUT,174)@18 + 1
    xOut_v <= u0_m0_wo0_oseq_gated_reg_q;
    xOut_c <= STD_LOGIC_VECTOR("0000000" & GND_q);
    xOut_0 <= u0_m0_wo0_mtree_add5_0_q;

END normal;
