library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- creates a square in Seven segment LED that rotates across the 4 LED displays

entity rotating_square_LED is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           cw : in STD_LOGIC;
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end rotating_square_LED;

architecture Behavioral of rotating_square_LED is

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

-- signals and constants for LED_time_multiplexer block
CONSTANT Hz_800_LEDtm : INTEGER := 4; 
CONSTANT N_bits_LEDtm : INTEGER := 2; -- change display every clock cycle
SIGNAL in_3_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_2_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_1_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_0_LEDtm : STD_LOGIC_VECTOR(6 DOWNTO 0);

-- signals for circular rotating pattern
CONSTANT square_high : STD_LOGIC_VECTOR(6 DOWNTO 0) := "1100011"; 
CONSTANT square_low : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0011101"; 
CONSTANT empty : STD_LOGIC_VECTOR(6 DOWNTO 0) := "0000000"; 
SIGNAL Hz_1_count_next : STD_LOGIC_VECTOR(5 DOWNTO 0); -- change square every 8 clock cycles
SIGNAL Hz_1_count_reg : STD_LOGIC_VECTOR(5 DOWNTO 0); -- change square every 8 clock cycles
-- 3 msb's of Hz_1_count will be used to decide which square display



begin
LEDtm : LED_time_mux GENERIC MAP(Hz_800 => Hz_800_LEDtm, N_bits => N_bits_LEDtm)
 PORT MAP(  clk => clk,
            rst => rst,
            in_3 => in_3_LEDtm,
            in_2 => in_2_LEDtm,
            in_1 => in_1_LEDtm,
            in_0 => in_0_LEDtm,
            ena_out => ena_out,    
            sseg_out => sseg_out   
 );

process (clk, rst)
begin
    IF rst = '0' THEN -- reset
        Hz_1_count_reg <= (OTHERS => '0');
    ELSIF clk'event AND clk = '1' THEN
        Hz_1_count_reg <= Hz_1_count_next;
    END IF; 
end process;

process (Hz_1_count_reg, en, cw)
begin
    if en = '1' AND cw = '1'THEN
        Hz_1_count_next <= std_logic_vector(unsigned(Hz_1_count_reg) + 1);
    elsif en = '1' AND cw = '0' THEN
        Hz_1_count_next <= std_logic_vector(unsigned(Hz_1_count_reg) - 1);
    end if;
        
    IF en = '1' THEN
        CASE Hz_1_count_reg (5 DOWNTO 3) IS
        WHEN "000"=>
            in_3_LEDtm <= square_high;
            in_2_LEDtm <= empty;
            in_1_LEDtm <= empty;
            in_0_LEDtm <= empty;
        WHEN "001"=>
            in_3_LEDtm <= empty;
            in_2_LEDtm <= square_high;
            in_1_LEDtm <= empty;
            in_0_LEDtm <= empty;
        WHEN "010"=>
            in_3_LEDtm <= empty;
            in_2_LEDtm <= empty;
            in_1_LEDtm <= square_high;
            in_0_LEDtm <= empty;
        WHEN "011"=>
            in_3_LEDtm <= empty;
            in_2_LEDtm <= empty;
            in_1_LEDtm <= empty;
            in_0_LEDtm <= square_high;
        WHEN "100"=>
            in_3_LEDtm <= empty;
            in_2_LEDtm <= empty;
            in_1_LEDtm <= empty;
            in_0_LEDtm <= square_low;
        WHEN "101"=>
            in_3_LEDtm <= empty;
            in_2_LEDtm <= empty;
            in_1_LEDtm <= square_low;
            in_0_LEDtm <= empty;
        WHEN "110"=>
            in_3_LEDtm <= empty;
            in_2_LEDtm <= square_low;
            in_1_LEDtm <= empty;
            in_0_LEDtm <= empty;
        WHEN "111"=>
            in_3_LEDtm <= square_low;
            in_2_LEDtm <= empty;
            in_1_LEDtm <= empty;
            in_0_LEDtm <= empty;
        WHEN OTHERS =>
            in_3_LEDtm <= empty;
            in_2_LEDtm <= empty;
            in_1_LEDtm <= empty;
            in_0_LEDtm <= empty;
        END CASE;
    END IF; 
    
end process;

end Behavioral;
