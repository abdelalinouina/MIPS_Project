library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end cpu_tb ;

architecture TB of cpu_tb is 
signal clk : std_logic:='0';
signal rst,rst_peripheral: std_logic;
signal INPr0_en,INPr1_en : std_logic;
signal INPr1_Input, INPr0_Input: std_logic_vector(31 downto 0);

begin


INPr1_Input<=x"00000002";
INPr0_Input<=x"00000003";
	
UUT: entity work.cpu
		port map (
				clk =>clk,
				rst=>rst,
				rst_peripheral=>rst_peripheral,
				INPr0_en=>INPr0_en,
				INPr1_en=>INPr1_en,
				INPr1_Input=>INPr1_Input,
				INPr0_Input=>INPr0_Input
				
				);	
	

 
 CLK<= not clk after 10 ns;
 
process 
begin
rst       <= '1';
INPr1_en  <='1';
INPr0_en  <='1';
wait for 10 ns;
rst       <= '0';	
wait; 
end process;
--process
--
--begin
--rst       <= '1';
--wait for 30 ns;
--rst       <= '0';
--clk <='1';
--wait for 30 ns;
--for i in 0 to 30 loop
--clk <= not clk;
--wait for 30 ns;
--end loop;
--
--end process;	

	
	end TB;