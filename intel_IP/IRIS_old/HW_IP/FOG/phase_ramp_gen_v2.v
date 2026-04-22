module phase_ramp_gen_v2 #(
    parameter OUTPUT_BIT = 32
)(
    input i_clk,
    input i_rst_n,
    input i_rate_trig,
    input i_ramp_trig,
    input i_mod_trig,
    input signed [31:0] i_step,
    input [31:0] i_fb_ON,
    input signed [31:0] i_mod,
    input [31:0] i_gain_sel,

    output signed [OUTPUT_BIT-1:0] o_phaseRamp_pre,
    output reg signed [OUTPUT_BIT-1:0] o_phaseRamp

`ifdef SIMULATION
    , output [31:0] o_gain_sel,
    output [31:0] o_gain_sel2,
    output [1:0] o_status,
    output o_change,
    output signed [31:0] o_ramp_init
`endif
);

// Parameters
localparam GAIN_INIT = 5;

// Registers
reg [31:0] reg_gain_sel, reg_gain_sel2;
reg [31:0] reg_fb_ON;
reg signed [31:0] reg_step;
reg signed [31:0] reg_ramp, reg_ramp_pre;

assign o_phaseRamp_pre = reg_ramp_pre;

`ifdef SIMULATION
    assign o_gain_sel = reg_gain_sel;
    assign o_gain_sel2 = reg_gain_sel2;
    assign o_status = 2'd0;
    assign o_change = |(reg_gain_sel2[3:0] ^ reg_gain_sel[3:0]);
    assign o_ramp_init = reg_ramp;
`endif

// Input Registers
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        reg_gain_sel <= GAIN_INIT;
        reg_gain_sel2 <= GAIN_INIT;
        reg_fb_ON <= 32'd0;
        reg_step <= 32'd0;
    end else begin
        reg_gain_sel <= i_gain_sel;
        reg_gain_sel2 <= reg_gain_sel;  // latch for change detection
        reg_fb_ON <= i_fb_ON;
        reg_step <= i_step;
    end
end

// Ramp Logic
always @(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        reg_ramp <= 32'd0;
        reg_ramp_pre <= 32'd0;
        o_phaseRamp <= 32'd0;
    end else begin
        case (reg_fb_ON)
            32'd0: begin
                reg_ramp <= 32'd0;
                reg_ramp_pre <= 32'd0;
                o_phaseRamp <= i_mod;
            end
            32'd1: begin
                if (i_mod_trig) begin
                    reg_ramp_pre <= reg_ramp_pre + reg_step;
                    reg_ramp <= reg_ramp_pre >>> reg_gain_sel[4:0]; // use lower 5 bits
                    o_phaseRamp <= reg_ramp + i_mod;
                end
            end
            32'd2: begin
                if (i_mod_trig)
                    o_phaseRamp <= o_phaseRamp + reg_step;
            end
            default: begin
                reg_ramp <= reg_ramp;
                reg_ramp_pre <= reg_ramp_pre;
                o_phaseRamp <= o_phaseRamp;
            end
        endcase
    end
end

endmodule
