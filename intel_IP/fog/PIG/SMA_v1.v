module SMA_v1
#(parameter WINDOW_SIZE = 32768)
(
	input i_clk,
	input i_rst_n,
	input i_update_strobe,
	input [31:0] i_window_sel,
	input signed [31:0] i_data,
	output signed [31:0] o_data
);

//MV select
localparam SIZE_1 = 		32'd0;
localparam SIZE_2 = 		32'd1;
localparam SIZE_4 = 		32'd2;
localparam SIZE_8 = 		32'd3;
localparam SIZE_16 = 		32'd4;
localparam SIZE_32 = 		32'd5;
localparam SIZE_64 = 		32'd6;
localparam SIZE_128 = 		32'd7;
localparam SIZE_256 = 		32'd8;
localparam SIZE_512 = 		32'd9;
localparam SIZE_1024 = 		32'd10;
localparam SIZE_2048 = 		32'd11;
localparam SIZE_4096 = 		32'd12;
localparam SIZE_8192 = 		32'd13;
localparam SIZE_16384 = 	32'd14;
localparam SIZE_32768 = 	32'd15;

// SMA usage
reg signed [31:0] count_reg, data_reg [0:WINDOW_SIZE-1];
reg [63:0] sum_reg;
reg [15:0] N;

//input window usage
reg [31:0] r_window_sel;

assign o_data = (r_window_sel==SIZE_1)? i_data : sum_reg >>> r_window_sel;

always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
		r_window_sel <= 32'd0;
	end
    else begin
		r_window_sel <= i_window_sel;
		 case(r_window_sel)
            SIZE_1:  	begin N <= 32'd1;end
            SIZE_2:  	begin N <= 32'd2;end
            SIZE_4:  	begin N <= 32'd4;end
            SIZE_8:  	begin N <= 32'd8;end
            SIZE_16: 	begin N <= 32'd16;end 
            SIZE_32: 	begin N <= 32'd32;end
            SIZE_64: 	begin N <= 32'd64;end
			SIZE_128: 	begin N <= 32'd128;end
			SIZE_256: 	begin N <= 32'd256;end
			SIZE_512: 	begin N <= 32'd512;end
			SIZE_1024: 	begin N <= 32'd1024;end
			SIZE_2048: 	begin N <= 32'd2048;end
			SIZE_4096: 	begin N <= 32'd4096;end
			SIZE_8192: 	begin N <= 32'd8192;end
			SIZE_16384: begin N <= 32'd16384;end
			SIZE_32768: begin N <= 32'd32768;end
        endcase
	end
end

// integer idx;
always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        sum_reg <= 0;
        count_reg <= 0;
        // for (genvar  idx = 0; idx < WINDOW_SIZE; idx = idx + 1) begin
        //     data_reg[idx] <= 0;
        // end
    end 
	else begin
		if(i_update_strobe) begin
			if(count_reg==N) begin
				count_reg <= 0;
				// sum_reg <= sum_reg + i_data - data_reg[count_reg];
				// data_reg[count_reg] <= i_data;
			end
			else begin
				count_reg <= count_reg + 1;
				// sum_reg <= sum_reg + i_data - data_reg[count_reg];
				// data_reg[count_reg] <= i_data;
			end
			sum_reg <= sum_reg + i_data - data_reg[count_reg];
			data_reg[count_reg] <= i_data;
		end
		else begin
			sum_reg <= sum_reg;
			count_reg <= count_reg;
		end
    end
end


endmodule