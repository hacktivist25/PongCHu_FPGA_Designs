library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity uart_dynamic_tb is
--  Port ( );
end uart_dynamic_tb;

architecture Behavioral of uart_dynamic_tb is

COMPONENT uart_dynamic is                                                                                                       
generic ( d_bits_uart : NATURAL := 8);                                                                                       
    Port ( clk : in STD_LOGIC;                                                                                               
           rst : in STD_LOGIC;                                                                                               
           rd_uart : in STD_LOGIC;                                                                                           
           wr_uart : in STD_LOGIC;                                                                                           
           wr_data : in STD_LOGIC_VECTOR(7 DOWNTO 0);                                                                        
           rx : in STD_LOGIC;                                                                                                
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); --1200, 2400, 4800 or 9600 bauds respectively for "00", "01", "10", "11
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits                                                          
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits                                                         
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even              
           tx_flag : out STD_LOGIC;                                                                                          
           rx_flag : out STD_LOGIC;                                                                                          
           tx : out STD_LOGIC;                                                                                               
           rd_data : out  STD_LOGIC_VECTOR(7 DOWNTO 0);                                                                      
           overrun_TX : out STD_LOGIC; -- if write data too fast on buffer                                                   
           err_RX : out  STD_LOGIC_VECTOR(2 DOWNTO 0)); -- (overrun error, parity error, frame_error)                        
end COMPONENT;                                                                                                            

procedure receive_uart_byte (
    signal rx : out std_logic;
    constant data  : std_logic_vector(8 downto 0); -- 8 max bits for data + 1 potential parity bit in MSB
    constant bit_period : time;
    constant n_bits : natural; -- number of data bits = 7 or 8
    constant s_bits : natural; -- number of stop bits = 1 or 2
    constant parity : natural -- number of parity bit = 0 or 1
) is
begin
    -- start bit
    rx <= '0';
    wait for bit_period;

    -- data bits LSB first
    for i in 0 to n_bits + parity - 1 loop
        rx <= data(i);
        wait for bit_period;
    end loop;
    
    -- stop bit
    for i in 0 to s_bits - 1 loop
        rx <= '1';
        wait for bit_period;
    end loop;

end procedure;

CONSTANT d_bits_uart_sig : NATURAL := 8;
SIGNAL clk_sig : STD_LOGIC;                          
SIGNAL rst_sig : STD_LOGIC;                          
SIGNAL rd_uart_sig : STD_LOGIC;                      
SIGNAL wr_uart_sig : STD_LOGIC;                      
SIGNAL wr_data_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);   
SIGNAL rx_sig : STD_LOGIC;                           
SIGNAL bd_rate_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL d_nums_sig : STD_LOGIC;
SIGNAL s_nums_sig : STD_LOGIC;
SIGNAL par_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL tx_flag_sig : STD_LOGIC;                     
SIGNAL rx_flag_sig : STD_LOGIC;                     
SIGNAL tx_sig : STD_LOGIC;                          
SIGNAL rd_data_sig : STD_LOGIC_VECTOR(7 DOWNTO 0); 
SIGNAL overrun_TX_sig : STD_LOGIC;
SIGNAL err_RX_sig : STD_LOGIC_VECTOR(2 DOWNTO 0); 

begin

UUT : uart_dynamic                                                                                                     
generic map (d_bits_uart => d_bits_uart_sig)                                                                                    
Port map ( clk => clk_sig,                                                                                          
           rst => rst_sig,                                                                                          
           rd_uart => rd_uart_sig,                                                                     
           wr_uart => wr_uart_sig,                                                                     
           wr_data => wr_data_sig,                                                                     
           rx => rx_sig,                                                                                             
           bd_rate => bd_rate_sig,
           d_nums => d_nums_sig,                                                       
           s_nums => s_nums_sig,                                                       
           par => par_sig,      
           tx_flag => tx_flag_sig,                                                                                      
           rx_flag => rx_flag_sig,                                                                                      
           tx => tx_sig,                                                                                           
           rd_data => rd_data_sig,                                                                
           overrun_TX => overrun_TX_sig,                                                
           err_RX => err_RX_sig );                       
      
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    rst_sig <= '0';
    rd_uart_sig <= '0';
    wr_uart_sig <= '0';
    wr_data_sig <= "11001010";
    rx_sig <= '1';
    bd_rate_sig <= "11"; 
    d_nums_sig <= '0'; 
    s_nums_sig <= '0'; 
    par_sig <= "00";
    WAIT FOR 50ns;
    rst_sig <= '1';
    WAIT FOR 20 ns;
    -- ================================================================================
    -- send a frame "(1)1001010" with different configurations, and then receive it
    -- ================================================================================
    -- sending "1001010" (7 databits) without parity, 1 stop bit, 9600 bauds
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 1300000ns;
    
    -- sending "11001010" (8 data bits) without parity, 1 stop bit, 9600 bauds
    bd_rate_sig <= "11"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '0';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 1300000ns;
    
    -- sending "11001010" (8 data bits) without parity, 1 stop bit, 4800 bauds
    bd_rate_sig <= "10"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '0';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 2600000ns;
    
    -- sending "11001010" (8 data bits) without parity, 2 stop bit, 9600 bauds
    bd_rate_sig <= "11"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '1';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 1300000ns;
    
    -- sending "11001010" (8 data bits) even parity, 2 stop bit, 9600 bauds
    bd_rate_sig <= "11"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '1';   
    par_sig <= "10";   
    WAIT FOR 20ns;  
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 1400000ns;
    
    -- sending "1001010" (7 data bits) even parity, 2 stop bit, 9600 bauds
    wr_data_sig <= "01001010";
    bd_rate_sig <= "11"; 
    d_nums_sig <= '0';   
    s_nums_sig <= '1';   
    par_sig <= "10";   
    WAIT FOR 20ns;  
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 1300000ns;
    
    -- sending "11001010" (8 data bits) odd parity, 2 stop bit, 9600 bauds
    wr_data_sig <= "11001010";
    bd_rate_sig <= "11"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '1';   
    par_sig <= "01";   
    WAIT FOR 20ns;  
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 800000ns;
    
    -- sending the same thing again but too soon
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 1300000ns;
    
    -- ===========================================================
    -- now let's receive those bits with different configurations
    -- ===========================================================
    -- receive "1001010", 9600 bauds, 7 bits, 1 stop bit, no parity
    bd_rate_sig <= "11"; 
    d_nums_sig <= '0';   
    s_nums_sig <= '0';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    receive_uart_byte(rx_sig, "001001010", 104320ns, 7, 1, 0);
    WAIT FOR 20 ns;
    rd_uart_sig <= '1';
    WAIT FOR 20 ns;
    rd_uart_sig <= '0';
    WAIT FOR 200000ns;
    
    -- receive "11001010", 9600 bauds, 8 bits, 1 stop bit, no parity
    bd_rate_sig <= "11"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '0';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    receive_uart_byte(rx_sig, "011001010", 104320ns, 8, 1, 0);
    WAIT FOR 20 ns;
    rd_uart_sig <= '1';
    WAIT FOR 20 ns;
    rd_uart_sig <= '0';
    WAIT FOR 200000ns;
    
    -- receive "11001010", 4800 bauds, 8 bits, 2 stop bit, no parity
    bd_rate_sig <= "10"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '1';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    receive_uart_byte(rx_sig, "011001010", 208640ns, 8, 2, 0);
    WAIT FOR 200000ns;
    
    -- receive same but we didn't read --> overrun mismatch
    bd_rate_sig <= "10"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '1';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    receive_uart_byte(rx_sig, "011001010", 208640ns, 8, 2, 0);
    WAIT FOR 20 ns;
    rd_uart_sig <= '1';
    WAIT FOR 20 ns;
    rd_uart_sig <= '0';
    WAIT FOR 200000ns;
    
     
    -- receive "11001010", 9600 bauds, 8 bits, 2 stop bit, even parity
    bd_rate_sig <= "11"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '1';   
    par_sig <= "10";   
    WAIT FOR 20ns;  
    receive_uart_byte(rx_sig, "011001010", 104320ns, 8, 2, 1);
    WAIT FOR 20 ns;
    rd_uart_sig <= '1';
    WAIT FOR 20 ns;
    rd_uart_sig <= '0';
    WAIT FOR 200000ns;
    
    -- receive "11001010", 9600 bauds, 8 bits, 2 stop bit, even parity -- parity mismatch
    bd_rate_sig <= "11"; 
    d_nums_sig <= '1';   
    s_nums_sig <= '1';   
    par_sig <= "10";   
    WAIT FOR 20ns;  
    receive_uart_byte(rx_sig, "111001010", 104320ns, 8, 2, 1);
    WAIT FOR 20 ns;
    rd_uart_sig <= '1';
    WAIT FOR 20 ns;
    rd_uart_sig <= '0';
    WAIT FOR 200000ns;
    
    -- receive "100 1010", 9600 bauds, 7 bits, 1 stop bit, no parity
    -- but tranceiver is in 8 bits and send "0100 1010" -> frame mismatch (stop bit = 1, but MSB = 0)
    bd_rate_sig <= "11"; 
    d_nums_sig <= '0';   
    s_nums_sig <= '0';   
    par_sig <= "00";   
    WAIT FOR 20ns;  
    -- sending pattern
    rx_sig <= '0'; -- start bit
    WAIT FOR 104300ns;
    rx_sig <= '0'; -- bit 0
    WAIT FOR 104300ns;
    rx_sig <= '1'; -- bit 1
    WAIT FOR 104300ns;
    rx_sig <= '0'; -- bit 2
    WAIT FOR 104300ns;
    rx_sig <= '1'; -- bit 3
    WAIT FOR 104300ns;
    rx_sig <= '0'; -- bit 4
    WAIT FOR 104300ns;
    rx_sig <= '0'; -- bit 5
    WAIT FOR 104300ns;
    rx_sig <= '1'; -- bit 6
    WAIT FOR 104300ns;
    rx_sig <= '0'; -- bit 7 ! should be stop bit since we wait 7 data bits !
    WAIT FOR 104300ns;
    rx_sig <= '1'; -- stop bit
    WAIT FOR 104300ns;
    -- end of sending pattern
    WAIT FOR 20 ns;
    rd_uart_sig <= '1';
    WAIT FOR 20 ns;
    rd_uart_sig <= '0';
    WAIT FOR 200000ns;
    
    
    
end process;

end Behavioral;
