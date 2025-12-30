library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity fibonacci is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           index : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR(19 DOWNTO 0);
           overflow : out STD_LOGIC);
end fibonacci;

architecture Behavioral of fibonacci is

type FSM_state IS (idle, op, done);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL t0_reg, t0_next, t1_reg, t1_next : INTEGER RANGE 0 TO 2**20;
SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO 32;

-- fib(n) = fib(n-1) + fib(n-2)
--        = t1 + t0

begin
    process(clk, rst)
    begin
        -- =================
        -- registers
        -- =================
        IF rst = '0' then
            state_reg <= idle;
            counter_reg <= 0;
            t1_reg <= 0;
            t0_reg <= 0;
        ELSIF rising_edge(clk) then
            state_reg <= state_next;        
            counter_reg <= counter_next;
            t1_reg <= t1_next;
            t0_reg <= t0_next;
        END IF;
    end process;
    
    process(state_reg, counter_reg, t1_reg, t0_reg, start)
    begin
        -- =================
        -- default
        -- =================
        state_next <= state_reg;     
        counter_next <= counter_reg; 
        t1_next <= t1_reg;           
        t0_next <= t0_reg;
        done_tick <= '0';
        ready <= '0';
        overflow <= '0';
               
        -- =================
        -- next_state
        -- =================
        CASE state_reg IS
            when idle =>
                ready <= '1';
                IF start = '1' THEN
                    state_next <= op;
                    t1_next <= 1;
                    t0_next <= 0;
                    counter_next <= to_integer(unsigned(index));
                END IF;
            when op =>
                IF counter_reg = 0 then
                    t1_next <= 0;
                else
                    IF counter_reg = 1 THEN
                        state_next <= done;
                    else
                        t1_next <= t1_reg + t0_reg;
                        t0_next <= t1_reg;
                        counter_next <= counter_reg -1;
                    END if;
                END IF;
            when done =>
                done_tick <= '1';
                state_next <= idle;
                IF t1_reg > 9999 then
                    overflow <= '1';
                END IF;
        END CASE;
        
        -- =================
        -- output
        -- =================
        result <= std_logic_vector(to_unsigned(t1_reg, 20));
        
    end process;
end Behavioral;
