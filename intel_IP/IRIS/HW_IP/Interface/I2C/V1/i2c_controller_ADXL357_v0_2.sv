/*** 
 1. test 沒有pull up 的 eeprom 版本
 2. 改寫READ_ACK 後 加入等待1 CLK 邏輯 
 ***/
module i2c_controller_ADXL357_v0_2(
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
	inout				i2c_scl,
	inout 				i2c_sda
);

	/*** register definition***/
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
	localparam HW 				= 	3'd4;


	/*** state machine definition ***/
	localparam IDLE 		= 	0;
	localparam START 		= 	1;
	localparam ADDRESS 		= 	2;
	localparam READ_ACK 	= 	3;
	localparam REG_ADDR  	= 	4;
	localparam READ_ACK2 	= 	5;
	localparam WRITE_DATA 	= 	6;
	localparam READ_ACK3 	= 	7;
	localparam READ_DATA 	= 	8;
	localparam WRITE_ACK 	= 	9;
	localparam READ_DATA2 	= 	10;
	localparam WRITE_ACK2 	= 	11;
	localparam READ_DATA3 	= 	12;
	localparam WRITE_ACK3 	= 	13;
	localparam READ_DATA4 	= 	14;
	localparam WRITE_ACK4 	= 	15;
	localparam READ_DATA5 	= 	16;
	localparam WRITE_ACK5 	= 	17;
	localparam READ_DATA6 	= 	18;
	localparam WRITE_ACK6 	= 	19;
	localparam READ_DATA7 	= 	20;
	localparam WRITE_ACK7 	= 	21;
	localparam READ_DATA8 	= 	22;
	localparam WRITE_ACK8 	= 	23;
	localparam READ_DATA9 	= 	24;
	localparam WRITE_ACK9 	= 	25;
	localparam READ_DATA10 	= 	26;
	localparam WRITE_ACK10 	= 	27;
	localparam READ_DATA11 	= 	28;
	localparam WRITE_ACK11 	= 	29;
	localparam SLOW 		= 	30;
	localparam STOP 		= 	31;

	/*** use to delay I2C READ_ACK one clock***/
	reg ack_checked_flag = 0;
	reg hold_scl = 0;


	/*** I2C read ack response***/
	localparam ACK  = 0;
	localparam NACK = 1;

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

	reg r_drdy = 0;
	/******* control register assignment ********/
	wire i_enable;
	wire [2:0] op_mode;
	wire [2:0] clk_rate;

	assign i_enable = i_ctrl[0];
	assign op_mode = i_ctrl[3:1];
	assign clk_rate = i_ctrl[6:4];

	/******* status register assignment ********/
	reg finish = 0;
	reg [7:0] state;
	reg sm_enable;

	// assign o_status[0] = ((i_rst_n == 1) && (state == IDLE) && (write_done == 0)) ? 1 : 0; //ready
	assign o_status[1] = finish; //finish 
	assign o_status[9:2] = state;  
	assign o_status[10]  = sm_enable;
	assign o_status[13:11]  = HW_SM;
	assign o_status[16:14]  = CPU_SM;

	reg [7:0] saved_addr;
	reg [7:0] saved_data;
	reg [7:0] counter;
	reg write_enable;
	reg sda_out = 0;
	reg i2c_scl_enable = 0;
	reg i2c_clk = 1;


	// assign i2c_scl = (i2c_scl_enable == 0 ) ? 1 : i2c_clk;
	assign i2c_scl = (i2c_scl_enable == 0 || hold_scl == 1) ? 1 : i2c_clk;
	assign i2c_sda = (write_enable == 1) ? sda_out : 'bz;

	/******* CLK_VALUE depends on input clock frequency********/
	reg [2:0] reg_clock_rate = 6;

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

	reg	[8:0] CLK_COUNT = 0; 	//clock

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[6]:100000/2^(6+1)=781.25 kHz, CLK_COUNT[7+1]:390.625 KHz
		i2c_clk <= CLK_COUNT[reg_clock_rate];
	end

	/*** i2c_scl_enable logic **/
	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			i2c_scl_enable <= 0;
		end else begin
			case (state)
				IDLE, START, STOP: i2c_scl_enable <= 0;
				default: i2c_scl_enable <= 1;
			endcase
		end
	end

	// State machine states
	typedef enum logic [2:0] {
		HW_SM_W_REG_TEMP = 3'd0,
		HW_SM_R_ALL = 3'd1
	} state_t;

	typedef enum logic [2:0] {
		CPU_SM_W_REG = 3'd0,
		CPU_SM_R_REG = 3'd1,
		CPU_SM_R_TEMP = 3'd2,
		CPU_SM_R_ACCL = 3'd3
	} CPU_state_t;

	state_t HW_SM;
	CPU_state_t CPU_SM;


	reg i_drdy_sync1, i_drdy_sync2;
	always @(posedge i_clk or negedge i_rst_n) begin
		if (!i_rst_n) begin
			i_drdy_sync1 <= 1'b1;
			i_drdy_sync2 <= 1'b1;
		end
		else begin
			i_drdy_sync1 <= i_drdy;
			i_drdy_sync2 <= i_drdy_sync1;
		end
	end

/*** SM update**/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			finish <= 0;
			state <= IDLE;
			//initialize reg_rd_data and output register 
			reg_rd_data <= 0;reg_rd_data_2 <= 0;reg_rd_data_3 <= 0;
			reg_rd_data_4 <= 0;reg_rd_data_5 <= 0;reg_rd_data_6 <= 0;
			reg_rd_data_7 <= 0;reg_rd_data_8 <= 0;reg_rd_data_9 <= 0;
			reg_rd_data_10 <= 0;reg_rd_data_11 <= 0;
			o_ACCX <= 0; o_ACCY <= 0; o_ACCZ <= 0; o_TEMP <= 0;

			sm_enable <= 0; 
			saved_data <= 0;
			
			CPU_SM <= CPU_SM_W_REG;
			HW_SM <= HW_SM_W_REG_TEMP;
		end		
		else begin

			case(state)
				IDLE: begin
					case(op_mode) 
						CPU_WREG, CPU_RREG, CPU_RD_TEMP, CPU_RD_ACCL: begin
							if(i_enable) sm_enable <= 1; 
						end
						HW: begin
							if(i_drdy_sync2) sm_enable <= 1; 
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
						HW: begin
							if(HW_SM == HW_SM_W_REG_TEMP) saved_addr <= {ADXL355_DEV_ADDR, 1'b0};
							else if(HW_SM == HW_SM_R_ALL) saved_addr <= {ADXL355_DEV_ADDR, 1'b1};
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
					if(!ack_checked_flag) begin
						if (i2c_sda == ACK) begin
							ack_checked_flag <= 1;  // 第一次檢查過 ACK，準備延遲
							hold_scl <= 1; // 停住 SCL 延遲一拍
							state <= READ_ACK;      // 延遲一拍（stay）
						end else begin
							state <= SLOW;  // 讀到 NACK
						end

					end
					else begin
						ack_checked_flag <= 0;  // reset flag，準備下一輪用
						hold_scl <= 0; // 恢復 SCL

						counter <= 7;
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
								else if(CPU_SM == CPU_SM_R_ACCL) state <= READ_DATA3;
							end
							HW: begin
								if(HW_SM == HW_SM_W_REG_TEMP) begin
									saved_data <= REG_ADXL355_TEMP2;
									state <= REG_ADDR;
								end
								else if(HW_SM == HW_SM_R_ALL) state <= READ_DATA;
							end
						endcase
					end
				end

				REG_ADDR: begin 
					if(counter == 0) begin
						state <= READ_ACK2;
					end else begin 
						counter <= counter - 1;
					end
				end

				READ_ACK2: begin 

					if(!ack_checked_flag) begin
						ack_checked_flag <= 1;  // 第一次檢查過 ACK，準備延遲
						hold_scl <= 1; // 停住 SCL 延遲一拍
						state <= READ_ACK2;      // 延遲一拍（stay）
					end
					else begin
						ack_checked_flag <= 0;  // reset flag，準備下一輪用
						hold_scl <= 0; // 恢復 SCL

						if(op_mode == CPU_WREG) begin
							counter <= 7;
							saved_data = i_w_data;
							state <= WRITE_DATA;
						end
						else state <= SLOW;
					end					
				end

				WRITE_DATA: begin 
					if(counter == 0) begin
						state <= READ_ACK3;
					end else begin
						counter <= counter - 1;
					end
				end

				READ_ACK3: begin 

					if(!ack_checked_flag) begin
						ack_checked_flag <= 1;  // 第一次檢查過 ACK，準備延遲
						hold_scl <= 1; // 停住 SCL 延遲一拍
						state <= READ_ACK3;      // 延遲一拍（stay）
					end
					else begin
						ack_checked_flag <= 0;  // reset flag，準備下一輪用
						hold_scl <= 0; // 恢復 SCL

						finish <= 1;
						state <= SLOW;
					end	
				end

				SLOW: begin
					state <= STOP;
				end

				STOP: begin
					finish <= 0;
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
								o_ACCX <= {{12{reg_rd_data_3[7]}}, reg_rd_data_3, reg_rd_data_4, reg_rd_data_5[7:4]};
								o_ACCY <= {{12{reg_rd_data_6[7]}}, reg_rd_data_6, reg_rd_data_7, reg_rd_data_8[7:4]};
								o_ACCZ <= {{12{reg_rd_data_9[7]}}, reg_rd_data_9, reg_rd_data_10, reg_rd_data_11[7:4]};
							end
						end
						HW: begin
							if(HW_SM == HW_SM_W_REG_TEMP) HW_SM <= HW_SM_R_ALL;
							else if(HW_SM == HW_SM_R_ALL) begin
								HW_SM <= HW_SM_W_REG_TEMP;
								sm_enable <= 0;
								o_TEMP <= {20'b0, reg_rd_data[3:0], reg_rd_data_2};
								o_ACCX <= {{12{reg_rd_data_3[7]}}, reg_rd_data_3, reg_rd_data_4, reg_rd_data_5[7:4]};
								o_ACCY <= {{12{reg_rd_data_6[7]}}, reg_rd_data_6, reg_rd_data_7, reg_rd_data_8[7:4]};
								o_ACCZ <= {{12{reg_rd_data_9[7]}}, reg_rd_data_9, reg_rd_data_10, reg_rd_data_11[7:4]};
							end
						end
					endcase
					state <= IDLE;				
				end

				READ_DATA: begin
					reg_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else begin
						counter <= counter - 1;
					end
				end
				
				WRITE_ACK: begin
					if(op_mode == CPU_RREG) begin
						finish <= 1;
						state <= SLOW;
					end
					else begin
						counter <= 7;
						state <= READ_DATA2;
					end
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
					else begin //HW mode
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
					counter <= 7;
					state <= READ_DATA10;
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
					state <= SLOW;
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
			write_enable <= 0;
		end else begin
			case(state)

				IDLE: begin
					write_enable <= 0;
				end
				
				START: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				ADDRESS: begin
					write_enable <= 1;
					sda_out <= saved_addr[counter];
				end
				
				READ_ACK, READ_ACK2, READ_ACK3: begin
					write_enable <= 0;
				end

				REG_ADDR: begin //write reg addr
					write_enable <= 1;
					sda_out <= saved_data[counter];
				end
				
				WRITE_DATA: begin //write reg value
					write_enable <= 1;
					sda_out <= saved_data[counter];
				end
				WRITE_ACK, WRITE_ACK2, WRITE_ACK3, WRITE_ACK4, WRITE_ACK5, WRITE_ACK6, WRITE_ACK7, WRITE_ACK8, WRITE_ACK9, WRITE_ACK10, WRITE_ACK11: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				
				READ_DATA, READ_DATA2, READ_DATA3, READ_DATA4, READ_DATA5, READ_DATA6, READ_DATA7, READ_DATA8, READ_DATA9, READ_DATA10, READ_DATA11: begin
					write_enable <= 0;	
					sda_out <= 0;			
				end

				SLOW: begin
					write_enable <= 1;
					sda_out <= 0;
				end
				
				STOP: begin
					write_enable <= 0;
					// write_enable <= 1;
					// sda_out <= 1;
				end
			endcase
		end
	end

endmodule