library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity bin_14b_to_BCD_4d_FSMD_tb is
--  Port ( );
end bin_14b_to_BCD_4d_FSMD_tb;

architecture Behavioral of bin_14b_to_BCD_4d_FSMD_tb is

COMPONENT bin_14b_to_BCD_4d_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bin_in_14b : in STD_LOGIC_VECTOR(13 DOWNTO 0);
           start : in STD_LOGIC;
           BCD_out_4d : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           ready : out STD_LOGIC;
           done : out STD_LOGIC); -- 4 digits
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                              
SIGNAL rst_sig : STD_LOGIC;                              
SIGNAL bin_in_14b_sig : STD_LOGIC_VECTOR(13 DOWNTO 0);    
SIGNAL start_sig : STD_LOGIC;                            
SIGNAL BCD_out_4d_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);  
SIGNAL ready_sig : STD_LOGIC;                           
SIGNAL done_sig : STD_LOGIC; -- 4 digits               

begin 
UUT : bin_14b_to_BCD_4d_FSMD
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            bin_in_14b => bin_in_14b_sig,
            start => start_sig,
            BCD_out_4d => BCD_out_4d_sig,
            ready => ready_sig,
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
    rst_sig <= '0';
    bin_in_14b_sig <= "10000110110000"; -- 8 624
    start_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 340 ns;
    
end process;
end Behavioral;
