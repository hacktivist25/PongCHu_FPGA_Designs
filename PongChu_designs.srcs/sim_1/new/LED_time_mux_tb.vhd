library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity LED_time_mux_tb is
--  Port ( );
end LED_time_mux_tb;

architecture Behavioral of LED_time_mux_tb is

COMPONENT LED_time_mux is
generic (
Hz_800 : INTEGER := 62500; -- considering 50MHz clock
N_bits : INTEGER := 16 -- ceil(  log2(Hz_800)  ) = 16
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

CONSTANT Hz_800_sig : INTEGER := 16 ;
CONSTANT N_bits_sig : INTEGER := 4;

SIGNAL clk_sig : STD_LOGIC;
SIGNAL rst_sig : STD_LOGIC;
SIGNAL in_3_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_2_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_1_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL in_0_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL ena_out_sig : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL sseg_out_sig : STD_LOGIC_VECTOR(6 DOWNTO 0);

begin
UUT : LED_time_mux GENERIC MAP (Hz_800 => Hz_800_sig, N_bits => N_bits_sig) PORT MAP ( clk => clk_sig, rst => rst_sig, in_3 => in_3_sig, in_2 => in_2_sig, in_1 => in_1_sig, in_0 => in_0_sig, ena_out => ena_out_sig, sseg_out => sseg_out_sig);

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
    in_3_sig <= "0000001";
    in_2_sig <= "0000011";
    in_1_sig <= "0000111";
    in_0_sig <= "0001111";
    WAIT FOR 30 ns;
    
    -- end of reset
    rst_sig <= '1';
    WAIT FOR 400 ns;
end process;

end Behavioral;
