module tb_fp_arithmetic_unit;

    // Testbench signals
    logic [31:0] a, b;
    logic [1:0] op;
    logic [31:0] result;
    time start_time, end_time;
    time exec_time;

    // Instantiate the FPU
    fp_arithmetic_unit uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    // Task to display the result and execution time
    task display_result;
        input logic [31:0] a;
        input logic [31:0] b;
        input logic [1:0] op;
        input logic [31:0] result;
        input time exec_time;
        begin
            $display("a: %h (%f)", a, $bitstoshortreal(a));
            $display("b: %h (%f)", b, $bitstoshortreal(b));
            $display("op: %b", op);
            $display("result: %h (%f)", result, $bitstoshortreal(result));
            $display("Execution time: %0t", exec_time);
            $display("");
        end
    endtask

    initial begin
        // Array of test vectors
        logic [31:0] test_vectors_a[3] = '{32'h40400000, 32'hC0400000, 32'h3F800000};
        logic [31:0] test_vectors_b[3] = '{32'h3F800000, 32'hBF800000, 32'h40400000};
        int num_vectors = 3;

        // Loop over each test vector and each operation
        for (int i = 0; i < num_vectors; i++) begin
            a = test_vectors_a[i];
            b = test_vectors_b[i];
            
            // Test addition
            start_time = $time;
            op = 2'b10;
            #10;
            end_time = $time;
            exec_time = end_time - start_time;
            // Expected result for addition
            // a = 3.0, b = 1.0 -> result = 4.0 (0x40800000)
            // a = -3.0, b = -1.0 -> result = -4.0 (0xC0800000)
            // a = 1.0, b = 3.0 -> result = 4.0 (0x40800000)
            // a = 0.0, b = INF -> result = INF (0xFFC0000)
            display_result(a, b, op, result, exec_time);

            
        end

        // Finish the simulation
        $stop;
    end
endmodule