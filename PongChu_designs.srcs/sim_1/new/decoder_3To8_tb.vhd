----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 18:51:08
-- Design Name: 
-- Module Name: decoder_3To8_tb - Behavioral
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

entity decoder_3To8_tb is
--  Port ( );
end decoder_3To8_tb;

architecture Behavioral of decoder_3To8_tb is
COMPONENT decoder_3To8  is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(2 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end COMPONENT ;

SIGNAL en : STD_LOGIC;
SIGNAL a : STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL bcode : STD_LOGIC_VECTOR(7 DOWNTO 0);

begin
UUT : decoder_3To8 PORT MAP(en => en, a=>a, bcode=>bcode);

vector_test : process
begin
    en <= '0';
    a <= "100";
    WAIT FOR 10ns;
    
    a <= "010";
    WAIT FOR 10ns;
    
    en <= '1' ;
    WAIT FOR 10ns;
    
    a <= "000";
    WAIT FOR 10ns;
    
    a <= "001";
    WAIT FOR 10ns;
    
    a <= "010";
    WAIT FOR 10ns;
    
    a <= "011";
    WAIT FOR 10ns;    

    
    a <= "100";
    WAIT FOR 10ns;
    
    a <= "101";
    WAIT FOR 10ns;
    
    a <= "110";
    WAIT FOR 10ns;
    
    a <= "111";
    WAIT FOR 10ns;
    

end process;

end Behavioral;
