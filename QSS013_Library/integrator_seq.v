module integrator_seq
(
    input i_clk,
	input i_rst_n,
    input [1:0] i_mode,
	input i_en,
    input [31:0] i_T1,
    input [31:0] i_T2,
    input [31:0] i_T3,
    input [31:0] i_T4,
    output reg o_sw,
    output reg o_cp
);

localparam MODE1 = 0;
localparam MODE2 = 1;
localparam MODE3 = 2;

reg [1:0] r_mode;
reg [31:0] r_t1, r_t2, r_t3;
reg [4:0] seq_SM;
reg [31:0] T1, T2, T3, T4;

always@(posedge i_clk) begin
    if(!i_rst_n) begin
		o_sw <= 0;
		o_cp <= 0;
        r_t1 <= 32'd0;
        r_t2 <= 32'd0;
        r_t3 <= 32'd0;
        r_mode <= MODE1;
        seq_SM <= 5'd0;
	end
    else begin
        r_mode <= i_mode;
        T1 <= i_T1;
        T2 <= i_T2;
        T3 <= i_T3;
        T4 <= i_T4;
        if(i_en) begin
            case(r_mode)
                MODE1: begin
                    case(seq_SM)
                        0: begin
                            if(r_t1 < (T1 - T4)) begin
                                o_sw <= 1'b1;
                                o_cp <= 1'b1;
                                r_t1 <= r_t1 + 1'b1;
                            end
                            else if(r_t1 < T1) begin
                                o_sw <= 1'b1;
                                o_cp <= 1'b0;
                                r_t1 <= r_t1 + 1'b1;
                            end
                            else begin
                                r_t1 <= 32'd0;
                                seq_SM <= 1;
                            end 
                        end
                        
                        1: begin
                            if(r_t3 < T3) begin
                                o_sw <= 1'b0;
                                o_cp <= 1'b0; 
                                r_t3 <= r_t3 + 1'b1;
                            end
                            else begin
                                seq_SM <= 2;
                                r_t3 <= 32'd0;
                            end
                        end
                        
                        2: begin
                            if(r_t2 < (T2 - T3)) begin
                                o_sw <= 1'b0;
                                o_cp <= 1'b1; 
                                r_t2 <= r_t2 + 1'b1;
                            end
                            else begin
                                r_t2 <= 32'd0;
                                seq_SM <= 0;
                            end
                        end
                    endcase
                end
            
                MODE2: begin
                    case(seq_SM)
                        0: begin
                            if(r_t1 < (T1 - T4)) begin
                                o_sw <= 1'b1;
                                o_cp <= 1'b0;
                                r_t1 <= r_t1 + 1'b1;
                            end
                            else if(r_t1 < T1) begin
                                o_sw <= 1'b1;
                                o_cp <= 1'b1;
                                r_t1 <= r_t1 + 1'b1;
                            end
                            else begin
                                r_t1 <= 32'd0;
                                seq_SM <= 1;
                            end 
                        end
                        
                        1: begin
                            if(r_t3 < T3) begin
                                o_sw <= 1'b0;
                                o_cp <= 1'b1; 
                                r_t3 <= r_t3 + 1'b1;
                            end
                            else begin
                                seq_SM <= 2;
                                r_t3 <= 32'd0;
                            end
                        end
                        
                        2: begin
                            if(r_t2 < (T2 - T3)) begin
                                o_sw <= 1'b0;
                                o_cp <= 1'b0; 
                                r_t2 <= r_t2 + 1'b1;
                            end
                            else begin
                                r_t2 <= 32'd0;
                                seq_SM <= 0;
                            end
                        end
                    endcase
                end

                MODE3: begin
                    o_cp <= 1'b0;
                    case(seq_SM)
                        0: begin
                            if(r_t1 < (T1 - T4)) begin
                                o_sw <= 1'b1;
                                r_t1 <= r_t1 + 1'b1;
                            end
                            else if(r_t1 < T1) begin
                                o_sw <= 1'b1;
                                r_t1 <= r_t1 + 1'b1;
                            end
                            else begin
                                r_t1 <= 32'd0;
                                seq_SM <= 1;
                            end 
                        end
                        
                        1: begin
                            if(r_t3 < T3) begin
                                o_sw <= 1'b0;
                                r_t3 <= r_t3 + 1'b1;
                            end
                            else begin
                                seq_SM <= 2;
                                r_t3 <= 32'd0;
                            end
                        end
                        
                        2: begin
                            if(r_t2 < (T2 - T3)) begin
                                o_sw <= 1'b0;
                                r_t2 <= r_t2 + 1'b1;
                            end
                            else begin
                                r_t2 <= 32'd0;
                                seq_SM <= 0;
                            end
                        end
                    endcase
                end
            
            endcase
        end
        else begin
            o_sw <= 0;
            o_cp <= 0;
            r_t1 <= 32'd0;
            r_t2 <= 32'd0;
            r_t3 <= 32'd0;
            seq_SM <= 5'd0;
        end
        
    end
end

endmodule