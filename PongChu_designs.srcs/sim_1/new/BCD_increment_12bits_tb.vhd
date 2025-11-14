----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 23:55:02
-- Design Name: 
-- Module Name: BCD_increment_12bits_tb - Behavioral
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

entity BCD_increment_12bits_tb is
--  Port ( );
end BCD_increment_12bits_tb;

architecture Behavioral of BCD_increment_12bits_tb is

COMPONENT BCD_increment_12bits is
    Port ( input_12bits : in STD_LOGIC_VECTOR(11 DOWNTO 0);
           enable : in STD_LOGIC;
           carry_out : out STD_LOGIC;
           digits_out : out STD_LOGIC_VECTOR(11 DOWNTO 0));
end COMPONENT;

SIGNAL input_12bits_sig : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL enable_sig : STD_LOGIC;
SIGNAL carry_out_sig : STD_LOGIC;
SIGNAL digits_out_sig : STD_LOGIC_VECTOR(11 DOWNTO 0);

begin
UUT : BCD_increment_12bits PORT MAP (input_12bits => input_12bits_sig, enable => enable_sig, carry_out => carry_out_sig, digits_out => digits_out_sig);

test_vector : process
begin
    input_12bits_sig <= "000000000000";
    enable_sig <= '0';
    WAIT FOR 10 ns;
    
    enable_sig <= '1';
    WAIT FOR 10 ns;
    
    input_12bits_sig <= "000000001000";
    WAIT FOR 10 ns;
    
    input_12bits_sig <= "000000001001";
    WAIT FOR 10 ns;
    
    input_12bits_sig <= "000010011001";
    WAIT FOR 10 ns;
    
    input_12bits_sig <= "100100001001";
    WAIT FOR 10 ns;
    
    input_12bits_sig <= "100110010011";
    WAIT FOR 10 ns;
end process;

end Behavioral;
