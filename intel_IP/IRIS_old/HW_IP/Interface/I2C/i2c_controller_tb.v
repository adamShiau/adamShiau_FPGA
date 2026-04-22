`timescale 1 ns/ 100 ps
module i2c_controller_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg treg_i2c_sda;
reg i_clk;
reg i_rst_n;
reg [6:0] i_dev_addr;
reg [7:0] i_w_data;
reg [7:0] i_reg_addr;
reg [31:0] i_ctrl;
reg i_drdy;

// wires                                               
wire i2c_scl;
wire i2c_sda;
wire i2c_clk_out;
wire [31:0] o_status;
wire [7:0]  o_rd_data;
wire [7:0]  o_rd_data_2;
wire [7:0]  o_rd_data_3;
wire [7:0]  o_rd_data_4;
wire [7:0]  o_rd_data_5;
wire [7:0]  o_rd_data_6;
wire [7:0]  o_rd_data_7;
wire [7:0]  o_rd_data_8;
wire [7:0]  o_rd_data_9;
wire [7:0]  o_rd_data_10;
wire [7:0]  o_rd_data_11;
wire o_w_enable;

wire [7:0] sm;
wire [1:0] op_mode;
wire sm_enable;
wire rw_reg;
wire ready;
wire finish;

assign sm = o_status[9:2]; 
assign ready = o_status[0];
assign finish = o_status[1];

assign sm_enable = i_ctrl[0];
assign rw_reg = i_ctrl[1];
assign op_mode = i_ctrl[3:2];

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

// assign statements (if any)                       
assign i2c_sda = treg_i2c_sda;
i2c_controller 
#(.DIVNUM(6))
i1 (
// port map - connection between master ports and signals/registers   
	.i2c_scl(i2c_scl),
	.i2c_sda(i2c_sda),
	.i2c_clk_out(i2c_clk_out),
	.i_clk(i_clk),
	.i_rst_n(i_rst_n),
	.i_dev_addr(i_dev_addr),
	.i_w_data(i_w_data),
	.i_reg_addr(i_reg_addr),
	.i_ctrl(i_ctrl),
	.i_drdy(i_drdy),

	.o_status(o_status),
	.o_rd_data(o_rd_data),
	.o_rd_data_2(o_rd_data_2),
	.o_rd_data_3(o_rd_data_3),
	.o_rd_data_4(o_rd_data_4),
	.o_rd_data_5(o_rd_data_5),
	.o_rd_data_6(o_rd_data_6),
	.o_rd_data_7(o_rd_data_7),
	.o_rd_data_8(o_rd_data_8),
	.o_rd_data_9(o_rd_data_9),
	.o_rd_data_10(o_rd_data_10),
	.o_rd_data_11(o_rd_data_11),
	.o_w_enable(o_w_enable)
);


initial                                                
begin      

i_clk = 0;          
i_rst_n = 0; 
i_drdy = 0;
i_ctrl = 0;
   
i_dev_addr = 7'h2D;   
i_reg_addr = 8'h2C;       
i_w_data = 8'h82;   
#50
i_rst_n = 1;    
// i_ctrl[0] = 1; 		//enable SM
i_drdy	= 1;
i_ctrl[1] = 1; 		//rw_reg
i_ctrl[3:2] = HW_11;	//op_mode
#5000
// i_ctrl[0] = 0; 		//enable SM
i_drdy	= 0;
#50
repeat(200) begin
	$display("Running repeat");  
	@(posedge i2c_clk_out);
end
                                           
$stop;                 
end  

always @(*) begin
	if (sm == READ_ACK || sm == READ_ACK2 || sm == READ_DATA || sm == READ_DATA2 || sm == READ_DATA3 || sm == READ_DATA4 || sm == READ_DATA5
	|| sm == READ_DATA6|| sm == READ_DATA7|| sm == READ_DATA8|| sm == READ_DATA9|| sm == READ_DATA10|| sm == READ_DATA11) begin
		treg_i2c_sda = 1'b0;
	end else begin
		treg_i2c_sda = 1'bz; // 其他狀態設為高阻態
	end
end

always#10 i_clk = ~i_clk;                                                
                                                   
endmodule

