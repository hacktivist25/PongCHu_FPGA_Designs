library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity debouncing_testing_circuit_FSM_Moore_tb is
--  Port ( );
end debouncing_testing_circuit_FSM_Moore_tb;

architecture Behavioral of debouncing_testing_circuit_FSM_Moore_tb is

COMPONENT debouncing_testing_circuit_FSM_Moore is
generic ( -- debouncing circuit constants
          LIMIT_deboucing : INTEGER := 500_000;
          N_deboucing : INTEGER := 19;
          -- Seven segment display constants
          Hz_800_LEDtm : INTEGER := 62500;
          N_bits_LEDtm : INTEGER := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

         
SIGNAL LIMIT_deboucing_sig : INTEGER := 2;        
SIGNAL N_deboucing_sig : INTEGER := 1;                         
SIGNAL Hz_800_LEDtm_sig : INTEGER := 4;             
SIGNAL N_bits_LEDtm_sig : INTEGER := 2;               
SIGNAL clk_sig : STD_LOGIC;                         
SIGNAL rst_sig : STD_LOGIC;                         
SIGNAL input_signal_sig : STD_LOGIC;                
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : debouncing_testing_circuit_FSM_Moore
GENERIC MAP(    LIMIT_deboucing => LIMIT_deboucing_sig,
                N_deboucing =>  N_deboucing_sig,
                Hz_800_LEDtm => Hz_800_LEDtm_sig,
                N_bits_LEDtm => N_bits_LEDtm_sig)
PORT MAP(   clk => clk_sig,
            rst => rst_sig,
            input_signal => input_signal_sig,
            sseg_out => sseg_out_sig,
            ena_out => ena_out_sig);

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10ns;
    clk_sig <= '0';
    WAIT FOR 10ns;
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
    WAIT FOR 140ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    
    input_signal_sig <= '0';
    WAIT FOR 200ns;
end process;

end Behavioral;
