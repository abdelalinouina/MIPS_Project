library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity mux2x1 is
	generic (
    width  :     positive := 32);
  port(
    in1    : in  std_logic_vector(width-1 downto 0);
    in2    : in  std_logic_vector(width-1 downto 0);  
	sel    : in  std_logic ;
    output    : out  std_logic_vector(width-1 downto 0));
end mux2x1;
 
  architecture bhv of mux2x1 is
begin
   process(in1,in2, sel)
  begin
  output <=std_logic_vector(to_unsigned(0,width));    
    case sel is
		when '0'    =>       output <= in1;
        when '1'    =>       output <= in2;
       when others => null;       
    end case;


  end process;
end bhv;