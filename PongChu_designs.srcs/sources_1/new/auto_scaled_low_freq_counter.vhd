library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity auto_scaled_low_freq_counter is
    Generic ( W_div : INTEGER := 30;
              N_bits_div : INTEGER := 5);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           signal_in : in STD_LOGIC;
           BCD_out : out STD_LOGIC_VECTOR(15 DOWNTO 0); -- 4 digits
           decimal_point_position : out STD_LOGIC_VECTOR(3 DOWNTO 0); -- one_hot
           -- 1000 = point for digit 3, 0100 for digit 2... etc...
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC);
end auto_scaled_low_freq_counter;

architecture Behavioral of auto_scaled_low_freq_counter is

-- ========================
-- COMPONENTS DECLARATION
-- ========================

COMPONENT period_counter_micro is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           signal_in : in STD_LOGIC;
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC;
           prd : out STD_LOGIC_VECTOR(19 DOWNTO 0)); -- 20 bits to count up to 1 million µs = 1s
end COMPONENT;

COMPONENT division_circuit is
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
end COMPONENT;

COMPONENT bin_24b_to_BCD_7d_FSMD is 
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bin_in_24b : in STD_LOGIC_VECTOR(23 DOWNTO 0);
           start : in STD_LOGIC;
           BCD_out_7d : out STD_LOGIC_VECTOR(27 DOWNTO 0);
           ready : out STD_LOGIC;
           done : out STD_LOGIC);
end COMPONENT;

COMPONENT BCD_ajustment is  
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_in : in STD_LOGIC_VECTOR(27 DOWNTO 0); -- 4 digits for units, 3 digits for decimals
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           done : out STD_LOGIC;
           decimal_pos_out : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           BCD_out : out STD_LOGIC_VECTOR(15 DOWNTO 0));
end COMPONENT;

-- ========================
-- SIGNALS
-- ========================

-- FSM
type FSM_state IS (idle, period, div, conv, adjustment);

-- registers
SIGNAL state_reg, state_next : FSM_state;

-- wires for period counter
SIGNAL start_period :  STD_LOGIC;
SIGNAL done_tick_period :  STD_LOGIC;
SIGNAL prd_period :  STD_LOGIC_VECTOR(19 DOWNTO 0);

-- wires for division circuit
SIGNAL start_div :  STD_LOGIC;
SIGNAL prd_div :  STD_LOGIC_VECTOR(W_div-1 DOWNTO 0);
SIGNAL quotient_div : STD_LOGIC_VECTOR (W_div-1 DOWNTO 0);  
SIGNAL done_tick_div : STD_LOGIC;

-- wires for bin to BCD conversion
SIGNAL start_conv :  STD_LOGIC;
SIGNAL quotient_corrected : STD_LOGIC_VECTOR (23 DOWNTO 0); -- qquotient dive 24 LSBs, correction on 10 lsbs from 1024 base to 1000 base for mHz
SIGNAL BCD_out_7d_conv : STD_LOGIC_VECTOR (27 DOWNTO 0);
SIGNAL done_conv : STD_LOGIC;

-- wires for adjustment circuit
SIGNAL start_adj :  STD_LOGIC;
SIGNAL done_adj : STD_LOGIC;
SIGNAL decimal_pos_out_adj : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL BCD_out_adj : STD_LOGIC_VECTOR(15 DOWNTO 0);


begin
-- ========================
-- COMPONENTS INSTANCIATION
-- ========================
    counter_microseconds : period_counter_micro
    PORT MAP (  clk => clk,
                rst => rst,
                start => start_period,
                signal_in => signal_in,
                ready => open,
                done_tick => done_tick_period,
                prd => prd_period);
    
    division : division_circuit 
    PORT MAP (  clk => clk,
                rst => rst,
                start => start_div, 
                divisor => prd_div,
                quotient => quotient_div,
                remainder => open,
                done_tick => done_tick_div,
                ready => open);
    
    conversion : bin_24b_to_BCD_7d_FSMD 
    PORT MAP (  clk => clk,
                rst => rst,
                bin_in_24b => quotient_corrected,
                start => start_conv,
                BCD_out_7d => BCD_out_7d_conv,
                ready => open,
                done => done_conv);
    
    adjustment_circuit : BCD_ajustment
    PORT MAP (  clk => clk,
                rst => rst,
                BCD_in => BCD_out_7d_conv,
                start => start_adj,
                ready => open,
                done => done_adj,
                decimal_pos_out => decimal_pos_out_adj,
                BCD_out => BCD_out_adj);
            
-- ========================
-- REGISTERS
-- ========================
    process (clk, rst)
    begin
        IF rst = '0' then   
           state_reg <= idle;
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
        END IF;
    end process;
    
    process (state_reg, start, signal_in, done_tick_period, done_tick_div, done_conv, done_adj)
    variable quotient_corrected_frac : STD_LOGIC_VECTOR(19 DOWNTO 0);
    begin
-- ========================
-- DEFAULT VALUES
-- ========================
        state_next <= state_reg;
        ready <= '0';
        done_tick <= '0';
        
        start_period <= '0';
        start_div <= '0';
        start_conv <= '0';
        start_adj <= '0';
        
        quotient_corrected_frac := "0000000000" & quotient_div(9 DOWNTO 0);
        quotient_corrected_frac := std_logic_vector( shift_right(
        shift_left(unsigned(quotient_corrected_frac), 9)  
        + shift_left(unsigned(quotient_corrected_frac), 8)
        + shift_left(unsigned(quotient_corrected_frac), 7)
        + shift_left(unsigned(quotient_corrected_frac), 6)
        + shift_left(unsigned(quotient_corrected_frac), 5)
        + shift_left(unsigned(quotient_corrected_frac), 3), 10));
        
        
-- ========================
-- NEXT STATE
-- ========================
        CASE state_reg is
            WHEN idle =>
                ready <= '1';
                IF start = '1' then
                    state_next <= period;
                    start_period <= '1';
                END IF;
            WHEN period =>
                IF done_tick_period = '1' THEN
                    state_next <= div;
                    start_div <= '1';
                    prd_div <= prd_period & "0000000000";
                END IF;
            WHEN div  =>
                IF done_tick_div = '1' THEN
                    state_next <= conv;
                    start_conv <= '1';
                    quotient_corrected <= quotient_div(23 DOWNTO 10) & quotient_corrected_frac(9 DOWNTO 0);
                END IF;
            WHEN conv =>
                IF done_conv = '1' THEN
                    state_next <= adjustment;
                    start_adj <= '1';
                END IF;
            WHEN adjustment =>
                IF done_adj = '1' THEN
                    state_next <= idle;
                    done_tick <= '1';
                END IF;
            END CASE;
-- ========================
-- DATA CALCULATION AND OUTPUT
-- ========================

        -- outputs
        BCD_out <= BCD_out_adj;
        IF decimal_pos_out_adj = "00" THEN
            decimal_point_position <= "0001";
        ELSIF decimal_pos_out_adj = "01" then
            decimal_point_position <= "0010";
        ELSIF decimal_pos_out_adj = "10" then
            decimal_point_position <= "0100";
        ELSIF decimal_pos_out_adj = "11" then
            decimal_point_position <= "1000";
        ELSE
            decimal_point_position <= "0000";
        END IF;
    end process;
end Behavioral;
