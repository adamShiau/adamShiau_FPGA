module i2c_controller_pullup
// #(parameter DIVNUM = 6)
(
	input wire 			i_clk,
	input wire 			i_rst_n,
	input wire [6:0] 	i_dev_addr,
	input wire [7:0] 	i_w_data,
	input wire [7:0] 	i_reg_addr,
	input wire [31:0]	i_ctrl,
	input wire 			i_drdy,

	output reg [7:0] 	o_rd_data,
	output reg [7:0] 	o_rd_data_2,
	output reg [7:0] 	o_rd_data_3,
	output reg [7:0] 	o_rd_data_4,
	output reg [7:0] 	o_rd_data_5,
	output reg [7:0] 	o_rd_data_6,
	output reg [7:0] 	o_rd_data_7,
	output reg [7:0] 	o_rd_data_8,
	output reg [7:0] 	o_rd_data_9,
	output reg [7:0] 	o_rd_data_10,
	output reg [7:0] 	o_rd_data_11,

	output wire [31:0] 	o_status,
	output wire 		o_w_enable,
	output wire			i2c_clk_out,
	output wire			i2c_scl,
	inout 				i2c_sda
	);

	/*** regidter definition***/
	localparam ADXL355_DEV_ADDR  = 7'h1D;
	localparam REG_ADXL355_TEMP2 = 8'h06;

	/*** I2C Clock rate definition for 50MHz input clock ***/
	localparam CLK_195K 	= 	7;
	localparam CLK_390K 	= 	6;
	localparam CLK_781K 	= 	5;
	localparam CLK_1562K 	= 	4;

	/*** op mode definition ***/
	localparam CPU_1 		= 	0;
	localparam CPU_11 		= 	1;
	localparam HW_11 		= 	2;

	/*** state machine definition ***/
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
	localparam NOP1 		= 	35;

	reg [7:0] state;
	reg [7:0] saved_addr;
	reg [7:0] saved_data;
	reg [7:0] counter;
	reg write_enable;
	reg sda_out = 0;
	reg [1:0] i2c_scl_enable = 0;
	reg i2c_scl_enable2 = 0;
	reg i2c_clk = 1;
	reg clk_2x = 1;
	reg	[7:0] CLK_COUNT = 0; 	//clock
	reg write_done = 0; // write done flag
	reg finish = 0; // finish flag
	reg rw = 0;
	reg r_drdy = 0;
	reg [2:0] reg_clock_rate = 6;

	wire i_enable, rw_reg, finish_ack;
	wire [1:0] op_mode;
	wire [2:0] clk_rate;
	reg sm_enable = 0;

	/******* control register********/
	assign i_enable = i_ctrl[0];
	assign rw_reg = i_ctrl[1];
	assign op_mode = i_ctrl[3:2]; //00: CPU 1 byte, 01: CPU 11 bytes, 10: FPGA 11 bytes, 11: reserved
	assign clk_rate = i_ctrl[6:4];

	/******* status register********/
	assign o_status[0] = ((i_rst_n == 1) && (state == IDLE) && (write_done == 0)) ? 1 : 0; //ready
	assign o_status[1] = finish; //finish 
	assign o_status[9:2] = state; 


	assign i2c_clk_out = i2c_clk;
	assign o_w_enable = write_enable; 
	assign i2c_scl = (i2c_scl_enable == 0 ) ? 0 : ( (i2c_scl_enable == 1 ) ? 1 : i2c_clk) ;
	assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz;

	/******* CLK_VALUE depends on input clock frequency, default is for 50 MHz********/
	always@(posedge i_clk) begin
		if(!i_rst_n) begin
			reg_clock_rate <= CLK_390K;
		end
		else begin
			reg_clock_rate <= clk_rate;
			case(clk_rate)
				CLK_195K : reg_clock_rate <= CLK_195K;
				CLK_390K : reg_clock_rate <= CLK_390K;
				CLK_781K : reg_clock_rate <= CLK_781K;
				CLK_1562K: reg_clock_rate <= CLK_1562K;
				default  : reg_clock_rate <= CLK_390K;
			endcase
		end
	end

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[6]:50000/2^(6+1)=390.625 kHz, CLK_COUNT[5]:781.25 KHz
		i2c_clk <= CLK_COUNT[reg_clock_rate];
		clk_2x  <= CLK_COUNT[reg_clock_rate-1];
	end

	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			i2c_scl_enable <= 1;
		end else begin
			if ( (state == READ_ACK_B)|| (state == READ_ACK2_B) ) begin
				i2c_scl_enable <= 0;
			end 
			else if ( (state == IDLE) ||(state == START) || (state == STOP) || (state == STOP2 ) || (state == NOP1 )) begin
				i2c_scl_enable <= 1;
			end 
			else begin
				i2c_scl_enable <= 2;
			end
		end
	end
	
	always @(posedge clk_2x or negedge i_rst_n) begin
		if(i2c_clk == 1) begin
			
			case(state)
				IDLE: begin	
				
				default: write_enable_2 <= 0;
			endcase
		end
		else begin
			write_enable_2 <= 0;
		end

	end


	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			write_enable <= 0;
			write_done <= 1'b0;
			rw <= 1'b0;
		end		
		else begin
			case(state)
				IDLE: begin
					if(op_mode==CPU_1 || op_mode==CPU_11) begin
						if(i_enable) sm_enable <= 1; 
					end
					
					if(op_mode==HW_11) begin
						if(i_drdy ) sm_enable <= 1; 
					end

					if (sm_enable) begin
						state <= START;

						if(op_mode==CPU_1 || op_mode==CPU_11) begin
							if(rw_reg == 1'b1) begin// read reg mode
								if(write_done == 1'b0) rw <= 1'b0;// in read reg mode, when write_done flag = 0 means it must write which reg you want to read first.  
								else rw <= 1'b1;
							end
							else rw <= 1'b0; // write reg mode							
						end			

						if(op_mode==HW_11) begin
							if(write_done == 1'b0) rw <= 1'b0;// in read reg mode, when write_done flag = 0 means it must write which reg you want to read first.  
							else rw <= 1'b1;
						end
					end
					else state <= IDLE;
				end



				START: begin
					write_enable <= 1;
					counter <= 7;
					if(op_mode==HW_11) saved_addr <= {ADXL355_DEV_ADDR, rw};
					else saved_addr <= {i_dev_addr, rw};
					state <= ADDRESS;
				end

				ADDRESS: begin
					if(saved_addr[counter]==1'b1) write_enable <= 0; //prepare pull-up condition.
					else write_enable <= 1;

					if (counter == 0) begin 
						state <= READ_ACK;
					end else counter <= counter - 1;
				end

				READ_ACK: begin
					write_enable <= 0;
					if (i2c_sda == 0) begin
						state <= READ_ACK_B;
					end 
					else state <= STOP;
				end

				READ_ACK_B: begin
					counter <= 7;
					if(rw == 0) begin
						if(op_mode==HW_11) saved_data = REG_ADXL355_TEMP2;
						else saved_data = i_reg_addr;
						state <= REG_ADDR;
					end
					else state <= READ_DATA;
				end

				REG_ADDR: begin 
					if(saved_data[counter]==1'b1) write_enable <= 0; //prepare pull-up condition.
					else write_enable <= 1;

					if(rw_reg == 1'b1) //read reg mode
						write_done <= 1'b1;

					if(counter == 0) begin
						state <= READ_ACK2;
					end else counter <= counter - 1;
				end

				READ_ACK2: begin 
					write_enable <= 0;
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
					write_enable <= 1;
					if(write_done==1'b0) begin
						sm_enable <= 1'b0;
					end
					state <= STOP2;
				end

				STOP2: begin
					state <= IDLE;
					finish <= 0;
				end

				NOP1: begin
					state <= IDLE;
				end

				WRITE_DATA: begin 
					if(saved_data[counter]==1'b1) write_enable <= 0; //prepare pull-up condition.
					else write_enable <= 1;

					if(counter == 0) begin
						state <= READ_ACK3;
					end else counter <= counter - 1;
				end

				READ_DATA: begin//11
					write_enable <= 0;
					if(write_done == 1'b1) write_done = 1'b0;
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin//12
					write_enable <= 1;
					if(op_mode == CPU_1) begin
						finish <= 1;
						state <= STOP; //00, CPU read 1 byte
					end
					else begin// else, CPU/FPGA read 11 bytes
						counter <= 7;
						state <= READ_DATA2;
					end
				end

				READ_DATA2: begin
					write_enable <= 0;
					o_rd_data_2[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK2;
					else counter <= counter - 1;
				end
				WRITE_ACK2: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA3;
				end

				READ_DATA3: begin
					write_enable <= 0;
					o_rd_data_3[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK3;
					else counter <= counter - 1;
				end
				WRITE_ACK3: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA4;
				end

				READ_DATA4: begin
					write_enable <= 0;
					o_rd_data_4[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK4;
					else counter <= counter - 1;
				end
				WRITE_ACK4: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA5;
				end

				READ_DATA5: begin
					write_enable <= 0;
					o_rd_data_5[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK5;
					else counter <= counter - 1;
				end
				WRITE_ACK5: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA6;
				end

				READ_DATA6: begin
					write_enable <= 0;
					o_rd_data_6[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK6;
					else counter <= counter - 1;
				end
				WRITE_ACK6: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA7;
				end

				READ_DATA7: begin
					write_enable <= 0;
					o_rd_data_7[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK7;
					else counter <= counter - 1;
				end
				WRITE_ACK7: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA8;
				end

				READ_DATA8: begin
					write_enable <= 0;
					o_rd_data_8[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK8;
					else counter <= counter - 1;
				end
				WRITE_ACK8: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA9;
				end

				READ_DATA9: begin
					write_enable <= 0;
					o_rd_data_9[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK9;
					else counter <= counter - 1;
				end
				WRITE_ACK9: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA10;
				end

				READ_DATA10: begin
					write_enable <= 0;
					o_rd_data_10[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK10;
					else counter <= counter - 1;
				end

				WRITE_ACK10: begin
					write_enable <= 1;
					counter <= 7;
					state <= READ_DATA11;
				end

				READ_DATA11: begin
					write_enable <= 0;
					o_rd_data_11[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK11;
					else counter <= counter - 1;
				end

				WRITE_ACK11: begin
					write_enable <= 1;
					finish <= 1;
					state <= STOP;
				end

				READ_ACK3: begin 
					write_enable <= 0;
					state <= READ_ACK3_B;
				end

				READ_ACK3_B: begin 
					finish <= 1;
					state <= STOP;
				end

				default: state <= IDLE;
			endcase
		end
	end
	
	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			// write_enable <= 1;
			sda_out <= 1;
		end else begin
			case(state)
				
				START: begin
					// write_enable <= 1;
					sda_out <= 0;
				end

				ADDRESS: begin
					sda_out <= saved_addr[counter];
				end
				
				READ_ACK: begin
					// write_enable <= 0;
				end

				READ_ACK_B: begin
					// write_enable <= 0;
				end

				READ_ACK2: begin
					// write_enable <= 0;
				end

				READ_ACK2_B: begin 
					// write_enable <= 0;
				end

				READ_ACK3: begin
					// write_enable <= 0;
				end

				READ_ACK3_B: begin 
					// write_enable <= 1;
					sda_out <= 0;
				end

				REG_ADDR: begin //write reg addr
					// write_enable <= 1;
					sda_out <= saved_data[counter];
				end
				
				WRITE_DATA: begin //write reg value
					// write_enable <= 1;
					sda_out <= saved_data[counter];
				end
				
				WRITE_ACK: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK2: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK3: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK4: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK5: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK6: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK7: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK8: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				WRITE_ACK9: begin
					// write_enable <= 1;
					sda_out <= 0;
				end
				
				READ_DATA: begin
					// write_enable <= 0;				
				end
				READ_DATA2: begin
					// write_enable <= 0;				
				end
				READ_DATA3: begin
					// write_enable <= 0;				
				end
				READ_DATA4: begin
					// write_enable <= 0;				
				end
				READ_DATA5: begin
					// write_enable <= 0;				
				end
				READ_DATA6: begin
					// write_enable <= 0;				
				end
				READ_DATA7: begin
					// write_enable <= 0;				
				end
				READ_DATA8: begin
					// write_enable <= 0;				
				end
				READ_DATA9: begin
					// write_enable <= 0;				
				end
				
				STOP: begin

				end

				STOP2: begin
					// write_enable <= 1;
					sda_out <= 1;
				end

				default:;
			endcase
		end
	end

endmodule