library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dual_edge_detector_Moore_tb is
--  Port ( );
end dual_edge_detector_Moore_tb;

architecture Behavioral of dual_edge_detector_Moore_tb is

COMPONENT dual_edge_detector_Moore is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           edge_up_tick, edge_down_tick  : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;         
SIGNAL rst_sig : STD_LOGIC;         
SIGNAL input_signal_sig : STD_LOGIC;
SIGNAL edge_up_tick_sig : STD_LOGIC;
SIGNAL edge_down_tick_sig: STD_LOGIC;

begin
UUT : dual_edge_detector_Moore 
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            input_signal => input_signal_sig,
            edge_up_tick => edge_up_tick_sig,
            edge_down_tick => edge_down_tick_sig);
    
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10ns;
    clk_sig <= '0';
    WAIT FOR 10ns;
end process;

test_vector : process
begin
    rst_sig <= '0';
    input_signal_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    
end process;

end Behavioral;
