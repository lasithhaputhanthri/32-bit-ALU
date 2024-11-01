`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 11:48:42 PM
// Design Name: 
// Module Name: fp_sub
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Floating point subtraction for IEEE 754 single-precision
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fp_sub(
    input [31:0] a,  // First input float
    input [31:0] b,  // Second input float
    output [31:0] result  // Resulting float
);

    // Break the inputs into sign, exponent, and mantissa
    wire sign_a = a[31];
    wire [7:0] exp_a = a[30:23];
    wire [22:0] mantissa_a = a[22:0];

    wire sign_b = b[31];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] mantissa_b = b[22:0];

    // Add implicit leading 1 for normalized numbers
    wire [23:0] frac_a = {1'b1, mantissa_a};  // 1.mantissa_a
    wire [23:0] frac_b = {1'b1, mantissa_b};  // 1.mantissa_b

    // Calculate exponent difference
    wire [7:0] exp_diff = (exp_a > exp_b) ? (exp_a - exp_b) : (exp_b - exp_a);

    // Shift the smaller number's mantissa to align the exponents
    wire [23:0] shifted_frac_b = (exp_a > exp_b) ? (frac_b >> exp_diff) : frac_b;
    wire [23:0] shifted_frac_a = (exp_a > exp_b) ? frac_a : (frac_a >> exp_diff);

    // Subtract the mantissas (assuming aligned exponents)
    wire [24:0] frac_diff = shifted_frac_a - shifted_frac_b;

    // Determine the result sign (same as `a` if no borrowing occurred, otherwise it takes `b`'s sign)
    wire result_sign = (shifted_frac_a >= shifted_frac_b) ? sign_a : sign_b;

    // Normalize the result (shift until the leading bit is 1)
    reg [7:0] final_exp;
    reg [22:0] final_frac;
    reg [24:0] normalized_diff;

    always @(*) begin
        if (frac_diff[24]) begin
            // If subtraction yields a result with a leading 1, normalize by shifting right
            normalized_diff = frac_diff;
            final_exp = (exp_a > exp_b) ? exp_a : exp_b;
        end else begin
            // Otherwise, shift left until a 1 is encountered (normalization)
            normalized_diff = frac_diff << 1;
            final_exp = ((exp_a > exp_b) ? exp_a : exp_b) - 1;
        end

        // Extract the final mantissa (without leading implicit 1)
        final_frac = normalized_diff[23:1];  // Drop the leading 1 and keep 23 bits
    end

    // Assemble the final result
    assign result = {result_sign, final_exp, final_frac};

endmodule


