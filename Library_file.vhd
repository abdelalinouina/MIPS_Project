library ieee;
use ieee.std_logic_1164.all;
package library_file is

type functions is (
   Alu_add,
   ALU_SUB,
   ALU_and, 
   ALU_or, 
   ALU_XOR,
   ALU_SH_LF, 
   ALU_SH_RI,
   ALU_SH_RI_AR,
   ALU_MULT_U,
   ALU_MULT_S,
   ALU_set_u,
   ALU_set_s,
   ALU_Beq,
   ALU_Bne,
   ALU_blez,
   ALU_bgtz,
   ALU_bltz,
   ALU_bgez,
   ALU_Byte_s,
   ALU_Half_s,
   ALU_Byte_U,
   ALU_Half_U,
   ALU_OUT_B,
   ALU_OUT_A,
   ALU_OUT_A_and_Branch );
  type loadType is (Load_word, Load_half_s, load_byte_s,Load_half_U, load_byte_U);
  type storeType is (store_word, Store_half, store_byte);

end package;