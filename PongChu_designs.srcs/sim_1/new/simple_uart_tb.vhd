library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity simple_uart_tb is
--  Port ( );
end simple_uart_tb;

architecture Behavioral of simple_uart_tb is

COMPONENT simple_UART is
    generic ( d_bits_uart : NATURAL := 8;
              dvsr_uart : NATURAL := 16;
              baudrate_divisor : NATURAL := 163 -- 50Mhz clock / (dvsr_uart * baudrate_divisor) = 19200 bauds for example here
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rd_uart, wr_uart : in STD_LOGIC;
           wr_data : in STD_LOGIC_VECTOR(d_bits_uart -1 DOWNTO 0);
           rx : in STD_LOGIC;
           tx_flag, rx_flag, tx : out STD_LOGIC;
           rd_data : out  STD_LOGIC_VECTOR(d_bits_uart -1 DOWNTO 0));
end COMPONENT;

CONSTANT d_bits_uart_sig  : NATURAL := 8;                            
CONSTANT dvsr_uart_sig  : NATURAL := 16;                             
CONSTANT baudrate_divisor_sig  : NATURAL := 2; -- for testing purposes
                                                          
SIGNAL clk_sig : STD_LOGIC;                                       
SIGNAL rst_sig  : STD_LOGIC;                                       
SIGNAL rd_uart_sig , wr_uart_sig  : STD_LOGIC;                          
SIGNAL wr_data_sig  : STD_LOGIC_VECTOR(d_bits_uart_sig -1 DOWNTO 0);   
SIGNAL rx_sig  : STD_LOGIC;                                        
SIGNAL tx_flag_sig , rx_flag_sig , tx_sig  : STD_LOGIC;                     
SIGNAL rd_data_sig  : STD_LOGIC_VECTOR(d_bits_uart_sig -1 DOWNTO 0);


procedure receive_uart_rx_byte (
    signal rx : out std_logic;
    constant data  : std_logic_vector(7 downto 0);
    constant bit_period : time
) is
begin
    -- start bit
    rx <= '0';
    wait for bit_period;

    -- data bits LSB first
    for i in 0 to 7 loop
        rx <= data(i);
        wait for bit_period;
    end loop;

    -- stop bit
    rx <= '1';
    wait for bit_period;
end procedure;


begin
UUT : simple_UART
GENERIC MAP( d_bits_uart => d_bits_uart_sig,
            dvsr_uart => dvsr_uart_sig,
            baudrate_divisor => baudrate_divisor_sig )
PORT MAP(   clk => clk_sig,             
            rst => rst_sig,            
            rd_uart => rd_uart_sig,
            wr_uart => wr_uart_sig,
            wr_data => wr_data_sig,
            rx => rx_sig,  
            tx_flag => tx_flag_sig,
            rx_flag => rx_flag_sig,
            tx => tx_sig,
            rd_data => rd_data_sig );
            
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    -- let's fake an interaction where we send 2 bytes and we receive those bytes again
    -- 11001010 then 00001111
    rst_sig <= '0';
    rd_uart_sig <= '0';
    wr_uart_sig <= '0';
    wr_data_sig <= "11001010";
    rx_sig <= '1';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    -- write UART
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 7000ns;
    
    wr_data_sig <= "00001111";
    WAIT FOR 20ns;
    wr_uart_sig <= '1';
    WAIT FOR 20ns;
    wr_uart_sig <= '0';
    WAIT FOR 7000ns;
    
    -- end of transmission, we now receive them
    receive_uart_rx_byte (rx_sig, "11001010", 640ns);
    WAIT FOR 6800ns;
    rd_uart_sig <= '1';
    WAIT FOR 20ns;
    rd_uart_sig <= '0';
    WAIT FOR 20ns;
    
    receive_uart_rx_byte (rx_sig, "00001111", 640ns);
    WAIT FOR 7000ns;
    rd_uart_sig <= '1';
    WAIT FOR 20ns;
    rd_uart_sig <= '0';
    WAIT FOR 20ns;
end process;

end Behavioral;
