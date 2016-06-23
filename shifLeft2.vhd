library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity shifLeft2 is
	generic ( width  :     positive := 32);
  port(
    input    : in  std_logic_vector(width-1 downto 0);
   output    : out  std_logic_vector(width-1 downto 0));
end shifLeft2;
 
  architecture BHV of shifLeft2 is
begin
   process(input)
   begin   
		output<= std_logic_vector(unsigned(input(width-3 downto 0) )&"00"); 
   end process;
   end BHV;