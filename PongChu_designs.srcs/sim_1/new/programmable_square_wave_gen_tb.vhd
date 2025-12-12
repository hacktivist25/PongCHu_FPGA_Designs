----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.12.2025 22:52:39
-- Design Name: 
-- Module Name: programmable_square_wave_gen_tb - Behavioral
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

entity programmable_square_wave_gen_tb is
--  Port ( );
end programmable_square_wave_gen_tb;

architecture Behavioral of programmable_square_wave_gen_tb is

COMPONENT programmable_square_wave_gen is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           m : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           n : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           output : out STD_LOGIC);
end COMPONENT;

SIGNAL rst_sig : STD_LOGIC;
SIGNAL clk_sig : STD_LOGIC;
SIGNAL m_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL n_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL output_sig : STD_LOGIC;

begin
UUT : programmable_square_wave_gen PORT MAP(rst => rst_sig, clk => clk_sig, m => m_sig, n => n_sig, output => output_sig);

clock : process
begin
    clk_sig <= '1'; 
    WAIT FOR 10ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    rst_sig <= '0' ; 
    m_sig <= "0100";
    n_sig <= "0100";
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 1000 ns;
    
    rst_sig <= '0' ; 
    m_sig <= "1000";
    n_sig <= "0010";
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 1200 ns;

end process;
end Behavioral;
