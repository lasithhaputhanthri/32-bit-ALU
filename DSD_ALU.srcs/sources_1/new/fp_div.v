`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024 11:57:13 PM
// Design Name: 
// Module Name: fp_div
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


module fp_div(
    input [31:0] a, 
    input [31:0] b, 
    output [31:0] result
);
// Floating-point division logic

// Break the inputs into sign, exponent, and mantissa
wire sign_a = a[31];
wire [7:0] exp_a = a[30:23];
wire [22:0] mantissa_a = a[22:0];

wire sign_b = b[31];
wire [7:0] exp_b = b[30:23];
wire [22:0] mantissa_b = b[22:0];

endmodule

