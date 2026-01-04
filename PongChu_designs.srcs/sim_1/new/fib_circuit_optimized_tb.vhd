library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fib_circuit_optimized_tb is
--  Port ( );
end fib_circuit_optimized_tb;

architecture Behavioral of fib_circuit_optimized_tb is

COMPONENT fib_circuit_optimized is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_d1_in, BCD_d0_in : in STD_LOGIC_VECTOR(3 DOWNTO 0); -- 31 max
           start : in STD_LOGIC;
           BCD_d3_out, BCD_d2_out, BCD_d1_out, BCD_d0_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           ready : out STD_LOGIC;
           overflow : out STD_LOGIC;
           done : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                                                               
SIGNAL rst_sig : STD_LOGIC;                                                               
SIGNAL BCD_d1_in_sig, BCD_d0_in_sig : STD_LOGIC_VECTOR(3 DOWNTO 0); -- 31 max                 
SIGNAL start_sig : STD_LOGIC;                                                             
SIGNAL BCD_d3_out_sig, BCD_d2_out_sig, BCD_d1_out_sig, BCD_d0_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ready_sig : STD_LOGIC;                                                            
SIGNAL overflow_sig : STD_LOGIC;                                                         
SIGNAL done_sig : STD_LOGIC;                                                            

begin
UUT : fib_circuit_optimized
PORT MAP (  clk => clk_sig,                                     
            rst => rst_sig,                                     
            BCD_d1_in => BCD_d1_in_sig,
            BCD_d0_in => BCD_d0_in_sig,
            start => start_sig,                                       
            BCD_d3_out => BCD_d3_out_sig,
            BCD_d2_out => BCD_d2_out_sig,
            BCD_d1_out => BCD_d1_out_sig,
            BCD_d0_out => BCD_d0_out_sig,
            ready => ready_sig,                                       
            overflow => overflow_sig,                               
            done => done_sig);

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    -- case fib(8) = 21
    rst_sig <= '0';
    BCD_d1_in_sig <= "0000"; 
    BCD_d0_in_sig <= "1000";
    start_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '0';
    WAIT FOR 700 ns;
    
    -- OVERFLOW case : fib(22) = 17711 > 9999
    BCD_d1_in_sig <= "0010"; 
    BCD_d0_in_sig <= "0010";
    WAIT FOR 60 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '0';
    WAIT FOR 1100 ns;
    
    -- case : fib(17) = 1 597
    BCD_d1_in_sig <= "0001"; 
    BCD_d0_in_sig <= "0111";
    WAIT FOR 60 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '0';
    WAIT FOR 1000 ns;
    
end process;

end Behavioral;
