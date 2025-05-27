library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_PMU_tot is
end tb_PMU_tot;

architecture behavior of tb_PMU_tot is

    -- Component declaration for the PMU (replace with your actual entity name and ports)
    component PMU_tot is
         Port (inputs : in std_logic_vector(7 downto 0);
        clk : in std_logic;
        reset : in std_logic;
        S_add : out std_logic_vector(2 downto 0);
        state_select : in std_logic_vector(2 downto 0);
        switchML,switchAL,switchAH,switchMH : out std_logic;
        isoML,isoAL,isoAH,isoMH : out std_logic;
        ret1,ret2,ret3 : out std_logic;
        sel1,sel2 : out std_logic
         );
    end component;

    -- Signals for testbench
    signal clk          : std_logic := '0';     
    signal reset          : std_logic := '1';
    signal inputs       : std_logic_vector(7 downto 0) := (others => '0');      
    signal state_select : std_logic_vector(2 downto 0) := (others => '0');
    signal S_add        : std_logic_vector(2 downto 0);
    signal switchML, switchAL, switchAH, switchMH : std_logic;
    signal isoML, isoAL, isoAH, isoMH : std_logic;
    signal ret1, ret2, ret3 : std_logic;
    signal sel1, sel2 : std_logic;
    constant clk_period : time := 1 ns; 

begin   
    -- Instantiate the PMU
    UUT: PMU_tot port map (
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

        -- initial reset
        inputs <= "00000000";
        state_select <= "000";
        reset <= '1';
        wait for 1 ns;
        
        --SLEEP MODE
        reset <= '0';
        inputs <= "01010100";
        wait for 3 ns;

        -- RPM MODE
        inputs <= "11111110";
        state_select <= "001";
        wait for 1 ns;
        -- vrca check
        -- mode 1
        inputs <= "11111110";
        wait for 1 ns;
        -- mode 2
        inputs <= "11111100";
        wait for 1 ns;
        -- mode 3
        inputs <= "11110000";
        wait for 1 ns;
        -- stato wait
        inputs <= "00000000"; -- Tutti zero
        wait for 6 ns;
      
        -- LPM MODE
        inputs <= "10100100"; 
        state_select <= "011";
        wait for 3 ns;
        
        -- ESM MODE
        inputs <= "00100100"; 
        state_select <= "010";
        wait for 1 ns;
         -- vrca check
        -- mode 1
        inputs <= "11111110";
        wait for 1 ns;
        -- mode 2
        inputs <= "11111100";
        wait for 1 ns;
        -- mode 3
        inputs <= "11110000";
        wait for 1 ns;
        -- stato wait
        inputs <= "00000000"; -- Tutti zero
        wait for 6 ns;
        -- FPM MODE
        inputs <= "00111100";
        state_select <= "110";
        wait for 3 ns;
        wait;
    end process;



end behavior;