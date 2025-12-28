library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity debouncing_FSMD_Moore_immediate is
    Generic ( max_count : INTEGER := 1_000_000); -- max_count x 20 ns = 20 ms
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           debounced_signal : out STD_LOGIC;
           debounced_tick : out STD_LOGIC);
end debouncing_FSMD_Moore_immediate;

architecture Behavioral of debouncing_FSMD_Moore_immediate is

type FSM_state is (stable, ignore);
SIGNAL state_reg, state_next : FSM_state;
SIGNAL output_reg, output_next : STD_LOGIC;

SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO max_count-1;
SIGNAL count_begin, count_enable : STD_LOGIC;
SIGNAL zero : STD_LOGIC;

begin
    -- ================
    -- registers
    -- ================
    process(clk, rst)
    begin
        IF rst = '0' then
            state_reg <= stable;
            output_reg <= '0';
            counter_reg <= max_count -1;
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
            output_reg <= output_next;
            counter_reg <= counter_next;
        END IF;
    end process;
    
    -- ================
    -- counter
    -- ================
    counter_next <= max_count - 1 WHEN count_begin = '1' ELSE 
    counter_reg - 1 WHEN counter_reg /= 0 AND count_enable = '1' ELSE 
    counter_reg;
    
    zero <= '1' WHEN (counter_reg = 0) ELSE '0';
    
    
    process(input_signal, state_reg, output_reg, counter_reg, zero)
    begin
    -- ================
    -- default_values
    -- ================
        output_next <= output_reg;
        state_next <= state_reg;
        count_begin <= '0';
        count_enable <= '0';
        debounced_tick <= '0';
    -- ================
    -- next_state logic
    -- ================
        IF state_reg = stable THEN
            IF input_signal /= output_reg THEN
                output_next <= input_signal;
                state_next <= ignore;
                count_begin <= '1';
                debounced_tick <= '1';
            END IF;
        ELSIF state_reg = ignore then
            IF zero = '1' THEN
                state_next <= stable;
            ELSE
                count_enable <= '1';
            END IF;
        END IF;
        
    -- ================
    -- output
    -- ================
    debounced_signal <= output_reg;
    end process;

end Behavioral;
