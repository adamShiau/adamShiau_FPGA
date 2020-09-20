module integrator_vth_v2
#(parameter EXT_SIG_BIT = 16)
(
input i_clk,
input i_rst_n,
input [5:0] i_gain_sel,
input [31:0] i_err,
input i_en,
input i_zero,
input i_add_sig_en,
input i_gain_mode,
input [EXT_SIG_BIT-1:0] i_ext_sig,
input [31:0] i_saturation,
input [31:0] i_vth,
input i_vth_cut_mode,

output signed [31:0] o_int

/*** for simulation ***/
, output [31:0] o_sat_p
, output [31:0] o_sat_n
, output [3:0] o_cstate
, output [3:0] o_nstate
, output [31:0] o_dv
, output [31:0] o_vo
, output o_change 
, output [4:0] o_shift_idx
, output o_sat_flag_p
, output o_sat_flag_n
, output o_limit_flag_p
, output o_limit_flag_n
// , output o_err_pol_change
, output o_zero_flag
, output o_vth_flag_p
, output o_vth_flag_n
, output [31:0] o_vth_cut_p
, output [31:0] o_vth_cut_n
);

wire signed [31:0] ext_sig;
wire signed [31:0] err;
wire signed [31:0] integrator_out;
reg [5:0] gain_sel_temp;
wire change;
reg [4:0] shift_idx;
reg [3:0] cstate, nstate;
reg signed [31:0] vo;
reg signed [31:0] dv;
wire signed [31:0] sat_p, sat_n;
wire signed [31:0] vth_p, vth_n;
wire signed [31:0] vth_cut_p, vth_cut_n;
wire signed [31:0] INT_LIMIT_P, INT_LIMIT_N;
wire sat_flag_p, sat_flag_n;
wire limit_flag_p, limit_flag_n;
wire vth_flag_p, vth_flag_n;
reg zero_flag;

/*** state machine***/
localparam NORMAL   = 4'd0;
localparam CAL_DIFF = 4'd1;
localparam SATURATION_P = 4'd2;
localparam SATURATION_N = 4'd3;
localparam THRESHOLD_P = 4'd4;
localparam THRESHOLD_N = 4'd5;
localparam THRESHOLD_P_DELAY = 4'd6;
localparam THRESHOLD_N_DELAY = 4'd7;
localparam LIMIT_SATURATION_P = 4'd8;
localparam LIMIT_SATURATION_N = 4'd9;

/*** define original integrator maximun value，signed 32bit range -2^31~2^31-1 = -2147483648~2147483647***/
`define INT_LIMIT 32'd2_000_000_000
assign INT_LIMIT_P = `INT_LIMIT;
assign INT_LIMIT_N = $signed(-`INT_LIMIT);
assign limit_flag_p = ((vo >= INT_LIMIT_P)&&!i_err[31])? 1'b1 : 1'b0; //if vo exceeds INT_LIMIT and err signal is positive
assign limit_flag_n = ((vo <= INT_LIMIT_N)&& i_err[31])? 1'b1 : 1'b0; //if vo exceeds -INT_LIMIT and err signal is negative

/*** define integrator saturation value， accept user input value***/
assign sat_p = i_saturation;
assign sat_n = $signed(-i_saturation);

assign sat_flag_p = ((integrator_out >= sat_p)&&!i_err[31])? 1'b1 : 1'b0; //if integrator exceeds i_saturation and err signal is positive
assign sat_flag_n = ((integrator_out <= sat_n)&& i_err[31])? 1'b1 : 1'b0; //if integrator exceeds -i_saturation and err signal is negative

/*** gain change signal***/
assign change = (i_gain_sel != gain_sel_temp)? 1'b1 : 1'b0;

assign o_int = (i_add_sig_en)? (integrator_out + ext_sig) : integrator_out;

assign integrator_out = (cstate == NORMAL)? ((vo >>> shift_idx) + dv) : integrator_out;

/*** convert ext_sig to 32 bit format***/
assign ext_sig = (i_ext_sig[EXT_SIG_BIT-1] == 1'b1)? {{32-EXT_SIG_BIT{1'b1}}, i_ext_sig} : i_ext_sig;


/*** define vth value and signal ***/
assign vth_flag_p = ((integrator_out > vth_p)&&(cstate == NORMAL))? 1'b1 : 1'b0;
assign vth_flag_n = ((integrator_out < vth_n)&&(cstate == NORMAL) )? 1'b1 : 1'b0;
assign vth_p = i_vth;
assign vth_n = $signed(-i_vth);
assign vth_cut_p = (i_vth_cut_mode)? vth_p*2 : vth_p;
assign vth_cut_n = (i_vth_cut_mode)? vth_n*2 : vth_n;

/*** for simulation ***/
assign o_sat_p = sat_n;
assign o_sat_n = sat_n;
assign o_cstate = cstate;
assign o_nstate = nstate;
assign o_dv = dv;
assign o_vo = vo;
assign o_change = change;
assign o_shift_idx = shift_idx;
assign o_sat_flag_p = sat_flag_p;
assign o_sat_flag_n = sat_flag_n;
assign o_limit_flag_p = limit_flag_p;
assign o_limit_flag_n = limit_flag_n;
// assign o_err_pol_change = err_pol_change;
assign o_zero_flag = zero_flag;
assign o_vth_cut_p = vth_cut_p;
assign o_vth_cut_n = vth_cut_n;
assign o_vth_flag_p = vth_flag_p;
assign o_vth_flag_n = vth_flag_n;
/*****************************************/

always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
        gain_sel_temp <= i_gain_sel;
        shift_idx <= 5'd5;
    end
    else begin
        gain_sel_temp <= i_gain_sel;
        case(gain_sel_temp) //delay one clk for timing
            0:  shift_idx <= 5'd0;
            1:  shift_idx <= 5'd1;
            2:  shift_idx <= 5'd2;
            3:  shift_idx <= 5'd3;
            4:  shift_idx <= 5'd4;
            5:  shift_idx <= 5'd5;
            6:  shift_idx <= 5'd6;
            7:  shift_idx <= 5'd7;
            8:  shift_idx <= 5'd8;
            9:  shift_idx <= 5'd9;
            10: shift_idx <= 5'd10;
            11: shift_idx <= 5'd11;
            12: shift_idx <= 5'd12;
            13: shift_idx <= 5'd13;
            14: shift_idx <= 5'd14;
            15: shift_idx <= 5'd15;
            default: shift_idx <= 5'd5;
        endcase
    end
end

always@(posedge i_clk) begin
    cstate <= nstate;
end

always@(*) begin
    if(~i_rst_n) begin
        nstate = NORMAL;
    end
    else begin
        case(cstate)
            NORMAL: begin
                if(change) nstate = CAL_DIFF;
                else if(sat_flag_p) nstate = SATURATION_P;
                else if(sat_flag_n) nstate = SATURATION_N;
                else if(vth_flag_p) nstate = THRESHOLD_P;
                else if(vth_flag_n) nstate = THRESHOLD_N;
                else if(limit_flag_p) nstate = LIMIT_SATURATION_P;
                else if(limit_flag_n) nstate = LIMIT_SATURATION_N;              
                else nstate = NORMAL;
            end
            
            CAL_DIFF: begin
                if(sat_flag_p) nstate = SATURATION_P;
                else if(sat_flag_n) nstate = SATURATION_N;
                else if(limit_flag_p) nstate = LIMIT_SATURATION_P;
                else if(limit_flag_n) nstate = LIMIT_SATURATION_N;
                else nstate = NORMAL;
            end
            
            SATURATION_P: begin
				if(!sat_flag_p) nstate = NORMAL;
				else if(change) nstate = CAL_DIFF;
            end
            
            SATURATION_N: begin
				if(!sat_flag_n) nstate = NORMAL;
				else if(change) nstate = CAL_DIFF;
            end
            
            THRESHOLD_P: nstate = NORMAL;
            
            THRESHOLD_N: nstate = NORMAL;
            
            LIMIT_SATURATION_P: begin 
				if(!limit_flag_p) nstate = NORMAL;
				else if(change) nstate = CAL_DIFF;
            end
            
            LIMIT_SATURATION_N: begin
				if(!limit_flag_n) nstate = NORMAL;
				else if(change) nstate = CAL_DIFF;
            end
        endcase
    end
end

/*** original integrator ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
        vo <= 32'd0;
		dv <= 32'd0;
    end
    else begin
        if(i_zero) begin
            vo <= 32'd0;
        end
        else begin
                case(cstate)
                    NORMAL:	if(i_en) vo <= vo + i_err;   
                    
                    CAL_DIFF: if(i_gain_mode) dv <= integrator_out - (vo >>> i_gain_sel);
                    
                    SATURATION_P: vo <= (sat_p <<< shift_idx - (dv <<< shift_idx)) ;
                    
                    SATURATION_N: vo <= (sat_n <<< shift_idx - (dv <<< shift_idx)) ;
                    
                    THRESHOLD_P: vo <= vo - (vth_cut_p <<< shift_idx);
                    
                    THRESHOLD_N: vo <= vo - (vth_cut_n <<< shift_idx);
                    
                    LIMIT_SATURATION_P: vo <= (INT_LIMIT_P); 
                
                    LIMIT_SATURATION_N: vo <= (INT_LIMIT_N); 
                endcase
        end
    end
end

endmodule