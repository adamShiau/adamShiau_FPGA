module i2c_controller_pullup_eeprom
(
	input wire 			i_clk,
	input wire 			i_rst_n,
	input wire [6:0] 	i_dev_addr,
	input wire [32-1:0] 	i_w_data,
	input wire [16-1:0] 	i_reg_addr,
	input wire [31:0]	i_ctrl,
	input wire 			i_drdy,

	output reg [7:0] 	o_rd_data,
	output reg [7:0] 	o_rd_data_2,
	output reg [7:0] 	o_rd_data_3,
	output reg [7:0] 	o_rd_data_4,
	// output reg [7:0] 	o_rd_data_5,
	// output reg [7:0] 	o_rd_data_6,
	// output reg [7:0] 	o_rd_data_7,
	// output reg [7:0] 	o_rd_data_8,
	// output reg [7:0] 	o_rd_data_9,
	// output reg [7:0] 	o_rd_data_10,
	// output reg [7:0] 	o_rd_data_11,

	output wire [31:0] 	o_status,
	output wire 		o_w_enable,
	output wire			i2c_clk_out,
	inout				i2c_scl,
	inout 				i2c_sda
	);

	/*** register definition***/
	// localparam ADXL355_DEV_ADDR  	= 7'h1D;
	// localparam REG_ADXL355_TEMP2 	= 8'h06;
	// localparam REG_ADXL355_TXDATA3 	= 8'h08;

	/*** I2C Clock rate definition for 100MHz input clock ***/
	localparam CLK_390K 	= 	7;
	localparam CLK_781K 	= 	6;
	localparam CLK_1562K 	= 	5;
	localparam CLK_3125K 	= 	4;

	/*** op mode definition ***/
	localparam CPU_1 		= 	2'b00;
	localparam CPU_11 		= 	2'b01;
	localparam HW_11 		= 	2'b11;

	/*** state machine definition ***/
	localparam IDLE 		= 	0;
	localparam START 		= 	1;
	localparam ADDRESS 		= 	2;
	localparam READ_ACK 	= 	3;
	localparam READ_ACK_B 	= 	4;
	localparam REG_ADDR  	= 	5;
	localparam READ_ACK2 	= 	6;
	localparam READ_ACK2_B 	= 	7;
	localparam REG_ADDR2  	= 	8;
	localparam READ_ACK3 	= 	9;
	localparam READ_ACK3_B 	= 	10;	
	localparam WRITE_DATA 	= 	11;
	localparam READ_ACK4 	= 	12;
	localparam READ_ACK4_B 	= 	13;	
	localparam WRITE_DATA2 	= 	14;
	localparam READ_ACK5 	= 	15;
	localparam READ_ACK5_B 	= 	16;	
	localparam WRITE_DATA3 	= 	17;
	localparam READ_ACK6 	= 	18;
	localparam READ_ACK6_B 	= 	19;	
	localparam WRITE_DATA4 	= 	20;
	localparam READ_ACK7 	= 	21;
	localparam READ_ACK7_B 	= 	22;	
	localparam READ_DATA 	= 	23;
	localparam WRITE_ACK 	= 	24;
	localparam READ_DATA2 	= 	25;
	localparam WRITE_ACK2 	= 	26;
	localparam READ_DATA3 	= 	27;
	localparam WRITE_ACK3 	= 	28;
	localparam READ_DATA4 	= 	29;
	localparam WRITE_ACK4 	= 	30;
	localparam STOP 		= 	31;
	localparam STOP2 		= 	32;
	localparam NOP1 		= 	33;


	reg [7:0] state;
	reg [7:0] saved_addr;
	reg [7:0] saved_data; //del.
	reg [7:0] saved_regaddr_H, saved_regaddr_L;
	reg [7:0] saved_write_3, saved_write_2, saved_write_1, saved_write_0;
	reg [7:0] counter;
	reg sda_out = 0;
	reg [1:0] i2c_scl_enable = 0;
	reg i2c_scl_enable2 = 0;
	reg i2c_clk = 1;
	reg clk_2x = 1;
	reg	[8:0] CLK_COUNT = 0; 	//clock
	reg write_done = 0; // write done flag
	reg finish = 0; // finish flag
	reg rw = 0;
	reg r_drdy = 0;
	reg [2:0] reg_clock_rate = 6;

	wire i_enable, rw_reg, finish_ack;
	wire [1:0] op_mode;
	wire [2:0] clk_rate;
	reg sm_enable = 0;

	wire w_en1, write_enable;
	reg w_en2 = 0;

	assign w_en1 = (sda_out==1)? 0:1 ;
	assign write_enable = w_en1 | w_en2;

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
	assign i2c_scl =	(i2c_scl_enable == 0) ? 0 : 
						((i2c_scl_enable == 1) ? 1'bz : 
                 		(i2c_clk == 1 ? 1'bz : 0));
	assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz;

	/******* CLK_VALUE depends on input clock frequency, default is for 50 MHz********/
	always@(posedge i_clk) begin
		if(!i_rst_n) begin
			reg_clock_rate <= CLK_390K;
		end
		else begin
			reg_clock_rate <= clk_rate;
			case(clk_rate)
				CLK_390K : reg_clock_rate <= CLK_390K;
				CLK_781K : reg_clock_rate <= CLK_781K;
				CLK_1562K: reg_clock_rate <= CLK_1562K;
				CLK_3125K: reg_clock_rate <= CLK_3125K;
				default  : reg_clock_rate <= CLK_390K;
			endcase
		end
	end

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[6]:100000/2^(6+1)=781.25 kHz, CLK_COUNT[7+1]:390.625 KHz
		i2c_clk <= CLK_COUNT[reg_clock_rate];
		clk_2x  <= CLK_COUNT[reg_clock_rate-1];
	end

	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			i2c_scl_enable <= 1;
		end else begin
			if ( (state == READ_ACK_B) || (state == READ_ACK2_B) || (state == READ_ACK3_B) || (state == READ_ACK4_B) 
			 || (state == READ_ACK5_B) || (state == READ_ACK6_B) || (state == READ_ACK7_B)) begin
				i2c_scl_enable <= 0;
			end 
			else if ( (state == IDLE) ||(state == START) || (state == STOP) || (state == STOP2 ) || (state == NOP1 )  ) begin
				i2c_scl_enable <= 1;
			end 
			else begin
				i2c_scl_enable <= 2;
			end
		end
	end
	
	/*** For the states need to WRITE operation, let w_en2 = 1, otherwise w_en2 = 0***/
	always @(posedge clk_2x or negedge i_rst_n) begin
		if(!i_rst_n) begin
			w_en2 <= 0;
		end 
		else begin
			case(state)
				START: begin	
					w_en2 <= 1;
				end
				ADDRESS: begin
					if(saved_addr[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				REG_ADDR: begin
					if(saved_regaddr_H[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				REG_ADDR2: begin
					if(saved_regaddr_L[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_DATA: begin
					if(saved_write_3[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_DATA2: begin
					if(saved_write_2[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_DATA3: begin
					if(saved_write_1[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_DATA4: begin
					if(saved_write_0[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_ACK: begin
					w_en2 <= 1;
				end
				WRITE_ACK2: begin
					w_en2 <= 1;
				end
				WRITE_ACK3: begin
					w_en2 <= 1;
				end
				WRITE_ACK4: begin
					w_en2 <= 1;
				end
				NOP1: begin
					w_en2 <= 1;
				end
				STOP: begin
					w_en2 <= 1;
				end
				default: w_en2 <= 0;
			endcase
		end
	end

	/*** SM update**/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			write_done <= 1'b0;
			rw <= 1'b0;
		end		
		else begin
			case(state)
				IDLE: begin
					// if(op_mode==CPU_1 || op_mode==CPU_11) begin
					// 	if(i_enable) sm_enable <= 1; 
					// end
					
					// if(op_mode==HW_11) begin
					// 	if(i_drdy ) sm_enable <= 1; 
					// end

					if(i_enable) sm_enable <= 1; 

					if (sm_enable) begin
						state <= START;

						if(rw_reg == 1'b1) begin// read reg mode
							if(write_done == 1'b0) rw <= 1'b0;// in read reg mode, when write_done flag = 0 means it must write which reg you want to read first.  
							else rw <= 1'b1;
						end
						else rw <= 1'b0; // write reg mode			

						// if(op_mode==CPU_1 || op_mode==CPU_11) begin
						// 	if(rw_reg == 1'b1) begin// read reg mode
						// 		if(write_done == 1'b0) rw <= 1'b0;// in read reg mode, when write_done flag = 0 means it must write which reg you want to read first.  
						// 		else rw <= 1'b1;
						// 	end
						// 	else rw <= 1'b0; // write reg mode							
						// end			

						// if(op_mode==HW_11) begin
						// 	if(write_done == 1'b0) rw <= 1'b0;// in read reg mode, when write_done flag = 0 means it must write which reg you want to read first.  
						// 	else rw <= 1'b1;
						// end
					end
					else state <= IDLE;
				end

				START: begin
					counter <= 7;
					// if(op_mode==HW_11) saved_addr <= {ADXL355_DEV_ADDR, rw};
					// else saved_addr <= {i_dev_addr, rw};
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
						// if(op_mode==HW_11) saved_data = REG_ADXL355_TEMP2;
						// if(op_mode==HW_11) saved_data = REG_ADXL355_TXDATA3;
						// else saved_data <= i_reg_addr;
						// saved_data <= i_reg_addr;
						saved_regaddr_H <= i_reg_addr[15:8];
						saved_regaddr_L <= i_reg_addr[7:0];
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
					// if( rw_reg == 1'b1) state <= STOP;
					// else begin
					// 	counter <= 7;
					// 	saved_data = i_w_data;
					// 	state <= WRITE_DATA;
					// end
					counter <= 7;
					state <= REG_ADDR2;
				end

				REG_ADDR2: begin 
					if(counter == 0) begin
						state <= READ_ACK3;
					end else counter <= counter - 1;
				end

				READ_ACK3: begin 
					state <= READ_ACK3_B;
				end

				READ_ACK3_B: begin 
					if( rw_reg == 1'b1) state <= STOP;
					else begin
						counter <= 7;
						// saved_data = i_w_data;
						saved_write_3 <=  i_w_data[31:24]; // MSB
						saved_write_2 <=  i_w_data[23:16];
						saved_write_1 <=  i_w_data[15:8];
						saved_write_0 <=  i_w_data[7:0]; //LSB
						state <= WRITE_DATA;
					end
					// finish <= 1;
					// state <= STOP;
				end

				STOP: begin
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
					state <= STOP;
				end

				WRITE_DATA: begin 
					if(counter == 0) begin
						// state <= READ_ACK3;
						state <= READ_ACK4;
					end else counter <= counter - 1;
				end

				READ_ACK4: begin 
					state <= READ_ACK4_B;
				end

				READ_ACK4_B: begin 
					counter <= 7;
					state <= WRITE_DATA2;
				end

				WRITE_DATA2: begin 
					if(counter == 0) begin
						state <= READ_ACK5;
					end else counter <= counter - 1;
				end

				READ_ACK5: begin 
					state <= READ_ACK5_B;
				end

				READ_ACK5_B: begin 
					counter <= 7;
					state <= WRITE_DATA3;
				end

				WRITE_DATA3: begin 
					if(counter == 0) begin
						state <= READ_ACK6;
					end else counter <= counter - 1;
				end

				READ_ACK6: begin 
					state <= READ_ACK6_B;
				end

				READ_ACK6_B: begin 
					counter <= 7;
					state <= WRITE_DATA4;
				end

				WRITE_DATA4: begin 
					if(counter == 0) begin
						state <= READ_ACK7;
					end else counter <= counter - 1;
				end

				READ_ACK7: begin 
					state <= READ_ACK7_B;
				end

				READ_ACK7_B: begin 
					finish <= 1;
					state <= STOP;
					// state <= NOP1;
				end

				READ_DATA: begin//11
					if(write_done == 1'b1) write_done <= 1'b0;
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin//12
					counter <= 7;
					state <= READ_DATA2;
				end

				READ_DATA2: begin
					o_rd_data_2[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK2;
					else counter <= counter - 1;
				end
				WRITE_ACK2: begin
					counter <= 7;
					state <= READ_DATA3;
				end

				READ_DATA3: begin
					o_rd_data_3[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK3;
					else counter <= counter - 1;
				end
				WRITE_ACK3: begin
					counter <= 7;
					state <= READ_DATA4;
				end

				READ_DATA4: begin
					o_rd_data_4[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK4;
					else counter <= counter - 1;
				end
				WRITE_ACK4: begin
					// counter <= 7;
					// state <= READ_DATA5;
					finish <= 1;
					state <= STOP;
				end
				default: state <= IDLE;
			endcase
		end
	end
	
	/*** sda_out control, active on the negative edge of the SM.
	For the read operation, set sda_out = 1;
	For the write operation, set sda_out = 0.
	***/
	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			sda_out <= 1;
		end else begin
			case(state)
				
				START: begin
					sda_out <= 0;
				end
				ADDRESS: begin
					sda_out <= saved_addr[counter];
				end
				
				READ_ACK: begin
					sda_out <= 1;
				end

				READ_ACK_B: begin
					sda_out <= 1;
				end

				READ_ACK2: begin
					sda_out <= 1;
				end

				READ_ACK2_B: begin 
					sda_out <= 1;
				end

				READ_ACK3: begin
					sda_out <= 1;
				end

				READ_ACK3_B: begin 
					sda_out <= 1;
				end

				READ_ACK4: begin
					sda_out <= 1;
				end

				READ_ACK4_B: begin 
					sda_out <= 1;
				end

				READ_ACK5: begin
					sda_out <= 1;
				end

				READ_ACK5_B: begin 
					sda_out <= 1;
				end

				READ_ACK6: begin
					sda_out <= 1;
				end

				READ_ACK6_B: begin 
					sda_out <= 1;
				end

				READ_ACK7: begin
					sda_out <= 1;
				end

				READ_ACK7_B: begin 
					sda_out <= 1;
				end

				REG_ADDR: begin //write reg addr
					// sda_out <= saved_data[counter];
					sda_out <= saved_regaddr_H[counter];
				end

				REG_ADDR2: begin //write reg addr L-byte
					sda_out <= saved_regaddr_L[counter];
				end
				
				WRITE_DATA: begin //write reg value
					sda_out <= saved_write_3[counter];
				end

				WRITE_DATA2: begin //write data
					sda_out <= saved_write_2[counter];
				end

				WRITE_DATA3: begin //write data
					sda_out <= saved_write_1[counter];
				end

				WRITE_DATA4: begin //write data, LSB
					sda_out <= saved_write_0[counter];
				end

				WRITE_ACK: begin
					sda_out <= 0;
				end
				WRITE_ACK2: begin
					sda_out <= 0;
				end
				WRITE_ACK3: begin
					sda_out <= 0;
				end
				WRITE_ACK4: begin
					sda_out <= 0;
				end

				READ_DATA: begin
					sda_out <= 1;			
				end
				READ_DATA2: begin
					sda_out <= 1;			
				end
				READ_DATA3: begin
					sda_out <= 1;			
				end
				READ_DATA4: begin
					sda_out <= 1;			
				end
				
				STOP: begin
					sda_out <= 0;
					// sda_out <= 1;
				end
				STOP2: begin
					sda_out <= 1;
				end
				NOP1: begin
					sda_out <= 0;
				end

				default:;
			endcase
		end
	end

endmodule