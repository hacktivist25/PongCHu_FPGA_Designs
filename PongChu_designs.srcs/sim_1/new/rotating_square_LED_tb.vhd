----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2025 20:21:16
-- Design Name: 
-- Module Name: rotating_square_LED_tb - Behavioral
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

entity rotating_square_LED_tb is
--  Port ( );
end rotating_square_LED_tb;

architecture Behavioral of rotating_square_LED_tb is

COMPONENT rotating_square_LED is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           cw : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;
    
SIGNAL clk_sig : STD_LOGIC;
SIGNAL rst_sig : STD_LOGIC;
SIGNAL en_sig : STD_LOGIC;
SIGNAL cw_sig : STD_LOGIC;
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : rotating_square_LED PORT MAP (
    clk => clk_sig,
    rst => rst_sig,
    en => en_sig,
    cw => cw_sig,
    sseg_out => sseg_out_sig,
    ena_out => ena_out_sig
    );

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    -- reset 
    rst_sig <= '0';
    en_sig <= '1';
    cw_sig <= '1';
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 800 ns;
    
    en_sig <= '0';
    cw_sig <= '0';
    WAIT FOR 500 ns;
    
    en_sig <= '1';
    WAIT FOR 800 ns;
end process;

end Behavioral;
