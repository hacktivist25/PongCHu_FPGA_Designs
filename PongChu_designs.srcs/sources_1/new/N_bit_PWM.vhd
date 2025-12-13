library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity N_bit_PWM is
    generic (
          N_bits : integer :=4
    );
    Port ( clk : in STD_LOGIC;
           w : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0); -- duty cycle is w / (2^N)
           rst : in STD_LOGIC;
           output : out STD_LOGIC);
end N_bit_PWM;

architecture Behavioral of N_bit_PWM is

SIGNAL counter_N_reg, counter_N_next : STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
SIGNAL output_reg, output_next : STD_LOGIC;

begin
process (clk, rst)
begin
    if rst = '0' then
        output_reg <= '0';
        counter_N_reg <= (others => '0');
    elsif clk'event and clk='1' THEN
        counter_N_reg <= counter_N_next;
        output_reg <= output_next;
    end if;
end process;

process (counter_N_reg)
begin
    counter_N_next <= std_logic_vector(unsigned(counter_N_reg) + 1);
    
    IF counter_N_reg < w THEN
        output_next <= '1';
    ELSE
        output_next <= '0';
    END IF;
  
    output <= output_reg;
end process;
end Behavioral;
