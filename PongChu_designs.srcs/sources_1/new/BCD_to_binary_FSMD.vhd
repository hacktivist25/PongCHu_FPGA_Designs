library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity BCD_to_binary_FSMD is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_2digits_input : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           start : in STD_LOGIC;
           binary_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           done : out STD_LOGIC;
           ready : out STD_LOGIC);
end BCD_to_binary_FSMD;

architecture Behavioral of BCD_to_binary_FSMD is

type FSM_state is (idle, step_one, op);
SIGNAL state_reg, state_next : FSM_state;

SIGNAL BCD_digit_1_reg, BCD_digit_0_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL BCD_digit_1_next, BCD_digit_0_next : STD_LOGIC_VECTOR(3 DOWNTO 0);

SIGNAL binary_out_reg, binary_out_next : STD_LOGIC_VECTOR(6 DOWNTO 0);

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
            binary_out_reg <= (OTHERS => '0');
            state_reg <= idle;
            counter_reg <= 0;
        ELSIF rising_edge(clk) THEN
            BCD_digit_1_reg <= BCD_digit_1_next;
            BCD_digit_0_reg <= BCD_digit_0_next;
            binary_out_reg <= binary_out_next;
            state_reg <= state_next;
            counter_reg <= counter_next;
        END IF;
    end process;
     
    process (state_reg, counter_reg, BCD_digit_1_reg, BCD_digit_0_reg, BCD_2digits_input, start, binary_out_reg)
    variable BCD_digit_1_var, BCD_digit_0_var : STD_LOGIC_VECTOR(3 DOWNTO 0);
    variable BCD_shift : STD_LOGIC;
    variable BCD_digit_1_decrement, BCD_digit_0_decrement : STD_LOGIC;
    variable BCD_load_input : STD_LOGIC;
    
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
        binary_out_next <= binary_out_reg;
        
        count_load := '0';
        count_ena := '0';
        BCD_shift := '0';
        BCD_digit_1_decrement := '0';
        BCD_digit_0_decrement := '0';
        BCD_load_input := '0';
        
    -- =====================
    -- next_state
    -- =====================
        CASE state_reg IS
            when idle =>
                ready <= '1';
                IF start = '1' THEN
                    state_next <= step_one;
                    BCD_load_input := '1';
                END IF;
            when step_one =>
                state_next <= op;
                count_load := '1';
                BCD_shift := '1';
            when op =>
                IF counter_reg = 0 THEN
                    state_next <= idle;
                    done <= '1';
                ELSE    
                    BCD_shift := '1';
                    count_ena := '1';  
                    IF to_integer(unsigned(BCD_digit_1_reg)) > 7 THEN
                        BCD_digit_1_decrement := '1';
                    END IF;
                    IF to_integer(unsigned(BCD_digit_0_reg)) > 7 THEN
                        BCD_digit_0_decrement := '1';
                    END IF;                    
                END IF;    
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
    IF BCD_load_input = '1' THEN
        BCD_digit_1_var := BCD_2digits_input(7 DOWNTO 4);
        BCD_digit_0_var := BCD_2digits_input(3 DOWNTO 0);
    END IF;
    
    IF BCD_shift = '1' then
        IF BCD_digit_1_decrement = '1' THEN
            BCD_digit_1_var := std_logic_vector(unsigned(BCD_digit_1_var) - 3);
        END IF;
        IF BCD_digit_0_decrement = '1' THEN
            BCD_digit_0_var := std_logic_vector(unsigned(BCD_digit_0_var) - 3);
        END IF;
        binary_out_next <= BCD_digit_0_var(0) & binary_out_reg(6 DOWNTO 1);
        BCD_digit_0_var := BCD_digit_1_var(0) & BCD_digit_0_var(3 DOWNTO 1);
        BCD_digit_1_var := '0' & BCD_digit_1_var(3 DOWNTO 1);  
    END IF;
    
    BCD_digit_1_next <= BCD_digit_1_var;
    BCD_digit_0_next <= BCD_digit_0_var;
        
    
    -- =====================
    -- output
    -- =====================
        binary_out <= binary_out_reg;
    end process;
end Behavioral;
