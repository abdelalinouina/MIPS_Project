library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;

entity CPU is
		generic (width  :     positive := 32);
		port ( 
			rst: in std_logic;
			clk	: in std_logic
			);			
end CPU ;

architecture  bhv of CPU  is
		
       signal IR_5downto0out :  std_logic_vector(5 downto 0);  
       signal IR20down16:  std_logic_vector(4 downto 0); 
       signal PCWriteCond:  std_logic;
       signal PCWrite:  std_logic;
       signal IorD : std_logic;
       signal MemWrite,MemRead:  std_logic;
      signal  IRWrite:  std_logic;
      signal  RegDst:  std_logic;
      signal  Load_LO,Load_HI:  std_logic;
      signal PC_load_en: std_logic;
      signal  regWrite,jumpAndLink:  std_logic;
      signal ALU_sel : functions;
      signal Load_type : loadType;
      signal store_type : storeType;
      signal  ALU_src_B,memToReg2,ALU_LO_HI_sel:  std_logic_vector(1 downto 0);
      signal  ALU_src_A,memToReg : std_logic;
       signal ALU_OP:  std_logic_vector(4 downto 0);
      signal  PC_Source,LO_HI_sel:  std_logic_vector(1 downto 0);
      signal PC_or_ALU_MUX,memRegOut,sigExtd_out,Mux_A_PC_out,shifLeft_out1,LO_out,HI_out,to_HI,to_write_MUX : std_logic_vector(31 downto 0);
      signal MUX_ALU_or_IR,writeData,readData1,readData2,MUX_B_or_IR_OUT,IR26_shifted,memRegDecoder_output: std_logic_vector(31 downto 0);
      signal memoryOutPut,IR_out,PC_out,ALU_out,RegB_out,RegA_out,ALU_OUT_temp,shift_left_input,RegB_out_mem  : std_logic_vector(31 downto 0);
      signal  IR_MUX_OUT: std_logic_vector(4 downto 0);      
      signal Branch,PC_inc : std_logic ;
begin


U_controller : entity work.controller
	
	port map(
		rst=>rst,
		clk	=> clk,
        IR_5downto0out =>IR_5downto0out, 
        IR20down16=>IR20down16,      
        PCWriteCond=>PCWriteCond,
		PCWrite=>PCWrite,        
        IorD =>IorD,
        PC_inc=>PC_inc,
        MemRead=>MemRead,
        MemWrite=>MemWrite,
        IRWrite=>IRWrite,
        RegDst=>RegDst,
        MemToReg=>memToReg,
        regWrite=>regWrite,
        ALUsrcB=>ALU_src_B,
        ALUsrcA=>ALU_src_A,
        ALUOP=>ALU_OP,
        PCSource=>PC_Source,
        Load_type=>Load_type,
        store_type=> store_type,
        jumpAndLink=>jumpAndLink
        		
);


PC_load_en <= PCWrite or (PCWriteCond and Branch);

IR_5downto0out <= IR_out(31 downto 26);
IR20down16	<=IR_out(20 downto 16);
--U_PC : entity work.PC
--	generic map (width=>32)
--	port map(
--		clk    =>clk,
--        rst    =>rst,
--		en   	=>PC_inc,
--		load_en	=>PC_load_en,
--		input =>MUX_ALU_or_IR,
--        output => PC_out);

U_PC: entity work.reg
generic map (width=>32)
port map (
		input=>MUX_ALU_or_IR ,
		output=>PC_out,
		load =>PC_load_en ,
		rst=> rst,
		clk => clk
);

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
		data		=>RegB_out_mem,
		wren		=>MemWrite,
		rden 		=> MemRead,
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
	wren   =>RegWrite ,
	regASel=> IR_OUT(25 downto 21),
	regBSel=>IR_OUT(20 downto 16),
	writeRegSel=>IR_MUX_OUT,
	jumpAndLink=>jumpAndLink,
	clk=>clk,
	rst 		=> rst		

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


		
U_memRegDecoder : entity work.memRegDecoder
	generic map (width=>32)
	port map(
		input=>memRegOut,		
				
		output=>memRegDecoder_output,
		sel=>Load_type 
		);

U_MUX_MemReg_or_ALU : entity work.mux2x1
	generic map (width=>32)
	port map(
		in1=>ALU_out,
		in2=>memRegDecoder_output,
				
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
 U_LO: entity work.reg
generic map (width=>32)
port map (
		input=>ALU_OUT_temp ,
		output=>LO_out,
		load =>Load_LO ,
		rst=> rst,
		clk => clk
);
 U_HI: entity work.reg
generic map (width=>32)
port map (
		input=>to_HI ,
		output=>HI_out,
		load =>load_HI ,
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


U_regBDecoder : entity work.regBDecoder
	generic map (width=>32)
	port map(
		input=>RegB_out,		
				
		output=>RegB_out_mem,
		sel=>store_type 
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
	
	 U_MUX_ALU_LO_HI : entity work.mux4x1
	generic map (width=>32)
	port map(
		in1=>ALU_OUT_temp,
		in2=>LO_out,
		in3=>Hi_out,
		in4=>x"00000000",		
		output=>to_write_MUX,
		sel=>ALU_LO_HI_sel 
		);
	
	
U_ALU: entity work.ALU
 generic map (
	width => 32)
	port map(
		input1=>Mux_A_PC_out ,
		input2=>MUX_B_or_IR_OUT,
		IR_shift_bits=>IR_out(10 downto 6),
		output=>ALU_OUT_temp ,
		output_HI => to_HI,		
		Branch=>Branch,		
		sel=>ALU_sel
		
	);
U_ALUControl: entity work.alu_control
	port map (
	IR5downto0=>IR_OUT(5 downto 0),
	ALUOp=>ALU_OP,
	Load_LO=>Load_LO,
	Load_HI=>Load_HI,
	ALU_LO_HI_sel=>ALU_LO_HI_sel,
	Sel=>ALU_sel
	
	);

U_ALU_OUT: entity work.reg
generic map (width=>32)
port map (
		input=>to_write_MUX ,
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
shift_left_input<="000000"&IR_out(25 downto 0);
U_SHIFT_LEFT2 : entity work.shifLeft2
generic map (width => 32)
port map(
		input=>shift_left_input ,
		output=>IR26_shifted
);
		
end bhv;
