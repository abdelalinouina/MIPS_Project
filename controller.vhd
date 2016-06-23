library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;
entity controller is

generic (
WIDTH : positive := 32
);
port (
        rst,clk	: in std_logic;
        IR_5downto0out : in std_logic_vector(5 downto 0); 
        IR20down16 : in std_logic_vector(4 downto 0);
        PCWriteCond: out std_logic;
        PCWrite: out std_logic;
        IorD :out std_logic;
        MemRead,MemWrite: out std_logic;
        IRWrite: out std_logic;
        RegDst: out std_logic;
        PC_inc: out std_logic;
        MemToReg: out std_logic;
        regWrite,jumpAndLink: out std_logic;
        ALUsrcB: out std_logic_vector(1 downto 0);
        ALUsrcA: out std_logic;
        ALUOP: out std_logic_vector(4 downto 0);
        PCSource: out std_logic_vector(1 downto 0);
        Load_type: out LoadType;
        store_type: out storeType;
        PC_load_en: out std_logic);
        
end controller;

architecture BHV of controller is

type state_type is (s_beq, s_bne, s_blez, s_bgtz, s_bltz, s_bgez,s_jmpA,s_jmpL,
					s_andi, s_ori, s_xori,s_set_s,s_set_u,s_Memory_access_write,s_Memory_access_write2,
					s_Instruction_Fetch,s_subiu,s_Memory_access_read_wait1,s_Init,s_Memory_address_computaion_wait,s_Type_I_completion,s_add_immediate_u,
					s_Instruction_Fetch2,s_R_type_completion,s_Exectution,s_Memory_access_read,S_Instruction_Read,s_Memory_address_computaion,s_Memory_read_completion_step);
	signal state, next_state: state_type;

begin

process(clk,rst)
	begin
	if (rst='1') then
	state<=s_Init;
	elsif (rising_edge(clk)) then
	state<=next_state;
	end if ;
	end process;
process(state)
begin	
		IorD<='0';		
		MemRead<='0';
		MemWrite <='0';
		aluSRCA<='1';
		IRWrite<='0';
		ALUSrcB<="00";
		PCWrite<='0';
		PCWriteCond<='0';
		PCSource<="00";
		ALUSrcA<='0';
		ALUSrcB<="00";
		ALUop<="01000";
		regDst <='0';
		regWrite<='0';
		jumpAndLink <='0';
		Load_type <= load_word;
		store_type <=store_word;
		--MemToReg<="00";
		NEXT_STATE<=s_Instruction_Fetch;
case state is 
	when s_Init=>
--		
	MemRead<='1';
--		IRWrite<='1';
	next_state <= s_Instruction_Fetch;

	when s_Instruction_Fetch=>
		
		--MemRead<='1';
		IRWrite<='1';
	next_state <= s_Instruction_Fetch2;
	when s_Instruction_Fetch2 =>
		--IRWrite<='1';		
		IorD<='0';		
		aluSRCA<='0';		
		ALUSrcB<="01";
		PCWrite<='1';
		PCSource<="00";
		ALUop<="01000";
		
	NEXT_STATE<=S_Instruction_Read;
	WHEN S_Instruction_Read=>
		--IRWrite<='1';
		ALUSrcA<='0';
		ALUSrcB<="11";
		ALUop<="01000";
		
		case IR_5downto0out is 
		
			 when "000000" => -- 00 R_Type
			Next_state <= s_Exectution;
			
			when "100011" => --23 load word
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "101011" => --2B store word
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "100000" => --20 load Byte signed
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "100100" => --24 load Byte unsigned
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "101000" => --28 store Byte
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "100001" => --21 load Half word signed
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "100101" => --25 load half word unsigned
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "101001" => --29 store half word
			NEXT_STATE<=s_Memory_address_computaion;
			
			when "001000" => -- add immediate unsigned
			next_state <= s_add_immediate_u;
			
			when "010000" => --10 sub immediate unsigned
			next_state <= s_subiu;
			
			when "001100" => --0C and immediate unsigned
			next_state <= s_andi;
			
			when "001101" => --0D or immediate unsigned
			next_state <= s_ori;
			
			when "001110" => --0E xor immediate unsigned
			next_state <= s_xori;
			
			when "001001" => --09 or set on less than signed immediate
			next_state <= s_set_s;
			
			when "001011" => --0B set on less than unsigned immediate
			next_state <= s_set_u;
			
			when "000100" => --04 Branch on equal
			next_state <= s_beq;
			PCSource <="01";
			
			when "000101" => --05 Branch on not equal
			next_state <= s_bne;
			
			when "000110" => --06 Branch on less or equal to zero
			next_state <= s_blez;
			
			when "000111" => --07 Branch on Greater than zero
			next_state <= s_bgtz;
			
			when "000001" => 
			     case IR20down16 is
					when "00001" => -- 01-01 Brand on greater then or equal to 0
							next_state <= s_bgez;
					when "00000" => -- 01-00 Brand on greater then or equal to 0
							next_state <= s_bltz;
					when others => null;
					end case;
			when "000010" => -- 02 jump to address
			next_state <= s_jmpA;
			PCSource <= "10";
			PCWrite <='1';
			when "000011" => -- 01 Branch on less than zero
			next_state <= s_jmpL;
				PCSource <= "10";
				PCWrite <='1';
				AluSrcA <='0';
				AluSrcB <="01";
				ALuOp   <="10000";
			
			
			
			--when "00" => -- 01 Branch on less than zero
			--next_state <= s_set_u;	
			
	
		when others =>null;
		end case;
		
		when s_jmpA=>
--			PCSource <= "10";
--			PCWrite <='1';
			next_state <= s_init;
			
		when s_jmpL =>
		jumpAndLink <='1';
		regWrite <='1';
		memToReg <='0';
		next_state <=s_init;
		when s_beq =>
		aluSRCA <='1';
		ALuSRcB<="00";
		ALUOp <="01110";
		PCWriteCond <='1';
		PCSource <="01";
		
		next_state <= s_init;
		
		
		when s_bgez =>
		aluSRCA <='1';
		ALuSRcB<="00";
		ALUOp <="01101";
		PCWriteCond <='1';
		PCSource <="01";
		
		next_state <= s_init;
		
		
		when s_bne =>
		aluSRCA <='1';
		ALuSRcB<="00";
		ALUOp <="01001";
		PCWriteCond <='1';
		PCSource <="01";
		
		next_state <= s_init;
		
		when s_blez =>
		aluSRCA <='1';
		ALuSRcB<="00";
		ALUOp <="01010";
		PCWriteCond <='1';
		PCSource <="01";
		
		next_state <= s_init;
		
		
		when s_bgtz =>
		aluSRCA <='1';
		ALuSRcB<="00";
		ALUOp <="01011";
		PCWriteCond <='1';
		PCSource <="01";
		
		next_state <= s_init;
		
		
		when s_bltz =>
		aluSRCA <='1';
		ALuSRcB<="00";
		ALUOp <="01100";
		PCWriteCond <='1';
		PCSource <="01";
		
		next_state <= s_init;
		
		
	when s_Exectution =>
		AluSrcA <= '1';
		AluSrcB <="00";
		ALuOp<= "00010";
		PCWritecond <='1';
		PCSource<="00";
		
		next_state <= s_R_type_completion;
		
	when s_R_type_completion =>
			regDst <='1';
			RegWrite <='1';
			MemToReg<='0';
			
		
		NEXT_STATE<=s_Init	;
			
	when s_Memory_address_computaion =>
			next_state <= s_Memory_address_computaion_wait;
			
		when s_Memory_address_computaion_wait =>
	
		ALUSrcA<='1';
		ALUSrcB<="10";
		ALUop<="01000";
		IorD<='1';	
		NEXT_STATE<=s_Memory_access_read;
		
		case IR_5downto0out is 
		
			 when "101011" => -- 2B store word
			Next_state <= s_Memory_access_write;
			
			when "101000" => -- 28 store Byte
			Next_state <= s_Memory_access_write;
			
			when "101001" => -- 29 store halfword
			Next_state <= s_Memory_access_write;
			
			when others => null;
		end case;
		
		when s_Memory_access_write =>
		--ALUSrcB<="10";
		MemWrite<='1';
		IorD<='1';
		case IR_5downto0out is 
		
			 when "101011" => -- 2B store word
			store_type <= store_word;
			
			when "101000" => -- 28 store Byte
			store_type <= store_Byte;
			
			when "101001" => -- 29 store halfword
			store_type <= store_half;
			
			when others => null;
		end case;
		next_state <=s_Memory_access_write2;
		
	when  s_Memory_access_write2 =>
			next_state <= s_init;
			IorD<='1';
			
		
	when s_Memory_access_read =>
		--ALUSrcB<="10";
		MemRead<='1';
		IorD<='1';
		next_state <=s_Memory_access_read_wait1;
		when s_Memory_access_read_wait1 =>
		--MemRead<='1';
		
	NEXT_STATE<=s_Memory_read_completion_step;
	
	when s_Memory_read_completion_step =>
	--ALUSrcB<="10";
		--regDst <='1';
		regWrite<='1';		
		MemToReg<='1';
		
		case IR_5downto0out is 
		
			
			
			when "100011" => --23 load word
			Load_type <= load_word;			
			
			when "100000" => --20 load Byte signed
			Load_type <= load_Byte_s;
			
			when "100100" => --24 load Byte unsigned
			Load_type <= load_Byte_u;
			
			when "100001" => --21 load Half word signed
			Load_type <= load_Half_s;
			
			when "100101" => --25 load half word unsigned
			Load_type <= load_Half_u;
			
			when others => null;
			end case;
		
		NEXT_STATE<=s_Init	;
		
		when s_add_immediate_u =>
		
		AluSrcA <= '1';
		AluSrcB <="10";
		ALuOp<= "01000";
		
		next_state <= s_Type_I_completion;
		
		
		when s_subiu =>
			AluSrcA <= '1';
			AluSrcB <="10";
			ALuOp<= "00001";
			next_state <= s_Type_I_completion;
			
		when s_andi =>
			AluSrcA <= '1';
			AluSrcB <="10";
			ALuOp<= "00011";
			next_state <= s_Type_I_completion;
		
		when s_ori =>
			AluSrcA <= '1';
			AluSrcB <="10";
			ALuOp<= "00100";
			next_state <= s_Type_I_completion;
			
		when s_set_s =>
			AluSrcA <= '1';
			AluSrcB <="10";
			ALuOp<= "00110";
			next_state <= s_Type_I_completion;
		when s_set_u =>
			AluSrcA <= '1';
			AluSrcB <="10";
			ALuOp<= "00111";
			next_state <= s_Type_I_completion;
		when s_xori =>
			AluSrcA <= '1';
			AluSrcB <="10";
			ALuOp<= "00101";
			next_state <= s_Type_I_completion;
		
		
	when s_Type_I_completion =>
			regDst <='0';
			RegWrite <='1';
			MemToReg<='0';
			NEXT_STATE<=s_Init	;
		
	
			
	
	
	when others=>null;
	end case;
	end process;
		

end BHV;