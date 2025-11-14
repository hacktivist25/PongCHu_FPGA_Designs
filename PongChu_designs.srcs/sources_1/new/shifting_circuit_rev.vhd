----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.11.2025 13:59:52
-- Design Name: 
-- Module Name: shifting_circuit - Behavioral
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

entity shifting_circuit_rev is
generic (
    N_bits : integer :=8
    );
    Port ( input : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
           lr : in STD_LOGIC; -- 0 = right shift, 1 = left shift
           output : out STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0));
end shifting_circuit_rev;


architecture Behavioral of shifting_circuit_rev is

COMPONENT rotate_right is
    generic (
        N_bits : integer :=8
    );
    Port ( input : in STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
           output : out STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0)
    );
end COMPONENT;

SIGNAL input_signal : STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);
SIGNAL out_right_shifter: STD_LOGIC_VECTOR(N_bits-1 DOWNTO 0);

begin

Rt_right : rotate_right GENERIC MAP (N_bits => N_bits) PORT MAP (input => input_signal, output => out_right_shifter);

process (lr, input, out_right_shifter)
    begin
    IF lr = '1' THEN -- left shift : reverse input and output
        for i in 0 to N_bits-1 loop
            input_signal(i) <= input(N_bits - 1 - i);
            output(i) <= out_right_shifter(N_bits - 1 - i);
        end loop;
    ELSE    
        input_signal(N_bits - 1 DOWNTO 0) <= input(N_bits - 1 DOWNTO 0);
        output(N_bits - 1 DOWNTO 0) <= out_right_shifter(N_bits - 1 DOWNTO 0);
    END IF;
    END process;

end Behavioral;
