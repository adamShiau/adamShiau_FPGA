
`timescale 1 ns/ 100 ps
module PPS_Sync_v2_vlg_tst();
// constants                                           
reg SYNC;
reg i_clk;
reg i_rst_n;
// wires                                               
wire pps_trig_out;
wire [31:0]  o_pulse_number;
wire [31:0]  o_half_period_cnt;
wire [3:0] o_cstate;
wire [3:0] o_nstate;

localparam PPS_HIGH = 100;
localparam PPS_duration = 1000000 - PPS_HIGH;

// assign statements (if any)                          
PPS_Sync_v2
#(.PULSE_NUM(5),
.HALF_PERIOD(100)
)
i1 (
// port map - connection between master ports and signals/registers   
	.SYNC(SYNC),
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.pps_trig_out(pps_trig_out),
	.o_half_period_cnt(o_half_period_cnt),
	.o_pulse_number(o_pulse_number),
	.o_cstate(o_cstate),
	.o_nstate(o_nstate)
);
initial                                                
begin   
	i_rst_n = 0; 
	i_clk = 0;
	SYNC = 0;   
	#10;
    i_rst_n = 1;   
	SYNC = 1;
	#1000;
	SYNC = 0;
	#9000;
	SYNC = 1;   
	#1000;
	SYNC = 0;
	#9000; 
	SYNC = 1;   
	#1000;
	SYNC = 0;
	#9000;                                    
                                          
$display("Running testbench");   
$stop;                    
end                                                    

always #5 i_clk = ~i_clk;                                                 
             
                                                   
endmodule

