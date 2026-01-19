library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uart_rx_dynamic_tb is
--  Port ( );
end uart_rx_dynamic_tb;

architecture Behavioral of uart_rx_dynamic_tb is

COMPONENT uart_rx_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           rx_word : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           err : out STD_LOGIC_VECTOR(1 DOWNTO 0); -- (parity error, frame_error)
           done : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                        
SIGNAL rst_sig : STD_LOGIC;                        
SIGNAL rx_in_sig : STD_LOGIC;                      
SIGNAL s_tick_sig : STD_LOGIC;                     
SIGNAL d_nums_sig : STD_LOGIC;
SIGNAL s_nums_sig : STD_LOGIC;
SIGNAL par_sig : STD_LOGIC_VECTOR(1 DOWNTO 0); 
SIGNAL rx_word_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL err_sig : STD_LOGIC_VECTOR(1 DOWNTO 0); 
SIGNAL done_sig : STD_LOGIC;                     

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
    

begin
UUT : uart_rx_dynamic
PORT MAP(   clk => clk_sig,
            rst => rst_sig,
            rx_in => rx_in_sig,
            s_tick => s_tick_sig, 
            d_nums => d_nums_sig, 
            s_nums => s_nums_sig, 
            par => par_sig, 
            rx_word => rx_word_sig,
            err => err_sig,
            done => done_sig);

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

s_tick_from_modulo_counter : process
begin
    s_tick_sig <= '1'; -- whatever s_tick frequency here, as long as it's lower than clock rate
    WAIT FOR 20 ns;
    s_tick_sig <= '0';
    WAIT FOR 20 ns;
end process;

test_vector : process
begin
    rst_sig <= '0';
    rx_in_sig <= '1';
    d_nums_sig <= '0'; -- 7 data bits
    s_nums_sig <= '0'; -- 1 stop bit
    par_sig  <= "00"; -- no parity scheme
    WAIT FOR 30 ns;
    
    rst_sig <= '1'; -- end of reset
    WAIT FOR 2000 ns;
    
    -- 7 data bits, 1 stop bit, no parity
    receive_uart_byte(rx_in_sig, "001100101", 640 ns, 7, 1, 0);
    -- 640 ns = 40 ns (s_tick perdio = sub-frequency of clock signal, here clk/2) * 16 (over-sampling factor)
    WAIT FOR 4000 ns;
    
    -- 8 data bits, 1 stop bit, no parity
    d_nums_sig <= '1';
    s_nums_sig <= '0';
    par_sig  <= "00";
    receive_uart_byte(rx_in_sig, "011100101", 640 ns, 8, 1, 0);
    WAIT FOR 4000 ns;
    
    -- 8 data bits, 2 stop bits, no parity
    d_nums_sig <= '1';
    s_nums_sig <= '1';
    par_sig  <= "00";
    receive_uart_byte(rx_in_sig, "011100101", 640 ns, 8, 2, 0);
    WAIT FOR 4000 ns;
    
     -- 8 data bits, 2 stop bits, even parity not respected
    d_nums_sig <= '1';
    s_nums_sig <= '1';
    par_sig  <= "10";
    receive_uart_byte(rx_in_sig, "110110101", 640 ns, 8, 2, 1);
    WAIT FOR 4000 ns;
    
     -- 8 data bits, 2 stop bits, even parity respected
    d_nums_sig <= '1';
    s_nums_sig <= '1';
    par_sig  <= "10";
    receive_uart_byte(rx_in_sig, "010110101", 640 ns, 8, 2, 1);
    WAIT FOR 4000 ns;
    
     -- 8 data bits, 2 stop bits, odd parity not respected
    d_nums_sig <= '1';
    s_nums_sig <= '1';
    par_sig  <= "01";
    receive_uart_byte(rx_in_sig, "110110101", 640 ns, 8, 2, 1);
    WAIT FOR 4000 ns;
    
    
     -- 7 data bits, 2 stop bits, no parity, frame error test
    d_nums_sig <= '0';
    s_nums_sig <= '1';
    par_sig  <= "00";
    
    -- start bit
    rx_in_sig <= '0';
    wait for 640ns;

    -- data bits LSB first
    for i in 0 to 6 loop
        rx_in_sig <= '1';
        wait for 640ns;
    end loop;
    
    -- stop bits shall be 1, but we will set the forst one to 0
    rx_in_sig <= '0';
    wait for 640ns;
    rx_in_sig <= '1';
    wait for 640ns;
    WAIT FOR 4000 ns;

end process;

end Behavioral;
