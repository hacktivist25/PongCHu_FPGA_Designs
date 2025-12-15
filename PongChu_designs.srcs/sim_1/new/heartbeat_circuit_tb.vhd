----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2025 08:02:16
-- Design Name: 
-- Module Name: heartbeat_circuit_tb - Behavioral
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

entity heartbeat_circuit_tb is
--  Port ( );
end heartbeat_circuit_tb;

architecture Behavioral of heartbeat_circuit_tb is

COMPONENT heartbeat_circuit is
    generic (
           --variables from LED time multiplexer
           Hz_800_LEDtm : INTEGER := 62500; 
           N_bits_LEDtm : INTEGER := 16; -- N_bits established considering ceil(  log2(Hz_800)  ) = 16
           bpm_72 : INTEGER := 41_666_666;
           N_bits : INTEGER := 26
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end COMPONENT;

CONSTANT Hz_800_LEDtm_const : INTEGER := 4; -- change display every clock cycle
CONSTANT N_bits_LEDtm_const : INTEGER := 2; 
CONSTANT bpm_72_const : INTEGER := 36; -- change frame every 12 clock cycles
CONSTANT N_bits_const : INTEGER := 6;    

SIGNAL clk_sig : STD_LOGIC;                         
SIGNAL rst_sig : STD_LOGIC;                         
SIGNAL en_sig : STD_LOGIC;                          
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : heartbeat_circuit
GENERIC MAP (   Hz_800_LEDtm => Hz_800_LEDtm_const,
                N_bits_LEDtm => N_bits_LEDtm_const,
                bpm_72 => bpm_72_const,
                N_bits => N_bits_const
) 
PORT MAP (      clk => clk_sig,  
                rst => rst_sig,
                en => en_sig,
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
    --reset
    rst_sig <= '0';
    en_sig <= '1';
    WAIT FOR 30ns;
    
    rst_sig <= '1';
    WAIT FOR 800ns;
    
    en_sig <= '0';
    WAIT FOR 600ns;
    
    en_sig <= '1';
    WAIT FOR 800ns;
 
 end process;
 end Behavioral;
