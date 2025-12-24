library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity enhanced_stopwatch is
    GENERIC ( hundred_ms : INTEGER := 5_000_000); --condidering a 50MHz clock
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           up : in STD_LOGIC;
           go : in STD_LOGIC;
           clr : in STD_LOGIC;
           m, ds : out STD_LOGIC_VECTOR(3 DOWNTO 0); --m : minute, ds : 0.1seconds (0 to 9)
           ss : out STD_LOGIC_VECTOR(5 DOWNTO 0)); -- seconds (0 to 59)
end enhanced_stopwatch;
-- we just have then to add a number to seven segment converter to display the output on the LED_time_multiplexer bloc.

architecture Behavioral of enhanced_stopwatch is

SIGNAL count_hundred_ms_reg, count_hundred_ms_next : STD_LOGIC_VECTOR(22 DOWNTO 0); -- 23 bits to count to 5_000_000
SIGNAL ds_counter_reg, ds_counter_next, m_counter_reg, m_counter_next : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL ss_counter_reg, ss_counter_next : STD_LOGIC_VECTOR(5 DOWNTO 0);

begin
    process (clk, rst)
    begin
        IF rst = '0' THEN -- reset
            count_hundred_ms_reg <= (OTHERS => '0');
            m_counter_reg <= (OTHERS => '0');
            ss_counter_reg <= (OTHERS => '0');
            ds_counter_reg <= (OTHERS => '0');
        ELSIF clk'event AND clk = '1' then
            count_hundred_ms_reg <= count_hundred_ms_next;
            m_counter_reg <= m_counter_next;
            ss_counter_reg <= ss_counter_next;
            ds_counter_reg <= ds_counter_next;
        END IF;
    end process;
    
    process(go, clr, up, m_counter_reg, ss_counter_reg, ds_counter_reg, count_hundred_ms_reg)
    variable hundred_ms_tick, s_tick, m_tick : STD_LOGIC;
    begin
        IF clr = '1' then
            m_counter_next <= (OTHERS => '0');
            ss_counter_next <= (OTHERS => '0');
            ds_counter_next <= (OTHERS => '0');
            hundred_ms_tick := '0';
            s_tick := '0';
            m_tick := '0';
        ELSE -- clr = 0
            
            -- hold value
            m_counter_next <= m_counter_reg;
            ss_counter_next <= ss_counter_reg;
            ds_counter_next <= ds_counter_reg;
            
            IF go = '1' THEN
            -- 100 ms counting
                IF to_integer(unsigned(count_hundred_ms_reg)) = hundred_ms - 1 then
                    count_hundred_ms_next <= (OTHERS => '0');
                    hundred_ms_tick := '1';
                ELSE
                    count_hundred_ms_next <= std_logic_vector(unsigned(count_hundred_ms_reg) + 1);
                    hundred_ms_tick := '0';
                END IF;
            
            
                                -- next state
                -- 100 ms
                IF hundred_ms_tick = '1' THEN
                    IF up = '1' THEN
                        IF ds_counter_reg = "1001" THEN -- 9
                            ds_counter_next <= "0000"; -- 0
                            s_tick := '1';
                        ELSE
                            ds_counter_next <= std_logic_vector(unsigned(ds_counter_reg) + 1);
                            s_tick := '0';
                        END IF;
                    ELSE -- up = 0 
                        IF ds_counter_reg = "0000" THEN -- 0
                            ds_counter_next <= "1001";-- 9
                            s_tick := '1';
                        ELSE
                            ds_counter_next <= std_logic_vector(unsigned(ds_counter_reg) - 1);
                            s_tick := '0';
                        END IF;
                    END IF;   
                END IF;
                
                 -- s
                IF s_tick = '1' THEN
                    s_tick := '0';
                    IF up = '1' THEN
                        IF ss_counter_reg = "111011" THEN -- 59
                            ss_counter_next <= "000000"; -- 0
                            m_tick := '1';
                        ELSE
                            ss_counter_next <= std_logic_vector(unsigned(ss_counter_reg) + 1);
                            m_tick := '0';
                        END IF;
                    ELSE -- up = 0 
                        IF ss_counter_reg = "000000" THEN -- 0
                            ss_counter_next <= "111011"; -- 59
                            m_tick := '1';
                        ELSE
                            ss_counter_next <= std_logic_vector(unsigned(ss_counter_reg) - 1);
                            m_tick := '0';
                        END IF;
                    END IF;   
                END IF;
                
                -- m
                IF m_tick = '1' THEN
                    m_tick := '0';
                    IF up = '1' THEN
                        IF m_counter_reg = "1001" THEN -- 9
                            m_counter_next <= "0000"; -- 0
                        ELSE
                            m_counter_next <= std_logic_vector(unsigned(m_counter_reg) + 1);
                        END IF;
                    ELSE -- up = 0 
                        IF m_counter_reg = "0000" THEN -- 0
                            m_counter_next <= "1001";-- 9
                        ELSE
                            m_counter_next <= std_logic_vector(unsigned(m_counter_reg) - 1);
                        END IF;
                    END IF;   
                END IF;
            END IF;
        END IF;
        
        -- affecting outputs
        m <= m_counter_reg;
        ss <= ss_counter_reg;
        ds <= ds_counter_reg;
        
    end process;

end Behavioral;
