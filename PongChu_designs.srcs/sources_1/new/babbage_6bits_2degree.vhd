library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- we consider a polynome of second degree f(n) = an² + bn +c
-- g(n) = f(n) - f(n-1) = a(2n-1) + b
-- we let a, b and c be coded in 4 bits signed
-- therefore, the maximum polynom is f(n) = 7(n² + n + 1)
-- n_max = 2^6 -1 = 63
-- f(63) = 28231
-- log2(28231) = 14.7 
-- so output size = 15 bits
entity babbage_6bits_2degree is
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
end babbage_6bits_2degree;

architecture Behavioral of babbage_6bits_2degree is
type FSM_state IS (idle, op, done);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL f_reg, f_next : SIGNED(15 DOWNTO 0);
SIGNAL g_reg, g_next : SIGNED(11 DOWNTO 0);
SIGNAL C_reg, C_next : SIGNED(4 DOWNTO 0);
SIGNAL counter_reg, counter_next : UNSIGNED (5 DOWNTO 0);
-- about g size : 
-- g(n) = f(n) - f(n-1) = a(2n-1) + b
-- |a| and |b| <= 7, n <= 63, therefore |g_max| =7*(125) + 7 = 882  and log2(882) < 10
-- therefore, we nee d10 bits if unsigned, 11 bits if signed for g register

begin
    -- ==================
    -- registers
    -- ==================
    process (clk, rst)
    begin
        IF rst = '0' then   
            state_reg <= idle;
            f_reg <= (OTHERS => '0');
            g_reg <= (OTHERS => '0');
            C_reg <= (OTHERS => '0');
            counter_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
            f_reg <= f_next;
            g_reg <= g_next;
            C_reg <= C_next;
            counter_reg <= counter_next;
        END IF;
    end process;

    process (state_reg, f_reg, g_reg, C_reg, start, counter_reg)
    variable load_var : STD_LOGIC;
    variable calculate_var : STD_LOGIC;
    variable decrement_counter : STD_LOGIC;
    begin
    -- ==================
    -- default
    -- ==================
        state_next <= state_reg;
        f_next <= f_reg;
        g_next <= g_reg;
        C_next <= C_reg;
        ready <= '0';
        done_tick <= '0';
        
        load_var := '0';
        calculate_var := '0';
        decrement_counter := '0';
        
    -- ==================
    -- next_state
    -- ==================
        CASE state_reg IS
            WHEN idle =>
                ready <= '1';
                IF start = '1' THEN
                    load_var := '1';
                    state_next <= op;
                END IF;
            WHEN op =>
                IF counter_reg = 0 then
                    state_next <= done;
                ELSIF counter_reg = 1 THEN
                    calculate_var := '1';
                    state_next <= done;
                ELSE
                    calculate_var := '1';
                    decrement_counter := '1';
                END IF;
            WHEN done =>
                done_tick <= '1';
                state_next <= idle;
        END CASE;
    -- ==================
    -- calculation
    -- ==================
    IF load_var = '1' THEN
        counter_next <= n;
        C_next <= C;
        f_next <= resize(f_init, f_reg'length); -- f(0) charged in register (4 bits out of 16)
        g_next <= resize(g_init, g_reg'length); -- g(1) charged in register (5 bits out of 12 )   
    END IF;
    
    IF calculate_var = '1' then
        f_next <= f_reg + g_reg;
        g_next <= g_reg + C_reg;
    END IF;
    
    IF decrement_counter = '1' THEN
        counter_next <= counter_reg - 1;
    END IF;
    
    
    -- ==================
    -- output
    -- ==================
    f_out <= f_reg; 
    end process;

end Behavioral;
