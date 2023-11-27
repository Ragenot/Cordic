library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Cordic_fsm is
    port(
        clk: in std_logic;
        input_fsm_signals: in std_logic_vector(1 downto 0);
	    tan_addr: out std_logic_vector(2 downto 0);
	    y: out std_logic_vector(3 downto 0)
	);
end;

architecture synth of Cordic_fsm is
    type statetype is (RESET, INIT, COUNT, COUNT_COORDINATES, COUNT_ANGLE, COUNT_COUNTER, STOP);
	signal state, nextstate: statetype;
	constant ALL_ZEROES: std_logic_vector(2 downto 0) := (others => '0');
	constant ALL_ONES: std_logic_vector(2 downto 0) := (others => '1');
	signal counter: std_logic_vector(2 downto 0);
	-- input signals
	signal start: std_logic;
	-- output signals
	signal global_reset, store_angle, store_coordinates, ready: std_logic;
begin
    start <= input_fsm_signals(0);

    --state register
    process(clk) begin
	   if rising_edge(clk) then
		  if start = '0' then state <= RESET;
		  else state <= nextstate;
		  end if;
	   end if;
    end process;

    --next state logic
    NXT_STATE: process(state, clk, counter)
    begin
        case(state) is
            when RESET => 
                nextstate <= INIT;        
            when INIT => 
                --nextstate <= COUNT_COORDINATES; 
                nextstate <= COUNT; 
            when COUNT =>
                if (counter = ALL_ZEROES) then
                    nextstate <= STOP; 
                else    
                    nextstate <= COUNT; 
                end if;
--            when COUNT_COORDINATES =>
--                nextstate <= COUNT_ANGLE;                   
--            when COUNT_ANGLE =>
--                nextstate <= COUNT_COUNTER;    
--            when COUNT_COUNTER =>
--                if (counter = ALL_ZEROES) then
--                    nextstate <= STOP; 
--                else    
--                    nextstate <= COUNT_COORDINATES; 
--                end if;   
            when STOP => 
                nextstate <= STOP;           
            when others =>
                nextstate <= RESET;   
        end case;  
    end process;

    TAN_COUNTER: process(clk)
    begin
        if falling_edge(clk) then 
            if (state = RESET) then 
                counter <= ALL_ZEROES;    
            elsif (state = COUNT) then
                counter <= counter + '1';    
            end if;
        end if;
    end process;

    --output logic
    global_reset <= '1' when state = INIT else '0';
    store_angle <= '1' when state = COUNT else '0';
    store_coordinates <= '1' when state = COUNT else '0';
    ready <= '1' when state = STOP else '0'; 

    y <= (ready, store_coordinates, store_angle, global_reset);
    tan_addr <= counter;
end;