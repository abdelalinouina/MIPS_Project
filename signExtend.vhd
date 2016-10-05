library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity signExtend is
	generic (width  : positive := 32);
	port	(input  : in  std_logic_vector(15 downto 0);   
	   		 output : out  std_logic_vector(31 downto 0);
	   		 IsSigned : in std_logic
	   		 );
end signExtend;
 
architecture BHV of signExtend is
begin
   process(input,IsSigned)
	   begin
	   if (IsSigned = '1') then
	   output(15 downto 0 )<=input;
	   for i in 16 to 31 loop
		output (i)<=input(15);
	   end loop;
	   else 
		output(31 downto 16) <= x"0000";
		output(15 downto 0 )<=input;
		end if;
   end process;
   end BHV;