module my_timer 
#(parameter COUNTER_NUM = 10000)
(
    input logic i_clk,
    input logic i_rst_n,
    input logic i_timer_rst,
    output logic [31:0] o_timer
);

logic [31:0] counter;

always_ff @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        counter <= 0;
        o_timer <= 0;
    end else if (i_timer_rst) begin
        counter <= 0;
        o_timer <= 0;
    end else begin
        if (counter < COUNTER_NUM - 1) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
            o_timer <= o_timer + 1;
        end
    end
end
endmodule
