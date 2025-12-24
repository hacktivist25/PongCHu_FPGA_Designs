library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity stack is
GENERIC (   W : INTEGER :=4; -- width of words
            N_addr_bits : INTEGER := 2); -- number of adressing_bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           wr_data : in STD_LOGIC_VECTOR(W-1 DOWNTO 0); -- write data
           psh, pop : in STD_LOGIC;
           empty, full : out STD_LOGIC;
           r_data : out STD_LOGIC_VECTOR(W-1 DOWNTO 0)); -- read data
end stack;

architecture Behavioral of stack is

-- memory element
type reg_array_t is array (0 to 2**N_addr_bits - 1) of std_logic_vector(W-1 downto 0);
signal array_reg : reg_array_t;

SIGNAL gauge_reg, gauge_next : INTEGER RANGE 0 TO 2**N_addr_bits;
SIGNAL full_reg, full_next, empty_reg, empty_next : STD_LOGIC;
SIGNAL wr_en, full_c : STD_LOGIC;

begin

process (clk, rst)
begin
    IF rst = '0' THEN -- then
        gauge_reg <= 0;
        full_reg <= '0';
        empty_reg <= '1';
    ELSIF clk'event AND clk = '1' THEN
        gauge_reg <= gauge_next;
        full_reg <= full_next;
        empty_reg <= empty_next;
        IF wr_en = '1' then
            array_reg(gauge_reg) <= wr_data;
        END IF;
    END IF;
end process;

process(gauge_reg, wr_data, psh, pop, full_reg, empty_reg)
begin
    IF gauge_reg = 0 THEN
        empty_next <= '1';
        full_next <= '0';
    ELSIF gauge_reg = 2**N_addr_bits THEN
        full_next <= '1';
        empty_next <= '0';
    ELSE
        full_next <= '0';
        empty_next <= '0';
    END IF;

    IF psh = '1' then
        gauge_next <= gauge_reg;
        IF gauge_reg < 2**N_addr_bits THEN
            gauge_next <= gauge_reg + 1;
        END IF; 
        
    ELSIF pop = '1' THEN
        gauge_next <= gauge_reg;
        IF gauge_reg > 0 THEN
            gauge_next <= gauge_reg - 1;
        END IF; 
    ELSE
        gauge_next <= gauge_reg;
    END IF;
    
    -- outputs
      if gauge_reg > 0 then
         r_data <= array_reg(gauge_reg-1);
      else
         r_data <= (others => '0');
      end if;
    
    IF gauge_reg = 2**N_addr_bits then
        full_c <= '1';
    ELSE
        full_c <= '0';
    END IF;
    
    wr_en <= psh AND NOT (full_c);
    empty <= empty_reg;
    full <= full_reg;

end process;

end Behavioral;
