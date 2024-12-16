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
	localparam ADDRESS7		= 	3;
	localparam ADDRESS6		= 	4;
	localparam ADDRESS5		= 	5;
	localparam ADDRESS4		= 	6;
	localparam ADDRESS3		= 	7;
	localparam ADDRESS2		= 	8;
	localparam ADDRESS1		= 	9;
	localparam ADDRESS0		= 	10;
	localparam READ_ACK 	= 	11;
	localparam READ_ACK_B 	= 	12;
	localparam REG_ADDR7  	= 	13;
	localparam REG_ADDR6  	= 	14;
	localparam REG_ADDR5  	= 	15;
	localparam REG_ADDR4  	= 	16;
	localparam REG_ADDR3  	= 	17;
	localparam REG_ADDR2  	= 	18;
	localparam REG_ADDR1  	= 	19;
	localparam REG_ADDR0  	= 	20;
	localparam READ_ACK2 	= 	21;
	localparam READ_ACK2_B 	= 	22;
	localparam WRITE_DATA7 	= 	23;
	localparam WRITE_DATA6 	= 	24;
	localparam WRITE_DATA5 	= 	25;
	localparam WRITE_DATA4 	= 	26;
	localparam WRITE_DATA3 	= 	27;
	localparam WRITE_DATA2 	= 	28;
	localparam WRITE_DATA1 	= 	29;
	localparam WRITE_DATA0 	= 	30;
	localparam READ_ACK3 	= 	31;
	localparam READ_ACK3_B 	= 	32;	
	localparam READ_DATA 	= 	33;
	localparam WRITE_ACK 	= 	34;
	localparam READ_DATA2 	= 	35;
	localparam WRITE_ACK2 	= 	36;
	localparam READ_DATA3 	= 	37;
	localparam WRITE_ACK3 	= 	38;
	localparam READ_DATA4 	= 	39;
	localparam WRITE_ACK4 	= 	40;
	localparam READ_DATA5 	= 	41;
	localparam WRITE_ACK5 	= 	42;
	localparam READ_DATA6 	= 	43;
	localparam WRITE_ACK6 	= 	44;
	localparam READ_DATA7 	= 	45;
	localparam WRITE_ACK7 	= 	46;
	localparam READ_DATA8 	= 	47;
	localparam WRITE_ACK8 	= 	48;
	localparam READ_DATA9 	= 	49;
	localparam WRITE_ACK9 	= 	50;
	localparam READ_DATA10 	= 	51;
	localparam WRITE_ACK10 	= 	52;
	localparam READ_DATA11 	= 	53;
	localparam WRITE_ACK11 	= 	54;
	localparam STOP 		= 	55;
	localparam STOP2 		= 	56;
	localparam NOP1 		= 	57;
	localparam PREP1		=	58;
	localparam PREP2		=	59;
	localparam PREP3		=	60;

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

	always@(posedge i_clk) begin
		CLK_COUNT <= CLK_COUNT + 1;//CLK_COUNT[6]:50000/2^(6+1)=390.625 kHz, CLK_COUNT[5]:781.25 KHz
		i2c_clk <= CLK_COUNT[reg_clock_rate];
	end

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

	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			i2c_scl_enable <= 1;
		end else begin
			if ( (state == READ_ACK_B)|| (state == READ_ACK2_B)|| (state == PREP2)|| (state == PREP3) ) begin
				i2c_scl_enable <= 0;
			end 
			else if ( (state == IDLE) ||(state == START) || (state == STOP) || (state == STOP2 ) || (state == NOP1 ) || (state == PREP1)) begin
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
					// counter <= 7;
					if(op_mode==HW_11) saved_addr <= {ADXL355_DEV_ADDR, rw};
					else saved_addr <= {i_dev_addr, rw};
					state <= PREP1;
				end

				PREP1: begin
					state <= ADDRESS7;
				end

				ADDRESS7: begin
					state <= ADDRESS6;
				end

				ADDRESS6: begin
					state <= ADDRESS5;
				end

				ADDRESS5: begin
					state <= ADDRESS4;
				end

				ADDRESS4: begin
					state <= ADDRESS3;
				end

				ADDRESS3: begin
					state <= ADDRESS2;
				end

				ADDRESS2: begin
					state <= ADDRESS1;
				end

				ADDRESS1: begin
					state <= ADDRESS0;
				end

				ADDRESS0: begin
					state <= READ_ACK;
				end

				READ_ACK: begin
					if (i2c_sda == 0) begin
						state <= READ_ACK_B;
					end 
					else state <= STOP;
				end

				READ_ACK_B: begin
					if(rw == 0) begin
						if(op_mode==HW_11) saved_data = REG_ADXL355_TEMP2;
						else saved_data = i_reg_addr;
						state <= PREP2;
					end
					else begin
						counter <= 7;
						state <= READ_DATA;
					end
				end

				PREP2: begin
					state <= REG_ADDR7;
				end

				REG_ADDR7: begin
					state <= REG_ADDR6;
				end

				REG_ADDR6: begin
					state <= REG_ADDR5;
				end

				REG_ADDR5: begin
					state <= REG_ADDR4;
				end

				REG_ADDR4: begin
					state <= REG_ADDR3;
				end

				REG_ADDR3: begin
					state <= REG_ADDR2;
				end

				REG_ADDR2: begin
					state <= REG_ADDR1;
				end

				REG_ADDR1: begin
					state <= REG_ADDR0;
				end

				REG_ADDR0: begin
					if(rw_reg == 1'b1) //read reg mode
						write_done <= 1'b1;
					state <= READ_ACK2;
				end

				READ_ACK2: begin 
					state <= READ_ACK2_B;
				end

				READ_ACK2_B: begin 
					if( rw_reg == 1'b1) state <= STOP;
					else begin
						// counter <= 7;
						saved_data = i_w_data;
						state <= PREP3;
					end
				end

				STOP: begin
					if(write_done==1'b0) begin
						sm_enable <= 1'b0;
					end
					state <= STOP2;

					// if(finish_ack) begin
					// 	state <= STOP2;
					// end
					// else state <= STOP;
				end

				STOP2: begin
					state <= IDLE;
					finish <= 0;
				end

				NOP1: begin
					state <= IDLE;
				end

				PREP3: begin
					state <= WRITE_DATA7;
				end

				WRITE_DATA7: begin
					state <= WRITE_DATA6;
				end

				WRITE_DATA6: begin
					state <= WRITE_DATA5;
				end

				WRITE_DATA5: begin
					state <= WRITE_DATA4;
				end

				WRITE_DATA4: begin
					state <= WRITE_DATA3;
				end

				WRITE_DATA3: begin
					state <= WRITE_DATA2;
				end

				WRITE_DATA2: begin
					state <= WRITE_DATA1;
				end

				WRITE_DATA1: begin
					state <= WRITE_DATA0;
				end

				WRITE_DATA0: begin
					state <= READ_ACK3;
				end

				// WRITE_DATA: begin 
				// 	if(counter == 0) begin
				// 		state <= READ_ACK3;
				// 	end else counter <= counter - 1;
				// end

				READ_DATA: begin//11
					if(write_done == 1'b1) write_done = 1'b0;
					o_rd_data[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK;
					else counter <= counter - 1;
				end
				
				WRITE_ACK: begin//12
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
					counter <= 7;
					state <= READ_DATA5;
				end

				READ_DATA5: begin
					o_rd_data_5[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK5;
					else counter <= counter - 1;
				end
				WRITE_ACK5: begin
					counter <= 7;
					state <= READ_DATA6;
				end

				READ_DATA6: begin
					o_rd_data_6[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK6;
					else counter <= counter - 1;
				end
				WRITE_ACK6: begin
					counter <= 7;
					state <= READ_DATA7;
				end

				READ_DATA7: begin
					o_rd_data_7[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK7;
					else counter <= counter - 1;
				end
				WRITE_ACK7: begin
					counter <= 7;
					state <= READ_DATA8;
				end

				READ_DATA8: begin
					o_rd_data_8[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK8;
					else counter <= counter - 1;
				end
				WRITE_ACK8: begin
					counter <= 7;
					state <= READ_DATA9;
				end

				READ_DATA9: begin
					o_rd_data_9[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK9;
					else counter <= counter - 1;
				end
				WRITE_ACK9: begin
					counter <= 7;
					state <= READ_DATA10;
				end

				READ_DATA10: begin
					o_rd_data_10[counter] <= i2c_sda;
					if (counter == 0) state <= WRITE_ACK10;
					else counter <= counter - 1;
				end

				WRITE_ACK10: begin
					counter <= 7;
					state <= READ_DATA11;
				end

				READ_DATA11: begin
					o_rd_data_11[counter] <= i2c_sda;
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
	
	always @(negedge i2c_clk or negedge i_rst_n) begin
		if(!i_rst_n) begin
			write_enable <= 1;
			sda_out <= 1;
		end else begin
			case(state)
				
				START: begin
					// write_enable <= 1;
					sda_out <= 0;
				end

				PREP1: begin
					// if(saved_addr[7]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					write_enable <= 1;
				end

				ADDRESS7: begin
					// if(saved_addr[6]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					sda_out <= saved_addr[7];
				end

				ADDRESS6: begin
					// if(saved_addr[5]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					sda_out <= saved_addr[6];
				end

				ADDRESS5: begin
					// if(saved_addr[4]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					sda_out <= saved_addr[5];
				end

				ADDRESS4: begin
					// if(saved_addr[3]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					sda_out <= saved_addr[4];
				end

				ADDRESS3: begin
					// if(saved_addr[2]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					sda_out <= saved_addr[3];
				end

				ADDRESS2: begin
					// if(saved_addr[1]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					sda_out <= saved_addr[2];
				end

				ADDRESS1: begin
					// if(saved_addr[0]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					// else write_enable <= 1;
					sda_out <= saved_addr[1];
				end

				ADDRESS0: begin
					write_enable <= 0;
					sda_out <= saved_addr[0];
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

				PREP2: begin
					if(saved_data[7]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
				end

				REG_ADDR7: begin
					if(saved_data[6]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[7];
				end

				REG_ADDR6: begin
					if(saved_data[5]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[6];
				end

				REG_ADDR5: begin
					if(saved_data[4]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[5];
				end

				REG_ADDR4: begin
					if(saved_data[3]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[4];
				end

				REG_ADDR3: begin
					if(saved_data[2]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[3];
				end

				REG_ADDR2: begin
					if(saved_data[1]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[2];
				end

				REG_ADDR1: begin
					if(saved_data[0]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[1];
				end

				REG_ADDR0: begin
					write_enable <= 0;
					sda_out <= saved_data[0];
				end

				// REG_ADDR: begin //write reg addr
				// 	write_enable <= 1;
				// 	sda_out <= saved_data[counter];
				// end

				PREP3: begin
					if(saved_data[7]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
				end

				WRITE_DATA7: begin
					if(saved_data[6]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[7];
				end

				WRITE_DATA6: begin
					if(saved_data[5]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[6];
				end

				WRITE_DATA5: begin
					if(saved_data[4]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[5];
				end

				WRITE_DATA4: begin
					if(saved_data[3]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[4];
				end

				WRITE_DATA3: begin
					if(saved_data[2]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[3];
				end

				WRITE_DATA2: begin
					if(saved_data[1]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[2];
				end

				WRITE_DATA1: begin
					if(saved_data[0]==1'b1) write_enable <= 0; //prepare pull-up condition one state before.
					else write_enable <= 1;
					sda_out <= saved_data[1];
				end

				WRITE_DATA0: begin
					write_enable <= 0;
					sda_out <= saved_data[0];
				end
				
				// WRITE_DATA: begin //write reg value
				// 	write_enable <= 1;
				// 	sda_out <= saved_data[counter];
				// end
				
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

				default:;
			endcase
		end
	end

endmodule