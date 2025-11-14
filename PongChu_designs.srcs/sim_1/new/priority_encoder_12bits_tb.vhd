----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 20:19:35
-- Design Name: 
-- Module Name: priority_encoder_12bits_tb - Behavioral
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

entity priority_encoder_12bits_tb is
--  Port ( );
end priority_encoder_12bits_tb;

architecture Behavioral of priority_encoder_12bits_tb is

COMPONENT priority_encoder_12bits is
    Port ( req : in STD_LOGIC_VECTOR(11 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

SIGNAL req_sig : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL output_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : priority_encoder_12bits PORT MAP (req => req_sig, output => output_sig);

test_vector : process
begin
    req_sig <= "000000000000";
    WAIT FOR 10 ns;
    req_sig <= "000000000001";
    WAIT FOR 10 ns;
    req_sig <= "000000000011";
    WAIT FOR 10 ns;
    req_sig <= "000000000111";
    WAIT FOR 10 ns;
    req_sig <= "000000001011";
    WAIT FOR 10 ns;
    req_sig <= "000000010011";
    WAIT FOR 10 ns;
    req_sig <= "000000100011";
    WAIT FOR 10 ns;
    req_sig <= "000001000011";
    WAIT FOR 10 ns;
    req_sig <= "000010000011";
    WAIT FOR 10 ns;
    req_sig <= "000100000011";
    WAIT FOR 10 ns;
    req_sig <= "001000000011";
    WAIT FOR 10 ns;
    req_sig <= "010000000011";
    WAIT FOR 10 ns;
    req_sig <= "100000000011";
    WAIT FOR 10 ns;
    WAIT;
end process;

end Behavioral;
