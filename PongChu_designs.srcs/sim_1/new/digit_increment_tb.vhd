----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 23:30:26
-- Design Name: 
-- Module Name: digit_increment_tb - Behavioral
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

entity digit_increment_tb is
--  Port ( );
end digit_increment_tb;

architecture Behavioral of digit_increment_tb is

COMPONENT digit_increment is
    Port ( digit : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           increment : in STD_LOGIC;
           carry_out : out STD_LOGIC;
           digit_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

SIGNAL digit_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL increment_sig : STD_LOGIC;
SIGNAL carry_out_sig : STD_LOGIC;
SIGNAL digit_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : digit_increment PORT MAP (digit => digit_sig, increment => increment_sig, carry_out => carry_out_sig, digit_out => digit_out_sig);

test_vector : process
begin
    digit_sig <= "0000";
    increment_sig <= '0';
    WAIT FOR 10 ns;
    
    increment_sig <= '1';
    WAIT FOR 10 ns;
    
    digit_sig <= "0001";
    WAIT FOR 10 ns;

    digit_sig <= "0010";
    WAIT FOR 10 ns;
    
    digit_sig <= "0011";
    WAIT FOR 10 ns;
    
    digit_sig <= "0100";
    WAIT FOR 10 ns;
    
    digit_sig <= "0101";
    WAIT FOR 10 ns;
    
    digit_sig <= "0110";
    WAIT FOR 10 ns;
    
    digit_sig <= "0111";
    WAIT FOR 10 ns;
    
    digit_sig <= "1000";
    WAIT FOR 10 ns;
    
    digit_sig <= "1001";
    WAIT FOR 10 ns;
    
    WAIT ;
    
end process;
end Behavioral;
