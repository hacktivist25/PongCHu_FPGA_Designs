----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2025 10:18:17
-- Design Name: 
-- Module Name: fp13_to_int8_tb - Behavioral
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

entity fp13_to_int8_tb is
--  Port ( );
end fp13_to_int8_tb;

architecture Behavioral of fp13_to_int8_tb is

COMPONENT fp13_to_int8 is
    Port ( fp13_sign : in STD_LOGIC;
           fp13_frac : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           fp13_exp : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           int8 : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           overflow : out STD_LOGIC;
           underflow : out STD_LOGIC);
end COMPONENT;

SIGNAL fp13_sign_sig : STD_LOGIC;
SIGNAL fp13_frac_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL fp13_exp_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL int8_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL overflow_sig : STD_LOGIC;
SIGNAL underflow_sig : STD_LOGIC;

begin
UUT : fp13_to_int8 PORT MAP (fp13_sign => fp13_sign_sig, fp13_frac => fp13_frac_sig, fp13_exp => fp13_exp_sig, int8 => int8_sig, overflow => overflow_sig, underflow => underflow_sig);
test_vector : PROCESS
begin
    fp13_sign_sig <= '1';
    fp13_frac_sig <= "10001011";
    fp13_exp_sig <= "0110";
    WAIT FOR 10 ns;
    
    fp13_frac_sig <= "11101011";
    fp13_exp_sig <= "0111";
    WAIT FOR 10 ns;
    
    fp13_frac_sig <= "10001011";
    fp13_exp_sig <= "1000";
    WAIT FOR 10 ns;
    
    fp13_frac_sig <= "10001011";
    fp13_exp_sig <= "0000";
    WAIT FOR 10 ns;
    
    fp13_sign_sig <= '0';
    fp13_frac_sig <= "10001011";
    fp13_exp_sig <= "0011";
    WAIT FOR 10 ns;
    
    fp13_frac_sig <= "10001011";
    fp13_exp_sig <= "0100";
    WAIT FOR 10 ns;
    
    fp13_frac_sig <= "10001011";
    fp13_exp_sig <= "0101";
    WAIT FOR 10 ns;
end process;
end Behavioral;
