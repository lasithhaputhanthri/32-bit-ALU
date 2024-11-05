module fp_adder(
    input logic [31:0] a, // First floating point number
    input logic [31:0] b, // Second floating point number
    output logic [31:0] result // Result of addition
);

    // Unpack the inputs
    logic sign_a, sign_b;
    logic [7:0] exp_a, exp_b;
    logic [23:0] frac_a, frac_b;
    logic sign_res;
    logic [7:0] exp_res;
    logic [23:0] frac_res;

    // Intermediate values
    logic [24:0] aligned_frac_a, aligned_frac_b;
    logic [24:0] added_frac;
    logic [7:0] exp_diff;
    logic [7:0] final_exp;
    logic [23:0] normalized_frac;
    logic [4:0] shift_amount;

    // Special cases handling
    always_comb begin
        if (a[30:23] == 8'hFF || b[30:23] == 8'hFF) begin
            // Handle NaN or Infinity
            result = 32'hFFC00000; // NaN
        end else if (a[30:0] == 0) begin
            // a is zero
            result = {b[31], b[30:0]};
        end else if (b[30:0] == 0) begin
            // b is zero
            result = {a[31], a[30:0]};
        end else begin
            // Normal addition
            sign_a = a[31];
            sign_b = b[31];
            exp_a = a[30:23];
            exp_b = b[30:23];
            frac_a = {1'b1, a[22:0]};
            frac_b = {1'b1, b[22:0]};

            if (exp_a > exp_b) begin
                exp_diff = exp_a - exp_b;
                aligned_frac_a = frac_a;
                aligned_frac_b = frac_b >> exp_diff;
                exp_res = exp_a;
            end else begin
                exp_diff = exp_b - exp_a;
                aligned_frac_a = frac_a >> exp_diff;
                aligned_frac_b = frac_b;
                exp_res = exp_b;
            end

            if (sign_a == sign_b) begin
                added_frac = aligned_frac_a + aligned_frac_b;
                sign_res = sign_a;
            end else begin
                if (aligned_frac_a >= aligned_frac_b) begin
                    added_frac = aligned_frac_a - aligned_frac_b;
                    sign_res = sign_a;
                end else begin
                    added_frac = aligned_frac_b - aligned_frac_a;
                    sign_res = sign_b;
                end
            end

            // Normalization
            if (added_frac[24]) begin
                normalized_frac = added_frac[24:1];
                final_exp = exp_res + 1;
            end else begin
                normalized_frac = added_frac[23:0];
                final_exp = exp_res;
                while (normalized_frac[23] == 0 && final_exp > 0) begin
                    normalized_frac = normalized_frac << 1;
                    final_exp = final_exp - 1;
                end
            end

            result = {sign_res, final_exp, normalized_frac[22:0]};
        end
    end
endmodule