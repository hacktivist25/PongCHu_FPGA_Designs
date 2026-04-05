`timescale 1ns / 1ps

module equal_2bits_tb_sv2;

    logic [1:0] a;
    logic [1:0] b;
    logic a_eq_b;
    
    equal_2bits dut(
        .a(a),
        .b(b),
        .a_eq_b(a_eq_b)
    );
    
    task check_equal;
        assert (a_eq_b === (a == b)) 
            else $error("Mismatch at time %0t: a=%b b=%b expected=%b got=%b",
                     $time, a, b, (a == b), a_eq_b);
    endtask
    
    // stimulus
    initial begin
        for (int i=0; i<4; i++) begin
            for (int j=0; j<4; j++) begin
                a = i;
                b = j;
                #1; 
                check_equal();
                #19;
            end
        end
    $display("Simulation finished.");
    $finish;
    end
endmodule