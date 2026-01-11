library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity reaction_timer is
    Generic ( ms_max : STD_LOGIC_VECTOR(15 DOWNTO 0) := "1100001101001111"); -- 49999);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           clr : in STD_LOGIC;
           start : in STD_LOGIC;
           stop : in STD_LOGIC;
           sseg_out_3, sseg_out_2, sseg_out_1, sseg_out_0 : out STD_LOGIC_VECTOR(6 DOWNTO 0); -- 4 7 segment led diplays
           LED : out STD_LOGIC;
           done : out STD_LOGIC;
           ready : out STD_LOGIC);
end reaction_timer;

architecture Behavioral of reaction_timer is

-- =============================
-- COMPONENT
-- =============================

COMPONENT bin_14b_to_BCD_4d_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bin_in_14b : in STD_LOGIC_VECTOR(13 DOWNTO 0);
           start : in STD_LOGIC;
           BCD_out_4d : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           ready : out STD_LOGIC;
           done : out STD_LOGIC); -- 4 digits
end COMPONENT;

COMPONENT hex_to_sseg is
    Port ( hex : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           sseg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
end COMPONENT;

-- =============================
-- SIGNALS
-- =============================
-- for components
SIGNAL start_tick_conv : STD_LOGIC;
SIGNAL bin_in_14b_conv : STD_LOGIC_VECTOR(13 DOWNTO 0);
SIGNAL BCD_out_4d_conv : STD_LOGIC_VECTOR(15 DOWNTO 0);

SIGNAL sseg_out_d3 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL sseg_out_d2 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL sseg_out_d1 : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL sseg_out_d0 : STD_LOGIC_VECTOR(6 DOWNTO 0);

type FSM_state IS (idle, random_delay, reaction_phase, result);
SIGNAL state_reg, state_next : FSM_state;
SIGNAL result_reg, result_next : STD_LOGIC_VECTOR (9 DOWNTO 0);

SIGNAL LFSR_reg, LFSR_next : STD_LOGIC_VECTOR (13 DOWNTO 0);
SIGNAL LFSR_save_reg, LFSR_save_next : STD_LOGIC_VECTOR (13 DOWNTO 0);

SIGNAL counter_reg, counter_next : STD_LOGIC_VECTOR (15 DOWNTO 0); -- to count up to ms_max
SIGNAL counter_ms_reg, counter_ms_next : STD_LOGIC_VECTOR (13 DOWNTO 0);

begin
-- =============================
-- COMPONENT INSTANCIATION
-- =============================
converter : bin_14b_to_BCD_4d_FSMD 
PORT MAP (  clk  => clk,
            rst => rst,
            bin_in_14b => bin_in_14b_conv,
            start => start_tick_conv,
            BCD_out_4d => BCD_out_4d_conv,
            ready => open,
            done => open);
            
sseg_d3 : hex_to_sseg
PORT MAP (  hex => BCD_out_4d_conv(15 DOWNTO 12),
            sseg => sseg_out_d3);
sseg_d2 : hex_to_sseg
PORT MAP (  hex => BCD_out_4d_conv(11 DOWNTO 8),
            sseg => sseg_out_d2);
sseg_d1 : hex_to_sseg
PORT MAP (  hex => BCD_out_4d_conv(7 DOWNTO 4),
            sseg => sseg_out_d1);
sseg_d0 : hex_to_sseg
PORT MAP (  hex => BCD_out_4d_conv(3 DOWNTO 0),
            sseg => sseg_out_d0);       
                 
-- =============================
-- registers
-- =============================
    process(clk, rst)
    begin   
        IF rst = '0' then
            state_reg <= idle;
            LFSR_reg <= "10101100001011"; -- initial value = primary polynom
            counter_reg <= (OTHERS => '0');
            counter_ms_reg <= (OTHERS => '0');
            LFSR_save_reg <= (OTHERS => '0');
        elsif rising_edge(clk) THEN
            state_reg <= state_next;
            LFSR_reg <= LFSR_next;
            counter_reg <= counter_next;
            counter_ms_reg <= counter_ms_next;
            LFSR_save_reg <= LFSR_save_next;
        END IF ;
    end process;
    

    process(clr, start, stop, state_reg, counter_reg, LFSR_reg, counter_reg, counter_ms_reg)
    variable LFRS_feedback : STD_LOGIC; 
    variable counter_ena : STD_LOGIC; 
    variable counter_clear : STD_LOGIC;     
    variable ms_tick : STD_LOGIC; 
    variable LFSR_save : STD_LOGIC; 
    variable result_display : STD_LOGIC; 
    variable welcome_display : STD_LOGIC; 
    variable void_display : STD_LOGIC; 
    variable start_tick_conv_var : STD_LOGIC; 
    variable reaction_timing : STD_LOGIC; 
    variable over_second : STD_LOGIC; 
    
    begin
    -- =============================
    -- default
    -- =============================
    counter_ena := '0';
    counter_clear := '0';
    ms_tick := '0';
    LFSR_save := '0';
    result_display := '0';
    welcome_display := '0';
    void_display := '0';
    start_tick_conv_var := '0';
    reaction_timing := '0';
    over_second := '0';
    LED <= '0';
    done <= '0';
    ready <= '0';
    
    LFSR_save_next <= LFSR_save_reg;
    state_next <= state_reg;
    counter_next <= counter_reg;
    counter_ms_next <= counter_ms_reg;
    start_tick_conv <= '0';
    
    -- =============================
    -- next_state
    -- =============================
        CASE state_reg is
            WHEN idle => 
                welcome_display := '1';
                ready <= '1';
                IF start = '1' then
                    state_next <= random_delay;
                    LFSR_save := '1';
                    counter_clear := '1';
                END IF; 
            WHEN random_delay => 
                void_display := '1';
                counter_ena := '1';
                IF counter_ms_reg(13 DOWNTO 0) = LFSR_save_reg THEN
                    state_next <= reaction_phase;
                    counter_clear := '1';
                END IF;
            WHEN reaction_phase => 
                reaction_timing := '1';
                LED <= '1';
                result_display := '1';
                counter_ena := '1';
                IF stop ='1' THEN
                done <= '1';
                    start_tick_conv_var := '1';
                    state_next <= result;
                END IF;
            WHEN result => 
                reaction_timing := '1';
                result_display := '1';
                IF clr = '1' then
                    state_next <= idle;
                END IF;
        END CASE;
        
    -- =============================
    -- if more than 1 second of reaction
    -- =============================    
        IF reaction_timing = '1' THEN
            IF unsigned(counter_ms_reg) > "00001111101000" then
                over_second := '1';
            END IF;
        END IF;
    
    -- =============================
    -- Linear-feedback shift register
    -- =============================
        LFRS_feedback := LFSR_reg(13) XOR LFSR_reg(12) XOR LFSR_reg(11) XOR LFSR_reg(1);
        LFSR_next <= LFSR_reg (12 DOWNTO 0) & LFRS_feedback;
        
    -- =============================
    -- Linear-feedback shift register SAVE VALUE
    -- =============================
        IF LFSR_save = '1' THEN
            LFSR_save_next <= LFSR_reg;
        END IF;
    
    -- =============================
    -- ms_counter
    -- =============================
        IF counter_clear = '1' then
            counter_next <= (OTHERS => '0');
        ELSIF counter_ena = '1' THEN
            IF counter_reg = ms_max then
                counter_next <= (OTHERS => '0');
                ms_tick := '1';
            ELSE
                counter_next <= std_logic_vector(unsigned(counter_reg) + 1);
            END IF;
        END IF;

    -- =============================
    -- counter for random delay and for reaction
    -- =============================
        IF counter_clear = '1' THEN
            counter_ms_next <= (OTHERS => '0');
        ELSIF counter_ena = '1' THEN
            IF ms_tick = '1' AND over_second = '0' THEN 
                counter_ms_next <= std_logic_vector(unsigned(counter_ms_reg) + 1);
            END IF;
        END IF;    
    
    
    -- =============================
    -- start bcd_convrter to display new ms
    -- =============================
        bin_in_14b_conv <= counter_ms_reg;
        IF start_tick_conv_var = '1' OR ms_tick = '1' then
            start_tick_conv <= '1';
        END IF;
        
    -- =============================
    -- output display
    -- =============================
        IF welcome_display = '1' THEN -- display HI
            sseg_out_3 <= "0000000";
            sseg_out_2 <= "0000000";
            sseg_out_1 <= "0110111";
            sseg_out_0 <= "0110000";
        ELSIF void_display = '1' THEN -- display nothing
            sseg_out_3 <= "0000000";
            sseg_out_2 <= "0000000";
            sseg_out_1 <= "0000000";
            sseg_out_0 <= "0000000";
        ELSIF over_second = '1' THEN -- 9.9999 = too much time to react (over 1 second)
            sseg_out_3 <= "1111101";
            sseg_out_2 <= "1111101";
            sseg_out_1 <= "1111101";
            sseg_out_0 <= "1111101";
        ELSIF result_display = '1' THEN -- display ms out of converter
            sseg_out_3 <= sseg_out_d3;
            sseg_out_2 <= sseg_out_d2;
            sseg_out_1 <= sseg_out_d1;
            sseg_out_0 <= sseg_out_d0;
        END IF;
    
    end process;
end Behavioral;
