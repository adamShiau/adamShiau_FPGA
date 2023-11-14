`timescale 1 ns/ 100 ps
module sim_err_signal_gen_v4_tb();
// constants                                           
// general purpose registers
// reg eachvec;
// test vector input registers
reg [13:0] i_adc_data;
reg [31:0] i_amp_H;
reg [31:0] i_amp_L;
reg [31:0] i_avg_sel;
reg i_clk;
reg [31:0] i_err_offset;
reg [31:0] i_freq_cnt;
reg i_polarity;
reg i_rst_n;
reg [31:0] i_wait_cnt;
// wires                                               
wire o_SM;
wire [31:0]  o_adc;
wire [31:0]  o_adc_sum;
wire [3:0]  o_cstate;
wire [31:0]  o_err;
wire [31:0]  o_mod_out;
// wire [31:0]  o_mod_out_dly1;
// wire [31:0]  o_mod_out_dly2;
wire [3:0]  o_nstate;
wire o_ramp_sync;
wire o_rate_sync;
wire [31:0]  o_stable_cnt;
wire o_status;
wire o_stepTrig;
// wire o_stepTrig_dly1;
// wire o_stepTrig_dly2;
wire o_step_sync;
wire o_step_sync_dly;

reg [31:0] cnt;

// assign statements (if any)                          
sim_err_signal_gen_v4 i1 (
// port map - connection between master ports and signals/registers   
	.i_adc_data(i_adc_data),
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_avg_sel(i_avg_sel),
	.i_clk(i_clk),
	.i_err_offset(i_err_offset),
	.i_freq_cnt(i_freq_cnt),
	.i_polarity(i_polarity),
	.i_rst_n(i_rst_n),
	.i_wait_cnt(i_wait_cnt),
	.o_SM(o_SM),
	.o_adc(o_adc),
	.o_adc_sum(o_adc_sum),
	.o_cstate(o_cstate),
	.o_err(o_err),
	.o_mod_out(o_mod_out),
	// .o_mod_out_dly1(o_mod_out_dly1),
	// .o_mod_out_dly2(o_mod_out_dly2),
	.o_nstate(o_nstate),
	.o_ramp_sync(o_ramp_sync),
	.o_rate_sync(o_rate_sync),
	.o_stable_cnt(o_stable_cnt),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig),
	// .o_stepTrig_dly1(o_stepTrig_dly1),
	// .o_stepTrig_dly2(o_stepTrig_dly2),
	.o_step_sync(o_step_sync),
	.o_step_sync_dly(o_step_sync_dly)
);
initial                                                
begin                                                  
i_clk = 1'b0;
i_freq_cnt = 32'd221;
i_amp_H = 32'd3000;
i_amp_L = -32'd3000;
i_adc_data = 14'd1000;
i_avg_sel = 32'd6;
i_err_offset = 32'd0;
i_polarity = 0;
i_wait_cnt = 32'd75;
i_rst_n = 1'b0;
cnt = 0;
#50
i_rst_n = 1'b1;
repeat(50) begin
	@(posedge o_stepTrig) begin
		cnt = cnt + 1;
		if(cnt==10) begin
			i_avg_sel = 32'd7;
		end

		
		$display("stepTrig"); 
	end
end                      
                                                       
// --> end                                             
$display("Running testbench"); 
$stop;                          
end                                                    

always#5 i_clk = ~i_clk; 

endmodule

