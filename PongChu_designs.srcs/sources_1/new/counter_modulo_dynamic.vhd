library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;


entity counter_modulo_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- selector for 1200, 2400, 4800 or 9600 bauds
           max_tick : out STD_LOGIC);
end counter_modulo_dynamic;

architecture Behavioral of counter_modulo_dynamic is

-- min baudrate = 1200
-- 50Mhz / (min_baudrate (1200) * oversampling factor (16) = max count (2604)
-- log2(2604) = 12, hence counter of 12 bits.
constant CNT_W : natural := 12;
SIGNAL counter_reg, counter_next : UNSIGNED (CNT_W - 1 DOWNTO 0);
CONSTANT BAUD_1200 : NATURAL := 2604; 
CONSTANT BAUD_2400 : NATURAL := 1302; 
CONSTANT BAUD_4800 : NATURAL := 651;  
CONSTANT BAUD_9600 : NATURAL := 326;  

function sel_baud(sel : STD_LOGIC_VECTOR(1 DOWNTO 0)) return natural is
    variable baudrate : natural;
    begin
        case sel is
            when "00" => return BAUD_1200;
            when "01" => return BAUD_2400;
            when "10" => return BAUD_4800;
            when OTHERS => return BAUD_9600;
        end case;
    end function;
        
    
begin
    process (clk, rst)
    begin
        IF rst = '0' then
            counter_reg <= (OTHERS => '0');
        ELSIF rising_edge (clk) THEN
            counter_reg <= counter_next;
        END IF;
    end process;

    process (counter_reg, bd_rate)
    variable max_count : NATURAL;
    begin
        max_count := sel_baud(bd_rate);
        counter_next <= counter_reg;
        
        max_tick <= '0';
        
        IF counter_reg >= to_unsigned(max_count-1, counter_reg'length) then
            counter_next <= (OTHERS => '0');
            max_tick <= '1';
        ELSE
            counter_next <= counter_reg + 1;
        END IF;
    end process;
end Behavioral;
