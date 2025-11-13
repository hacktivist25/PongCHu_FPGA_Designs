----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 10:58:49
-- Design Name: 
-- Module Name: greater_than_4bits_tb - Behavioral
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

entity greater_than_4bits_tb is
--  Port ( );
end greater_than_4bits_tb;

architecture Behavioral of greater_than_4bits_tb is

COMPONENT greater_than_4bits IS
    Port ( a : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           b : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           a_greater_b : out STD_LOGIC);
END COMPONENT;

SIGNAL a : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL b : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL a_greater_b : STD_LOGIC;

begin
UUT : greater_than_4bits PORT MAP (a => a, b => b, a_greater_b => a_greater_b);

test_vector : process
    begin
    a <= "0000";
    b <= "0000";
    WAIT FOR 10 ns;
    
    a <= "0001";
    WAIT FOR 10 ns;
    
    b <= "0001";
    WAIT FOR 10 ns;
    
    b <= "0010";
    WAIT FOR 10 ns;
    
    a <= "0010";
    WAIT FOR 10 ns;
    
    a <= "0011";
    WAIT FOR 10 ns;
    
    a <= "0100";
    WAIT FOR 10 ns;
    
    b <= "0011";
    WAIT FOR 10 ns;
    
    b <= "0100";
    WAIT FOR 10 ns;
    
    b <= "1011";
    WAIT FOR 10 ns;
    
    a <= "1011";
    WAIT FOR 10 ns;
    
    a <= "1100";
    WAIT FOR 10 ns;
end process;
end Behavioral;
