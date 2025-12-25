library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_to_sseg_tb is
--  Port ( );
end hex_to_sseg_tb;

architecture Behavioral of hex_to_sseg_tb is

COMPONENT hex_to_sseg is
    Port ( hex : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           sseg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
end COMPONENT;

SIGNAL hex_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL sseg_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);

begin
    UUT : hex_to_sseg PORT MAP (hex => hex_sig, sseg => sseg_sig);
    test_vector : process
    begin
        hex_sig <= "0000";
        WAIT FOR 20 ns;
        hex_sig <= "0001";
        WAIT FOR 20 ns;
        hex_sig <= "0010";
        WAIT FOR 20 ns;
        hex_sig <= "0011";
        WAIT FOR 20 ns;
        hex_sig <= "0100";
        WAIT FOR 20 ns;
        hex_sig <= "0101";
        WAIT FOR 20 ns;
        hex_sig <= "0110";
        WAIT FOR 20 ns;
        hex_sig <= "0111";
        WAIT FOR 20 ns;
        hex_sig <= "1000";
        WAIT FOR 20 ns;
        hex_sig <= "1001";
        WAIT FOR 20 ns;
        hex_sig <= "1010";
        WAIT FOR 20 ns;
        hex_sig <= "1011";
        WAIT FOR 20 ns;
        hex_sig <= "1100";
        WAIT FOR 20 ns;
        hex_sig <= "1101";
        WAIT FOR 20 ns;
        hex_sig <= "1110";
        WAIT FOR 20 ns;
        hex_sig <= "1111";
        WAIT FOR 20 ns;
    end process;
end Behavioral;
