----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2025 13:25:48
-- Design Name: 
-- Module Name: rotate_left - Behavioral
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

entity rotate_left is
    generic (
        N_bits : integer :=8
    );
    Port ( input : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0)
    );
end rotate_left;

architecture Behavioral of rotate_left is

begin
    output(N_bits-1 DOWNTO 1) <= input(N_bits-2 DOWNTO 0);
    output(0) <= input(N_bits-1);
end Behavioral;
