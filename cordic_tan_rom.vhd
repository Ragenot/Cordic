library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity cordic_tan_rom is
    generic (N: integer := 16);
    port (
        addr: in  std_logic_vector(2 downto 0); 
        data: out std_logic_vector(N-1 downto 0)
    );
end;

architecture synth of cordic_tan_rom is
    type rom_type is array (0 to 7) of std_logic_vector(N-1 downto 0);
    -- set the data on each adress to some value 
    constant TAN_0 : std_logic_vector(N-1 downto 0) := "0000110010010001";
    constant TAN_1 : std_logic_vector(N-1 downto 0) := "0000011101101011";
    constant TAN_2 : std_logic_vector(N-1 downto 0) := "0000001111101011";
    constant TAN_3 : std_logic_vector(N-1 downto 0) := "0000000111111101";
    constant TAN_4 : std_logic_vector(N-1 downto 0) := "0000000100000000";
    constant TAN_5 : std_logic_vector(N-1 downto 0) := "0000000010000000";
    constant TAN_6 : std_logic_vector(N-1 downto 0) := "0000000001000000";
    constant TAN_7 : std_logic_vector(N-1 downto 0) := "0000000000100000";

    constant ALL_ZEROES: std_logic_vector(N-1 downto 0) := (others => '0');
    constant mem: rom_type := (
        TAN_0, TAN_1, TAN_2, TAN_3,
        TAN_4, TAN_5, TAN_6, TAN_7
        );
begin
     data <= mem(to_integer(unsigned(addr)));   
end;