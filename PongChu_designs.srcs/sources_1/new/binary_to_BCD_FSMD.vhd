library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity binary_to_BCD_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bin_in : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           done : out STD_LOGIC;
           BCD_out : out STD_LOGIC_VECTOR(7 DOWNTO 0)); -- 2 BCD digits
end binary_to_BCD_FSMD;

architecture Behavioral of binary_to_BCD_FSMD is

type FSM_state is (idle, op, step_last);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL BCD_digit_1_reg, BCD_digit_0_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL BCD_digit_1_next, BCD_digit_0_next : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL bin_in_reg, bin_in_next : STD_LOGIC_VECTOR(6 DOWNTO 0);

CONSTANT count_max : INTEGER := 6; -- 6 steps to perform conversion (after 1st step
SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO 6;

begin
    -- =====================
    -- registers
    -- =====================
    process (clk, rst)
    begin
        IF rst = '0' then
            BCD_digit_1_reg <= "0000";
            BCD_digit_0_reg <= "0000";
            bin_in_reg <= (OTHERS => '0');
            state_reg <= idle;
            counter_reg <= 0;
        ELSIF rising_edge(clk) THEN
            BCD_digit_1_reg <= BCD_digit_1_next;
            BCD_digit_0_reg <= BCD_digit_0_next;
            bin_in_reg <= bin_in_next;
            state_reg <= state_next;
            counter_reg <= counter_next;
        END IF;
    end process;
     
    process (state_reg, counter_reg, BCD_digit_1_reg, BCD_digit_0_reg, start, bin_in_reg)
    variable BCD_digit_1_var, BCD_digit_0_var : STD_LOGIC_VECTOR(3 DOWNTO 0);
    variable BCD_shift : STD_LOGIC;
    variable BCD_digit_1_increment, BCD_digit_0_increment : STD_LOGIC;
    variable bin_load_input : STD_LOGIC;
    
    variable count_ena : STD_LOGIC;
    variable count_load : STD_LOGIC;
    
    begin
    -- =====================
    -- default values       
    -- =====================
        done <= '0';
        ready <= '0';
        state_next <= state_reg;
        counter_next <= counter_reg;
        BCD_digit_1_var := BCD_digit_1_reg;
        BCD_digit_0_var := BCD_digit_0_reg;
        bin_in_next <= bin_in_reg;
        
        count_load := '0';
        count_ena := '0';
        BCD_shift := '0';
        BCD_digit_1_increment := '0';
        BCD_digit_0_increment := '0';
        bin_load_input := '0';
        
    -- =====================
    -- next_state
    -- =====================
        CASE state_reg IS
            when idle =>
                ready <= '1';
                IF start = '1' THEN
                    state_next <= op;
                    bin_load_input := '1';
                    count_load := '1';
                END IF;
            when op =>
                count_ena := '1';
                BCD_shift := '1';
                IF to_integer(unsigned(BCD_digit_1_reg)) > 4 THEN
                    BCD_digit_1_increment := '1';
                END IF;
                IF to_integer(unsigned(BCD_digit_0_reg)) > 4 THEN
                    BCD_digit_0_increment := '1';
                END IF;    
                IF counter_reg = 0 THEN
                    state_next <= step_last;
                END IF;
            when step_last =>
                state_next <= idle;
                done <= '1';
        END CASE;
    -- =====================
    -- counter
    -- =====================
        IF count_load = '1' THEN
            counter_next <= count_max ;
        ELSIF count_ena = '1' THEN
            counter_next <= counter_reg - 1;
        END IF;
    -- =====================
    -- data path
    -- =====================
        IF bin_load_input = '1' THEN
            BCD_digit_1_var := (OTHERS => '0');
            BCD_digit_0_var := (OTHERS => '0');
            bin_in_next <= bin_in;
        END IF;
        
        IF BCD_shift = '1' then
            IF BCD_digit_1_increment = '1' THEN
                BCD_digit_1_var := std_logic_vector(unsigned(BCD_digit_1_var) + 3);
            END IF;
            IF BCD_digit_0_increment = '1' THEN
                BCD_digit_0_var := std_logic_vector(unsigned(BCD_digit_0_var) + 3);
            END IF;
            BCD_digit_1_var := BCD_digit_1_var(2 DOWNTO 0) & BCD_digit_0_var(3);
            BCD_digit_0_var := BCD_digit_0_var(2 DOWNTO 0) & bin_in_reg(6);
            bin_in_next <= bin_in_reg(5 DOWNTO 0) & '0';
        END IF;
        
        BCD_digit_1_next <= BCD_digit_1_var;
        BCD_digit_0_next <= BCD_digit_0_var;
        
    -- =====================
    -- output
    -- =====================
        BCD_out <= BCD_digit_1_reg & BCD_digit_0_reg;
    end process;
end Behavioral;
