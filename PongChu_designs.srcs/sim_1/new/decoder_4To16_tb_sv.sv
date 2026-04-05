`timescale 1ns / 1ps
module decoder_4To16_tb_sv;

    logic en_tb;
    logic [3:0] a_tb;
    logic [15:0] bcode_tb;
    
    decoder_4To16 dut(
        .en(en_tb),
        .a(a_tb),
        .bcode(bcode_tb)
    );
    
    task check_result;
        logic [15:0] expected;
        if (en_tb)
            expected = 16'b1 << a_tb;
        else
            expected = 16'b0;
            
        assert(expected === bcode_tb)
            else $error ("Mismatch at %0t : en = %b, a = %b, expected : %b, got : %b", 
            $time, en_tb, a_tb, expected, bcode_tb);
    endtask;
    
    initial begin
        for (int u = 0; u < 2; u++) begin
            for (int i = 0; i < 16; i++) begin
              en_tb = u;
              a_tb = i;
              #1
              check_result();
              #4;
            end
        end  
    end
    
endmodule
