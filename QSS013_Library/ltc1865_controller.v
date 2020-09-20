module ltc1865_controller
#(
parameter SPI_NEXT_VALID_NUM = 8165, //12.5M@250, 100K@8165
/***
for 100KHz sck, T=10us, data sampling time = 16*sck + 3.3us = 163.3us 
if input clk = 50MHz, 163.3us = 163300ns/20ns = 8165 clk
for 12.5MHz sck, T=80ns, data sampling time = 16*sck + 3.3us = 4.58us 
if input clk = 50MHz, 4.58us = 4580ns/20ns = 229 clk
***/
parameter SCK_HALF_PERIOD_CLK = 250 //12.5M@2, 100K@250
/*** 
if input clk = 50MHz, 250 clk = 20ns*250 = 5us => sck period = 10us = 10KHz
***/
)
(
	input i_clk,
	input i_rst_n,
	input i_en,
	input i_txe_n,
	
	/*** spi***/
	output o_sdo,
	input i_sdi,
	output o_sck,
	output o_scs,
	
	/*** ch ***/
	input i_ch,
	output [15:0] o_adc_data,
	
	output o_tx_dv,
	output o_rx_dv	
);

/*** launch spi ***/
reg r_tx_dv;
reg [7:0] r_tx_byte;
reg [2:0] spi_sm = 0;
reg [31:0] r_spi_next_valid;
wire [7:0] channel_sel;

assign channel_sel = (i_ch==1'b0) ? 8'd128 : 8'd192; //128@ADC ch0, 192@ch1

assign o_tx_dv = r_tx_dv;
assign o_rx_dv = r_rx_dv;

always@(posedge i_clk) begin
    if(!i_rst_n) begin
		r_tx_dv <= 0;
		r_spi_next_valid <= SPI_NEXT_VALID_NUM;
	end
	else begin
		case(spi_sm) 
			0: begin
				r_spi_next_valid <= SPI_NEXT_VALID_NUM;
				r_tx_byte <= channel_sel; 
				if(!i_txe_n && i_en) spi_sm <= 1;
			end
			1: begin
				r_tx_dv <= 1'b1;
				spi_sm <= 2;
			end
		
			2: begin
				r_tx_dv <= 1'b0;
				spi_sm <= 3;
			end
			
			3: begin
				if(r_spi_next_valid > 0) r_spi_next_valid <= r_spi_next_valid - 1'b1;
				else spi_sm <= 0;
			end
		endcase
	end
end

SPI_Master_With_Single_CS 
#(
.SPI_MODE(3),
.CLKS_PER_HALF_BIT(SCK_HALF_PERIOD_CLK), //12.5M@2, 100K@250
.CS_INACTIVE_CLKS(1) //CS HIGH 的時間 = SPI_NEXT_VALID_NUM - 16*sck週期
)SPI_module
(
.i_Rst_L(i_rst_n),     // FPGA Reset
.i_Clk(i_clk),       // FPGA Clock
   
   /*** TX (MOSI) Signals ***/
.i_TX_Count(1),  // # clk per CS low
.i_TX_Byte(r_tx_byte),       // Byte to transmit on MOSI
.i_TX_DV(r_tx_dv),         // Data Valid Pulse with i_TX_Byte
.o_TX_Ready(tx_rd),      // Transmit Ready for next byte
   
   /*** RX (MISO) Signals ***/
.o_RX_Count(),  // Index RX byte
.o_RX_DV(r_rx_dv),     // Data Valid pulse (1 clock cycle)
.o_RX_Byte(o_adc_data),   // two Bytes received on MISO

   /*** SPI Interface ***/
.o_SPI_Clk(o_sck),
.i_SPI_MISO(i_sdi), 
.o_SPI_MOSI(o_sdo),
.o_SPI_CS_n(o_scs)

,.leading_edge(leading_edge)
,.trailing_edge(trailing_edge)
);

endmodule