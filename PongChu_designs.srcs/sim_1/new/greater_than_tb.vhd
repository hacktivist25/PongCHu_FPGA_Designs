----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2025 18:51:11
-- Design Name: 
-- Module Name: greater_than_tb - Behavioral
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

entity greater_than_tb is

end greater_than_tb;


architecture Behavioral of greater_than_tb is
COMPONENT greater_than
    PORT (  a_greater_b : OUT std_logic;
        a : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL a_greater_b : STD_LOGIC;
    SIGNAL a : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL b : STD_LOGIC_VECTOR (1 DOWNTO 0);

begin
UUT : greater_than PORT MAP (a_greater_b => a_greater_b, a => a, b => b);

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
