library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity uart_dynamic_v2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rd_uart : in STD_LOGIC;
           wr_uart : in STD_LOGIC;
           wr_data : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           rx : in STD_LOGIC;
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); --1200, 2400, 4800 or 9600 bauds respectively for "00", "01", "10", "11"
           d_nums : in STD_LOGIC; -- '0' = 7 databits, '1' = 8 databits 
           s_nums : in STD_LOGIC; -- '0' = 1 stop bit, '1' = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           cpu_clear_overrun : STD_LOGIC; --  clears overrun sticky flag
           tx : out STD_LOGIC;
           tx_full : out STD_LOGIC;
           rx_empty : out STD_LOGIC;
           rd_data : out  STD_LOGIC_VECTOR(9 DOWNTO 0); -- 2 MSb for parity and frame error
           overrun_RX : out STD_LOGIC); -- if write data too fast on buffer) 
end uart_dynamic_v2;

architecture Behavioral of uart_dynamic_v2 is

--========================
-- COMPONENT declaration
--========================
COMPONENT counter_modulo_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- selector for 1200, 2400, 4800 or 9600 bauds
           max_tick : out STD_LOGIC);
end COMPONENT;

COMPONENT uart_rx_dynamic_v2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           rx_word : out STD_LOGIC_VECTOR(9 DOWNTO 0); -- maximum of 8 data bits + 2 error bits (parity and frame error)
           ready : out STD_LOGIC;
           done : out STD_LOGIC);
end COMPONENT;

COMPONENT uart_tx_dynamic_v2 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tx_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           tx_start : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           tx_out : out STD_LOGIC;
           ready : out STD_LOGIC;
           done : out STD_LOGIC);
end COMPONENT;

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

--========================
-- SIGNALS declaration  
--========================
CONSTANT width_word_RX : NATURAL := 10;
CONSTANT width_word_TX : NATURAL := 8;

CONSTANT fifo_bit_addr : NATURAL := 3;


SIGNAL s_tick_mod : STD_LOGIC;

SIGNAL fifo_tx_rd_data : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL fifo_tx_empty : STD_LOGIC;

SIGNAL fifo_rx_rd_data : STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL fifo_rx_full : STD_LOGIC;

SIGNAL tx_ready : STD_LOGIC;

SIGNAL rx_done : STD_LOGIC;
SIGNAL rx_out : STD_LOGIC_VECTOR(9 DOWNTO 0);

SIGNAL tx_start : STD_LOGIC;

SIGNAL fifo_rx_wr : STD_LOGIC;

SIGNAL overrun_RX_reg : STD_LOGIC;


begin
--========================
-- COMPONENT declaration
--========================
    baud_rate_generator :  counter_modulo_dynamic
        Port Map ( clk => clk,
                   rst => rst,
                   bd_rate => bd_rate,
                   max_tick  => s_tick_mod);
    
    
    RX_module : uart_rx_dynamic_v2
        port MAP( clk => clk,
               rst => rst,
               rx_in => rx,
               s_tick => s_tick_mod,
               d_nums => d_nums,
               s_nums => s_nums, 
               par => par,
               rx_word => rx_out,
               ready => open,
               done => rx_done);
    
    TX_module : uart_tx_dynamic_v2
        port MAP ( clk => clk,
               rst => rst,
               tx_in => fifo_tx_rd_data,
               tx_start => tx_start,
               s_tick => s_tick_mod,
               d_nums => d_nums,
               s_nums => s_nums,
               par => par,
               tx_out => tx,
               ready => tx_ready,
               done => open);
    
    fifo_RX : fifo
    Generic map( data_width => width_word_RX,
                 bit_addr => fifo_bit_addr)
    Port map ( clk => clk,
               rst => rst,
               wr_data => rx_out,
               rd => rd_uart,
               wr => fifo_rx_wr,
               rd_data => rd_data,
               full => fifo_rx_full,
               empty => rx_empty);

    
    fifo_TX : fifo                    
    Generic map( data_width => width_word_TX,      
                 bit_addr => fifo_bit_addr)        
    Port map ( clk => clk,                
               rst => rst,               
               wr_data => wr_data,           
               rd => tx_start,                
               wr => wr_uart,                
               rd_data => fifo_tx_rd_data,           
               full => tx_full,              
               empty => fifo_tx_empty);      
                     
--========================
-- overrun error RX
--========================
    process(clk, rst)
    begin
        IF rst = '0' THEN
            overrun_RX_reg <= '0';
        ELSIF rising_edge(clk) THEN
            IF cpu_clear_overrun = '1' then
                overrun_RX_reg <= '0';
            ELSIF (rx_done AND fifo_rx_full) = '1' THEN
                overrun_RX_reg <= '1';
            END IF;
        END IF;
    end process;
    
    overrun_rx <= overrun_rx_reg;
--========================
-- start signal for TX
--========================
    tx_start <= NOT(fifo_tx_empty) AND tx_ready;
    
--========================
-- write signal for RX fifo
--========================
   fifo_rx_wr <= rx_done AND NOT(fifo_rx_full);
    
end Behavioral;
