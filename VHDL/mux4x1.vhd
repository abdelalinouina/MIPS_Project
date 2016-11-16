library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity mux4x1 is
	generic (
    width  :     positive := 8);
  port(
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);
    in3    : in  std_logic_vector(width-1 downto 0);
    in4    : in  std_logic_vector(width-1 downto 0);
	sel    : in  std_logic_vector(1 downto 0);
    output    : out  std_logic_vector(width-1 downto 0));
end mux4x1;
 
  architecture CASE_STATEMENT of mux4x1 is
begin
   process(in1,in2,in3,in4, sel)
  begin
  output <=std_logic_vector(to_unsigned(0,width));
   
    case sel is
		when "00"    => output <= in1;        
        when "01"    => output <= in2;         
        when "10" 	 => output <= in3;         
		when "11"    => output <= in4;
        when others => null;       
    end case;
  end process;
end CASE_STATEMENT;