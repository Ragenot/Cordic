library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity comb_shifter is
	generic(N: integer := 16);
    port(
        number: in std_logic_vector(N-1 downto 0);
		shift: in std_logic_vector(2 downto 0);
		q: out std_logic_vector(N-1 downto 0)
		);
end;

architecture synth of comb_shifter is

begin
	process(shift, number) begin
		case(shift) is
            when "000" => q <= number;
            when "001" => q <= number(15) & number(15 downto 1);
            when "010" => q <= number(15) & number(15) & number(15 downto 2);
            when "011" => q <= number(15) & number(15) & number(15) & number(15 downto 3);
            when "100" => q <= number(15) & number(15) & number(15) & number(15) & number(15 downto 4);
            when "101" => q <= number(15) & number(15) & number(15) & number(15) & number(15) & number(15 downto 5);
            when "110" => q <= number(15) & number(15) & number(15) & number(15) & number(15) & number(15) & number(15 downto 6);
            when "111" => q <= number(15) & number(15) & number(15) & number(15) & number(15) & number(15) & number(15) & number(15 downto 7);
            when others => q <= number;
		end case;
	end process;
end;