library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity PMU_power is
    port (
        clk : in std_logic;
        rst : in std_logic;
        state_select : in std_logic_vector(2 downto 0);
        switchML,switchAL,switchAH,switchMH : out std_logic;
        isoML,isoAL,isoAH,isoMH : out std_logic;
        ret1,ret2,ret3 : out std_logic;
        sel1,sel2 : out std_logic
    );
end PMU_power;


architecture behavioral of PMU_power is
type main_state is (
  SLEEP, --sleep mode
  RPM,  -- low power multiplier and low power vprca 
  LPM,  -- low power multiplier and high speed rca
  ESM, -- high speed multiplier and low power vprca
  FPM  -- high speed multiplier and high speed rca
);

ATTRIBUTE enum_encoding : string;
ATTRIBUTE enum_encoding OF main_state : TYPE IS "000 001 011 010 110";
signal current_state, next_state : main_state;
signal reset: std_logic;

begin

  UPDATE_STATE : process(clk,rst)
  begin 
      if rst = '1' then
          current_state <= SLEEP;
      elsif rising_edge(clk) then
          current_state <=  next_state;
      end if;
  end process;


  NEXT_STATES: process (current_state,state_select)
  
  begin 
  case current_state is
    when SLEEP =>
      if state_select = "000" then
                next_state <= SLEEP;
            elsif state_select = "001" then
                next_state <= RPM;
            elsif state_select = "010" then 
                next_state <= LPM;
            elsif state_select = "011" then 
                next_state <= ESM;
            elsif state_select = "110" then
                next_state <= FPM;
            else
                next_state <= SLEEP; 
            end if;
        when RPM =>
            if state_select = "000" then
                next_state <= SLEEP;
            elsif state_select = "001" then
                next_state <= RPM;
            elsif state_select = "010" then 
                next_state <= LPM;
            elsif state_select = "011" then 
                next_state <= ESM;
            elsif state_select = "110" then
                next_state <= FPM;
            else
                next_state <= SLEEP; 
            end if;
        when LPM =>
            if state_select = "000" then
                next_state <= SLEEP;
            elsif state_select = "001" then
                next_state <= RPM;
            elsif state_select = "010" then 
                next_state <= LPM;
            elsif state_select = "011" then 
                next_state <= ESM;
            elsif state_select = "110" then
                next_state <= FPM;
            else
                next_state <= SLEEP; 
            end if;
        when ESM =>
            if state_select = "000" then
                next_state <= SLEEP;
            elsif state_select = "001" then
                next_state <= RPM;
            elsif state_select = "010" then 
                next_state <= LPM;
            elsif state_select = "011" then 
                next_state <= ESM;
            elsif state_select = "110" then
                next_state <= FPM;
            else
                next_state <= SLEEP; 
            end if;
        when FPM =>
            if state_select = "000" then
                next_state <= SLEEP;
            elsif state_select = "001" then
                next_state <= RPM;
            elsif state_select = "010" then 
                next_state <= LPM;
            elsif state_select = "011" then 
                next_state <= ESM;
            elsif state_select = "110" then
                next_state <= FPM;
            else
                next_state <= SLEEP; 
            end if;
      
    when others =>
            next_state <= SLEEP; -- default case          
    end case;
  end process;



  OUTPUTS: process (current_state)
  begin     
    switchML <= '1';  -- spenti 
    switchAL <= '1';
    switchAH <= '1';
    switchMH <= '1';
    isoML <= '0';  -- isolati
    isoAL <= '0';
    isoAH <= '0';
    isoMH <= '0';  
    ret1 <= '1';  -- trasparenti
    ret2 <= '1';
    ret3 <= '1';
  case current_state is 
    when SLEEP =>
        ret1 <= '0';
        ret2 <= '0';
        ret3 <= '0';
        sel1 <= '0';
        sel2 <= '0';
    when RPM =>
        switchML <= '0';
        switchAL <= '0';
        isoML <= '1';
        isoAL <= '1';
        sel1 <= '0';  -- prendo parte low sopra
        sel2 <= '0';
    when LPM =>
        switchML <= '0';
        switchAH <= '0';
        isoML <= '1';
        isoAH <= '1';
        sel1 <= '0';  -- prendo parte high sotto
        sel2 <= '1';
    when ESM =>
        switchAL <= '0';
        switchMH <= '0';
        isoAL <= '1';
        isoMH <= '1';
        sel1 <= '1';
        sel2 <= '0';
    when FPM =>
      -- Assuming FPM has the same outputs as ESM 
      switchAH <= '0'; 
      switchMH <= '0'; 
      isoAH <= 	'1'; 
      isoMH <= 	'1';  
      sel1 <= '1';
      sel2 <= '1';
    when others =>
        reset <= '1';
end case;
  end process;








end behavioral;