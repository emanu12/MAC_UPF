library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_PMU_power is
end tb_PMU_power;

architecture behavioral of tb_PMU_power is

    -- Component declaration for the PMU power (replace with your actual entity name and ports)
    component PMU_power is
        port (
            clk : in std_logic;
            rst : in std_logic;
            state_select : in std_logic_vector(2 downto 0);
            switchML, switchAL, switchAH, switchMH : out std_logic;
            isoML, isoAL, isoAH, isoMH : out std_logic;
            ret1, ret2, ret3 : out std_logic;
            sel1, sel2 : out std_logic
        );
    end component;

    -- Signals for testbench
    signal clk          : std_logic := '0';
    signal rst          : std_logic := '1';
    signal state_select : std_logic_vector(2 downto 0) := (others => '0');
    signal switchML, switchAL, switchAH, switchMH : std_logic;
    signal isoML, isoAL, isoAH, isoMH : std_logic;
    signal ret1, ret2, ret3 : std_logic;
    signal sel1, sel2 : std_logic;
    constant clk_period : time := 1 ns;


    begin

         -- Clock generation
       clk_process : process
    begin
        while true loop
            clk <= '1';
            wait for clk_period / 2;
            clk <= '0';
            wait for clk_period / 2;
        end loop;
    end process;


    UUT: PMU_power
        port map (
            clk => clk,
            rst => rst,
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
    -- Stimuli process
    stim_proc: process
    begin
        -- Initial reset
        rst <= '1';
        wait for 1 ns;
        rst <= '0';

        -- Test case 1: Set state to RPM
        state_select <= "001"; -- RPM
        wait for 2 ns;

        -- Test case 2: Set state to LPM
        state_select <= "010"; -- LPM
        wait for 2 ns;

        -- Test case 3: Set state to ESM
        state_select <= "011"; -- ESM
        wait for 2 ns;

        -- Test case 4: Set state to FPM
        state_select <= "100"; -- FPM
        wait for 2 ns;

        -- Test case 5: Set state to SLEEP
        state_select <= "000"; -- SLEEP
        wait for 2 ns;

        -- End of simulation
        wait;
    end process;
        
            





end behavioral;