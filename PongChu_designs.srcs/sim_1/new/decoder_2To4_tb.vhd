----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 14:34:12
-- Design Name: 
-- Module Name: decoder_2To4_tb - Behavioral
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

entity decoder_2To4_tb is
--  Port ( );
end decoder_2To4_tb;

architecture Behavioral of decoder_2To4_tb is
COMPONENT decoder_2To4 is
Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(3 DOWNTO 0)
           );
   END COMPONENT;
SIGNAL en : STD_LOGIC;
SIGNAL a : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL bcode : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : decoder_2To4 PORT MAP(en => en, a => a, bcode => bcode);

vector_test : process
    begin
    en <= '0';
    a <= "00";
    WAIT FOR 10ns;
    
    a <= "10";
    WAIT FOR 10ns;
    
    a <= "00";
    en <= '1';
    WAIT FOR 10ns;
    
    a <= "01";
    WAIT FOR 10ns;
    
    a <= "10";
    WAIT FOR 10ns;
    
    a <= "11";
    WAIT FOR 10ns;
    
END process;

end Behavioral;
