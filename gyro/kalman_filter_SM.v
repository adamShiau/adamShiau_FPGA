module Kalman_filter_SM
(
	input i_clk,
	input i_rst_n,
	input signed [13:0] i_meas,
	input [31:0] i_kal_Q, i_kal_R,
	output reg signed [31:0] x_out, p_out
);

`define K_CNT 11

//State machine
localparam INIT 	= 4'd0;
localparam PREDICT 	= 4'd1;
localparam K_GAIN 	= 4'd2; 
localparam UPDATE 	= 4'd3;

wire signed [31:0] measurement, p_now_temp, x_now_temp;
wire signed [31:0] p_now, x_now;

reg [3:0] cstate, nstate;
reg [31:0] r_kal_Q, r_kal_R;
reg clken_K_gain, clken_update_p, clken_update_x;
reg signed [31:0] x_pre, p_pre, p_plus_R, p_shift;
reg signed [31:0] err, r_meas;
reg signed [31:0] k, one_mius_k;
wire signed [31:0] k_temp;
reg [5:0] k_cnt, update_cnt;
reg k_finish_flag, update_finish_flag;
wire K_gain_data_valid, divisor_tready, dividend_tready;

assign measurement = (i_meas[13] == 1'b1)? {{18{1'b1}} , i_meas} : i_meas;

always@(posedge i_clk or negedge i_rst_n) begin
	if (!i_rst_n) begin
		r_kal_Q <= 32'd0;
		r_kal_R <= 32'd0;
		r_meas <= 32'd0;
	end
	else begin
		r_kal_Q <= i_kal_Q;
		r_kal_R <= i_kal_R;
		r_meas 	<= measurement;
	end
end

/*** next state logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) cstate <= INIT;
    else cstate <= nstate;
end

/*** state registor ***/
always@(*) begin
    if(!i_rst_n) begin
        nstate = INIT;
    
    end
    else begin
        case(cstate)
            INIT: begin 
                if(i_rst_n) nstate = PREDICT;
                else nstate = INIT;
            end
			
            PREDICT: nstate = K_GAIN;
			
			K_GAIN: begin
				if(k_finish_flag) nstate = UPDATE;
				else nstate = K_GAIN;
			end
			UPDATE: nstate = PREDICT;
			
        endcase
    end
end

/*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
		x_out <= 32'd0;
		p_out <= 32'd100000;
		x_pre <= 32'd0; 
		p_pre <= 32'd0;
		err <= 32'd0;
		k <= 32'd0;
		one_mius_k <= 32'd0;
		clken_K_gain <= 1'b1;
		clken_update_p <= 1'b0;
		clken_update_x <= 1'b0;
		k_cnt <= `K_CNT;
		// update_cnt <= 6'd2;
		k_finish_flag <= 1'b0;
		update_finish_flag <= 1'b0;
		p_plus_R <= 32'd0;
		p_shift <= 32'd0;
    end
    else begin
        case(cstate)
            INIT: begin //0
				x_out <= 32'd0;
				p_out <= 32'd100000;
            end
			
			PREDICT: begin //1
				x_pre <= x_out;
				p_pre <= p_out + r_kal_Q;
			end
			
			K_GAIN: begin //2
				err <= r_meas - x_pre;
				p_plus_R <= p_pre + r_kal_R;
				p_shift <= p_pre << 13;
				if(k_cnt != 6'd1) k_cnt <= k_cnt - 6'd1;
				else if(K_gain_data_valid) begin
					k_finish_flag <= 1'b1;
					one_mius_k <= 32'd8192 - k_temp;
					k <= k_temp;
				end
				else k_finish_flag <= 1'b0;
			end
			
			UPDATE: begin //3
				k_cnt <= `K_CNT;
				k_finish_flag <= 1'b0;
				update_finish_flag <= 1'b0;
				p_out <= p_now >> 13;
				x_out <= x_pre + (x_now >>> 13);
			end
        endcase
    end


end

div32_kal_HR div_K_gain (
  .aclk(i_clk),                                      // input wire aclk
  .aclken(1'b1),                                  // input wire aclken
  .aresetn(i_rst_n),                                // input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tready(divisor_tready),    // output wire s_axis_divisor_tready
  .s_axis_divisor_tdata(p_plus_R),      // input wire [31 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tready(dividend_tready),  // output wire s_axis_dividend_tready
  .s_axis_dividend_tdata(p_shift),    // input wire [31 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(K_gain_data_valid),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(k_temp)            // output wire [31 : 0] m_axis_dout_tdata
);

mult32_kal_v2 mult_update_p (
  .CLK(i_clk),    // input wire CLK
  .A(one_mius_k),        // input wire [31 : 0] A
  .B(p_pre),        // input wire [31 : 0] B
  .CE(1'b1),      // input wire CE
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(p_now)        // output wire [63 : 0] P
);

mult32_kal_v2 mult_update_x (
  .CLK(i_clk),    // input wire CLK
  .A(k),        // input wire [31 : 0] A
  .B(err),        // input wire [31 : 0] B
  .CE(1'b1),      // input wire CE
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(x_now)        // output wire [63 : 0] P
);

endmodule