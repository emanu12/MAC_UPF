library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
    port(
        inputs, weights : in std_logic_vector(7 downto 0);
        clk: in std_logic;
        reset: in std_logic;
         S_add : in std_logic_vector(2 downto 0);
        switchML,switchAL,switchAH,switchMH : in std_logic;
        isoML,isoAL,isoAH,isoMH : in std_logic;
        ret1,ret2,ret3 : in std_logic;
        sel1,sel2 : in std_logic;
        outputs : buffer std_logic_vector(15 downto 0)

    );
end datapath;

architecture behavioral of datapath is

component multiplier is
Generic (
        N : integer := 8 -- Width of the input signals
    );
    Port (
        a : in  STD_LOGIC_VECTOR(N-1 downto 0); 
        b : in  STD_LOGIC_VECTOR(N-1 downto 0); 
        result : out  STD_LOGIC_VECTOR(N*2 -1 downto 0) 
    );
end component;


component rca is
    Port (
        A : in STD_LOGIC_VECTOR(15 downto 0);
        B : in STD_LOGIC_VECTOR(15 downto 0);
        Cin : in STD_LOGIC;
        Sum : out STD_LOGIC_VECTOR(15 downto 0);
        Cout : out STD_LOGIC
    );
end component;  


component registerN is
    generic (
        N : integer := 8
    );
    port (
        clk     : in  STD_LOGIC;
        reset   : in  STD_LOGIC;
        d       : in  STD_LOGIC_VECTOR(N-1 downto 0);
        q       : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end component;

component mux is 
 generic (
        N : integer := 8 
    );
    Port (
        a : in STD_LOGIC_VECTOR(N-1 downto 0);  
        b : in STD_LOGIC_VECTOR(N-1 downto 0);  
        sel : in STD_LOGIC; 
        y : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end component;

component precision_ripple_carry_adder is
PORT(  A,B: in std_logic_vector(15 downto 0);
		Cin : in std_logic;
		rst : in std_logic;
		clk :in std_logic;
		sign_select : in std_logic_vector(2 downto 0);
		S_out : out std_logic_vector(15 downto 0);
		C_out : out std_logic
		); 
end component;

signal inputs_reg, weights_reg : std_logic_vector(7 downto 0);
signal out_low_multiplier : std_logic_vector(15 downto 0);
signal out_high_multiplier : std_logic_vector(15 downto 0);
signal in_vprca : std_logic_vector(15 downto 0);
signal out_vprca : std_logic_vector(15 downto 0);
signal in_rca : std_logic_vector(15 downto 0);  
signal out_rca : std_logic_vector(15 downto 0);
signal out_sum : std_logic_vector(15 downto 0);
signal rst_delayed : std_logic;
signal in_rca_mux, in_vprca_mux : std_logic_vector(15 downto 0);

begin 


-- reg iniziali 

REG_INPUTS: registerN
    generic map (
        N => 8
    )
    port map (
        clk => clk,
        reset => reset,
        d => inputs,
        q => inputs_reg
    );
REG_WEIGHTS: registerN
    generic map (
        N => 8
    )
    port map (
        clk => clk,
        reset => reset,
        d => weights,
        q => weights_reg
    );

-- Low multiplier
LOW_MULTIPLIER: multiplier
    generic map (
        N => 8
    )
    port map (
        a => inputs_reg,
        b => weights_reg,
        result => out_low_multiplier
    );

-- High multiplier
HIGH_MULTIPLIER: multiplier
    generic map (
        N => 8
    )
    port map (
        a => inputs_reg,
        b => weights_reg,
        result => out_high_multiplier
    );

    -- Mux low multiplier
MUX_LOW: mux 
    generic map (
        N => 16
    )
    port map (
        a => out_low_multiplier,
        b => out_high_multiplier, 
        sel => sel1,
        y => in_vprca_mux
    );

    -- Mux high multiplier
MUX_HIGH: mux 
    generic map (
        N => 16
    )
    port map (
        a => out_low_multiplier,
        b => out_high_multiplier, 
        sel => sel1,
        y =>in_rca_mux
    );

-- reg in mezzo
REG_L: registerN
    generic map (
        N => 16
    )
    port map (
        clk => clk,
        reset => reset,
        d => in_rca_mux,
        q => in_rca
    );


REG_H: registerN
    generic map (
        N => 16
    )
    port map (
        clk => clk,
        reset => reset,
        d => in_vprca_mux,
        q => in_vprca
    );


-- VPRCA
VPRCA: precision_ripple_carry_adder
    port map (
        A => in_vprca,
        B => outputs,
        Cin => '0', 
        rst => reset,
        clk => clk,
        sign_select => S_add, 
        S_out => out_vprca,
        C_out => open 
    );

-- RCA
RCA_SUM: rca
    port map (
        A => in_rca,
        B => outputs, 
        Cin => '0', 
        Sum => out_rca, 
        Cout => open 
    );

-- MUX SUM

MUX_SUM: mux 
    generic map (
        N => 16
    )
    port map (
        a => out_vprca,
        b => out_rca, 
        sel => sel2,
        y => out_sum
    );

--register output
REG_OUTPUT: registerN
    generic map (
        N =>16
    )
    port map (
        clk => clk,
        reset => rst_delayed,
        d => out_sum, 
        q => outputs
    );

    delayed_reset: process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                rst_delayed <= '1';
            else
                rst_delayed <= '0';
            end if;
        end if;
    end process;

end behavioral;