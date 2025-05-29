library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MAC_UPF is
    port(
        inputs, weights : in std_logic_vector(7 downto 0);
        clk: in std_logic;
        reset: in std_logic;
        state_select : in std_logic_vector(2 downto 0);
        outputs : buffer std_logic_vector(15 downto 0)
    );
end MAC_UPF;

architecture behavioral of MAC_UPF is

    component PMU_tot is
        Port (
            inputs : in std_logic_vector(7 downto 0);
            clk : in std_logic;
            reset : in std_logic;
            S_add : out std_logic_vector(2 downto 0);
            state_select : in std_logic_vector(2 downto 0);
            switchML, switchAL, switchAH, switchMH : out std_logic;
            isoML, isoAL, isoAH, isoMH : out std_logic;
            ret1, ret2, ret3 : out std_logic;
            sel1, sel2 : out std_logic
        );
    end component;

    component datapath is
        port(
            inputs, weights : in std_logic_vector(7 downto 0);
            clk: in std_logic;
            reset: in std_logic;
            S_add : in std_logic_vector(2 downto 0);
            switchML, switchAL, switchAH, switchMH : in std_logic;
            isoML, isoAL, isoAH, isoMH : in std_logic;
            ret1, ret2, ret3 : in std_logic;
            sel1, sel2 : in std_logic;
            outputs : buffer std_logic_vector(15 downto 0)
        );
    end component;

    signal S_add : std_logic_vector(2 downto 0);
    signal switchML, switchAL, switchAH, switchMH : std_logic;  
    signal isoML, isoAL, isoAH, isoMH : std_logic;
    signal ret1, ret2, ret3 : std_logic;
    signal sel1, sel2 : std_logic;

begin




-- PMU
PMU_inst : PMU_tot
    port map (
        inputs => inputs,
        clk => clk,
        reset => reset,
        S_add => S_add,
        state_select => state_select,
        switchML => switchML,
        switchAL => switchAL,
        switchAH => switchAH,
        switchMH => switchMH,
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


-- Datapath

DP_inst : datapath
    port map (
        inputs => inputs,
        weights => weights,
        clk => clk,
        reset => reset,
        S_add => S_add,
        switchML => switchML,
        switchAL => switchAL,
        switchAH => switchAH,
        switchMH => switchMH,
        isoML => isoML,
        isoAL => isoAL,
        isoAH => isoAH,
        isoMH => isoMH,
        ret1 => ret1,
        ret2 => ret2,
        ret3 => ret3,
        sel1 => sel1,
        sel2 => sel2,
        outputs => outputs
    );






end behavioral;