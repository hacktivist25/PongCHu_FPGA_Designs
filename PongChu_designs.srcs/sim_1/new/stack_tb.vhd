library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stack_tb is
--  Port ( );
end stack_tb;

architecture Behavioral of stack_tb is

COMPONENT stack is
GENERIC (   W : INTEGER :=4; -- width of words
            N_addr_bits : INTEGER := 2); -- number of adressing_bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           wr_data : in STD_LOGIC_VECTOR(W-1 DOWNTO 0); -- write data
           psh, pop : in STD_LOGIC;
           empty, full : out STD_LOGIC;
           r_data : out STD_LOGIC_VECTOR(W-1 DOWNTO 0)); -- read data
end COMPONENT;

constant W_sig : integer := 4;
SIGNAL clk_sig : STD_LOGIC;                                        
SIGNAL rst_sig : STD_LOGIC;                                        
SIGNAL wr_data_sig : STD_LOGIC_VECTOR(W_sig-1 DOWNTO 0); 
SIGNAL psh_sig, pop_sig : STD_LOGIC;                                   
SIGNAL empty_sig, full_sig : STD_LOGIC;                               
SIGNAL r_data_sig : STD_LOGIC_VECTOR(W_sig-1 DOWNTO 0); 


begin
UUT : stack 
PORT MAP (  clk => clk_sig,
            rst => rst_sig,
            wr_data => wr_data_sig,
            psh => psh_sig,
            pop => pop_sig,
            empty => empty_sig,
            full => full_sig,
            r_data => r_data_sig);

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10ns;
    clk_sig <= '0';
    WAIT FOR 10ns;
end process;

test_vector : process
begin
    -- reset
    rst_sig <= '0';
    wr_data_sig <= "0001";
    psh_sig <= '0';
    pop_sig <= '0';
    WAIT FOR 50ns;
    rst_sig <= '1';
    WAIT FOR 20ns;
    psh_sig <= '1';
    WAIT FOR 20ns;
    wr_data_sig <= "0010";
    WAIT FOR 20ns;
    wr_data_sig <= "0011";
    WAIT FOR 20ns;
    wr_data_sig <= "0100";
    WAIT FOR 20ns;
    wr_data_sig <= "0101";
    WAIT FOR 20ns;
    wr_data_sig <= "0110";
    WAIT FOR 20ns;
    psh_sig <= '0';
    pop_sig <= '1';
    WAIT FOR 160ns;
end process;

end Behavioral;
