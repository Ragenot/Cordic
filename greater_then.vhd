library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity Greater_then is
    generic(N: integer := 16);
    port(
        a, b: in std_logic_vector(N-1 downto 0);
        isGreater: out std_logic
        );
end;

architecture Behavioral of Greater_then is
begin
    isGreater <= '1' when (a > b) else '0';
end;
