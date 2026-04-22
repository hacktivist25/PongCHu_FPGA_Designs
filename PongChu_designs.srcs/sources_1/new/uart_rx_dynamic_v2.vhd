library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity uart_rx_dynamic_v2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           rx_word : out STD_LOGIC_VECTOR(9 DOWNTO 0); -- maximum of 8 data bits + 2 error bits (parity and frame error)
           ready : out STD_LOGIC;
           done : out STD_LOGIC);
end uart_rx_dynamic_v2;

architecture Behavioral of uart_rx_dynamic_v2 is

type FSM_state IS (idle, start_bit, data, parity, stop, done_state);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL s_count_reg, s_count_next : UNSIGNED( 3 DOWNTO 0 ); -- counting s_ticks for oversampling (x16)
SIGNAL n_count_reg, n_count_next : UNSIGNED( 2 DOWNTO 0 ); -- counting number of bits received
SIGNAL w_reg, w_next : STD_LOGIC_VECTOR( 9 DOWNTO 0 ); -- output register
SIGNAL parity_bit_reg, parity_bit_next : STD_LOGIC; -- special registers for parity bits
SIGNAL err_reg, err_next : STD_LOGIC_VECTOR(1 DOWNTO 0); -- special registers for parity and frame error

SIGNAL d_nums_reg, d_nums_next:  STD_LOGIC; -- saving n° of stop bits expected at starting frame
SIGNAL s_nums_reg, s_nums_next:  STD_LOGIC; -- saving n° of stop bits expected at starting frame
SIGNAL par_reg, par_next :  STD_LOGIC_VECTOR( 1 DOWNTO 0 ); -- saving parity_bit_scheme expected at starting frame

SIGNAL rx_prev_reg : STD_LOGIC; -- holds previous value of RX to detect falling edge
SIGNAL rx_reg : STD_LOGIC; -- holds actual value of RX to make robust design free from metastability

begin
    process (clk, rst) 
    begin
        -- ======================
        -- registers
        -- ======================
        IF rst = '0' THEN
            state_reg <= idle;
            s_count_reg <= (OTHERS => '0');
            n_count_reg <= (OTHERS => '0');
            w_reg <= (OTHERS => '0');
            parity_bit_reg <= '0';
            err_reg <= "00";
            d_nums_reg <= '0';
            s_nums_reg <= '0';
            par_reg <= (OTHERS => '0');
            rx_prev_reg <= '1';
            rx_reg <= '1';
        ELSIF rising_edge(clk) then
            state_reg <= state_next;
            s_count_reg <= s_count_next;
            n_count_reg <= n_count_next;
            w_reg <= w_next;
            parity_bit_reg <= parity_bit_next;
            err_reg <= err_next;
            d_nums_reg <= d_nums_next;
            s_nums_reg <= s_nums_next;
            par_reg <= par_next;
            rx_prev_reg <= rx_reg;
            rx_reg <= rx_in;
        END IF;
    end process;
    
    process (rx_reg, s_tick, state_reg, s_count_reg, n_count_reg, w_reg, parity_bit_reg, err_reg, d_nums_reg, s_nums_reg, par_reg, rx_prev_reg)
    variable clear_s_count : STD_LOGIC;
    variable inc_s_count : STD_LOGIC;
    variable clear_n_count : STD_LOGIC;
    variable inc_n_count : STD_LOGIC;
    variable receive_bit : STD_LOGIC;
    variable receive_par_bit : STD_LOGIC;
    variable clear_registers : STD_LOGIC;
    variable save_param : STD_LOGIC;
    
    variable nb_bits : NATURAL;
    variable nb_stop_bits : NATURAL;
    
    variable is_odd : STD_LOGIC; -- 1 if number of '1' in received data bit is odd
    
    variable w_var : STD_LOGIC_VECTOR(7 DOWNTO 0); -- intermediate value for receiving register
    variable err_var : STD_LOGIC_VECTOR(1 DOWNTO 0); -- intermediate value for receiving error register
    
    begin
        -- ======================
        -- default
        -- ======================
        state_next <= state_reg;
        s_count_next <= s_count_reg;
        n_count_next <= n_count_reg;
        w_var := w_reg(7 DOWNTO 0);
        err_var := err_reg;
        w_next(7 DOWNTO 0) <= w_var;
        parity_bit_next <= parity_bit_reg;
        done <= '0';
        ready <= '0';
        
        d_nums_next <= d_nums_reg;
        s_nums_next <= s_nums_reg;
        par_next <= par_reg;
        
        clear_s_count := '0';
        inc_s_count := '0';
        clear_n_count := '0';
        inc_n_count := '0';
        receive_bit := '0';
        receive_par_bit := '0';
        clear_registers := '0';
        save_param := '0';

        
        -- ======================
        -- next-state logic
        -- ======================
        CASE state_reg IS 
            WHEN idle =>
            ready <= '1';
                IF rx_reg = '0' AND rx_prev_reg = '1' THEN -- start bit
                    state_next <= start_bit;
                    clear_s_count := '1';
                    clear_registers := '1';
                    save_param := '1';
                END IF;
            WHEN start_bit =>
                IF s_tick = '1' then
                    IF s_count_reg = 7 then
                        clear_s_count := '1';
                        clear_n_count := '1';
                        state_next <= data;
                    ELSE
                       inc_s_count := '1';
                    END IF;
                END IF;
            WHEN data =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 THEN
                        clear_s_count := '1';
                        receive_bit := '1';
                        if n_count_reg = nb_bits - 1 then
                            clear_n_count := '1';
                            IF (par_reg(1) XOR par_reg(0)) = '1' THEN
                                state_next <= parity;
                            ELSE
                                state_next <= stop;
                            END IF;
                        ELSE
                            inc_n_count := '1';
                        END IF;
                    ELSE
                        inc_s_count := '1';
                    END IF;
                END IF;
            WHEN parity =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 then
                        receive_par_bit := '1';
                        clear_s_count := '1';
                        state_next <= stop;
                    else
                        inc_s_count := '1';
                    END IF;
                END IF;
            WHEN stop =>
                IF s_tick = '1' then
                    IF s_count_reg =  15 then
                        clear_s_count := '1';
                        IF rx_reg = '0' THEN -- stop bit shall be '1' then ERROR
                            err_var(0) := '1'; -- raise frame error flag
                        END IF;
                        IF n_count_reg = nb_stop_bits - 1 THEN
                            state_next <= done_state;
                        ELSE
                            inc_n_count := '1';
                        END IF;
                    else
                        inc_s_count := '1';
                    END IF;
                END IF;
            WHEN done_state =>
                done <= '1';
                state_next <= idle;
            END CASE;
            
        -- ======================
        -- data
        -- ======================
        
        -- number of bits
        IF d_nums_reg = '0' then
            nb_bits := 7;
        ELSE
            nb_bits := 8;
        END IF;
       -- number of stop bits
        IF s_nums_reg = '0' then
            nb_stop_bits := 1;
        ELSE
            nb_stop_bits := 2;
        END IF;
        
        -- oversampling counter
        IF clear_s_count = '1' then
            s_count_next <= (OTHERS => '0');
        ELSIF inc_s_count = '1' THEN
             s_count_next <= s_count_reg + 1;
        END IF;
        -- received bits counter
        IF clear_n_count = '1' then
            n_count_next <= (OTHERS => '0');
        ELSIF inc_n_count = '1' then
            n_count_next <= n_count_reg + 1;
        END IF;
        
        -- bit receiving method
        IF receive_bit = '1' THEN
            w_var(to_integer(n_count_reg)):= rx_reg;
            w_next(7 DOWNTO 0) <= w_var;
        END if;
        IF receive_par_bit = '1' THEN
            parity_bit_next <= rx_reg;
        END IF;
        
        -- registers cleaning at start
        IF clear_registers = '1' THEN
            w_next <= (OTHERS => '0');
            parity_bit_next <= '0';
            err_var := "00";
        END IF;
        
        -- saving parameters when a frame is starting
        IF save_param = '1' THEN
            d_nums_next <= d_nums;
            s_nums_next <= s_nums;
            par_next <= par;
        END IF;
        
        -- parity error
        is_odd := w_reg(7) XOR w_reg(6) XOR w_reg(5) XOR w_reg(4) XOR w_reg(3) XOR w_reg(2) XOR w_reg(1) XOR w_reg(0);
        CASE par_reg is
            WHEN "10" => -- even parity scheme
                IF (is_odd XOR parity_bit_reg) = '1' then
                    err_var(1) := '1';
                else   
                    err_var(1) := '0';
                END IF;
            WHEN "01" => -- odd parity scheme
                IF (is_odd XOR parity_bit_reg) = '1' then
                    err_var(1) := '0';
                else   
                    err_var(1) := '1';
                END IF;
            WHEN OTHERS => -- no parity scheme parity scheme
                err_var(1) := '0';
            END CASE;
            
            -- 2 MSBs of rx word are for error bits (parity and frame error)
            w_next(9 DOWNTO 8) <= err_var;
            err_next <= err_var;
    end process;
     -- ======================
     -- output                
     -- ======================
    rx_word <= w_reg;

end Behavioral;
