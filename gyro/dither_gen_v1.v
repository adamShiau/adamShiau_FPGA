module dither_gen_v1
(
    input i_clk,
    input i_rst_n,
    input i_trig,
    input [31:0] i_wait_cnt,
    input [2:0] i_avg_sel, 
    output reg signed [31:0] o_data,
);

localparam LOW = -1;
localparam HIGH = 1;

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

reg r_trig;
reg [2:0] shift;
reg [31:0] r_wair_cnt;
reg [3:0] cstate, nstate;
reg signed [31:0] reg_sum, reg_data_H, reg_data_L;


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
			MV_128: begin o_mv_cnt <= 32'd64; shift <= MV_64; end
			MV_256: begin o_mv_cnt <= 32'd64; shift <= MV_64; end
			MV_512: begin o_mv_cnt <= 32'd64; shift <= MV_64; end
			MV_1024: begin o_mv_cnt <= 32'd64; shift <= MV_64; end
        endcase
    end
end


always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
        o_status <= LOW;
		o_stepTrig <= 1'b0;
        o_mod_out <= 0;
        SM <= LOW;
        freq_cnt <= 32'd125;
    end
    else begin
        case(SM)
            LOW: begin
                o_status <= LOW;
                o_mod_out <= amp_L;
                if(freq_cnt != 32'd0) freq_cnt <= freq_cnt - 1'b1;
                else begin
                    SM <= HIGH;
                    freq_cnt <= i_freq_cnt;
                end
				// if(freq_cnt != (i_freq_cnt - TRIGHOLD)) o_stepTrig <= 1'b0;
				// else o_stepTrig <= 1'b1;
				if(freq_cnt == i_freq_cnt) o_stepTrig <= 1'b1;
				else o_stepTrig <= 1'b0;
            end
            
            HIGH: begin
                o_status <= HIGH;
                o_mod_out <= amp_H;
                if(freq_cnt != 32'd1) freq_cnt <= freq_cnt - 1'b1;
                else begin
                    SM <= LOW;
                    freq_cnt <= i_freq_cnt;
                end
				// if(freq_cnt != (i_freq_cnt - TRIGHOLD)) o_stepTrig <= 1'b1;
				// else o_stepTrig <= 1'b0;
				if(freq_cnt == i_freq_cnt) o_stepTrig <= 1'b1;
				else o_stepTrig <= 1'b0;
            end
        
        endcase
    end
end

endmodule