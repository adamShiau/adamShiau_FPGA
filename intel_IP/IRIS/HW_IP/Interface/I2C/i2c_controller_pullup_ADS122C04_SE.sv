module i2c_controller_pullup_ADS122C04_SE
(
	input wire 			i_clk,
	input wire 			i_rst_n,
	input wire [6:0] 	i_dev_addr,
	input wire [7:0] 	i_w_data,
	input wire [7:0] 	i_reg_addr,
	input wire [31:0]	i_ctrl,
	input wire 			i_drdy,
	input wire 			i_sync,

	output reg signed [32-1:0] 	o_AIN0,
	output reg signed [32-1:0] 	o_AIN1,
	output reg signed [32-1:0] 	o_AIN2,
	output reg signed [32-1:0] 	o_AIN3,


	output wire [31:0] 	o_status,
	output wire [31:0] 	o_cnt,
	output wire 		o_w_enable,
	output wire			i2c_clk_out,
	inout				i2c_scl,
	inout 				i2c_sda
);

	/*** regidter definition***/
	localparam ADXL355_DEV_ADDR  	= 7'h1D;
	localparam REG_ADXL355_TEMP2 	= 8'h06;
	localparam REG_ADXL355_TXDATA3 	= 8'h08;

	/*** I2C Clock rate definition for 50MHz input clock ***/
	localparam CLK_390K 	= 	7;
	localparam CLK_781K 	= 	6;
	localparam CLK_1562K 	= 	5;
	localparam CLK_3125K 	= 	4;

	/*** op mode definition ***/
	localparam CPU_WREG	= 	3'd0;
	localparam CPU_RREG = 	3'd1;
	localparam HW 		= 	3'd2;

	/*** WREG definition    ***/
	localparam WREG_CONFIG_0 = 8'b0100_0000;
	localparam WREG_CONFIG_1 = 8'b0100_0100;
	localparam WREG_CONFIG_2 = 8'b0100_1000;
	localparam WREG_CONFIG_3 = 8'b0100_1100;

	/*** CMD definition    ***/
	localparam CMD_START = 8'b0000_1000;
	localparam CMD_RDATA = 8'b0001_0000;

	/*** Ain MUX Configuration    ***/
	localparam MUX_AIN0 = 8'b1000_0001;
	localparam MUX_AIN1 = 8'b1001_0001;
	localparam MUX_AIN2 = 8'b1010_0001;
	localparam MUX_AIN3 = 8'b1011_0001;

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
	reg rw = 0;
	reg r_drdy = 0;
	reg [2:0] reg_clock_rate = 6;

	wire i_enable, finish_ack;
	wire [2:0] op_mode;
	wire [2:0] clk_rate;
	reg sm_enable;
	reg [31:0] cnt_HW;

	wire w_en1, write_enable;
	reg w_en2 = 0;

	// assign w_en1 = (sda_out==1)? 0:1 ;
	assign w_en1 = ~sda_out;
	assign write_enable = w_en1 | w_en2;

	/******* control register********/
	assign i_enable = i_ctrl[0];
	assign op_mode = i_ctrl[3:1];
	assign clk_rate = i_ctrl[6:4];

	/******* status register********/
	assign o_status[0] = ((i_rst_n == 1) && (state == IDLE) && (write_done == 0)) ? 1 : 0; //ready
	assign o_status[1] = finish; //finish 
	assign o_status[9:2] = state;  
	assign o_status[10]  = sm_enable;
	assign o_status[11]  = CPU_SM;
	assign o_status[14:12]  = HW_SM;
	assign o_status[16:15]  = AIN_SM;
	assign o_cnt = cnt_HW;


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

// rising edge detection

reg i_sync_d, r_sync;

always @(posedge i2c_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		i_sync_d <= 0;
		r_sync   <= 0;
	end else begin
		i_sync_d <= i_sync;  // 記錄前一個時鐘的 i_sync
		r_sync   <= i_sync & ~i_sync_d;  // 產生 1-clock 寬度脈衝
	end
end

// State machine states
typedef enum logic {
	CPU_SM_W_REG = 1'b0,
	CPU_SM_READ  = 1'b1
} CPU_SM_t;

typedef enum logic [2:0] {
	HW_SM_W_REG_MUX 	= 3'd0,
	HW_SM_W_START_CMD   = 3'd1,
	HW_SM_WAIT_DRDY     = 3'd2,
	HW_SM_W_REG_RDATA   = 3'd3,
	HW_SM_READ_ADC	    = 3'd4
} HW_SM_t;

typedef enum logic [1:0] {
	AIN_SM_AIN0 = 2'd0,
	AIN_SM_AIN1 = 2'd1,
	AIN_SM_AIN2 = 2'd2,
	AIN_SM_AIN3 = 2'd3
} AIN_SM_t;

CPU_SM_t CPU_SM;
HW_SM_t  HW_SM;
AIN_SM_t AIN_SM;

/*** SM update**/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			write_done <= 1'b0;
			rw <= 1'b0;
			reg_rd_data <= 0;reg_rd_data_2 <= 0;reg_rd_data_3 <= 0;
			reg_rd_data_4 <= 0;reg_rd_data_5 <= 0;reg_rd_data_6 <= 0;
			reg_rd_data_7 <= 0;reg_rd_data_8 <= 0;reg_rd_data_9 <= 0;
			reg_rd_data_10 <= 0;reg_rd_data_11 <= 0;
			o_AIN0 <= 0; o_AIN1 <= 0; o_AIN2 <= 0; o_AIN3 <= 0;
			sm_enable <= 0; 
			saved_data <= 0;
			finish <= 0;
			cnt_HW <= 0;
			/***  SM initialization  ***/
			CPU_SM <= CPU_SM_W_REG;
			HW_SM <= HW_SM_W_REG_MUX;
			AIN_SM <= AIN_SM_AIN0;
		end		
		else begin
			case(state)
				IDLE: begin // 根據op_mode模式來啟動狀態機

					case (op_mode)
						CPU_WREG, CPU_RREG: if(i_enable) sm_enable <= 1; 
						HW: begin
							if(HW_SM == HW_SM_WAIT_DRDY) begin
								if(i_drdy == 1'b0) begin 
									HW_SM <= HW_SM_W_REG_RDATA;
									sm_enable <= 1;
									cnt_HW <= 32'd0;
								end
								else begin
									sm_enable <= 0;
									cnt_HW <= cnt_HW + 1'b1;
								end
							end
							else sm_enable <= 1;
						end
					endcase

					if (sm_enable) state <= START;
					else state <= IDLE;
				end

				START: begin
					counter <= 7; // Initialize counter to 7 in this state, as it will be used as an index in the next state.

					case (op_mode)
						CPU_WREG: begin
							saved_addr <= {i_dev_addr, 1'b0};
						end
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) saved_addr <= {i_dev_addr, 1'b0};
							else if(CPU_SM == CPU_SM_READ) saved_addr <= {i_dev_addr, 1'b1};
						end
						HW: begin
							if(HW_SM == HW_SM_READ_ADC) saved_addr <= {i_dev_addr, 1'b1};
							else saved_addr <= {i_dev_addr, 1'b0};
							// if (HW_SM == HW_SM_W_REG_MUX || HW_SM == W_START_CMD || HW_SM == W_REG_RDATA) begin
							// 	saved_addr <= {i_dev_addr, 1'b0};
							// end 
							// else if (HW_SM == READ_ADC) begin
							// 	saved_addr <= {i_dev_addr, 1'b1};
							// end
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

					case (op_mode)
						CPU_WREG: begin
							saved_data <= i_reg_addr;
							state <= REG_ADDR;
						end
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) begin
								saved_data <= i_reg_addr;
								state <= REG_ADDR;
							end
							else if(CPU_SM == CPU_SM_READ) state <= READ_DATA;
						end
						HW: begin 
							case(HW_SM)
								HW_SM_W_REG_MUX: begin 
									saved_data <= WREG_CONFIG_0;
									state <= REG_ADDR;
								end
								HW_SM_W_START_CMD: begin
									saved_data <= CMD_START; 
									state <= REG_ADDR;
								end
								HW_SM_W_REG_RDATA: begin
									saved_data <= CMD_RDATA; 
									state <= REG_ADDR;
								end
								HW_SM_READ_ADC: state <= READ_DATA;
								// HW_SM_WAIT_DRDY: state <= READ_ACK_B;
							endcase
						end
					endcase
				end

				REG_ADDR: begin 
					if (counter == 0) begin 
						state <= READ_ACK2;
					end else begin
						counter <= counter - 1;
					end
				end

				READ_ACK2: begin 
					state <= READ_ACK2_B;
				end

				READ_ACK2_B: begin 

					case (op_mode)
						CPU_WREG: begin
							counter <= 7;
							saved_data <= i_w_data;
							state <= WRITE_DATA;
						end
						CPU_RREG: state <= STOP;	
						HW: begin
							if(HW_SM == HW_SM_W_START_CMD || HW_SM == HW_SM_W_REG_RDATA) state <= STOP;	
							else if(HW_SM == HW_SM_W_REG_MUX) begin
								case(AIN_SM)
									AIN_SM_AIN0: saved_data <= MUX_AIN0; 
									AIN_SM_AIN1: saved_data <= MUX_AIN1; 
									AIN_SM_AIN2: saved_data <= MUX_AIN2; 
									AIN_SM_AIN3: saved_data <= MUX_AIN3; 
								endcase
								counter <= 7;
								state <= WRITE_DATA;
							end
						end
						default: begin
							 state <= STOP;
						end
					endcase
				end

				STOP: begin
					case (op_mode)
						CPU_WREG: sm_enable <= 0;
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) CPU_SM <= CPU_SM_READ;
							else if(CPU_SM == CPU_SM_READ) begin
								CPU_SM <= CPU_SM_W_REG;
								sm_enable <= 0;
								o_AIN0 <= {24'b0, reg_rd_data};
							end
						end
						HW: begin
							case(HW_SM)
								HW_SM_W_REG_MUX: HW_SM <= HW_SM_W_START_CMD; 
								HW_SM_W_START_CMD: begin
									HW_SM <= HW_SM_WAIT_DRDY;
									sm_enable <= 0;
								end
								// HW_SM_WAIT_DRDY: HW_SM <= HW_SM_W_REG_RDATA; 
								HW_SM_W_REG_RDATA: HW_SM <= HW_SM_READ_ADC;
								HW_SM_READ_ADC: begin
									HW_SM <= HW_SM_W_REG_MUX;
									case(AIN_SM)
										AIN_SM_AIN0: begin 
											o_AIN0 <= {12'b0, reg_rd_data, reg_rd_data_2, reg_rd_data_3};
											AIN_SM <= AIN_SM_AIN1;
										end
										AIN_SM_AIN1: begin 
											o_AIN1 <= {12'b0, reg_rd_data, reg_rd_data_2, reg_rd_data_3};
											AIN_SM <= AIN_SM_AIN2;
										end
										AIN_SM_AIN2: begin
											o_AIN2 <= {12'b0, reg_rd_data, reg_rd_data_2, reg_rd_data_3}; 
											AIN_SM <= AIN_SM_AIN3;
										end
										AIN_SM_AIN3: begin 
											o_AIN3 <= {12'b0, reg_rd_data, reg_rd_data_2, reg_rd_data_3};
											AIN_SM <= AIN_SM_AIN0;
										end
									endcase
								end
							endcase
						end
						default: state <= STOP;
					endcase

					state <= STOP2;
	
					
					// o_AIN1 <= {{12{reg_rd_data_4[7]}}, reg_rd_data_4, reg_rd_data_5, reg_rd_data_6[7:4]};
					// o_AIN2 <= {{12{reg_rd_data_7[7]}}, reg_rd_data_7, reg_rd_data_8, reg_rd_data_9[7:4]};
					// o_AIN3 <= {20'b0, reg_rd_data_10[3:0], reg_rd_data_11};
					
				end

				STOP2: begin
					state <= IDLE;
					finish <= 0;
				end

				NOP1: begin
					state <= IDLE;
				end

				WRITE_DATA: begin 
					if (counter == 0) begin 
						state <= READ_ACK3;
					end else begin
						counter <= counter - 1;
					end
				end

				READ_DATA: begin//11					
					reg_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin//12
					case (op_mode)
						CPU_RREG: begin
							finish <= 1;
							state <= STOP;
						end
						HW: begin
							counter <= 7;
							state <= READ_DATA2;
						end
					endcase
				end

				READ_DATA2: begin
					reg_rd_data_2[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK2;
					else counter <= counter - 1;
				end
				WRITE_ACK2: begin
					counter <= 7;
					state <= READ_DATA3;
				end

				READ_DATA3: begin
					reg_rd_data_3[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK3;
					else counter <= counter - 1;
				end
				WRITE_ACK3: begin
					finish <= 1;
					state <= STOP;
					// counter <= 7;
					// state <= READ_DATA4;
				end

				READ_DATA4: begin
					reg_rd_data_4[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK4;
					else counter <= counter - 1;
				end
				WRITE_ACK4: begin
					counter <= 7;
					state <= READ_DATA5;
				end

				READ_DATA5: begin
					reg_rd_data_5[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK5;
					else counter <= counter - 1;
				end
				WRITE_ACK5: begin
					counter <= 7;
					state <= READ_DATA6;
				end

				READ_DATA6: begin
					reg_rd_data_6[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK6;
					else counter <= counter - 1;
				end
				WRITE_ACK6: begin
					counter <= 7;
					state <= READ_DATA7;
				end

				READ_DATA7: begin
					reg_rd_data_7[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK7;
					else counter <= counter - 1;
				end
				WRITE_ACK7: begin
					counter <= 7;
					state <= READ_DATA8;
				end

				READ_DATA8: begin
					reg_rd_data_8[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK8;
					else counter <= counter - 1;
				end
				WRITE_ACK8: begin
					counter <= 7;
					state <= READ_DATA9;
				end

				READ_DATA9: begin
					reg_rd_data_9[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK9;
					else counter <= counter - 1;
				end
				WRITE_ACK9: begin
					// finish <= 1;
					state <= STOP;
				end

				READ_DATA10: begin
					reg_rd_data_10[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK10;
					else counter <= counter - 1;
				end

				WRITE_ACK10: begin
					counter <= 7;
					state <= READ_DATA11;
				end

				READ_DATA11: begin
					reg_rd_data_11[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK11;
					else counter <= counter - 1;
				end

				WRITE_ACK11: begin
					finish <= 1;
					state <= STOP;
				end

				READ_ACK3: begin 
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
				WRITE_ACK10: begin
					sda_out <= 0;
				end
				WRITE_ACK11: begin
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
				READ_DATA10: begin
					sda_out <= 1;				
				end
				READ_DATA11: begin
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