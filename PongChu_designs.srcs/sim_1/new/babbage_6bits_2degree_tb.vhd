library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity babbage_6bits_2degree_tb is
--  Port ( );
end babbage_6bits_2degree_tb;

architecture Behavioral of babbage_6bits_2degree_tb is

COMPONENT babbage_6bits_2degree is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           n : in UNSIGNED(5 DOWNTO 0);
           C : in SIGNED(4 DOWNTO 0); -- constant = g(n) - g(n-1) = 2a
           f_init : in SIGNED(3 DOWNTO 0); -- f(0) = c
           g_init : in SIGNED(4 DOWNTO 0); -- g(1) = b + a
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC;
           f_out : out SIGNED(15 DOWNTO 0));
end component;

SIGNAL clk_sig : STD_LOGIC;              
SIGNAL rst_sig : STD_LOGIC;              
SIGNAL start_sig : STD_LOGIC;            
SIGNAL n_sig : UNSIGNED(5 DOWNTO 0);     
SIGNAL C_sig : SIGNED(4 DOWNTO 0);       
SIGNAL f_init_sig : SIGNED(3 DOWNTO 0);  
SIGNAL g_init_sig : SIGNED(4 DOWNTO 0);  
SIGNAL ready_sig : STD_LOGIC;           
SIGNAL done_tick_sig : STD_LOGIC;       
SIGNAL f_out_sig : SIGNED(15 DOWNTO 0);

begin
UUT : babbage_6bits_2degree
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            start => start_sig,
            n => n_sig,
            C => C_sig,
            f_init => f_init_sig,
            g_init => g_init_sig,
            ready => ready_sig,
            done_tick => done_tick_sig,
            f_out => f_out_sig );

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    -- first polynom : 7n² + 7n + 7, with n = 0, 1, 2, 3, 4, and 60
    rst_sig <= '0';
    start_sig <= '0';
    n_sig <= "000000"; -- 0
    C_sig <= "01110"; -- +14
    f_init_sig <= "0111"; -- +7
    g_init_sig <= "01110"; -- +14
    WAIT FOR 50 ns;
    
    rst_sig <= '1';
    start_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '0';
    n_sig <= "000001";
    WAIT FOR 60 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "000010"; -- next time n = 2
    WAIT FOR 60 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "000011"; -- next time n = 3
    WAIT FOR 80 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "000100"; -- next time n = 4
    WAIT FOR 100 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "111100"; -- next time n = 60
    WAIT FOR 120 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 1400 ns;
    
    
    
    
    
    
    -- second polynom : -3n² + 2n - 6, with n = 0, 1, 2, 3, 4, and 60
    n_sig <= "000000"; -- 0
    C_sig <= "11010"; -- 2a = -6
    f_init_sig <= "1010"; -- c = -6
    g_init_sig <= "11111"; -- b + a = -1
    WAIT FOR 20 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    
    start_sig <= '0';
    n_sig <= "000001";
    WAIT FOR 60 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "000010"; -- next time n = 2
    WAIT FOR 60 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "000011"; -- next time n = 3
    WAIT FOR 80 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "000100"; -- next time n = 4
    WAIT FOR 100 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    n_sig <= "111100"; -- next time n = 60
    WAIT FOR 120 ns;
    
    start_sig <= '1';
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 1400 ns;
    

end process;

end Behavioral;
