module fp_arithmetic_unit(
    input logic [31:0] a, // First floating point number
    input logic [31:0] b, // Second floating point number
    input logic [1:0] op, // Operation selector: 00 = add, 01 = subtract, 10 = multiply, 11 = divide
    output logic [31:0] result // Result of the operation
);

    // Internal signals
    logic [31:0] add_result;
    logic [31:0] sub_result;
    logic [31:0] mul_result;
//    , sub_result, mul_result, div_result;
    

    // Instantiate the arithmetic modules
    fp_adder adder (
        .a(a),
        .b(b),
        .result(add_result)
    );
    
     fp_subtractor subtractor (
        .a(a),
        .b(b),
        .result(sub_result)
    );

     fp_multiplier multiplier (
        .a(a),
        .b(b),
        .result(mul_result)
    );


    // Operation selector
    always_comb begin
        case (op)
            2'b00: result = add_result;
            2'b01: result = sub_result;
            2'b10: result = mul_result;
//            2'b11: result = div_result;
            default: result = 32'h00000000; // Default to zero
        endcase
    end
endmodule