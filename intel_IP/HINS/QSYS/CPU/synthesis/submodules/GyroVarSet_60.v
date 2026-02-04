`timescale 1ns / 1ps

module GyroVarSet_60 (
    // Avalon bus:
    input   [6:0]  address,
    input          chipselect,
    input          clk,
    input          rst_n,
    input          write_n,
    input  signed [31:0] writedata,  
    output reg signed [31:0] readdata, 
    output reg o_latch_trigger,

    // var outputs:
    output reg signed [31:0] o_reg0, o_reg1, o_reg2, o_reg3, o_reg4, o_reg5, o_reg6, o_reg7, o_reg8, o_reg9,
    output reg signed [31:0] o_reg10, o_reg11, o_reg12, o_reg13, o_reg14, o_reg15, o_reg16, o_reg17, o_reg18, o_reg19,
    output reg signed [31:0] o_reg20, o_reg21, o_reg22, o_reg23, o_reg24, o_reg25, o_reg26, o_reg27, o_reg28, o_reg29,
    output reg signed [31:0] o_reg30, o_reg31, o_reg32, o_reg33, o_reg34, o_reg35, o_reg36, o_reg37, o_reg38, o_reg39,
    output reg signed [31:0] o_reg40, o_reg41, o_reg42, o_reg43, o_reg44, o_reg45, o_reg46, o_reg47, o_reg48, o_reg49,
    output reg signed [31:0] o_reg50, o_reg51, o_reg52, o_reg53, o_reg54, o_reg55, o_reg56, o_reg57, o_reg58, o_reg59,

    // var inputs:
    input signed [31:0] i_var0, i_var1, i_var2, i_var3, i_var4, i_var5, i_var6, i_var7, i_var8, i_var9,
    input signed [31:0] i_var10, i_var11, i_var12, i_var13, i_var14, i_var15, i_var16, i_var17, i_var18, i_var19,
    input signed [31:0] i_var20, i_var21, i_var22, i_var23, i_var24, i_var25, i_var26, i_var27, i_var28, i_var29,
    input signed [31:0] i_var30, i_var31, i_var32, i_var33, i_var34, i_var35, i_var36, i_var37, i_var38, i_var39,
    input signed [31:0] i_var40, i_var41, i_var42, i_var43, i_var44, i_var45, i_var46, i_var47, i_var48, i_var49,
    input signed [31:0] i_var50, i_var51, i_var52, i_var53, i_var54, i_var55, i_var56, i_var57, i_var58, i_var59
);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_latch_trigger <= 1'b0;
    end else begin
        // 當 CPU 讀取地址 71 (即 IMU 第一筆數據) 時產生一個 clock 的脈衝
        if (chipselect && write_n && (address == 7'd71)) begin
            o_latch_trigger <= 1'b1;
        end else begin
            o_latch_trigger <= 1'b0;
        end
    end
end

// Initialize registers and handle Avalon bus operations
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Initialize output registers
        o_reg0 <= 32'd0; o_reg1 <= 32'd0; o_reg2 <= 32'd0; o_reg3 <= 32'd0; o_reg4 <= 32'd0; o_reg5 <= 32'd0;
        o_reg6 <= 32'd0; o_reg7 <= 32'd0; o_reg8 <= 32'd0; o_reg9 <= 32'd0; o_reg10 <= 32'd0; o_reg11 <= 32'd0;
        o_reg12 <= 32'd0; o_reg13 <= 32'd0; o_reg14 <= 32'd0; o_reg15 <= 32'd0; o_reg16 <= 32'd0; o_reg17 <= 32'd0;
        o_reg18 <= 32'd0; o_reg19 <= 32'd0; o_reg20 <= 32'd0; o_reg21 <= 32'd0; o_reg22 <= 32'd0; o_reg23 <= 32'd0;
        o_reg24 <= 32'd0; o_reg25 <= 32'd0; o_reg26 <= 32'd0; o_reg27 <= 32'd0; o_reg28 <= 32'd0; o_reg29 <= 32'd0;
        o_reg30 <= 32'd0; o_reg31 <= 32'd0; o_reg32 <= 32'd0; o_reg33 <= 32'd0; o_reg34 <= 32'd0; o_reg35 <= 32'd0;
        o_reg36 <= 32'd0; o_reg37 <= 32'd0; o_reg38 <= 32'd0; o_reg39 <= 32'd0; o_reg40 <= 32'd0; o_reg41 <= 32'd0;
        o_reg42 <= 32'd0; o_reg43 <= 32'd0; o_reg44 <= 32'd0; o_reg45 <= 32'd0; o_reg46 <= 32'd0; o_reg47 <= 32'd0;
        o_reg48 <= 32'd0; o_reg49 <= 32'd0; o_reg50 <= 32'd0; o_reg51 <= 32'd0; o_reg52 <= 32'd0; o_reg53 <= 32'd0;
        o_reg54 <= 32'd0; o_reg55 <= 32'd0; o_reg56 <= 32'd0; o_reg57 <= 32'd0; o_reg58 <= 32'd0; o_reg59 <= 32'd0;
        readdata  <= 32'd0;
    end else if (chipselect) begin
        if (!write_n) begin
            // Write operation
            case (address)
                0: o_reg0 <= writedata;
                1: o_reg1 <= writedata;
                2: o_reg2 <= writedata;
                3: o_reg3 <= writedata;
                4: o_reg4 <= writedata;
                5: o_reg5 <= writedata;
                6: o_reg6 <= writedata;
                7: o_reg7 <= writedata;
                8: o_reg8 <= writedata;
                9: o_reg9 <= writedata;
                10: o_reg10 <= writedata;
                11: o_reg11 <= writedata;
                12: o_reg12 <= writedata;
                13: o_reg13 <= writedata;
                14: o_reg14 <= writedata;
                15: o_reg15 <= writedata;
                16: o_reg16 <= writedata;
                17: o_reg17 <= writedata;
                18: o_reg18 <= writedata;
                19: o_reg19 <= writedata;
                20: o_reg20 <= writedata;
                21: o_reg21 <= writedata;
                22: o_reg22 <= writedata;
                23: o_reg23 <= writedata;
                24: o_reg24 <= writedata;
                25: o_reg25 <= writedata;
                26: o_reg26 <= writedata;
                27: o_reg27 <= writedata;
                28: o_reg28 <= writedata;
                29: o_reg29 <= writedata;
                30: o_reg30 <= writedata;
                31: o_reg31 <= writedata;
                32: o_reg32 <= writedata;
                33: o_reg33 <= writedata;
                34: o_reg34 <= writedata;
                35: o_reg35 <= writedata;
                36: o_reg36 <= writedata;
                37: o_reg37 <= writedata;
                38: o_reg38 <= writedata;
                39: o_reg39 <= writedata;
                40: o_reg40 <= writedata;
                41: o_reg41 <= writedata;
                42: o_reg42 <= writedata;
                43: o_reg43 <= writedata;
                44: o_reg44 <= writedata;
                45: o_reg45 <= writedata;
                46: o_reg46 <= writedata;
                47: o_reg47 <= writedata;
                48: o_reg48 <= writedata;
                49: o_reg49 <= writedata;
                50: o_reg50 <= writedata;
                51: o_reg51 <= writedata;
                52: o_reg52 <= writedata;
                53: o_reg53 <= writedata;
                54: o_reg54 <= writedata;
                55: o_reg55 <= writedata;
                56: o_reg56 <= writedata;
                57: o_reg57 <= writedata;
                58: o_reg58 <= writedata;
                59: o_reg59 <= writedata;
            endcase
        end else begin
            // Read operation
            case (address)
                0: readdata <= o_reg0;
                1: readdata <= o_reg1;
                2: readdata <= o_reg2;
                3: readdata <= o_reg3;
                4: readdata <= o_reg4;
                5: readdata <= o_reg5;
                6: readdata <= o_reg6;
                7: readdata <= o_reg7;
                8: readdata <= o_reg8;
                9: readdata <= o_reg9;
                10: readdata <= o_reg10;
                11: readdata <= o_reg11;
                12: readdata <= o_reg12;
                13: readdata <= o_reg13;
                14: readdata <= o_reg14;
                15: readdata <= o_reg15;
                16: readdata <= o_reg16;
                17: readdata <= o_reg17;
                18: readdata <= o_reg18;
                19: readdata <= o_reg19;
                20: readdata <= o_reg20;
                21: readdata <= o_reg21;
                22: readdata <= o_reg22;
                23: readdata <= o_reg23;
                24: readdata <= o_reg24;
                25: readdata <= o_reg25;
                26: readdata <= o_reg26;
                27: readdata <= o_reg27;
                28: readdata <= o_reg28;
                29: readdata <= o_reg29;
                30: readdata <= o_reg30;
                31: readdata <= o_reg31;
                32: readdata <= o_reg32;
                33: readdata <= o_reg33;
                34: readdata <= o_reg34;
                35: readdata <= o_reg35;
                36: readdata <= o_reg36;
                37: readdata <= o_reg37;
                38: readdata <= o_reg38;
                39: readdata <= o_reg39;
                40: readdata <= o_reg40;
                41: readdata <= o_reg41;
                42: readdata <= o_reg42;
                43: readdata <= o_reg43;
                44: readdata <= o_reg44;
                45: readdata <= o_reg45;
                46: readdata <= o_reg46;
                47: readdata <= o_reg47;
                48: readdata <= o_reg48;
                49: readdata <= o_reg49;
                50: readdata <= o_reg50;
                51: readdata <= o_reg51;
                52: readdata <= o_reg52;
                53: readdata <= o_reg53;
                54: readdata <= o_reg54;
                55: readdata <= o_reg55;
                56: readdata <= o_reg56;
                57: readdata <= o_reg57;
                58: readdata <= o_reg58;
                59: readdata <= o_reg59;
                60: readdata <= i_var0;
                61: readdata <= i_var1;
                62: readdata <= i_var2;
                63: readdata <= i_var3;
                64: readdata <= i_var4;
                65: readdata <= i_var5;
                66: readdata <= i_var6;
                67: readdata <= i_var7;
                68: readdata <= i_var8;
                69: readdata <= i_var9;
                70: readdata <= i_var10;
                71: readdata <= i_var11;
                72: readdata <= i_var12;
                73: readdata <= i_var13;
                74: readdata <= i_var14;
                75: readdata <= i_var15;
                76: readdata <= i_var16;
                77: readdata <= i_var17;
                78: readdata <= i_var18;
                79: readdata <= i_var19;
                80: readdata <= i_var20;
                81: readdata <= i_var21;
                82: readdata <= i_var22;
                83: readdata <= i_var23;
                84: readdata <= i_var24;
                85: readdata <= i_var25;
                86: readdata <= i_var26;
                87: readdata <= i_var27;
                88: readdata <= i_var28;
                89: readdata <= i_var29;
                90: readdata <= i_var30;
                91: readdata <= i_var31;
                92: readdata <= i_var32;
                93: readdata <= i_var33;
                94: readdata <= i_var34;
                95: readdata <= i_var35;
                96: readdata <= i_var36;
                97: readdata <= i_var37;
                98: readdata <= i_var38;
                99: readdata <= i_var39;
                100: readdata <= i_var40;
                101: readdata <= i_var41;
                102: readdata <= i_var42;
                103: readdata <= i_var43;
                104: readdata <= i_var44;
                105: readdata <= i_var45;
                106: readdata <= i_var46;
                107: readdata <= i_var47;
                108: readdata <= i_var48;
                109: readdata <= i_var49;
                110: readdata <= i_var50;
                111: readdata <= i_var51;
                112: readdata <= i_var52;
                113: readdata <= i_var53;
                114: readdata <= i_var54;
                115: readdata <= i_var55;
                116: readdata <= i_var56;
                117: readdata <= i_var57;
                118: readdata <= i_var58;
                119: readdata <= i_var59;
                default: readdata <= 32'd0; // Default case to avoid latches
            endcase
        end
    end
end
endmodule

