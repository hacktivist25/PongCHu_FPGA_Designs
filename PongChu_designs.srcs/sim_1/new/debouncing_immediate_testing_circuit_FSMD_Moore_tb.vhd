----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.12.2025 17:43:03
-- Design Name: 
-- Module Name: debouncing_immediate_testing_circuit_FSMD_Moore_tb - Behavioral
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

entity debouncing_immediate_testing_circuit_FSMD_Moore_tb is
--  Port ( );
end debouncing_immediate_testing_circuit_FSMD_Moore_tb;

architecture Behavioral of debouncing_immediate_testing_circuit_FSMD_Moore_tb is

COMPONENT debouncing_immediate_testing_circuit_FSMD_Moore is
    generic ( max_count_FSMD : INTEGER := 1_000_000; -- max_count x 20 ns = 20 ms
              Hz_800_LEDtm : INTEGER := 62500;
              N_bits_LEDtm : INTEGER := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

CONSTANT max_count_FSMD_sig : INTEGER := 6;
CONSTANT Hz_800_LEDtm_sig : INTEGER := 4;         
CONSTANT N_bits_LEDtm_sig : INTEGER := 2;      
     
SIGNAL clk_sig : STD_LOGIC;                         
SIGNAL rst_sig : STD_LOGIC;                         
SIGNAL input_signal_sig : STD_LOGIC;                
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : debouncing_immediate_testing_circuit_FSMD_Moore
    generic map ( max_count_FSMD => max_count_FSMD_sig,
                  Hz_800_LEDtm => Hz_800_LEDtm_sig,
                  N_bits_LEDtm => N_bits_LEDtm_sig)
    Port map ( clk => clk_sig,
               rst => rst_sig,
               input_signal => input_signal_sig,
               sseg_out => sseg_out_sig,
               ena_out => ena_out_sig);

clck : process
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
    WAIT FOR 120 ns;
    
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    input_signal_sig <= '0';
    WAIT FOR 20 ns;
    input_signal_sig <= '1';
    WAIT FOR 20 ns;
    input_signal_sig <= '0';
    WAIT FOR 120 ns;
    
end process;

end Behavioral;
