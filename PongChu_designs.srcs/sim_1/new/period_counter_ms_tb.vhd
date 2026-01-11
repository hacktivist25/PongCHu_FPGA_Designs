library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity period_counter_ms_tb is
--  Port ( );
end period_counter_ms_tb;

architecture Behavioral of period_counter_ms_tb is

COMPONENT period_counter_ms is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           signal_in : in STD_LOGIC;
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC;
           prd : out STD_LOGIC_VECTOR(9 DOWNTO 0)); -- 10 bits to count up to 1k ms = 1s
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                      
SIGNAL rst_sig : STD_LOGIC;                      
SIGNAL start_sig : STD_LOGIC;                    
SIGNAL signal_in_sig : STD_LOGIC;                
SIGNAL ready_sig : STD_LOGIC;                   
SIGNAL done_tick_sig : STD_LOGIC;               
SIGNAL prd_sig : STD_LOGIC_VECTOR(9 DOWNTO 0);

begin
UUT : period_counter_ms
PORT map(   clk => clk_sig,
            rst => rst_sig,
            start => start_sig, 
            signal_in => signal_in_sig,
            ready => ready_sig,
            done_tick => done_tick_sig,
            prd => prd_sig);

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
    start_sig <= '0';
    signal_in_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '0';
    WAIT FOR 20 ns;
    
    signal_in_sig <= '1';
    WAIT FOR 15000000 ns;
    signal_in_sig <= '0'; -- 30 ms period
    WAIT FOR 15000000 ns;
    
    signal_in_sig <= '1';
    WAIT FOR 15000000 ns;
    signal_in_sig <= '0';
    WAIT FOR 15000000 ns;
    
end process;

end Behavioral;
