module PPS_Sync_v2
#(parameter PULSE_NUM = 100, // for 100 Hz datarate
parameter HALF_PERIOD = 500000) //1e6*10ns = 10ms, pulse dt
(
	input i_clk,
	input i_rst_n,
	input SYNC,
	output reg pps_trig_out,
	output [31:0] o_pulse_number,
	output [31:0] o_half_period_cnt,
	output [3:0] o_cstate, 
	output [3:0] o_nstate
);

localparam LOW = 1'b0;
localparam HIGH = 1'b1;
localparam MIN_NUM = 1'b0;
localparam MIN_CNT = 1'b0;

//State machine
localparam WAIT_SYNC = 		4'd0;
localparam CHECK_NUM = 		4'd1;
localparam GENERATE_PULSE_H =	4'd2;
localparam GENERATE_PULSE_L =	4'd3;

reg [31:0] pulse_number, half_period_cnt;
reg [3:0] cstate, nstate;

assign o_pulse_number = pulse_number;
assign o_half_period_cnt = half_period_cnt;
assign o_cstate = cstate;
assign o_nstate = nstate;

/*** next state logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) cstate <= WAIT_SYNC;
    else cstate <= nstate;
end


/*** state generator ***/
///***

always@(*) begin
	if(~i_rst_n) begin
		nstate = WAIT_SYNC;
	end
	else begin	
		case(cstate)
		WAIT_SYNC: begin
			if(SYNC == 1'b1) nstate = CHECK_NUM;
		end

		CHECK_NUM: begin
			if(pulse_number == 32'd0) nstate = WAIT_SYNC;
			else nstate = GENERATE_PULSE_H;
		end

		GENERATE_PULSE_H: begin
			if(half_period_cnt == 32'd0) nstate = GENERATE_PULSE_L;
		end

		GENERATE_PULSE_L: begin
			if(half_period_cnt == 32'd0) nstate = CHECK_NUM;
		end
		
		default: nstate = WAIT_SYNC;
		endcase
				
	end

end
//***/

///***
always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		pulse_number <= PULSE_NUM;
		half_period_cnt <= HALF_PERIOD-1'b1;
		pps_trig_out <= LOW;
	end
	
	else begin
		case(cstate)
		WAIT_SYNC: begin
			pps_trig_out <= LOW;
			pulse_number <= PULSE_NUM;
		end

		CHECK_NUM: begin
			pps_trig_out <= LOW;
			if(pulse_number != 32'd0) pulse_number <= pulse_number - 1'b1;
		end

		GENERATE_PULSE_H: begin	
			if(half_period_cnt != 32'd0) begin
				half_period_cnt <= half_period_cnt - 1'b1;
				pps_trig_out <= HIGH;
			end
			else begin
				half_period_cnt <= HALF_PERIOD-1'b1;
			end
		end

		GENERATE_PULSE_L: begin	
			if(half_period_cnt != 32'd0) begin
				half_period_cnt <= half_period_cnt - 1'b1;
				pps_trig_out <= LOW;
			end
			else begin
				half_period_cnt <= HALF_PERIOD-1'b1;
			end
		end
		

		endcase
	end
end
//***/

endmodule