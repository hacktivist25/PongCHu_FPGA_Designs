library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- We suppose a clock period of 20 ns (50MHz oscillator)
-- m and n are interpreted as unsigned 4 bits wide numbers
-- times are m*100ns and n*100ns respectively for "on" and "off" periods
entity programmable_square_wave_gen is
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           m : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           n : in STD_LOGIC_VECTOR(3 DOWNTO 0);
           output : out STD_LOGIC);
end programmable_square_wave_gen;

architecture Behavioral of programmable_square_wave_gen is

SIGNAL m_count_reg, n_count_reg, m_count_next, n_count_next : STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL output_reg, output_next : STD_LOGIC;


begin

process(clk, rst)
begin
     IF rst = '0' THEN
        output_reg <= '0';
        m_count_reg <= "0000000";
        n_count_reg <= "0000000";
    ELSIF clk'event AND clk = '1' THEN
        output_reg <= output_next;
        m_count_reg <= m_count_next;
        n_count_reg <= n_count_next;
    END IF;
end process;

process(output_reg, n_count_reg, m_count_reg)
begin
    output_next <= output_reg;
    m_count_next <= m_count_reg;
    n_count_next <= n_count_reg;
    
    IF output_reg = '0' THEN
        IF to_integer(unsigned(n_count_reg)) = 5*to_integer(unsigned(n)) - 1 THEN
            n_count_next <= "0000000";
            output_next <= '1';
        ELSE
            n_count_next <= std_logic_vector(UNSIGNED(n_count_reg) + 1);
            
        END IF;
    ELSIF output_reg = '1' then
        IF to_integer(unsigned(m_count_reg)) = 5*to_integer(unsigned(m)) - 1 THEN
            m_count_next <= "0000000";
            output_next <= '0';
        ELSE
            m_count_next <= std_logic_vector(UNSIGNED(m_count_reg) + 1);
        END IF;
    END IF;
    
    output <= output_reg;
end process;
end Behavioral;
