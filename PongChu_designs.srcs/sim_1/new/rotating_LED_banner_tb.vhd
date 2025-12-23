library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rotating_LED_banner_tb is
--  Port ( );
end rotating_LED_banner_tb;

architecture Behavioral of rotating_LED_banner_tb is

COMPONENT rotating_LED_banner is
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
end COMPONENT;

--constants for testbench purposes
CONSTANT Hz_800_LEDtm_sig : INTEGER := 4; -- each clock_cycle => new displayer
CONSTANT N_bits_LEDtm_sig : INTEGER := 2;
CONSTANT display_frequency_sig: INTEGER := 8; -- let a 4 digit cycle 2 times before showing the new sequence

SIGNAL clk_sig : STD_LOGIC;                                          
SIGNAL rst_sig : STD_LOGIC;                                          
SIGNAL en_sig : STD_LOGIC;                                           
SIGNAL dir_sig : STD_LOGIC;                                          
SIGNAL message_X_digits_sig : STD_LOGIC_VECTOR(69 DOWNTO 0);
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);                 
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);                 

begin
UUT : rotating_LED_banner
GENERIC MAP (
            Hz_800_LEDtm => Hz_800_LEDtm_sig,
            N_bits_LEDtm => N_bits_LEDtm_sig,
            display_frequency => display_frequency_sig)
PORT MAP (
           clk => clk_sig,
           rst => rst_sig,
           en => en_sig,
           dir => dir_sig,
           message_X_digits => message_X_digits_sig,
           sseg_out => sseg_out_sig,        
           ena_out=> ena_out_sig);
         
clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    -- reset
    rst_sig <= '0';
    en_sig <= '1';
    dir_sig <= '1';
    message_X_digits_sig <= 
    "0000001" &
    "0000010" &
    "0000011" &
    "0000100" &
    "0000101" &
    "0000110" &
    "0000111" &
    "0001000" &
    "0001001" &
    "0001010";
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 1600 ns;
    
    -- stop
    en_sig <= '0';
    WAIT FOR 60 ns;
    
    -- change direction
    dir_sig <= '0';
    WAIT FOR 20 ns;
    
    en_sig <= '1';
    WAIT FOR 1600 ns;
end process;

end Behavioral;