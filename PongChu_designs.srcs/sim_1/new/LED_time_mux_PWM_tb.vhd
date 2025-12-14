----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.12.2025 13:26:42
-- Design Name: 
-- Module Name: LED_time_mux_PWM_tb - Behavioral
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

entity LED_time_mux_PWM_tb is
--  Port ( );
end LED_time_mux_PWM_tb;

architecture Behavioral of LED_time_mux_PWM_tb is

COMPONENT LED_time_mux_PWM is
    Port ( in_3 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_2 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_1 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_0 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           w : in STD_LOGIC_VECTOR(3 DOWNTO 0); -- discrepancy here, I created a modular
           -- PWN with variable w width, but made a fixed width w for this LED :/ 
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

SIGNAL in_3_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_2_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_1_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_0_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL rst_sig : STD_LOGIC;
SIGNAL clk_sig : STD_LOGIC;
SIGNAL w_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : LED_time_mux_PWM PORT MAP ( in_3 => in_3_sig, in_2 => in_2_sig, in_1 => in_1_sig , in_0 => in_0_sig, rst => rst_sig, clk => clk_sig, w => w_sig, sseg_out => sseg_out_sig, ena_out => ena_out_sig);

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
    in_3_sig<= "0000001";
    in_2_sig<= "0000011";
    in_1_sig<= "0000111";
    in_0_sig<= "0001111";
    w_sig <= "1000";
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 4000 ns;
end process;
end Behavioral;
