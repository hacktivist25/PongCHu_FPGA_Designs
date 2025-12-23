library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity rotating_LED_banner is
    generic ( 
                --variables from LED time multiplexer
            Hz_800_LEDtm : INTEGER := 62500; 
            N_bits_LEDtm : INTEGER := 16; -- N_bits established considering ceil(  log2(Hz_800)  ) = 16
    
            --X_digits : INTEGER := 10; -- fixed message length of 10, because of to unintelligible
            -- code for variable length
            -- even though I am perfectly capable of creating one
            display_frequency: INTEGER := 12_500_000
            -- considering 50MHz clock, default "display_frequency" value is established for 4 Hz change rate
            );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           en : in STD_LOGIC;
           dir : in STD_LOGIC;
           message_X_digits : in STD_LOGIC_VECTOR(69 DOWNTO 0); --noice
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end rotating_LED_banner;

architecture Behavioral of rotating_LED_banner is

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

CONSTANT n_bits_for_display_frequency : INTEGER:= 24;
SIGNAL counter_next, counter_reg : STD_LOGIC_VECTOR(n_bits_for_display_frequency-1 DOWNTO 0);
SIGNAL counter_X_next, counter_X_reg : integer range 0 to 9;
SIGNAL in_3_sseg_reg, in_3_sseg_next : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_2_sseg_reg, in_2_sseg_next : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_1_sseg_reg, in_1_sseg_next : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_0_sseg_reg, in_0_sseg_next : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL sseg_out_next : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_next : STD_LOGIC_VECTOR(3 DOWNTO 0);


begin

time_multiplexed_seven_segment : LED_time_mux 
GENERIC MAP(    
        Hz_800 => Hz_800_LEDtm,
        N_bits => N_bits_LEDtm)
PORT MAP(
        clk => clk,
        rst => rst,
        in_3 => in_3_sseg_reg,
        in_2 => in_2_sseg_reg,
        in_1 => in_1_sseg_reg,
        in_0 => in_0_sseg_reg,
        ena_out => ena_out_next,
        sseg_out => sseg_out_next);

process (clk, rst)
begin
    IF rst = '0' THEN -- reset
        in_3_sseg_reg <= "0000000";
        in_2_sseg_reg <= "0000000";
        in_1_sseg_reg <= "0000000";
        in_0_sseg_reg <= "0000000";
        counter_reg <= (OTHERS =>'0');
        counter_X_reg <= 0;
    ELSIF clk'event AND clk = '1' THEN
        in_3_sseg_reg <= in_3_sseg_next;
        in_2_sseg_reg <= in_2_sseg_next;
        in_1_sseg_reg <= in_1_sseg_next;
        in_0_sseg_reg <= in_0_sseg_next;
        counter_reg <= counter_next;
        counter_X_reg <= counter_X_next;
     END IF;
end process;

process(en, dir, message_X_digits, counter_reg, counter_X_reg)
begin  
    IF en = '1' THEN
        IF to_integer(unsigned(counter_reg)) = display_frequency - 1 THEN
            counter_next <= (OTHERS => '0');
            IF dir = '1' then
                IF counter_X_reg = 9 THEN
                    counter_X_next <= 0;
                ELSE
                    counter_X_next <= counter_X_reg + 1;
                END IF;
            ELSIF dir = '0' then
                IF counter_X_reg= 0 THEN
                    counter_X_next <= 9;
                ELSE
                    counter_X_next <= counter_X_reg - 1;
                END IF;
           END IF;
        ELSE
            counter_next <= std_logic_vector(unsigned(counter_reg) + 1);
        END IF;
    END IF;

    in_3_sseg_next <= message_X_digits((((counter_X_reg)*7)+6) mod 69 DOWNTO ((counter_X_reg)*7) mod 69);
    in_2_sseg_next <= message_X_digits((((counter_X_reg + 1)*7)+6) mod 69 DOWNTO ((counter_X_reg + 1)*7) mod 69);
    in_1_sseg_next <= message_X_digits((((counter_X_reg + 2)*7)+6) mod 69 DOWNTO ((counter_X_reg + 2)*7) mod 69);
    in_0_sseg_next <= message_X_digits((((counter_X_reg + 3)*7)+6) mod 69 DOWNTO ((counter_X_reg + 3)*7) mod 69);

    ena_out <= ena_out_next;
    sseg_out <= sseg_out_next;
end process;

end Behavioral;
