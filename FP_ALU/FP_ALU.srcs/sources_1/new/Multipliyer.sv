`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/05/2024 12:42:44 PM
// Design Name: 
// Module Name: Multipliyer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fp_multiplier (
    input logic [31:0] a, // First operand
    input logic [31:0] b, // Second operand
    output logic [31:0] result // Result of multiplication
);

    logic [7:0] a_sign, b_sign;         // Sign bits
    logic [7:0] a_exp, b_exp;           // Exponent bits
    logic [23:0] a_mantissa, b_mantissa; // Mantissa bits
    logic [7:0] result_sign;             // Result sign
    logic [8:0] result_exp;              // Result exponent
    logic [47:0] result_mantissa;        // Result mantissa

    // Unpacking the inputs
    assign a_sign = a[31];
    assign a_exp = a[30:23];
    assign a_mantissa = {1'b1, a[22:0]}; // Implicit leading 1 for normalized numbers

    assign b_sign = b[31];
    assign b_exp = b[30:23];
    assign b_mantissa = {1'b1, b[22:0]}; // Implicit leading 1 for normalized numbers

    // Multiplication logic
    always_comb begin
        result_sign = a_sign ^ b_sign; // XOR for sign bit
        result_exp = a_exp + b_exp - 8'b01111111; // Add exponents and adjust bias
        result_mantissa = a_mantissa * b_mantissa; // Multiply mantissas

        // Normalize the result mantissa if necessary
        if (result_mantissa[47] == 1) begin
            result_exp = result_exp + 1;
            result_mantissa = result_mantissa[46:23]; // Shift right
        end else begin
            result_mantissa = result_mantissa[45:22]; // Keep it within 24 bits
        end

        // Pack the result into the output
        result = {result_sign, result_exp[7:0], result_mantissa[22:0]};
    end
endmodule

