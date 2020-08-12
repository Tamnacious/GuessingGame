----------------------------------------------------------------------------------
-- Company: CSE490
-- Engineer: Carmen Tam
-- 
-- Create Date: 
-- Design Name: 
-- Module Name: project2_code - Behavioral
-- Project Name: project_2
-- Target Devices: Basys3
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 

-- **NOTES**
-- Find a way to add decimals for each wrong guess inputted
-- Clock cycles for game.
-- Erasing PL1/PL2 after the a digit is inputted
-- Restarting the game
-- 2 HI and 2 LO
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity project2_code is
    Port ( 
           reset: in STD_LOGIC;
           clock : in STD_LOGIC;                        
           SW : in STD_LOGIC_VECTOR (3 downto 0);       -- 4 Bit Input
           LED: out STD_LOGIC_VECTOR (3 downto 0);      -- LEDS
           GAME : out STD_LOGIC;                        -- Last LED
           SSEG : out STD_LOGIC_VECTOR (7 downto 0);    -- Cathodes
           SSEG_AN: out STD_LOGIC_VECTOR (3 downto 0);  -- Anodes
           BTN : in STD_LOGIC_VECTOR (4 downto 0)
    );      
    
end project2_code;

architecture Behavioral of project2_code is

-- Start ------                                  
    
    -- States
    TYPE state_type IS (A, B, C, D, F, G, WIN, LOSE);   
    signal present_state, next_state : state_type;
    
    -- User inputs
    signal chosen: STD_LOGIC_VECTOR (15 downto 0);
    signal guess: STD_LOGIC_VECTOR (15 downto 0);
    
    -- "Holding" variables
    -- Number of guesses
    signal SSEG_count : STD_LOGIC_VECTOR (3 downto 0); 
    -- SSEG Display depending on user switch input
    signal SSEG_num : STD_LOGIC_VECTOR (3 downto 0);
    signal SSEG_num1 : STD_LOGIC_VECTOR (3 downto 0);
    signal SSEG_num2: STD_LOGIC_VECTOR (3 downto 0);
    signal SSEG_num3 : STD_LOGIC_VECTOR (3 downto 0);
    
    -- "Variable holding the value of the last 4 switches   
    signal counter: STD_LOGIC_VECTOR (1 downto 0);
    signal button_press: STD_LOGIC_VECTOR(2 downto 0);
    
    -- Seperated digits for each anode (D3,D2,D1,D0)
    signal hex_parse0 : STD_LOGIC_VECTOR (3 downto 0);      -- D0
    signal hex_parse1 : STD_LOGIC_VECTOR (7 downto 4);      -- D1
    signal hex_parse2 : STD_LOGIC_VECTOR (11 downto 8);     -- D2
    signal hex_parse3 : STD_LOGIC_VECTOR (15 downto 12);    -- D3
    
    -- Variable/ Signal holding each 4 bit switch converted into an 8 bit SSEG combination.
    signal sseg_hold : STD_LOGIC_VECTOR(7 downto 0);
    signal sseg_hold1 : STD_LOGIC_VECTOR(7 downto 0);
    signal sseg_hold2 : STD_LOGIC_VECTOR(7 downto 0);
    signal sseg_hold3 : STD_LOGIC_VECTOR(7 downto 0);
    -- Signal holding SSEG display for winning screen (No. of player guesses)
    signal wsseg : STD_LOGIC_VECTOR(7 downto 0);

    -- Keeping track of a win or loss effect
    signal wrong_count: STD_LOGIC_VECTOR(3 downto 0):= "0000";
---------------
    -- Clock enabled for counters
    signal clock_cycle: STD_LOGIC_VECTOR (27 downto 0);
    
    -- Keeping track of blinking LED and new start game
    signal timer : STD_LOGIC_VECTOR (1 downto 0);
    signal timer_cycle: STD_LOGIC_VECTOR(1 downto 0);
    signal new_game: STD_LOGIC_VECTOR (1 downto 0);
    

begin        
          
LED <= SW; -- When a switch is activated, designated LED is lit

-- At Game start, state will start at A, displaying PL _ 1
process(clock, reset)
begin
    if (reset = '1') then
        present_state <= A;
    elsif(rising_edge(clock)) then
        present_state <= next_state;
        clock_cycle <= clock_cycle + 1;
        
    end if;
end process;

--Clock Counter for traversing through each anode
counter <= clock_cycle(18 downto 17);
-- Counter for traversing through each second for the LED
timer <= clock_cycle(27 downto 26);
       

process(BTN(4))
begin
    if(falling_edge(BTN(4))) then
        button_press <= button_press + 1;
        if (button_press = 5)then
            -- Counts for a wrong input by PLAYER 2
            wrong_count <= wrong_count + 1;
            button_press <= button_press - 2 ;

        end if;
    end if;
end process;

nextstate : process(present_state, button_press)
begin
    -- Each state traverses through the center button press.
    case present_state is 
       
        -- PL 1 display
        when A => if (button_press = 1) then 
                    next_state <= B;
                  else
                    next_state <= A;
                  end if;
                  
                  
        -- Entering chosen number
        when B => if(button_press = 2) then
                    -- Player One's chosen combination of numbers.
                    chosen <= hex_parse3 & hex_parse2 & hex_parse1 & hex_parse0;           
                    next_state <= C;
                  else
                    next_state <= B;
                  end if;
        --PL 2 display
        when C => if(button_press = 3) then
                    next_state <= D;
                   else
                    next_state <= C;
                  end if;
        -- Guessing Stage
        when D => 
                  if(button_press = 4)then
                      guess <= hex_parse3 & hex_parse2 & hex_parse1 & hex_parse0;  
                      
                      if(guess > chosen) then
                            next_state <= F;

                      elsif (guess < chosen) then
                            next_state <= G;

                      elsif (guess = chosen) then
                            next_state <= WIN;
                            
                      end if;   
                  else
                    next_state <= D;           
                  end if;
        
        -- 2 HI
        when F =>  
                  if (button_press = 5) then     
                    next_state <= D;   
                    if (wrong_count = 4) then
                            next_state <= LOSE; 
                    end if;
                    else
                    next_state <= F;  
                  end if; 
        -- 2 LO
        when G =>  
                   if (button_press = 5) then
                    next_state <= D; 
                    if (wrong_count = 4) then
                            next_state <= LOSE; 
                    end if;                   
                    else
                    next_state <= G;
                  end if;           
        -- WIN          
        when WIN => next_state <= WIN;
        
        -- LOSE          
        when LOSE => if ( new_game /= 0) then
                        next_state <= A;
                     else   
                        next_state <= LOSE;
                     end if;
        
    end case;
end process nextstate;     

-- Action for pressing the left button (Latches D0)
process(BTN(0))
begin
    if (BTN(0) = '1') then
        hex_parse0 <= SW(3 downto 0);
        SSEG_num <= hex_parse0;
    end if;
end process;

-- Action for pressing the right button (Latches D3)
process(BTN(1))
begin
    if (BTN(1) = '1') then
        hex_parse3 <= SW(3 downto 0);
        SSEG_num3 <= hex_parse3;
    end if;

end process;

-- Action for pressing the down button (Latches D2)
process(BTN(2))
begin
    if (BTN(2) = '1') then
        hex_parse2 <= SW(3 downto 0);
        SSEG_num2 <= hex_parse2;
    end if;

end process;

-- Action for pressing the up button (Latches D1)
process(BTN(3))
begin
    if (BTN(3) = '1') then
        hex_parse1 <= SW(3 downto 0);
        SSEG_num1 <= hex_parse1;
    end if;

end process;
  
-- Cycles through 3 seconds before restarting game if player had lost.
-- Flashed LED light on and off for player win.  
process(timer)
begin
    case (timer) is
    when "00" => timer_cycle <= "00";
                 if(present_state= WIN)
                    then GAME <= '1'; 
                 end if;
                 if (present_state = LOSE)
                    then timer_cycle <= timer_cycle + 1;
                 end if;   
    when "01" => 
                 if(present_state= WIN)
                    then GAME <= '0'; 
                 end if;  
                 if (present_state = LOSE)
                    then timer_cycle <= timer_cycle + 1;
                 end if;   
    when "10" => 
                 if(present_state = WIN)
                    then GAME <= '1'; 
                 end if; 
                 if (present_state = LOSE)
                    then timer_cycle <= timer_cycle + 1;
                 end if;  
    when "11" => 
                 if (present_state = LOSE and timer_cycle = 3)
                    then new_game <= new_game +1;
                 end if;
    end case;
end process;
  
-- For each counter incrementation, depending on the state, SSEG display will appear as different numbers or letters.
process(counter)
begin
    case (counter) is
    when "00" =>  SSEG_AN <= "0111"; 
                  if(present_state = A) then        -- Initial Start Screen 
                    SSEG <= "10001100"; -- P
                    
                  elsif (present_state = B) then    -- Initial PL_2 Screen              
                    SSEG <= sseg_hold3;
                    
                  elsif (present_state = C) then    -- Initial PL_2 Screen              
                    SSEG <= "10001100"; -- P
                        
                  elsif (present_state = D) then     -- Entering Guess
                     if(wrong_count > 3) then
                        SSEG <= sseg_hold3 - "10000000";
                     else   
                        SSEG <= sseg_hold3;
                     end if;                  
                  elsif (present_state = F) then     -- 2 HI
                    SSEG <= "10100100"; -- 2
                    
                  elsif (present_state = G) then     -- 2 LO
                    SSEG <= "10100100"; -- 2
                    
                  elsif (present_state = LOSE) then
                    SSEG <= "11000111"; -- L
                    
                  elsif (present_state = WIN) then
                    SSEG <= "11111111"; -- BLANK
                  end if;
    when "01" =>  SSEG_AN <= "1011";  
                      -- Accessing the second digit
                  if(present_state = A) then
                    SSEG <= "11000111"; -- L
                  elsif (present_state = B) then 
                    SSEG <= sseg_hold2;
                  elsif (present_state = C) then
                    SSEG <= "11000111"; -- L
                  elsif (present_state = D) then
                     if(wrong_count > 2) then
                        SSEG <= sseg_hold2 - "10000000";
                     else   
                        SSEG <= sseg_hold2;
                     end if;                  
                  elsif (present_state = F) then
                    SSEG <= "11111111"; -- blank
                  elsif (present_state = G) then 
                    SSEG <= "11111111"; -- blank
                  elsif (present_state = LOSE) then 
                    SSEG <= "11000000"; -- O 
                  elsif (present_state = WIN) then
                    SSEG <= "11111111"; -- BLANK
                  end if;
    when "10" =>  SSEG_AN <= "1101"; 
                     -- Accessing the third digit
                  if(present_state = A) then
                    SSEG <= "11111111"; -- blank
                  elsif (present_state = B) then                 
                    SSEG <= sseg_hold1;
                  elsif (present_state = C) then
                    SSEG <= "11111111"; -- blank
                  elsif (present_state = D) then
                     if(wrong_count > 1) then
                        SSEG <= sseg_hold1 - "10000000";
                     else   
                        SSEG <= sseg_hold1;
                     end if;   
                  elsif (present_state = F) then
                    SSEG <= "10001001"; -- 2
                  elsif (present_state = G) then
                    SSEG <= "11000111"; -- 2
                  elsif (present_state = LOSE) then
                    SSEG <= "10010010"; -- S
                  elsif (present_state = WIN) then
                    SSEG <= "11111111"; -- BLANK
                  end if;
    when "11" =>  SSEG_AN <= "1110";

                  if(present_state = A) then
                    SSEG <= "11111001"; -- 1
                  elsif (present_state = B) then             
                    SSEG <= sseg_hold;                    
                  elsif (present_state = C) then
                    SSEG <= "10100100"; -- 2
                  elsif (present_state = D) then
                  -- Controlling the decimal points
                    if(wrong_count > 0) then
                        SSEG <= sseg_hold - "10000000";
                     else   
                        SSEG <= sseg_hold;
                     end if;   
                  elsif (present_state = F) then
                    SSEG <= "11111001"; -- I
                  elsif (present_state = G) then
                    SSEG <= "11000000"; -- O
                  elsif (present_state = LOSE) then
                    SSEG <= "10000110"; -- E
                  elsif (present_state = WIN) then
                    SSEG_count <= wrong_count ; 
                    SSEG <= wsseg;
                  end if;
                  
    end case;
end process;  

--Anopde 4 (D0)
--Defining Seven Segment Input for each Anode
process(SSEG_num)
begin
    -- Turns on the 7 segment digit based on the changing holding variable
    case SSEG_num is
    when "0000" => 
        sseg_hold <= "11000000"; -- 0    
    when "0001" => 
        sseg_hold <= "11111001"; -- 1 
    when "0010" => 
        sseg_hold <= "10100100"; -- 2 
    when "0011" => 
        sseg_hold <= "10110000"; -- 3 
    when "0100" => 
        sseg_hold <= "10011001"; -- 4 
    when "0101" => 
        sseg_hold <= "10010010"; -- 5 
    when "0110" => 
        sseg_hold <= "10000010"; -- 6 
    when "0111" => 
        sseg_hold <= "11111000"; -- 7 
    when "1000" => 
        sseg_hold <= "10000000"; -- 8    
    when "1001" => 
        sseg_hold <= "10010000"; -- 9 
    when "1010" => 
        sseg_hold <= "10100000"; -- a
    when "1011" => 
        sseg_hold <= "10000011"; -- b
    when "1100" => 
        sseg_hold <= "11000110"; -- C
    when "1101" => 
        sseg_hold <= "10100001"; -- d
    when "1110" => 
        sseg_hold <= "10000110"; -- E
    when "1111" => 
        sseg_hold <= "10001110"; -- F
    
    when others => sseg_hold <= "11111111"; -- Blank 
    
    end case; 
end process;

-- Anode 3 (D1)
process(SSEG_num1)
begin
    -- Turns on the 7 segment digit based on the changing holding variable
    case SSEG_num1 is
    when "0000" => 
        sseg_hold1 <= "11000000"; -- 0    
    when "0001" => 
        sseg_hold1 <= "11111001"; -- 1 
    when "0010" => 
        sseg_hold1 <= "10100100"; -- 2 
    when "0011" => 
        sseg_hold1 <= "10110000"; -- 3 
    when "0100" => 
        sseg_hold1 <= "10011001"; -- 4 
    when "0101" => 
        sseg_hold1 <= "10010010"; -- 5 
    when "0110" => 
        sseg_hold1 <= "10000010"; -- 6 
    when "0111" => 
        sseg_hold1 <= "11111000"; -- 7 
    when "1000" => 
        sseg_hold1 <= "10000000"; -- 8    
    when "1001" => 
        sseg_hold1 <= "10010000"; -- 9 
    when "1010" => 
        sseg_hold1 <= "10100000"; -- a
    when "1011" => 
        sseg_hold1 <= "10000011"; -- b
    when "1100" => 
        sseg_hold1 <= "11000110"; -- C
    when "1101" => 
        sseg_hold1 <= "10100001"; -- d
    when "1110" => 
        sseg_hold1 <= "10000110"; -- E
    when "1111" => 
        sseg_hold1 <= "10001110"; -- F
    
    when others => sseg_hold1 <= "11111111"; -- Blank 
    
    end case; 
end process;

-- Anode 2 ( D2)
process(SSEG_num2)
begin
    -- Turns on the 7 segment digit based on the changing holding variable
    case SSEG_num2 is
    when "0000" => 
        sseg_hold2 <= "11000000"; -- 0    
    when "0001" => 
        sseg_hold2 <= "11111001"; -- 1 
    when "0010" => 
        sseg_hold2 <= "10100100"; -- 2 
    when "0011" => 
        sseg_hold2 <= "10110000"; -- 3 
    when "0100" => 
        sseg_hold2 <= "10011001"; -- 4 
    when "0101" => 
        sseg_hold2 <= "10010010"; -- 5 
    when "0110" => 
        sseg_hold2 <= "10000010"; -- 6 
    when "0111" => 
        sseg_hold2 <= "11111000"; -- 7 
    when "1000" => 
        sseg_hold2 <= "10000000"; -- 8    
    when "1001" => 
        sseg_hold2 <= "10010000"; -- 9 
    when "1010" => 
        sseg_hold2 <= "10100000"; -- a
    when "1011" => 
        sseg_hold2 <= "10000011"; -- b
    when "1100" => 
        sseg_hold2 <= "11000110"; -- C
    when "1101" => 
        sseg_hold2 <= "10100001"; -- d
    when "1110" => 
        sseg_hold2 <= "10000110"; -- E
    when "1111" => 
        sseg_hold2 <= "10001110"; -- F
    
    when others => sseg_hold2 <= "11111111"; -- Blank 
    
    end case; 
end process;

--Anode 1 (D3)
process(SSEG_num3)
begin
    -- Turns on the 7 segment digit based on the changing holding variable
    case SSEG_num3 is
    when "0000" => 
        sseg_hold3 <= "11000000"; -- 0    
    when "0001" => 
        sseg_hold3 <= "11111001"; -- 1 
    when "0010" => 
        sseg_hold3 <= "10100100"; -- 2 
    when "0011" => 
        sseg_hold3 <= "10110000"; -- 3 
    when "0100" => 
        sseg_hold3 <= "10011001"; -- 4 
    when "0101" => 
        sseg_hold3 <= "10010010"; -- 5 
    when "0110" => 
        sseg_hold3 <= "10000010"; -- 6 
    when "0111" => 
        sseg_hold3 <= "11111000"; -- 7 
    when "1000" => 
        sseg_hold3 <= "10000000"; -- 8    
    when "1001" => 
        sseg_hold3 <= "10010000"; -- 9 
    when "1010" => 
        sseg_hold3 <= "10100000"; -- a
    when "1011" => 
        sseg_hold3 <= "10000011"; -- b
    when "1100" => 
        sseg_hold3 <= "11000110"; -- C
    when "1101" => 
        sseg_hold3 <= "10100001"; -- d
    when "1110" => 
        sseg_hold3 <= "10000110"; -- E
    when "1111" => 
        sseg_hold3 <= "10001110"; -- F
    
    when others => sseg_hold3 <= "11111111"; -- Blank 
    
    end case; 
end process;

-- Anode For displaying number of guesses before win.
--Defining Seven Segment Input for each Anode
process(SSEG_count)
begin
    -- Turns on the 7 segment digit based on the changing holding variable
    case SSEG_count is
    when "0000" => 
        wsseg <= "11000000"; -- 0    
    when "0001" => 
        wsseg <= "11111001"; -- 1 
    when "0010" => 
        wsseg <= "10100100"; -- 2 
    when "0011" => 
        wsseg <= "10110000"; -- 3 
    when "0100" => 
        wsseg <= "10011001"; -- 4 
    when "0101" => 
        wsseg <= "10010010"; -- 5 
    when "0110" => 
        wsseg <= "10000010"; -- 6 
    when "0111" => 
        wsseg <= "11111000"; -- 7 
    when "1000" => 
        wsseg <= "10000000"; -- 8    
    when "1001" => 
        wsseg <= "10010000"; -- 9 
    when "1010" => 
        wsseg <= "10100000"; -- a
    when "1011" => 
        wsseg <= "10000011"; -- b
    when "1100" => 
        wsseg <= "11000110"; -- C
    when "1101" => 
        wsseg <= "10100001"; -- d
    when "1110" => 
        wsseg <= "10000110"; -- E
    when "1111" => 
        wsseg <= "10001110"; -- F
    
    when others => wsseg <= "11111111"; -- Blank 
    
    end case; 
end process;

end Behavioral;
