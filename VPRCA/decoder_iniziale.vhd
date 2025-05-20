
library IEEE;
use IEEE.std_logic_1164.all; 
--use WORK.constants.all; 

entity decoder is 
PORT(S0,S1,S2 :in std_logic;
	cntr : out std_logic_vector(7 downto 0)); 
End decoder;

architecture behavior of decoder is

begin 
	cntr(0) <= not(S0);
	cntr(1) <= not((S1 or S2) and S0);
	cntr(2) <= not(S0 and((not(S1) and S2) or (S2 and S1)));
	cntr(3) <= not(S0 and((not(S1) and S2) or (S2 and S1)));  -- Explicitly defining cntr(3)
	cntr(4) <= not(S2 and S1 and S0);
	cntr(5) <= not(S2 and S1 and S0);
	cntr(6) <= not(S2 and S1 and S0);
	cntr(7) <= not(S2 and S1 and S0);

end behavior;