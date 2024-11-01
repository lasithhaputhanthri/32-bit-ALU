`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024
// Design Name: 
// Module Name: FP_ALU
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

module FP_ALU (
    input [31:0] a,      // First floating-point number
    input [31:0] b,      // Second floating-point number
    input [1:0] op,      // Operation selector: 00 = add, 01 = sub, 10 = mul, 11 = div
    output reg [31:0] result  // Result of the operation
);

// Declare wires for the results of each operation
wire [31:0] add_result;
wire [31:0] sub_result;
wire [31:0] mul_result;
wire [31:0] div_result;


// Select operation based on 'op'
always @(op) begin
    case (op)
        2'b00: result = add_result;  // Addition
        2'b01: result = sub_result;  // Subtraction
        2'b10: result = mul_result;  // Multiplication
        2'b11: result = div_result;  // Division
        default: result = 32'b0;      // Default result (invalid op)
    endcase
end

// Instantiate operation modules
fp_add fp_add_inst (
    .a(a),
    .b(b),
    .result(add_result)
);

fp_sub fp_sub_inst (
    .a(a),
    .b(b),
    .result(sub_result)
);

fp_mul fp_mul_inst (
    .a(a),
    .b(b),
    .result(mul_result)
);

fp_div fp_div_inst (
    .a(a),
    .b(b),
    .result(div_result)
);

endmodule
