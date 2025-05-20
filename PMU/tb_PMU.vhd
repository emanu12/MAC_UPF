library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity tb_PMU is 
end tb_PMU;

architecture behavior of tb_PMU is


component PMU is
    Port ( inputs : in std_logic_vector(7 downto 0);
           clk : in std_logic;
           reset : in std_logic;
           S_add : out std_logic_vector(2 downto 0);
           stop_add : out std_logic;
           stop_mult: out std_logic
         );
end component;

    
    signal inputs : std_logic_vector(7 downto 0);
    signal clk : std_logic := '1';
    signal reset : std_logic := '0';
    signal S_add : std_logic_vector(2 downto 0);
    signal stop_add : std_logic;
    signal stop_mult: std_logic;
    constant clk_period : time := 1 ns;

begin


    clk_process : process
    begin
        while true loop
            clk <= '1';
            wait for clk_period / 2;
            clk <= '0';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimoli per il test
    stim_proc: process
    begin
        -- Reset iniziale
        inputs <= "00000000";
        reset <= '1';
        wait for 1 ns;
        reset <= '0';

        -- Test case 1: Tutti gli input a 0
        inputs <= "01010000";
        wait for 1 ns;

        -- Test case 2: Input con un bit alto
        inputs <= "11111100";
        wait for 1 ns;

        -- Test case 3: Input con più bit alti
        inputs <= "11111110";
        wait for 1 ns;

        -- Test case 4: Input con tutti i bit alti
        inputs <= "11101011";
        wait for 1 ns;

        inputs <= "00000000"; -- Tutti zero
        wait for 1 ns;
        
        inputs <= "10100000"; -- Tutti zero
        wait for 1 ns;
        
        inputs <= "00000000"; -- Tutti zero
        wait for 3 ns;
        inputs <= "00000000"; -- Tutti zero
        wait for 2 ns;
        inputs <= "00000010"; -- 
        wait for 1 ns;
        inputs <= "00000000"; -- Tutti zero
        wait for 6 ns;
        -- Fine simulazione
        wait;
    end process;

    PBU: PMU 
        port map (
            inputs => inputs,
            clk    => clk,
            reset  => reset,
            S_add  => S_add,
            stop_add => stop_add,
            stop_mult => stop_mult
        );


    end behavior;
