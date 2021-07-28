module Kalman_filter_SM
(
	input i_clk,
	input i_rst_n,
	input signed [9:0] i_meas,
	input [31:0] i_kal_Q, i_kal_R,
	output reg signed [31:0] x_out, p_out
	/*** monitor ***/
	, output signed [31:0] monitor0
	, output signed [31:0] monitor1
	, output signed [31:0] monitor2
	, output signed [31:0] monitor3
);

//State machine
localparam INIT 	= 4'd0;
localparam PREDICT 	= 4'd1;
localparam MEASURE 	= 4'd2;
localparam K_GAIN 	= 4'd3;
localparam UPDATE 	= 4'd4;
localparam OUTPUT 	= 4'd5;
localparam K_GAIN_NOP = 4'd6; 
localparam UPDATE_NOP = 4'd7;

wire signed [31:0] measurement, p_now, x_now;

reg [3:0] cstate, nstate;
reg [31:0] r_kal_Q, r_kal_R;
reg clken_K_gain, clken_update_p, clken_update_x;
reg signed [31:0] x_pre, p_pre;
reg signed [31:0] err, r_meas;
reg signed [31:0] k;
wire signed [63:0] k_temp;
wire signed [31:0] k_mon;
wire signed [31:0] div_up, div_down;

assign measurement = (i_meas[9] == 1'b1)? {{22{1'b1}} , i_meas} : i_meas;
assign k_mon = k;
assign div_up = p_pre <<< 13;
assign div_down = p_pre + r_kal_R;
assign monitor0 = r_meas;

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
			
			K_GAIN: nstate = K_GAIN_NOP;
			
			K_GAIN_NOP: nstate = UPDATE;
			
			UPDATE: nstate = UPDATE_NOP;
			
			UPDATE_NOP: nstate = OUTPUT;
			
			OUTPUT: nstate = PREDICT;
			
			
        
        endcase
    end

end

/*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
		x_out <= 32'd0;
		p_out <= 32'd100000;
		clken_K_gain <= 1'b0;
		clken_update_p <= 1'b0;
		clken_update_x <= 1'b0;
    end
    else begin
        case(cstate)
            INIT: begin
				x_out <= 32'd0;
				p_out <= 32'd100000;
            end
			
			PREDICT: begin
				x_pre <= x_out;
				p_pre <= p_out + r_kal_Q;
			end
			
			K_GAIN: begin
				clken_K_gain <= 1'b1;
				err <= r_meas - x_pre;
			end
			
			K_GAIN_NOP: begin
				k <= k_temp[63:32];
			end
			
			UPDATE: begin
				clken_K_gain <= 1'b0;
				clken_update_p <= 1'b1;
				clken_update_x <= 1'b1;
			end
			
			UPDATE_NOP: begin
			end
			
			OUTPUT: begin
				clken_update_p <= 1'b0;
				clken_update_x <= 1'b0;
				p_out <= p_now >> 13;
				x_out <= x_pre + (x_now >>> 13);
			end
			
        endcase
    end


end

div32_kal_v2 div_K_gain (
  .aclk(i_clk),                                      // input wire aclk
  .aclken(clken_K_gain),                                  // input wire aclken
  .aresetn(i_rst_n),                                // input wire aresetn
  .s_axis_divisor_tvalid(1'b1),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(p_pre + r_kal_R),      // input wire [31 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(1'b1),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(p_pre <<< 13),    // input wire [31 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(k_temp)            // output wire [63 : 0] m_axis_dout_tdata
);

mult32_kal_v2 mult_update_p (
  .CLK(i_clk),    // input wire CLK
  .A(32'd8192 - k),        // input wire [31 : 0] A
  .B(p_pre),        // input wire [31 : 0] B
  .CE(clken_update_p),      // input wire CE
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(p_now)        // output wire [63 : 0] P
);

mult32_kal_v2 mult_update_x (
  .CLK(i_clk),    // input wire CLK
  .A(k),        // input wire [31 : 0] A
  .B(err),        // input wire [31 : 0] B
  .CE(clken_update_x),      // input wire CE
  .SCLR(~i_rst_n),  // input wire SCLR
  .P(x_now)        // output wire [63 : 0] P
);

endmodule