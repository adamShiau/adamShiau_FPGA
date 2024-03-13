module mySMA_TOP
(
input i_clk,
input i_rst_n,
input i_update_strobe,
input [31:0] i_window_sel,
input signed [31:0] i_data,
output signed [31:0] o_data
,output [31:0] m_count_reg
,output [63:0] m_sum_reg
,output [15:0] m_N
);

SMA_v1
#(.WINDOW_SIZE(64))
uSMA
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.i_update_strobe(i_update_strobe),
.i_window_sel(i_window_sel),
.i_data(i_data),
.o_data(o_data),
.m_count_reg(m_count_reg),
.m_sum_reg(m_sum_reg),
.m_N(m_N)
);



endmodule