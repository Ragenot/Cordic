library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Cordic is
    generic(N: integer := 16);
    port(
        clk, en: in std_logic;
        input_angle, x, y: in std_logic_vector(N-1 downto 0);
        result_x, result_y: out std_logic_vector(N-1 downto 0);
        ready: out std_logic
    );
end Cordic;

architecture struct of Cordic is
    component Cordic_fsm is
        port(
            clk: in std_logic;
	        input_fsm_signals: in std_logic_vector(1 downto 0);
	        tan_addr: out std_logic_vector(2 downto 0);
	        y: out std_logic_vector(3 downto 0)
	        );
	end component;  
	component Cordic_scheme is
        generic(N: integer := 16);
        port(
            clk: in std_logic;
            fsm_control_signals: in std_logic_vector(2 downto 0);
            input_angle, x, y: in std_logic_vector(N-1 downto 0);
            tan_addr: in std_logic_vector(2 downto 0);
            result_x, result_y: out std_logic_vector(N-1 downto 0)
            );
	end component; 
	signal ControlSignal: std_logic_vector(3 downto 0); 
	signal addr: std_logic_vector(2 downto 0);
	signal inputs_fsm: std_logic_vector(1 downto 0);
begin
    inputs_fsm <= ('0', en);
    fsm: Cordic_fsm port map(
        clk => clk, 
        input_fsm_signals => inputs_fsm, 
        tan_addr => addr, 
        y => ControlSignal
    );
    scheme: Cordic_scheme port map(
        clk => clk, 
        fsm_control_signals => ControlSignal(2 downto 0), 
        tan_addr => addr, 
        input_angle => input_angle, 
        x => x, 
        y => y, 
        result_x => result_x, 
        result_y => result_y
    );
    ready <= ControlSignal(3);
end;
