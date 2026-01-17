library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity uart_tx is
    GENERIC (   d_bits : NATURAL := 8; -- number of data bits
                dvsr : NATURAL := 16); -- 16 for 1 stop bit, 24 for 1.5, 32 for 2 stop bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tx_start : in STD_LOGIC;
           tx_in : in STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           s_tick : in STD_LOGIC;
           tx_out : out STD_LOGIC;
           done : out STD_LOGIC);
end uart_tx;

architecture Behavioral of uart_tx is

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
SIGNAL in_reg, in_next : UNSIGNED( d_bits - 1 DOWNTO 0 ); -- counting number of bits received
SIGNAL out_reg, out_next : STD_LOGIC; -- output register

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
            in_reg <= (OTHERS => '0');
            out_reg <=  '1';
        ELSIF rising_edge(clk) then
            state_reg <= state_next;
            s_count_reg <= s_count_next;
            n_count_reg <= n_count_next;
            in_reg <= in_next;
            out_reg <=  out_next;
        END IF;
    end process;
    
    process (tx_start, tx_in, s_tick, state_reg, s_count_reg, n_count_reg, in_reg)
    variable clear_s_count : STD_LOGIC;
    variable inc_s_count : STD_LOGIC;
    variable clear_n_count : STD_LOGIC;
    variable inc_n_count : STD_LOGIC;
    variable send_1bit : STD_LOGIC;
    variable send_0 : STD_LOGIC;
    variable send_1 : STD_LOGIC;
    variable register_in : STD_LOGIC;
    begin
        -- ======================
        -- default
        -- ======================
        state_next <= state_reg;
        s_count_next <= s_count_reg;
        n_count_next <= n_count_reg;
        in_next <= in_reg;
        out_next <= out_reg;
        done <= '0';
        
        clear_s_count := '0';
        inc_s_count := '0';
        clear_n_count := '0';
        inc_n_count := '0';
        send_1bit := '0';
        send_0 := '0';
        send_1 := '0';
        register_in := '0';
        
        -- ======================
        -- next-state logic
        -- ======================
        CASE state_reg IS 
            WHEN idle =>
                send_1 := '1';
                IF tx_start = '1' THEN -- start  signal
                    state_next <= start_bit;
                    clear_s_count := '1';
                    register_in := '1';
                    send_0 := '1';
                END IF;
            WHEN start_bit =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 then
                        clear_s_count := '1';
                        clear_n_count := '1';
                        send_1bit := '1';
                        state_next <= data;
                    ELSE
                        inc_s_count := '1';
                    END IF;
                END IF;
            WHEN data =>
                IF s_tick = '1' then
                    IF s_count_reg = 15 THEN
                        clear_s_count := '1';
                        send_1bit := '1';
                        if n_count_reg = 7 then
                            state_next <= stop;
                            clear_s_count := '1';
                            send_0 := '1';
                        ELSE
                            inc_n_count := '1';
                        END IF;
                    ELSE
                        inc_s_count := '1';
                    END IF;
                END IF;
            WHEN stop =>
                IF s_tick = '1' then
                    IF s_count_reg = dvsr - 1 then
                        done <= '1';
                        send_1 := '1';
                        state_next <= idle;
                    else
                        inc_s_count := '1';
                    END IF;
                END IF;
            END CASE;
        -- ======================
        -- data
        -- ======================
        IF clear_s_count = '1' then
            s_count_next <= (OTHERS => '0');
        ELSIF inc_s_count = '1' then
            s_count_next <= s_count_reg + 1;
        END IF;
        
        IF clear_n_count = '1' then
            n_count_next <= (OTHERS => '0');
        ELSIF inc_n_count = '1' then
            n_count_next <= n_count_reg + 1;
        END IF;
        
     -- ======================
     -- output                
     -- ======================
    IF register_in = '1' then
        in_next <= unsigned(tx_in);
    END IF;
    
    IF send_0 = '1' THEN
        out_next <= '0';
    ELSIF send_1 = '1' THEN
        out_next <= '1';
    ELSIF send_1bit = '1' THEN
        out_next <= in_reg(0);
        in_next <= '0' & in_reg (d_bits - 1 DOWNTO 1);
    END IF;  
      
    tx_out <= out_reg;
        
    end process;     
end Behavioral;

