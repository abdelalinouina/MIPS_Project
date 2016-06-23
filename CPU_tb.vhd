library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu_tb is
end cpu_tb ;

architecture TB of cpu_tb is 
signal clk : std_logic:='0';
signal rst: std_logic;
begin
	
UUT: entity work.cpu
		port map (
				clk =>clk,
				rst=>rst
				);	
	

 
 CLK<= not clk after 10 ns;
 
process 
begin
rst       <= '1';
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