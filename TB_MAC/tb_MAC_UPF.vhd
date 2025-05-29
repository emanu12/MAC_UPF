library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity tb_MAC_UPF is
end tb_MAC_UPF;

architecture Behavioral of tb_MAC_UPF is

    component MAC_UPF is
        port(
            inputs, weights : in std_logic_vector(7 downto 0);
            clk: in std_logic;
            reset: in std_logic;
            state_select : in std_logic_vector(2 downto 0);
            outputs : buffer std_logic_vector(15 downto 0)
        );
    end component;

    signal inputs, weights : std_logic_vector(7 downto 0);
    signal clk : std_logic := '0';
    signal reset : std_logic := '1';
    signal state_select : std_logic_vector(2 downto 0) := "000";
    signal outputs : std_logic_vector(15 downto 0);
    signal clk_period : time := 1 ns;

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

    -- Stimuli process
    stim_proc: process
    begin 

        -- initial reset
        inputs <= "00000000";
        weights <= "00000000";
        state_select <= "000";
        reset <= '1';
        wait for 1 ns;
        
        --SLEEP MODE
        reset <= '0';
        inputs <= "01010100";
        weights <= "00000000";
        wait for 3 ns;

        -- RPM MODE  2x2
        inputs <= "00000010"; 
        weights <= "00000010";
        state_select <= "001";
        wait for 1 ns;
        -- vrca check
        -- mode 1
        inputs <= "00000010";
        weights <= "00000010";
        wait for 1 ns;
        -- mode 2
        inputs <= "00000010";
        weights <= "00000010";
        wait for 1 ns;
        -- mode 3
        inputs <= "00000010";
        weights <= "00000010";
        wait for 1 ns;
        -- stato wait
        inputs <= "00000000"; -- Tutti zero
        wait for 6 ns;
      
        -- LPM MODE
         inputs <= "00000010";
        weights <= "00000010";
        state_select <= "011";
        wait for 3 ns;
        
        -- ESM MODE
        inputs <= "00000010";
        weights <= "00000010";
        state_select <= "010";
        wait for 1 ns;
         -- vrca check
        -- mode 1
        inputs <= "00000010";
        weights <= "00000010";
        wait for 1 ns;
        -- mode 2
        inputs <= "00000010";
        weights <= "00000010";
        wait for 1 ns;
        -- mode 3
        inputs <= "00000010";
        weights <= "00000010";
        wait for 1 ns;
        -- stato wait
        inputs <= "00000000"; -- Tutti zero
        wait for 6 ns;
        -- FPM MODE
        inputs <= "00000010";
        weights <= "00000010";
        state_select <= "110";
        wait for 3 ns;
        wait;
    end process;

MAC_UPF_inst : MAC_UPF
        port map (
            inputs => inputs,
            weights => weights,
            clk => clk,
            reset => reset,
            state_select => state_select,
            outputs => outputs
        );




end Behavioral;
    