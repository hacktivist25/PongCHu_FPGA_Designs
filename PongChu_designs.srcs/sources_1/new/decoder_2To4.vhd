----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 14:22:40
-- Design Name: 
-- Module Name: 2_to_4_decoder - Behavioral
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

entity decoder_2To4 is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(3 DOWNTO 0)
           );
end decoder_2To4;

architecture Behavioral of decoder_2To4 is

begin
bcode(3)<= a(1) AND a(0) AND en;
bcode(2)<= a(1) AND NOT(a(0)) AND en;
bcode(1)<= NOT(a(1)) AND a(0) AND en;
bcode(0)<= NOT(a(1)) AND NOT(a(0)) AND en;

end Behavioral;
