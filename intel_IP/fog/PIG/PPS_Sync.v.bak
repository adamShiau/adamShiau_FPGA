module PPS_Sync
#(parameter PULSE_NUM = 100, // for 100 Hz datarate
parameter PULSE_CNT = 1000000) //1e6*10ns = 10ms, pulse dt
(
	input i_clk,
	input i_rst_n,
	input SYNC,
	output reg pps_trig_out,
	output [31:0] o_pulse_number,
	output [31:0] o_pulse_cnt,
	output [3:0] o_cstate, 
	output [3:0] o_nstate
);

localparam LOW = 1'b0;
localparam HIGH = 1'b1;
localparam MIN_NUM = 1'b0;
localparam MIN_CNT = 1'b0;

//State machine
localparam WAIT_SYNC = 		4'd0;
// localparam CHECK_NUMBER =	4'd1;
localparam GENERATE_PULSE =	4'd1;

reg [31:0] pulse_number, pulse_cnt;
reg [3:0] cstate, nstate;

assign o_pulse_number = pulse_number;
assign o_pulse_cnt = pulse_cnt;
assign o_cstate = cstate;
assign o_nstate = nstate;

/*** next state logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) cstate <= WAIT_SYNC;
    else cstate <= nstate;
end

/*** state generator ***/
always@(*) begin
	if(~i_rst_n) begin
		nstate = WAIT_SYNC;
	end
	else begin	
		case(cstate)
		WAIT_SYNC: begin
			if(SYNC) nstate = GENERATE_PULSE;
		end

		// CHECK_NUMBER: begin
		// end

		GENERATE_PULSE: begin
			if(pulse_number == 32'd0) nstate = WAIT_SYNC;
		end
		
		default: nstate = WAIT_SYNC;
		endcase
				
	end

end

always@(posedge i_clk or negedge i_rst_n) begin
	if(~i_rst_n) begin
		pulse_number <= PULSE_NUM;
		pulse_cnt <= PULSE_CNT;
		pps_trig_out <= LOW;
	end
	
	else begin
		case(cstate)
		WAIT_SYNC: begin
			pps_trig_out <= LOW;
			pulse_number <= PULSE_NUM;
		end

		// CHECK_NUMBER: begin
		// 	pps_trig_out <= LOW;
		// end

		GENERATE_PULSE: begin
			if(pulse_number != MIN_NUM) begin
				// pulse_number <= pulse_number - 1'b1;
				if(pulse_cnt != MIN_CNT) begin
					pulse_cnt <= pulse_cnt - 1'b1;
					pps_trig_out <= LOW;
					
					if(pulse_cnt == PULSE_CNT) pps_trig_out <= HIGH;
					else pps_trig_out <= LOW;
					
				end
				else begin
					pulse_cnt <= PULSE_CNT;
					pps_trig_out <= LOW;
					pulse_number <= pulse_number - 1'b1;
				end
			end
			else begin
				
				pps_trig_out <= LOW;
			end
		end

		endcase
	end
end

endmodule