library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hex_to_sseg is
    Port ( hex : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           sseg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
end hex_to_sseg;

architecture Behavioral of hex_to_sseg is
begin
    sseg <= "0000000" WHEN hex = "0000"
    ELSE "0110000" WHEN hex = "0001"
    ELSE "1101101" WHEN hex = "0010"
    ELSE "1001111" WHEN hex = "0011"
    ELSE "0110011" WHEN hex = "0100"
    ELSE "1011011" WHEN hex = "0101"
    ELSE "1011111" WHEN hex = "0110"
    ELSE "1110000" WHEN hex = "0111"
    ELSE "1111111" WHEN hex = "1000"
    ELSE "1111011" WHEN hex = "1001"
    ELSE "1111101" WHEN hex = "1010"
    ELSE "0011111" WHEN hex = "1011"
    ELSE "1001110" WHEN hex = "1100"
    ELSE "0111101" WHEN hex = "1101"
    ELSE "1101111" WHEN hex = "1110"
    ELSE "1000111" WHEN hex = "1111"
    ELSE "0000000";
end Behavioral;
