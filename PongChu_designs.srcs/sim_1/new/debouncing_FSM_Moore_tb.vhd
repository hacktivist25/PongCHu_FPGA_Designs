----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.12.2025 14:33:34
-- Design Name: 
-- Module Name: debouncing_FSM_Moore_tb - Behavioral
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

entity debouncing_FSM_Moore_tb is
--  Port ( );
end debouncing_FSM_Moore_tb;

architecture Behavioral of debouncing_FSM_Moore_tb is

COMPONENT debouncing_FSM_Moore is
    generic ( LIMIT : INTEGER := 500_000; -- 10ms/20ns = 500k, log2(500k) = 19 => N=19
              N : INTEGER := 19); -- 10ms/20ns = 500k, log2(500k) = generic
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           debounced_signal : out STD_LOGIC);
end COMPONENT;

-- values to check the effect on a testbench if no FPGA to physically check. (no shame to be poor at the moment :) )
CONSTANT LIMIT_sig : INTEGER := 2; -- for testbench purposes
CONSTANT N_sig : INTEGER := 1; -- for testbench purposes
-- need 4 to 6 clock cycles of stability to confirm

SIGNAL clk_sig : STD_LOGIC;               
SIGNAL rst_sig : STD_LOGIC;               
SIGNAL input_signal_sig : STD_LOGIC;      
SIGNAL debounced_signal_sig : STD_LOGIC;

begin
UUT : debouncing_FSM_Moore
GENERIC MAP (   LIMIT => LIMIT_sig,
                N => N_sig)
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            input_signal => input_signal_sig,
            debounced_signal => debounced_signal_sig);

clock :process
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
    input_signal_sig <= '0';
    WAIT FOR 50ns;
    
    rst_sig <= '1';
    WAIT FOR 20ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    
    input_signal_sig <= '1';
    WAIT FOR 20ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    
    input_signal_sig <= '1';
    WAIT FOR 140ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20ns;
    
    input_signal_sig <= '1';
    WAIT FOR 40ns;
    
    input_signal_sig <= '0';
    WAIT FOR 140ns;
end process;

end Behavioral;
