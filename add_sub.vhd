library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 

entity add_sub is 
    Port ( a : in std_logic_vector (15 downto 0); 
            b : in std_logic_vector (15 downto 0); 
            mode : in std_logic; 
            c : out std_logic_vector (15 downto 0)
         ); 
end add_sub;

architecture Behavioral of add_sub is 
begin 
process (a, b, mode) begin 
    if mode = '1' then 
        c <= a + b; 
    else 
        c <= a - b; 
    end if; 
end process; 
end Behavioral;