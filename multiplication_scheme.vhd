library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplication_scheme is
    generic(N: integer := 16);
    port(
        x, y: in std_logic_vector(N-1 downto 0);
        mode: in std_logic;
        shift: in std_logic_vector(2 downto 0);
        new_x, new_y: out std_logic_vector(N-1 downto 0)
        );
end;

architecture Behavioral of multiplication_scheme is
    component comb_shifter is
        generic (N: integer := 16);
        port(
            number: in std_logic_vector(N-1 downto 0);
            shift: in std_logic_vector(2 downto 0);
            q: out std_logic_vector(N-1 downto 0)
            );
    end component; 
    component add_sub is 
        Port ( a : in std_logic_vector (15 downto 0); 
            b : in std_logic_vector (15 downto 0); 
            mode : in std_logic; 
            c : out std_logic_vector (15 downto 0)
            ); 
    end component;
    signal shifted_x, shifted_y: std_logic_vector(N-1 downto 0);
    signal mode_n: std_logic;
begin
    mode_n <= not mode;
    
    coordinate_1: comb_shifter port map(
        number => x, 
        shift => shift, 
        q => shifted_x
    );
    
    coordinate_2: comb_shifter port map(
        number => y, 
        shift => shift, 
        q => shifted_y
    );
    
    ADD_SUB_X: add_sub port map(
        a => x, 
        b => shifted_y, 
        mode => mode_n, 
        c => new_x
    );
    
    ADD_SUB_Y: add_sub port map(
        a => y, 
        b => shifted_x, 
        mode => mode, 
        c => new_y
    );
    
end;