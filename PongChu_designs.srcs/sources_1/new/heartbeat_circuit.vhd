library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity heartbeat_circuit is
    generic (
           --variables from LED time multiplexer
           Hz_800_LEDtm : INTEGER := 62500; 
           N_bits_LEDtm : INTEGER := 16; -- N_bits established considering ceil(  log2(Hz_800)  ) = 16
           bpm_72 : INTEGER := 41_666_666;
           N_bits : INTEGER := 26
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end heartbeat_circuit;

architecture Behavioral of heartbeat_circuit is

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
-- led time multiplexer signals
SIGNAL in_3_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_2_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_1_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_0_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);


--1.2 Hz counter
CONSTANT bpm_72_third1 : INTEGER := bpm_72/3; -- one third of bpm_72 
--(Dividing in VHDL already applies a roof(X) function), i.e 10/3 = 3
CONSTANT bpm_72_third2 : INTEGER := (2*bpm_72)/3; -- two third of bpm_72
signal bpm_72_counter_reg, bpm_72_counter_next : STD_LOGIC_VECTOR(26 DOWNTO 0);

CONSTANT left_bar : STD_LOGIC_VECTOR(6 DOWNTO 0):="0000110";
CONSTANT right_bar : STD_LOGIC_VECTOR(6 DOWNTO 0):="0110000";
CONSTANT empty : STD_LOGIC_VECTOR(6 DOWNTO 0):="0000000";

begin
LED_tm : LED_time_mux 
GENERIC MAP( Hz_800 => Hz_800_LEDtm,
             N_bits => N_bits_LEDtm)
PORT MAP (  clk => clk,   
            rst => rst, 
            in_3 => in_3_LEDtm,    
            in_2 => in_2_LEDtm,    
            in_1 => in_1_LEDtm,    
            in_0 => in_0_LEDtm,    
            ena_out => ena_out,
            sseg_out => sseg_out);

process(clk, rst)
begin
    -- reset
    IF rst = '0' THEN
        bpm_72_counter_reg <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN   
        bpm_72_counter_reg <= bpm_72_counter_next;
    END IF; 
end process;

process (bpm_72_counter_reg, en)
begin
    IF to_integer(unsigned(bpm_72_counter_reg)) = bpm_72 AND en = '1' THEN
        bpm_72_counter_next <= (OTHERS => '0');
    ELSIF en = '0' THEN
        bpm_72_counter_next <= bpm_72_counter_reg;
    ELSE
        bpm_72_counter_next <= std_logic_vector(unsigned(bpm_72_counter_reg) + 1);
    END IF;
    
    IF to_integer(unsigned(bpm_72_counter_reg)) < bpm_72_third1 THEN
        in_3_LEDtm <= empty;
        in_2_LEDtm <= right_bar;
        in_1_LEDtm <= left_bar;
        in_0_LEDtm <= empty;
    ELSIF to_integer(unsigned(bpm_72_counter_reg)) < bpm_72_third2 THEN
        in_3_LEDtm <= empty;
        in_2_LEDtm <= left_bar;
        in_1_LEDtm <= right_bar;
        in_0_LEDtm <= empty;
    ELSE
        in_3_LEDtm <= left_bar;
        in_2_LEDtm <= empty;
        in_1_LEDtm <= empty;
        in_0_LEDtm <= right_bar;
    END IF;
end process;

end Behavioral;
