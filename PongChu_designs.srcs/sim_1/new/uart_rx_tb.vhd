library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uart_rx_tb is
--  Port ( );
end uart_rx_tb;

architecture Behavioral of uart_rx_tb is

COMPONENT uart_rx is
    GENERIC (   d_bits : NATURAL := 8; -- number of data bits
                dvsr : NATURAL := 16); -- 16 for 1 stop bit, 24 for 1.5, 32 for 2 stop bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           rx_word : out STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           done : out STD_LOGIC);
end COMPONENT;

CONSTANT d_bits_sig : NATURAL := 8;
CONSTANT dvsr_sig : NATURAL := 16;
SIGNAL clk_sig : STD_LOGIC;                               
SIGNAL rst_sig : STD_LOGIC;                               
SIGNAL rx_in_sig : STD_LOGIC;                             
SIGNAL s_tick_sig : STD_LOGIC;                            
SIGNAL rx_word_sig : STD_LOGIC_VECTOR(d_bits_sig - 1 DOWNTO 0);
SIGNAL done_sig : STD_LOGIC;                            

procedure send_uart_byte (
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
UUT : uart_rx
GENERIC MAP(d_bits => d_bits_sig,
            dvsr => dvsr_sig)
PORT MAP(   clk => clk_sig,
            rst => rst_sig,
            rx_in => rx_in_sig,
            s_tick => s_tick_sig,
            rx_word => rx_word_sig,
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
    s_tick_sig <= '1';
    WAIT FOR 20 ns;
    s_tick_sig <= '0';
    WAIT FOR 20 ns;
end process;

test_vector : process
begin
    rst_sig <= '0';
    rx_in_sig <= '1';
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    send_uart_byte(rx_in_sig, "00110101", 640 ns);
    -- 640 ns = 40 ns (s_tick perdio = sub-frequency of clock signal, here clk/2) * 16 (over-sampling factor)

    wait until done_sig = '1';
    wait;
end process;

end Behavioral;
