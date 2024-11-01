`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2024
// Design Name: 
// Module Name: test_FP_ALU
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

module test_FP_ALU;
    reg [31:0] a;
    reg [31:0] b;
    reg [1:0] op;
    wire [31:0] result;

    // Instantiate the ALU
    FP_ALU uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    initial begin
        // Test multiplication
        a = 32'b01000000000000000000000000000000;  // 3.0 in IEEE 754 format
        b = 32'b01000000000000000000000000000000;  // 3.0 in IEEE 754 format
        op = 2'b10; // Select multiplication operation
        
        // Display inputs before operation
        $display("Input a = %b, Input b = %b", a, b);
        #100;  // Wait for 10 time units

        // Display result after multiplication
        $display("Multiplication Result (Binary) = %b", result);
        $display("Multiplication Result (Decimal) = %f", $bitstoreal(result));
        
        // Wait and finish simulation
        #100;
        $finish;  // Use $finish to end simulation properly
    end
endmodule
