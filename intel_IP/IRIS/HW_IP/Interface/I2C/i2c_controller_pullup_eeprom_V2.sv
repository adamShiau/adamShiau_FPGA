/*** 
07-12-2025
調整OP_MODE，更改為新版寫法
***/
module i2c_controller_pullup_eeprom_V2
(
	input wire 				i_clk,
	input wire 				i_rst_n,
	input wire [6:0] 		i_dev_addr,
	input wire [32-1:0] 	i_w_data,
	input wire [16-1:0] 	i_reg_addr,
	input wire [31:0]		i_ctrl,
	input wire 				i_drdy,

	output reg [7:0] 		o_rd_data,
	output reg [7:0] 		o_rd_data_2,
	output reg [7:0] 		o_rd_data_3,
	output reg [7:0] 		o_rd_data_4,


	output wire [31:0] 		o_status,
	inout					i2c_scl,
	inout 					i2c_sda
	);

	/*** I2C Clock rate definition for 100MHz input clock ***/
	localparam CLK_390K 	= 	7;
	localparam CLK_781K 	= 	6;
	localparam CLK_1562K 	= 	5;
	localparam CLK_3125K 	= 	4;

	/*** op mode definition ***/
	localparam CPU_WREG	= 	3'd0;
	localparam CPU_RREG = 	3'd1;
	localparam HW 		= 	3'd2;

	// internal state machine states define
	typedef enum logic {
		CPU_SM_W_REG = 1'b0,
		CPU_SM_READ  = 1'b1
	} CPU_SM_t;

	CPU_SM_t CPU_SM;

	/*** I2C read ack response***/
	localparam ACK  = 0;
	localparam NACK = 1;

	/*** state machine definition ***/
	localparam IDLE 		= 	0;
	localparam START 		= 	1;
	localparam ADDRESS 		= 	2;
	localparam READ_ACK 	= 	3;
	localparam READ_ACK_B 	= 	4;
	// localparam REG_ADDR  	= 	5;
	localparam REG_HBYTE  	= 	5;
	localparam READ_ACK2 	= 	6;
	localparam READ_ACK2_B 	= 	7;
	// localparam REG_ADDR2  	= 	8;
	localparam REG_LBYTE  	= 	8;
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

	reg [7:0] 		reg_rd_data, reg_rd_data_2, reg_rd_data_3, reg_rd_data_4;
	/******* finish strobe & reesponse ********/
	reg finish = 0;
	reg wait_finish_flag = 0;
	reg prev_clear;
	wire clear_pulse;

	/******* control register assignment ********/
	wire i_enable;
	wire [2:0] op_mode;
	wire [2:0] clk_rate;

	assign i_enable = i_ctrl[0];
	assign op_mode = i_ctrl[3:1];
	assign clk_rate = i_ctrl[6:4];
	assign clear_pulse = (i_ctrl[7] == 1'b1) && (prev_clear == 1'b0); // up edge detect

	/******* status register assignment ********/
	// assign o_status[0] = ((i_rst_n == 1) && (state == IDLE) && (write_done == 0)) ? 1 : 0; //ready
	assign o_status[1] 	 = finish; 
	assign o_status[9:2] = state;  
	assign o_status[10]  = sm_enable;
	assign o_status[11]  = CPU_SM;

	reg [7:0] state;
	reg sm_enable;

	reg [7:0] saved_addr;
	reg [7:0] saved_data;
	reg [7:0] saved_regaddr_H, saved_regaddr_L;
	reg [7:0] saved_write_3, saved_write_2, saved_write_1, saved_write_0;
	reg [7:0] counter;
	reg sda_out = 0;
	reg [1:0] i2c_scl_enable = 0;
	reg i2c_scl_enable2 = 0;
	reg i2c_clk = 1;
	reg clk_2x = 1;
	reg	[8:0] CLK_COUNT = 0;
	reg [2:0] reg_clock_rate = 6;

	wire w_en1, write_enable;
	reg w_en2 = 0;

	// assign w_en1 = (sda_out==1)? 0:1 ;
	assign w_en1 = ~sda_out;
	assign write_enable = w_en1 | w_en2;


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
			case(state)
				READ_ACK_B, READ_ACK2_B, READ_ACK3_B, READ_ACK4_B, READ_ACK5_B, READ_ACK6_B, READ_ACK7_B: i2c_scl_enable <= 0;
				IDLE, START, STOP, STOP2: i2c_scl_enable <= 1;
				default: i2c_scl_enable <= 2;
			endcase
		end
	end

	/** Control logic for 'finish': set in STOP state, cleared on i_ctrl[7] rising edge **/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if (!i_rst_n) begin
			finish <= 0;
			prev_clear <= 0;
		end 
		else begin
			prev_clear <= i_ctrl[7];

			case(state)

				STOP: begin
					if(wait_finish_flag) finish <= 1;
				end
				default: begin
					if (clear_pulse) finish <= 0;
				end

			endcase
		end
	end
	
	/*** 
	1. For the states need to WRITE operation, let w_en2 = 1, otherwise w_en2 = 0
	2. clk_2x is used here to ensure write_enable is asserted earlier before the write state
	***/
	always @(posedge clk_2x or negedge i_rst_n) begin
		if(!i_rst_n) begin
			w_en2 <= 0;
		end 
		else begin
			case(state)
				START: w_en2 <= 1;	
				ADDRESS: begin
					if(saved_addr[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				REG_HBYTE: begin
					if(saved_regaddr_H[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				REG_LBYTE: begin
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
				WRITE_ACK: w_en2 <= 1;
				WRITE_ACK2: w_en2 <= 1;
				WRITE_ACK3: w_en2 <= 1;
				WRITE_ACK4: w_en2 <= 1;
				STOP: w_en2 <= 1;
				default: w_en2 <= 0;
			endcase
		end
	end

	/*** SM update**/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			wait_finish_flag <= 0;
			reg_rd_data <= 0;
			reg_rd_data_2 <= 0;	
			reg_rd_data_3 <= 0;
			reg_rd_data_4 <= 0;
			sm_enable <= 0;
			CPU_SM <= CPU_SM_W_REG;
		end		
		else begin
			case(state)
				IDLE: begin
					wait_finish_flag <= 0;
					case(op_mode) 
						CPU_WREG, CPU_RREG: if(i_enable) sm_enable <= 1; 
						default: state <= IDLE;
					endcase

					if (sm_enable) begin
						state <= START;
					end
					else state <= IDLE;
				end

				START: begin
					counter <= 7; // Initialize counter to 7 in this state, as it will be used as an index in the next state.

					case (op_mode)
						CPU_WREG: saved_addr <= {i_dev_addr, 1'b0};
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) saved_addr <= {i_dev_addr, 1'b0};
							else if(CPU_SM == CPU_SM_READ) saved_addr <= {i_dev_addr, 1'b1};
						end
					endcase

					state <= ADDRESS;
				end

				ADDRESS: begin
					if (counter == 0) begin 
						state <= READ_ACK;
					end 
					else counter <= counter - 1;
				end

				READ_ACK: begin
					if (i2c_sda == ACK) begin
						state <= READ_ACK_B;
					end 
					else state <= STOP;
				end

				READ_ACK_B: begin

					counter <= 7;

					case (op_mode)
						CPU_WREG: begin
							saved_regaddr_H <= i_reg_addr[15:8];
							saved_regaddr_L <= i_reg_addr[7:0];
							state <= REG_HBYTE;
						end
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) begin
								saved_regaddr_H <= i_reg_addr[15:8];
								saved_regaddr_L <= i_reg_addr[7:0];
								state <= REG_HBYTE;
							end
							else if(CPU_SM == CPU_SM_READ) state <= READ_DATA;
						end
					endcase

				end

				REG_HBYTE: begin 
					if (counter == 0) begin 	
						state <= READ_ACK2;
					end else counter <= counter - 1;
				end

				READ_ACK2: begin 
					state <= READ_ACK2_B;
				end

				READ_ACK2_B: begin 
					counter <= 7;
					state <= REG_LBYTE;
				end

				REG_LBYTE: begin 
					if (counter == 0) begin 
						state <= READ_ACK3;
					end else counter <= counter - 1;
				end

				READ_ACK3: begin 
					state <= READ_ACK3_B;
				end

				READ_ACK3_B: begin 

					case (op_mode)
						CPU_WREG: begin
							counter <= 7;
							saved_write_3 <=  i_w_data[31:24]; // MSB
							saved_write_2 <=  i_w_data[23:16];
							saved_write_1 <=  i_w_data[15:8];
							saved_write_0 <=  i_w_data[7:0]; //LSB
							state <= WRITE_DATA;
						end
						CPU_RREG: state <= STOP;
					endcase

				end

				// NOP1: begin
				// 	state <= STOP;
				// end

				WRITE_DATA: begin 
					if(counter == 0) begin
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
					wait_finish_flag <= 1;
					state <= STOP;
				end

				STOP: begin
					case(op_mode) 
						CPU_WREG: begin
							sm_enable <= 0;
						end
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) begin 
								CPU_SM <= CPU_SM_READ;
							end
							else if(CPU_SM == CPU_SM_READ) begin
								CPU_SM <= CPU_SM_W_REG;
								sm_enable <= 0;
								o_rd_data   <= reg_rd_data;
								o_rd_data_2 <= reg_rd_data_2;
								o_rd_data_3 <= reg_rd_data_3;
								o_rd_data_4 <= reg_rd_data_4;
							end
						end
					endcase
					state <= STOP2;
				end

				STOP2: begin
					state <= IDLE;
				end

				READ_DATA: begin

					reg_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;

					// o_rd_data[counter] <= i2c_sda;
					// if(write_done == 1'b1) write_done <= 1'b0;
					// o_rd_data[counter] <= i2c_sda;
					// if (counter == 0) state <= WRITE_ACK;
					// else counter <= counter - 1;
				end
				
				WRITE_ACK: begin//12
					counter <= 7;
					state <= READ_DATA2;
				end

				READ_DATA2: begin
					// o_rd_data_2[counter] <= i2c_sda;
					reg_rd_data_2[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK2;
					else counter <= counter - 1;
				end
				WRITE_ACK2: begin
					counter <= 7;
					state <= READ_DATA3;
				end

				READ_DATA3: begin
					// o_rd_data_3[counter] <= i2c_sda;
					reg_rd_data_3[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK3;
					else counter <= counter - 1;
				end
				WRITE_ACK3: begin
					counter <= 7;
					state <= READ_DATA4;
				end

				READ_DATA4: begin
					// o_rd_data_4[counter] <= i2c_sda;
					reg_rd_data_4[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK4;
					else counter <= counter - 1;
				end
				WRITE_ACK4: begin
					// counter <= 7;
					// state <= READ_DATA5;
					wait_finish_flag <= 1;
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
				
				READ_ACK, READ_ACK_B, READ_ACK2, READ_ACK2_B, READ_ACK3, READ_ACK3_B, READ_ACK4, 
				READ_ACK4_B, READ_ACK5, READ_ACK5_B, READ_ACK6, READ_ACK6_B, READ_ACK7, READ_ACK7: begin
					sda_out <= 1;
				end

				REG_HBYTE: begin 
					sda_out <= saved_regaddr_H[counter];
				end

				REG_LBYTE: begin 
					sda_out <= saved_regaddr_L[counter];
				end
				
				WRITE_DATA: begin 
					sda_out <= saved_write_3[counter];
				end

				WRITE_DATA2: begin 
					sda_out <= saved_write_2[counter];
				end

				WRITE_DATA3: begin 
					sda_out <= saved_write_1[counter];
				end

				WRITE_DATA4: begin 
					sda_out <= saved_write_0[counter];
				end

				WRITE_ACK, WRITE_ACK2, WRITE_ACK3, WRITE_ACK4: begin
					sda_out <= 0;
				end

				READ_DATA, READ_DATA2, READ_DATA3, READ_DATA4: begin
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