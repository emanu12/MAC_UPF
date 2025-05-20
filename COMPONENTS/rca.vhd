library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Ripple carry adder
-- This is a simple 16-bit ripple carry adder

entity rca is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0);
        B : in STD_LOGIC_VECTOR(15 downto 0);
        Cin : in STD_LOGIC;
        Sum : out STD_LOGIC_VECTOR(15 downto 0);
        Cout : out STD_LOGIC
    );
end rca;

architecture Behavioral of rca is
    signal carry : STD_LOGIC_VECTOR(15 downto 0);
begin

    carry(0) <= Cin;
    Sum(0) <= A(0) XOR B(0) XOR carry(0);
    carry(1) <= (A(0) AND B(0)) OR (A(0) AND carry(0)) OR (B(0) AND carry(0));

    gen_adders: for i in 1 to 15 generate
        Sum(i) <= A(i) XOR B(i) XOR carry(i);
        carry(i+1) <= (A(i) AND B(i)) OR (A(i) AND carry(i)) OR (B(i) AND carry(i));
    end generate;

    Cout <= carry(16);
end Behavioral;