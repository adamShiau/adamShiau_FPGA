`timescale 1ns / 1ps

module GyroVarSet2 (
// avalon bus:
    address,
    chipselect,
    clk,
    rst_n,
    write_n,
    writedata,
    readdata, 

// var outputs:
	o_reg0,
    o_reg1,
    o_reg2,
    o_reg3,
    o_reg4,
    o_reg5,
    o_reg6,
    o_reg7,
    o_reg8,
    o_reg9,
    o_reg10,
    o_reg11,
    o_reg12,
    o_reg13,
    o_reg14,
    o_reg15,
    o_reg16,
    o_reg17,
    o_reg18,
    o_reg19,
    o_reg20,
    o_reg21,
    o_reg22,
    o_reg23,
    o_reg24,    
// var inputs:
	i_var0,
    i_var1,
    i_var2,
    i_var3,
    i_var4,
    i_var5,
    i_var6,
    i_var7,
    i_var8,
    i_var9,
    i_var10,
    i_var11,
    i_var12,
    i_var13,
    i_var14,
    i_var15,
    i_var16,
    i_var17,
    i_var18,
    i_var19,
    i_var20,
    i_var21,
    i_var22,
    i_var23,
    i_var24    
)
;


output reg  [ 31: 0] readdata;
input   [  5: 0] address;
input            chipselect;
input            clk;
input            rst_n;
input            write_n;
input   [ 31: 0] writedata;

output reg [  31: 0] o_reg0, o_reg1, o_reg2, o_reg3, o_reg4, o_reg5, o_reg6, o_reg7, o_reg8, o_reg9, o_reg10;
output reg [  31: 0] o_reg11, o_reg12, o_reg13, o_reg14, o_reg15, o_reg16, o_reg17, o_reg18, o_reg19, o_reg20;
output reg [  31: 0] o_reg21, o_reg22, o_reg23, o_reg24;

input [31:0] i_var0, i_var1, i_var2, i_var3, i_var4, i_var5, i_var6, i_var7, i_var8, i_var9, i_var10;
input [31:0] i_var11, i_var12, i_var13, i_var14, i_var15, i_var16, i_var17, i_var18, i_var19, i_var20;
input [31:0] i_var21, i_var22, i_var23, i_var24;




always@(posedge clk or negedge rst_n) begin
    if(!rst_n) readdata <= 32'd0;
    else if(chipselect && write_n) begin
        case(address)
            // 0: readdata <= i_var0;
            // 1: readdata <= i_var1;
            // 2: readdata <= i_var2; 
            // 3: readdata <= i_var3; 
            // 4: readdata <= i_var4; 
            // 5: readdata <= i_var5; 
            // 6: readdata <= i_var6; 
            // 7: readdata <= i_var7; 
            // 8: readdata <= i_var8; 
            // 9: readdata <= i_var9;
            // 10: readdata <= i_var10;
            // 11: readdata <= i_var11;
            // 12: readdata <= i_var12;
            // 13: readdata <= i_var13;
            // 14: readdata <= i_var14;
            // 15: readdata <= i_var15;
            // 16: readdata <= i_var16;
            // 17: readdata <= i_var17;
            // 18: readdata <= i_var18;
            // 19: readdata <= i_var19;
            // 20: readdata <= i_var20;
            // 21: readdata <= i_var21;
            // 22: readdata <= i_var22;
            // 23: readdata <= i_var23;
            // 24: readdata <= i_var24;

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
            25: readdata <= i_var0;
            26: readdata <= i_var1;
            27: readdata <= i_var2; 
            28: readdata <= i_var3; 
            29: readdata <= i_var4; 
            30: readdata <= i_var5; 
            31: readdata <= i_var6; 
            32: readdata <= i_var7; 
            33: readdata <= i_var8; 
            34: readdata <= i_var9;
            35: readdata <= i_var10;
            36: readdata <= i_var11;
            37: readdata <= i_var12;
            38: readdata <= i_var13;
            39: readdata <= i_var14;
            40: readdata <= i_var15;
            41: readdata <= i_var16;
            42: readdata <= i_var17;
            43: readdata <= i_var18;
            44: readdata <= i_var19;
            45: readdata <= i_var20;
            46: readdata <= i_var21;
            47: readdata <= i_var22;
            48: readdata <= i_var23;
            49: readdata <= i_var24;
            default: readdata <= 32'd0;
        endcase
    end
end
  
always@(posedge clk or negedge rst_n)
begin
	if (!rst_n) begin
		o_reg0 <= 32'd0; //reg_mod_freq_cnt
		o_reg1 <= 32'd0; //reg_mod_freq_cnt
		o_reg2 <= 32'd0; //reg_mod_H
		o_reg3 <= 32'd0; //reg_mod_L
		o_reg4 <= 32'd0; //ADC_reg_H_offset
		o_reg5 <= 32'd0; //Init_stable_cnt
		o_reg6 <= 32'd0; //mv_mode
		o_reg7 <= 32'd0; //adc_test_H
		o_reg8 <= 32'd0; //err_polarity
		o_reg9 <= 32'd0;//Diff_vth
		o_reg10 <= 32'd0;//adc_test_L
		o_reg11 <= 32'd0;//ladder_rst
		o_reg12 <= 32'd0;//reg_vth_1st_int
		o_reg13 <= 32'd0;//err_shift_idx_pre
		o_reg14 <= 32'd0; // w_th_p
		o_reg15 <= 32'd0; // w_th_n
		o_reg16 <= 32'd0;//reg_vth
		o_reg17 <= 32'd0;//err_shift_idx
		o_reg18 <= 32'd0; //mod_off
		o_reg19 <= 32'd0; //kal_Q
		o_reg20 <= 32'd0; //kal_R
		o_reg21 <= 32'd0; //output_mode
		o_reg22 <= 32'd0;
		o_reg23 <= 32'd0;
		o_reg24 <= 32'd0;
  end
  else if(chipselect && !write_n) begin
    case(address)
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
    endcase
    end
end


endmodule

