library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity fifo_tb is
--  Port ( );
end fifo_tb;

architecture Behavioral of fifo_tb is

    -- ======================
    -- COMPONENT DECLARATION
    -- ======================
    COMPONENT fifo is
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
    end COMPONENT;

    -- ================
    -- SIGNALS                
    -- ================
    CONSTANT data_width_sig : NATURAL := 8;  
    CONSTANT bit_addr_sig : NATURAL :=2;    
    SIGNAL clk_sig : STD_LOGIC;                                      
    SIGNAL rst_sig : STD_LOGIC;                                      
    SIGNAL wr_data_sig : STD_LOGIC_VECTOR(data_width_sig-1 DOWNTO 0);    
    SIGNAL rd_sig : STD_LOGIC;                                       
    SIGNAL wr_sig : STD_LOGIC;                                       
    SIGNAL rd_data_sig : STD_LOGIC_VECTOR(data_width_sig-1 DOWNTO 0);   
    SIGNAL full_sig : STD_LOGIC;                                    
    SIGNAL empty_sig : STD_LOGIC;                                  

begin
    -- ==========================
    -- COMPONENT INSTANCIATION     
    -- ==========================
    UUT : fifo GENERIC MAP( data_width => data_width_sig, 
                            bit_addr => bit_addr_sig )
    PORT MAP(   clk => clk_sig,
                rst => rst_sig,
                wr_data => wr_data_sig,
                rd => rd_sig,
                wr => wr_sig,
                rd_data => rd_data_sig,
                full => full_sig,
                empty => empty_sig);
 
    -- ================
    -- STIMULUS       
    -- ================
    -- we're testing a 8-bits fifo with 4 adresses
    clock : process
    begin
        clk_sig <= '1';
        WAIT FOR 10 ns;
        clk_sig <= '0';
        WAIT FOR 10 ns;
    end process;
    
    testing_vectors : process
    begin
        rst_sig <= '1';
        WAIT FOR 20ns;
        rst_sig <= '0';
        wr_data_sig <= "11001100"; -- 0xCC
        rd_sig <= '0';
        wr_sig <= '0';
        WAIT FOR 50 ns;
        
        rst_sig <= '1';
        WAIT FOR 20ns;
        
        -- writing 0xCC, 0xFF, 0x33, 0x99, and then 0x11(fail because full)
        wr_sig <= '1';
        WAIT FOR 20ns;
        wr_data_sig <= "11111111"; -- 0xFF
        WAIT FOR 20ns;
        wr_data_sig <= "00110011"; -- 0x33
        WAIT FOR 20ns;
        wr_data_sig <= "10011001"; -- 0x99
        WAIT FOR 20ns;
        wr_data_sig <= "00010001"; -- 0x11
        WAIT FOR 20ns;
        
        -- fifo now contains 0xCC, 0xFF, 0x33, 0x99, ad is reading 0xCC
        
        -- rd and wr one time : should read 0xFF and write 0x11 at0xCC's position
        rd_sig <= '1';
        WAIT FOR 20ns;
        
        -- fifo now should contain 0x11, 0xFF, 0x33, 0x99, and it's reading 0xFF
        
        -- read 0x33, 0x99, 0x11, then nothing because empty flag
        wr_sig <= '0';
        WAIT FOR 100ns;
        
        -- empty fifo, rd and wr should perform only write, and not read
        wr_sig <= '1';
        wr_data_sig <= "00100010"; -- 0x22
        WAIT FOR 20ns;
        -- and then it shoud read AND write since it's not empty anymore
        wr_data_sig <= "01000100"; -- 0x44
        WAIT FOR 20ns;
        
    end process;
end Behavioral;
