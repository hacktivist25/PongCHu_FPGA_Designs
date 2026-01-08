library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity division_circuit_tb is
--  Port ( );
end division_circuit_tb;

architecture Behavioral of division_circuit_tb is

COMPONENT division_circuit is
    Generic ( W : INTEGER := 20;
              N_bits : INTEGER := 5); -- log2(W) +1
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           divisor : in STD_LOGIC_VECTOR (W-1 DOWNTO 0); -- 101 to 1 000 000
           quotient : out STD_LOGIC_VECTOR (W-1 DOWNTO 0); -- 0 to 9999 
           remainder : out STD_LOGIC_VECTOR (W-1 DOWNTO 0); -- 0 to 999
           done_tick : out STD_LOGIC;
           ready : out STD_LOGIC);
end COMPONENT;

CONSTANT W_sig : INTEGER := 30;
CONSTANT N_bits_sig : INTEGER := 5;
SIGNAL clk_sig : STD_LOGIC;                           
SIGNAL rst_sig : STD_LOGIC;                           
SIGNAL start_sig : STD_LOGIC;                         
SIGNAL divisor_sig : STD_LOGIC_VECTOR (W_sig-1 DOWNTO 0); 
SIGNAL quotient_sig : STD_LOGIC_VECTOR (W_sig-1 DOWNTO 0);
SIGNAL remainder_sig : STD_LOGIC_VECTOR (W_sig-1 DOWNTO 0);
SIGNAL done_tick_sig : STD_LOGIC;                    
SIGNAL ready_sig : STD_LOGIC;                       

begin
UUT : division_circuit 
GENERIC MAP ( W => W_sig,
              N_bits => N_bits_sig)
PORT MAP ( clk => clk_sig,
           rst => rst_sig,
           start => start_sig,
           divisor => divisor_sig,
           quotient => quotient_sig,
           remainder => remainder_sig,
           done_tick => done_tick_sig,
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
    rst_sig <= '0';
    divisor_sig <= "0000" &  --frac part
                   "0000" &  --frac part
                   "00"   &  --frac part
                   "0000" &  --101
                   "0000" &  --101
                   "0000" &  --101
                   "0110" &  --101
                   "0101" ;  --101

                   
    start_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 700 ns;
    
    divisor_sig <=   "00" & -- 10 000
                   "0000" & 
                   "0000" & 
                   "0000" & 
                   "0010" &
                   "0111" &
                   "0001" &
                   "0000";
    WAIT FOR 20 ns;
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 700 ns;
end process;

end Behavioral;
