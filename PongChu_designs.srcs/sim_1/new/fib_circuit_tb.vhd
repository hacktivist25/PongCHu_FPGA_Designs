library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity fib_circuit_tb is
--  Port ( );
end fib_circuit_tb;

architecture Behavioral of fib_circuit_tb is

COMPONENT fib_circuit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           BCD_in : in STD_LOGIC_VECTOR(7 DOWNTO 0); -- 2 BCD digits for fibonacci which goes up to 31 (5 bits input only)
           BCD_out : out STD_LOGIC_VECTOR(15 DOWNTO 0); --4 BCD output digits = fibonacci result
           done : out STD_LOGIC;
           ready : out STD_LOGIC;
           overflow_out : out STD_LOGIC);
end COMPONENT;

SIGNAL clk_sig : STD_LOGIC;                         
SIGNAL rst_sig : STD_LOGIC;                         
SIGNAL start_sig : STD_LOGIC;                       
SIGNAL BCD_in_sig : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL BCD_out_sig : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL done_sig : STD_LOGIC;                       
SIGNAL ready_sig : STD_LOGIC;                      
SIGNAL overflow_out_sig : STD_LOGIC;              

begin
UUT : fib_circuit
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            start => start_sig,
            BCD_in => BCD_in_sig,
            BCD_out => BCD_out_sig,
            done => done_sig,
            ready => ready_sig,
            overflow_out => overflow_out_sig);

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
    BCD_in_sig <= "00001000"; -- 0 8 (2 digits)
    WAIT FOR 50 ns;
    
    -- normal case : fib(8) = 21
    rst_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 700 ns;
    
    -- OVERFLOW case : fib(22) = 17711 > 9999
    BCD_in_sig <= "00100010"; -- 2 2 (2 digits)
    WAIT FOR 20 ns;
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 1000 ns;
    
end process;
end Behavioral;
