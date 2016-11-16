library ieee;
use ieee.std_logic_1164.all;
package MIPS_LIB is

-----------------------------------------------------------------------
--Constants for ALU Operation signals----------------------------------

constant add 		: std_logic_vector(5 downto 0):= "100001";
constant sub_op 	: std_logic_vector(5 downto 0):= "100011";
constant mult_s		: std_logic_vector(5 downto 0):= "011000";
constant mult_U 	: std_logic_vector(5 downto 0):= "011001";
constant and_op 	: std_logic_vector(5 downto 0):= "100100";
constant or_op 		: std_logic_vector(5 downto 0):= "100101";
constant xor_op 	: std_logic_vector(5 downto 0):= "100110";
constant sh_ri 		: std_logic_vector(5 downto 0):= "000010";
constant sh_lf		: std_logic_vector(5 downto 0):= "000000";
constant sh_ri_ar	: std_logic_vector(5 downto 0):= "000011";
constant set_s 		: std_logic_vector(5 downto 0):= "101010";
constant set_u 		: std_logic_vector(5 downto 0):= "101011";
constant beq 		: std_logic_vector(5 downto 0):= "000100";
constant bne 		: std_logic_vector(5 downto 0):= "000101";
constant blez 		: std_logic_vector(5 downto 0):= "000110";
constant bgtz 		: std_logic_vector(5 downto 0):= "000111";
constant bltz 		: std_logic_vector(5 downto 0):= "000001";
constant bgez 		: std_logic_vector(5 downto 0):= "001000";
constant out_A		: std_logic_vector(5 downto 0):= "001111";
constant out_B 		: std_logic_vector(5 downto 0):= "001110";
constant R_type 	: std_logic_vector(5 downto 0):= "111111";
end MIPS_LIB;