`timescale 1 ns/ 100 ps
module i2c_controller_vlg_tst();
// constants                                           
// general purpose registers
reg eachvec;
// test vector input registers
reg treg_i2c_sda;
reg i_clk;
reg [6:0] i_dev_addr;
reg i_enable;
reg [7:0] i_reg_addr;
reg i_rst_n;
reg i_rw_reg;
reg [7:0] i_w_data;
// wires                                               
wire i2c_scl;
wire i2c_sda;
wire i2c_clk_out;
wire o_finish;
wire [7:0]  o_rd_data;
wire o_ready;
wire o_w_enable;
wire [7:0]  sm;

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
	.i_dev_addr(i_dev_addr),
	.i_enable(i_enable),
	.i_reg_addr(i_reg_addr),
	.i_rst_n(i_rst_n),
	.i_rw_reg(i_rw_reg),
	.i_w_data(i_w_data),
	.o_finish(o_finish),
	.o_rd_data(o_rd_data),
	.o_ready(o_ready),
	.o_w_enable(o_w_enable),
	.sm(sm)
);
initial                                                
begin      

i_enable = 0;
i_clk = 0;          
i_rst_n = 0;    
i_dev_addr = 7'h1D;   
i_reg_addr = 8'h00;      
i_rw_reg = 1'b0;   
i_w_data = 8'hAB;   
#50
i_rst_n = 1;    
i_enable = 1;
#50
repeat(100) begin
	$display("Running repeat");  
	@(posedge i2c_clk_out);
end
                                           
$stop;                 
end  

always @(*) begin
	if (sm == 3 || sm == 6 || sm == 11 || sm == 4 || sm == 7 || sm == 12) begin
		treg_i2c_sda = 1'b0; // sm = 3、6 或 11 時將 i2c_sda 拉低
	end else begin
		treg_i2c_sda = 1'bz; // 其他狀態設為高阻態
	end
end

always#10 i_clk = ~i_clk;                                                
                                                   
endmodule

