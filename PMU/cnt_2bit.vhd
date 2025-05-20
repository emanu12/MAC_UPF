library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cnt_2bit is
    Port (
        clk    : in  STD_LOGIC;
        reset  : in  STD_LOGIC;
        enable : in  STD_LOGIC;
        count  : out UNSIGNED(1 downto 0)
    );
end cnt_2bit;

architecture Behavioral of cnt_2bit is
    signal cnt_reg : UNSIGNED(1 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            cnt_reg <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                cnt_reg <= cnt_reg + 1;
            else
                cnt_reg <= cnt_reg; 
            end if;
        end if;
    end process;

    count <= cnt_reg;
end Behavioral;