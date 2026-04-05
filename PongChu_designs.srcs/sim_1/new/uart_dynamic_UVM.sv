`timescale 1ns / 1ps

interface UART_if();
    logic clk, rst;
    logic rd_uart;                                                                                                        
    logic wr_uart;                                                                                                        
    logic [7:0] wr_data;                                                                                        
    logic rx ;                                                                                                       
    logic [1:0] bd_rate;   //1200, 2400, 4800 or 9600 bauds respectively for "00", "01", "10", "11"             
    logic d_nums; // 0 = 7 databits, 1 = 8 databits                                                                        
    logic s_nums; // 0 = 1 stop bit, 1 = 2 stop bits                                                                       
    logic [1:0] par; // parity scheme : "00" or "11" = no, "01" = odd, "10" = even                            
    logic tx_flag;                                                                                                       
    logic rx_flag;                                                                                                       
    logic tx;                                                                                                           
    logic [7:0] rd_data;                                                                                  
    logic overrun_TX; // if write data too fast on buffer                                                                 
    logic [2:0] err_RX; // (overrun error, parity error, frame_error)
endinterface : UART_if

module uart_dynamic_UVM;


endmodule
