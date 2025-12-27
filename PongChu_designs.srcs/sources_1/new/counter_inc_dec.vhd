library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity counter_inc_dec is
    generic ( max_value : INTEGER := 12); -- between 0 and 15, since I do a 4 bits counter
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           inc : in STD_LOGIC; -- increment signal
           dec : in STD_LOGIC; -- decrement signal
           counter_out : out STD_LOGIC_VECTOR(3 DOWNTO 0)); -- count from 0 max value
end counter_inc_dec;

architecture Behavioral of counter_inc_dec is

SIGNAL counter_reg, counter_next : INTEGER RANGE 0 TO max_value;

begin
    -- ====================
    -- registers
    -- ====================
    process (clk, rst)
    begin
        IF rst = '0' THEN 
            counter_reg <= 0;
        ELSIF rising_edge(clk) then
            counter_reg <= counter_next;
        END IF;
    end process;

    process (counter_reg, inc, dec)
    begin
        -- ====================
        -- default value
        -- ====================
        counter_next <= counter_reg;
        
        -- ====================
        -- bext_state logic
        -- ====================
        IF inc = '1' THeN
            IF counter_reg = max_value THEN
                counter_next <= counter_reg;
            else   
                counter_next <= counter_reg + 1;
            END IF;
        ELSIF dec = '1' THEN
            IF counter_reg = 0 THEN
                counter_next <= counter_reg;
            else   
                counter_next <= counter_reg - 1;
            END IF;
        END IF;
        
        -- ====================
        -- output
        -- ====================
        counter_out <= std_logic_vector(to_unsigned(counter_reg, 4));
    end process;
end Behavioral;
