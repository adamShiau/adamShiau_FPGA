module my_iir_filter_v1 #(
    parameter WIDTH = 14, // Default bit width
    parameter COEFF_A1 = 16'hC7CF, // Coefficient a1 in Q1.15 format
    parameter COEFF_A2 = 16'hADE8, // Coefficient a2 in Q1.15 format
    parameter COEFF_B0 = 16'h0292, // Coefficient b0 in Q1.15 format
    parameter COEFF_B1 = 16'h0524, // Coefficient b1 in Q1.15 format
    parameter COEFF_B2 = 16'h0292  // Coefficient b2 in Q1.15 format
) (
    input wire clk,
    input wire n_rst,
    input wire signed [WIDTH-1:0] din,
    output reg signed [WIDTH+15:0] dout
);

    // Internal registers
    reg signed [WIDTH-1:0] x0, x1, x2; // Previous inputs
    reg signed [WIDTH-1:0] y1, y2; // Previous outputs
    // reg signed [WIDTH+15:0] acc;    // Accumulator for computation
    reg signed [WIDTH+15:0] mult [0:4];    // 乘法結果

    // Filter computation
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            x0 <= 0;
            x1 <= 0;
            x2 <= 0;
            y1 <= 0;
            y2 <= 0;
        end else begin
            x0 <= din;
            x1 <= x0;
            x2 <= x1;
            y1 <= dout;
            y2 <= y1;
        end
    end

    
    // 乘法運算
    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            mult[0] <= 0;  // 復位時設置為 0
            mult[1] <= 0;
            mult[2] <= 0;
            mult[3] <= 0;
            mult[4] <= 0;
        end else begin
            // mult[0] <= x0 * COEFF_B0;
            // mult[1] <= x1 * COEFF_B1;
            // mult[2] <= x2 * COEFF_B2;
            // mult[3] <= y1 * COEFF_A1;
            // mult[4] <= y2 * COEFF_A2;
            mult[0] <= $signed(x0) * $signed(COEFF_B0);
            mult[1] <= $signed(x1) * $signed(COEFF_B1);
            mult[2] <= $signed(x2) * $signed(COEFF_B2);
            mult[3] <= $signed(y1) * $signed(COEFF_A1);
            mult[4] <= $signed(y2) * $signed(COEFF_A2);
        end
    end

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            dout <= 0;
        end else begin
            dout <= mult[0]+ mult[1] + mult[2] - mult[3];
        //    dout <= mult[0] + mult[1] + mult[2] - mult[3] - mult[4];
        //    acc = mult[0] + mult[1] + mult[2] - mult[3] - mult[4];
        //    dout <= acc[WIDTH+14:15]; // Scale result to output width
        end
    end

endmodule
