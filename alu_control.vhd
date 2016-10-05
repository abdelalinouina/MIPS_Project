library ieee;
use ieee.std_logic_1164.all;
use work.library_file.all;
use work.MIPS_LIB.all;

entity alu_control is

	port(
		ALUOp: in std_logic_vector(5 downto 0);
		IR5downto0: in std_logic_vector(5 downto 0);
		Load_LO,Load_HI: out std_logic;	
		ALU_LO_HI_sel: out std_logic_vector(1 downto 0);	
		sel: out std_logic_vector(5 downto 0)		
	);
end alu_control;

architecture BHV of alu_control is 
begin

process(ALUOp, IR5Downto0)
begin

sel<=OUT_B;
Load_LO <='0';
Load_Hi<='0';
ALU_LO_HI_sel<="00";

	if ALUOp = R_type then
		sel <= IR5Downto0;
		
		case IR5Downto0 is 	
			when "011000" => sel <= mult_s;
							Load_LO <='1';
							Load_HI <='1';
			when "011001" => sel <= mult_u;
							Load_LO <='1';
							Load_HI <='1';	
			when "010000" => ALU_LO_HI_sel <="10";
			when "010010" => ALU_LO_HI_sel <="01";
			when "001000" => sel <=out_A;
			when others =>  null;
	end case;
		
	else
		sel <= ALUOp;
	end if;

end process;
end BHV;
	