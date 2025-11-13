----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2025 15:01:33
-- Design Name: 
-- Module Name: decoder_4To16_tb - Behavioral
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

entity decoder_4To16_tb is
--  Port ( );
end decoder_4To16_tb;

architecture Behavioral of decoder_4To16_tb is

COMPONENT decoder_4To16 is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(15 DOWNTO 0)
           );
end COMPONENT;

SIGNAL en : STD_LOGIC;
SIGNAL a : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bcode : STD_LOGIC_VECTOR(15 DOWNTO 0);

begin
UUT : decoder_4To16 PORT MAP(en => en, a => a, bcode => bcode);

test_vector : process
begin
    en <= '0';
    a <= "1000";
    WAIT FOR 10ns;
    
    a <= "0100";
    WAIT FOR 10ns;
    
    en <= '1' ;
    WAIT FOR 10ns;
    
    a <= "0000";
    WAIT FOR 10ns;
    
    a <= "0001";
    WAIT FOR 10ns;
    
    a <= "0010";
    WAIT FOR 10ns;
    
    a <= "0011";
    WAIT FOR 10ns;    
    
    a <= "0100";
    WAIT FOR 10ns;
    
    a <= "0101";
    WAIT FOR 10ns;
    
    a <= "0110";
    WAIT FOR 10ns;
    
    a <= "0111";
    WAIT FOR 10ns;
    
    a <= "1000";
    WAIT FOR 10ns;
    
    a <= "1001";
    WAIT FOR 10ns;
    
    a <= "1010";
    WAIT FOR 10ns;
    
    a <= "1011";
    WAIT FOR 10ns;    
    
    a <= "1100";
    WAIT FOR 10ns;
    
    a <= "1101";
    WAIT FOR 10ns;
    
    a <= "1110";
    WAIT FOR 10ns;
    
    a <= "1111";
    WAIT FOR 10ns;
end process;

end Behavioral;
