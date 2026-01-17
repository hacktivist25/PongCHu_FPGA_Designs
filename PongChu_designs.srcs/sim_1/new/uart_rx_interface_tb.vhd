library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity uart_rx_interface_tb is
--  Port ( );
end uart_rx_interface_tb;

architecture Behavioral of uart_rx_interface_tb is

COMPONENT uart_rx_interface is
    GENERIC ( d_bits : NATURAL := 8); -- number of data bits
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           received_data : in STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           clr_flag : in STD_LOGIC;
           set_flag : in STD_LOGIC;
           data : out STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           flag : out STD_LOGIC);
end COMPONENT;

CONSTANT d_bits_sig : NATURAL := 8; -- number of data bits          
SIGNAL rst_sig : STD_LOGIC;                                        
SIGNAL clk_sig : STD_LOGIC;                                        
SIGNAL received_data_sig : STD_LOGIC_VECTOR(d_bits_sig - 1 DOWNTO 0);  
SIGNAL clr_flag_sig : STD_LOGIC;                                   
SIGNAL set_flag_sig : STD_LOGIC;                                   
SIGNAL data_sig : STD_LOGIC_VECTOR(d_bits_sig - 1 DOWNTO 0);          
SIGNAL flag_sig : STD_LOGIC;

begin

UUT : uart_rx_interface
GENERIC MAP(d_bits => d_bits_sig)
PORT MAP( rst => rst_sig,
          clk => clk_sig,
          received_data => received_data_sig,
          clr_flag => clr_flag_sig,
          set_flag => set_flag_sig,
          data => data_sig,
          flag => flag_sig);

clock : process
begin
    clk_sig <= '1';
    WAIT FOR 10 ns;
    clk_sig <= '0';
    WAIT FOR 10 ns;
end process;

test_vector : process
begin
    rst_sig <= '0';
    received_data_sig <= "11001010";
    clr_flag_sig <= '0';
    set_flag_sig <= '0';
    WAIT FOR 30 ns;
    
    rst_sig <= '1';
    WAIT FOR 20 ns;
    
    set_flag_sig <= '1';
    WAIT FOR 20 ns;
    set_flag_sig <= '0';
    received_data_sig <= "11111111";
    WAIT FOR 20 ns;
    
    set_flag_sig <= '1';
    WAIT FOR 20 ns;
    set_flag_sig <= '0';
    received_data_sig <= "00001111";
    WAIT FOR 20 ns;
    
    clr_flag_sig <= '1';
    WAIT FOR 20 ns;
    clr_flag_sig <= '0';
    received_data_sig <= "11001100";
    WAIT FOR 20 ns;
    
    set_flag_sig <= '1';
    WAIT FOR 20 ns;
    set_flag_sig <= '0';
    WAIT FOR 20 ns;
    
end process;

end Behavioral;
