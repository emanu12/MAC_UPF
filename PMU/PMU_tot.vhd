library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;


entity PMU_tot is 
    Port (inputs : in std_logic_vector(7 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        S_add : out std_logic_vector(2 downto 0);
        select_state : in std_logic_vector(2 downto 0);
        switchML,switchAL,switchAH,switchMH : out std_logic;
        isoML,isoAL,isoAH,isoMH : out std_logic;
        ret1,ret2,ret3 : out std_logic;
        sel1,sel2 : out std_logic
         );
end PMU_tot;


architecture behavioral of PMU_tot is

    component PMU_logic is 
        Port (inputs : in std_logic_vector(7 downto 0);
            clk : in std_logic;
            reset : in std_logic;
            S_add : out std_logic_vector(2 downto 0);
            switchAL : out std_logic;
            switchML, switchMH : out std_logic
          );
    end component;


    component PMU_power is
        port (
            clk : in std_logic;
            rst : in std_logic;
            select_state : in std_logic_vector(2 downto 0);
            switchML,switchAL,switchAH,switchMH : out std_logic;
            isoML,isoAL,isoAH,isoMH : out std_logic;
            ret1,ret2,ret3 : out std_logic;
            sel1,sel2 : out std_logic
        );
    end component;

    signal out_logic_switchML, out_logic_switchAL, out_logic_switchMH : std_logic;
    signal out_power_switchML, out_power_switchAL, out_power_switchMH : std_logic;
    
    begin
    PMULOGIC : PMU_logic
        port map (
            inputs => inputs,
            clk => clk,
            reset => reset,
            S_add => S_add,
            switchAL => out_logic_switchAL,
            switchML => out_logic_switchML,
            switchMH => out_logic_switchMH
        );    

    PMUPOWER : PMU_power
        port map (
            clk => clk,
            rst => reset,
            select_state => select_state,
            switchML => out_power_switchML,
            switchAL => out_power_switchAL,
            switchAH => switchAH,  -- Assuming these are not used in this context
            switchMH => out_power_switchMH,
            isoML => isoML,
            isoAL => isoAL,
            isoAH => isoAH,
            isoMH => isoMH,
            ret1 => ret1,
            ret2 => ret2,
            ret3 => ret3,
            sel1 => sel1,
            sel2 => sel2
        );
    switchML <= out_logic_switchML or out_power_switchML;
    switchAL <= out_logic_switchAL or out_power_switchAL;
    


    end behavioral;