----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2025 14:06:50
-- Design Name: 
-- Module Name: debouncing_FSMD_Moore_immediate_tb - Behavioral
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

entity debouncing_FSMD_Moore_immediate_tb is
--  Port ( );
end debouncing_FSMD_Moore_immediate_tb;

architecture Behavioral of debouncing_FSMD_Moore_immediate_tb is

COMPONENT debouncing_FSMD_Moore_immediate is
    Generic ( max_count : INTEGER := 1_000_000); -- max_count x 20 ns = 20 ms
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           debounced_signal : out STD_LOGIC;
           debounced_tick : out STD_LOGIC);
end COMPONENT;

CONSTANT max_count_sig : INTEGER := 6;
SIGNAL clk_sig : STD_LOGIC;                
SIGNAL rst_sig : STD_LOGIC;                
SIGNAL input_signal_sig : STD_LOGIC;       
SIGNAL debounced_signal_sig : STD_LOGIC; 
SIGNAL debounced_tick_sig : STD_LOGIC; 


begin
UUT : debouncing_FSMD_Moore_immediate 
GENERIC MAP( max_count => max_count_sig)
PORT MAP(   clk => clk_sig,              
            rst => rst_sig,
            input_signal => input_signal_sig,   
            debounced_signal => debounced_signal_sig,
            debounced_tick => debounced_tick_sig);
                     
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    rst_sig <= '0';
    input_signal_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    input_signal_sig <= '1';
    WAIT FOR 80 ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    input_signal_sig <= '1';
    WAIT FOR 80 ns;

end process;

end Behavioral;
