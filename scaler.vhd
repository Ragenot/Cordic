library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity scaler is
	generic(N: integer := 16);
    port(
        x, y: in std_logic_vector(N-1 downto 0);
		new_x, new_y: out std_logic_vector(N-1 downto 0)
		);
end;

architecture synth of scaler is

begin
	new_x <= (x(15) & x(15 downto 1)) + (x(15) & x(15) & x(15) & x(15 downto 3)) - (x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15 downto 6)) - 
			(x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15 downto 9)) - 
			(x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15) & x(15) &x(15) & x(15) & x(15) & x(15) & x(15 downto 13));
			
	new_y <= (y(15) & y(15 downto 1)) + (y(15) & y(15) & y(15) & y(15 downto 3)) - (y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15 downto 6)) - 
			(y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15 downto 9)) - 
			(y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15) & y(15 downto 13));
end;