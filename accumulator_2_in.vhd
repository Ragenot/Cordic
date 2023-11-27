library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity accumulator_2_in is
    port(
        clk, rst: in std_logic;
        en_1, en_2 : in std_logic; 
        reg_in_1, reg_in_2 : in std_logic_vector(15 downto 0);
        reg_out: out std_logic_vector(15 downto 0)
        );
end;

architecture arch of accumulator_2_in is
    signal tmp: std_logic_vector(15 downto 0);
begin
    process (clk)
    begin
        if falling_edge(clk) then
            if (rst = '1') then
                tmp <= std_logic_vector(to_unsigned(0, 16));
            elsif (en_1 = '1') then
                tmp <= reg_in_1;
            elsif (en_2 = '1') then
                tmp <= reg_in_2;
            end if;
        end if;
end process;
    reg_out <= tmp;
end arch;