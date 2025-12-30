library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fibonacci_tb is
--  Port ( );
end fibonacci_tb;

architecture Behavioral of fibonacci_tb is

COMPONENT fibonacci is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           index : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR(19 DOWNTO 0);
           overflow : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                             
SIGNAL rst_sig : STD_LOGIC;                             
SIGNAL start_sig : STD_LOGIC;                           
SIGNAL index_sig : STD_LOGIC_VECTOR(4 DOWNTO 0);        
SIGNAL ready_sig : STD_LOGIC;                          
SIGNAL done_tick_sig : STD_LOGIC;                      
SIGNAL result_sig : STD_LOGIC_VECTOR(19 DOWNTO 0);     
SIGNAL overflow_sig : STD_LOGIC;                      

begin
UUT : fibonacci
PORT MAP(   clk =>  clk_sig,
            rst =>  rst_sig,
            start => start_sig,
            index => index_sig,
            ready => ready_sig,
            done_tick  => done_tick_sig,
            result => result_sig,
            overflow => overflow_sig);

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
    start_sig <= '0';
    index_sig <= "00101"; -- 5
    WAIT FOR 50ns;
    
    rst_sig <= '1';
    WAIT FOR 20ns;
    
    start_sig <= '1';
    WAIT FOR 20ns;
    
    start_sig <= '0';
    WAIT FOR 140ns;
    
    index_sig <= "11000"; -- 24
    start_sig <= '1';
    WAIT FOR 20ns;
    
    start_sig <= '0';
    WAIT FOR 600ns;


end process;
end Behavioral;
