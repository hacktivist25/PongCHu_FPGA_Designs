library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity N_bit_PWM_tb is
--  Port ( );
end N_bit_PWM_tb;

architecture Behavioral of N_bit_PWM_tb is

COMPONENT N_bit_PWM is
    generic (
          N_bits : integer :=4
    );
    Port ( clk : in STD_LOGIC;
           w : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0); -- duty cycle is w / (2^N)
           rst : in STD_LOGIC;
           output : out STD_LOGIC);
end COMPONENT;

CONSTANT N: integer:=4;

SIGNAL clk_sig : STD_LOGIC;
SIGNAL w_sig : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL rst_sig : STD_LOGIC;
SIGNAL output_sig : STD_LOGIC;

begin
UUT : N_bit_PWM GENERIC MAP (N_bits => N) PORT MAP (clk => clk_sig, w => w_sig, rst => rst_sig, output => output_sig);

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
    w_sig <= "0001";
    WAIT FOR 30 ns;
    
    rst_sig<='1';
    WAIT FOR 400 ns;
    
    w_sig <= "1011";
    WAIT FOR 600 ns;
end process;

end Behavioral;
