`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 13:26:23
// Design Name: 
// Module Name: uart_test_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define SIM

module uart_test_top(

input clk,
input rx,
output tx

`ifdef SIM
, (* mark_debug = "true" *)output rx_dv
, (* mark_debug = "true" *)output [7:0] rx_byte
, (* mark_debug = "true" *)output tx_active
, (* mark_debug = "true" *)output tx_done
`endif

);

localparam IDLE = 0;
localparam TX_START = 1;

(* mark_debug = "true" *) reg tx_dv;
reg [2:0] sm;
(* mark_debug = "true" *) wire [2:0] tx_sm;

initial begin
tx_dv = 0;
sm = 0;
end

always@(posedge clk) begin

case(sm)
	IDLE: begin
		tx_dv <= 0;
		if(rx_dv) begin
			tx_dv <= 1;
			sm <= TX_START;
		end
	end
	TX_START: begin
		tx_dv <= 0;
		if(tx_done) sm <= IDLE;
	end
	
endcase

end

uart_rx #(.CLKS_PER_BIT(434)) 
u_rx
(
.i_Clock(clk),
.i_Rx_Serial(rx),
.o_Rx_DV(rx_dv),
.o_Rx_Byte(rx_byte)
, .o_Rx_SM()
);

	
uart_tx #(.CLKS_PER_BIT(434)) 
u_tx
(
.i_Clock(clk),
.i_Tx_DV(tx_dv),
.i_Tx_Byte(rx_byte), 
.o_Tx_Active(tx_active),
.o_Tx_Serial(tx),
.o_Tx_Done(tx_done)
, .o_Tx_SM(tx_sm)
);


endmodule
