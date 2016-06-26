library ieee;
use ieee.std_logic_1164.all;
package library_file is

type functions is (
   Alu_add,     ALU_SUB,    	ALU_and,      ALU_or,   	ALU_XOR,	   ALU_SH_LF, 
   ALU_SH_RI,   ALU_SH_RI_AR,   ALU_MULT_U,   ALU_MULT_S,   ALU_set_u,     ALU_set_s,
   ALU_Beq,     ALU_Bne, 		ALU_blez,     ALU_bgtz,     ALU_bltz,      ALU_bgez,
   ALU_Byte_s,  ALU_Half_s,     ALU_Byte_U,   ALU_Half_U,   ALU_OUT_B,     ALU_OUT_A,
   ALU_OUT_A_and_Branch 
   );
   
   
  type state_type is (
					s_beq, 		s_bne, 		s_blez, 	s_bgtz, 	s_bltz, 	s_bgez,s_jmpA,s_jmpL,
					s_andi, 	s_ori,		s_xori,		s_set_s,	s_set_u,	s_Memory_access_write,
					s_Memory_access_write2,				s_Instruction_Fetch,	s_subiu,s_Memory_access_read_wait1,
					s_Init,								s_Memory_address_computaion_wait,
					s_Type_I_completion,				s_add_immediate_u,		s_Instruction_Fetch2,
					s_R_type_completion,				s_Exectution,			s_Memory_access_read,
					S_Instruction_Read,					s_Memory_address_computaion,
					s_Memory_read_completion_step
					);
	
  type loadType is (
					Load_word, Load_half_s, 	load_byte_s,Load_half_U, 	load_byte_U
					);
					
  type storeType is (
					store_word, 	Store_half, 	store_byte
					);

end package;