dither_gen_v2 dither_gen_v2_inst
(
    .i_clk(),           
    .i_rst_n(),         
    .i_dither_high(),   //[31:0]
    .i_dither_low(),    //[31:0]
    .i_period_cnt(),    //[31:0] 
    .i_wait_cnt(),      //[31:0]
    .i_avg_sel(),       //[31:0]
    .i_data(),          //[31:0] 
    .o_data(),          //[31:0] signed
    .o_dither_out()     //[31:0] signed

    /*** for simulation ***/
    , .o_reg_data_H()   //[31:0] signed
    , .o_reg_data_L()   //[31:0] signed
    , .o_reg_sum()      //[31:0] signed
    , .o_cstate()       //[3:0]
    , .o_nstate()       //[3:0]
    , .o_trig()
    , .o_period_cnt()   //[31:0]
);
