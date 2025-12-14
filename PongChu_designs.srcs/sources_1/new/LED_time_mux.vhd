library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity LED_time_mux is
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
end LED_time_mux;

architecture Behavioral of LED_time_mux is

SIGNAL counter_reg : STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
SIGNAL counter_next : STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);


begin
process (clk, rst)
begin
    if rst = '0' THEN -- reset
        counter_reg <= (others => '0');
    elsif clk'event and clk = '1' THEN
        counter_reg<= counter_next;
    end if;
end process;

process (in_3, in_2, in_1, in_0, counter_reg)
begin
    -- next-state calculation
    IF to_integer(unsigned(counter_reg)) = Hz_800 - 1 THEN 
        counter_next <= (OTHERS => '0');
    ELSE
        counter_next <= std_logic_vector(unsigned(counter_reg ) + 1);
    END IF;
    
    -- choosing digit to enable
    CASE counter_reg(N_bits-1 DOWNTO N_bits-2) is
        WHEN "00" =>
            sseg_out <= in_3;
            ena_out <= "0111";
        WHEN "01" =>
            sseg_out <= in_2;
            ena_out <= "1011";
        WHEN "10" =>
            sseg_out <= in_1;
            ena_out <= "1101";
        WHEN "11" =>
            sseg_out <= in_0;
            ena_out <= "1110";
        WHEN OTHERS =>
            sseg_out <= "0000000";
            ena_out <= "1111";
    end case;
end process;

end Behavioral;
