library ieee;
use ieee.std_logic_1164.all;
use work.library_file.all;

entity address_decoder is

	port(
		address: in std_logic_vector(31 downto 0);
		inport1, inport0, ram_input: in std_logic_vector(31 downto 0);
		
		wr_en,rd_en: in std_logic;
		outport1_en,outport0_en, Ram_wr_en,Ram_rd_en: out  std_logic;
		output: out std_logic_vector(31 downto 0);
		address_out: out std_logic_vector(7 downto 0);
		clk,rst : in std_logic
	);
end address_decoder;

architecture BHV of address_decoder is 
signal state, next_state: state_type;
begin

process(clk,rst)
	begin
		if (rst='1') then
		state<=s_dec_Init;
		elsif (rising_edge(clk)) then
		state<=next_state;
		end if ;
	end process;
	
process(address,state,ram_input,inport0,inport1, wr_en,rd_en)
	begin
address_out<=address(7 downto 0);
Ram_wr_en<='0';
Ram_rd_en <='1';
outport0_en<='0';
outport1_en<='0';
output<=ram_input;
next_state <= s_dec_init;
case state is 
when s_dec_init =>
	
	next_state <= s_dec_init;

if (address(31 downto 8)=x"000000" and wr_en='1') then 
	
	Ram_wr_en <='1';
	Ram_rd_en <='0';
end if ;

if (address(31 downto 0)=x"0000FFFE" and wr_en='1') then 
	
	next_state <= s_dec_init4;
	
end if ;

if (address(31 downto 0)=x"0000FFFF" and wr_en='1') then 
	
	next_state <= s_dec_init5;
end if ;

if (address(31 downto 8)=x"000000" and rd_en='1') then 
	
	output <=ram_input(31 downto 0);
end if ;

if (address(31 downto 0)=x"0000FFFE"  and rd_en='1') then 
	next_state <= s_dec_init2;
	
	
end if ;

if (address(31 downto 0)=x"0000FFFF"  and rd_en='1') then 
	next_state <= s_dec_init3;
	--output <=inport1;
end if ;

when s_dec_init2 =>
	
	next_state <= s_dec_init;
	output <=inport0;
	
when s_dec_init3 =>
	
	next_state <= s_dec_init;
	output <=inport1;
	
when s_dec_init4 =>
	
	next_state <= s_dec_init;
	outport0_en<='1';
when s_dec_init5 =>
	
	next_state <= s_dec_init;
	outport1_en<='1';
	--output <=inport1;
	
when others =>null;
end case;
	end process;
	

	
	end BHV;
	