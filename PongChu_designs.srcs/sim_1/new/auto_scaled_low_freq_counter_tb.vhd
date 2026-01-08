library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity auto_scaled_low_freq_counter_tb is
--  Port ( );
end auto_scaled_low_freq_counter_tb;

architecture Behavioral of auto_scaled_low_freq_counter_tb is

COMPONENT auto_scaled_low_freq_counter is
    Generic ( W_div : INTEGER := 30;
              N_bits_div : INTEGER := 5);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           signal_in : in STD_LOGIC;
           BCD_out : out STD_LOGIC_VECTOR(15 DOWNTO 0); -- 4 digits
           decimal_point_position : out STD_LOGIC_VECTOR(3 DOWNTO 0); -- one_hot
           -- 1000 = point for digit 3, 0100 for digit 2... etc...
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC);
end COMPONENT;

CONSTANT W_div_sig : INTEGER := 30;
CONSTANT N_bits_div_sig : INTEGER := 5;
SIGNAL clk_sig : STD_LOGIC;                                                   
SIGNAL rst_sig : STD_LOGIC;                                                   
SIGNAL start_sig : STD_LOGIC;                                                 
SIGNAL signal_in_sig : STD_LOGIC;                                             
SIGNAL BCD_out_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);             
SIGNAL decimal_point_position_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);        
SIGNAL ready_sig : STD_LOGIC;                                                
SIGNAL done_tick_sig : STD_LOGIC;       
                                    
begin
UUT : auto_scaled_low_freq_counter
GENERIC MAP(  W_div => W_div_sig,
              N_bits_div => N_bits_div_sig)
PORT MAP(   clk => clk_sig,   
            rst => rst_sig,   
            start => start_sig,  
            signal_in => signal_in_sig,
            BCD_out => BCD_out_sig,
            decimal_point_position => decimal_point_position_sig,
            ready => ready_sig,
            done_tick => done_tick_sig);
            
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
    
    signal_in_sig <= '1'; -- 140 µs period
    WAIT FOR 70000 ns;
    signal_in_sig <= '0';
    WAIT FOR 70000 ns;
    signal_in_sig <= '1';
    WAIT FOR 70000 ns;
    signal_in_sig <= '0';
    WAIT FOR 70000 ns;

end process;
end Behavioral;
