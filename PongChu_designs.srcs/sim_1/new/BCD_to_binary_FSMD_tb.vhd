library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity BCD_to_binary_FSMD_tb is
--  Port ( );
end BCD_to_binary_FSMD_tb;

architecture Behavioral of BCD_to_binary_FSMD_tb is

COMPONENT BCD_to_binary_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_2digits_input : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           start : in STD_LOGIC;
           binary_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           done : out STD_LOGIC;
           ready : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                                  
SIGNAL rst_sig : STD_LOGIC;                                  
SIGNAL BCD_2digits_input_sig : STD_LOGIC_VECTOR(7 DOWNTO 0); 
SIGNAL start_sig : STD_LOGIC;                                
SIGNAL binary_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);       
SIGNAL done_sig : STD_LOGIC;                                
SIGNAL ready_sig : STD_LOGIC;                              

begin
UUT : BCD_to_binary_FSMD
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            BCD_2digits_input => BCD_2digits_input_sig,
            start => start_sig,
            binary_out => binary_out_sig,
            done => done_sig,
            ready => ready_sig);

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
    BCD_2digits_input_sig <= "10011001"; --99, shoud give result "0110 0011"
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
