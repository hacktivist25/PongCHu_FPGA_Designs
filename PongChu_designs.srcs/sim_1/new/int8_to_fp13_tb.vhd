----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2025 11:42:02
-- Design Name: 
-- Module Name: int8_to_fp13_tb - Behavioral
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

entity int8_to_fp13_tb is
--  Port ( );
end int8_to_fp13_tb;

architecture Behavioral of int8_to_fp13_tb is

COMPONENT int8_to_fp13 is
    Port ( int8_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           fp13_sign : out STD_LOGIC;
           fp13_frac : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           fp13_exp : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;
SIGNAL int8_in_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL fp13_sign_sig : STD_LOGIC;
SIGNAL fp13_frac_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL fp13_exp_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : int8_to_fp13 PORT MAP (int8_in => int8_in_sig, fp13_sign => fp13_sign_sig, fp13_frac => fp13_frac_sig, fp13_exp => fp13_exp_sig);

test_vectors : process 
begin
    int8_in_sig <= "10000000";
    WAIT FOR 10 ns;
    
    int8_in_sig <= "10001000";
    WAIT FOR 10 ns;
    
    int8_in_sig <= "11000011";
    WAIT FOR 10 ns;
    
    int8_in_sig <= "10011100";
    WAIT FOR 10 ns;
    
    int8_in_sig <= "01100100";
    WAIT FOR 10 ns;
    
    int8_in_sig <= "01111111";
    WAIT FOR 10 ns;

end process;

end Behavioral;
