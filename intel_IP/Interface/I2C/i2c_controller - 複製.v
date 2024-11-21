//`timescale 1ns / 100ps


module i2c_controller(
	input wire clk,
	input wire rst,
	input wire [6:0] addr,
	input wire [7:0] data_in,
	input wire enable,
	input wire rw,

	output reg [7:0] data_out,
	output wire ready,
	output wire w_enable,
	output [7:0] sm,

	inout i2c_sda,
	output i2c_scl,
	output i2c_clk_out
	);

	localparam IDLE = 0;
	localparam START = 1;
	localparam ADDRESS = 2;
	localparam READ_ACK = 3;
	localparam WRITE_DATA = 4;
	localparam WRITE_ACK = 5;
	localparam READ_DATA = 6;
	localparam READ_ACK2 = 7;
	localparam STOP = 8;
	localparam STOP2 = 9;
	localparam IDLE2 = 10;
	localparam START2 = 11;
	localparam ADDRESS2 = 12;
	localparam READ_ACK_B = 13;
	localparam READ_ACK2_B = 14;
	
	// localparam DIVIDE_BY = 4;

	reg [7:0] state;
	reg [7:0] saved_addr;
	reg [7:0] saved_data;
	reg [7:0] counter;
	// reg [7:0] counter2 = 0;
	reg write_enable;
	reg sda_out;
	reg i2c_scl_enable = 0;
	reg i2c_scl_enable2 = 0;
	reg i2c_clk = 1;
	reg	[6:0] CLK_COUNT = 0; 	//clock

	assign sm = state; 
	assign i2c_clk_out = i2c_clk;
	assign w_enable = write_enable; 
	assign ready = ((rst == 0) && (state == IDLE)) ? 1 : 0;
	// assign i2c_scl = (i2c_scl_enable == 0 ) ? 1 : i2c_clk;
	assign i2c_scl = (i2c_scl_enable2 == 0 ) ? 0 : ( (i2c_scl_enable == 0 ) ? 1 : i2c_clk) ;
	assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz;
	// assign i2c_sda = (state == IDLE)? 1 : ( (write_enable == 1) ? sda_out : 1'bz );
	
	// 此處產生i2c_clk，頻率為clk 1/(DIVIDE_BY/2)，若DIVIDE_BY = 4，頻率為1/2 clk
	// always @(posedge clk) begin
	// 	if (counter2 == (DIVIDE_BY/2) - 1) begin
	// 		i2c_clk <= ~i2c_clk;
	// 		counter2 <= 0;
	// 	end
	// 	else counter2 <= counter2 + 1;
	// end 

	always@(posedge clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[7]:390.625 kHz, CLK_COUNT[6]:781.25 KHz
		i2c_clk <= CLK_COUNT[6];
	end

	
	always @(negedge i2c_clk, posedge rst) begin
		if(rst == 1) begin
			i2c_scl_enable <= 0;
			i2c_scl_enable2 <= 1;
		end else begin
			if ( (state == IDLE) || (state == IDLE2) ||(state == START) ||(state == START2) || (state == STOP) || (state == STOP2)) begin
				i2c_scl_enable <= 0;
			end else begin
				i2c_scl_enable <= 1;
			end

			if ( (state == READ_ACK_B)|| (state == READ_ACK2_B) ) begin
				i2c_scl_enable2 <= 0;
			end else begin
				i2c_scl_enable2 <= 1;
			end


		end
	
	end


	always @(posedge i2c_clk, posedge rst) begin
		if(rst == 1) begin
			state <= IDLE;
		end		
		else begin
			case(state)
			
				IDLE: begin
					if (enable) begin
						state <= START;
						// saved_addr <= {addr, rw};
						// saved_data <= data_in;
					end
					else state <= IDLE;
				end

				IDLE2: begin
					if (enable) begin
						state <= START2;
					end
					else state <= IDLE2;
				end

				START: begin
					counter <= 7;
					saved_addr <= {7'h1D, 1'b0};
					state <= ADDRESS;
				end

				START2: begin
					counter <= 7;
					saved_addr <= {7'h1D, 1'b1};
					state <= ADDRESS2;
				end

				ADDRESS: begin
					if (counter == 0) begin 
						state <= READ_ACK;
					end else counter <= counter - 1;
				end

				ADDRESS2: begin
					if (counter == 0) begin 
						state <= READ_ACK;
					end else counter <= counter - 1;
				end

				READ_ACK: begin
					if (i2c_sda == 0) begin
						state <= READ_ACK_B;
					end 
					else state <= STOP;
				end

				READ_ACK_B: begin
					counter <= 7;
					if(saved_addr[0] == 0) begin
						saved_data = 8'h00;
						state <= WRITE_DATA;
					end
					else state <= READ_DATA;
				end

				WRITE_DATA: begin //WRITE_DATA = 4
					if(counter == 0) begin
						state <= READ_ACK2;
					end else counter <= counter - 1;
				end
				
				READ_ACK2: begin //READ_ACK2 = 7
					state <= READ_ACK2_B;
				end

				READ_ACK2_B: begin 
					state <= STOP2;
				end

				READ_DATA: begin
					data_out[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin
					state <= STOP;
				end

				STOP: begin
					state <= IDLE;
				end

				STOP2: begin //STOP2 = 9
					state <= IDLE2;
				end
			endcase
		end
	end
	
	always @(negedge i2c_clk, posedge rst) begin
		if(rst == 1) begin
			write_enable <= 1;
			sda_out <= 1;
		end else begin
			case(state)
				
				START: begin
					write_enable <= 1;
					sda_out <= 0;
				end

				START2: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				
				ADDRESS: begin
					sda_out <= saved_addr[counter];
				end

				ADDRESS2: begin
					sda_out <= saved_addr[counter];
				end
				
				READ_ACK: begin
					write_enable <= 0;
				end

				READ_ACK_B: begin
					write_enable <= 0;
				end

				READ_ACK2: begin //READ_ACK2 = 7
					write_enable <= 0;
				end

				READ_ACK2_B: begin 
					write_enable <= 0;
				end
				
				WRITE_DATA: begin //WRITE_DATA = 4
					write_enable <= 1;
					sda_out <= saved_data[counter];
				end
				
				WRITE_ACK: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				
				READ_DATA: begin
					write_enable <= 0;				
				end
				
				STOP: begin
					write_enable <= 1;
					sda_out <= 1;
				end

				STOP2: begin //STOP2 = 9
					write_enable <= 1;
					sda_out <= 1;
				end
			endcase
		end
	end

endmodule