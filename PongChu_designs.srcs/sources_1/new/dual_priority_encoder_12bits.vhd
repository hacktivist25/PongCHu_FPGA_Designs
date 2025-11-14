----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2025 20:49:39
-- Design Name: 
-- Module Name: dual_priority_encoder_12bits - Behavioral
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

entity dual_priority_encoder_12bits is
    Port ( req : in STD_LOGIC_VECTOR(11 DOWNTO 0);
           prio_1 : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           prio_2 : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end dual_priority_encoder_12bits;

architecture Behavioral of dual_priority_encoder_12bits is

COMPONENT priority_encoder_12bits is
    Port ( req : in STD_LOGIC_VECTOR(11 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(3 DOWNTO 0));
END COMPONENT;

SIGNAL req_masked : STD_LOGIC_VECTOR(11 DOWNTO 0);
SIGNAL prio_1_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin

prio_1 <= prio_1_sig;

priority_1 : priority_encoder_12bits PORT MAP (req => req, output => prio_1_sig);
priority_2 : priority_encoder_12bits PORT MAP (req => req_masked, output => prio_2);

process (req, prio_1_sig)
    begin
    req_masked <= req;
    case prio_1_sig is
        WHEN "1100" =>
            req_masked(11) <= '0';
        WHEN "1011" =>
            req_masked(10) <= '0';
        WHEN "1010" =>
            req_masked(9) <= '0';
        WHEN "1001" =>
            req_masked(8) <= '0';
        WHEN "1000" =>
            req_masked(7) <= '0';
        WHEN "0111" =>
            req_masked(6) <= '0';
        WHEN "0110" =>
            req_masked(5) <= '0';
        WHEN "0101" =>
            req_masked(4) <= '0';
        WHEN "0100" =>
            req_masked(3) <= '0';
        WHEN "0011" =>
            req_masked(2) <= '0';
        WHEN "0010" =>
            req_masked(1) <= '0';
        WHEN "0001" =>
            req_masked(0) <= '0';
        WHEN OTHERS =>
            
    end case;
end process;

end Behavioral;
