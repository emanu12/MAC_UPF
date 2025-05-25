library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity mul is 
	Port (	A:	In	std_logic_vector(7 downto 0);
		B:	In	std_logic_vector(7 downto 0);
		M:	Out	std_logic_vector(15 downto 0)
	);
end mul; 

architecture BEHAVIORAL of mul is

begin

process(A, B)
  begin
    M <= std_logic_vector(unsigned(A) * unsigned(B));
  end process;

end BEHAVIORAL;
