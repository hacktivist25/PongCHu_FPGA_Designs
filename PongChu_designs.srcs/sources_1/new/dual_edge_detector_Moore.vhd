library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity dual_edge_detector_Moore is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           input_signal : in STD_LOGIC;
           edge_up_tick, edge_down_tick  : out STD_LOGIC);
end dual_edge_detector_Moore;

architecture Behavioral of dual_edge_detector_Moore is

type FSM_state is (zero, edge_up, one, edge_down);
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
                    state_next <= edge_up;
                END IF;
            WHEN edge_up =>
                IF input_signal = '1' then
                    state_next <= one;
                ELSE
                    state_next <= edge_down;
                END IF;
            WHEN one =>
                IF input_signal = '0' then
                    state_next <= edge_down;
                END IF;
            WHEN edge_down =>
                IF input_signal = '1' then
                    state_next <= edge_up;
                ELSE
                    state_next <= zero;
                END IF;
        END CASE;
        
        --=============
        -- OUTPUT
        --=============
        IF state_reg = edge_up THEN
            edge_up_tick <= '1';
        ELSIF state_reg = edge_down THEN
            edge_down_tick <= '1';
        END IF;
    end process;
    

end Behavioral;
