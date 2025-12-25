library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity dual_edge_detector_Mealy is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           edge_up_tick, edge_down_tick : out STD_LOGIC);
end dual_edge_detector_Mealy;

architecture Behavioral of dual_edge_detector_Mealy is

type FSM_state is (zero, one);
SIGNAL state_reg, state_next : FSM_state;

begin
process(clk, rst)
    begin
        IF rising_edge(clk) THEN
            IF rst = '0' THEN
                state_reg <= zero;
            ELSE
                state_reg <= state_next;
            END IF;
        END IF;
    end process;
    
    process(input_signal, state_reg)
    begin
        -- default value
        state_next <= state_reg;
        edge_up_tick <= '0';
        edge_down_tick <= '0';
        
        --=============
        -- NEXT STATE
        --=============
        CASE state_reg is
            WHEN zero => 
                IF input_signal = '1' then
                    state_next <= one;
                END IF;
            WHEN one =>
                IF input_signal = '0' then
                    state_next <= zero;
                END IF;
        END CASE;
        
        --=============
        -- OUTPUT
        --=============
        IF state_reg = zero THEN
            IF input_signal = '1' THEN
               edge_up_tick <= '1';
            END IF;
        ELSIF state_reg = one THEN
            IF input_signal = '0' THEN
                edge_down_tick <= '1';
            END IF;
        END IF;
    end process;

end Behavioral;
