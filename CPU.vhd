library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CPU is
		generic (width  :     positive := 32);
		port ( 
			rst: in std_logic;
			clk	: in std_logic
			);			
end CPU ;

architecture  bhv of CPU  is
		
       signal IR_5downto0out :  std_logic_vector(5 downto 0);  
       signal PCWriteCond:  std_logic;
       signal PCWrite:  std_logic;
       signal IorD : std_logic;
       signal MemReadNotWrite:  std_logic;
      signal  IRWrite:  std_logic;
      signal  RegDst:  std_logic;
      signal  MemToReg:  std_logic;
      signal PC_load_en: std_logic;
      signal  regWrite:  std_logic;
      signal  ALU_src_B:  std_logic_vector(1 downto 0);
      signal  ALU_src_A:  std_logic;
       signal ALU_OP:  std_logic_vector(3 downto 0);
      signal  PC_Source:  std_logic_vector(1 downto 0);
      signal PC_or_ALU_MUX,memRegOut,sigExtd_out,Mux_A_PC_out,shifLeft_out1 : std_logic_vector(31 downto 0);
      signal MUX_ALU_or_IR,writeData,readData1,readData2,MUX_B_or_IR_OUT,IR26_shifted: std_logic_vector(31 downto 0);
      signal memoryOutPut,IR_out,PC_out,ALU_out,RegB_out,RegA_out,ALU_OUT_temp  : std_logic_vector(31 downto 0);
      signal  IR_MUX_OUT: std_logic_vector(4 downto 0);      
      signal Z,PC_inc : std_logic ;
begin


U_controller : entity work.controller
	
	port map(
		rst=>rst,
		clk	=> clk,
        IR_5downto0out =>IR_5downto0out,       
        PCWriteCond=>PCWriteCond,
		PCWrite=>PCWrite,        
        IorD =>IorD,
        MemReadNotWrite=>MemReadNotWrite,
        IRWrite=>IRWrite,
        RegDst=>RegDst,
        MemToReg=>MemToReg,
        regWrite=>regWrite,
        ALU_src_B=>ALU_src_B,
        ALU_src_A=>ALU_src_A,
        ALU_OP=>ALU_OP,
        PC_Source=>PC_Source,
        PC_load_en=>PC_load_en		
);


PC_inc <= PCWrite or (PCWriteCond and Z);

IR_5downto0out <= IR_out(31 downto 26);

U_PC : entity work.PC
	generic map (width=>32)
	port map(
		clk    =>clk,
        rst    =>rst,
		en   	=>PC_inc,
		load_en	=>PC_load_en,
		input =>MUX_ALU_or_IR,
        output => PC_out);


U_MUX_PC_or_ALU : entity work.mux2x1
	generic map (width=>32)
	port map(
		in1=>PC_out,
		in2=>ALU_out,		
		output=>PC_or_ALU_MUX,
		sel=> IorD
		);

U_MEMORY : entity work.memory	
	port map(
		address		=>PC_or_ALU_MUX(7 downto 0),
		clock		=>clk,
		data		=>RegB_out,
		wren		=>MemReadNotWrite,
		q			=>memoryOutPut		
);


U_IR: entity work.reg
generic map (width=>32)
port map (
		input=>memoryOutPut ,
		output=>IR_OUT,
		load =>IRWrite ,
		rst=> rst,
		clk => clk
);

U_IR_MUX : entity work.mux2x1
	generic map (width=>5)
	port map(
		in1=>IR_OUT(20 downto 16),
		in2=>IR_OUT(15 downto 11),		
		output=>IR_MUX_OUT,
		sel=>RegDst 
		);

U_REG_FILE: entity work.regFile
generic map (width => 32)
  port map(
    input    =>writeData,    
    outputA    =>readData1,
    outputB   =>readData2,
	wren   =>IRWrite,
	regASel=> IR_OUT(25 downto 21),
	regBSel=>IR_OUT(20 downto 16),
	writeRegSel=>IR_MUX_OUT,
	clk=>clk
 );



U_Mem_reg: entity work.reg
generic map (width=>32)
port map (
		input=>memoryOutPut ,
		output=>memRegOut,
		load =>'1' ,
		rst=> rst,
		clk => clk
);

U_MUX_MemReg_or_ALU : entity work.mux2x1
	generic map (width=>32)
	port map(
		in1=>ALU_out,
		in2=>memRegOut,		
		output=>writeData,
		sel=>memToReg 
		);
 
 U_A: entity work.reg
generic map (width=>32)
port map (
		input=>readData1 ,
		output=>regA_out,
		load =>'1' ,
		rst=> rst,
		clk => clk
);

U_B: entity work.reg
generic map (width=>32)
port map (
		input=> readData2,
		output=>RegB_out,
		load => '1',
		rst=> rst,
		clk => clk
);

U_SIGNRXTD: entity work.signExtend
generic map (width=>32)
port map (
		input=> IR_OUT(15 downto 0),
		output=>sigExtd_out		
);
 
 U_MUX_A_or_PC : entity work.mux2x1
	generic map (width=>32)
	port map(
		in1=>PC_out,
		in2=>RegA_out,		
		output=>Mux_A_PC_out,
		sel=>ALU_src_A 
		);
		
 U_MUX_B_or_IR : entity work.mux4x1
	generic map (width=>32)
	port map(
		in1=>RegB_out,
		in2=>x"00000004",
		in3=>sigExtd_out,
		in4=>shifLeft_out1,		
		output=>MUX_B_or_IR_OUT,
		sel=>ALU_src_B 
		);
	
U_ALU: entity work.ALU
 generic map (
	width => 32)
	port map(
		input1=>Mux_A_PC_out ,
		input2=>MUX_B_or_IR_OUT,
		output=>ALU_OUT_temp ,		
		zeroFlag=>z,		
		sel=>ALU_OP
		
	);
 
U_ALU_OUT: entity work.reg
generic map (width=>32)
port map (
		input=>ALU_OUT_temp ,
		output=>ALU_out,
		load =>'1' ,
		rst=> rst,
		clk=>clk
		);
	
 U_MUX_ALU_or_IR : entity work.mux4x1
	generic map (width=>32)
	port map(
		in1=>ALU_OUT_temp,
		in2=>ALU_out,
		in3=>IR26_shifted,
		in4=>x"00000000",		
		output=>MUX_ALU_or_IR,
		sel=>PC_Source 
		);
		
U_SHIFT_LEFT1 : entity work.shifLeft2
generic map (width => 32)
port map(
		input=>sigExtd_out ,
		output=>shifLeft_out1
);

U_SHIFT_LEFT2 : entity work.shifLeft2
generic map (width => 32)
port map(
		input=>"000000"&IR_out(25 downto 0) ,
		output=>IR26_shifted
);
		
end bhv;
