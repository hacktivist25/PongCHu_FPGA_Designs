`timescale 1ns / 1ps


module BCD_to_binary_FSMD_tb_sv;
    //DUT inputs
    logic clk_tb;   
    logic rst_tb;   
    logic [7:0] BCD_2digits_input_tb;
    logic start_tb; 
    //DUT outputs
    logic [6:0] binary_out_tb;
    logic done_tb;
    logic ready_tb;
    
    BCD_to_binary_FSMD dut (
        .clk(clk_tb),                     
        .rst(rst_tb),                     
        .BCD_2digits_input(BCD_2digits_input_tb),
        .start(start_tb),                   
        .binary_out(binary_out_tb),      
        .done(done_tb),              
        .ready(ready_tb)
    );
    
    task check_result(input int expected);
        assert (binary_out_tb === expected)
            else $error("misatch at %0t : input : %b, output : %b, expected : %b", 
               $time, BCD_2digits_input_tb, binary_out_tb, expected);
    endtask
    
    initial clk_tb = 0;
    always #10 clk_tb = ~clk_tb;
    
    initial begin
        // initial values + reset
        rst_tb = 1'b0;
        BCD_2digits_input_tb = 8'b00000000; 
        start_tb = 1'b0;
        repeat (3) @(posedge clk_tb);
        rst_tb = 1'b1;
        repeat (3) @(posedge clk_tb);
        
        for (int tens = 0; tens <10; tens++) begin
            for (int units = 0; units < 10; units++) begin
                BCD_2digits_input_tb[7:4] = tens;
                BCD_2digits_input_tb[3:0] = units;
                @(posedge clk_tb);
                start_tb = 1'b1;
                @(posedge clk_tb);
                start_tb = 1'b0;
                @(posedge done_tb);
                check_result(tens * 10 + units);
                @(posedge clk_tb);
            end
        end
    end
endmodule
