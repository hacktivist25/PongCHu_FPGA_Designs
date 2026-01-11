library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity reaction_timer_tb is
--  Port ( );
end reaction_timer_tb;

architecture Behavioral of reaction_timer_tb is

COMPONENT reaction_timer is
    Generic ( ms_max : STD_LOGIC_VECTOR(15 DOWNTO 0) := "1100001101001111"); -- 49999);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clr : in STD_LOGIC;
           start : in STD_LOGIC;
           stop : in STD_LOGIC;
           sseg_out_3, sseg_out_2, sseg_out_1, sseg_out_0 : out STD_LOGIC_VECTOR(6 DOWNTO 0); -- 4 7 segment led diplays
           LED : out STD_LOGIC;
           done : out STD_LOGIC;
           ready : out STD_LOGIC);
end COMPONENT;

CONSTANT ms_max_sig : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000110001"; -- 49 to transform ms on µs for simulation purposes;

SIGNAL clk_sig : STD_LOGIC;                                                               
SIGNAL rst_sig : STD_LOGIC;                                                               
SIGNAL clr_sig : STD_LOGIC;                                                               
SIGNAL start_sig : STD_LOGIC;                                                             
SIGNAL stop_sig : STD_LOGIC;                                                              
SIGNAL sseg_out_3_sig, sseg_out_2_sig, sseg_out_1_sig, sseg_out_0_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL LED_sig : STD_LOGIC;                                                              
SIGNAL done_sig : STD_LOGIC;                                                             
SIGNAL ready_sig : STD_LOGIC;                                                           

begin
UUT : reaction_timer
GENERIC MAP (ms_max => ms_max_sig)
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            clr => clr_sig,
            start => start_sig,
            stop => stop_sig,
            sseg_out_3 => sseg_out_3_sig,
            sseg_out_2 => sseg_out_2_sig, 
            sseg_out_1 => sseg_out_1_sig,
            sseg_out_0 => sseg_out_0_sig,
            LED => LED_sig, 
            done => done_sig,
            ready => ready_sig);

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
    clr_sig <= '0';
    start_sig <= '0';
    stop_sig <= '0';
    WAIT FOR 30 ns;
    -- now in idle state - going to start
    rst_sig <= '1';
    start_sig <= '1'; -- random timer start -- 11 019 ms of delay before being able to press stop
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 11169000 ns ; -- wait enought so we have ~ 150 ms of reaction time
    
    -- stop to stop reaction timer and display result
    stop_sig <= '1';
    WAIT FOR 20 ns;
    stop_sig <= '0';
    WAIT FOR 8000 ns;
    
    -- put in idle state again
    clr_sig <= '1';
    WAIT FOR 20 ns;
    clr_sig <= '0';
    WAIT FOR 600 ns;
    
    
    
    -- second try, we will let more than 1 second of reaction time
    start_sig <= '1'; -- random timer start -- 15 168 ms of delay before being able to press stop
    WAIT FOR 20 ns;
    start_sig <= '0';
    WAIT FOR 16568000 ns ; -- wait more than 1 second to have the 9.9999s (waitd too much = more than 1 second)
    
    -- stop to stop reaction timer and display result
    stop_sig <= '1';
    WAIT FOR 20 ns;
    stop_sig <= '0';
    WAIT FOR 8000 ns;

end process;

end Behavioral;
