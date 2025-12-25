library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncing_FSM_Moore is
generic (   LIMIT : INTEGER := 500_000; -- 10ms/20ns = 500k, log2(500k) = 19 => N=19
            N : INTEGER := 19); -- 10ms/20ns = 500k, log2(500k) = generic
            -- N is useless here, because I wanted to do an STD_LOGIC_VECTOR(N-1 DOWNTO 0) for the free-running counter...
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           debounced_signal : out STD_LOGIC);
end debouncing_FSM_Moore;
-- considering 20ms debouncing time, and a clock of 50MHz

architecture Behavioral of debouncing_FSM_Moore is

-- FSM states
type FSM_state is (zero, wait_zero_0, wait_zero_1, wait_zero_2, one, wait_one_0, wait_one_1, wait_one_2);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO LIMIT-1;
SIGNAL tick_10ms : STD_LOGIC;

begin
    --==============================
    -- Free running 10ms counter
    --==============================
    process (clk)
    begin
        IF rising_edge(clk) THEN
            counter_reg <= counter_next;
        END IF;
    end process;
    counter_next <= counter_reg + 1 WHEN counter_reg < LIMIT - 1 ELSE 0; -- free-running, no reset
    tick_10ms <= '0' WHEN counter_reg = LIMIT-1 ELSE '1';
    
    --==============================
    -- registers
    --==============================
    process(clk, rst)
    begin
        IF rising_edge(clk) THEN
            IF rst = '0' THEN -- then
                state_reg <= zero;
            ELSE
                state_reg <= state_next;
            END IF;
        END IF;
    end process;
    

    process (state_reg, input_signal,tick_10ms)
    begin
        --==============================
        -- default value
        --==============================
        state_next <= state_reg;
        debounced_signal <= '0';
        
        --==============================
        -- next_state
        --==============================
        CASE state_reg IS
            when zero =>
                IF input_signal = '1' then
                    state_next <= wait_zero_0;
                END IF;
            when wait_zero_0 =>
                IF input_signal = '1' THEN
                    IF tick_10ms = '1' THEN
                        state_next <= wait_zero_1;
                    END IF;
                ELSE
                    state_next <= zero;
                END IF;
            when wait_zero_1 =>
                IF input_signal = '1' THEN
                    IF tick_10ms = '1' THEN
                        state_next <= wait_zero_2;
                    END IF;
                ELSE
                    state_next <= zero;
                END IF;
            when wait_zero_2 =>
                IF input_signal = '1' THEN
                    IF tick_10ms = '1' THEN
                        state_next <= one;
                    END IF;
                ELSE
                    state_next <= zero;
                END IF;
            when one =>
                IF input_signal = '0' then
                    state_next <= wait_one_0;
                END IF;
            when wait_one_0 =>
                IF input_signal = '0' THEN
                    IF tick_10ms = '1' THEN
                        state_next <= wait_one_1;
                    END IF;
                ELSE
                    state_next <= one;
                END IF;
            when wait_one_1 =>
                IF input_signal = '0' THEN
                    IF tick_10ms = '1' THEN
                        state_next <= wait_one_2;
                    END IF;
                ELSE
                    state_next <= one;
                END IF;
            when wait_one_2 =>
                IF input_signal = '0' THEN
                    IF tick_10ms = '1' THEN
                        state_next <= zero;
                    END IF;
                ELSE
                    state_next <= one;
                END IF;
        END CASE;
        
        --==============================
        -- output
        --==============================
        IF state_reg = zero OR state_reg = wait_zero_0 OR state_reg = wait_zero_1 OR state_reg = wait_zero_2 then
            debounced_signal <= '0';
        ELSE 
            debounced_signal <= '1';
        END IF;
        
    end process;
    
end Behavioral;
