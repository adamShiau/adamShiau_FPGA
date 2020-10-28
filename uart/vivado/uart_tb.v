//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////
 
// This testbench will exercise both the UART Tx and Rx.
// It sends out byte 0xAB over the transmitter
// It then exercises the receive by receiving byte 0x3F
`timescale 1ns/10ps
 
//`include "uart_tx.v"
//`include "uart_rx.v"
 
module uart_tb ();
 
// Testbench uses a 50 MHz clock
// Want to interface to 115200 baud UART
// 50000000 / 115200 = 434 Clocks Per Bit.
parameter c_CLOCK_PERIOD_NS = 20;
parameter c_CLKS_PER_BIT    = 434;
parameter c_BIT_PERIOD      = 8680; // 1/115200 = 8680 ns

reg r_Clock = 0;
reg r_Tx_DV = 0;
reg [7:0] r_Tx_Byte = 0;
wire o_Tx_Active;
wire o_Tx_Serial;
wire w_Tx_Done;
wire [2:0] o_Tx_SM; 

reg r_Rx_Serial = 1; //pull High
wire [2:0] o_Rx_SM; 
wire o_Rx_DV;
wire [7:0] w_Rx_Byte;
   
 
// Takes in input byte and serializes it 
task UART_WRITE_BYTE;
input [7:0] i_Data;
integer     ii;
begin
	// Send Start Bit
	r_Rx_Serial <= 1'b0;
	#(c_BIT_PERIOD);
	// #1000;
   
  // Send Data Byte
for (ii=0; ii<8; ii=ii+1) begin
	r_Rx_Serial <= i_Data[ii];
	#(c_BIT_PERIOD);
end
   
  // Send Stop Bit
  r_Rx_Serial <= 1'b1;
  #(c_BIT_PERIOD);
end
endtask // UART_WRITE_BYTE
   
   
uart_rx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_RX_INST
(
.i_Clock(r_Clock),
.i_Rx_Serial(r_Rx_Serial),
.o_Rx_DV(o_Rx_DV),
.o_Rx_Byte(w_Rx_Byte)
, .o_Rx_SM(o_Rx_SM)
);
   
uart_tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_INST
(
.i_Clock(r_Clock),
.i_Tx_DV(r_Tx_DV),
.i_Tx_Byte(r_Tx_Byte),
.o_Tx_Active(o_Tx_Active),
.o_Tx_Serial(o_Tx_Serial),
.o_Tx_Done(w_Tx_Done)
, .o_Tx_SM(o_Tx_SM)
 );
 
    
always #(c_CLOCK_PERIOD_NS/2)
	r_Clock <= ~r_Clock;
 
   
  // Main Testing:
initial begin

   
  // Tell UART to send a command (exercise Tx)
  @(posedge r_Clock);
  @(posedge r_Clock);
  UART_WRITE_BYTE(8'h55);
  @(posedge r_Clock);
  r_Tx_DV <= 1'b1;
  r_Tx_Byte <= w_Rx_Byte;
  @(posedge r_Clock);
  r_Tx_DV <= 1'b0;
  @(posedge w_Tx_Done);
   		 
  // Check that the correct command was received
  if (w_Rx_Byte == 8'h3F)
	$display("Test Passed - Correct Byte Received");
  else
	$display("Test Failed - Incorrect Byte Received");
   
end
   
endmodule