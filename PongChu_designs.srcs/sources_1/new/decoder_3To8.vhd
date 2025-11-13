----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06.11.2025 18:13:47
-- Design Name: 
-- Module Name: Decoder_3To8 - Behavioral
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

entity decoder_3To8  is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(2 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(7 DOWNTO 0));
end decoder_3To8 ;

architecture Behavioral of decoder_3To8 is

COMPONENT decoder_2To4 is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(3 DOWNTO 0)
           );
end COMPONENT;

SIGNAL bcode_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bcode_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL enable_1 : STD_LOGIC;
SIGNAL enable_0 : STD_LOGIC;

begin
enable_1 <= a(2);
enable_0 <= NOT(a(2));

decoder_2To4_instance_1 : decoder_2To4 PORT MAP(en => enable_1, a => a(1 DOWNTO 0), bcode => bcode_1);
decoder_2To4_instance_0 : decoder_2To4 PORT MAP(en => enable_0, a => a(1 DOWNTO 0), bcode => bcode_0);

bcode(7 DOWNTO 4) <= bcode_1;
bcode(3 DOWNTO 0) <= bcode_0;

end Behavioral;
