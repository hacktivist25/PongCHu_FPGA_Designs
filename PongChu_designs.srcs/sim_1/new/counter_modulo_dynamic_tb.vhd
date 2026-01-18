library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity counter_modulo_dynamic_tb is
--  Port ( );
end counter_modulo_dynamic_tb;

architecture Behavioral of counter_modulo_dynamic_tb is
COMPONENT counter_modulo_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- selector for 1200, 2400, 4800 or 9600 bauds
           max_tick : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                       
SIGNAL rst_sig : STD_LOGIC;                       
SIGNAL bd_rate_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL max_tick_sig : STD_LOGIC;                

begin
UUT : counter_modulo_dynamic
PORT MAP (   clk => clk_sig,
             rst => rst_sig,
             bd_rate => bd_rate_sig,
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
    bd_rate_sig <= "00";
    WAIT FOR 30ns;
    
    rst_sig <= '1'; -- launching counter
    wait until max_tick_sig = '1';
    
    wait for 1000ns;
    bd_rate_sig <= "01";
    wait until max_tick_sig = '1';
    wait for 60 ns;
end process;

end Behavioral;
