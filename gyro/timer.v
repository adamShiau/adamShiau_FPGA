module timer
#(parameter COUNTER_NUM = 10000)
(
input i_clk,
input i_rst_n,
input i_timer_rst,
output reg [31:0] o_timer
);

reg [31:0] timer_cnt;

always@(posedge i_clk or negedge i_rst_n) begin
    if(~i_rst_n) begin
        timer_cnt <= COUNTER_NUM;
        o_timer <= 32'd0;
    end
    else begin
        if(i_timer_rst) begin
            timer_cnt <= COUNTER_NUM;
            o_timer <= 32'd0;
        end
        else begin
            if(timer_cnt != 32'd1) timer_cnt <= timer_cnt - 1'b1;
            else begin
                timer_cnt <= COUNTER_NUM;
                o_timer <= o_timer + 1'b1;
            end
        end
    end

end
endmodule