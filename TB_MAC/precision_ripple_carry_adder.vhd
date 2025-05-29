
library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
--use WORK.constants.all; -- libreria WORK user-defined

entity precision_ripple_carry_adder is 
PORT(  A,B: in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		rst : in std_logic;
		clk :in std_logic;
		sign_select : in std_logic_vector(2 downto 0);
		S_out : out std_logic_vector(15 downto 0);
		C_out : out std_logic
		); 
end precision_ripple_carry_adder;


architecture behavior of precision_ripple_carry_adder is 

component FA_modify is 
    port (
        A, B, Cin : in std_logic;  
        S : in std_logic;
		Sum, Cout : out std_logic  
    );
end component;

component decoder is 
PORT(S0,S1,S2 :in std_logic;
		cntr : out std_logic_vector(7 downto 0)); 
end component;

component FA is 
port (
        A, B, Cin : in std_logic;  
		Sum, Cout : out std_logic  
    );
end component;

signal carry : std_logic_vector(16 downto 0);
signal out_decoder : std_logic_vector(7 downto 0);
signal S : std_logic_vector(15 downto 0);
signal cout : std_logic;

begin


carry(0) <= Cin;
Cout <= carry(16);

DEC : decoder port map( S0	=> sign_select(0),S1 => sign_select(1),S2 => sign_select(2), cntr => out_decoder);

Gen_FAi : for i in 0 to 7 generate 
begin 
	FAI : FA_modify port map (A => A(i) , B => B(i),Cin => carry(i), S => out_decoder(i), Sum => S_out(i),Cout => carry(i+1));  
end generate;

Gen_FAi2 : for i in 8 to 15 generate
begin
	FAI_normali : FA port map (A => A(i) , B => B(i), Cin => carry(i), Sum => S_out(i),Cout => carry(i+1));

end generate;

end behavior;
