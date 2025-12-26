library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncing_FSM_Moore_immediate_tb is
--  Port ( );
end debouncing_FSM_Moore_immediate_tb;

architecture Behavioral of debouncing_FSM_Moore_immediate_tb is

COMPONENT debouncing_FSM_Moore_immediate is
    generic ( LIMIT : INTEGER := 500_000; -- 10ms/20ns = 500k, log2(500k) = 19 => N=19
              N : INTEGER := 19); -- 10ms/20ns = 500k, log2(500k) = generic
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           debounced_signal : out STD_LOGIC);
end COMPONENT;

CONSTANT LIMIT_sig : INTEGER := 2; 
CONSTANT N_sig : INTEGER := 1; 
SIGNAL rst_sig : STD_LOGIC;               
SIGNAL clk_sig : STD_LOGIC; 
SIGNAL input_signal_sig : STD_LOGIC;      
SIGNAL debounced_signal_sig : STD_LOGIC;

begin
UUT : debouncing_FSM_Moore_immediate
GENERIC MAP( LIMIT => LIMIT_sig,
             N  => N_sig)
PORT MAP (  rst => rst_sig,
            clk => clk_sig,
            input_signal => input_signal_sig,
            debounced_signal => debounced_signal_sig );
            
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    -- reset
    rst_sig <= '0';
    input_signal_sig <= '0';
    WAIT FOR 50ns;
    
    rst_sig <= '1';
    WAIT FOR 20ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    input_signal_sig <= '1';
    WAIT FOR 200ns;
    input_signal_sig <= '0';
    WAIT FOR 40ns;
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    input_signal_sig <= '0';
    WAIT FOR 200ns;
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    input_signal_sig <= '0';
    WAIT FOR 20ns;
end process;     
end Behavioral;
