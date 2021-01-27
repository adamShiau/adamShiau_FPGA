module err_signal_gen(
input i_clk,
input i_rst_n,
input i_status,
input i_polarity,
input [31:0] i_wait_cnt,
input [31:0] i_err_offset_H,
input [13:0] i_adc_data,
input [2:0] i_avg_sel, 
input [31:0] i_err_th,
output reg signed [31:0] o_errsignal,
output signed [31:0] o_errsignal_w_th,
output reg o_err_done,

/*** for simulation ***/
output reg [31:0] o_mv_cnt,
output reg signed [31:0] o_adc_reg_H, o_adc_reg_L,
output signed [31:0] o_adc_H_sum, o_adc_L_sum,
output [3:0] o_cstate, o_nstate
);

//State machine
localparam WAIT_H_STATE = 0;
localparam STABLE_H = 1;
localparam ACQ_SIG_H = 2;
localparam WAIT_L_STATE = 3;
localparam STABLE_L = 4;
localparam ACQ_SIG_L = 5;
localparam ACQ_DONE = 6;
localparam ERR_DONE = 7;


//MV select
localparam MV_1 = 0;
localparam MV_2 = 1;
localparam MV_4 = 2;
localparam MV_8 = 3;
localparam MV_16 = 4;
localparam MV_32 = 5;
localparam MV_64 = 6;


`define LOW  1'b0
`define HIGH 1'b1

reg [3:0] cstate, nstate;
reg [31:0] stable_cnt, mv_cnt;
reg [2:0] shift;
reg signed [31:0] adc_H_sum, adc_L_sum;
reg acq_H_done, acq_L_done;
wire [31:0] adc;
wire signed [31:0] err_th_n, err_th_p;
wire signed [31:0] offset;

assign o_adc_H_sum = adc_H_sum;
assign o_adc_L_sum = adc_L_sum;

assign err_th_n = $signed(-i_err_th);
assign err_th_p = i_err_th;

assign offset = $signed(i_err_offset_H);

assign o_errsignal_w_th = ((o_errsignal > err_th_p) || (o_errsignal < err_th_n))? o_errsignal : 0;

assign o_cstate = cstate;
assign o_nstate = nstate;


/*** convert 14 bit adc to 32 bit format***/
assign adc = (i_adc_data[13] == 1'b1)? {{18{1'b1}} , i_adc_data} : i_adc_data;

always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        shift <= 3'd0;
        o_mv_cnt <= 32'd0;
    end
    else begin
        case(i_avg_sel)
            MV_1:  begin o_mv_cnt <= 32'd1;  shift <= MV_1; end
            MV_2:  begin o_mv_cnt <= 32'd2;  shift <= MV_2; end
            MV_4:  begin o_mv_cnt <= 32'd4;  shift <= MV_4; end
            MV_8:  begin o_mv_cnt <= 32'd8;  shift <= MV_8; end
            MV_16: begin o_mv_cnt <= 32'd16; shift <= MV_16; end 
            MV_32: begin o_mv_cnt <= 32'd32; shift <= MV_32; end
            MV_64: begin o_mv_cnt <= 32'd64; shift <= MV_64; end
        endcase
    end
end

/*** next state logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) cstate <= WAIT_H_STATE;
    else cstate <= nstate;
end

/*** state registor ***/
always@(*) begin
    if(~i_rst_n) begin
        nstate = WAIT_H_STATE;
    
    end
    else begin
        case(cstate)
            WAIT_H_STATE: begin
                if(i_status == `HIGH) nstate = STABLE_H;
                else nstate = WAIT_H_STATE;
            end
            
            STABLE_H: begin
                if(stable_cnt == 32'd0) nstate = ACQ_SIG_H;
                else nstate = STABLE_H;
            end
            
            ACQ_SIG_H: begin
                if(acq_H_done) nstate = WAIT_L_STATE;
                else nstate = ACQ_SIG_H;
            end
            
            WAIT_L_STATE: begin
                if(i_status == `LOW) nstate = STABLE_L;
                else nstate = WAIT_L_STATE;
            end
            
            STABLE_L: begin
                if(stable_cnt == 32'd0) nstate = ACQ_SIG_L;
                else nstate = STABLE_L;
            end
            
            ACQ_SIG_L: begin
                if(acq_L_done) nstate = ACQ_DONE;
                else nstate = ACQ_SIG_L;
            end
            
            ACQ_DONE: nstate = ERR_DONE;
			
			ERR_DONE: nstate = WAIT_H_STATE;
        
        endcase
    end

end

/*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        stable_cnt <= 32'd100;
        mv_cnt <= 32'd16;
        adc_H_sum <= 32'd0;
        adc_L_sum <= 32'd0;
		o_errsignal <= 32'd0;
    end
    else begin
        acq_H_done <= 1'b0;
        acq_L_done <= 1'b0;
        o_err_done <= 1'b0;
        case(cstate)
            WAIT_H_STATE: begin
                stable_cnt <= i_wait_cnt;
                mv_cnt <= o_mv_cnt;
                adc_H_sum <= 32'd0;
            end
            
            STABLE_H: begin
                if(stable_cnt != 32'd0) stable_cnt <= stable_cnt - 1'b1;
            end
            
            ACQ_SIG_H: begin
                if(mv_cnt != 32'd0) begin
                    mv_cnt <= mv_cnt - 1'b1;
                    adc_H_sum <= adc_H_sum + adc;
                end
                else begin  
                    o_adc_reg_H <= ((adc_H_sum >>> shift) + offset);
                    acq_H_done <= 1'b1;
                end
            end
            
            WAIT_L_STATE: begin
                stable_cnt <= i_wait_cnt;
                mv_cnt <= o_mv_cnt;
                adc_L_sum <= 32'd0;
            end
            
            STABLE_L: begin
                if(stable_cnt != 32'd0) stable_cnt <= stable_cnt - 1'b1;
            end
            
            ACQ_SIG_L: begin
                if(mv_cnt != 32'd0) begin
                    mv_cnt <= mv_cnt - 1'b1;
                    adc_L_sum <= adc_L_sum + adc;
                end
                else begin  
                    o_adc_reg_L <= (adc_L_sum >>> shift);
                    acq_L_done <= 1'b1;
                end
            end
            
            ACQ_DONE: begin
                if(!i_polarity) o_errsignal <= o_adc_reg_H - o_adc_reg_L;
                else o_errsignal <= o_adc_reg_L - o_adc_reg_H;
            end
			
			ERR_DONE: o_err_done <= 1'b1;
        endcase
    end


end
endmodule