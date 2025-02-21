module my_sync_gen (
    input logic i_clk,
    input logic i_rst_n,
    input logic [31:0] i_sync_count,
    output logic o_sync_out
);

	logic [31:0] sync_count_reg;
	
	always_ff @(posedge i_clk or negedge i_rst_n) begin
		 if (!i_rst_n) begin
			  sync_count_reg <= 32'd500000;
		 end 
		 else begin
			  sync_count_reg <= i_sync_count;
		 end
	end


    logic [31:0] counter;
	 
	 always_ff @(posedge i_clk or negedge i_rst_n) begin
		 if (!i_rst_n) begin
			  counter <= 0;
			  o_sync_out <= 0;
		 end 
		 else if (i_sync_count != sync_count_reg) begin
			  counter <= 0; 
		 end
		 else if (counter == sync_count_reg - 1) begin
			  counter <= 0;
			  o_sync_out <= ~o_sync_out;
		 end 
		 else begin
			  counter <= counter + 1;
		 end
	end

    
    
endmodule
