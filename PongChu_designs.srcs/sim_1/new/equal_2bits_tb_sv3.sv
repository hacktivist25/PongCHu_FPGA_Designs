`timescale 1ns / 1ps

module equal_2bits_tb_sv;


    logic [1:0] a;
    logic [1:0] b;
    logic a_eq_b;
    

    equal_2bits dut ( 
          .a(a),
          .b(b),
          .a_eq_b(a_eq_b)
        );
    
    
    // stimulus 
    initial begin
        a = 2'b00;
        b = 2'b00;
        #20;
        b = 2'b01;
        #20;
        b = 2'b10;
        #20;
        b = 2'b11;
        #20;
        a = 2'b01;
        b = 2'b00;
        #20;
        b = 2'b01;
        #20;
        b = 2'b10;
        #20;
        b = 2'b11;
        #20;
        a = 2'b10;
        b = 2'b00;
        #20;
        b = 2'b01;
        #20;
        b = 2'b10;
        #20;
        b = 2'b11;
        #20;
        a = 2'b11;
        b = 2'b00;
        #20;
        b = 2'b01;
        #20;
        b = 2'b10;
        #20;
        b = 2'b11;
        #20
    $finish;
    
    end 
    
endmodule       