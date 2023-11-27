library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package Core is
    constant N: integer := 16;
    constant const_0_pi  : std_logic_vector(N-1 downto 0) := "0000000000000000"; 
    constant const_pi_2  : std_logic_vector(N-1 downto 0) := "0001100100100010";
    constant const_pi    : std_logic_vector(N-1 downto 0) := "0011001001000100";
    constant const_3_pi_2: std_logic_vector(N-1 downto 0) := "0100101101100110";
    constant const_2_pi  : std_logic_vector(N-1 downto 0) := "0110010010001000";
    procedure pre_processing(
        signal input_angle: in std_logic_vector(N-1 downto 0); 
        signal x: in std_logic_vector(N-1 downto 0); 
        signal y: in std_logic_vector(N-1 downto 0); 
		signal normalized_angle: out std_logic_vector(N-1 downto 0);
		signal normalized_x: out std_logic_vector(N-1 downto 0); 
        signal normalized_y: out std_logic_vector(N-1 downto 0)
	);

end package Core;

package body Core is
    procedure pre_processing(
        signal input_angle: in std_logic_vector(N-1 downto 0); 
        signal x: in std_logic_vector(N-1 downto 0); 
        signal y: in std_logic_vector(N-1 downto 0); 
		signal normalized_angle: out std_logic_vector(N-1 downto 0);
		signal normalized_x: out std_logic_vector(N-1 downto 0); 
        signal normalized_y: out std_logic_vector(N-1 downto 0)
	) is
	   variable tmp_angle: integer := 0;
	   variable tmp_x: integer := 0;
	   variable tmp_y: integer := 0;
	   variable tmp: integer := 0;
	begin
	   tmp_angle := to_integer(signed(input_angle)); 
	   tmp_x := to_integer(signed(x)); 
	   tmp_y := to_integer(signed(y));  
	   tmp := 0;
	   
	   if(tmp_angle < to_integer(signed(const_pi_2))) then
	   elsif(tmp_angle < to_integer(signed(const_pi))) then
	       tmp := tmp_x;
	       tmp_angle := tmp_angle - to_integer(signed(const_pi_2));
	       tmp_x := -tmp_y;
	       tmp_y := tmp;  
	   elsif(tmp_angle < to_integer(signed(const_3_pi_2))) then
	       tmp_angle := tmp_angle - to_integer(signed(const_pi));
	       tmp_x := -tmp_x;
	       tmp_y := -tmp_y; 
	   elsif(tmp_angle < to_integer(signed(const_2_pi))) then
	       tmp := tmp_x;
	       tmp_angle := tmp_angle - to_integer(signed(const_3_pi_2));
	       tmp_x := tmp_y;
	       tmp_y := -tmp;  
	   end if;
	   
	   normalized_angle <= std_logic_vector(to_unsigned(tmp_angle, normalized_angle'length));    
	   normalized_x <= std_logic_vector(to_unsigned(tmp_x, normalized_x'length)); 
	   normalized_y <= std_logic_vector(to_unsigned(tmp_y, normalized_y'length));
	   
	end pre_processing;

end package body;
