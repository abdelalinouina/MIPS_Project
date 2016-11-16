library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;

entity memRegDecoder is

	generic ( WIDTH : positive := 32);
	port    ( input : in std_logic_vector(WIDTH-1 downto 0);		
			  sel   : in loadType;
			  output: out std_logic_vector(WIDTH-1 downto 0));
end memRegDecoder;

architecture BHV of memRegDecoder is
begin
process(input, sel)
begin
	output <= input;
	
	case sel is 
		-- load word
		when load_word =>
			output <= input;
			
		-- Load Half Word Unsigned
		when load_Half_U => output <= std_logic_vector(x"0000"&unsigned(input(width/2-1  downto 0)));
				
		-- Load Byte unsigned		
		when load_Byte_U => output <= std_logic_vector(x"000000"&unsigned(input(width/4-1  downto 0)));
				
		-- Halfword signed	
		when Load_Half_s => 
				if (input(15)='0') then 	
				output <=std_logic_vector(x"0000"&unsigned(input(width/2-1  downto 0)));
				else
				output <=std_logic_vector(x"FFFF"&unsigned(input(width/2-1  downto 0)));
				end if;				
				
		-- Byte signed	
		when Load_Byte_s => 
				if (input(7)='0') then 	
				output <= std_logic_vector(x"000000"&unsigned(input(width/4-1  downto 0)));
				else
				output <= std_logic_vector(x"FFFFFF"&unsigned(input(width/4-1  downto 0)));
				end if;

	end case;

end process;
end BHV;