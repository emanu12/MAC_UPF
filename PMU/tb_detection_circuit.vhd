-- filepath: c:\Users\emanu\Documents\POLITO\LOWPOWER\LowPower3_2025\LAB2\es3\datapath\tb_detection_circuit.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_detection_circuit is
-- Test bench non ha porte
end tb_detection_circuit;

architecture Behavioral of tb_detection_circuit is

    -- Component declaration per il detection circuit
    component detection_circuit
        Port (
            inputs : in  std_logic_vector(7 downto 0);
            clk    : in  std_logic;
            reset  : in  std_logic;
            cnt_enable : in  std_logic;
            x, y, k, z : out std_logic
        );
    end component;

    -- Segnali per collegare il test bench al circuito
    signal clk    : std_logic := '1';
    signal reset  : std_logic := '0';
    signal inputs : std_logic_vector(7 downto 0) := (others => '0');
    signal x, y, k, z : std_logic;

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    -- Instanziazione del detection circuit
    uut: detection_circuit
        Port map (
            inputs => inputs,
            clk    => clk,
            reset  => reset,
            x      => x,
            y      => y,
            k      => k,
            z      => z
        );

    -- Processo per generare il clock
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

    -- Stimoli per il test
    stim_proc: process
    begin
        -- Reset iniziale
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        -- Test case 1: Tutti gli input a 0
        inputs <= "01010000";
        wait for 10 ns;

        -- Test case 2: Input con un bit alto
        inputs <= "11111100";
        wait for 10 ns;

        -- Test case 3: Input con più bit alti
        inputs <= "11111110";
        wait for 10 ns;

        -- Test case 4: Input con tutti i bit alti
        inputs <= "11101011";
        wait for 10 ns;

        inputs <= "00000000"; -- Tutti zero
        wait for 10 ns;
        
        inputs <= "00000000"; -- Tutti zero
        wait for 10 ns;
        
        inputs <= "00000000"; -- Tutti zero
        wait for 10 ns;

        
        inputs <= "01010010"; -- Tutti zero
        wait for 10 ns;
        -- Fine simulazione
        wait;
    end process;

end Behavioral;