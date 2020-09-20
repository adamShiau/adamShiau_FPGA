module threshold_cut(
    input signed [31:0] i_sig,
    input [31:0] i_vth,
	input i_vth_cut_mode,
    output [31:0] o_out
);

wire signed [31:0] vth_p, vth_n;
wire signed [31:0] vth_cut_p, vth_cut_n;

assign vth_p = i_vth;
assign vth_n = $signed(-i_vth);
assign vth_cut_p = (i_vth_cut_mode)? vth_p*2 : vth_p;
assign vth_cut_n = (i_vth_cut_mode)? vth_n*2 : vth_n;


assign o_out = (i_sig > vth_p)? (i_sig - vth_cut_p) : ((i_sig < vth_n)? (i_sig - vth_cut_n): i_sig);

endmodule