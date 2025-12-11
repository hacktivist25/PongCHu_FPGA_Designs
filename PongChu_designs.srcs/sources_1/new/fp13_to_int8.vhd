----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2025 13:02:29
-- Design Name: 
-- Module Name: fp13_to_int8 - Behavioral
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

entity fp13_to_int8 is
    Port ( fp13_sign : in STD_LOGIC;
           fp13_frac : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           fp13_exp : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           int8 : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           overflow : out STD_LOGIC;
           underflow : out STD_LOGIC);
end fp13_to_int8;

architecture Behavioral of fp13_to_int8 is
SIGNAL num_right_shift : UNSIGNED(2 DOWNTO 0);
SIGNAL frac_shifted : STD_LOGIC_VECTOR(7 DOWNTO 0);

begin
    process (fp13_sign, fp13_frac, fp13_exp, frac_shifted, num_right_shift)
    begin
        int8(7) <= fp13_sign;
        IF fp13_exp(3) = '1' THEN
            overflow <= '1';
            underflow <= '0';
            int8( 6 DOWNTO 0 ) <= "0000000";
        ELSIF fp13_exp = "0000" THEN
            overflow <= '0';
            underflow <= '1';
            int8( 6 DOWNTO 0 ) <= "0000000";
        ELSE
            overflow <= '0';
            underflow <= '0';
            
            num_right_shift <= to_unsigned(7, 3) - unsigned(fp13_exp(2 downto 0));
            frac_shifted <= std_logic_vector(shift_right(unsigned(fp13_frac), to_integer(num_right_shift)));
            int8(6 DOWNTO 0) <= frac_shifted(7 DOWNTO 1);
        END IF;
    end process;
end Behavioral;
