library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--this is directed test case, an UVM descritpion with a more elaborated randomized test will
-- be implemented later.

entity uart_dynamic_v2_tb is
--  Port ( );
end uart_dynamic_v2_tb;

architecture Behavioral of uart_dynamic_v2_tb is

COMPONENT uart_dynamic_v2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rd_uart : in STD_LOGIC;
           wr_uart : in STD_LOGIC;
           wr_data : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           rx : in STD_LOGIC;
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); --1200, 2400, 4800 or 9600 bauds respectively for "00", "01", "10", "11"
           d_nums : in STD_LOGIC; -- '0' = 7 databits, '1' = 8 databits 
           s_nums : in STD_LOGIC; -- '0' = 1 stop bit, '1' = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           tx : out STD_LOGIC;
           tx_full : out STD_LOGIC;
           rx_empty : out STD_LOGIC;
           rd_data : out  STD_LOGIC_VECTOR(9 DOWNTO 0); -- 2 MSb for parity and frame error
           overrun_RX : out STD_LOGIC); -- if write data too fast on buffer) 
end COMPONENT;                                                                                                            


-- wrong method for procedure : we should have made it relative to a number of clock edges, and 
-- not relative to a time step like here, but let's keep it this way, since we always 
-- operate with a 50MHz clock, and we stay in 9600 bauds
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
    for i in 0 to n_bits - 1 loop
        rx <= data(i);
        wait for bit_period;
    end loop;
    
    if parity = 1 then
        rx <= data(8); -- slot reserved for parity bit   
        wait for bit_period;
    end if;
    
    -- stop bit
    for i in 0 to s_bits - 1 loop
        rx <= '1';
        wait for bit_period;
    end loop;

end procedure;

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
SIGNAL tx_sig : STD_LOGIC;                          
SIGNAL tx_full_sig : STD_LOGIC;                          
SIGNAL rx_empty_sig : STD_LOGIC;                          
SIGNAL rd_data_sig : STD_LOGIC_VECTOR(9 DOWNTO 0); 
SIGNAL overrun_rx_sig : STD_LOGIC;

SIGNAL loopback_en : STD_LOGIC; -- used to link rx and tx together
SIGNAL rx_manual_sig : STD_LOGIC; -- used when tx and rx aren't linked together

-- array of 9 words to write on TX FIFO for PHASE 2 test (see later)
type data_array_t is array (0 to 8) of std_logic_vector(7 downto 0);
constant test_data : data_array_t := (
    x"12", x"34", x"56", x"78",
    x"9A", x"BC", x"DE", x"F0",
    x"50"
);

begin

-- Loopback / sélection source RX
rx_sig <= tx_sig when loopback_en = '1' else rx_manual_sig;

UUT : uart_dynamic_v2                                                                                                 
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
           tx => tx_sig,  
           tx_full => tx_full_sig,
           rx_empty => rx_empty_sig,                                                                                 
           rd_data => rd_data_sig,                                                                
           overrun_rx => overrun_rx_sig );                       
      
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

-- ================================================================================
-- we will stay at 9600 baud rate to reduce simulation time
-- directed tst will be done in 3 big phases : 
-- PHASE 1 : RX testing
-- - A1 : read RX to ensure nothing is read while empty 
-- - A2 : receive data 9 times to fill FIFO and make sure the overrun is triggered --> we lose 1 packet
--     - on these 8 first sends, some errors will occur
-- - A3 : read 8 times to ensure correct data retranscription with correct errors
--
-- PHASE 2 : TX testing
-- - B1 : write 9 words rapidly to check that FIFO TX full is triggered 
--
-- PHASE 3 :RX/TX loopback
-- - C1 : link TX to RX
-- - C2 : write 9 words on TX to check if they arrive correctly on RX (1 packet should be 
--   lost from TX side --> TX full)
-- - C3 : write 1 word when RX is full (1 packet should be lost from RX --> overrun error)
-- - C4 : read 8 received words
-- ================================================================================

test_vector : process
begin
    -- ==============
    -- RESET
    -- ==============
    rst_sig <= '0';
    rd_uart_sig <= '0';
    wr_uart_sig <= '0';
    wr_data_sig <= "11001010";
    bd_rate_sig <= "11"; 
    d_nums_sig <= '0'; 
    s_nums_sig <= '0'; 
    par_sig <= "00";
    loopback_en <= '0';
    rx_manual_sig <= '1';
    WAIT FOR 50ns;
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    -- ==
    -- A1
    -- ==
    rd_uart_sig <= '1';
    WAIT FOR 20 ns;
    rd_uart_sig <= '0';
    WAIT FOR 20 ns;
    
    -- ==
    -- A2
    -- ==
    d_nums_sig <= '1';  -- 8 data bis
    s_nums_sig <= '0';  -- 1 stop bit
    WAIT FOR 20ns;
    receive_uart_byte (rx_manual_sig, "001010101", 640ns, 8, 1, 0); 
    WAIT FOR 2000ns;
    d_nums_sig <= '0'; -- 7 data bis
    s_nums_sig <= '1'; -- 2 stop bit
    WAIT FOR 20ns;
    receive_uart_byte (rx_manual_sig, "000101010", 640ns, 7, 2, 0); 
    WAIT FOR 2000ns;
    -- frame error
    s_nums_sig <= '0'; -- 1 stop bit
    WAIT FOR 20ns;
    receive_uart_byte (rx_manual_sig, "000101010", 640ns, 8, 1, 0); 
    WAIT FOR 2000ns;
    -- parity error
    par_sig <= "10"; -- even parity scheme
    d_nums_sig <= '1'; -- 8 data bis
    WAIT FOR 20ns; 
    receive_uart_byte (rx_manual_sig, "100110011", 640ns, 8, 1, 1); 
    WAIT FOR 2000ns;
    receive_uart_byte (rx_manual_sig, "011001100", 640ns, 8, 1, 1); 
    WAIT FOR 2000ns;
    -- parity AND frame error (shoud that even be possible/allowed ?)
    d_nums_sig <= '0'; -- 7 data bis
    WAIT FOR 20ns;
    receive_uart_byte (rx_manual_sig, "010001001", 640ns, 8, 1, 1); 
    WAIT FOR 2000ns;
    d_nums_sig <= '1'; -- 8 data bis
    s_nums_sig <= '1'; -- 2 stop bit
    WAIT FOR 20ns;
    receive_uart_byte (rx_manual_sig, "110100101", 640ns, 8, 2, 1); 
    WAIT FOR 2000ns;
    s_nums_sig <= '0'; -- 1 stop bit
    WAIT FOR 20ns;
    receive_uart_byte (rx_manual_sig, "010011001", 640ns, 8, 1, 0); 
    WAIT FOR 2000ns;
    -- lost packet
    receive_uart_byte (rx_manual_sig, "000110011", 640ns, 8, 1, 0); 
    WAIT FOR 2000ns;

    -- ==
    -- A3 -- read all RX fifo
    -- ==
    wait until falling_edge(clk_sig);
    FOR i in 0 to 7 loop
        rd_uart_sig <= '1';
        wait until falling_edge(clk_sig);
        rd_uart_sig <= '0';
        FOR j in 0 to 7 loop
            wait until falling_edge(clk_sig);
        end loop;
    end loop;
    
    -- ==
    -- B1
    -- ==
    -- send 9 words of 8 bits, 1 stop bit, with odd parity scheme
    par_sig <= "01"; -- even parity scheme
    wr_data_sig <= test_data(0);
    wait until falling_edge(clk_sig);
    wr_uart_sig <= '1'; -- activate writing mode, we will write all in a burst
    for i in 1 to 8 loop
        wait until falling_edge(clk_sig);
        wr_data_sig <= test_data(i);
    end loop;
    wait until falling_edge(clk_sig);
    wr_uart_sig <= '0';
    WAIT FOR 2000ns;
   
   
    -- ==
    -- C1
    -- ==
    loopback_en <= '1';
    wait until rising_edge(clk_sig);
    
    -- ==
    -- C2
    -- ==
    wr_data_sig <= test_data(0);
    wait until falling_edge(clk_sig);
    wr_uart_sig <= '1'; -- activate writing mode, we will write all in a burst
    for i in 1 to 8 loop
        wait until falling_edge(clk_sig);
        wr_data_sig <= test_data(i);
    end loop;
    wait until falling_edge(clk_sig);
    wr_uart_sig <= '0';
    WAIT FOR 2000ns;
    
end process;

end Behavioral;
