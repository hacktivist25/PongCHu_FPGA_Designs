library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;


entity uart_dynamic is
generic ( d_bits_uart : NATURAL := 8);
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rd_uart : in STD_LOGIC;
           wr_uart : in STD_LOGIC;
           wr_data : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           rx : in STD_LOGIC;
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); --1200, 2400, 4800 or 9600 bauds respectively for "00", "01", "10", "11"
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits 
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           tx_flag : out STD_LOGIC;
           rx_flag : out STD_LOGIC;
           tx : out STD_LOGIC;
           rd_data : out  STD_LOGIC_VECTOR(7 DOWNTO 0);
           overrun_TX : out STD_LOGIC; -- if write data too fast on buffer
           err_RX : out  STD_LOGIC_VECTOR(2 DOWNTO 0)); -- (overrun error, parity error, frame_error)
end uart_dynamic;

architecture Behavioral of uart_dynamic is

--========================
-- COMPONENT declaration
--========================
COMPONENT counter_modulo_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           bd_rate : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- selector for 1200, 2400, 4800 or 9600 bauds
           max_tick : out STD_LOGIC);
end COMPONENT;

COMPONENT uart_rx_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           rx_in : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
           rx_word : out STD_LOGIC_VECTOR(7 DOWNTO 0);
           err : out STD_LOGIC_VECTOR(1 DOWNTO 0); -- (parity error, frame_error)
           done : out STD_LOGIC);
end COMPONENT;

COMPONENT uart_tx_dynamic is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           tx_in : in STD_LOGIC_VECTOR(7 DOWNTO 0);
           tx_start : in STD_LOGIC;
           s_tick : in STD_LOGIC;
           d_nums : in STD_LOGIC; -- 0 = 7 databits, 1 = 8 databits
           s_nums : in STD_LOGIC; -- 0 = 1 stop bit, 1 = 2 stop bits
           par : in STD_LOGIC_VECTOR(1 DOWNTO 0); -- parity scheme : "00" or "11" = no, "01" = odd, "10" = even
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
SIGNAL s_tick_mod : STD_LOGIC;
SIGNAL done_RX, done_TX : STD_LOGIC;
SIGNAL flag_RX, flag_TX : STD_LOGIC;
SIGNAL word_out_RX, word_in_TX : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL err_RX_sig : STD_LOGIC_VECTOR(1 DOWNTO 0);

SIGNAL overun_RX_sig : STD_LOGIC; 
SIGNAL overun_TX_sig : STD_LOGIC; 
SIGNAL overun_RX_reg, overun_RX_next : STD_LOGIC; 
SIGNAL overun_TX_reg, overun_TX_next : STD_LOGIC; 

begin
--========================
-- COMPONENT declaration
--========================
    baud_rate_generator :  counter_modulo_dynamic
        Port Map ( clk => clk,
                   rst => rst,
                   bd_rate => bd_rate,
                   max_tick  => s_tick_mod);
    
    
    RX_module : uart_rx_dynamic
        port MAP( clk => clk,
               rst => rst,
               rx_in => rx,
               s_tick => s_tick_mod,
               d_nums => d_nums,
               s_nums => s_nums, 
               par => par,
               rx_word => word_out_RX,
               err => err_RX_sig,
               done => done_RX);
    
    TX_module : uart_tx_dynamic
        port MAP ( clk => clk,
               rst => rst,
               tx_in => word_in_TX,
               tx_start => flag_TX,
               s_tick => s_tick_mod,
               d_nums => d_nums,
               s_nums => s_nums,
               par => par,
               tx_out => tx,
               done => done_TX);
    
    flag_FF_RX : flag_buf 
        GENERIC MAP ( d_bits => d_bits_uart)
        Port MAP ( rst => rst,
                   clk => clk,
                   received_data => word_out_RX,
                   clr_flag => rd_uart,
                   set_flag => done_RX,
                   data => rd_data,
                   flag => flag_RX);
    
    flag_FF_TX : flag_buf 
        GENERIC MAP ( d_bits => d_bits_uart)
        Port MAP ( rst => rst,
                   clk => clk,
                   received_data => wr_data,
                   clr_flag => done_TX,
                   set_flag => wr_uart,
                   data => word_in_TX,
                   flag => flag_TX);
--========================
-- error 
--========================
    process(clk, rst)
    begin
        IF rst = '0' THEN
            overun_RX_reg <= '0';
            overun_TX_reg <= '0';
        ELSIF rising_edge(clk) then
            overun_RX_reg <= overun_RX_next;
            overun_TX_reg <= overun_TX_next;
        END IF;
    end process;
    
    overun_RX_sig <= flag_RX AND done_RX;
    overun_TX_sig <= flag_TX AND wr_uart;
    
    process(wr_uart, rd_uart, overun_RX_sig, overun_TX_sig, overun_RX_reg, overun_TX_reg, done_RX, done_TX)
    begin
        overun_RX_next <= overun_RX_reg;
        overun_TX_next <= overun_TX_reg;
        
        IF (wr_uart OR done_TX) = '1' then
            overun_TX_next <= overun_TX_sig;
        END IF;
        IF (rd_uart OR done_RX) = '1' then
            overun_RX_next <= overun_RX_sig;
        END IF;
    end process;
    
--========================
-- OUTPUT affectation
--========================
    err_RX(2) <= overun_RX_reg;
    err_RX(1 DOWNTO 0) <= err_RX_sig;
    overrun_TX <= overun_TX_reg;
    tx_flag <= flag_TX;
    rx_flag <= flag_RX;
end Behavioral;
