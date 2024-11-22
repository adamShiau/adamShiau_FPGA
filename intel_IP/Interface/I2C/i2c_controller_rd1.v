//`timescale 1ns / 100ps


module i2c_controller
#(parameter DIVNUM = 6)
(
	input wire 			i_clk,
	input wire 			i_rst_n,
	input wire [6:0] 	i_dev_addr,
	input wire [7:0] 	i_w_data,
	input wire [7:0] 	i_reg_addr,
	input wire 			i_enable,
	input wire 			i_rw_reg,

	output reg [7:0] 	o_rd_data,
	output wire			o_ready,
	output wire			o_finish,
	output wire 		o_w_enable,
	output wire [7:0] 	sm,
	output wire			i2c_clk_out,
	output wire			i2c_scl,
	inout 				i2c_sda
	);

	localparam IDLE = 0;
	localparam START = 1;
	localparam ADDRESS = 2;
	localparam READ_ACK = 3;
	localparam READ_ACK_B = 4;
	localparam REG_ADDR  = 5;
	localparam READ_ACK2 = 6;
	localparam READ_ACK2_B = 7;
	localparam READ_DATA = 8;
	localparam WRITE_ACK = 9;
	localparam WRITE_DATA = 10;
	localparam READ_ACK3 = 11;
	localparam READ_ACK3_B = 12;	
	localparam STOP = 13;
	localparam STOP2 = 14;

	reg [7:0] state;
	reg [7:0] saved_addr;
	reg [7:0] saved_data;
	reg [7:0] counter;
	reg write_enable;
	reg sda_out = 0;
	reg [1:0] i2c_scl_enable = 0;
	reg i2c_scl_enable2 = 0;
	reg i2c_clk = 1;
	reg	[7:0] CLK_COUNT = 0; 	//clock
	reg write_done = 0; // write done flag
	reg finish = 0; // finish flag
	reg rw = 0;

	assign i2c_clk_out = i2c_clk;
	assign sm = state; 
	// assign o_finish = finish;
	assign o_finish = ( (write_done == 0) && (state == STOP2) )? 1:0;
	assign o_w_enable = write_enable; 
	assign o_ready = ((i_rst_n == 1) && (state == IDLE)) ? 1 : 0;
	// assign i2c_scl = (i2c_scl_enable == 0 ) ? 1 : i2c_clk;
	// assign i2c_scl = (i2c_scl_enable2 == 0 ) ? 0 : ( (i2c_scl_enable == 0 ) ? 1 : i2c_clk) ;
	assign i2c_scl = (i2c_scl_enable == 0 ) ? 0 : ( (i2c_scl_enable == 1 ) ? 1 : i2c_clk) ;
	assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz;

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[7]:390.625 kHz, CLK_COUNT[6]:781.25 KHz
		i2c_clk <= CLK_COUNT[DIVNUM];
	end

	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			i2c_scl_enable <= 1;
		end else begin
			if ( (state == READ_ACK_B)|| (state == READ_ACK2_B) ) begin
				i2c_scl_enable <= 0;
			end 
			else if ( (state == IDLE) ||(state == START) || (state == STOP) || (state == STOP2 ) ) begin
				i2c_scl_enable <= 1;
			end 
			else begin
				i2c_scl_enable <= 2;
			end
		end
	end
	
	// always @(negedge i2c_clk or negedge i_rst_n) begin
	// 	if(!i_rst_n) begin
	// 		i2c_scl_enable <= 0;
	// 	end else begin
	// 		if ( (state == IDLE) ||(state == START) || (state == STOP) ) begin
	// 			i2c_scl_enable <= 0;
	// 		end 
	// 		else begin
	// 			i2c_scl_enable <= 1;
	// 		end
	// 	end
	// end

	// always @(posedge i2c_clk or negedge i_rst_n) begin
	// 	if(!i_rst_n) begin
	// 		i2c_scl_enable2 <= 1;
	// 	end else begin
	// 		if ( (state == READ_ACK_B)|| (state == READ_ACK2_B) ) begin
	// 			i2c_scl_enable2 <= 0;
	// 		end 
	// 		else begin
	// 			i2c_scl_enable2 <= 1;
	// 		end
	// 	end
	
	// end


	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			finish <= 1'b0;
			rw <= 1'b0;
		end		
		else begin
			case(state)
				IDLE: begin
					if (i_enable) begin
						state <= START;
						if(i_rw_reg == 1'b1) begin// read reg mode
							if(write_done == 1'b0) rw <= 1'b0;
							else rw <= 1'b1;
						end
						else rw <= 1'b0;
					end
					else state <= IDLE;

					if(finish == 1'b1) begin
						finish <= 1'b0;
						rw <= 1'b0;
					end
				end

				START: begin
					counter <= 7;
					saved_addr <= {i_dev_addr, rw};
					state <= ADDRESS;
				end

				ADDRESS: begin
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
					if(rw == 0) begin
						saved_data = i_reg_addr;
						state <= REG_ADDR;
					end
					else state <= READ_DATA;
				end

				REG_ADDR: begin 
					if(i_rw_reg == 1'b1) //read reg mode
						write_done <= 1'b1;

					if(counter == 0) begin
						state <= READ_ACK2;
					end else counter <= counter - 1;
				end

				READ_ACK2: begin 
					state <= READ_ACK2_B;
				end

				READ_ACK2_B: begin 
					counter <= 7;
					if( i_rw_reg == 1'b1) state <= STOP;
					else begin
						saved_data = i_w_data;
						state <= WRITE_DATA;
					end
				end

				STOP: begin
					// if(write_done==1'b0) finish <= 1'b1;
					// else finish <= 1'b0;
					state <= STOP2;
				end

				STOP2: begin
					if(write_done==1'b0) finish <= 1'b1;
					else finish <= 1'b0;
					state <= IDLE;
				end

				WRITE_DATA: begin 
					if(counter == 0) begin
						state <= READ_ACK3;
					end else counter <= counter - 1;
				end

				READ_DATA: begin
					if(write_done == 1'b1) write_done = 1'b0;
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin
					state <= STOP;
				end

				READ_ACK3: begin 
					state <= READ_ACK3_B;
				end

				READ_ACK3_B: begin 
					state <= STOP;
				end
			endcase
		end
	end
	
	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			write_enable <= 1;
			sda_out <= 1;
		end else begin
			case(state)
				
				START: begin
					write_enable <= 1;
					sda_out <= 0;
				end

				ADDRESS: begin
					sda_out <= saved_addr[counter];
				end
				
				READ_ACK: begin
					write_enable <= 0;
				end

				READ_ACK_B: begin
					write_enable <= 0;
				end

				READ_ACK2: begin
					write_enable <= 0;
				end

				READ_ACK2_B: begin 
					write_enable <= 0;
				end

				READ_ACK3: begin
					write_enable <= 0;
				end

				READ_ACK3_B: begin 
					write_enable <= 1;
					sda_out <= 0;
				end

				REG_ADDR: begin //write reg addr
					write_enable <= 1;
					sda_out <= saved_data[counter];
				end
				
				WRITE_DATA: begin //write reg value
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
					// write_enable <= 1;
					// sda_out <= 1;
				end

				STOP2: begin
					write_enable <= 1;
					sda_out <= 1;
				end
			endcase
		end
	end

endmodule