----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2025 11:14:07
-- Design Name: 
-- Module Name: enhanced_stopwatch_tb - Behavioral
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

entity enhanced_stopwatch_tb is
--  Port ( );
end enhanced_stopwatch_tb;

architecture Behavioral of enhanced_stopwatch_tb is

COMPONENT enhanced_stopwatch is
    GENERIC ( hundred_ms : INTEGER := 5_000_000); --condidering a 50MHz clock
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           up : in STD_LOGIC;
           go : in STD_LOGIC;
           clr : in STD_LOGIC;
           m, ds : out STD_LOGIC_VECTOR(3 DOWNTO 0); --m : minute, ds : 0.1seconds (0 to 9)
           ss : out STD_LOGIC_VECTOR(5 DOWNTO 0)); -- seconds (0 to 59)
end COMPONENT;

CONSTANT hundred_ms_sig: INTEGER := 2; -- each 2 clock cycles = 100 ms
SIGNAL clk_sig : STD_LOGIC;                      
SIGNAL rst_sig : STD_LOGIC;                      
SIGNAL up_sig : STD_LOGIC;             
SIGNAL go_sig : STD_LOGIC;                       
SIGNAL clr_sig : STD_LOGIC;                      
SIGNAL m_sig, ds_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ss_sig : STD_LOGIC_VECTOR(5 DOWNTO 0); 

begin
UUT : enhanced_stopwatch 
GENERIC MAP(hundred_ms => hundred_ms_sig)
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            up => up_sig, 
            go => go_sig, 
            clr => clr_sig,
            m => m_sig,
            ds => ds_sig, 
            ss => ss_sig);
            
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10ns;
    clk_sig <= '0';
    WAIT FOR 10ns;
end process;

test_vector : process
begin
    -- reset
    rst_sig <= '0'; 
    up_sig <= '1'; 
    go_sig <= '1'; 
    clr_sig <= '0';
    WAIT FOR 50 ns;
    
    rst_sig <= '1'; 
    WAIT FOR 1000 ns;
    
    go_sig <= '0';
    WAIT FOR 100 ns;
    
    clr_sig <= '1';
    up_sig <= '0';
    WAIT FOR 60 ns;
    
    clr_sig <= '0';
    WAIT FOR 60 ns;
    
    go_sig <= '1';
    WAIT FOR 1000 ns;
    
end process;

end Behavioral;