library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity regFile is
	generic (width  :     positive := 32);
	port(
    input    	: in  std_logic_vector(width-1 downto 0);    
    outputA     : out   std_logic_vector(width-1 downto 0);
    outputB     : out  std_logic_vector(width-1 downto 0);
	wren        : in  std_logic;
	regASel     : in std_logic_vector(4 downto 0);
	regBSel     : in std_logic_vector(4 downto 0);
	writeRegSel : in std_logic_vector(4 downto 0);
	clk         : in  std_logic);
    
end regFile;
 
  architecture BHV of regFile is
	type registerFile is array(natural range <>) of std_logic_vector (width-1 downto 0);
	signal registers: registerFile(31 downto 0);
	begin	
   regFile : process(clk)
	   begin 
	   if rising_edge(clk) then
			outputA <= registers(to_integer(unsigned(regAsel)));
			outputB <= registers(to_integer(unsigned(regBsel)));
			if wren ='1' then
		    registers(to_integer(unsigned(writeRegSel)))<=input;
			   if (regAsel = writeRegSel) then 
					outputA<=input;
				end if;
				if (regBsel = writeRegSel) then 
					outputB<=input;
				end if;
			end if ;
		end if;
	end process;
	
 end BHV;