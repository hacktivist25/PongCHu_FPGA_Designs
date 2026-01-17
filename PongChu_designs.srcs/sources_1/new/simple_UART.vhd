library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity simple_UART is
    generic ( d_bits_uart : NATURAL := 8;
              dvsr_uart : NATURAL := 16;
              baudrate_divisor : NATURAL := 163 -- 50Mhz clock / (dvsr_uart * baudrate_divisor) = 19200 bauds for example here
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rd_uart, wr_uart : in STD_LOGIC;
           wr_data : in STD_LOGIC_VECTOR(d_bits_uart -1 DOWNTO 0);
           rx : in STD_LOGIC;
           tx_flag, rx_flag, tx : out STD_LOGIC;
           rd_data : out  STD_LOGIC_VECTOR(d_bits_uart -1 DOWNTO 0));
end simple_UART;

architecture Behavioral of simple_UART is

--========================
-- COMPONENT declaration
--========================
COMPONENT counter_modulo is
    Generic (   max_count : NATURAL := 16);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           max_tick : out STD_LOGIC);
end COMPONENT;

COMPONENT uart_rx is
    GENERIC (   d_bits : NATURAL := 8; -- number of data bits
                dvsr : NATURAL := 16); -- 16 for 1 stop bit, 24 for 1.5, 32 for 2 stop bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           rx_word : out STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           done : out STD_LOGIC);
end COMPONENT;

COMPONENT uart_tx is
    GENERIC (   d_bits : NATURAL := 8; -- number of data bits
                dvsr : NATURAL := 16); -- 16 for 1 stop bit, 24 for 1.5, 32 for 2 stop bits
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tx_start : in STD_LOGIC;
           tx_in : in STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           s_tick : in STD_LOGIC;
           tx_out : out STD_LOGIC;
           done : out STD_LOGIC);
end COMPONENT;

COMPONENT flag_buf is
    GENERIC ( d_bits : NATURAL := 8); -- number of data bits
    Port ( rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           received_data : in STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           clr_flag : in STD_LOGIC;
           set_flag : in STD_LOGIC;
           data : out STD_LOGIC_VECTOR(d_bits - 1 DOWNTO 0);
           flag : out STD_LOGIC);
end COMPONENT;
--========================
-- SIGNALS declaration  
--========================
SIGNAL s_tick : STD_LOGIC;
SIGNAL done_receiver, done_transmitter : STD_LOGIC;
SIGNAL tx_flag_signal : STD_LOGIC;
SIGNAL rx_word : STD_LOGIC_VECTOR(d_bits_uart - 1 DOWNTO 0);
SIGNAL out_ff_tx : STD_LOGIC_VECTOR(d_bits_uart - 1 DOWNTO 0);

begin
    --========================
    -- COMPONENT instanciation  
    --========================
    baudrate_generator : counter_modulo
    GENERIC MAP (max_count => baudrate_divisor)
    PORT MAP ( clk => clk,
                rst => rst,
                max_tick => s_tick);
                
    uart_RX_module : uart_rx
    GENERIC MAP ( d_bits => d_bits_uart,
                  dvsr => dvsr_uart)
    PORT MAP (  clk => clk,
                rst => rst,
                rx_in => rx,
                s_tick => s_tick,
                rx_word => rx_word,
                done => done_receiver);
           
    uart_TX_module : uart_tx
    GENERIC MAP ( d_bits => d_bits_uart,
                  dvsr => dvsr_uart)
    PORT MAP (  clk => clk,
                rst => rst,
                tx_start => tx_flag_signal,
                tx_in => out_ff_tx,
                s_tick => s_tick,
                tx_out => tx,
                done => done_transmitter);
                
    FF_RX : flag_buf
    GENERIC MAP ( d_bits => d_bits_uart)
    PORT MAP (  rst => rst,
                clk => clk,
                received_data => rx_word,
                clr_flag => rd_uart,
                set_flag => done_receiver,
                data => rd_data,
                flag => rx_flag);
                
    FF_TX : flag_buf
    GENERIC MAP ( d_bits => d_bits_uart)
    PORT MAP (  rst => rst,
                clk => clk,
                received_data => wr_data,
                clr_flag => done_transmitter,
                set_flag => wr_uart,
                data => out_ff_tx,
                flag => tx_flag_signal);
         
    tx_flag <= tx_flag_signal;
end Behavioral;
