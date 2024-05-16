module SMA_v3
#(parameter WINDOW_SIZE = 32768)
(
	input i_clk,
	input i_rst_n,
	input i_update_strobe,
	input [31:0] i_window_sel,
	input signed [31:0] i_data,
	output signed [31:0] o_data
	// for simulation
	, output [31:0] m_count_reg
	, output [63:0] m_sum_reg
	, output [15:0] m_N
	, output [31:0] m_data_reg
	, output window_change
);

`define LOW  1'b0
`define HIGH 1'b1

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

//State machine
localparam RST = 				4'd0; 
localparam WAIT = 				4'd1; 
localparam UPDATE_SUM = 		4'd2;
localparam SUBSTRACT_OLD = 		4'd3;
localparam REPLACE_NEW = 		4'd4;
localparam COUNTET_PROCEED = 	4'd5;


// SMA usage
reg signed [31:0] count_reg, data_reg [0:WINDOW_SIZE-1];
reg signed [31:0] sum_reg;
reg [15:0] N;
reg [15:0] idx;
reg [3:0] cstate, nstate;
//input window usage
reg [31:0] r_window_sel, r_window_sel_dly;
// wire window_change;

assign window_change = r_window_sel_dly!=r_window_sel;

assign o_data = (r_window_sel==SIZE_1)? i_data : sum_reg >>> r_window_sel;
assign m_count_reg = count_reg;
assign m_sum_reg = sum_reg;
assign m_N = N;
assign m_data_reg = data_reg[count_reg];

always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
		r_window_sel <= 32'd0;
		r_window_sel_dly <= 32'd0;
	end
    else begin
		r_window_sel <= i_window_sel;
		r_window_sel_dly <= r_window_sel;
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

/*** state register ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) cstate <= RST;
    else cstate <= nstate;
end

/*** next state generator ***/
always@(*) begin
	if(!i_rst_n) begin
		nstate = RST;
	end

	else begin			
		case(cstate)
			RST: begin
				nstate = WAIT;
			end
			WAIT: begin
				if(window_change) nstate = RST;
				else if(i_update_strobe == `HIGH) nstate = UPDATE_SUM;
				else nstate = WAIT;
			end
			UPDATE_SUM: begin
				if(window_change) nstate = RST;
				else nstate = SUBSTRACT_OLD;
			end

			SUBSTRACT_OLD: begin 
				if(window_change) nstate = RST;
				else nstate = REPLACE_NEW;
			end

			REPLACE_NEW: begin 
				if(window_change) nstate = RST;
				else nstate = COUNTET_PROCEED;
			end

			COUNTET_PROCEED: begin
				if(window_change) nstate = RST;
				else nstate = WAIT;
			end
			default: nstate = RST;
		endcase		
	end

end

// /*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
	if(!i_rst_n) begin
		sum_reg <= 0;
		count_reg <= 0;
	end
	
	else begin
		case(cstate)
			RST: begin
				sum_reg <= 0;
       			count_reg <= 0;
			end
			WAIT: begin

			end
			UPDATE_SUM: begin
				sum_reg <= sum_reg + i_data;
				
			end
			SUBSTRACT_OLD: begin
				sum_reg <= sum_reg - data_reg[count_reg];
			end 

			REPLACE_NEW: begin
				data_reg[count_reg] <= i_data;
			end

			COUNTET_PROCEED: begin
				if(count_reg > N-1) begin
					count_reg <= 0;
				end
				else begin
					count_reg <= count_reg + 1;
				end
			end
		
			default: begin
			end
			
		endcase

	end
		
end

// always @(posedge i_clk or negedge i_rst_n) begin
//     if (!i_rst_n) begin
//         sum_reg <= 0;
//         count_reg <= 0;
// 		/*** below initialization needs for simulation ***/
// //      for (idx = 0; idx < WINDOW_SIZE; idx = idx + 1) begin
// //          data_reg[idx] <= 0;
// //      end
//     end 
// 	else begin
// 		if(window_change) begin
// 			count_reg <= 0;
// 			sum_reg <= 0;
// //			for (idx = 0; idx < WINDOW_SIZE; idx = idx + 1) begin
// //				data_reg[idx] <= 0;
// //			end
// 		end
// 		if(i_update_strobe) begin
// 			if(count_reg > N-1) begin
// 				count_reg <= 0;
// 			end
// 			else begin
// 				count_reg <= count_reg + 1;
// 			end
// 			sum_reg <= sum_reg + i_data - data_reg[count_reg];
// 			data_reg[count_reg] <= i_data;
// 		end
//     end
// end

endmodule