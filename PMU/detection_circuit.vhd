library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity detection_circuit is 
    Port (
        inputs      : in std_logic_vector(7 downto 0);
        clk         : in std_logic;
        reset       : in std_logic;
        cnt_enable  : in std_logic;
        x, y, k, z, p : out std_logic
    );
end detection_circuit;

architecture behavioral of detection_circuit is

    component cnt_2bit is 
        Port (
            clk    : in std_logic;
            reset  : in std_logic;
            enable : in std_logic;
            count  : out unsigned(1 downto 0)
        );
    end component;

    signal v, l, z1 : std_logic;
    signal out_cnt : unsigned(1 downto 0);
    signal cnt_enable_out : std_logic;

begin

    -- Detection logic
    v <= not (inputs(3) or inputs(2) or inputs(1) or inputs(0));   -- 1 se i primi 4 bit sono zero
    l <= not (inputs(0) or inputs(1));                             -- detection di 0 e 1

    x <= not (l or inputs(0));                                    
    y <= l and (not v);                                           

    k <= (inputs(4) or inputs(5) or inputs(6) or inputs(7)) and v;        -- primi 4 bit zero, altri no
    p <= (not(inputs(4) or inputs(5) or inputs(6) or inputs(7))) and v;   -- tutti i bit zero

    -- Contatore abilitato solo se cnt_enable è 1 e z1 è 0
    cnt_enable_out <= cnt_enable and not(z1); 

    -- Istanziazione contatore
    CNT : cnt_2bit port map(
        clk     => clk,
        reset   => reset,
        enable  => cnt_enable_out,
        count   => out_cnt
    );

    -- z1 = 1 se il contatore vale 2 (10)
    z1 <= not(out_cnt(1)) and out_cnt(0);
    z  <= z1;

end behavioral;
