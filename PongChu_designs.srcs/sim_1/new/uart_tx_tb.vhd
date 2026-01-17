library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity uart_tx_tb is
--  Port ( );
end uart_tx_tb;

architecture Behavioral of uart_tx_tb is

COMPONENT uart_tx is
    GENERIC (   d_bits : NATURAL := 8; -- number of data bits
                dvsr : NATURAL := 16); -- 16 for 1 stop bit, 24 for 1.5, 32 for 2 stop bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tx_start : in STD_LOGIC;
           tx_in : in STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           s_tick : in STD_LOGIC;
           tx_out : out STD_LOGIC;
           done : out STD_LOGIC);
end COMPONENT;

CONSTANT d_bits_sig : NATURAL := 8;
CONSTANT dvsr_sig : NATURAL := 16;
SIGNAL clk_sig : STD_LOGIC;                               
SIGNAL rst_sig : STD_LOGIC;                               
SIGNAL tx_start_sig : STD_LOGIC;                              
SIGNAL tx_in_sig : STD_LOGIC_VECTOR(d_bits_sig - 1 DOWNTO 0);                      
SIGNAL s_tick_sig : STD_LOGIC;                            
SIGNAL tx_out_sig : STD_LOGIC;
SIGNAL done_sig : STD_LOGIC;                            

begin
UUT : uart_tx
GENERIC MAP(d_bits => d_bits_sig,
            dvsr => dvsr_sig)
PORT MAP(   clk => clk_sig,
            rst => rst_sig,
            tx_start => tx_start_sig,
            tx_in => tx_in_sig,
            s_tick => s_tick_sig,
            tx_out => tx_out_sig,
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
    tx_in_sig <= "11001010";
    tx_start_sig <= '0';
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    -- start sending 1100 1010 byte
    tx_start_sig <= '1';
    WAIT FOR 20 ns;
    
    tx_start_sig <= '0';
    wait for 6600 ns; -- 16 (oversampling factor) * 2 (s_tick division factor) * 20 ns (clock cycle) * 10 (10 bits) + 200 ns
end process;

end Behavioral;