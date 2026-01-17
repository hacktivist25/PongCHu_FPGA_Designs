library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity counter_modulo_tb is
--  Port ( );
end counter_modulo_tb;

architecture Behavioral of counter_modulo_tb is

COMPONENT counter_modulo is
    Generic (   max_count : NATURAL := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           max_tick : out STD_LOGIC);
end COMPONENT;

CONSTANT max_count_sig : NATURAL := 16;  
SIGNAL clk_sig : STD_LOGIC;               
SIGNAL rst_sig : STD_LOGIC;               
SIGNAL max_tick_sig : STD_LOGIC;        

begin
UUT : counter_modulo
GENERIC MAP(max_count => max_count_sig)
PORT MAP(   clk => clk_sig,
            rst => rst_sig,
            max_tick => max_tick_sig);

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
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 360 ns;
    
end process;

end Behavioral;
