library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity detection_circuit is 
    Port (	inputs : in std_logic_vector(7 downto 0);
          clk : in std_logic;
          reset : in std_logic;
          cnt_enable : in std_logic;
          x,y,k,z,p : out std_logic
         );
end detection_circuit;

architecture behavioral of detection_circuit is

component cnt_2bit is 
        Port ( clk : in std_logic;
               reset : in std_logic;
               enable : in std_logic;
               count : out std_logic_vector(1 downto 0)
             );
end component;

signal  v,l ,z1: std_logic;
signal out_cnt: std_logic_vector(1 downto 0);
signal cnt_enable_out: std_logic;

-- x mode 1, y mode 2, k mode 3 and z mode 4 (quando trovo tutti zero mi attiva p)

begin

v <= not (inputs(3) or inputs(2) or inputs(1) or inputs(0)); -- se i primi 4 bit sono zero va a 1
l <= not (inputs(0) or inputs(1));                           -- realizza il cicrcuito di detection 
x <= not (l or inputs(0));                                   
y <= l and (not(v));                                        

k <= (inputs(4) or inputs(5) or inputs(6) or inputs(7)) and v;        -- se i primi 4 bit sono 0 e glia ltri no va  1
p <= (not (inputs(4) or inputs(5) or inputs(6) or inputs(7)) and v);  -- se tutti i bit sono 0 va a 1 

cnt_enable_out <= cnt_enable and (not(z1)); 

CNT : cnt_2bit port map(clk,reset,cnt_enable_out, out_cnt);

z1 <= not(out_cnt(1)) and out_cnt(0); -- se il contatore è 2  va a 1

z <= z1;



end behavioral;