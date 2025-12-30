library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity binary_to_BCD_FSMD_tb is
--  Port ( );
end binary_to_BCD_FSMD_tb;

architecture Behavioral of binary_to_BCD_FSMD_tb is

COMPONENT binary_to_BCD_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bin_in : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           done : out STD_LOGIC;
           BCD_out : out STD_LOGIC_VECTOR(7 DOWNTO 0)); -- 2 BCD digits
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                                  
SIGNAL rst_sig : STD_LOGIC;                                  
SIGNAL bin_in_sig : STD_LOGIC_VECTOR(6 DOWNTO 0); 
SIGNAL start_sig : STD_LOGIC;                                
SIGNAL BCD_out_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);       
SIGNAL done_sig : STD_LOGIC;                                
SIGNAL ready_sig : STD_LOGIC;         

begin
UUT : binary_to_BCD_FSMD
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            bin_in => bin_in_sig,
            start => start_sig,
            ready => ready_sig,
            done => done_sig,
            BCD_out => BCD_out_sig);

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
    bin_in_sig <= "1100011"; --99, shoud give result "1001 1001"
    start_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '0';
    WAIT FOR 260 ns;

end process;

end Behavioral;