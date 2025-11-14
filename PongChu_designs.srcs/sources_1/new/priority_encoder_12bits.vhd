----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 12:04:08
-- Design Name: 
-- Module Name: dual_priority_encoder - Behavioral
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

entity priority_encoder_12bits is
    Port ( req : in STD_LOGIC_VECTOR(11 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end priority_encoder_12bits;

architecture Behavioral of priority_encoder_12bits is



begin
process (req)
    begin
    if req(11) = '1' THEN output <= "1100";
        elsif req(10) = '1' THEN output <= "1011";
        elsif req(9) = '1' THEN output <= "1010";
        elsif req(8) = '1' THEN output <= "1001";
        elsif req(7) = '1' THEN output <= "1000";
        elsif req(6) = '1' THEN output <= "0111";
        elsif req(5) = '1' THEN output <= "0110";
        elsif req(4) = '1' THEN output <= "0101";
        elsif req(3) = '1' THEN output <= "0100";
        elsif req(2) = '1' THEN output <= "0011";
        elsif req(1) = '1' THEN output <= "0010";
        elsif req(0) = '1' THEN output <= "0001";
        else output<= "0000";
    END IF;
    end process;
end Behavioral;