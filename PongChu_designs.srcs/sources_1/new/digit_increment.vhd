----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 23:15:48
-- Design Name: 
-- Module Name: digit_increment - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity digit_increment is
    Port ( digit : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           increment : in STD_LOGIC;
           carry_out : out STD_LOGIC;
           digit_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end digit_increment;

architecture Behavioral of digit_increment is

begin
process (digit, increment)
begin
    carry_out <= '0';
    IF increment = '1' THEN
        case digit is
            WHEN "1001" => 
                digit_out <= "0000";
                carry_out <= '1';
            WHEN "1000" => 
                digit_out <= "1001";
            WHEN "0111" => 
                digit_out <= "1000";
            WHEN "0110" => 
                digit_out <= "0111";
            WHEN "0101" => 
                digit_out <= "0110";
            WHEN "0100" => 
                digit_out <= "0101";
            WHEN "0011" => 
                digit_out <= "0100";
            WHEN "0010" => 
                digit_out <= "0011";
            WHEN "0001" => 
                digit_out <= "0010";
            WHEN "0000" => 
                digit_out <= "0001";
            WHEN OTHERS =>
    end case;
    ELSE
        digit_out <= digit;
    END IF;
end process;

end Behavioral;
