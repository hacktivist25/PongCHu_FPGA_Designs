`timescale 1ns / 1ps


module BCD_to_binary_FSMD_tb_sv2;
    //in
    logic clk_tb;
    logic rst_tb;
    logic [7:0] BCD_2digits_input_tb;
    logic start_tb;
    //out
    logic [6:0] binary_out_tb;
    logic done_tb;  
    logic ready_tb;
    
    // DUT
    BCD_to_binary_FSMD dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .BCD_2digits_input(BCD_2digits_input_tb),
        .start(start_tb),
        .binary_out(binary_out_tb),
        .done(done_tb),
        .ready(ready_tb)
    );
    
    // TASKS AND FUNCTIONS
    task driver_reset_init;
        rst_tb = 1'b0; // active-low reset
        BCD_2digits_input_tb = 8'b00000000;
        start_tb = 1'b0;
        repeat(3) @(posedge clk_tb);
        rst_tb = 1'b1;
        @(posedge clk_tb);
    endtask
    
    task driver_input(input int tens, input int units);
        fork
            begin : timeout
                repeat (100) @(posedge clk_tb);
                $error("TIMEOUT : waiting for ready ");
            end
            
            begin : wait_for_ready
                wait (ready_tb);
            end
        join_any
        disable fork;
        
        if(!ready_tb) begin
            $fatal("DUT not ready after timeout");
        end
        
        BCD_2digits_input_tb[7:4] = tens;
        BCD_2digits_input_tb[3:0] = units;
        @(posedge clk_tb);
        start_tb = 1'b1;
        @(posedge clk_tb);
        start_tb = 1'b0;
    endtask
    
    task monitor_output(output int got);
        @(posedge done_tb);
        got = binary_out_tb;
    endtask
    
    function int scoreboard_golden_model(input int tens, input int units);
        return (tens*10 + units);
    endfunction
    
    task scoreboard_SC(input int expected, input int got);
        assert (got === expected)
            else $error("mismatch at %0t : expected = %b, got = %b", 
            $time, expected, got);
    endtask
    
    //VARIABLES
    int got;
    
    // TEST
    initial clk_tb = 1;
    always #10 clk_tb = ~clk_tb;
    
    initial begin
        driver_reset_init();
        for (int tens = 0; tens<10; tens++) begin
            for (int units = 0; units<10; units++) begin
                driver_input(tens, units);   
                monitor_output(got);
                scoreboard_SC(scoreboard_golden_model(tens, units), got);
            end
        end
    end
endmodule
