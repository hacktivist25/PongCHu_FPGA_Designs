library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

 -- we consider here no spurious change in parameters (like d_nums, s_nums or par)
 -- to make it more robust, we cound register parameters input when we start to receive/transmit a frame
 -- to make it extremely robust we could allow changes only during idle, or with handshake protocols
entity uart_rx_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           rx_word : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           err : out STD_LOGIC_VECTOR(1 DOWNTO 0); -- (parity error, frame_error)
           done : out STD_LOGIC);
end uart_rx_dynamic;

architecture Behavioral of uart_rx_dynamic is

type FSM_state IS (idle, start_bit, data, parity, stop);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL s_count_reg, s_count_next : UNSIGNED( 4 DOWNTO 0 ); -- counting s_ticks for oversampling (up to 31 for 2 stop bits)
SIGNAL n_count_reg, n_count_next : UNSIGNED( 2 DOWNTO 0 ); -- counting number of bits received
SIGNAL w_reg, w_next : STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- output register
SIGNAL parity_bit_reg, parity_bit_next : STD_LOGIC; -- special registers for parity bits
SIGNAL err_reg, err_next : STD_LOGIC_VECTOR(1 DOWNTO 0); -- special registers for parity bits

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
        ELSIF rising_edge(clk) then
            state_reg <= state_next;
            s_count_reg <= s_count_next;
            n_count_reg <= n_count_next;
            w_reg <= w_next;
            parity_bit_reg <= parity_bit_next;
            err_reg <= err_next;
        END IF;
    end process;
    
    process (rx_in, s_tick, state_reg, s_count_reg, n_count_reg, w_reg, parity_bit_reg, err_reg, d_nums, s_nums, par)
    variable clear_s_count : STD_LOGIC;
    variable inc_s_count : STD_LOGIC;
    variable clear_n_count : STD_LOGIC;
    variable inc_n_count : STD_LOGIC;
    variable receive_bit : STD_LOGIC;
    variable receive_par_bit : STD_LOGIC;
    variable clear_registers : STD_LOGIC;
    
    variable nb_bits : NATURAL;
    variable nb_stop_bits : NATURAL;
    
    variable is_odd : STD_LOGIC; -- 1 if number of '1' in received data bit is odd
    
    variable w_var : STD_LOGIC_VECTOR(7 DOWNTO 0); -- intermediate value for receiving register
    begin
        -- ======================
        -- default
        -- ======================
        state_next <= state_reg;
        s_count_next <= s_count_reg;
        n_count_next <= n_count_reg;
        w_var := w_reg;
        w_next <= w_var;
        parity_bit_next <= parity_bit_reg;
        err_next <= err_reg;
        done <= '0';
        
        clear_s_count := '0';
        inc_s_count := '0';
        clear_n_count := '0';
        inc_n_count := '0';
        receive_bit := '0';
        receive_par_bit := '0';
        clear_registers := '0';

        
        -- ======================
        -- next-state logic
        -- ======================
        CASE state_reg IS 
            WHEN idle =>
                IF rx_in = '0' THEN -- start bit
                    state_next <= start_bit;
                    clear_s_count := '1';
                    clear_registers := '1';
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
                            clear_s_count := '1';
                            IF (par(1) XOR par(0)) = '1' THEN
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
                        IF rx_in = '0' THEN -- stop bit shall be '1' then ERROR
                            err_next(0) <= '1'; -- raise frame error flag
                        END IF;
                        IF n_count_reg = nb_stop_bits - 1 THEN
                            done <= '1';
                            state_next <= idle;
                        ELSE
                            inc_n_count := '1';
                        END IF;
                    else
                        inc_s_count := '1';
                    END IF;
                END IF;
            END CASE;
            
        -- ======================
        -- data
        -- ======================
        
        -- number of bits
        IF d_nums = '0' then
            nb_bits := 7;
        ELSE
            nb_bits := 8;
        END IF;
       -- number of stop bits
        IF s_nums = '0' then
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
            w_var(to_integer(n_count_reg)):= rx_in;
            w_next <= w_var;
        END if;
        IF receive_par_bit = '1' THEN
            parity_bit_next <= rx_in;
        END IF;
        
        -- registers cleaning at start
        IF clear_registers = '1' THEN
            w_next <= (OTHERS => '0');
            parity_bit_next <= '0';
            err_next <= "00";
        END IF;
        
        -- parity error
        is_odd := w_reg(7) XOR w_reg(6) XOR w_reg(5) XOR w_reg(4) XOR w_reg(3) XOR w_reg(2) XOR w_reg(1) XOR w_reg(0);
        CASE par is
            WHEN "10" => -- even parity scheme
                IF (is_odd XOR parity_bit_reg) = '1' then
                    err_next(1) <= '1';
                else   
                    err_next(1) <= '0';
                END IF;
            WHEN "01" => -- odd parity scheme
                IF (is_odd XOR parity_bit_reg) = '1' then
                    err_next(1) <= '0';
                else   
                    err_next(1) <= '1';
                END IF;
            WHEN OTHERS => -- no parity scheme parity scheme
                err_next(1) <= '0';
            END CASE;
    end process;
     -- ======================
     -- output                
     -- ======================
    rx_word <= w_reg;
    err <= err_reg;

end Behavioral;
