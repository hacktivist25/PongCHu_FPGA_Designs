library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- BCD_to_binary -> fibonacci --> binary_to_BCD
-- huge problems in the design the book makes us implement : 
--   - if you enter for example 64 = 0b01000000
--   - only the 5 last bits 0b00000 are entered to fibonacci...
-- let's assume that you know input is limited from 0 to 31
-- you an fix it, but with a huge multiplier bloc (takes a lot of ressources)
entity fib_circuit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           BCD_in : in STD_LOGIC_VECTOR(7 DOWNTO 0); -- 2 BCD digits for fibonacci which goes up to 31 (5 bits input only)
           BCD_out : out STD_LOGIC_VECTOR(15 DOWNTO 0); --4 BCD output digits = fibonacci result
           done : out STD_LOGIC;
           ready : out std_logic;
           overflow_out : out std_logic);
end fib_circuit;

architecture Behavioral of fib_circuit is

-- =============================
-- COMPONENT DECLARATION
-- =============================
COMPONENT fibonacci is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           start : in STD_LOGIC;
           index : in STD_LOGIC_VECTOR(4 DOWNTO 0);
           ready : out STD_LOGIC;
           done_tick : out STD_LOGIC;
           result : out STD_LOGIC_VECTOR(19 DOWNTO 0);
           overflow : out STD_LOGIC);
end COMPONENT;

COMPONENT BCD_to_binary_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_2digits_input : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           start : in STD_LOGIC;
           binary_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           done : out STD_LOGIC;
           ready : out STD_LOGIC);
end COMPONENT;

-- adaptaded to convert binary to 4 digits (for fibonacci)
COMPONENT bin_14b_to_BCD_4d_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bin_in_14b : in STD_LOGIC_VECTOR(13 DOWNTO 0);
           start : in STD_LOGIC;
           BCD_out_4d : out STD_LOGIC_VECTOR(15 DOWNTO 0);
           ready : out STD_LOGIC;
           done : out STD_LOGIC); -- 4 digits
end COMPONENT;

-- =============================
-- FSM states
-- =============================
type FSM_state IS (idle, BCD_to_bin_step, fib_step, bin_to_BCD_step);
SIGNAL state_reg, state_next : FSM_state;
SIGNAL BCD_to_bin_start, fib_start, bin_to_BCD_start : STD_LOGIC;

-- =============================
-- SIGNAL DECLARATIONS
-- =============================
-- output
SIGNAL BCD_out_next, BCD_out_reg : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL overflow_reg, overflow_next : STD_LOGIC;

-- BCD_to_bin outputs
SIGNAL BCD_to_bin_out : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL BCD_to_bin_ready : STD_LOGIC;
SIGNAL BCD_to_bin_done : STD_LOGIC;

-- fibonacci outputs
SIGNAL fibonacci_out : STD_LOGIC_VECTOR(19 DOWNTO 0);
SIGNAL fibonacci_ready : STD_LOGIC;
SIGNAL fibonacci_done : STD_LOGIC;
SIGNAL fibonacci_overflow : STD_LOGIC;

-- bin_to_BCD outputds
SIGNAL bin_to_BCD_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL bin_to_BCD_ready : STD_LOGIC;
SIGNAL bin_to_BCD_done : STD_LOGIC;


begin
-- =============================
-- COMPONENT INSTANCIATION
-- =============================
BCD_2_bin_initial_conversion : BCD_to_binary_FSMD
PORT MAP (  clk => clk,
            rst => rst,
            BCD_2digits_input => BCD_in,
            start => BCD_to_bin_start,
            binary_out => BCD_to_bin_out,
            done => BCD_to_bin_done,
            ready => BCD_to_bin_ready);
            
fibonacci_step : fibonacci
PORT MAP (  clk => clk,
            rst => rst,
            start => fib_start,
            index => BCD_to_bin_out(4 DOWNTO 0),
            ready => fibonacci_ready,
            done_tick => fibonacci_done,
            result => fibonacci_out,
            overflow => fibonacci_overflow);
            
bin_2_BCD_final_conversion : bin_14b_to_BCD_4d_FSMD
PORT MAP (  clk => clk,
            rst => rst,
            bin_in_14b => fibonacci_out(13 DOWNTO 0),
            start => bin_to_BCD_start,
            BCD_out_4d  => bin_to_BCD_out,
            ready => bin_to_BCD_ready,
            done => bin_to_BCD_done);

-- =============================
-- REGISTERS
-- =============================
    process(clk, rst)
        begin
        IF rst = '0' THEN 
            state_reg <= idle;
            BCD_out_reg <= (OTHERS => '0');
            overflow_reg <= '0';
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
            BCD_out_reg <= BCD_out_next;
            overflow_reg <= overflow_next;
        END IF;       
    END PROCESS;

    process(BCD_in, state_reg, overflow_reg, start, BCD_to_bin_done, fibonacci_done, bin_to_BCD_done)
    begin
    -- =============================
    -- default
    -- =============================
    state_next <= state_reg;
    BCD_out_next <= BCD_out_reg;
    overflow_next <= overflow_reg;
    ready <= '0';
    done <= '0';
    overflow_out <= '0';
    
    BCD_to_bin_start <= '0';
    fib_start <= '0';
    bin_to_BCD_start <= '0';

    
    
    -- =============================
    -- next-state
    -- =============================
    CASE state_reg IS
        when idle =>
            ready <= '1'; -- ready FSM
            IF start = '1' THEN
                state_next <= BCD_to_bin_step;
                bcd_to_bin_start <= '1';
            END IF;
        when BCD_to_bin_step =>
            IF BCD_to_bin_done = '1' THEN
                state_next <= fib_step;
                fib_start <= '1';
            END IF;
        when fib_step =>
            IF fibonacci_done = '1' THEN
                state_next <= bin_to_BCD_step;
                overflow_next <= fibonacci_overflow; -- save overflow bit
                bin_to_BCD_start <= '1';
            END IF;
        when bin_to_BCD_step =>
            IF bin_to_BCD_done = '1' THEN
                state_next <= idle;
                BCD_out_next <= bin_to_BCD_out;
                done <= bin_to_BCD_done; -- done FSM
            END IF;
    END CASE;

    -- =============================
    -- output
    -- =============================
    overflow_out <= overflow_reg;
    IF overflow_reg = '1' THEN
        BCD_out <= "1001100110011001"; --overflow
    ELSE -- overflow = els
        BCD_out <= BCD_out_reg;
    END IF;
    end process;
end Behavioral;
