library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;



entity flag_buf is
    GENERIC ( d_bits : NATURAL := 8); -- number of data bits
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           received_data : in STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           clr_flag : in STD_LOGIC;
           set_flag : in STD_LOGIC;
           data : out STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           flag : out STD_LOGIC);
end flag_buf;

architecture Behavioral of flag_buf is

SIGNAL buf_reg, buf_next : STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
SIGNAL flag_reg, flag_next : STD_LOGIC;

begin
    process (clk, rst)
    begin
        IF rst <= '0' then
            flag_reg <= '0';
            buf_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) then
            flag_reg <= flag_next;
            buf_reg <= buf_next;
        END IF;
    end process;
    
    process (flag_reg, buf_reg, set_flag, clr_flag)
    begin
        flag_next <= flag_reg;
        buf_next <= buf_reg;
        
        IF set_flag = '1' then
            flag_next <= '1';
            buf_next <= received_data;
        ELSIF clr_flag = '1' then
            flag_next <= '0';
        END IF;
        
        data <= buf_reg;
        flag <= flag_reg;
    end process;

end Behavioral;
