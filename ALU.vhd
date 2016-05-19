library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity alu is
generic ( WIDTH : positive := 32);
	port (
		input1 : in std_logic_vector(WIDTH-1 downto 0);
		input2 : in std_logic_vector(WIDTH-1 downto 0);
		sel : in std_logic_vector(3 downto 0);
		output : out std_logic_vector(WIDTH-1 downto 0);
		zeroFlag:out std_logic
	);
end alu;

architecture BHV of alu is
	signal zeroFlagSig: std_logic;	
	signal resultSig : std_logic_vector(width-1 downto 0);
	
begin
	process( input1, input2, sel)
		variable tempResult_32bits:std_logic_vector(width-1 downto 0);	
		variable tempResult_33bits: std_logic_vector(width downto 0);
		variable tempResult_64bits: std_logic_vector(2*width-1 downto 0);	
		variable H : integer;
	
	begin
		output <=  input1;
		H:=0;
		zeroFlagSig<='0';
		tempResult_32bits:=std_logic_vector(to_unsigned(0, width));
		tempResult_33bits:=std_logic_vector(to_unsigned(0, width+1));
		tempResult_64bits:=std_logic_vector(to_unsigned(0, 2*width));
	
	case sel is 
	-- addition
		when "0000" => tempResult_33bits:=std_logic_vector(unsigned("0"&input1)+unsigned("0"&input2));
						tempResult_32bits:=tempResult_33bits(width-1 downto 0);
						output <=std_logic_vector(tempResult_32bits);
						
	-- subtraction			
		when "0001" => 
		tempResult_33bits:=std_logic_vector(unsigned("0"&input1)+not(unsigned("0"&input2) +to_unsigned(1,9 )) );		
		tempResult_32bits:=tempResult_33bits(width-1 downto 0);
		when "0011" => tempResult_32bits:=std_logic_vector(unsigned(input1)and unsigned(input2));
		
	-- OR	
		when "0100" => tempResult_32bits:=std_logic_vector(unsigned(input1) or unsigned(input2));
		
	-- XOR		
		when "0101" => tempResult_32bits:=std_logic_vector(unsigned(input1)xor unsigned(input2));
		
		
	--shift left
		when "0110" => tempResult_32bits:=input1;
					H:=to_integer(unsigned(input2));
			for i in 0 to 32 loop
				if H > 0 then
				tempResult_32bits:=std_logic_vector((unsigned(tempResult_32bits(width -2 downto 0))&'0'));
				H:=H-1;
				end if;
			end loop;
						
	-- shift right				
		when "0111"	=>  tempResult_32bits:=input1;
				H:=to_integer(unsigned(input2));		
				for i in 0 to 32 loop
					if H > 0 then
					tempResult_32bits:=std_logic_vector('0'&(unsigned(tempResult_32bits(width -1 downto 1))));
					H:=H-1;
					end if;
				end loop;
				
	-- mult LO unsigned 		
		when "1000" => tempResult_64bits:=std_logic_vector(unsigned(input1)*unsigned(input2));
						tempResult_32bits:=std_logic_vector(unsigned(tempResult_64bits(width-1 downto 0)));
						
	-- mult HI unsigned					
		when "1001" => tempResult_64bits:=std_logic_vector(unsigned(input1)*unsigned(input2));	
						tempResult_32bits:=std_logic_vector(unsigned(tempResult_64bits(2*width-1 downto width)));
						
	-- mult LO	
	
		when "1010" => tempResult_64bits:=std_logic_vector(signed(input1)*signed(input2));
						tempResult_32bits:=std_logic_vector(signed(tempResult_64bits(width-1 downto 0)));
						
	-- mult HI					
		when "1011" => tempResult_64bits:=std_logic_vector(signed(input1)*signed(input2));	
						tempResult_32bits:=std_logic_vector(signed(tempResult_64bits(2*width-1 downto width)));	
									
		when others=> null;
		end case;
		
		
		output <=std_logic_vector(tempResult_32bits);
		
		if (tempResult_32bits = std_logic_vector(to_unsigned(0,width))) then
				zeroFlagsig <= '1';
			end if ;
		
		  
	end process;
	
	

        
       zeroFlag<=zeroFlagsig;
	
      
end BHV;

