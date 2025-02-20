module my_sync_gen (
    input logic i_clk,
    input logic i_rst_n,
    input logic [31:0] i_sync_count,
    output logic o_sync_out
);

    logic [31:0] counter;
	 
	 always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            counter <= 0;
            o_sync_out <= 0;
        end 
        else begin
            if (i_sync_count == 0) begin
                counter <= 0;
                o_sync_out <= 0;
            end
            else if (counter == i_sync_count -1) begin
                counter <= 0;
                o_sync_out <= ~o_sync_out;
            end 
            else begin
                counter <= counter + 1;
            end
        end
    end
    
//    always_ff @(posedge i_clk or negedge i_rst_n) begin
//        if (!i_rst_n) begin
//            counter <= 0;
//            o_sync_out <= 0;
//        end 
//        else begin
//            if (i_sync_count == 0) begin
//                counter <= 0;
//                o_sync_out <= 0;
//            end
//            else if (counter < i_sync_count) begin
//                counter <= counter + 1;
//                o_sync_out <= 0;
//            end 
//            else begin
//                counter <= 0;
//                o_sync_out <= 1;
//            end
//        end
//    end
    
endmodule
