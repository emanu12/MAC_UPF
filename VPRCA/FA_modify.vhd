library IEEE;
use IEEE.std_logic_1164.all; 
--use WORK.constants.all; 

entity FA_modify is
    port (
        A, B, Cin : in std_logic;  
        S : in std_logic;
		Sum, Cout : out std_logic  
    );
end FA_modify;

architecture behavior of FA_modify is
signal Ain, Bin : std_logic;
begin
Ain <= A and S;
Bin <= B and S;
 Sum  <= Ain xor Bin xor Cin;
 Cout <= (Ain and Bin) or (Ain and Cin) or (Bin and Cin);
end behavior;