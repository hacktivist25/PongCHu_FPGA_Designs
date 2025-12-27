library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity parking_occupancy_counter_tb is
--  Port ( );
end parking_occupancy_counter_tb;

architecture Behavioral of parking_occupancy_counter_tb is

COMPONENT parking_occupancy_counter is
    generic ( max_value_counter : INTEGER := 12;
              Hz_800_LEDtm : INTEGER := 62500; 
              N_bits_LEDtm : INTEGER := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

CONSTANT max_value_counter_sig : INTEGER := 12;  
CONSTANT Hz_800_LEDtm_sig : INTEGER := 4; -- display a different digit each clock cycle (4 digits displayd every 4 clock cycles
CONSTANT N_bits_LEDtm_sig : INTEGER := 2;    

SIGNAL clk_sig : STD_LOGIC;                         
SIGNAL rst_sig : STD_LOGIC;                         
SIGNAL a_sig : STD_LOGIC;                           
SIGNAL b_sig : STD_LOGIC;                           
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
  
begin
UUT : parking_occupancy_counter
generic MAP( max_value_counter => max_value_counter_sig,      
          Hz_800_LEDtm => Hz_800_LEDtm_sig,   
          N_bits_LEDtm => N_bits_LEDtm_sig)       
Port MAP( clk => clk_sig,                            
       rst => rst_sig,                            
       a => a_sig,                            
       b => b_sig,                        
       sseg_out => sseg_out_sig,
       ena_out => ena_out_sig);
       
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
    a_sig <= '0';
    b_sig <= '0';
    WAIT FOR 50 ns;
    
    -- end of reset
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    -- exiting scenario -- empty parking lot = impossible
    b_sig <= '1';
    WAIT FOR 20 ns;
    a_sig <= '1';
    WAIT FOR 20 ns;
    b_sig <= '0';
    WAIT FOR 20 ns;
    a_sig <= '0';
    WAIT FOR 140 ns;
    
    -- entering scenario
    a_sig <= '1';
    WAIT FOR 20 ns;
    b_sig <= '1';
    WAIT FOR 20 ns;
    a_sig <= '0';
    WAIT FOR 20 ns;
    b_sig <= '0';
    WAIT FOR 140 ns;
    
    -- exiting scenario
    b_sig <= '1';
    WAIT FOR 20 ns;
    a_sig <= '1';
    WAIT FOR 20 ns;
    b_sig <= '0';
    WAIT FOR 20 ns;
    a_sig <= '0';
    WAIT FOR 140 ns;
    
    -- entering scenario - 1
    a_sig <= '1';
    WAIT FOR 20 ns;
    b_sig <= '1';
    WAIT FOR 20 ns;
    a_sig <= '0';
    WAIT FOR 20 ns;
    b_sig <= '0';
    WAIT FOR 80 ns;
    
    -- entering scenario -2
    a_sig <= '1';
    WAIT FOR 20 ns;
    b_sig <= '1';
    WAIT FOR 20 ns;
    a_sig <= '0';
    WAIT FOR 20 ns;
    b_sig <= '0';
    WAIT FOR 80 ns;
    
end process;

end Behavioral;
