----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.11.2025 21:04:27
-- Design Name: 
-- Module Name: greaterThan_fp_13bits_tb - Behavioral
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

entity greaterThan_fp_13bits_tb is
--  Port ( );
end greaterThan_fp_13bits_tb;

architecture Behavioral of greaterThan_fp_13bits_tb is

COMPONENT greaterThan_fp_13bits is
    Port ( sign_a, sign_b : in STD_LOGIC;
           frac_a, frac_b : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           exp_a, exp_b : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           gr : out STD_LOGIC);
end COMPONENT;

SIGNAL sign_a_sig, sign_b_sig : STD_LOGIC;
SIGNAL frac_a_sig, frac_b_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL exp_a_sig, exp_b_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL gr_sig : STD_LOGIC;

begin
UUT : greaterThan_fp_13bits PORT MAP(sign_a => sign_a_sig, sign_b => sign_b_sig, frac_a => frac_a_sig, frac_b => frac_b_sig, exp_a => exp_a_sig, exp_b => exp_b_sig, gr => gr_sig);

test_vector : process
    begin
        
        sign_a_sig <= '0';
        sign_b_sig <= '0';
        frac_a_sig <= "10010000";
        frac_b_sig <= "10100011";
        exp_a_sig <= "0001";
        exp_b_sig <= "0001";
        WAIT FOR 10 ns;
        
        frac_a_sig <= "10100111";
        WAIT FOR 10 ns;
        
        exp_b_sig <= "0010";
        WAIT FOR 10 ns;
        
        exp_a_sig <= "0011";
        WAIT FOR 10 ns;

    end process;
end Behavioral;
