----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 10:44:47
-- Design Name: 
-- Module Name: greater_than_4bits - Behavioral
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

entity greater_than_4bits is
    Port ( a : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           b : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           a_greater_b : out STD_LOGIC);
end greater_than_4bits;

architecture Behavioral of greater_than_4bits is

COMPONENT equal_2bits is
    Port ( a : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           b : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           a_eq_b : out STD_LOGIC);
    END COMPONENT;
    
COMPONENT greater_than
    PORT (  a_greater_b : OUT std_logic;
        a : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

signal SUP_2MSB : STD_LOGIC;
signal EQ_2MSB : STD_LOGIC;
signal SUP_2LSB : STD_LOGIC;

begin
greater_than_1 : greater_than PORT MAP (a => a(3 downto 2), b=> b(3 downto 2), a_greater_b => SUP_2MSB);
equal : equal_2bits PORT MAP (a => a(3 downto 2), b=> b(3 downto 2), a_eq_b => EQ_2MSB);
greater_than_2 : greater_than PORT MAP (a => a(1 downto 0), b=> b(1 downto 0), a_greater_b => SUP_2LSB);

-- if a 2 MSB's greater than b 
--     then a greater than b
-- else
--     if a 2MSB equal b 2MSB
--         compare a and b 2LSB to decide which is smaller
--     else
--        a is not greater than b

a_greater_b <= (EQ_2MSB AND SUP_2LSB) OR SUP_2MSB;

end Behavioral;
