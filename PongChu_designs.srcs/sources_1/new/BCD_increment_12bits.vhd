----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 23:47:00
-- Design Name: 
-- Module Name: BCD_increment_12bits - Behavioral
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

entity BCD_increment_12bits is
    Port ( input_12bits : in STD_LOGIC_VECTOR(11 DOWNTO 0);
           enable : in STD_LOGIC;
           carry_out : out STD_LOGIC;
           digits_out : out STD_LOGIC_VECTOR(11 DOWNTO 0));
end BCD_increment_12bits;

architecture Behavioral of BCD_increment_12bits is

COMPONENT digit_increment is
    Port ( digit : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           increment : in STD_LOGIC;
           carry_out : out STD_LOGIC;
           digit_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

SIGNAL carry_out_digit0 : STD_LOGIC;
SIGNAL carry_out_digit1 : STD_LOGIC;
SIGNAL carry_out_digit2 : STD_LOGIC;

SIGNAL out_digit2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL out_digit1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL out_digit0 : STD_LOGIC_VECTOR(3 DOWNTO 0);



begin

digit_2 : digit_increment PORT MAP(digit => input_12bits(11 DOWNTO 8), increment => carry_out_digit1, carry_out => carry_out_digit2, digit_out => out_digit2);
digit_1 : digit_increment PORT MAP(digit => input_12bits(7 DOWNTO 4), increment => carry_out_digit0, carry_out => carry_out_digit1, digit_out => out_digit1);
digit_0 : digit_increment PORT MAP(digit => input_12bits(3 DOWNTO 0), increment => enable, carry_out => carry_out_digit0, digit_out => out_digit0);

digits_out <= out_digit2 & out_digit1 & out_digit0;
carry_out <= carry_out_digit2;

end Behavioral;
