library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity BCD_ajustment_tb is
--  Port ( );
end BCD_ajustment_tb;

architecture Behavioral of BCD_ajustment_tb is

COMPONENT BCD_ajustment is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_in : in STD_LOGIC_VECTOR(27 DOWNTO 0); -- 4 digits for units, 3 digits for decimals
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           done : out STD_LOGIC;
           decimal_pos_out : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           BCD_out : out STD_LOGIC_VECTOR(15 DOWNTO 0));
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                                 
SIGNAL rst_sig : STD_LOGIC;                                 
SIGNAL BCD_in_sig : STD_LOGIC_VECTOR(27 DOWNTO 0);
SIGNAL start_sig : STD_LOGIC;                               
SIGNAL ready_sig : STD_LOGIC;                              
SIGNAL done_sig : STD_LOGIC;                               
SIGNAL decimal_pos_out_sig : STD_LOGIC_VECTOR(1 DOWNTO 0); 
SIGNAL BCD_out_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);       

begin
UUT : BCD_ajustment
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            BCD_in => BCD_in_sig,
            start => start_sig,
            ready => ready_sig,
            done => done_sig,
            decimal_pos_out => decimal_pos_out_sig,
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
    rst_sig <= '0';
    start_sig <= '0';
    BCD_in_sig <= "1111" & 
                  "0001" &
                  "0010" &
                  "0100" &
                  "1000" &
                  "0011" &
                  "0111";
    WAIT FOR 50ns;
    
    rst_sig <= '1';
    WAIT FOR 20ns;
    
    start_sig <= '1';
    WAIT FOR 20ns;
    
    start_sig <= '0';
    WAIT FOR 100 ns;
    
    
    BCD_in_sig <= "0000" & 
                  "0000" &
                  "0010" &
                  "0100" &
                  "1000" &
                  "0011" &
                  "0111";
    WAIT FOR 20ns; 
    
    start_sig <= '1';
    WAIT FOR 20ns;
    
    start_sig <= '0';
    WAIT FOR 100 ns;
    
end process;

end Behavioral;
