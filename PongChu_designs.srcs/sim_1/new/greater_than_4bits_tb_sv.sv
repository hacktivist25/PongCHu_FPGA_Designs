`timescale 1ns / 1ps

module greater_than_4bits_tb_sv;
    logic [3:0] a_tb;
    logic [3:0] b_tb;
    logic a_greater_b_tb;
    
    greater_than_4bits dut (
        .a(a_tb),
        .b(b_tb),
        .a_greater_b(a_greater_b_tb)
    );
    
    task eval_true;
        assert (a_greater_b_tb === (a_tb > b_tb))
            else $error ("mismatch at time %0t : a_tb = %b,  b_tb = %b, expected = %b, result = %b",
             $time, a_tb, b_tb, (a_tb > b_tb), a_greater_b_tb);
    endtask
    
    initial begin
        for (int i = 0; i<16; i++) begin
            for (int j = 0; j<16; j++) begin
                a_tb = i;
                b_tb = j;
                #1;
                eval_true();
                # 19;
            end
        end
    $display ("simulation finished");    
    $finish;         
    end
endmodule
