library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity BCD_ajustment is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           BCD_in : in STD_LOGIC_VECTOR(27 DOWNTO 0); -- 4 digits for units, 3 digits for decimals
           start : in STD_LOGIC;
           ready : out STD_LOGIC;
           done : out STD_LOGIC;
           decimal_pos_out : out STD_LOGIC_VECTOR(1 DOWNTO 0);
           BCD_out : out STD_LOGIC_VECTOR(15 DOWNTO 0));
end BCD_ajustment;

architecture Behavioral of BCD_ajustment is

type FSM_state IS (idle, op);
SIGNAL state_reg, state_next : FSM_state;
SIGNAL counter_reg, counter_next : STD_LOGIC_VECTOR(1 DOWNTO 0);
SIGNAL BCD_out_reg, BCD_out_next : STD_LOGIC_VECTOR(27 DOWNTO 0);

begin
    process(clk, rst)
    begin
        IF rst = '0' THEN 
            state_reg <= idle ;
            counter_reg <= "00";
            BCD_out_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
            counter_reg <= counter_next;
            BCD_out_reg <= BCD_out_next;
        END IF;
    end process;
    
    process(state_reg, counter_reg, BCD_out_reg, BCD_in, start)
    variable out_load : STD_LOGIC;
    variable decimal_point_counter_clr, decimal_point_counter_inc : STD_LOGIC;
    variable BCD_shift_L : STD_LOGIC;
    begin
        decimal_point_counter_clr := '0';
        decimal_point_counter_inc := '0';
        out_load := '0';
        BCD_shift_L := '0';
        state_next <= state_reg;
        counter_next <= counter_reg;
        BCD_out_next <= BCD_out_reg;
        ready <= '0';
        done <= '0';
        
        CASE state_reg is
            WHEN idle =>
                ready <= '1';
                IF start = '1' then
                    decimal_point_counter_clr := '1';
                    out_load := '1';
                    state_next <= op;
                END IF;
            WHEN op =>
                IF BCD_out_reg(27 DOWNTO 24) = "0000" THEN
                    decimal_point_counter_inc := '1';
                    BCD_shift_L := '1';
                ELSE
                    done <= '1';
                    state_next <= idle;
                END IF;
            END CASE;   
            
            IF out_load = '1' then
                BCD_out_next <= BCD_in;
            END IF;
            
            IF decimal_point_counter_clr = '1' THEN
                counter_next <= "00";
            ELSIF decimal_point_counter_inc = '1' THEN
                counter_next <= std_logic_vector(unsigned(counter_reg) + 1); 
            END IF;
            
            IF BCD_shift_L = '1' THEN
                BCD_out_next<= BCD_out_reg (23 DOWNTO 0) & "0000";
            END IF;
            
            BCD_out <= BCD_out_reg (27 DOWNTO 12);
            decimal_pos_out <= counter_reg;
            
    end process;
end Behavioral;
