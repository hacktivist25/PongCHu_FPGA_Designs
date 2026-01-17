library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;



entity counter_modulo is
    Generic (   max_count : NATURAL := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           max_tick : out STD_LOGIC);
end counter_modulo;

architecture Behavioral of counter_modulo is

function clog2 (n : natural) return natural IS
  variable r : natural := 0;    
  variable v : natural := n - 1;
begin
  while v > 0 loop
    r := r+1;
    v := v/2;
  end loop;
  return r;
end function;

CONSTANT N_bits : NATURAL := clog2(max_count);
SIGNAL counter_reg, counter_next : UNSIGNED(N_bits - 1 DOWNTO 0);

begin
    process(clk, rst)
    begin
        IF rst = '0' then
            counter_reg <= (OTHERS => '0');
        ELSIF rising_edge (clk) THEN
            counter_reg <= counter_next;
        END IF;
    end process;
    
    process (counter_reg)
    begin
        counter_next <= counter_reg;
        max_tick <= '0';
        IF counter_reg = max_count-1 then
            counter_next <= (OTHERS => '0');
            max_tick <= '1';
        ELSE
            counter_next <= counter_reg + 1;
        END IF;
    end process;

end Behavioral;
