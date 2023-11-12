`timescale 1 ns/ 100 ps
module modulation_gen_v3_tb();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg [31:0] i_amp_H;
reg [31:0] i_amp_L;
reg i_clk;
reg [31:0] i_freq_cnt;
reg i_rst_n;
// wires                                               
// wire o_SM;
wire [31:0]  o_mod_out;
wire [31:0]  o_mod_out_dly1;
wire [31:0]  o_mod_out_dly2;
wire o_status;
wire o_stepTrig;
wire o_stepTrig_dly1;
wire o_stepTrig_dly2;

// assign statements (if any)                          
modulation_gen_v3 i1 (
// port map - connection between master ports and signals/registers   
	.i_amp_H(i_amp_H),
	.i_amp_L(i_amp_L),
	.i_clk(i_clk),
	.i_freq_cnt(i_freq_cnt),
	.i_rst_n(i_rst_n),
	// .o_SM(o_SM),
	.o_mod_out(o_mod_out),
	.o_mod_out_dly1(o_mod_out_dly1),
	.o_mod_out_dly2(o_mod_out_dly2),
	.o_status(o_status),
	.o_stepTrig(o_stepTrig),
	.o_stepTrig_dly1(o_stepTrig_dly1),
	.o_stepTrig_dly2(o_stepTrig_dly2)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin    
i_clk = 1'b0;
i_freq_cnt = 32'd100;
i_amp_H = 32'd3000;
i_amp_L = -32'd3000;
i_rst_n = 1'b0;
#50
i_rst_n = 1'b1;
#50000	                      
                                                       
// --> end                                             
$display("Running testbench");    
$stop;                     
end                                                    
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
                                                       
@eachvec;                                              
// --> end                                             
end  

always#5 i_clk = ~i_clk;

endmodule

