library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity parking_occupancy_counter is
    generic ( max_value_counter : INTEGER := 12;
              Hz_800_LEDtm : INTEGER := 62500; 
              N_bits_LEDtm : INTEGER := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a : in STD_LOGIC;
           b : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end parking_occupancy_counter;

architecture Behavioral of parking_occupancy_counter is

-- =====================
-- COMPONENTS
-- =====================
COMPONENT FSM_Moore_parking is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a, b : in STD_LOGIC;
           entering, exiting : out STD_LOGIC);
           -- exit is a banned word in VHDL, I hate disparity
end COMPONENT;

COMPONENT counter_inc_dec is
    generic ( max_value : INTEGER := 12); -- between 0 and 15, since I do a 4 bits counter
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           inc : in STD_LOGIC; -- increment signal
           dec : in STD_LOGIC; -- decrement signal
           counter_out : out STD_LOGIC_VECTOR(3 DOWNTO 0)); -- count from 0 max value
end COMPONENT;

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

COMPONENT hex_to_sseg is
    Port ( hex : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           sseg : out STD_LOGIC_VECTOR(6 DOWNTO 0));
end COMPONENT;

-- =====================
-- SIGNALS
-- =====================
-- output from FSM
SIGNAL entering_FSM, exiting_FSM : STD_LOGIC;
-- output from counter
SIGNAL counter : std_logic_vector(3 DOWNTO 0);
-- output from hex_to_sseg
SIGNAL sseg_digit0 : std_logic_vector(6 DOWNTO 0);

CONSTANT EMPTY : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000";

begin
    -- =====================
    -- INSTANCIATIONS
    -- =====================
    FSM_moore :  FSM_Moore_parking
    PORT MAP ( clk => clk,
               rst => rst,
               a => a,
               b => b,
               entering => entering_FSM,
               exiting => exiting_FSM);
               
    counter_increment_decrement : counter_inc_dec
    generic MAP( max_value => max_value_counter) 
    Port MAP ( clk => clk,
               rst => rst,
               inc => entering_FSM,
               dec => exiting_FSM,
               counter_out => counter);
               
    hex_to_sseg_digit : hex_to_sseg 
    Port MAP ( hex => counter,
               sseg=> sseg_digit0);
      
    LED_time_multiplexed : LED_time_mux
    generic MAP (
           Hz_800 => Hz_800_LEDtm,
           N_bits => N_bits_LEDtm)
    Port MAP ( clk => clk,
               rst => rst, 
               in_3 => EMPTY,
               in_2 => EMPTY,
               in_1 => EMPTY,
               in_0 => sseg_digit0,
               ena_out => ena_out,
               sseg_out => sseg_out);

end Behavioral;
