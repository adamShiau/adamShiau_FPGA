module modulation_gen_ut (
    input i_clk,
    input i_rst_n,
    input [31:0] i_freq_cnt,
    input signed [31:0] i_amp_H,  // half-cycle amplitude for the positive phase
    input signed [31:0] i_amp_L,  // half-cycle amplitude for the negative phase
    output reg signed [31:0] o_mod_out, // square-wave output
    output reg o_status,               // current cycle status (1: positive, 0: negative)
    output reg o_stepTrig              // amplitude switching trigger signal
);

    // Register definitions
    reg [31:0] cnt;       // counter
    reg polarity;         // polarity (indicates positive or negative half-cycle)
    
    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // asynchronous reset
            cnt <= 0;
            polarity <= 1'b0;
            o_mod_out <= 0;
            o_stepTrig <= 1'b0;
            o_status <= 1'b0;
        end else begin
            if (cnt < i_freq_cnt - 1) begin
                // increment counter
                cnt <= cnt + 1;
                o_stepTrig <= 1'b0; // default: no trigger
            end else begin
                // reset counter and toggle polarity
                cnt <= 0;
                polarity <= ~polarity; // toggle polarity

                // trigger o_stepTrig on polarity switch
                o_stepTrig <= 1'b1;
            end

            // update output and status based on polarity
            if (polarity) begin
                o_mod_out <= i_amp_H; // positive half-cycle
                o_status <= 1'b1;     // positive status
            end else begin
                o_mod_out <= i_amp_L; // negative half-cycle
                o_status <= 1'b0;     // negative status
            end
        end
    end

endmodule
