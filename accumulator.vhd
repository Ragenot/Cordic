library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity accumulator is
    port(
        clk, rst: in std_logic;
        en : in std_logic; 
        reg_in : in std_logic_vector(15 downto 0);
        reg_out: out std_logic_vector(15 downto 0));
end accumulator;

architecture arch of accumulator is
    signal tmp: std_logic_vector(15 downto 0);
begin
    process (clk)
    begin
        if falling_edge(clk) then
            if (rst = '1') then
                tmp <= std_logic_vector(to_unsigned(0, 16));
            elsif (en = '1') then
                tmp <= reg_in;
            end if;
        end if;
end process;
    reg_out <= tmp;
end arch;