library ieee;
use ieee.std_logic_1164.all;
use work.library_file.all;

entity alu_control is

	port(
		ALUOp: in std_logic_vector(4 downto 0);
		IR5downto0: in std_logic_vector(5 downto 0);
		Load_LO,Load_HI: out std_logic;	
		ALU_LO_HI_sel: out std_logic_vector(1 downto 0);	
		sel: out functions		
	);
end alu_control;

architecture BHV of alu_control is 
begin

process(ALUOp, IR5Downto0)
begin

sel<=ALU_OUT_B;
Load_LO <='0';
Load_Hi<='0';
ALU_LO_HI_sel<="00";

case Aluop is 
	when "00000" =>sel<=ALU_OUT_B;
	when "01000" => sel <= Alu_add;
	when "00001" => sel <= Alu_sub;
	when "00011" => sel <= Alu_and;
	when "00100" => sel <= Alu_or;
	when "00101" => sel <= Alu_xor;
	when "00110" => sel <=ALU_set_s;
	when "00111" => sel <=ALU_set_u;
	when "01110"=> sel <= ALU_beq;
	when "01001"=> sel <= ALU_bne;
	when "01010"=> sel <= ALU_blez;
	when "01011"=> sel <= ALU_bgtz;
	when "01100"=> sel <= ALU_bltz;
	when "01101"=> sel <= ALU_bgez;
	when "10000" =>sel<=ALU_OUT_A;
	when "00010" =>
			case IR5Downto0 is 
			when "100001" => sel <= Alu_add;
			when "100011" => sel <= Alu_SUB;
			when "100100" => sel <= Alu_and;
			when "100101" => sel <= Alu_or;
			when "100110" => sel <= Alu_xor;
			when "000010" => sel <= ALU_SH_RI;
			when "000000" => sel <= ALU_SH_LF;
			when "000011" => sel <= ALU_SH_RI_Ar;
			when "011000" => sel <= ALU_MULT_S;
							Load_LO <='1';
							Load_HI <='1';
			when "011001" => sel <= ALU_MULT_U;
							Load_LO <='1';
							Load_HI <='1';
			when "101010" => sel <=ALU_set_s;
			when "101011" => sel <=ALU_set_u;
			when "010000" => ALU_LO_HI_sel <="10";
			when "010010" => ALU_LO_HI_sel <="01";
			when "001000" => sel <=ALU_out_A;
			
			when others => null;
	end case;
	when others => null;
end case;
end process;
end BHV;
	