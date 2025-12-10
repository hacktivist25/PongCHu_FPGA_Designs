----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2025 12:10:53
-- Design Name: 
-- Module Name: greaterThan_fp_13bits - Behavioral
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

entity greaterThan_fp_13bits is
    Port ( sign_a, sign_b : in STD_LOGIC;
           frac_a, frac_b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           exp_a, exp_b : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           gr : out STD_LOGIC);
end greaterThan_fp_13bits;
-- 13 bits : s (sign bit), significand[7:0], exponent[3:0]
-- s = 1 => negative, 0 => positive
-- number = (-1)^s * .frac * 2^exponent

architecture Behavioral of greaterThan_fp_13bits is

signal frac_a_numeric, frac_b_numeric : STD_LOGIC_VECTOR(7 DOWNTO 0);
signal exp_a_numeric, exp_b_numeric : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin

    frac_b_numeric <= frac_b;
    exp_a_numeric <= exp_a;
    exp_b_numeric <= exp_b;
    frac_a_numeric <= frac_a;

    process (frac_a_numeric, frac_b_numeric, exp_a_numeric, exp_b_numeric)
    begin
        gr <= '0';
        if exp_a_numeric > exp_b_numeric then
            gr <= '1';
        elsif exp_a_numeric = exp_b_numeric then
            if frac_a_numeric > frac_b_numeric then
                gr <= '1';
            end if;
        end if;
    end process;

end Behavioral;
