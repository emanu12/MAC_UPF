library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multiplier is
    Generic (
        N : integer := 8 -- Width of the input signals
    );
    Port (
        a : in  STD_LOGIC_VECTOR(N-1 downto 0); 
        b : in  STD_LOGIC_VECTOR(N-1 downto 0); 
        result : out  STD_LOGIC_VECTOR(N*2 -1 downto 0) 
    );
end multiplier;

architecture Behavioral of multiplier is
begin

    result <= std_logic_vector(signed(a) * signed(b));

end Behavioral;