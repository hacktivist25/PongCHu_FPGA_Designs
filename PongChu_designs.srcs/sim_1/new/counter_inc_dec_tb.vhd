library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity counter_inc_dec_tb is
--  Port ( );
end counter_inc_dec_tb;

architecture Behavioral of counter_inc_dec_tb is

COMPONENT counter_inc_dec is
    generic ( max_value : INTEGER := 12); -- between 0 and 15, since I do a 4 bits counter
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           inc : in STD_LOGIC; -- increment signal
           dec : in STD_LOGIC; -- decrement signal
           counter_out : out STD_LOGIC_VECTOR(3 DOWNTO 0)); -- count from 0 max value
end COMPONENT;

CONSTANT max_value_sig : INTEGER := 12;
SIGNAL clk_sig : STD_LOGIC;                             
SIGNAL rst_sig : STD_LOGIC;                             
SIGNAL inc_sig : STD_LOGIC;      
SIGNAL dec_sig : STD_LOGIC;      
SIGNAL counter_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
UUT : counter_inc_dec
GENERIC MAP(max_value => max_value_sig)
PORT MAP(   clk => clk_sig,
            rst => rst_sig,
            inc => inc_sig,
            dec => dec_sig,
            counter_out => counter_out_sig);

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10ns;
    clk_sig <= '0';
    WAIT FOR 10ns;
end process;

test_vector : process
begin
-- rst
    rst_sig <= '0';
    inc_sig <= '0';
    dec_sig <= '0';
    WAIT FOR 50 ns;
    
    -- end of reset
    rst_sig <= '1';
    WAIT FOR 20ns;
    
    -- ===========================
    -- between 2 clocks scenarios
    -- ===========================
    -- dec while 0
    dec_sig <= '1';
    WAIT FOR 20ns;
    dec_sig <= '0';
    WAIT FOR 20ns;
    
    -- increase to max
    inc_sig <= '1';
    WAIT FOR 280ns;
    
    -- pause
    inc_sig <= '0';
    WAIT FOR 40ns;
    
    -- decrease from max
    dec_sig <= '1';
    WAIT FOR 90ns;
    
    -- ===========================
    -- at clock rising edge scenarios
    -- ===========================
    -- decrease
    dec_sig <= '1';
    WAIT FOR 20ns;
    dec_sig <= '0';
    WAIT FOR 20ns;
    
    -- increase
    inc_sig <= '1';
    WAIT FOR 20ns;
    inc_sig <= '0';
    WAIT FOR 20ns;
end process;
    
end Behavioral;
