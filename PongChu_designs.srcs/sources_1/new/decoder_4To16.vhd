----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.11.2025 14:33:55
-- Design Name: 
-- Module Name: decoder_4To16 - Behavioral
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

entity decoder_4To16 is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(15 DOWNTO 0)
           );
end decoder_4To16;

architecture Behavioral of decoder_4To16 is

COMPONENT decoder_2To4 is
    Port ( en : in STD_LOGIC;
           a : in STD_LOGIC_VECTOR(1 DOWNTO 0);
           bcode : out STD_LOGIC_VECTOR(3 DOWNTO 0)
           );
end COMPONENT;

SIGNAL bcode_3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bcode_2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bcode_1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bcode_0 : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL ena_3 : STD_LOGIC;
SIGNAL ena_2 : STD_LOGIC;
SIGNAL ena_1 : STD_LOGIC;
SIGNAL ena_0 : STD_LOGIC;

begin
ena_3 <= en AND a(3) AND a(2);
ena_2 <= en AND a(3) AND NOT(a(2));
ena_1 <= en AND NOT(a(3)) AND a(2);
ena_0 <= en AND NOT(a(3)) AND NOT(a(2));

decoder_3 : decoder_2To4 PORT MAP(en => ena_3, a => a(1 DOWNTO 0), bcode => bcode_3);
decoder_2 : decoder_2To4 PORT MAP(en => ena_2, a => a(1 DOWNTO 0), bcode => bcode_2);
decoder_1 : decoder_2To4 PORT MAP(en => ena_1, a => a(1 DOWNTO 0), bcode => bcode_1);
decoder_0 : decoder_2To4 PORT MAP(en => ena_0, a => a(1 DOWNTO 0), bcode => bcode_0);

bcode(15 DOWNTO 12) <= bcode_3;
bcode(11 DOWNTO 8) <= bcode_2;
bcode(7 DOWNTO 4) <= bcode_1;
bcode(3 DOWNTO 0) <= bcode_0;
end Behavioral;
