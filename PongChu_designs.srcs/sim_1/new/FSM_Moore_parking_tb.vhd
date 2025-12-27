----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2025 11:20:26
-- Design Name: 
-- Module Name: FSM_Moore_parking_tb - Behavioral
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

entity FSM_Moore_parking_tb is
--  Port ( );
end FSM_Moore_parking_tb;

architecture Behavioral of FSM_Moore_parking_tb is

COMPONENT FSM_Moore_parking is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a, b : in STD_LOGIC;
           entering, exiting : out STD_LOGIC);
           -- exit is a banned word in VHDL, I hate disparity
end component;

SIGNAL clk_sig : STD_LOGIC;                 
SIGNAL rst_sig : STD_LOGIC;                 
SIGNAL a_sig, b_sig : STD_LOGIC;                
SIGNAL entering_sig, exiting_sig : STD_LOGIC; 

begin
UUT : FSM_Moore_parking
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            a=> a_sig,
            b=> b_sig ,
            entering => entering_sig,
            exiting => exiting_sig);

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    -- rst
    rst_sig <= '0';
    a_sig <= '0';
    b_sig <= '0';
    WAIT FOR 50 ns;
    
    -- end of reset
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    -- entering scenario
    a_sig <= '1';
    WAIT FOR 20 ns;
    b_sig <= '1';
    WAIT FOR 20 ns;
    a_sig <= '0';
    WAIT FOR 20 ns;
    b_sig <= '0';
    WAIT FOR 60 ns;
    
    -- exiting scenario
    b_sig <= '1';
    WAIT FOR 20 ns;
    a_sig <= '1';
    WAIT FOR 20 ns;
    b_sig <= '0';
    WAIT FOR 20 ns;
    a_sig <= '0';
    WAIT FOR 20 ns;
    
end process;

end Behavioral;
