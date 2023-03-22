/*** 
err_signal_gen_v3 created in 03/20/2023
新增wait cnt and AVG
***/

module err_signal_gen_v3
#(parameter ADC_BIT = 14)
(
input i_clk,
input i_rst_n,
input i_status,
input i_polarity,
input i_trig,
input [31:0] i_wait_cnt,
input signed [31:0] i_err_offset,
input signed [ADC_BIT-1:0] i_adc_data,
input [31:0] i_avg_sel, 
output signed [31:0] o_err,
output reg o_step_sync,
output reg o_step_sync_dly,
output reg o_rate_sync,
output reg o_ramp_sync,


/*** for simulation ***/
//output reg [31:0] o_r_mv_cnt,
output signed [31:0] o_adc,
output signed [31:0] o_adc_old,
output signed [31:0] o_adc_new,
output signed [31:0] o_adc_sum,
output o_pol_change,
output o_flip_flag,
output [3:0] o_cstate, o_nstate,
output [31:0] o_stable_cnt
);

//State machine
localparam RST = 			4'd0;
localparam WAIT_L_STATE = 	4'd1;
localparam WAIT_H_STATE = 	4'd2;
localparam WAIT_STABLE =	4'd3;
localparam ACQ_INIT = 		4'd4;
localparam ACQ_NEW	 = 		4'd5;
localparam ERR_GEN = 		4'd6;
localparam ERR_GEN_DLY = 	4'd7;
localparam WAIT_NEXT = 		4'd8; 
localparam RATE_SYNC_GEN = 	4'd9;
localparam RAMP_SYNC_GEN = 	4'd10;

`define LOW  1'b0
`define HIGH 1'b1

reg [3:0] cstate, nstate;
reg r_polarity, r_polarity2, r_status, r_acq_done, r_trig, r_sync;
reg [31:0] r_stable_cnt, r_mv_cnt, r_avg_sel, r_freq_cnt;
reg acq_done, r_flip, r_init, r_stable;
reg signed [31:0] r_adc_sum;
reg signed [31:0] r_adc, r_adc_old, r_adc_new, r_err, r_err_offset;
wire signed [31:0] adc;

assign o_adc = r_adc;
assign o_adc_old = r_adc_old;
assign o_adc_new = r_adc_new;
assign o_err = r_err;
assign o_adc_sum = r_adc_sum;
assign o_pol_change = r_polarity2 ^ r_polarity;
assign o_flip_flag = r_flip;
assign o_cstate = cstate;
assign o_nstate = nstate;
//assign o_err_sync = r_sync;
assign o_stable_cnt = r_stable_cnt;


/*** convert 14 bit adc to 32 bit format***/
// assign adc = (i_adc_data[ADC_BIT-1] == 1'b1)? {{32-ADC_BIT{1'b1}} , i_adc_data} : i_adc_data;

always@(posedge i_clk or negedge i_rst_n) begin
	if(!i_rst_n) begin
		r_polarity <= 1'b1;
		r_polarity2 <= 1'b1;
		r_err_offset <= 0;
		r_status <= 1'b0;
		r_avg_sel <= 3;
		r_freq_cnt <= 32'd10;
		r_adc <= 32'd0;
		r_trig <= 1'b0;
	end
	else begin
		r_polarity <= i_polarity;
		r_polarity2 <= r_polarity;
		r_err_offset <= i_err_offset;
		r_status <= i_status;
		r_avg_sel <= i_avg_sel;
		r_freq_cnt <= i_wait_cnt;
		// r_adc <= adc;
		r_adc <= {{24{i_adc_data[ADC_BIT-1]}}, i_adc_data[ADC_BIT-1:0]}; //sign bit extension to 32 bit
		r_trig <= i_trig;
	end
end

/*** next state logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) cstate <= RST;
    else cstate <= nstate;
end

/*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
	if(!i_rst_n) begin
		r_stable_cnt <= 32'd50;
		r_mv_cnt <= 32'd8;
		r_adc_sum <= 32'd0;
		r_err <= 32'd0;
		r_adc_new <= 32'd0;
		r_adc_old <= 32'd0;
		r_acq_done <= 1'b0;
		r_flip <= 1'b0;
		r_init <= 1'b1;
		r_stable <= 1'b0;
	end
	
	else begin
		case(cstate)
			RST: begin
				r_stable_cnt <= r_freq_cnt;
				r_flip <= 1'b0;
				r_init <= 1'b1;
				r_stable <= 1'b0;
				o_step_sync <= 1'b0;
				o_step_sync_dly <= 1'b0;
				o_ramp_sync <= 1'b0;
				o_rate_sync <= 1'b0;
				// r_adc_sum <= 32'd0;
			end

			WAIT_L_STATE: begin

			end

			WAIT_H_STATE: begin

			end

			WAIT_STABLE: begin
				r_mv_cnt <= 32'd32;
				r_acq_done <= 1'b0;
				r_adc_sum <= 32'd0;
				
				if(r_stable_cnt != 32'd0) r_stable_cnt <= r_stable_cnt - 1'b1;
				else r_stable <= 1'b1;
			end

			ACQ_INIT: begin
				r_stable_cnt <= r_freq_cnt;
				r_stable <= 1'b0;
				r_init <= 1'b0;
				
				if(r_mv_cnt != 32'd0) begin
					r_mv_cnt <= r_mv_cnt - 1'b1;
					r_adc_sum <= r_adc_sum + r_adc;
				end
				else begin
					r_adc_old <= (r_adc_sum >>> r_avg_sel); 
					r_acq_done <= 1'b1;
				end
			end

			ACQ_NEW: begin
				r_stable_cnt <= r_freq_cnt;
				r_stable <= 1'b0;
				
				if(r_mv_cnt != 32'd0) begin
					r_mv_cnt <= r_mv_cnt - 1'b1;
					r_adc_sum <= r_adc_sum + r_adc;
				end
				else begin
					r_adc_new <= (r_adc_sum >>> r_avg_sel); 
					r_acq_done <= 1'b1;
				end
			end

			ERR_GEN: begin
				if(!r_flip) begin
					r_err <= ((r_adc_new - r_adc_old) + r_err_offset);
					r_flip <= ~r_flip;
					// r_flip <= 1'b1;
				end
				else begin
					r_err <= ((r_adc_old - r_adc_new) + r_err_offset);
					r_flip <= ~r_flip;
					// r_flip <= 1'b0;
				end
				r_adc_old <= r_adc_new;
				o_step_sync <= 1'b1;
			end
			
			ERR_GEN_DLY: begin
				o_step_sync_dly <= 1'b1;
				o_step_sync <= 1'b0;
			end
			
			RATE_SYNC_GEN: begin
				o_rate_sync <= 1'b1;
				o_step_sync_dly <= 1'b0;
			end
			
			RAMP_SYNC_GEN: begin
				o_ramp_sync <= 1'b1;
				o_rate_sync <= 1'b0;
			end

			WAIT_NEXT: begin
				o_ramp_sync <= 1'b0;
			end	
		
			default: begin
			end
			
		endcase

	end
		
end
	
/*** state generator ***/

always@(*) begin
	if(~i_rst_n) begin
		nstate = RST;
	end

	else begin	
		case(cstate)
			RST: begin
				if(r_polarity) begin
					if(r_status == `HIGH) nstate = WAIT_L_STATE;
					else nstate = RST;
				end
				else begin
					if(r_status == `LOW) nstate = WAIT_H_STATE;
					else nstate = RST;
				end
			end

			WAIT_L_STATE: begin
				if(r_trig) nstate = WAIT_STABLE;
				else nstate = WAIT_L_STATE;
			end

			WAIT_H_STATE: begin
				if(r_trig) nstate = WAIT_STABLE;
				else nstate = WAIT_L_STATE;
			end

			WAIT_STABLE: begin
				if(r_stable) begin
					if(r_init == 1'b1) nstate = ACQ_INIT;
					else nstate = ACQ_NEW;
				end
				else nstate = WAIT_STABLE;
			end

			ACQ_INIT: begin
				if(r_acq_done) begin
					if(r_trig) nstate = WAIT_STABLE;
					else nstate = ACQ_INIT;
				end	
				else nstate = ACQ_INIT;
			end

			ACQ_NEW: begin
				if(r_acq_done) begin
					nstate = ERR_GEN;
				end		
				else nstate = ACQ_NEW;
			end

			ERR_GEN: begin
				nstate = ERR_GEN_DLY;
			end
			
			ERR_GEN_DLY: begin
				nstate = RATE_SYNC_GEN;
			end
			
			RATE_SYNC_GEN: begin
				nstate = RAMP_SYNC_GEN;
			end
			
			RAMP_SYNC_GEN: begin
				nstate = WAIT_NEXT;
			end

			WAIT_NEXT: begin
				if(r_trig) nstate = WAIT_STABLE;
				else nstate = WAIT_NEXT;
			end
			
			default: nstate = RST;

		endcase
		
		if(o_pol_change) nstate = RST;
		
	end

end


endmodule