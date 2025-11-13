----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.11.2025 11:37:27
-- Design Name: 
-- Module Name: equal_2bits_tb - Behavioral
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

entity equal_2bits_tb is

end equal_2bits_tb;

architecture Behavioral of equal_2bits_tb is
COMPONENT equal_2bits is
    Port ( a : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           b : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           a_eq_b : out STD_LOGIC);
    END COMPONENT;
   
    SIGNAL a : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL a_eq_b : STD_LOGIC;
    
begin
UUT : equal_2bits PORT MAP (a => a, b => b, a_eq_b => a_eq_b);
test_vector : process
    begin
    a <= "00";
    b <= "00";
    WAIT FOR 10 ns;
    a <= "01";
    WAIT FOR 10 ns;
    a <= "10";
    WAIT FOR 10 ns;
    a <= "11";
    WAIT FOR 10 ns;
    a <= "00";
    b <= "01";
    WAIT FOR 10 ns;
    a <= "01";
    WAIT FOR 10 ns;
    a <= "10";
    WAIT FOR 10 ns;
    a <= "11";
    WAIT FOR 10 ns;
    a <= "00";
    b <= "10";
    WAIT FOR 10 ns;
    a <= "01";
    WAIT FOR 10 ns;
    a <= "10";
    WAIT FOR 10 ns;
    a <= "11";
    WAIT FOR 10 ns;
    a <= "00";
    b <= "11";
    WAIT FOR 10 ns;
    a <= "01";
    WAIT FOR 10 ns;
    a <= "10";
    WAIT FOR 10 ns;
    a <= "11";
    WAIT FOR 10 ns;
end process;

end Behavioral;
