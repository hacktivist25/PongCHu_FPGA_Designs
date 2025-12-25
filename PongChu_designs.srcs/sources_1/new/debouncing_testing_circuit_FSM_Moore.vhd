library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity debouncing_testing_circuit_FSM_Moore is
generic ( -- debouncing circuit constants
          LIMIT_deboucing : INTEGER := 500_000;
          N_deboucing : INTEGER := 19;
          -- Seven segment display constants
          Hz_800_LEDtm : INTEGER := 62500;
          N_bits_LEDtm : INTEGER := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end debouncing_testing_circuit_FSM_Moore;
-- weird code just to test : counter and hex to sseg convertion are done here
-- this is a bad practice, the code concerning the counter and the digit to
-- sseg conversion should be two blocs, and this code should be reduced to
-- a simple instanciating and wire plugging work

architecture Behavioral of debouncing_testing_circuit_FSM_Moore is

-- ==================
-- COMPONENTS DECLARATION
-- ==================

-- debouncing circuit
COMPONENT debouncing_FSM_Moore is
generic (   LIMIT : INTEGER := 500_000; -- 10ms/20ns = 500k, log2(500k) = 19 => N=19
            N : INTEGER := 19); -- 10ms/20ns = 500k, log2(500k) = generic
            -- N is useless here, because I wanted to do an STD_LOGIC_VECTOR(N-1 DOWNTO 0) for the free-running counter...
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           debounced_signal : out STD_LOGIC);
end COMPONENT;

-- Double-edge detector
COMPONENT dual_edge_detector_Moore is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           edge_up_tick, edge_down_tick  : out STD_LOGIC);
end COMPONENT;

-- LED time_multiplexed (seven-segment display)
COMPONENT LED_time_mux is
    generic (
           Hz_800 : INTEGER := 62500; -- Hz800 established considering 50MHz clock
           N_bits : INTEGER := 16 -- N_bits established considering ceil(  log2(Hz_800)  ) = 16
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           in_3 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_2 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_1 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_0 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0));
end COMPONENT;

-- hex to sseg converter : 
COMPONENT hex_to_sseg is
    Port ( hex : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           sseg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
end COMPONENT;

-- ==================
-- SIGNALS AND CONSTANTS
-- ==================
-- db : debounced, b : bounced
SIGNAL tick_edge_up_db, tick_edge_up_b, tick_edge_down_db, tick_edge_down_b : STD_LOGIC;
SIGNAL debounced_signal : STD_LOGIC;
SIGNAL counter_debounced_MSB, counter_debounced_LSB, counter_bounced_MSB, counter_bounced_LSB : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL counter_db_next, counter_db_reg, counter_b_next, counter_b_reg : INTEGER RANGE 0 TO 99;
SIGNAL counter_db_reg_vect, counter_b_reg_vect : UNSIGNED(7 DOWNTO 0);

begin
-- ==========================
-- COMPONENTS INSTANCIATION
-- ==========================
debouncing_circuit : debouncing_FSM_Moore
GENERIC MAP( LIMIT => LIMIT_deboucing,
             N => N_deboucing)
PORT MAP(   clk => clk,           
            rst => rst,             
            input_signal => input_signal,
            debounced_signal => debounced_signal);

dual_edge_detector_debounced : dual_edge_detector_Moore
PORT MAP(   clk => clk,           
            rst => rst,             
            input_signal => debounced_signal,
            edge_up_tick => tick_edge_up_db, 
            edge_down_tick => tick_edge_down_db);   
      
dual_edge_detector_bounce : dual_edge_detector_Moore
PORT MAP(   clk => clk,           
            rst => rst,             
            input_signal => input_signal,
            edge_up_tick => tick_edge_up_b, 
            edge_down_tick => tick_edge_down_b);

seven_segment_display : LED_time_mux
GENERIC MAP( Hz_800 => Hz_800_LEDtm,
             N_bits => N_bits_LEDtm)
PORT MAP( clk => clk,
          rst => rst,
          in_3 => counter_debounced_MSB,
          in_2 => counter_debounced_LSB,
          in_1 => counter_bounced_MSB,
          in_0 => counter_bounced_LSB,
          sseg_out => sseg_out,
          ena_out => ena_out);
          
hex_to_sseg_debounced_MSB : hex_to_sseg
PORT MAP (hex => std_logic_vector(counter_db_reg_vect(7 DOWNTO 4)),
          sseg => counter_debounced_MSB);
          
hex_to_sseg_debounced_LSB : hex_to_sseg
PORT MAP (hex => std_logic_vector(counter_db_reg_vect(3 DOWNTO 0)),
          sseg => counter_debounced_LSB);
          
hex_to_sseg_bounced_MSB : hex_to_sseg
PORT MAP (hex => std_logic_vector(counter_b_reg_vect(7 DOWNTO 4)),
          sseg => counter_bounced_MSB);
          
hex_to_ssegbounced_LSB : hex_to_sseg
PORT MAP (hex => std_logic_vector(counter_b_reg_vect(3 DOWNTO 0)),
          sseg => counter_bounced_LSB);
    
    -- ==========================
    -- COUNTER to std_logic conversion
    -- ==========================      
    counter_db_reg_vect <= to_unsigned(counter_db_reg, 8);
    counter_b_reg_vect <= to_unsigned(counter_b_reg, 8);
    
    -- ==========================
    -- COUNTERS counting edges
    -- ==========================
    process (tick_edge_down_db, tick_edge_up_db, tick_edge_down_b, tick_edge_up_b )
    begin
    -- default value
        counter_db_next <= counter_db_reg;
        counter_b_next <= counter_b_reg;
        IF tick_edge_down_db = '1' OR tick_edge_up_db = '1' THEN
            IF counter_db_reg < 99 THEN
                counter_db_next <= counter_db_reg + 1;
            ELSE 
                counter_db_next <= 0;
            END IF;
        END IF;
        IF tick_edge_down_b = '1' OR tick_edge_up_b = '1' THEN
            IF counter_b_reg < 99 THEN
                counter_b_next <= counter_b_reg + 1;
            ELSE 
                counter_b_next <= 0;
            END IF;
        END IF;
    end process;

    -- ==========================
    -- registers
    -- ==========================
    process(clk, rst)
    begin
        IF rising_edge(clk) THEN
            IF rst = '0' then
                counter_db_reg <= 0;
                counter_b_reg <= 0;
            ELSE
                counter_db_reg <= counter_db_next;
                counter_b_reg <= counter_b_next;
            END IF;
        END IF;
    end process;

end Behavioral;
