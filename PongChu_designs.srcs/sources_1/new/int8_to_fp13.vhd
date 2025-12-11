----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2025 23:40:13
-- Design Name: 
-- Module Name: int8_to_fp13 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity int8_to_fp13 is
    Port ( int8_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           fp13_sign : out STD_LOGIC;
           fp13_frac : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           fp13_exp : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end int8_to_fp13;

architecture Behavioral of int8_to_fp13 is

Signal input_unsigned : UNSIGNED(7 DOWNTO 0);

begin

process(int8_in, input_unsigned)
begin
    
    fp13_sign <= int8_in(7);
    input_unsigned <= unsigned(int8_in);
    
    IF int8_in(6) = '1' THEN
        fp13_frac <= std_logic_vector (shift_left(input_unsigned,  1));
        fp13_exp <= "0111";
    ELSIF int8_in(5) = '1' THEN
        fp13_frac <= std_logic_vector (shift_left(input_unsigned,  2));
        fp13_exp <= "0110";
    ELSIF int8_in(4) = '1' THEN
        fp13_frac <= std_logic_vector (shift_left(input_unsigned,  3));
        fp13_exp <= "0101";
    ELSIF int8_in(3) = '1' THEN
        fp13_frac <= std_logic_vector (shift_left(input_unsigned,  4));
        fp13_exp <= "0100";
    ELSIF int8_in(2) = '1' THEN
        fp13_frac <= std_logic_vector (shift_left(input_unsigned,  5));
        fp13_exp <= "0011";
    ELSIF int8_in(1) = '1' THEN
        fp13_frac <= std_logic_vector (shift_left(input_unsigned,  6));
        fp13_exp <= "0010";
    ELSIF int8_in(0) = '1' THEN
        fp13_frac <= std_logic_vector (shift_left(input_unsigned,  7));
        fp13_exp <= "0001";
    ELSE
        fp13_frac <= "00000000";
        fp13_exp <= "0000";
    END IF;

end process;
end Behavioral;
