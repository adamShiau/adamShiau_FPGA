dither_gen_v1 dither_gen_v1_inst
(
    .i_clk(),
    .i_rst_n(),
    .i_trig(),
    .i_wait_cnt(),  //[31:0]
    .i_avg_sel(),   //[31:0]
    .i_data(),      //[31:0]
    .o_data(),      //[31:0]
    .o_dither_out() //[31:0]

    /*** for simulation ***/
    , .o_reg_data_H()   //[31:0]
    , .o_reg_data_L()   //[31:0]
    , .o_reg_sum()      //[31:0]
    , .o_cstate()       //[3:0]
    , .o_nstate()       //[3:0]
);