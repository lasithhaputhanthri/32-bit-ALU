`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2024
// Design Name: 
// Module Name: fp_mul
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

module fp_mul(
    input [31:0] a,       // Input float a
    input [31:0] b,       // Input float b
    output [31:0] result  // Output float result
);

    // Extract mantissa, exponent, and sign
    wire [22:0] aFrac = a[22:0];
    wire [22:0] bFrac = b[22:0];

    wire [7:0] aExp = a[30:23];
    wire [7:0] bExp = b[30:23];

    wire aSign = a[31];
    wire bSign = b[31];

    // Compute sign bit
    wire zSign = aSign ^ bSign;

    // Compute exponent
    wire [8:0] exp_sum = aExp + bExp - 8'd127;

    // Add implicit `1` bit and shift to align for multiplication
    wire [23:0] aFrac_ext = {1'b1, aFrac};
    wire [23:0] bFrac_ext = {1'b1, bFrac};

    // Perform 32-bit multiplication and focus only on the upper 32 bits
    wire [47:0] zFrac = aFrac_ext * bFrac_ext;
    wire [23:0] zFrac0 = zFrac[47:24];  // Only the upper 32 bits are used

    // Handle overflow and normalization
    reg [31:0] final_frac;
    reg [7:0] final_exp;

    always @(*) begin
        if (zFrac0[31]) begin
            // If overflowed into more than 23 bits, adjust fraction and decrement exponent
            final_frac = zFrac0 >> 1;
            final_exp = exp_sum - 1;
        end else begin
            final_frac = zFrac0;
            final_exp = exp_sum;
        end
    end

    // Combine the sign, exponent, and fraction to form the final floating-point number
    assign result = {zSign, final_exp[7:0], final_frac[30:8]};  // Only the upper 23 bits are kept

endmodule
