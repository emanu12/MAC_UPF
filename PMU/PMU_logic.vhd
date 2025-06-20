library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity PMU_logic is 
    Port (	inputs : in std_logic_vector(7 downto 0);
            clk : in std_logic;
            enable : in std_logic;
           reset : in std_logic;
           S_add : out std_logic_vector(2 downto 0);
           switchAL :out  std_logic;
           switchML, switchMH :out  std_logic
         );
end PMU_logic;

architecture behavioral of PMU_logic is

component detection_circuit is 
        Port (	inputs : in std_logic_vector(7 downto 0);
              clk : in std_logic;
              reset : in std_logic;
              cnt_enable : in std_logic;
               x,y,k,z,p : out std_logic
             );
end component;



  type type_state is (
    S0, -- mode 0
    S1,  -- mode 1
    S2, -- mode 2
    S3, --  mode 3 
    S4, --  mode 4
    S5  -- trovato uno zero  
);

ATTRIBUTE enum_encoding : string;
ATTRIBUTE enum_encoding OF type_state : TYPE IS "000 001 011 010 110 100 ";
signal current_state, next_state : type_state;
signal reset_cnt, cnt_enable : std_logic;
signal x,y,k,z,p : std_logic;
signal S_add_delay : std_logic_vector(2 downto 0);
signal switchAL_delay, switchML_delay, switchMH_delay : std_logic;

begin

  UPDATE_STATE : process(clk,reset,enable)
  begin 
      if reset = '1' or enable = '0' then
          current_state <= S0;
      elsif rising_edge(clk) then
          current_state <= next_state;
      end if;
  end process;



NEXT_STATES: process (current_state,x,y,z,k,p)

begin
case current_state is
  when S0 =>
        if x = '1' then
            next_state <= S1;
        elsif y = '1' then
            next_state <= S2;
        elsif k = '1' then
            next_state <= S3;
        elsif p = '1' then    
            next_state <= S5;
        else
            next_state <= S0;
        end if;
  when S1 =>
        if x = '1' then
          next_state <= S1;
      elsif y = '1' then
          next_state <= S2;
      elsif k = '1' then
          next_state <= S3;
      elsif p = '1' then    
          next_state <= S5;
      else
          next_state <= S0;
      end if;
when S2 =>
        if x = '1' then
          next_state <= S1;
      elsif y = '1' then
          next_state <= S2;
      elsif k = '1' then
          next_state <= S3;
      elsif p = '1' then    
          next_state <= S5;
      else
          next_state <= S0;
      end if;
when S3 =>
      if x = '1' then
        next_state <= S1;
      elsif y = '1' then
        next_state <= S2;
      elsif k = '1' then
        next_state <= S3;
      elsif p = '1' then
        next_state <= S5;
      else
        next_state <= S0;
      end if;  
when S4 =>    
      if x = '1' then
        next_state <= S1;
      elsif y = '1' then
        next_state <= S2;
      elsif k = '1' then
        next_state <= S3;
      elsif z = '1' and p = '1' then    
        next_state <= S4;  
      else
        next_state <= S0;
      end if;
  when S5 =>    
      if x = '1' then
        next_state <= S1;
      elsif y = '1' then
        next_state <= S2;
      elsif k = '1' then
        next_state <= S3;
      elsif z = '1' and p = '1' then    
      next_state <= S4;
      elsif p = '1' and z = '0' then    
      next_state <= S5;
      else
        next_state <= S0;
      end if;
  when others =>
   next_state <= S0;
end case;

end process;



OUTPUT: process (current_state)
begin
  S_add_delay <= "000";
  switchAL_delay <= '0';
  switchML_delay <= '0';
  switchMH_delay <= '0';
case current_state is
  when S0 =>
  reset_cnt <= '1';
  when S1 =>
        S_add_delay <= "100";
        reset_cnt <= '1';
  when S2 =>
      S_add_delay <= "110";
      reset_cnt <= '1';
  when S3 => 
      S_add_delay <= "111";
      reset_cnt <= '1';
  when S4 =>
      switchAL_delay <= '1';
      switchML_delay <= '1';
      switchMH_delay <= '1';
  when S5 =>
      reset_cnt <= '0';
      cnt_enable <= '1';
  when others =>
      reset_cnt <= '1';
end case;
end process;

DELAY : process(clk)
begin
if (rising_edge(clk)) then
    switchAL <= switchAL_delay;
    S_add <= S_add_delay;
    end if;
end process;
-- non devo mettere delay per moltiplicatore solamente adder visto che è l'unico dopo il registro di mezzo
switchML <= switchML_delay;   
    switchMH <= switchMH_delay;

  DET : detection_circuit port map(inputs,clk,reset_cnt,cnt_enable,x,y,k,z,p);




end behavioral;