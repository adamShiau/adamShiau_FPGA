module feedback_step_gen_v5 (
    input i_clk,
    input i_rst_n,
    input i_trig,
    input i_trig_dly,
    input signed [31:0] i_err,
    input [31:0] i_gain_sel,
    input [31:0] i_fb_ON,
    input signed [31:0] i_const_step,
    output signed [31:0] o_step

    // For simulation only
`ifdef SIMULATION
    , output [31:0] o_fb_ON,
    output signed [31:0] o_step_pre,
    output [31:0] o_gain_sel,
    output [31:0] o_gain_sel2,
    output [1:0] o_status,
    output o_change,
    output signed [31:0] o_step_init 
`endif
);

// Internal registers
reg [31:0] reg_gain_sel, reg_gain_sel2;
reg reg_trig;
reg [31:0] reg_fb_ON;
reg [1:0] r_status;
reg signed [31:0] reg_err;
reg signed [31:0] reg_step, reg_step_pre;

wire [4:0] shift_amt = reg_gain_sel[4:0]; // 限制 shift 範圍

assign o_step = reg_step;

`ifdef SIMULATION
    assign o_gain_sel = reg_gain_sel;
    assign o_gain_sel2 = reg_gain_sel2;
    assign o_status = r_status;
    assign o_fb_ON = reg_fb_ON;
    assign o_step_pre = reg_step_pre;
    assign o_change = |(reg_gain_sel2[3:0] ^ reg_gain_sel[3:0]);
    assign o_step_init = reg_step; // 簡化 o_step_init 的設計
`endif

always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        reg_err <= 32'd0;
        reg_gain_sel <= 32'd5;
        reg_fb_ON <= 32'd0;
        reg_trig <= 1'b0;
    end else begin
        reg_err <= i_err;
        reg_gain_sel <= i_gain_sel;
        reg_fb_ON <= i_fb_ON;
        reg_trig <= i_trig;
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if (~i_rst_n) begin
        reg_step <= 32'd0;
        reg_step_pre <= 32'd0;
        reg_gain_sel2 <= 32'd5;
    end else begin
        case (reg_fb_ON[1:0])
            2'd0: begin
                reg_step <= 32'd0;
                reg_step_pre <= 32'd0;
            end
            2'd1: begin
                if (i_trig)
                    reg_step_pre <= reg_step_pre + reg_err;
                else if (i_trig_dly)
                    reg_step <= reg_step_pre >>> shift_amt;
            end
            2'd2: begin
                if (i_trig)
                    reg_step <= i_const_step;
            end
            default: begin
                reg_step <= 32'd0;
                reg_step_pre <= 32'd0;
            end
        endcase
    end
end

endmodule
