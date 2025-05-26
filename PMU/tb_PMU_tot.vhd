library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_PMU_tot is
end tb_PMU_tot;

architecture behavior of tb_PMU_tot is

    -- Component declaration for the PMU (replace with your actual entity name and ports)
    component PMU_tot is
        port (
            clk : in std_logic;
            rst : in std_logic;
            inputs : in std_logic_vector(7 downto 0);
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
    signal inputs       : std_logic_vector(7 downto 0) := (others => '0');      
    signal state_select : std_logic_vector(2 downto 0) := (others => '0');
    signal switchML, switchAL, switchAH, switchMH : std_logic;
    signal isoML, isoAL, isoAH, isoMH : std_logic;
    signal ret1, ret2, ret3 : std_logic;
    signal sel1, sel2 : std_logic;
    constant clk_period : time := 1 ns; 

begin   
    -- Instantiate the PMU
    UUT: PMU_tot
        port map (
            clk => clk,
            rst => rst,
            inputs => inputs,
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

    -- Stimuli process
    stim_proc: process
    begin
        -- Initial reset
        inputs <= "00000000";
        rst <= '1';
        wait for 1 ns;
        rst <= '0';

        -- Test cases can be added here

        wait; -- Wait indefinitely after the test cases
    end process;





end behavior;