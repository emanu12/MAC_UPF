library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; -- we need a conversion to unsigned 

entity TBMUL is 
end TBMUL; 

architecture TEST of TBMUL is

component mul 
	Port (A:	In	std_logic_vector(7 downto 0);
		B:	In	std_logic_vector(7 downto 0);
		M:	Out	std_logic_vector(15 downto 0)
	);
end component; 
  
  signal Ai, Bi: std_logic_vector(7 downto 0); 
  signal Mi : std_logic_vector(15 downto 0);

Begin

  DUT: mul port map (A => Ai,
                     B => Bi,
                     M => Mi);

  STIMULUS1: process
  begin
    Ai <= "00000000";
    Bi <= "00000000";
    wait for 2 ns;
    Ai <= "00110100";
    Bi <= "01110100";
    wait for 2 ns;
    Ai <= "11111111";
    Bi <= "01011011";
    wait for 2 ns;
    Ai <= "11110000";
    Bi <= "00000110";
    wait for 2 ns;
    Ai <= "00000111";
    Bi <= "00111100";
    wait for 2 ns;
    Ai <= "01110000";
    Bi <= "00000110";
    wait for 2 ns;
    Ai <= "01111100";
    Bi <= "11111111";
    wait for 2 ns;
    Ai <= "00011111";
    Bi <= "00110010";
    wait for 2 ns;
    Ai <= "00011100";
    Bi <= "00001110";
    wait for 2 ns;
    Ai <= "00011100";
    Bi <= "01111110";
    wait for 2 ns;
    Ai <= "00001110";
    Bi <= "00010000";
    wait for 2 ns;
    Ai <= "00000001";
    Bi <= "10000000";
    wait for 2 ns;
    Ai <= "11000000";
    Bi <= "01111111";
    wait for 2 ns;
  end process STIMULUS1;

end TEST;

