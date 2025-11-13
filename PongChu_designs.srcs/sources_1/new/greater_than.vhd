----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.11.2025 18:40:46
-- Design Name: 
-- Module Name: greater_than - Behavioral
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

entity greater_than is
Port (  a_greater_b : OUT std_logic;
        a : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        b : IN STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
end greater_than;

architecture Behavioral of greater_than is

begin
a_greater_b <= (a(1) AND NOT(b(1))) 
OR (NOT(a(1)) AND a(0) AND NOT(b(1)) AND NOT(b(0))) 
OR (a(1) AND a(0) AND b(1) AND NOT(b(0))); 
end Behavioral;
