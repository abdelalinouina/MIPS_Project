
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity top_level is
    port (
		
        switches  : in  std_logic_vector(7 downto 0);
        button  : in  std_logic_vector(2 downto 0);
        led0    : out std_logic_vector(6 downto 0);
       -- led0_dp : out std_logic;
        led1    : out std_logic_vector(6 downto 0);
      --  led1_dp : out std_logic;
        led2    : out std_logic_vector(6 downto 0);
     --   led2_dp : out std_logic;
        led3    : out std_logic_vector(6 downto 0);
     --   led3_dp : out std_logic;
          clk		: in std_logic;
          rst_peripheral : in std_logic
       );
end top_level;

architecture STR of top_level is

    component decoder7seg
        port (
            input  : in  std_logic_vector(3 downto 0);
            output : out std_logic_vector(6 downto 0));
    end component;

    

    signal outport1    : std_logic_vector(15 downto 0);
    signal outport0    : std_logic_vector(15 downto 0);
   
    signal done_signal   : std_logic;
    signal rst_signal   : std_logic;
    signal inport0_en_sig,inport1_en_sig,rst_input_sig : std_logic;
	
    constant C0 : std_logic_vector(3 downto 0) := "0000";
    
begin  -- STR

    -- map adder output to two leftmost LEDs
    U_LED3 : decoder7seg port map (
        input  => outport1(15 downto 12),
        output => led3);

    U_LED2 : decoder7seg port map (
        input  => outport1(11 downto 8),
        output => led2);

    U_LED1 : decoder7seg port map (
        input  => outport1(7 downto 4),
        output => led1);

    U_LED0 : decoder7seg port map (
        input  => outport1(3 downto 0),
        output => led0);

   
    

    -- instantiate adder (has to be eight bits for this top-level file)
U_cpu : entity work.cpu
	generic map (width=>32)
	port map(
		clk		=>clk,
		rst		=>rst_signal,
		rst_peripheral		=>rst_peripheral,
		INPr1_Input(7 downto 0)		=>switches(7 downto 0),
		INPr1_Input(31 downto 8)	=>std_logic_vector(to_unsigned(0,24)),
		
		INPr0_Input(7 downto 0)		=>switches(7 downto 0),
		INPr0_Input(31 downto 8)	=>std_logic_vector(to_unsigned(0,24)),
		--OUTPR0_data(15 downto 0)			=>outport0,
		OUTPR1_data(15 downto 0)			=>outport1,
		INPr0_en =>inport0_en_sig,
		INPr1_en =>inport1_en_sig
		
);

  
   
     rst_signal <= not button(0);
inport0_en_sig  <=  not button(2);
inport1_en_sig  <=  not button(1);


    -- show 6th sum bit (actual carry out) on led2 dp
  

end STR;


