----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2025 14:54:19
-- Design Name: 
-- Module Name: shifting_circuit_tb - Behavioral
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

entity shifting_circuit_tb is
--  Port ( );
end shifting_circuit_tb;

architecture Behavioral of shifting_circuit_tb is

COMPONENT shifting_circuit is
generic (
    N_bits : integer :=8
    );
    Port ( input : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
           lr : in STD_LOGIC; -- -- 0 = right shift, 1 = left shift
           output : out STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0));
end COMPONENT;

CONSTANT N: integer:=8;

SIGNAL input_sig : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL lr_sig : STD_LOGIC;
SIGNAL output_sig : STD_LOGIC_VECTOR(N-1 DOWNTO 0);

begin
UUT : shifting_circuit GENERIC MAP (N_bits => N) PORT MAP (input => input_sig, lr => lr_sig, output => output_sig);

vector_test : process
    begin
    
    input_sig <= "10010011";
    lr_sig <= '0';
    WAIT FOR 10ns;
    
    lr_sig <= '1';
    WAIT FOR 10ns;
    WAIT;
    
    end process;

end Behavioral;
