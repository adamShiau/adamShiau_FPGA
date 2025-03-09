module i2c_controller_pullup_ADXL357_v5
(
	input wire 			i_clk,
	input wire 			i_rst_n,
	input wire [6:0] 	i_dev_addr,
	input wire [7:0] 	i_w_data,
	input wire [7:0] 	i_reg_addr,
	input wire [31:0]	i_ctrl,
	input wire 			i_drdy,

	output reg signed [32-1:0] 	o_ACCX,
	output reg signed [32-1:0] 	o_ACCY,
	output reg signed [32-1:0] 	o_ACCZ,
	output reg signed [32-1:0] 	o_TEMP,


	output wire [31:0] 	o_status,
	output wire 		o_w_enable,
	output wire			i2c_clk_out,
	inout				i2c_scl,
	inout 				i2c_sda
);

	/*** regidter definition***/
	localparam ADXL355_DEV_ADDR  	= 7'h1D;
	localparam REG_ADXL355_TEMP2 	= 8'h06;
	localparam REG_ADXL355_XDATA3 	= 8'h08;
	localparam REG_ADXL355_ZDATA3 	= 8'h0E;

	/*** I2C Clock rate definition for 50MHz input clock ***/
	localparam CLK_390K 	= 	7;
	localparam CLK_781K 	= 	6;
	localparam CLK_1562K 	= 	5;
	localparam CLK_3125K 	= 	4;

	/*** op mode definition ***/
	localparam CPU_RREG 		= 	3'd0;
	localparam CPU_WREG 		= 	3'd1;
	localparam CPU_RD_TEMP 		= 	3'd2;
	localparam CPU_RD_ACCL 		= 	3'd3;
	localparam HW_ALL 			= 	3'd4;
	localparam HW_ACC 			= 	3'd5;
	localparam HW_TEMP 			= 	3'd6;

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

	reg signed [7:0] 	reg_rd_data;
	reg signed [7:0] 	reg_rd_data_2;
	reg signed [7:0] 	reg_rd_data_3;
	reg signed [7:0] 	reg_rd_data_4;
	reg signed [7:0] 	reg_rd_data_5;
	reg signed [7:0] 	reg_rd_data_6;
	reg signed [7:0] 	reg_rd_data_7;
	reg signed [7:0] 	reg_rd_data_8;
	reg signed [7:0] 	reg_rd_data_9;
	reg signed [7:0] 	reg_rd_data_10;
	reg signed [7:0] 	reg_rd_data_11;

	reg [7:0] state;
	reg [7:0] saved_addr;
	reg [7:0] saved_data;
	reg [7:0] counter;
	reg sda_out = 0;
	reg [1:0] i2c_scl_enable = 0;
	reg i2c_scl_enable2 = 0;
	reg i2c_clk = 1;
	reg clk_2x = 1;
	reg	[8:0] CLK_COUNT = 0; 	//clock
	reg write_done = 0; // write done flag
	reg finish = 0; // finish flag
	// reg rw = 0;
	reg r_drdy = 0;
	reg [2:0] reg_clock_rate = 6;

	wire i_enable, finish_ack;
	wire [2:0] op_mode;
	wire [2:0] clk_rate;
	reg sm_enable;

	wire w_en1, write_enable;
	reg w_en2 = 0;

	// assign w_en1 = (sda_out==1)? 0:1 ;
	assign w_en1 = ~sda_out;
	assign write_enable = w_en1 | w_en2;

	/******* control register********/
	assign i_enable = i_ctrl[0];
	// assign rw_reg = i_ctrl[1];
	assign op_mode = i_ctrl[3:1]; //00: CPU 1 byte, 01: CPU 11 bytes, 10: FPGA 11 bytes, 11: reserved
	assign clk_rate = i_ctrl[6:4];

	/******* status register********/
	assign o_status[0] = ((i_rst_n == 1) && (state == IDLE) && (write_done == 0)) ? 1 : 0; //ready
	assign o_status[1] = finish; //finish 
	assign o_status[9:2] = state;  
	assign o_status[10]  = sm_enable;


	assign i2c_clk_out = i2c_clk;
	assign o_w_enable = write_enable; 
	assign i2c_scl =	(i2c_scl_enable == 0) ? 0 : 
						((i2c_scl_enable == 1) ? 1'bz : 
                 		(i2c_clk == 1 ? 1'bz : 0));
	assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz; // open drain method

	/******* CLK_VALUE depends on input clock frequency********/
	always@(posedge i_clk) begin
		if(!i_rst_n) begin
			reg_clock_rate <= CLK_390K;
		end
		else begin
			reg_clock_rate <= clk_rate;
			case(clk_rate)
				CLK_390K : reg_clock_rate <= CLK_390K;
				CLK_781K : reg_clock_rate <= CLK_781K;
				CLK_1562K : reg_clock_rate <= CLK_1562K;
				CLK_3125K: reg_clock_rate <= CLK_3125K;
				default  : reg_clock_rate <= CLK_390K;
			endcase
		end
	end

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[6]:100000/2^(7+1)=390.625 kHz, CLK_COUNT[6]:781.25 KHz
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
					if(saved_data[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_DATA: begin
					if(saved_data[counter]==0) w_en2 <= 1;
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
				WRITE_ACK5: begin
					w_en2 <= 1;
				end
				WRITE_ACK6: begin
					w_en2 <= 1;
				end
				WRITE_ACK7: begin
					w_en2 <= 1;
				end
				WRITE_ACK8: begin
					w_en2 <= 1;
				end
				WRITE_ACK9: begin
					w_en2 <= 1;
				end
				WRITE_ACK10: begin
					w_en2 <= 1;
				end
				WRITE_ACK11: begin
					w_en2 <= 1;
				end
				STOP: begin
					w_en2 <= 1;
				end
				default: w_en2 <= 0;
			endcase
		end
	end

// State machine states
typedef enum logic [1:0] {
	HW_SM_W_REG_TEMP = 2'd0,
	HW_SM_R_TEMP = 2'd1,
	HW_SM_W_REG_ACC = 2'd2,
	HW_SM_R_ACC = 2'd3
} state_t;

typedef enum logic [2:0] {
	CPU_SM_W_REG = 3'd0,
	CPU_SM_R_REG = 3'd1,
	CPU_SM_R_TEMP = 3'd2,
	CPU_SM_R_ACCL = 3'd3
} CPU_state_t;

state_t HW_SM;
CPU_state_t CPU_SM;

/*** SM update**/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			write_done <= 1'b0;
			// rw <= 1'b0;
			reg_rd_data <= 0;reg_rd_data_2 <= 0;reg_rd_data_3 <= 0;
			reg_rd_data_4 <= 0;reg_rd_data_5 <= 0;reg_rd_data_6 <= 0;
			reg_rd_data_7 <= 0;reg_rd_data_8 <= 0;reg_rd_data_9 <= 0;
			reg_rd_data_10 <= 0;reg_rd_data_11 <= 0;
			o_ACCX <= 0; o_ACCY <= 0; o_ACCZ <= 0; o_TEMP <= 0;
			sm_enable <= 0; 
			saved_data <= 0;
			finish <= 0;
			CPU_SM <= CPU_SM_W_REG;
			// HW_SM <= HW_SM_W_REG_TEMP;
			HW_SM <= HW_SM_W_REG_ACC;
		end		
		else begin

			case(state)
				IDLE: begin
					case(op_mode) 
						CPU_WREG, CPU_RREG, CPU_RD_TEMP, CPU_RD_ACCL: begin
							if(i_enable) sm_enable <= 1; 
						end
						HW_ALL, HW_ACC, HW_TEMP: begin
							if(i_drdy) sm_enable <= 1; 
						end 
						default: state <= IDLE;

					endcase

					if (sm_enable) begin
						state <= START;
					end
					else state <= IDLE;

				end

				START: begin
					counter <= 7; // Initialize counter to 7 in this state, as it will be used as an index in the next state.
					case(op_mode) 
						CPU_WREG: saved_addr <= {ADXL355_DEV_ADDR, 1'b0};
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) saved_addr <= {ADXL355_DEV_ADDR, 1'b0};
							else if(CPU_SM == CPU_SM_R_REG) saved_addr <= {ADXL355_DEV_ADDR, 1'b1};
						end
						CPU_RD_TEMP: begin
							if(CPU_SM == CPU_SM_W_REG) saved_addr <= {ADXL355_DEV_ADDR, 1'b0};
							else if(CPU_SM == CPU_SM_R_TEMP) saved_addr <= {ADXL355_DEV_ADDR, 1'b1};
						end
						CPU_RD_ACCL: begin
							if(CPU_SM == CPU_SM_W_REG) saved_addr <= {ADXL355_DEV_ADDR, 1'b0};
							else if(CPU_SM == CPU_SM_R_ACCL) saved_addr <= {ADXL355_DEV_ADDR, 1'b1};
						end
						HW_ALL, HW_ACC, HW_TEMP: begin
							if(HW_SM == HW_SM_W_REG_TEMP || HW_SM == HW_SM_W_REG_ACC) saved_addr <= {ADXL355_DEV_ADDR, 1'b0};
							else if(HW_SM == HW_SM_R_TEMP || HW_SM == HW_SM_R_ACC) saved_addr <= {ADXL355_DEV_ADDR, 1'b1};
						end
					endcase
					state <= ADDRESS;
					
				end

				ADDRESS: begin
					if (counter == 0) begin 
						state <= READ_ACK;
					end else begin
						 counter <= counter - 1;
					end
				end

				READ_ACK: begin
					if (i2c_sda == 0) begin
						state <= READ_ACK_B;
					end 
					else state <= STOP;
				end

				READ_ACK_B: begin
					counter <= 7; // Initialize counter to 7 in this state, as it will be used as an index in the next state.

					case(op_mode) 
						CPU_WREG: begin
							saved_data <= i_reg_addr;
							state <= REG_ADDR;
						end
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) begin
								saved_data <= i_reg_addr;
								state <= REG_ADDR;
							end
							else if(CPU_SM == CPU_SM_R_REG) state <= READ_DATA;
						end
						CPU_RD_TEMP: begin
							if(CPU_SM == CPU_SM_W_REG) begin
								saved_data <= REG_ADXL355_TEMP2;
								state <= REG_ADDR;
							end
							else if(CPU_SM == CPU_SM_R_TEMP) state <= READ_DATA;
						end
						CPU_RD_ACCL: begin
							if(CPU_SM == CPU_SM_W_REG) begin
								saved_data <= REG_ADXL355_XDATA3;
								state <= REG_ADDR;
							end
							else if(CPU_SM == CPU_SM_R_ACCL) state <= READ_DATA;
						end
						HW_ALL, HW_ACC, HW_TEMP: begin
							if(HW_SM == HW_SM_W_REG_TEMP) begin
								saved_data <= REG_ADXL355_TEMP2;
								state <= REG_ADDR;
							end
							else if(HW_SM == HW_SM_R_TEMP) state <= READ_DATA;
							else if(HW_SM == HW_SM_W_REG_ACC) begin
								saved_data <= REG_ADXL355_XDATA3;
								state <= REG_ADDR;
							end
							else if(HW_SM == HW_SM_R_ACC) state <= READ_DATA;
						end
					endcase
				end

				REG_ADDR: begin 
					if(counter == 0) begin
						state <= READ_ACK2;
					end else begin 
						counter <= counter - 1;
					end
				end

				READ_ACK2: begin 
					state <= READ_ACK2_B;
				end

				READ_ACK2_B: begin 
					if(op_mode == CPU_WREG) begin
						counter <= 7;
						saved_data = i_w_data;
						state <= WRITE_DATA;
					end
					else state <= STOP;
					// case(op_mode) 
					// 	CPU_WREG: begin
					// 		counter <= 7;
					// 		saved_data = i_w_data;
					// 		state <= WRITE_DATA;
					// 	end
					// 	CPU_RREG, CPU_RD_TEMP, CPU_RD_ACCL, HW_ALL, HW_ACC, HW_TEMP: state <= STOP;
					// endcase
				end

				STOP: begin
					case(op_mode) 
						CPU_WREG: begin
							sm_enable <= 0;
						end
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) CPU_SM <= CPU_SM_R_REG;
							else if(CPU_SM == CPU_SM_R_REG) begin
								CPU_SM <= CPU_SM_W_REG;
								sm_enable <= 0;
								o_ACCX <= {24'b0, reg_rd_data};
							end
						end
						CPU_RD_TEMP: begin
							if(CPU_SM == CPU_SM_W_REG) CPU_SM <= CPU_SM_R_TEMP;
							else if(CPU_SM == CPU_SM_R_TEMP) begin
								CPU_SM <= CPU_SM_W_REG;
								sm_enable <= 0;
								o_TEMP <= {20'b0, reg_rd_data[3:0], reg_rd_data_2};
							end
						end
						CPU_RD_ACCL: begin
							if(CPU_SM == CPU_SM_W_REG) CPU_SM <= CPU_SM_R_ACCL;
							else if(CPU_SM == CPU_SM_R_ACCL) begin
								CPU_SM <= CPU_SM_W_REG;
								sm_enable <= 0;
								o_ACCX <= {{12{reg_rd_data[7]}}, reg_rd_data, reg_rd_data_2, reg_rd_data_3[7:4]};
								o_ACCY <= {{12{reg_rd_data_4[7]}}, reg_rd_data_4, reg_rd_data_5, reg_rd_data_6[7:4]};
								o_ACCZ <= {{12{reg_rd_data_7[7]}}, reg_rd_data_7, reg_rd_data_8, reg_rd_data_9[7:4]};
							end
						end
						HW_ALL: begin
							if(HW_SM == HW_SM_W_REG_TEMP) HW_SM <= HW_SM_R_TEMP;
							else if(HW_SM == HW_SM_R_TEMP) HW_SM <= HW_SM_W_REG_ACC;
							else if(HW_SM == HW_SM_W_REG_ACC) HW_SM <= HW_SM_R_ACC;
							else if(HW_SM == HW_SM_R_ACC) begin
								HW_SM <= HW_SM_W_REG_TEMP;
								sm_enable <= 0;
								o_TEMP <= {20'b0, reg_rd_data[3:0], reg_rd_data_2};
								o_ACCX <= {{12{reg_rd_data_3[7]}}, reg_rd_data_3, reg_rd_data_4, reg_rd_data_5[7:4]};
								o_ACCY <= {{12{reg_rd_data_6[7]}}, reg_rd_data_6, reg_rd_data_7, reg_rd_data_8[7:4]};
								o_ACCZ <= {{12{reg_rd_data_9[7]}}, reg_rd_data_9, reg_rd_data_10, reg_rd_data_11[7:4]};	
							end
						end
						HW_TEMP: begin
							if(HW_SM == HW_SM_W_REG_TEMP) HW_SM <= HW_SM_R_TEMP;
							else if(HW_SM == HW_SM_R_TEMP) begin
								HW_SM <= HW_SM_W_REG_TEMP;
								sm_enable <= 0;
								o_TEMP <= {20'b0, reg_rd_data[3:0], reg_rd_data_2};
							end
						end
						HW_ACC: begin
							if(HW_SM == HW_SM_W_REG_ACC) HW_SM <= HW_SM_R_ACC;
							else if(HW_SM == HW_SM_R_ACC) begin
								HW_SM <= HW_SM_W_REG_ACC;
								sm_enable <= 0;
								o_ACCX <= {{12{reg_rd_data[7]}}, reg_rd_data, reg_rd_data_2, reg_rd_data_3[7:4]};
								o_ACCY <= {{12{reg_rd_data_4[7]}}, reg_rd_data_4, reg_rd_data_5, reg_rd_data_6[7:4]};
								o_ACCZ <= {{12{reg_rd_data_7[7]}}, reg_rd_data_7, reg_rd_data_8, reg_rd_data_9[7:4]};
							end
						end
					endcase
					state <= STOP2;	
					// o_TEMP <= {20'b0, reg_rd_data[3:0], reg_rd_data_2};
								
				end

				STOP2: begin
					state <= IDLE;
					finish <= 0;
				end

				NOP1: begin
					state <= IDLE;
				end

				WRITE_DATA: begin 
					if(counter == 0) begin
						state <= READ_ACK3;
					end else begin
						counter <= counter - 1;
					end
				end

				READ_ACK3: begin 
					state <= READ_ACK3_B;
				end

				READ_ACK3_B: begin 
					finish <= 1;
					state <= STOP;
				end

				READ_DATA: begin
					reg_rd_data[counter] <= i2c_sda;

					if (counter == 0) state <= WRITE_ACK;
					else begin
						counter <= counter - 1;
					end
				end
				
				WRITE_ACK: begin//12
					if(op_mode == CPU_RREG) begin
						finish <= 1;
						state <= STOP;
					end
					else begin
						counter <= 7;
						state <= READ_DATA2;
					end
					// case(op_mode) 
					// 	CPU_RREG: begin
					// 		finish <= 1;
					// 		state <= STOP;
					// 	end
					// 	CPU_RD_TEMP, CPU_RD_ACCL, HW_ALL: begin
					// 		counter <= 7;
					// 		state <= READ_DATA2;
					// 	end
					// endcase
				end

				READ_DATA2: begin
					reg_rd_data_2[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK2;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK2: begin
					if(op_mode == CPU_RD_TEMP) begin
						finish <= 1;
						state <= STOP;
					end
					else begin
						counter <= 7;
						state <= READ_DATA3;
					end
				end

				READ_DATA3: begin
					reg_rd_data_3[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK3;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK3: begin
					counter <= 7;
					state <= READ_DATA4;
				end

				READ_DATA4: begin
					reg_rd_data_4[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK4;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK4: begin
					counter <= 7;
					state <= READ_DATA5;
				end

				READ_DATA5: begin
					reg_rd_data_5[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK5;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK5: begin
					counter <= 7;
					state <= READ_DATA6;
				end

				READ_DATA6: begin
					reg_rd_data_6[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK6;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK6: begin
					counter <= 7;
					state <= READ_DATA7;
				end

				READ_DATA7: begin
					reg_rd_data_7[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK7;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK7: begin
					counter <= 7;
					state <= READ_DATA8;
				end

				READ_DATA8: begin
					reg_rd_data_8[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK8;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK8: begin
					counter <= 7;
					state <= READ_DATA9;
				end

				READ_DATA9: begin
					reg_rd_data_9[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK9;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK9: begin
					// counter <= 7;
					// state <= READ_DATA10;
					state <= STOP;
					finish <= 1;
				end

				READ_DATA10: begin
					reg_rd_data_10[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK10;
					else begin
						counter <= counter - 1;
					end
				end

				WRITE_ACK10: begin
					counter <= 7;
					state <= READ_DATA11;
				end

				READ_DATA11: begin
					reg_rd_data_11[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK11;
					else begin
						counter <= counter - 1;
					end
				end

				WRITE_ACK11: begin
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

				REG_ADDR: begin //write reg addr
					sda_out <= saved_data[counter];
				end
				
				WRITE_DATA: begin //write reg value
					sda_out <= saved_data[counter];
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
				WRITE_ACK5: begin
					sda_out <= 0;
				end
				WRITE_ACK6: begin
					sda_out <= 0;
				end
				WRITE_ACK7: begin
					sda_out <= 0;
				end
				WRITE_ACK8: begin
					sda_out <= 0;
				end
				WRITE_ACK9: begin
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
				READ_DATA5: begin
					sda_out <= 1;			
				end
				READ_DATA6: begin
					sda_out <= 1;		
				end
				READ_DATA7: begin
					sda_out <= 1;			
				end
				READ_DATA8: begin
					sda_out <= 1;			
				end
				READ_DATA9: begin
					sda_out <= 1;				
				end
				STOP: begin
					sda_out <= 0;
				end
				STOP2: begin
					sda_out <= 1;
				end

				default:;
			endcase
		end
	end

endmodule