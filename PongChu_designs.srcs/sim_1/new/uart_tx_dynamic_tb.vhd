library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity uart_tx_dynamic_tb is
--  Port ( );
end uart_tx_dynamic_tb;

architecture Behavioral of uart_tx_dynamic_tb is

COMPONENT uart_tx_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tx_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           tx_start : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           tx_out : out STD_LOGIC;
           done : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                   
SIGNAL rst_sig : STD_LOGIC;                   
SIGNAL tx_in_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL tx_start_sig : STD_LOGIC;              
SIGNAL s_tick_sig : STD_LOGIC;                
SIGNAL d_nums_sig : STD_LOGIC;
SIGNAL s_nums_sig : STD_LOGIC;
SIGNAL par_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL tx_out_sig : STD_LOGIC;               
SIGNAL done_sig : STD_LOGIC;                

begin
UUT : uart_tx_dynamic
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            tx_in => tx_in_sig, 
            tx_start => tx_start_sig,
            s_tick => s_tick_sig,
            d_nums => d_nums_sig,
            s_nums => s_nums_sig,
            par => par_sig,
            tx_out => tx_out_sig,
            done => done_sig);
            
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

s_tick_from_modulo_counter : process
begin
    s_tick_sig <= '1'; -- whatever s_tick frequency here, as long as it's lower than clock rate
    WAIT FOR 20 ns;
    s_tick_sig <= '0';
    WAIT FOR 20 ns;
end process;

test_vector : process
begin
    -- reset + initial parameters
    rst_sig <= '0';
    tx_in_sig <= "11001010";
    tx_start_sig <= '0';
    d_nums_sig <= '0';
    s_nums_sig <= '0';
    par_sig <=  "00";
    WAIT FOR 50 ns;
    
    -- end of reseet
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    -- start : 7 data bits, 1 stop bit, no parity scheme
    tx_start_sig <= '1';
    WAIT FOR 20 ns;
    tx_start_sig <= '0';
    WAIT FOR 8000 ns;
    
    -- 8 data bits, 1 stop bit, no parity scheme
    d_nums_sig <= '1';
    s_nums_sig <= '0';
    par_sig <=  "00"; 
    WAIT FOR 20 ns;
    tx_start_sig <= '1';
    WAIT FOR 20 ns;
    tx_start_sig <= '0';
    WAIT FOR 8000 ns;
    
    -- 8 data bits, 2 stop bit, no parity scheme
    d_nums_sig <= '1';
    s_nums_sig <= '1';
    par_sig <=  "00"; 
    WAIT FOR 20 ns;
    tx_start_sig <= '1';
    WAIT FOR 20 ns;
    tx_start_sig <= '0';
    WAIT FOR 8000 ns;
    
    -- 8 data bits, 1 stop bit, even parity scheme
    d_nums_sig <= '1';
    s_nums_sig <= '1';
    par_sig <=  "10"; 
    WAIT FOR 20 ns;
    tx_start_sig <= '1';
    WAIT FOR 20 ns;
    tx_start_sig <= '0';
    WAIT FOR 8000 ns;
    
    -- 8 data bits, 1 stop bit, odd parity scheme
    d_nums_sig <= '1';
    s_nums_sig <= '1';
    par_sig <=  "01"; 
    WAIT FOR 20 ns;
    tx_start_sig <= '1';
    WAIT FOR 20 ns;
    tx_start_sig <= '0';
    WAIT FOR 8000 ns;
    
    
end process;

end Behavioral;
