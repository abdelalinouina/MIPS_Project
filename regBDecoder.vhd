library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;

entity regBDecoder is

	generic ( WIDTH : positive := 32);
	port (
		input : in std_logic_vector(WIDTH-1 downto 0);	
		
		sel : in storeType;
		output : out std_logic_vector(WIDTH-1 downto 0)
		
	);
end regBDecoder;

architecture BHV of regBDecoder is
begin
process(input, sel)
begin
output <= input;
case sel is 
	-- store word
when store_word =>
	output <= input;
	-- store Half Word 
when store_Half => output <= std_logic_vector("0000000000000000"&unsigned(input(width/2-1  downto 0)));
		
		-- store Byte 		
when store_Byte => output <= std_logic_vector("000000000000000000000000"&unsigned(input(width/4-1  downto 0)));
		
when others => null;
end case;

end process;
end BHV;