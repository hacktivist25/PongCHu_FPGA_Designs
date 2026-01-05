library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity period_counter_micro is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           signal_in : in STD_LOGIC;
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC;
           prd : out STD_LOGIC_VECTOR(19 DOWNTO 0)); -- 20 bits to count up to 1 million µs = 1s
end period_counter_micro;

architecture Behavioral of period_counter_micro is
type FSM_state IS (idle, wait_edge, counting, done);
SIGNAL state_reg, state_next : FSM_state;

-- registers
SIGNAL prd_reg, prd_next : STD_LOGIC_VECTOR(19 DOWNTO 0);
SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO 49; -- 1µs period

begin
    process(clk, rst)
    begin
        IF rst = '0' THEN
            state_reg <= idle;
            counter_reg <= 0;
            prd_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
            counter_reg <= counter_next;
            prd_reg <= prd_next;
        END IF;
    END PROCESS;
    
    process(state_reg, counter_reg, prd_reg, start, signal_in)
    begin
    -- ===========================    
    -- default values   
    -- ===========================    
        ready <= '0';
        done_tick <= '0';
        prd_next <= prd_reg;
        state_next <= state_reg;
    
        CASE state_reg IS 
            when idle =>
                ready <= '1';
                IF start = '1' THEN
                    state_next <= wait_edge;
                END IF;
            when wait_edge =>
                IF signal_in = '1' then
                    state_next <= counting;
                    prd_next <= (OTHERS => '0'); -- clear previous result
                    counter_next <= 0;
                END IF;
            when counting =>
                IF signal_in = '1' then
                    state_next <= done;
                ELSE
                    IF counter_reg = 49 THEN
                        counter_next <= 0;
                        prd_next <= std_logic_vector(unsigned(prd_reg) + 1); 
                    ELSE
                        counter_next <= counter_reg + 1 ;
                    END IF;
                END IF;
            when done =>
                done_tick <= '1';
                state_next <= idle;
        END CASE;   
        
        prd <= prd_reg;
    END PROCESS;
end Behavioral;
