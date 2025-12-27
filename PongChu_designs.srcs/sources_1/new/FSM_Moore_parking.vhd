library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

entity FSM_Moore_parking is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           a, b : in STD_LOGIC;
           entering, exiting : out STD_LOGIC);
           -- exit is a banned word in VHDL, I hate disparity
end FSM_Moore_parking;

architecture Behavioral of FSM_Moore_parking is

type FMS_state is (idle, enter_0, enter_1, enter_2, done_enter, exit_0, exit_1, exit_2, done_exit);
SIGNAL state_reg, state_next : FMS_state;

begin

-- =============
-- registers
-- =============
    PROCESS (clk, rst)
    BEGIN
        IF rst = '0' then
            state_reg <= idle;
        ELSIF rising_edge(clk) THEN
            state_reg <= state_next;
        END IF;
    END PROCESS;

    PROCESS(state_reg, a, b)
    BEGIN
        -- =============
        -- default values
        -- =============
        state_next <= state_reg;
        exiting <= '0';
        entering <= '0';    
            
        -- =============
        -- next-state logic
        -- =============
        IF state_reg = idle THEN
            IF a = '1' THEN
                state_next <= enter_0;
            ELSIF b = '1' THEN
                state_next <= exit_0;
            END IF;
        ELSIF state_reg = enter_0 THEN
            IF b = '1' THEN 
                state_next <= enter_1;
            END IF;
        ELSIF state_reg = enter_1 THEN
            IF a = '0' THEN 
                state_next <= enter_2;
            END IF;
        ELSIF state_reg = enter_2 THEN
            IF b = '0' THEN 
                state_next <= done_enter;
            END IF;
        ELSIF state_reg = exit_0 THEN
            IF a = '1' THEN 
                state_next <= exit_1;
            END IF;
        ELSIF state_reg = exit_1 THEN
            IF b = '0' THEN 
                state_next <= exit_2;
            END IF;
        ELSIF state_reg = exit_2 THEN
            IF a = '0' THEN 
                state_next <= done_exit;
            END IF;
        ELSIF state_reg = done_exit OR state_reg = done_enter THEN
            state_next <= idle;
        END IF;
        
        -- =============
        -- output logic
        -- =============
        IF state_reg = done_exit THEN
           exiting <= '1';
        ELSIF state_reg = done_enter THEN
           entering <= '1';
        END IF;
            
    END PROCESS;

end Behavioral;
