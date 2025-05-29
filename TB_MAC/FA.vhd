library IEEE;
use IEEE.std_logic_1164.all; 
--use WORK.constants.all; 

entity FA is
    port (
        A, B, Cin : in std_logic;  
		Sum, Cout : out std_logic  
    );
end FA;

architecture behavior of FA is
signal Ain, Bin : std_logic;
begin
 Sum  <= A xor B xor Cin;
 Cout <= (A and B) or (A and Cin) or (B and Cin);
end behavior;