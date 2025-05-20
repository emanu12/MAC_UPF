library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    generic (
        N : integer := 8 
    );
    Port (
        a : in STD_LOGIC_VECTOR(N-1 downto 0);  
        b : in STD_LOGIC_VECTOR(N-1 downto 0);  
        sel : in STD_LOGIC; 
        y : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end mux;

architecture Behavioral of mux is
begin
    process(a, b, sel)
    begin
        if sel = '0' then
            y <= a;
        else
            y <= b;
        end if;
    end process;
end Behavioral;