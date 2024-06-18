`timescale 1 ns/ 100 ps
module dither_gen_v2_tb();

// test vector input registers
reg i_clk;
reg i_rst_n;
reg [31:0] i_avg_sel;
reg [31:0] i_data;
reg [31:0] i_wait_cnt;

// wires                                               
wire [31:0]  o_data;
wire [31:0]  o_dither_out;
wire [3:0]   o_cstate;
wire [3:0]   o_nstate;
wire [31:0] o_reg_data_H;
wire [31:0] o_reg_data_L;
wire [31:0] o_reg_sum;
wire        o_trig;
wire [31:0] o_period_cnt;

localparam REG_H = 32'd4096;
localparam REG_L = -32'd4200;

dither_gen_v2 dither_gen_v2_inst
(
    .i_clk(i_clk),           
    .i_rst_n(i_rst_n),         
    .i_dither_high(REG_H),   //[31:0]
    .i_dither_low(REG_L),    //[31:0]
    .i_period_cnt(32'd100),    //[31:0] 
    .i_wait_cnt(i_wait_cnt),      //[31:0]
    .i_avg_sel(i_avg_sel),       //[31:0]
    .i_data(i_data),          //[31:0] 
    .o_data(o_data),          //[31:0] signed
    .o_dither_out(o_dither_out)     //[31:0] signed

    /*** for simulation ***/
    , .o_reg_data_H(o_reg_data_H)   //[31:0] signed
    , .o_reg_data_L(o_reg_data_L)   //[31:0] signed
    , .o_reg_sum(o_reg_sum)      //[31:0] signed
    , .o_cstate(o_cstate)       //[3:0]
    , .o_nstate(o_nstate)       //[3:0]
    , .o_trig(o_trig)
    , .o_period_cnt(o_period_cnt) 
);

initial begin
	// Initialize inputs
    i_clk = 0;
    i_rst_n = 0;
    i_avg_sel = 4;
    
    i_wait_cnt = 9;                                                  

	$display("Running testbench"); 

	// Apply reset
    #100; // Wait for 100 ns for reset to finish
    i_rst_n = 1;
    
    // Generate 100 trigger pulses
    // repeat (250) begin
    //     i_trig = 1;
    //     #10; // Trigger pulse width of 1 clock cycle (10 ns for 100 MHz clock)
    //     i_trig = 0;
	// 	#1000; // 1 us delay for 100 MHz clock
    // end
    #5000000; // Wait for a few cycles after the last trigger
    $stop;
end   

// Update i_data based on o_dither_out
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        i_data <= 0;
    end 
	else begin
        if (o_dither_out == REG_H)
            i_data <= 1000;
        else if (o_dither_out == REG_L)
            i_data <= -2100;
        else
            i_data <= 0; // Default value if o_dither_out is neither 1 nor -1
    end
end

// Clock generation
always begin
    #5 i_clk = ~i_clk; // 10 ns period -> 100 MHz clock
end

// State name annotations
reg [8*10:1] cstate, nstate; //one char need 8 bits, ex: "RST" needs 8*3 bits
always @(o_cstate) begin
    case (o_cstate)
        4'd0: cstate = "RST";
        4'd1: cstate = "DITHER_H";
        4'd2: cstate = "WAIT_H";
        4'd3: cstate = "ACQ_H";
        4'd4: cstate = "DITHER_L";
        4'd5: cstate = "WAIT_L";
        4'd6: cstate = "ACQ_L";
        4'd7: cstate = "OUT_GEN";
        default: cstate = "UNKNOWN";
    endcase
end
always @(o_nstate) begin
    case (o_nstate)
        4'd0: nstate = "RST";
        4'd1: nstate = "DITHER_H";
        4'd2: nstate = "WAIT_H";
        4'd3: nstate = "ACQ_H";
        4'd4: nstate = "DITHER_L";
        4'd5: nstate = "WAIT_L";
        4'd6: nstate = "ACQ_L";
        4'd7: nstate = "OUT_GEN";
        default: nstate = "UNKNOWN";
    endcase
end

endmodule

