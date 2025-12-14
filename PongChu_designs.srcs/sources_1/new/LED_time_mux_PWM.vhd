----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.12.2025 14:26:33
-- Design Name: 
-- Module Name: LED_time_mux_PWM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity LED_time_mux_PWM is
    Port ( in_3 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_2 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_1 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_0 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           w : in STD_LOGIC_VECTOR(3 DOWNTO 0); -- discrepancy here, I created a modular
           -- PWN with variable w width, but made a fixed width w for this LED :/ 
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0));
end LED_time_mux_PWM;

architecture Behavioral of LED_time_mux_PWM is

COMPONENT N_bit_PWM is
    generic (
          N_bits : integer :=4
    );
    Port ( clk : in STD_LOGIC;
           w : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0); -- duty cycle is w / (2^N)
           rst : in STD_LOGIC;
           output : out STD_LOGIC);
end COMPONENT;

COMPONENT LED_time_mux is
    generic (
           Hz_800 : INTEGER := 62500; -- Hz800 established considering 50MHz clock
           N_bits : INTEGER := 16 -- N_bits established considering ceil(  log2(Hz_800)  ) = 16
    );
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           in_3 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_2 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_1 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           in_0 : in STD_LOGIC_VECTOR(6 DOWNTO 0);
           ena_out : out STD_LOGIC_VECTOR(3 DOWNTO 0);
           sseg_out : out STD_LOGIC_VECTOR(6 DOWNTO 0));
end COMPONENT;

CONSTANT Hz_800_const : INTEGER :=64; -- with this, digit change occur at the same frequency as a cycle for PWM.
-- this simplifies verification.
CONSTANT N_bits_const_LEDtm : INTEGER := 6;
CONSTANT N_bits_const_PWM : INTEGER := 4;
SIGNAL ena_out_LED_tm : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL output_PWM : STD_LOGIC;

begin
LED_tm : LED_time_mux GENERIC MAP(Hz_800 => Hz_800_const, N_bits => N_bits_const_LEDtm) PORT MAP(
    clk => clk,
    rst => rst,
    in_3 => in_3,
    in_2 => in_2,
    in_1 => in_1,
    in_0 => in_0,
    ena_out => ena_out_LED_tm,
    sseg_out => sseg_out
);

PWM : N_bit_PWM GENERIC MAP(N_bits => N_bits_const_PWM) PORT MAP(
    clk => clk,
    w => w,
    rst => rst,
    output => output_PWM
);

process(output_PWM, ena_out_LED_tm)
begin
    IF output_PWM = '1' THEN
        ena_out <= ena_out_LED_tm;
    ELSE
        ena_out <= "1111";
    END IF;
end process;
end Behavioral;
