module iir_filter #(
    parameter WIDTH = 16, // Default bit width
    parameter COEFF_A1 = 16'hC7CF, // Coefficient a1 in Q1.15 format
    parameter COEFF_A2 = 16'hADE8, // Coefficient a2 in Q1.15 format
    parameter COEFF_B0 = 16'h0292, // Coefficient b0 in Q1.15 format
    parameter COEFF_B1 = 16'h0524, // Coefficient b1 in Q1.15 format
    parameter COEFF_B2 = 16'h0200  // Coefficient b2 in Q1.15 format
) (
    input wire clk,
    input wire n_rst,
    input wire signed [WIDTH-1:0] din,
    output reg signed [WIDTH-1:0] dout
);

    // Internal registers
    reg signed [WIDTH-1:0] x1, x2; // Previous inputs
    reg signed [WIDTH-1:0] y1, y2; // Previous outputs
    reg signed [WIDTH+15:0] acc;  // Accumulator for computation

    // Filter computation
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            // Reset all registers
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
            dout <= 0;
        end else begin
            // Compute the filter output
            acc = $signed(din) * $signed(COEFF_B0) +
                  $signed(x1) * $signed(COEFF_B1) +
                  $signed(x2) * $signed(COEFF_B2) -
                  $signed(y1) * $signed(COEFF_A1) -
                  $signed(y2) * $signed(COEFF_A2);

            dout <= acc[WIDTH+14:15];

            // Update delay registers
            x2 <= x1;
            x1 <= din;
            y2 <= y1;
            y1 <= dout;
        end
    end

endmodule
