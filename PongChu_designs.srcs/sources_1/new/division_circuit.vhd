library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity division_circuit is
    Generic ( W : INTEGER := 30;
              N_bits : INTEGER := 5); -- log2(W) +1
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           divisor : in STD_LOGIC_VECTOR (W-1 DOWNTO 0); -- 101 to 1 000 000
           quotient : out STD_LOGIC_VECTOR (W-1 DOWNTO 0); -- 0 to 9999 
           remainder : out STD_LOGIC_VECTOR (W-1 DOWNTO 0); -- 0 to 999
           done_tick : out STD_LOGIC;
           ready : out STD_LOGIC);
end division_circuit;

architecture Behavioral of division_circuit is

CONSTANT BILLION_CONST : STD_LOGIC_VECTOR(W-1 DOWNTO 0) := "111101000010010000000000000000"; -- 1 024 000 000

-- 1 000 000 µs / prediod = frequency
-- to obtain 3 digits (10 bits) of mHz precision, we multiply dividend by 2^10 (1024) , hence the "billion constant"

type FSM_state IS (idle, op, last, done);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL rh_reg, rh_next, rl_reg, rl_next : STD_LOGIC_VECTOR (W-1 DOWNTO 0);
SIGNAL d_reg, d_next : STD_LOGIC_VECTOR (W-1 DOWNTO 0);
SIGNAL n_reg, n_next : INTEGER RANGE 0 TO W;

begin
    process(clk, rst)
    begin
        IF rst = '0' then
            state_reg <= idle;
            rh_reg <= (OTHERS => '0');
            rl_reg <= (OTHERS => '0');
            d_reg <= (OTHERS => '0');
            n_reg <= 0;
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
            rh_reg <= rh_next;
            rl_reg <= rl_next;
            d_reg <= d_next; 
            n_reg <= n_next; 
        END IF;
    end process;
    
    process(state_reg, rh_reg, rl_reg, d_reg, n_reg, start)
    variable rh_temp : STD_LOGIC_VECTOR(W-1 DOWNTO 0);
    variable q_bit : STD_LOGIC;
    begin
        rh_temp := rh_reg;
    
        state_next <= state_reg;
        ready <= '0';
        done_tick <= '0';
        rh_next <= rh_temp;
        rl_next <= rl_reg;
        d_next <= d_reg;
        n_next <= n_reg;
        q_bit := '0';
        
        IF unsigned(rh_temp) >= unsigned(d_reg) THEN       
            rh_temp := std_logic_vector(unsigned(rh_temp) - unsigned(d_reg));
            q_bit := '1';
        END IF;
        
        CASE state_reg is
            WHEN idle =>
                ready <= '1';
                IF start = '1' THEN 
                    rh_next <= (OTHERS => '0');
                    rl_next <= BILLION_CONST;
                    d_next <= divisor;
                    n_next <= W;
                    state_next <= op;
                end IF;
            WHEN op =>
                rl_next <= rl_reg(W-2 DOWNTO 0) & q_bit;
                rh_next <= rh_temp(W-2 DOWNTO 0) & rl_reg(W-1);
                n_next <= n_reg - 1;
                IF n_reg = 1 then
                    state_next <= last;
                END IF;
            WHEN last =>
                rl_next <= rl_reg (W-2 DOWNTO 0) & q_bit;
                rh_next <= rh_temp;
                state_next <= done;
            WHEN done =>
                done_tick <= '1';
                state_next <= idle;
        END CASE;
        
        -- output 
        quotient <= rl_reg;
        remainder <= rh_reg;
    end process;

end Behavioral;