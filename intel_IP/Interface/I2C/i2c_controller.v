//`timescale 1ns / 100ps


module i2c_controller
#(parameter DIVNUM = 6)
(
	input wire 			i_clk,
	input wire 			i_rst_n,
	input wire [6:0] 	i_dev_addr,
	input wire [7:0] 	i_w_data,
	input wire [7:0] 	i_reg_addr,
	// input wire 			sm_enable,
	input wire [31:0]	i_ctrl,
	// input wire 			rw_reg,
	input wire 			i_drdy,

	output reg [7:0] 	o_rd_data,
	// output wire			o_ready,
	// output wire			o_finish,
	output wire [31:0] 	o_status,
	output wire 		o_w_enable,
	// output wire [7:0] 	sm,
	output wire			i2c_clk_out,
	output wire			i2c_scl,
	inout 				i2c_sda
	);

	localparam IDLE 		= 	0;
	localparam START 		= 	1;
	localparam ADDRESS 		= 	2;
	localparam READ_ACK 	= 	3;
	localparam READ_ACK_B 	= 	4;
	localparam REG_ADDR  	= 	5;
	localparam READ_ACK2 	= 	6;
	localparam READ_ACK2_B 	= 	7;
	localparam WRITE_DATA 	= 	8;
	localparam READ_ACK3 	= 	9;
	localparam READ_ACK3_B 	= 	10;	
	localparam READ_DATA 	= 	11;
	localparam WRITE_ACK 	= 	12;
	localparam READ_DATA2 	= 	13;
	localparam WRITE_ACK2 	= 	14;
	localparam READ_DATA3 	= 	15;
	localparam WRITE_ACK3 	= 	16;
	localparam READ_DATA4 	= 	17;
	localparam WRITE_ACK4 	= 	18;
	localparam READ_DATA5 	= 	19;
	localparam WRITE_ACK5 	= 	20;
	localparam READ_DATA6 	= 	21;
	localparam WRITE_ACK6 	= 	22;
	localparam READ_DATA7 	= 	23;
	localparam WRITE_ACK7 	= 	24;
	localparam READ_DATA8 	= 	25;
	localparam WRITE_ACK8 	= 	26;
	localparam READ_DATA9 	= 	27;
	localparam WRITE_ACK9 	= 	28;
	localparam READ_DATA10 	= 	29;
	localparam WRITE_ACK10 	= 	30;
	localparam READ_DATA11 	= 	31;
	localparam WRITE_ACK11 	= 	32;
	localparam STOP 		= 	33;
	localparam STOP2 		= 	34;

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
	reg r_drdy = 0;

	wire i_enable, rw_reg;
	wire [1:0] op_mode;
	reg sm_enable = 0;
	// control register
	// assign sm_enable = i_ctrl[0];
	assign i_enable = i_ctrl[0];
	assign rw_reg = i_ctrl[1];
	assign op_mode = i_ctrl[3:2]; //00: CPU 1 byte, 01: CPU 11 bytes, 10: FPGA 11 bytes, 11: reserved
	// status register
	assign o_status[0] = ((i_rst_n == 1) && (state == IDLE)) ? 1 : 0; //ready


	assign i2c_clk_out = i2c_clk;
	assign sm = state; 
	assign o_finish = ( (write_done == 0) && (state == STOP2) )? 1:0;
	assign o_w_enable = write_enable; 
	
	// assign i2c_scl = (i2c_scl_enable == 0 ) ? 1 : i2c_clk;
	// assign i2c_scl = (i2c_scl_enable2 == 0 ) ? 0 : ( (i2c_scl_enable == 0 ) ? 1 : i2c_clk) ;
	assign i2c_scl = (i2c_scl_enable == 0 ) ? 0 : ( (i2c_scl_enable == 1 ) ? 1 : i2c_clk) ;
	assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz;

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[7]:390.625 kHz, CLK_COUNT[6]:781.25 KHz
		i2c_clk <= CLK_COUNT[DIVNUM];
	end

	// always@(posedge i2c_clk) begin
	// 	sm_enable <= i_enable;
	// end

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
	
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			finish <= 1'b0;
			write_done <= 1'b0;
			rw <= 1'b0;
		end		
		else begin
			case(state)
				IDLE: begin
					if(i_enable) sm_enable <= 1;

					if(finish == 1'b1) begin
						finish <= 1'b0;
						rw <= 1'b0;
					end

					if (sm_enable) begin
						state <= START;
						if(rw_reg == 1'b1) begin// read reg mode
							if(write_done == 1'b0) rw <= 1'b0;// in read reg mode, when write_done flag = 0 means it must write which reg you want to read first.  
							else rw <= 1'b1;
						end
						else rw <= 1'b0; // write reg mode
					end
					else state <= IDLE;
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
					if(rw_reg == 1'b1) //read reg mode
						write_done <= 1'b1;

					if(counter == 0) begin
						state <= READ_ACK2;
					end else counter <= counter - 1;
				end

				READ_ACK2: begin 
					state <= READ_ACK2_B;
				end

				READ_ACK2_B: begin 
					if( rw_reg == 1'b1) state <= STOP;
					else begin
						counter <= 7;
						saved_data = i_w_data;
						state <= WRITE_DATA;
					end
				end

				STOP: begin
					state <= STOP2;
				end

				STOP2: begin
					if(write_done==1'b0) begin
						finish <= 1'b1;
						sm_enable <= 1'b0;
					end
					else finish <= 1'b0;
					state <= IDLE;
				end

				WRITE_DATA: begin 
					if(counter == 0) begin
						state <= READ_ACK3;
					end else counter <= counter - 1;
				end

				READ_DATA: begin//11
					if(write_done == 1'b1) write_done = 1'b0;
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin//12
					if(~op_mode) state <= STOP; //00, CPU read 1 byte
					else begin// else, CPU/FPGA read 11 bytes
						counter <= 7;
						state <= READ_DATA2;
					end
				end

				READ_DATA2: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK2;
					else counter <= counter - 1;
				end
				WRITE_ACK2: begin
					counter <= 7;
					state <= READ_DATA3;
				end

				READ_DATA3: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK3;
					else counter <= counter - 1;
				end
				WRITE_ACK3: begin
					counter <= 7;
					state <= READ_DATA4;
				end

				READ_DATA4: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK4;
					else counter <= counter - 1;
				end
				WRITE_ACK4: begin
					counter <= 7;
					state <= READ_DATA5;
				end

				READ_DATA5: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK5;
					else counter <= counter - 1;
				end
				WRITE_ACK5: begin
					counter <= 7;
					state <= READ_DATA6;
				end

				READ_DATA6: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK6;
					else counter <= counter - 1;
				end
				WRITE_ACK6: begin
					counter <= 7;
					state <= READ_DATA7;
				end

				READ_DATA7: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK7;
					else counter <= counter - 1;
				end
				WRITE_ACK7: begin
					counter <= 7;
					state <= READ_DATA8;
				end

				READ_DATA8: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK8;
					else counter <= counter - 1;
				end
				WRITE_ACK8: begin
					counter <= 7;
					state <= READ_DATA9;
				end

				READ_DATA9: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK9;
					else counter <= counter - 1;
				end
				WRITE_ACK9: begin
					counter <= 7;
					state <= READ_DATA10;
				end

				READ_DATA10: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK10;
					else counter <= counter - 1;
				end

				WRITE_ACK10: begin
					counter <= 7;
					state <= READ_DATA11;
				end

				READ_DATA11: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK11;
					else counter <= counter - 1;
				end

				WRITE_ACK11: begin
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
			counter <= 0;
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
				WRITE_ACK2: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK3: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK4: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK5: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK6: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK7: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK8: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK9: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				
				READ_DATA: begin
					write_enable <= 0;				
				end
				READ_DATA2: begin
					write_enable <= 0;				
				end
				READ_DATA3: begin
					write_enable <= 0;				
				end
				READ_DATA4: begin
					write_enable <= 0;				
				end
				READ_DATA5: begin
					write_enable <= 0;				
				end
				READ_DATA6: begin
					write_enable <= 0;				
				end
				READ_DATA7: begin
					write_enable <= 0;				
				end
				READ_DATA8: begin
					write_enable <= 0;				
				end
				READ_DATA9: begin
					write_enable <= 0;				
				end
				
				STOP: begin

				end

				STOP2: begin
					write_enable <= 1;
					sda_out <= 1;
				end
			endcase
		end
	end

endmodule