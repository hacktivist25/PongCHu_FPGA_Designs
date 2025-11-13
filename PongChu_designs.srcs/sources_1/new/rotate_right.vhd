----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2025 13:19:44
-- Design Name: 
-- Module Name: rotate_right - Behavioral
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

entity rotate_right is
    generic (
        N_bits : integer :=8
    );
    Port ( input : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0)
    );
end rotate_right;

architecture Behavioral of rotate_right is

begin
    output(N_bits-2 DOWNTO 0) <= input(N_bits-1 DOWNTO 1);
    output(N_bits-1) <=  input(0);
end Behavioral;