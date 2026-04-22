// test 沒有pull up 的 eeprom 版本
module i2c_controller_eeprom_v0(
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

	/*** state machine definition ***/
	localparam IDLE = 0;
	localparam START = 1;
	localparam ADDRESS = 2;
	localparam READ_ACK = 3;
	localparam REG_HBYTE = 4;
	localparam READ_ACK2 = 5;
	localparam REG_LBYTE = 6;
	localparam READ_ACK3 = 7;
	localparam WRITE_DATA = 8;
	localparam READ_ACK4 = 9;
	localparam WRITE_DATA2 = 10;
	localparam READ_ACK5 = 11;
	localparam WRITE_DATA3 = 12;
	localparam READ_ACK6 = 13;
	localparam WRITE_DATA4 = 14;
	localparam READ_ACK7 = 15;
	localparam READ_DATA = 16; 
	localparam WRITE_ACK = 17;
	localparam READ_DATA2 = 18;
	localparam WRITE_ACK2 = 19;
	localparam READ_DATA3 = 20;
	localparam WRITE_ACK3 = 21;
	localparam READ_DATA4 = 22;
	localparam WRITE_ACK4 = 23;
	localparam SLOW = 24;
	localparam STOP = 25;

	/*** I2C read ack response***/
	localparam ACK  = 0;
	localparam NACK = 1;
	
	
	/*** op mode definition ***/
	localparam CPU_WREG	= 	3'd0;
	localparam CPU_RREG = 	3'd1;

	// internal state machine states define
	typedef enum logic {
		CPU_SM_W_REG = 1'b0,
		CPU_SM_READ  = 1'b1
	} CPU_SM_t;

	CPU_SM_t CPU_SM;


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
	assign o_status[1] = finish; 
	assign o_status[9:2] = state;  
	assign o_status[10]  = sm_enable;
	assign o_status[11]  = CPU_SM;

	reg [7:0] saved_addr;
	// reg [7:0] saved_data;
	reg [7:0] saved_regaddr_H, saved_regaddr_L;
	reg [7:0] saved_write_3, saved_write_2, saved_write_1, saved_write_0;
	reg [7:0] counter;
	reg write_enable;
	reg sda_out;
	reg i2c_scl_enable = 0;
	reg i2c_clk = 1;
	

	// assign ready = ((i_rst_n == 0) && (state == IDLE)) ? 1 : 0;
	assign i2c_scl = (i2c_scl_enable == 0 ) ? 1 : i2c_clk;
	assign i2c_sda = (write_enable == 1) ? sda_out : 'bz;

	/*** I2C clock generation ***/
	// --------CLK_VALUE depends on input clock frequency, 
	// --------here is for 100 MHz input clock
	localparam CLK_390K 	= 	7;
	localparam CLK_781K 	= 	6;
	localparam CLK_1562K 	= 	5;
	localparam CLK_3125K 	= 	4;

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

	/*** SM update**/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			finish <= 0;
			state <= IDLE;
			o_rd_data <= 8'd0;
			o_rd_data_2 <= 8'd0;
			o_rd_data_3 <= 8'd0;
			o_rd_data_4 <= 8'd0;
			CPU_SM <= CPU_SM_W_REG;
		end		
		else begin
			case(state)
			
				IDLE: begin
					case (op_mode)
						CPU_WREG, CPU_RREG: if(i_enable) sm_enable <= 1; 
						default: sm_enable <= 0;
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
					endcase

					state <= ADDRESS;
				end

				ADDRESS: begin
					if (counter == 0) begin 
						state <= READ_ACK;
					end else counter <= counter - 1;
				end

				READ_ACK: begin
					if (i2c_sda == ACK) begin
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
					else state <= SLOW;
				end

				REG_HBYTE: begin
					if (counter == 0) begin 	
						state <= READ_ACK2;
					end else counter <= counter - 1;
				end

				READ_ACK2: begin
					counter <= 7;
					state <= REG_LBYTE;
					// if (i2c_sda == ACK) begin
					// 	counter <= 7;
					// 	state <= REG_LBYTE;
					// end 
					// else state <= SLOW;
				end

				REG_LBYTE: begin
					if (counter == 0) begin 
						state <= READ_ACK3;
					end else counter <= counter - 1;
				end

				READ_ACK3: begin
					case (op_mode)
						CPU_WREG: begin
							counter <= 7;
							saved_write_3 <=  i_w_data[31:24]; // MSB
							saved_write_2 <=  i_w_data[23:16];
							saved_write_1 <=  i_w_data[15:8];
							saved_write_0 <=  i_w_data[7:0]; //LSB
							state <= WRITE_DATA;
						end
						CPU_RREG: state <= SLOW;
					endcase
				end

				WRITE_DATA: begin
					if(counter == 0) begin
						state <= READ_ACK4;
					end else counter <= counter - 1;
				end

				READ_ACK4: begin
					counter <= 7;
					state <= WRITE_DATA2;
				end

				WRITE_DATA2: begin
					if(counter == 0) begin
						state <= READ_ACK5;
					end else counter <= counter - 1;
				end

				READ_ACK5: begin
					counter <= 7;
					state <= WRITE_DATA3;
				end

				WRITE_DATA3: begin
					if(counter == 0) begin
						state <= READ_ACK6;
					end else counter <= counter - 1;
				end

				READ_ACK6: begin
					counter <= 7;
					state <= WRITE_DATA4;
				end

				WRITE_DATA4: begin
					if(counter == 0) begin
						state <= READ_ACK7;
					end else counter <= counter - 1;
				end

				READ_ACK7: begin
					finish <= 1;
					state <= SLOW;
				end

				SLOW: begin
					state <= STOP;
				end

				STOP: begin
					finish <= 0;
					case (op_mode)
						CPU_WREG: sm_enable <= 0;
						CPU_RREG: begin
							if(CPU_SM == CPU_SM_W_REG) CPU_SM <= CPU_SM_READ;
							else if(CPU_SM == CPU_SM_READ) begin
								CPU_SM <= CPU_SM_W_REG;
								sm_enable <= 0;
							end
						end
					endcase
					state <= IDLE;
				end

				READ_DATA: begin
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin
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
					finish <= 1;
					state <= SLOW;
				end
			endcase
		end
	end
	
	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			write_enable <= 0;
			// sda_out <= 1;
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
				
				READ_ACK, READ_ACK2, READ_ACK3, READ_ACK4, READ_ACK5, READ_ACK6, READ_ACK7: begin
					write_enable <= 0;
				end

				WRITE_DATA: begin //write reg value, MSB
					write_enable <= 1;
					sda_out <= saved_write_3[counter];
				end

				WRITE_DATA2: begin //write data
					write_enable <= 1;
					sda_out <= saved_write_2[counter];
				end

				WRITE_DATA3: begin //write data
					write_enable <= 1;
					sda_out <= saved_write_1[counter];
				end

				WRITE_DATA4: begin //write data, LSB
					write_enable <= 1;
					sda_out <= saved_write_0[counter];
				end
				
				WRITE_ACK, WRITE_ACK2, WRITE_ACK3, WRITE_ACK4: begin
					write_enable <= 1;
					sda_out <= 0;
				end

				REG_HBYTE: begin
					write_enable <= 1;
					sda_out <= saved_regaddr_H[counter];
				end

				REG_LBYTE: begin
					write_enable <= 1;
					sda_out <= saved_regaddr_L[counter];
				end
				
				READ_DATA, READ_DATA2, READ_DATA3, READ_DATA4: begin
					write_enable <= 0;				
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