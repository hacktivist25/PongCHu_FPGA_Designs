library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- fifo is implemented in circular fashion (see "circular buffer" on wikipedia)
entity fifo is
    Generic( data_width : NATURAL := 8;
             bit_addr : NATURAL :=4);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC; 
           wr_data : in STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
           rd : in STD_LOGIC;
           wr : in STD_LOGIC;
           rd_data : out STD_LOGIC_VECTOR(data_width-1 DOWNTO 0);
           full : out STD_LOGIC;
           empty : out STD_LOGIC);
end fifo;

architecture Behavioral of fifo is    
    
    TYPE mem_t is array (0 to 2**bit_addr - 1) of std_logic_vector(data_width-1 downto 0);
    SIGNAL mem : mem_t;
    SIGNAL rd_pt_reg, rd_pt_next : UNSIGNED( bit_addr - 1 DOWNTO 0); -- read  pointer
    SIGNAL wr_pt_reg, wr_pt_next : UNSIGNED( bit_addr - 1 DOWNTO 0); -- write pointer
    SIGNAL full_reg, full_next : STD_LOGIC;
    SIGNAL empty_reg, empty_next : STD_LOGIC;
    
    
begin
    PROCESS(clk, rst)
    begin
        IF rst='0' THEN
            full_reg <= '0';
            empty_reg <= '1';
            rd_pt_reg <= (OTHERS => '0');
            wr_pt_reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            full_reg <= full_next;
            empty_reg <= empty_next;
            rd_pt_reg <= rd_pt_next;
            wr_pt_reg <= wr_pt_next;
        END IF;
    end process;
    
    -- ===================
    -- MEMORY OPERATIONS
    -- ===================
    process(clk)
    begin
        if rising_edge(clk) then
            if  wr = '1' and ((full_reg = '0') or (rd = '1')) then
                mem(to_integer(wr_pt_reg)) <= wr_data;
            end if;
        end if;
    end process;
    
    PROCESS(rd, wr, rd_pt_reg, wr_pt_reg, full_reg, empty_reg)
        variable rd_wr : STD_LOGIC_VECTOR(1 DOWNTO 0);
        variable rd_pt_succ : UNSIGNED( bit_addr - 1 DOWNTO 0);
        variable wr_pt_succ : UNSIGNED( bit_addr - 1 DOWNTO 0); 
    begin
        -- ================
        -- default values
        -- ================
        rd_wr (1) := rd;
        rd_wr (0) := wr;
        full_next <= full_reg;
        empty_next <= empty_reg;
        rd_pt_next <= rd_pt_reg;
        wr_pt_next <= wr_pt_reg;
        rd_pt_succ := rd_pt_reg + 1; 
        wr_pt_succ := wr_pt_reg + 1; 
        
        -- ================
        -- next_state
        -- ================
        CASE rd_wr IS
            when "00" =>  -- no op
                --do nothing
            when "01" =>  -- write
                IF full_reg = '0' THEN -- if not full
                    wr_pt_next <= wr_pt_succ;
                    IF wr_pt_succ = rd_pt_reg THEN
                        full_next <= '1';
                    END IF;
                    empty_next <= '0';
                END IF;
            when "10" =>  -- read
                IF empty_reg = '0' THEN -- if not full
                    rd_pt_next <= rd_pt_succ;
                    IF rd_pt_succ = wr_pt_reg THEN
                        empty_next <= '1';
                    END IF;
                    full_next <= '0';
                END IF;
            when "11" =>  -- write and read
                wr_pt_next <= wr_pt_succ;
                empty_next <= '0'; -- if empty, it's a write only operation, so empty flag is cleared
                if empty_reg = '0' THEN
                    rd_pt_next <= rd_pt_succ;
                END IF;
            when others =>
                --do nothing
        end case;
    end process;
    -- ================
    -- output affectation
    -- ================
    full <= full_reg;
    empty <= empty_reg;
    rd_data <= mem(to_integer(rd_pt_reg));
end Behavioral;
