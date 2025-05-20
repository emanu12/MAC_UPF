library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register is
    generic (
        N : integer := 8 
    );
    Port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        enable  : in  STD_LOGIC;
        d       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        q       : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end register;

architecture Behavioral of register is
begin
    process(clk)
    begin
        if reset = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                q <= d;
            end if;
        end if;
    end process;

end Behavioral;