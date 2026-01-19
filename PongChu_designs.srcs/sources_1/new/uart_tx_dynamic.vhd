library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

 -- we consider here no spurious change in parameters (like d_nums, s_nums or par)
 -- to make it more robust, we cound register parameters input when we start to receive/transmit a frame
 -- to make it extremely robust we could allow changes only during idle, or with handshake protocols
entity uart_tx_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tx_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           tx_start : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           tx_out : out STD_LOGIC;
           done : out STD_LOGIC);
end uart_tx_dynamic;

architecture Behavioral of uart_tx_dynamic is

type FSM_state IS (idle, start_bit, data, parity, stop);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL s_count_reg, s_count_next : UNSIGNED( 4 DOWNTO 0 ); -- counting s_ticks for oversampling (up to 31 for 2 stop bits)
SIGNAL n_count_reg, n_count_next : UNSIGNED( 2 DOWNTO 0 ); -- counting number of bits received
SIGNAL tx_in_reg, tx_in_next : STD_LOGIC_VECTOR( 7 DOWNTO 0 ); -- registered input 
SIGNAL tx_out_reg, tx_out_next : STD_LOGIC; --- next output bit
SIGNAL parity_bit_reg, parity_bit_next : STD_LOGIC; -- special registers for parity bits

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
            tx_in_reg <= (OTHERS => '0');
            tx_out_reg <= '1';
            parity_bit_reg <= '0';
        ELSIF rising_edge(clk) then
            state_reg <= state_next;
            s_count_reg <= s_count_next;
            n_count_reg <= n_count_next;
            tx_in_reg <= tx_in_next;
            tx_out_reg <= tx_out_next;
            parity_bit_reg <= parity_bit_next;
        END IF;
    end process;
    
    process (tx_in, s_tick, state_reg, s_count_reg, n_count_reg, tx_in_reg, tx_start, parity_bit_reg, d_nums, s_nums, par)
    variable clear_s_count : STD_LOGIC;
    variable inc_s_count : STD_LOGIC;
    variable clear_n_count : STD_LOGIC;
    variable inc_n_count : STD_LOGIC;
    variable send_bit : STD_LOGIC;
    variable send_par_bit : STD_LOGIC;
    variable register_in : STD_LOGIC;
    variable send_0 : STD_LOGIC;
    variable send_1 : STD_LOGIC;
    
    
    variable nb_bits : NATURAL;
    variable nb_stop_bits : NATURAL;
    
    variable is_odd : STD_LOGIC; -- 1 if number of '1' in received data bit is odd    
    variable parity_bit : STD_LOGIC; -- 1 if number of '1' in received data bit is odd    
    begin
        -- ======================
        -- default
        -- ======================
        state_next <= state_reg;
        s_count_next <= s_count_reg;
        n_count_next <= n_count_reg;
        tx_in_next <= tx_in_reg;
        tx_out_next <= tx_out_reg;
        parity_bit_next <= parity_bit_reg;
        done <= '0';
        
        clear_s_count := '0';
        inc_s_count := '0';
        clear_n_count := '0';
        inc_n_count := '0';
        send_bit := '0';
        send_par_bit := '0';
        register_in := '0';
        send_0 := '0';
        send_1 := '0';

        
        -- ======================
        -- next-state logic
        -- ======================
        CASE state_reg IS 
            WHEN idle =>
                send_1 := '1';
                IF tx_start = '1' THEN -- start
                    state_next <= start_bit;
                    clear_s_count := '1';
                    register_in := '1';
                    send_1 := '0';
                    send_0 := '1';
                END IF;
            WHEN start_bit =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 then
                        clear_s_count := '1';
                        clear_n_count := '1';
                        send_bit := '1';
                        state_next <= data;
                    ELSE
                       inc_s_count := '1';
                    END IF;
                END IF;
            WHEN data =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 THEN
                        clear_s_count := '1';
                        if n_count_reg = nb_bits - 1 then
                            clear_n_count := '1';
                            clear_s_count := '1';
                            IF (par(1) XOR par(0)) = '1' THEN
                                send_par_bit := '1';
                                state_next <= parity;
                            ELSE
                                send_1 := '1';
                                state_next <= stop;
                            END IF;
                        ELSE
                            send_bit := '1';
                            inc_n_count := '1';
                        END IF;
                    ELSE
                        inc_s_count := '1';
                    END IF;
                END IF;
            WHEN parity =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 then
                        send_1 := '1'; -- stop bit
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
                        IF n_count_reg = nb_stop_bits - 1 then
                            send_1 := '1';
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
        
        -- parity bit calculation
        is_odd := tx_in(7) XOR tx_in(6) XOR tx_in(5) XOR tx_in(4) XOR tx_in(3) XOR tx_in(2) XOR tx_in(1) XOR tx_in(0);
        CASE par is
            WHEN "10" => -- even parity scheme
                parity_bit := is_odd;
            WHEN "01" => -- odd parity scheme
                parity_bit := NOT(is_odd);
            WHEN OTHERS =>
                parity_bit := '0';
        END CASE;
        
        -- registering input
        IF register_in = '1' then
            tx_in_next <= tx_in;
            parity_bit_next <= parity_bit;
        END IF;
            
        
        -- oversampling counter
        IF clear_s_count = '1' then
            s_count_next <= (OTHERS => '0');
        ELSIF inc_s_count = '1' THEN
             s_count_next <= s_count_reg + 1;
        END IF;
        -- sended bits counter
        IF clear_n_count = '1' then
            n_count_next <= (OTHERS => '0');
        ELSIF inc_n_count = '1' then
            n_count_next <= n_count_reg + 1;
        END IF;
        
        -- bit sending method
        IF send_0 = '1' THEN
            tx_out_next <= '0';
        ELSIF send_1 = '1' THEN
            tx_out_next <= '1';
        ELSIF send_bit = '1' THEN
            tx_out_next <= tx_in_reg(0);
            tx_in_next <= '0' & tx_in_reg (7 DOWNTO 1);
        ELSIF send_par_bit = '1' THEN
            tx_out_next <= parity_bit_reg;
        END IF;  
        
    end process;
     -- ======================
     -- output                
     -- ======================
    tx_out <= tx_out_reg;

end Behavioral;
