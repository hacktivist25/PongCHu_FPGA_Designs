----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.11.2025 11:12:02
-- Design Name: 
-- Module Name: equal_2bits - Behavioral
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

entity equal_2bits is
    Port ( a : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           b : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           a_eq_b : out STD_LOGIC);
end equal_2bits;

architecture Behavioral of equal_2bits is
SIGNAL p0 : STD_LOGIC;
SIGNAL p1 : STD_LOGIC;

begin
p0 <= NOT(a(0) XOR b(0));
p1 <= NOT(a(1) XOR b(1));
a_eq_b <= p0 AND p1;
end Behavioral;
