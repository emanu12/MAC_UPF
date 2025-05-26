library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity PMU is 
    Port (	inputs : in std_logic_vector(7 downto 0);
            clk : in std_logic;
           reset : in std_logic;
           state_select : in std_logic_vector(2 downto 0);
           S_add : out std_logic_vector(2 downto 0);
           select_mux: out std_logic;
           switchML, switchAL, switchAH, switchMH, isoML, isoAL, isoAH, isoMH : out std_logic
           ret1,ret2,ret3: out std_logic
         );
end PMU;

architecture behavioral of PMU is

component detection_circuit is 
        Port (	inputs : in std_logic_vector(7 downto 0);
              clk : in std_logic;
              reset : in std_logic;
              cnt_enable : in std_logic;
               x,y,k,z,p : out std_logic
             );
end component;


type main_state is (
  SLEEP, --sleep mode
  RPM,  -- low power multiplier and low power vprca 
  LPM,  -- low power multiplier and high speed rca
  ESM, -- high speed multiplier and low power vprca
  FPM,  -- high speed multiplier and high speed rca
);

ATTRIBUTE enum_encoding : string;
ATTRIBUTE enum_encoding OF main_state : TYPE IS "000 001 011 010 110";
signal current_main_state, next_main_state : main_state;


  type sub_state is (
    S0, -- mode 0
    S1,  -- mode 1
    S2, -- mode 2
    S3, --  mode 3 
    S4, --  mode 4
    S5  -- trovato uno zero  
);

ATTRIBUTE enum_encoding : string;
ATTRIBUTE enum_encoding OF sub_state : TYPE IS "000 001 011 010 110 100 ";
signal current_sub_state, next_sub_state : sub_state;
signal reset_cnt, cnt_enable : std_logic;
signal x,y,k,z,p : std_logic;




begin

  UPDATE_STATE : process(clk,reset)
  begin 
      if reset = '1' then
          current_sub_state <= S0;
          current_main_state <= SLEEP;
      elsif rising_edge(clk) then
          current_sub_state <= next_sub_state;
          current_main_state <= next_main_state;
      end if;
  end process;



NEXT_STATES: process (current_sub_state,current_main_state,x,y,z,k,p,state_select)
begin
case current_main_state is   
          when SLEEP =>
            if state_select = "000" then
                next_main_state <= SLEEP;
            elsif state_select = "001" then
                next_main_state <= RPM;
            elsif state_select = "010" then 
                next_main_state <= LPM;
            elsif state_select = "011" then 
                next_main_state <= ESM;
            elsif state_select = "100" then
                next_main_state <= FPM;
            else
                next_main_state <= SLEEP; 
            end if;
    when RPM =>
            if state_select = "000" then
              next_main_state <= SLEEP;
          elsif state_select = "001" then
              next_main_state <= RPM;
          elsif state_select = "010" then 
              next_main_state <= LPM;
          elsif state_select = "011" then 
              next_main_state <= ESM;
          elsif state_select = "100" then
              next_main_state <= FPM;
          else
              next_main_state <= SLEEP; 
          end if;
          --SUBROUTINE 
          case current_sub_state is
            when S0 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when S1 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when S2 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when S3 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;  
            when S4 =>    
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif z = '1' and p = '1' then    
                next_sub_state <= S4;  
              else
                next_sub_state <= S0;
              end if;
            when S5 =>    
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif z = '1' and p = '1' then    
                next_sub_state <= S4;
              elsif p = '1' and z = '0' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when others =>
              next_sub_state <= S0;
          end case;
    
    when LPM =>
      if state_select = "000" then
        next_main_state <= SLEEP;
    elsif state_select = "001" then
        next_main_state <= RPM;
    elsif state_select = "010" then 
        next_main_state <= LPM;
    elsif state_select = "011" then 
        next_main_state <= ESM;
    elsif state_select = "100" then
        next_main_state <= FPM;
    else
        next_main_state <= SLEEP; 
    end if;
    
    when ESM =>
              if state_select = "000" then
                next_main_state <= SLEEP;
            elsif state_select = "001" then
                next_main_state <= RPM;
            elsif state_select = "010" then 
                next_main_state <= LPM;
            elsif state_select = "011" then 
                next_main_state <= ESM;
            elsif state_select = "100" then
                next_main_state <= FPM;
            else
                next_main_state <= SLEEP; 
            end if;
            -- SUBROUTINE 
           case current_sub_state is
            when S0 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when S1 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when S2 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when S3 =>
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif p = '1' then
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;  
            when S4 =>    
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif z = '1' and p = '1' then    
                next_sub_state <= S4;  
              else
                next_sub_state <= S0;
              end if;
            when S5 =>    
              if x = '1' then
                next_sub_state <= S1;
              elsif y = '1' then
                next_sub_state <= S2;
              elsif k = '1' then
                next_sub_state <= S3;
              elsif z = '1' and p = '1' then    
                next_sub_state <= S4;
              elsif p = '1' and z = '0' then    
                next_sub_state <= S5;
              else
                next_sub_state <= S0;
              end if;
            when others =>
              next_sub_state <= S0;
          end case;
    
    when FPM =>
          if state_select = "000" then
          next_main_state <= SLEEP;
      elsif state_select = "001" then
          next_main_state <= RPM;
      elsif state_select = "010" then 
          next_main_state <= LPM;
      elsif state_select = "011" then 
          next_main_state <= ESM;
      elsif state_select = "100" then
          next_main_state <= FPM;
      else
          next_main_state <= SLEEP;
      end if;

end case;

end process;




OUTPUT_MAIN: process (current_main_state,current_sub_state)
begin
  select_mux <= '0';
  case current_main_state is
    switchML <= '1';
    switchAL <= '1';
    switchMH <= '1';
    switchAH <= '1';
    isoML <= '1';
    isoAL <= '1'; 
    isoMH <= '1';
    isoAH <= '1';
    when SLEEP =>

    when RPM =>
    S_add <= "000";
    switchAL <= '0';
    switchML <= '0';
    reset_cnt <= '0';
        case current_state is
          when S0 =>
          reset_cnt <= '1';
          when S1 =>
                S_add <= "100";
                reset_cnt <= '1';
          when S2 =>
              S_add <= "110";
              reset_cnt <= '1';
          when S3 => 
              S_add <= "111";
              reset_cnt <= '1';
          when S4 =>
              switchML <= '1';
              switchMH <= '1';
              switchAL <= '1';
          when S5 =>
              reset_cnt <= '0';
              cnt_enable <= '1';
          when others =>
              reset_cnt <= '1';
        end case;
   
    when LPM =>
    switchML <= '0';
    switchAH <= '0';
   
    when ESM =>
    switchAL <= '0';
    switchAH <= '0';
    reset_cnt <= '0';
    case current_state is
      when S0 =>
      reset_cnt <= '1';
      when S1 =>
            S_add <= "100";
            reset_cnt <= '1';
      when S2 =>
          S_add <= "110";
          reset_cnt <= '1';
      when S3 => 
          S_add <= "111";
          reset_cnt <= '1';
      when S4 =>
          switchML <= '1';
          switchMH <= '1';
          switchAL <= '1';
      when S5 =>
          reset_cnt <= '0';
          cnt_enable <= '1';
      when others =>
          reset_cnt <= '1';
    end case;

    when FPM =>
    switchMH <= '0';
    switchAH <= '0';

end process;


  DET : detection_circuit port map(inputs,clk,reset_cnt,cnt_enable,x,y,k,z,p);




end behavioral;