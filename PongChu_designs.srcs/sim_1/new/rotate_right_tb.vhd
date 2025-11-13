----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2025 13:27:54
-- Design Name: 
-- Module Name: rotate_left_tb - Behavioral
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

entity rotate_right_tb is
--  Port ( );
end rotate_right_tb;

architecture Behavioral of rotate_right_tb is

COMPONENT rotate_right is
    generic (
        N_bits : integer :=8
    );
    Port ( input : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0)
    );
end COMPONENT;

CONSTANT N : integer := 8;

SIGNAL input_sig : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL output_sig : STD_LOGIC_VECTOR(N-1 DOWNTO 0);


begin
UUT : rotate_right GENERIC MAP(N_bits => N) PORT MAP(input => input_sig, output => output_sig);

testvector : process
    begin
    input_sig <= "00001000";
    WAIT FOR 10ns;
    
    input_sig <= "10001000";
    WAIT FOR 10ns;
    
    input_sig <= "00000001";
    WAIT FOR 10ns;
    
    input_sig <= "00001100";
    WAIT FOR 10ns;
    
    input_sig <= "10001001";
    WAIT FOR 10ns;
    
    end process;
end Behavioral;
