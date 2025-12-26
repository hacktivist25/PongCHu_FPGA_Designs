library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity debouncing_FSM_Moore_immediate is
    generic ( LIMIT : INTEGER := 500_000; -- 10ms/20ns = 500k, log2(500k) = 19 => N=19
              N : INTEGER := 19); -- 10ms/20ns = 500k, log2(500k) = generic
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           debounced_signal : out STD_LOGIC);
end debouncing_FSM_Moore_immediate;

architecture Behavioral of debouncing_FSM_Moore_immediate is

-- FSM states
type FSM_state is (zero, ignore_from_0, one, ignore_from_1);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO LIMIT-1;
SIGNAL tick_10ms : STD_LOGIC;
SIGNAL clr_counter_of_tick : STD_LOGIC;
SIGNAL number_of_tick_reg, number_of_tick_next : INTEGER RANGE 0 TO 2; -- responsible of counting 3 ticks when ignoring input

begin
    --==============================
    -- Free running 10ms counter and counter of ticks
    --==============================
    process (clk, rst)
    begin
        IF rst = '0' then
            counter_reg <= 0;
            number_of_tick_reg <= 0;
        ELSIF rising_edge(clk) THEN
            counter_reg <= counter_next;
            number_of_tick_reg <= number_of_tick_next;
        END IF;
    end process;
    
    number_of_tick_next <= number_of_tick_reg + 1 WHEN number_of_tick_reg < 2 AND clr_counter_of_tick = '0' AND tick_10ms = '1'
    ELSE number_of_tick_reg WHEN clr_counter_of_tick = '0' AND tick_10ms = '0'
    ELSE 0;
    
    counter_next <= counter_reg + 1 WHEN counter_reg < LIMIT - 1 ELSE 0; -- free-running
    tick_10ms <= '1' WHEN counter_reg = LIMIT-1 ELSE '0';
    
    --==============================
    -- registers
    --==============================
    process(clk, rst)
    begin
        IF rst = '0' THEN
            state_reg <= zero;
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
        END IF;
    end process;
    
    process (state_reg, input_signal, number_of_tick_reg)
        variable ns : FSM_state;
    begin
        --==============================
        -- default value
        --==============================
        ns := state_reg;
        debounced_signal <= '0';
        clr_counter_of_tick <= '0';
        
        --==============================
        -- next_state
        --==============================
        CASE state_reg IS
            when zero =>
                IF input_signal = '1' then
                    ns := ignore_from_0;
                END IF;
            when ignore_from_0 =>
                IF number_of_tick_reg = 2 THEN
                    IF input_signal = '1' THEN
                        ns := one;
                    ELSE -- input_signal = 0
                        ns := zero;
                    END IF;
                END IF;
            when one =>
                IF input_signal = '0' then
                    ns := ignore_from_1;
                END IF;
            when ignore_from_1 =>
                IF number_of_tick_reg = 2 THEN
                    IF input_signal = '1' THEN
                        ns := one;
                    ELSE -- input_signal = 0
                        ns := zero;
                    END IF;
                END IF;
        END CASE;
        
        state_next <= ns;
        
        --==============================
        -- output
        --==============================
        IF state_reg = zero OR state_reg = ignore_from_1 then
            debounced_signal <= '0';
        ELSE 
            debounced_signal <= '1';
        END IF;
        
        --==============================
        -- control signal for counter of ticks
        --==============================
        IF (state_reg = zero AND ns = ignore_from_0) OR (state_reg = one AND ns = ignore_from_1) then
            clr_counter_of_tick <= '1';
        ELSE
            clr_counter_of_tick <= '0';
        END IF;
        
    end process;

end Behavioral;
