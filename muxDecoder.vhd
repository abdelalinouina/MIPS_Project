library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;

entity muxDecoder is

	port (
		controller_Input : in std_logic_vector(1 downto 0);
		alu_controller_Input : in std_logic_vector(1 downto 0);
		
		
		output : out std_logic_vector(1 downto 0)
		
	);
end muxDecoder;

architecture BHV of muxDecoder is
begin
process(controller_Input,alu_controller_Input)
begin

if (alu_controller_Input ="00") then 
	output <=controller_Input;
else 
output <=alu_controller_Input;
end if;


end process;
end BHV;