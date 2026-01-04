library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity fib_circuit_optimized is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_d1_in, BCD_d0_in : in STD_LOGIC_VECTOR(3 DOWNTO 0); -- 31 max
           start : in STD_LOGIC;
           BCD_d3_out, BCD_d2_out, BCD_d1_out, BCD_d0_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           ready : out STD_LOGIC;
           overflow : out STD_LOGIC;
           done : out STD_LOGIC);
end fib_circuit_optimized;

architecture Behavioral of fib_circuit_optimized is

-- FSM
type FSM_state is (idle, BCD_bin_first, BCD_bin_op, fibo, bin_BCD_op, done_step);
SIGNAL state_reg, state_next : FSM_state;
-- counter
SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO 32;
-- converter registers

-- registers
SIGNAL BCD_d3_reg, BCD_d2_reg, BCD_d1_reg, BCD_d0_reg : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL BCD_d3_next, BCD_d2_next, BCD_d1_next, BCD_d0_next : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL bin_reg, bin_next : STD_LOGIC_VECTOR(13 DOWNTO 0);
SIGNAL t0_reg, t0_next, t1_reg, t1_next : INTEGER RANGE 0 TO 2**20;
SIGNAL overflow_reg, overflow_next : STD_LOGIC;



begin
    -- =====================
    -- registers
    -- =====================
    process (clk, rst)
    begin
        IF rst = '0' then
            BCD_d3_reg <= (OTHERS => '0');
            BCD_d2_reg <= (OTHERS => '0');
            BCD_d1_reg <= (OTHERS => '0');
            BCD_d0_reg <= (OTHERS => '0');
            bin_reg <= (OTHERS => '0');
            t1_reg <= 0;
            t0_reg <= 0;
            state_reg <= idle;
            counter_reg <= 0;
            overflow_reg <= '0';
        ELSIF rising_edge(clk) THEN
            BCD_d3_reg <= BCD_d3_next;
            BCD_d2_reg <= BCD_d2_next;
            BCD_d1_reg <= BCD_d1_next;
            BCD_d0_reg <= BCD_d0_next;
            t1_reg <= t1_next;
            t0_reg <= t0_next;
            bin_reg <= bin_next;
            state_reg <= state_next;
            counter_reg <= counter_next;
            overflow_reg <= overflow_next;
        END IF;
    end process;
     
    process (state_reg, counter_reg, BCD_d1_in, BCD_d0_in, start, BCD_d3_reg, BCD_d2_reg, BCD_d1_reg, BCD_d0_reg, bin_reg, t1_reg, t0_reg, overflow_reg)
    variable count_ena : STD_LOGIC;
    variable BCD_to_bin_load_input, bin_to_BCD_load_input : STD_LOGIC;
    variable shift_R : STD_LOGIC;
    variable shift_L : STD_LOGIC;
    variable load_BCD_to_bin_counter, load_bin_to_BCD_counter : STD_LOGIC;
    variable load_fib : STD_LOGIC;
    variable fib_int_to_bin : STD_LOGIC_VECTOR(13 DOWNTO 0);
    variable correct_BCD_1_m, correct_BCD_0_m : STD_LOGIC;
    variable correct_BCD_3_p,correct_BCD_2_p, correct_BCD_1_p, correct_BCD_0_p : STD_LOGIC;
    variable BCD_d3_var, BCD_d2_var, BCD_d1_var, BCD_d0_var : STD_LOGIC_VECTOR(3 DOWNTO 0);
    begin
    -- =====================
    -- default values       
    -- =====================
        done <= '0';
        ready <= '0';

        t1_next <= t1_reg;            
        t0_next <= t0_reg;            
        bin_next <= bin_reg;          
        state_next <= state_reg;      
        counter_next <= counter_reg;  
        overflow_next <= overflow_reg;

        count_ena := '0';
        BCD_to_bin_load_input := '0';
        bin_to_BCD_load_input := '0';
        shift_R := '0';
        shift_L := '0';
        load_BCD_to_bin_counter := '0';
        load_bin_to_BCD_counter := '0';
        load_fib := '0';
        fib_int_to_bin := (OTHERS => '0');
        correct_BCD_1_m := '0';
        correct_BCD_0_m := '0';
        correct_BCD_3_p := '0';
        correct_BCD_2_p := '0';
        correct_BCD_1_p := '0';
        correct_BCD_0_p := '0';
        BCD_d3_var := BCD_d3_reg;
        BCD_d2_var := BCD_d2_reg;
        BCD_d1_var := BCD_d1_reg;
        BCD_d0_var := BCD_d0_reg;
        
        
        
        
    -- =====================
    -- next_state
    -- =====================
        CASE state_reg IS
            when idle =>
                ready <= '1';
                IF start = '1' THEN
                    state_next <= BCD_bin_first;
                    BCD_to_bin_load_input := '1';
                    overflow_next <= '0'; -- clear overflow output
                END IF;
                
            when BCD_bin_first =>
                load_BCD_to_bin_counter := '1';
                shift_R := '1';
                state_next <= BCD_bin_op;
                
            when BCD_bin_op =>
                IF counter_reg = 0 THEN
                    state_next <= fibo;
                    t1_next <= 1;
                    t0_next <= 0;
                    load_fib := '1';
                ELSE    
                    shift_R := '1';
                    count_ena := '1';  
                    IF to_integer(unsigned(BCD_d1_reg)) > 7 THEN
                        correct_BCD_1_m := '1';
                    END IF;
                    IF to_integer(unsigned(BCD_d0_reg)) > 7 THEN
                        correct_BCD_0_m := '1';
                    END IF;                    
                END IF;   
                
            when fibo =>
                IF counter_reg = 0 then
                    t1_next <= 0;
                    state_next <= bin_BCD_op;
                else
                    IF counter_reg = 1 THEN
                        state_next <= bin_BCD_op;
                        load_bin_to_BCD_counter := '1';
                        bin_to_BCD_load_input := '1';
                        IF t1_reg > 9999 then
                            overflow_next <= '1';
                        END IF;
                    else
                        t1_next <= t1_reg + t0_reg;
                        t0_next <= t1_reg;
                        count_ena := '1';
                    END if;
                END IF;
                
            when bin_BCD_op =>
                count_ena := '1';
                shift_L := '1';
                IF to_integer(unsigned(BCD_d3_reg)) > 4 THEN
                    correct_BCD_3_p := '1';
                END IF;
                IF to_integer(unsigned(BCD_d2_reg)) > 4 THEN
                    correct_BCD_2_p := '1';
                END IF;
                IF to_integer(unsigned(BCD_d1_reg)) > 4 THEN
                    correct_BCD_1_p := '1';
                END IF;
                IF to_integer(unsigned(BCD_d0_reg)) > 4 THEN
                    correct_BCD_0_p := '1';
                END IF;
                IF counter_reg = 0 THEN
                    state_next <= done_step;
                END IF;
            when done_step =>
                done <= '1';
                state_next <= idle;
        END CASE;
    -- =====================
    -- counter
    -- =====================
        IF load_BCD_to_bin_counter = '1' THEN
            counter_next <= 6 ;
        ELSIF load_bin_to_BCD_counter = '1' THEN
            counter_next <= 13 ;
        ELSIF load_fib = '1' THEN
            counter_next <= to_integer(unsigned(bin_reg(13 DOWNTO 7))) ;
        ELSIF count_ena = '1' THEN
            counter_next <= counter_reg - 1;
        END IF;
        
    -- =====================
    -- data path
    -- =====================
    
        IF BCD_to_bin_load_input = '1' THEN
            BCD_d1_var := BCD_d1_in;
            BCD_d0_var := BCD_d0_in;
            bin_next <= (OTHERS => '0');
        ELSIF bin_to_BCD_load_input = '1' THEN
            fib_int_to_bin := std_logic_vector(to_unsigned(t1_reg, 14));
            bin_next <= fib_int_to_bin;
            BCD_d3_var := (OTHERS => '0');
            BCD_d2_var := (OTHERS => '0');
            BCD_d1_var := (OTHERS => '0');
            BCD_d0_var := (OTHERS => '0');
        END IF;
        
        IF shift_R = '1' then
            IF correct_BCD_1_m = '1' THEN
                BCD_d1_var := std_logic_vector(unsigned(BCD_d1_var) - 3);
            END IF;
            IF correct_BCD_0_m = '1' THEN
                BCD_d0_var := std_logic_vector(unsigned(BCD_d0_var) - 3);
            END IF;
            bin_next <= BCD_d0_var(0) & bin_reg(13 DOWNTO 1);
            BCD_d0_var := BCD_d1_var(0) & BCD_d0_var(3 DOWNTO 1);
            BCD_d1_var := '0' & BCD_d1_var(3 DOWNTO 1);  
        ELSIF shift_L = '1' then
            IF correct_BCD_3_p = '1' THEN
                BCD_d3_var := std_logic_vector(unsigned(BCD_d3_var) + 3);
            END IF;
            IF correct_BCD_2_p = '1' THEN
                BCD_d2_var := std_logic_vector(unsigned(BCD_d2_var) + 3);
            END IF;
            IF correct_BCD_1_p = '1' THEN
                BCD_d1_var := std_logic_vector(unsigned(BCD_d1_var) + 3);
            END IF;
            IF correct_BCD_0_p = '1' THEN
                BCD_d0_var := std_logic_vector(unsigned(BCD_d0_var) + 3);
            END IF;
            BCD_d3_var := BCD_d3_var(2 DOWNTO 0) & BCD_d2_var(3);
            BCD_d2_var := BCD_d2_var(2 DOWNTO 0) & BCD_d1_var(3);
            BCD_d1_var := BCD_d1_var(2 DOWNTO 0) & BCD_d0_var(3);
            BCD_d0_var := BCD_d0_var(2 DOWNTO 0) & bin_reg(13);
            bin_next <= bin_reg(12 DOWNTO 0) & '0';
        END IF;
    
        BCD_d3_next <= BCD_d3_var;
        BCD_d2_next <= BCD_d2_var;
        BCD_d1_next <= BCD_d1_var;
        BCD_d0_next <= BCD_d0_var;
            
        -- =====================
        -- output
        -- =====================
        overflow <= overflow_reg;
        IF overflow_reg = '1' THEN -- 9999 overflow case
            BCD_d3_out <= "1001";  
            BCD_d2_out <= "1001";  
            BCD_d1_out <= "1001";  
            BCD_d0_out <= "1001";  
        ELSE
            BCD_d3_out <= BCD_d3_reg;   
            BCD_d2_out <= BCD_d2_reg;   
            BCD_d1_out <= BCD_d1_reg;   
            BCD_d0_out <= BCD_d0_reg;   
        END IF;
    end process;
end Behavioral;

