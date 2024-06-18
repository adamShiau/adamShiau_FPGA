/*** 
dither_gen_v2, 
1. Add self trigger signal inside the module.
2. Add register input for dither_high and dither_low from outside the module.
***/
module dither_gen_v2
(
    input i_clk,
    input i_rst_n,
    input [31:0] i_dither_high,
    input [31:0] i_dither_low,
    input [31:0] i_period_cnt, 
    input [31:0] i_wait_cnt,
    input [31:0] i_avg_sel, 
    input [31:0] i_data,
    output signed [31:0] o_data,
    output signed [31:0] o_dither_out

    /*** for simulation ***/
    , output signed [31:0] o_reg_data_H
    , output signed [31:0] o_reg_data_L
    , output signed [31:0] o_reg_sum
    , output [3:0] o_cstate, o_nstate
);

//State machine
localparam RST           = 	0;
localparam DITHER_H      = 	1;
localparam WAIT_STABLE_H = 	2;
localparam ACQ_H         = 	3;
localparam DITHER_L      = 	4;
localparam WAIT_STABLE_L = 	5;
localparam ACQ_L         = 	6;
localparam OUT_GEN       = 	7;


//MV select
localparam MV_1 = 		0;
localparam MV_2 = 		1;
localparam MV_4 = 		2;
localparam MV_8 = 		3;
localparam MV_16 = 		4;
localparam MV_32 = 		5;
localparam MV_64 = 		6;
localparam MV_128 = 	7;
localparam MV_256 = 	8;
localparam MV_512 = 	9;
localparam MV_1024 = 	10;
localparam MV_2048 = 	11;
localparam MV_4096 = 	12;

reg trig;
reg [31:0] period_cnt;
reg [3:0] shift;
reg [31:0] wait_cnt, mv_cnt, avg_sel;
reg [3:0] cstate, nstate;
reg signed [31:0] reg_sum, reg_data_H, reg_data_L, reg_i_data, reg_o_data, dither_out;
reg signed [31:0] dither_high, dither_low;
reg stable, acq_done;
reg [31:0] trig_cnt;

assign o_data = reg_o_data;
assign o_dither_out = dither_out;
assign o_cstate = cstate;
assign o_nstate = nstate;
assign o_reg_data_H = reg_data_H;
assign o_reg_data_L = reg_data_L;
assign o_reg_sum = reg_sum;

/*** self trig module***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        period_cnt <= 32'd100;
    end
    else begin
        if(period_cnt != 32'd0) begin
            period_cnt <= i_period_cnt - 1'b1;
            trig <= 1'b0;
        end
        else begin
            period_cnt <= i_period_cnt;
            trig <= 1'b1;
        end
    end
end




always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        avg_sel     <= 32'd0;
        shift       <= 4'd0;
        mv_cnt      <= 32'd0;
        wait_cnt    <= 32'd0;
        reg_i_data  <= 32'd0;
        dither_high <= 32'd20;
        dither_low  <= -32'd20;
    end
    else begin
        avg_sel     <= i_avg_sel;
        wait_cnt    <= i_wait_cnt;
        reg_i_data  <= i_data;
        dither_high <= i_dither_high;
        dither_low  <= i_dither_low;
        case(avg_sel)
            MV_1:    begin mv_cnt <= 32'd1;     shift <= MV_1;      end
            MV_2:    begin mv_cnt <= 32'd2;     shift <= MV_2;      end
            MV_4:    begin mv_cnt <= 32'd4;     shift <= MV_4;      end
            MV_8:    begin mv_cnt <= 32'd8;     shift <= MV_8;      end
            MV_16:   begin mv_cnt <= 32'd16;    shift <= MV_16;     end 
            MV_32:   begin mv_cnt <= 32'd32;    shift <= MV_32;     end
            MV_64:   begin mv_cnt <= 32'd64;    shift <= MV_64;     end
            MV_128:  begin mv_cnt <= 32'd128;   shift <= MV_128;    end
			MV_256:  begin mv_cnt <= 32'd256;   shift <= MV_256;    end
			MV_512:  begin mv_cnt <= 32'd512;   shift <= MV_512;    end
			MV_1024: begin mv_cnt <= 32'd1024;  shift <= MV_1024;   end
            MV_2048: begin mv_cnt <= 32'd2048;  shift <= MV_2048;   end
            MV_4096: begin mv_cnt <= 32'd4096;  shift <= MV_4096;   end
            default: begin mv_cnt <= 32'd128;   shift <= MV_128;    end
        endcase
    end
end

/*** next state logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) cstate <= RST;
    else cstate <= nstate;
end

/*** state registor ***/
always@(*) begin
    if(~i_rst_n) begin
        nstate = RST;
    end
    else begin
        case(cstate)
            RST: begin
                if(trig) nstate = DITHER_H;
                else     nstate = RST;
            end
            DITHER_H: begin
                nstate = WAIT_STABLE_H;
            end
            WAIT_STABLE_H: begin
                if(stable) nstate = ACQ_H;
                else nstate = WAIT_STABLE_H;
            end
            ACQ_H: begin
                if(acq_done) nstate = DITHER_L;
                else nstate = ACQ_H;
            end
            DITHER_L: begin
                nstate = WAIT_STABLE_L;
            end
            WAIT_STABLE_L: begin
                if(stable) nstate = ACQ_L;
                else nstate = WAIT_STABLE_L;
            end
            ACQ_L: begin
                if(acq_done) nstate =OUT_GEN;
                else nstate = ACQ_L;
            end
            OUT_GEN: begin
                nstate = DITHER_H;
            end
            default: nstate = RST;
        endcase
    end

end

/*** output logic ***/
always@(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        stable <= 1'b0;
        dither_out <= 32'd0;
        trig_cnt <= 32'd0;
        reg_o_data <= 32'd0;
    end
    else begin
        case(cstate)
            RST: begin
                stable <= 1'b0;
                acq_done <= 1'b0;
                trig_cnt <= 32'd0;
                reg_sum <= 32'd0;
                reg_data_H <= 32'd0;
                reg_data_L <= 32'd0;
            end
            DITHER_H: begin
                dither_out <= dither_high;
            end
            WAIT_STABLE_H: begin
                if(trig) trig_cnt <= trig_cnt + 1'b1;
                else trig_cnt <= trig_cnt;

                if(trig_cnt == wait_cnt) begin
                    trig_cnt <= mv_cnt;
                    stable <= 1'b1;
                end
            end
            ACQ_H: begin
                stable <= 1'b0;

                if(trig) trig_cnt <= trig_cnt - 1'b1;
                else trig_cnt <= trig_cnt;

                if(trig_cnt != 32'd0) begin
                    if(trig) reg_sum <= reg_sum + reg_i_data;
                end
                else begin
                    acq_done <= 1'b1;
                    reg_data_H <= reg_sum >>> avg_sel;
                end
            end
            DITHER_L: begin
                acq_done <= 1'b0;
                reg_sum <= 32'd0;
                dither_out <= dither_low;
            end
            WAIT_STABLE_L: begin
                if(trig) trig_cnt <= trig_cnt + 1'b1;
                else trig_cnt <= trig_cnt;

                if(trig_cnt == wait_cnt) begin
                    trig_cnt <= mv_cnt;
                    stable <= 1'b1;
                end
            end
            ACQ_L: begin
                stable <= 1'b0;

                if(trig) trig_cnt <= trig_cnt - 1'b1;
                else trig_cnt <= trig_cnt;

                if(trig_cnt != 32'd0) begin
                    if(trig) reg_sum <= reg_sum + reg_i_data;
                end
                else begin
                    acq_done <= 1'b1;
                    reg_data_L <= reg_sum >>> avg_sel;
                end
            end
            OUT_GEN: begin
                acq_done <= 1'b0;
                reg_sum <= 32'd0;
                reg_o_data <= (reg_data_H + reg_data_L) >>> 1 ;
            end
            default: begin
            end
        endcase
    end
end


endmodule