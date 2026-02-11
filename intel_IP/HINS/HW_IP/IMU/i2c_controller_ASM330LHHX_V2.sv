// 2-4-2026 建立
// 新增 i_latch_trigger 來 latch data，需對應修改後的 VaeSet_60 ip
module i2c_controller_ASM330LHHX_V2
(
	input wire 			i_clk,
	input wire 			i_rst_n,
	input wire [6:0] 	i_dev_addr,
	input wire [7:0] 	i_w_data,
	input wire [7:0] 	i_reg_addr,
	input wire [31:0]	i_ctrl,
	input wire 			i_drdy,
	input wire 			i_sync,
	input wire i_latch_trigger,

	output logic signed [32-1:0] 	o_GYROX,
	output logic signed [32-1:0] 	o_GYROY,
	output logic signed [32-1:0] 	o_GYROZ,
	output logic signed [32-1:0] 	o_ACCX,
	output logic signed [32-1:0] 	o_ACCY,
	output logic signed [32-1:0] 	o_ACCZ,
	output logic signed [32-1:0] 	o_TEMP,


	output wire [31:0] 	o_status,
	output wire [31:0] 	o_cnt,
	output wire 		o_w_enable,
	output wire			i2c_clk_out,
	inout				i2c_scl,
	inout 				i2c_sda
);

	/*** regidter definition***/
	localparam ASM330LHHX_DEV_ADDR  = 7'h6A; // b'1101010, SA0 connect to GNS
	localparam REG_OUT_TEMP_L 		= 8'h20;
	localparam REG_OUT_TEMP_H 		= 8'h21;
	localparam REG_OUTX_L_G 		= 8'h22;
	localparam REG_OUTX_H_G 		= 8'h23;
	localparam REG_OUTY_L_G 		= 8'h24;
	localparam REG_OUTY_H_G 		= 8'h25;
	localparam REG_OUTZ_L_G 		= 8'h26;
	localparam REG_OUTZ_H_G 		= 8'h27;
	localparam REG_OUTX_L_A 		= 8'h28;
	localparam REG_OUTX_H_A 		= 8'h29;
	localparam REG_OUTY_L_A 		= 8'h2A;
	localparam REG_OUTY_H_A 		= 8'h2B;
	localparam REG_OUTZ_L_A 		= 8'h2C;
	localparam REG_OUTZ_H_A 		= 8'h2D;

	/*** I2C Clock rate definition for 100MHz input clock ***/
	localparam CPU_CLK_97K 		= 	0;
	localparam CPU_CLK_195K 	= 	1;
	localparam CPU_CLK_390K 	= 	2;
	localparam CPU_CLK_781K 	= 	3;
	localparam CPU_CLK_1562K 	= 	4;
	localparam CPU_CLK_3125K 	= 	5;

	localparam  CLK_97K 	= 	9;
	localparam CLK_195K 	= 	8;
	localparam CLK_390K 	= 	7;
	localparam CLK_781K 	= 	6;
	localparam CLK_1562K 	= 	5;
	localparam CLK_3125K 	= 	4;

	/*** op mode definition ***/
	localparam CPU_WREG	= 	3'd0;
	localparam CPU_RREG = 	3'd1;
	localparam HW 		= 	3'd2;
	localparam CPU_CMD	= 	3'd3;

	/*** REG definition    ***/
	localparam OUT_TEMP_L  = 8'h20;


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
	localparam READ_DATA12 	= 	33;
	localparam WRITE_ACK12 	= 	34;
	localparam READ_DATA13 	= 	35;
	localparam WRITE_ACK13 	= 	36;
	localparam READ_DATA14 	= 	37;
	localparam WRITE_ACK14 	= 	38;
	localparam STOP 		= 	39;
	localparam STOP2 		= 	40;

	logic signed [7:0] 	reg_rd_data,   reg_rd_data_2, reg_rd_data_3, reg_rd_data_4;
	logic signed [7:0] 	reg_rd_data_5, reg_rd_data_6, reg_rd_data_7, reg_rd_data_8;
	logic signed [7:0] 	reg_rd_data_9, reg_rd_data_10, reg_rd_data_11, reg_rd_data_12;
	logic signed [7:0] 	reg_rd_data_13, reg_rd_data_14;
	// 定義影子暫存器 (Live Data)
	logic signed [31:0] live_gx, live_gy, live_gz, live_ax, live_ay, live_az, live_temp;
	

	reg [7:0] state;
	reg [7:0] saved_addr;
	reg [7:0] saved_data;
	reg [7:0] counter;
	reg sda_out = 0;
	reg [1:0] i2c_scl_enable = 0;
	reg i2c_scl_enable2 = 0;
	reg i2c_clk = 1;
	reg clk_2x = 1;
	reg	[9:0] CLK_COUNT = 0; 	//clock
	reg [3:0] reg_clock_rate = 6;
	reg write_done = 0; // write done flag
	reg r_drdy = 0;

	wire i_enable, finish_ack;
	wire [2:0] op_mode;
	wire [2:0] clk_rate;
	reg sm_enable;

	wire w_en1, write_enable;
	reg w_en2 = 0;
	reg [31:0] drdy_timeout;

	
	

	/******* finish strobe & reesponse ********/
	reg finish = 0; // finish flag
	reg wait_finish_flag = 0;
	reg prev_clear;
	wire clear_pulse;

	// assign w_en1 = (sda_out==1)? 0:1 ;
	assign w_en1 = ~sda_out;
	assign write_enable = w_en1 | w_en2;



	/******* control register********/
	assign i_enable = i_ctrl[0];
	assign op_mode = i_ctrl[3:1];
	assign clk_rate = i_ctrl[6:4];
	assign clear_pulse = (i_ctrl[7] == 1'b1) && (prev_clear == 1'b0); // up edge detect

	/******* status register********/
	assign o_status[0] = ((i_rst_n == 1) && (state == IDLE) && (write_done == 0)) ? 1 : 0; //ready
	assign o_status[1] = finish; //finish 
	assign o_status[9:2] = state;  
	assign o_status[10]  = sm_enable;
	assign o_status[12:11]  = CPU_SM;
	assign o_status[15:13]  = HW_SM;
	// assign o_status[17:16]  = AIN_SM;
	assign o_cnt = drdy_timeout;


	assign i2c_clk_out = i2c_clk;
	assign o_w_enable = write_enable; 
	assign i2c_scl =	(i2c_scl_enable == 0) ? 0 : 
						((i2c_scl_enable == 1) ? 1'bz : 
                 		(i2c_clk == 1 ? 1'bz : 0));
	assign i2c_sda = (write_enable == 1) ? sda_out : 1'bz; // open drain method

	/******* CLK_VALUE depends on input clock frequency********/
	always@(posedge i_clk) begin
		if(!i_rst_n) begin
			reg_clock_rate <= CLK_195K;
		end
		else begin
			reg_clock_rate <= clk_rate;
			case(clk_rate)
				CPU_CLK_97K   : reg_clock_rate <= CLK_97K;	
				CPU_CLK_195K  : reg_clock_rate <= CLK_195K;
				CPU_CLK_390K  : reg_clock_rate <= CLK_390K;
				CPU_CLK_781K  : reg_clock_rate <= CLK_781K;
				CPU_CLK_1562K : reg_clock_rate <= CLK_1562K;
				CPU_CLK_3125K : reg_clock_rate <= CLK_3125K;
				default  : reg_clock_rate <= CLK_390K;
			endcase
		end
	end

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[7]:100000/2^(7+1)=390.625 kHz, CLK_COUNT[6]:781.25 KHz
		i2c_clk <= CLK_COUNT[reg_clock_rate];
		clk_2x  <= CLK_COUNT[reg_clock_rate-1];
	end

	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			i2c_scl_enable <= 1;
		end else begin
			case(state)
				READ_ACK_B, READ_ACK2_B, READ_ACK3_B: i2c_scl_enable <= 0;
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

	/*** For the states need to WRITE operation, let w_en2 = 1, otherwise w_en2 = 0***/
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
				REG_ADDR: begin
					if(saved_data[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_DATA: begin
					if(saved_data[counter]==0) w_en2 <= 1;
					else w_en2 <= 0;
				end
				WRITE_ACK ,  WRITE_ACK2,  WRITE_ACK3,  WRITE_ACK4, WRITE_ACK5,
				WRITE_ACK6,  WRITE_ACK7,  WRITE_ACK8,  WRITE_ACK9, WRITE_ACK10,
				WRITE_ACK11, WRITE_ACK12, WRITE_ACK13, WRITE_ACK14: begin
					w_en2 <= 1;
				end
				STOP: w_en2 <= 1;
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
typedef enum logic [1:0] {
	CPU_SM_W_REG = 2'd0,
	CPU_SM_READ  = 2'd1
} CPU_SM_t;

typedef enum logic [2:0] {
	HW_SM_WAIT_DRDY     = 3'd0,
	HW_SM_W_REG   		= 3'd1,
	HW_SM_READ_DATA	    = 3'd2
} HW_SM_t;

CPU_SM_t CPU_SM;
HW_SM_t  HW_SM;

reg i_drdy_sync1, i_drdy_sync2;
always @(posedge i2c_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        i_drdy_sync1 <= 1'b1;
        i_drdy_sync2 <= 1'b1;
    end
    else begin
        i_drdy_sync1 <= i_drdy;
        i_drdy_sync2 <= i_drdy_sync1;
    end
end

// 修改 i2c_controller_ASM330LHHX_V2.sv 裡面的輸出區塊
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        o_GYROX <= 0; o_GYROY <= 0; o_GYROZ <= 0;
        o_ACCX  <= 0; o_ACCY  <= 0; o_ACCZ  <= 0;
        o_TEMP  <= 0;
    end else begin
        // --- 情況 1：HW 模式下的 Latch 鎖定 ---
        if (op_mode == HW) begin
            if (i_latch_trigger) begin
                o_GYROX <= live_gx;
                o_GYROY <= live_gy;
                o_GYROZ <= live_gz;
                o_ACCX  <= live_ax;
                o_ACCY  <= live_ay;
                o_ACCZ  <= live_az;
                o_TEMP  <= live_temp;
            end
        end
        // --- 情況 2：CPU 模式 (寫入校驗或手動讀取) ---
        else begin
            // 讓輸出埠直接等於 live 暫存器，不等待 latch 訊號
            o_GYROX <= live_gx;
            o_GYROY <= live_gy;
            o_GYROZ <= live_gz;
            o_ACCX  <= live_ax;
            o_ACCY  <= live_ay;
            o_ACCZ  <= live_az;
            o_TEMP  <= live_temp;
        end
    end
end

/*** SM update**/
	always @(posedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			state <= IDLE;
			wait_finish_flag <= 0;
			write_done <= 1'b0;
			reg_rd_data <= 0;reg_rd_data_2 <= 0;reg_rd_data_3 <= 0;
			reg_rd_data_4 <= 0;reg_rd_data_5 <= 0;reg_rd_data_6 <= 0;
			reg_rd_data_7 <= 0;reg_rd_data_8 <= 0;reg_rd_data_9 <= 0;
			reg_rd_data_10 <= 0;reg_rd_data_11 <= 0;reg_rd_data_12 <= 0;
			reg_rd_data_13 <= 0;reg_rd_data_14 <= 0;
			// o_ACCX <= 0; o_ACCY <= 0; o_ACCZ <= 0; o_TEMP <= 0;
			// o_GYROX <= 0; o_GYROY <= 0; o_GYROZ <= 0;
			
			// o_AIN0 <= 0; o_AIN1 <= 0; o_AIN2 <= 0; o_AIN3 <= 0;
			sm_enable <= 0; 
			saved_data <= 0;
			// finish <= 0;
			/*** drdy_timeout init ***/
			drdy_timeout <= 0;
			/***  SM initialization  ***/
			CPU_SM <= CPU_SM_W_REG;
			HW_SM <= HW_SM_WAIT_DRDY;
		end		
		else begin
			case(state)
				IDLE: begin // 根據op_mode模式來啟動狀態機
					wait_finish_flag <= 0;
					case (op_mode)
						CPU_WREG, CPU_RREG: if(i_enable) sm_enable <= 1; 
						HW: begin
							if(HW_SM == HW_SM_WAIT_DRDY) begin
								if(i_drdy_sync2 == 1'b1) begin  // INT1 有訊號來
									HW_SM <= HW_SM_W_REG;
									sm_enable <= 1;
									// drdy_timeout <= 32'd0;
								end
								else begin
            						sm_enable <= 0;
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
							if(HW_SM == HW_SM_W_REG) saved_addr <= {i_dev_addr, 1'b0};
							else saved_addr <= {i_dev_addr, 1'b1};
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
								HW_SM_W_REG: begin 
									saved_data <= OUT_TEMP_L;
									state <= REG_ADDR;
								end
								HW_SM_READ_DATA: state <= READ_DATA;
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
						HW: state <= STOP;
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
								live_gx <= {24'b0, reg_rd_data}; // 當模式為 CPU 讀取時，使用 o_GYROX 當作讀到的 reg 值
							end
						end
						HW: begin
							case(HW_SM)
								HW_SM_W_REG: HW_SM <= HW_SM_READ_DATA ;
								HW_SM_READ_DATA: begin
									HW_SM <= HW_SM_WAIT_DRDY;
									sm_enable <= 0;

									live_temp <= {{16{reg_rd_data_2[7]}}, reg_rd_data_2, reg_rd_data};
									live_gx   <= {{16{reg_rd_data_4[7]}}, reg_rd_data_4, reg_rd_data_3};
									live_gy   <= {{16{reg_rd_data_6[7]}}, reg_rd_data_6, reg_rd_data_5};
									live_gz   <= {{16{reg_rd_data_8[7]}}, reg_rd_data_8, reg_rd_data_7};
									live_ax   <= {{16{reg_rd_data_10[7]}}, reg_rd_data_10, reg_rd_data_9};
									live_ay   <= {{16{reg_rd_data_12[7]}}, reg_rd_data_12, reg_rd_data_11};
									live_az   <= {{16{reg_rd_data_14[7]}}, reg_rd_data_14, reg_rd_data_13};
								end
							endcase
						end
						default: state <= STOP;
					endcase

					state <= STOP2;
					
				end

				STOP2: begin
					state <= IDLE;
					// finish <= 0;
				end


				WRITE_DATA: begin 
					if (counter == 0) begin 
						state <= READ_ACK3;
					end else begin
						counter <= counter - 1;
					end
				end

				READ_ACK3: begin 
					state <= READ_ACK3_B;
				end

				READ_ACK3_B: begin 
					wait_finish_flag <= 1;
					state <= STOP;
				end

				READ_DATA: begin				
					reg_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin
					case (op_mode)
						CPU_RREG: begin
							wait_finish_flag <= 1;
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
					counter <= 7;
					state <= READ_DATA12;
				end
				READ_DATA12: begin
					reg_rd_data_12[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK12;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK12: begin
					counter <= 7;
					state <= READ_DATA13;
				end
				READ_DATA13: begin
					reg_rd_data_13[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK13;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK13: begin
					counter <= 7;
					state <= READ_DATA14;
				end
				READ_DATA14: begin
					reg_rd_data_14[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK14;
					else begin
						counter <= counter - 1;
					end
				end
				WRITE_ACK14: begin
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
				
				READ_ACK, READ_ACK_B, READ_ACK2, READ_ACK2_B, READ_ACK3, READ_ACK3_B: begin
					sda_out <= 1;
				end

				REG_ADDR: begin //write reg addr
					sda_out <= saved_data[counter];
				end
				
				WRITE_DATA: begin //write reg value
					sda_out <= saved_data[counter];
				end
				WRITE_ACK, WRITE_ACK2, WRITE_ACK3, WRITE_ACK4, WRITE_ACK5, WRITE_ACK6, 
				WRITE_ACK7, WRITE_ACK8, WRITE_ACK9, WRITE_ACK10, WRITE_ACK11, WRITE_ACK12, 
				WRITE_ACK13, WRITE_ACK14: begin
					sda_out <= 0;
				end
				
				READ_DATA, READ_DATA2, READ_DATA3, READ_DATA4, READ_DATA5, READ_DATA6, 
				READ_DATA7, READ_DATA8, READ_DATA9, READ_DATA10, READ_DATA11, READ_DATA12, 
				READ_DATA13, READ_DATA14: begin
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