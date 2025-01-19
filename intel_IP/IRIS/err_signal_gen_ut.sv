`timescale 1ns / 1ps

module err_signal_gen_ut #(
    parameter ADC_BIT = 14
) (
    input logic i_clk,
    input logic i_rst_n,
    input logic i_status,
    input logic i_polarity,
    input logic i_trig,
    input logic [31:0] i_wait_cnt,
    input logic signed [31:0] i_err_offset,
    input logic signed [ADC_BIT-1:0] i_adc_data,
    input logic [31:0] i_avg_sel,
    output logic signed [31:0] o_err
);

    // State machine states
    typedef enum logic [3:0] {
        RST = 4'd0,
        WAIT_L_STATE = 4'd1,
        WAIT_H_STATE = 4'd2,
        WAIT_STABLE_L = 4'd3,
        WAIT_STABLE_H = 4'd4,
        ACQ_L = 4'd5,
        ACQ_H = 4'd6,
        ERR_GEN = 4'd7,
        ERR_GEN_DLY = 4'd8,
        RATE_SYNC_GEN = 4'd9,
        RAMP_SYNC_GEN = 4'd10,
        WAIT_NEXT = 4'd11
    } state_t;

    state_t cstate, nstate;

    // Internal registers
    logic [31:0] wait_counter;
    logic [31:0] sample_count;
    logic signed [31:0] adc_sum;
    logic signed [31:0] low_avg;
    logic signed [31:0] high_avg;

    // Derived parameters
    logic [31:0] num_samples;
    assign num_samples = (1 << i_avg_sel);

    // State transition logic
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            cstate <= RST;
        end else begin
            cstate <= nstate;
        end
    end

    // Next state logic
    always_comb begin
        nstate = cstate; // Default to current state
        case (cstate)
            RST: begin
                if (i_status == 1'b1) nstate = WAIT_L_STATE;
            end

            WAIT_L_STATE: begin
                if (i_trig) begin
                    nstate = WAIT_STABLE_L;
                end
            end

            WAIT_STABLE_L: begin
                if (wait_counter == 0) begin
                    nstate = ACQ_L;
                end
            end

            ACQ_L: begin
                if (sample_count == num_samples) begin
                    nstate = WAIT_H_STATE;
                end
            end

            WAIT_H_STATE: begin
                if (i_trig) begin
                    nstate = WAIT_STABLE_H;
                end
            end

            WAIT_STABLE_H: begin
                if (wait_counter == 0) begin
                    nstate = ACQ_H;
                end
            end

            ACQ_H: begin
                if (sample_count == num_samples) begin
                    nstate = ERR_GEN;
                end
            end

            ERR_GEN: begin
                nstate = ERR_GEN_DLY;
            end

            ERR_GEN_DLY: begin
                nstate = RATE_SYNC_GEN;
            end

            RATE_SYNC_GEN: begin
                nstate = RAMP_SYNC_GEN;
            end

            RAMP_SYNC_GEN: begin
                nstate = WAIT_NEXT;
            end

            WAIT_NEXT: begin
                nstate = WAIT_L_STATE;
            end

            default: nstate = RST;
        endcase
    end

    // Output and register update logic
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            wait_counter <= 0;
            sample_count <= 0;
            adc_sum <= 0;
            low_avg <= 0;
            high_avg <= 0;
            o_err <= 0;
        end else begin
            case (cstate)
                RST: begin
                    wait_counter <= i_wait_cnt;
                    sample_count <= 0;
                    adc_sum <= 0;
                    low_avg <= 0;
                    high_avg <= 0;
                    o_err <= 0;
                end

                WAIT_L_STATE: begin
                    if (i_trig) begin
                        wait_counter <= i_wait_cnt;
                    end
                end

                WAIT_STABLE_L: begin
                    if (wait_counter > 0) begin
                        wait_counter <= wait_counter - 1;
                    end
                end

                ACQ_L: begin
                    if (sample_count < num_samples) begin
                        adc_sum <= adc_sum + {{18{i_adc_data[ADC_BIT-1]}}, i_adc_data};
                        sample_count <= sample_count + 1;
                    end else begin
                        low_avg <= adc_sum >>> i_avg_sel;
                        adc_sum <= 0;
                        sample_count <= 0;
                    end
                end

                WAIT_H_STATE: begin
                    if (i_trig) begin
                        wait_counter <= i_wait_cnt;
                    end
                end

                WAIT_STABLE_H: begin
                    if (wait_counter > 0) begin
                        wait_counter <= wait_counter - 1;
                    end
                end

                ACQ_H: begin
                    if (sample_count < num_samples) begin
                        adc_sum <= adc_sum + {{18{i_adc_data[ADC_BIT-1]}}, i_adc_data};
                        sample_count <= sample_count + 1;
                    end else begin
                        high_avg <= (adc_sum >>> i_avg_sel) + i_err_offset;
                        adc_sum <= 0;
                        sample_count <= 0;
                    end
                end

                ERR_GEN: begin
                    if (i_polarity == 1'b0) begin
                        o_err <= high_avg - low_avg;
                    end else begin
                        o_err <= low_avg - high_avg;
                    end
                end

                default: begin
                    // Default case for safety
                end
            endcase
        end
    end

endmodule
