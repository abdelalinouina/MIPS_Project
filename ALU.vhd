library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;

entity alu is
generic ( WIDTH : positive := 32);
	port (
		input1 : in std_logic_vector(WIDTH-1 downto 0);
		input2 : in std_logic_vector(WIDTH-1 downto 0);
		IR_shift_bits: in std_logic_vector(4 downto 0);
		sel : in functions;
		output : out std_logic_vector(WIDTH-1 downto 0);
		output_Hi : out std_logic_vector(WIDTH-1 downto 0);
		Branch :out std_logic
		);
end alu;

architecture BHV of alu is
	signal BranchSig: std_logic;	
	signal resultSig : std_logic_vector(width-1 downto 0);
	
begin
	process( input1, input2,IR_shift_bits, sel)
		variable tempResult_32bits:std_logic_vector(width-1 downto 0);	
		variable tempResult_33bits: std_logic_vector(width downto 0);
		variable tempResult_64bits: std_logic_vector(2*width-1 downto 0);	
		variable H : integer;
	
	begin
		output <=  input1;	
		H:=0;
		BranchSig<='0';
		tempResult_32bits:=std_logic_vector(to_unsigned(0, width));
		tempResult_33bits:=std_logic_vector(to_unsigned(0, width+1));
		tempResult_64bits:=std_logic_vector(to_unsigned(0, 2*width));
	
	case sel is 
	-- addition
		when ALU_add => tempResult_33bits:=std_logic_vector(unsigned("0"&input1)+unsigned("0"&input2));
						tempResult_32bits:=tempResult_33bits(width-1 downto 0);
						output <=std_logic_vector(tempResult_32bits);
						
	-- subtraction			
		when ALU_Sub => 
		tempResult_33bits:=std_logic_vector(unsigned("0"&input1)- (unsigned("0"&input2)  ));		
		tempResult_32bits:=tempResult_33bits(width-1 downto 0);
	-- AND
		when ALU_AND => tempResult_32bits:=std_logic_vector(unsigned(input1)and unsigned(input2));
		
	-- OR	
		when ALU_OR => tempResult_32bits:=std_logic_vector(unsigned(input1) or unsigned(input2));
		
	-- XOR		
		when ALU_XOR => tempResult_32bits:=std_logic_vector(unsigned(input1)xor unsigned(input2));
		
		
	--shift left logical
		when ALU_SH_LF => tempResult_32bits:=input2;
					H:=to_integer(unsigned(IR_shift_bits));
			for i in 0 to 32 loop
				if H > 0 then
				tempResult_32bits:=std_logic_vector((unsigned(tempResult_32bits(width -2 downto 0))&'0'));
				H:=H-1;
				end if;
			end loop;
						
	-- shift right logical				
		when ALU_SH_RI	=>  tempResult_32bits:=input2;
				H:=to_integer(unsigned(IR_shift_bits));		
				for i in 0 to 32 loop
					if H > 0 then
					tempResult_32bits:=std_logic_vector('0'&(unsigned(tempResult_32bits(width -1 downto 1))));
					H:=H-1;
					end if;
				end loop;
				
				
	-- shift right arithmetic				
		when ALU_SH_RI_Ar	=>  tempResult_32bits:=input2;
				H:=to_integer(unsigned(IR_shift_bits));		
				for i in 0 to 32 loop
					if H > 0 then
					if (input2(width-1)='0') then
					tempResult_32bits:=std_logic_vector('0'&(unsigned(tempResult_32bits(width -1 downto 1))));
					end if;
					if (input2(width-1)='1') then
					tempResult_32bits:=std_logic_vector('1'&(unsigned(tempResult_32bits(width -1 downto 1))));
					end if;
					H:=H-1;
					end if;					
				end loop;
				
	-- mult  unsigned 		
		when ALU_MULT_U => tempResult_64bits:=std_logic_vector(unsigned(input1)*unsigned(input2));
					tempResult_32bits:=std_logic_vector(unsigned(tempResult_64bits(width-1 downto 0)));
						
	
						
	
						
	-- mult signed					
		when ALU_MULT_S => tempResult_64bits:=std_logic_vector(signed(input1)*signed(input2));	
						tempResult_32bits:=std_logic_vector(signed(tempResult_64bits(2*width-1 downto width)));
	-- output = RegB						
		when ALU_OUT_B =>	tempResult_32bits:=std_logic_vector(unsigned(input2));
		
	-- output = RegA
		when ALU_OUT_A =>	tempResult_32bits:=std_logic_vector(unsigned(input1));
							branchSig <='1';
	-- set on less signed
		when ALU_set_s=>
					if (signed(input1) < signed(input2) ) then
					tempResult_32bits:=std_logic_vector(to_unsigned(1,32));	
					else
					tempResult_32bits:=std_logic_vector(to_unsigned(0,32));	
					end if;
					
	-- set on less unsigned				
		when ALU_set_u=>
					if (unsigned(input1) < unsigned(input2) ) then
					tempResult_32bits:=std_logic_vector(to_unsigned(1,32));	
					else
					tempResult_32bits:=std_logic_vector(to_unsigned(0,32));	
					end if;
	-- branch on equal				
		
		when ALU_beq =>
			if (unsigned(input1) = unsigned(input2)) then
			 branchSig <='1';
			 end if;
		
	-- branch not equal
		when ALU_bne => 
			if (unsigned(input1) /=  unsigned(input2)) then 
			branchSig <='1'; 
			end if;
	-- branch on less than or equal to zero	
		when ALU_blez => 
			if (to_integer(signed(input1)) <= 0) then 
			branchSig <='1';
			end if;
			
	-- branch on greater than	
		when ALU_bgtz => 
		if (to_integer(signed(input1)) > 0) then 
		branchSig <='1'; 
		end if;
	-- branch on less than zero
		when ALU_bltz => 
		if (to_integer(signed(input1)) < 0) then 
		branchSig <='1'; 
		end if;
		
	-- branck on greater than or equal to zero
		when ALU_bgez => 
		if (to_integer(signed(input1)) >= 0) then
		branchSig <='1'; 
		end if;
								
		when others=> 	tempResult_32bits:=std_logic_vector(unsigned(input2));
		
		end case;
		
		
		output <=std_logic_vector(tempResult_32bits);
		output_HI <=std_logic_vector(tempResult_64bits(2*width-1 downto width));
		
		
		
		  
	end process;
	
	

        
       branch<=BranchSig;
	
      
end BHV;

