----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 21:07:50
-- Design Name: 
-- Module Name: dual_priority_encoder_12bits_tb - Behavioral
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

entity dual_priority_encoder_12bits_tb is
--  Port ( );
end dual_priority_encoder_12bits_tb;

architecture Behavioral of dual_priority_encoder_12bits_tb is

COMPONENT dual_priority_encoder_12bits is
    Port ( req : in STD_LOGIC_VECTOR(11 DOWNTO 0);
           prio_1 : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           prio_2 : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

SIGNAL req_sig : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL prio_1_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL prio_2_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : dual_priority_encoder_12bits PORT MAP (req => req_sig, prio_1 => prio_1_sig, prio_2 => prio_2_sig);

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
    req_sig <= "000001010011";
    WAIT FOR 10 ns;
    req_sig <= "000011000011";
    WAIT FOR 10 ns;
    req_sig <= "000101000011";
    WAIT FOR 10 ns;
    req_sig <= "001000010011";
    WAIT FOR 10 ns;
    req_sig <= "010000000011";
    WAIT FOR 10 ns;
    req_sig <= "100000001000";
    WAIT FOR 10 ns;
    WAIT;
end process;

end Behavioral;
