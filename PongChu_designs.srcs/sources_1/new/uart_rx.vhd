library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity uart_rx is
    GENERIC (   d_bits : NATURAL := 8; -- number of data bits
                dvsr : NATURAL := 16); -- 16 for 1 stop bit, 24 for 1.5, 32 for 2 stop bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           rx_word : out STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           done : out STD_LOGIC);
end uart_rx;

architecture Behavioral of uart_rx is

function clog2(n : natural) return natural is
  variable r : natural := 0;
  variable v : natural := n - 1;
begin
  while v > 0 loop
    v := v / 2;
    r := r + 1;
  end loop;
  return r;
end function;

constant DBIT_W : natural := clog2(d_bits);
constant DVSR_W : natural := clog2(dvsr);

type FSM_state IS (idle, start_bit, data, stop);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL s_count_reg, s_count_next : UNSIGNED( DVSR_W - 1 DOWNTO 0 ); -- counting s_ticks for oversampling
SIGNAL n_count_reg, n_count_next : UNSIGNED( DBIT_W - 1 DOWNTO 0 ); -- counting number of bits received
SIGNAL w_reg, w_next : STD_LOGIC_VECTOR( d_bits - 1 DOWNTO 0 ); -- output register

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
        ELSIF rising_edge(clk) then
            state_reg <= state_next;
            s_count_reg <= s_count_next;
            n_count_reg <= n_count_next;
            w_reg <= w_next;
        END IF;
    end process;
    
    process (rx_in, s_tick, state_reg, s_count_reg, n_count_reg, w_reg)
    variable clear_s_count : STD_LOGIC;
    variable clear_n_count : STD_LOGIC;
    begin
        -- ======================
        -- default
        -- ======================
        state_next <= state_reg;
        s_count_next <= s_count_reg;
        n_count_next <= n_count_reg;
        w_next <= w_reg;
        done <= '0';
        
        clear_s_count := '0';
        clear_n_count := '0';
        
        -- ======================
        -- next-state logic
        -- ======================
        CASE state_reg IS 
            WHEN idle =>
                IF rx_in = '0' THEN -- start bit
                state_next <= start_bit;
                clear_s_count := '1';
                END IF;
            WHEN start_bit =>
                IF s_tick = '1' then
                    IF s_count_reg = 7 then
                        clear_s_count := '1';
                        clear_n_count := '1';
                        state_next <= data;
                    ELSE
                        s_count_next <= s_count_reg +1;
                    END IF;
                END IF;
            WHEN data =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 THEN
                        clear_s_count := '1';
                        w_next <= rx_in & w_reg (d_bits - 1 DOWNTO 1);
                        if n_count_reg = 7 then
                            state_next <= stop;
                            clear_s_count := '1';
                        ELSE
                            n_count_next <= n_count_reg +1;
                        END IF;
                    ELSE
                        s_count_next <= s_count_reg +1;
                    END IF;
                END IF;
            WHEN stop =>
                IF s_tick = '1' then
                    IF s_count_reg = dvsr - 1 then
                        done <= '1';
                        state_next <= idle;
                    else
                        s_count_next <= s_count_reg + 1;
                    END IF;
                END IF;
            END CASE;
        -- ======================
        -- data
        -- ======================
        IF clear_s_count = '1' then
            s_count_next <= (OTHERS => '0');
        END IF;
        
        IF clear_n_count = '1' then
            n_count_next <= (OTHERS => '0');
        END IF;
        
    end process;
     -- ======================
     -- output                
     -- ======================
    rx_word <= w_reg;
     
end Behavioral;
