library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;

entity datapath is
		generic (width  :     positive := 32);
		port 	(rst	: 	  in std_logic;
				 INPr0_en: 	  in std_logic;
				 INPr1_en: 	  in std_logic;
				 INPr1_Input : in std_logic_vector(31 downto 0);
				 INPr0_Input : in std_logic_vector(31 downto 0);
				 OUTPR0_data :out std_logic_vector(31 downto 0);
				 OUTPR1_data :out std_logic_vector(31 downto 0);
				 INPORT_Reset	: 	  in std_logic;
				 clk	: 	  in std_logic;
				 regB_disable : in std_logic;
				 PCWrite : in std_logic;
				 PCWriteCond : in std_logic;
				 IsSigned : in std_logic;        
				IorD :in std_logic;
				MemRead,MemWrite: in std_logic;
				IRWrite: in std_logic;
				RegDst: in std_logic;
				MemToReg: in std_logic;
				regWrite,jumpAndLink: in std_logic;
				ALUsrcB: in std_logic_vector(1 downto 0);
				ALUsrcA: in std_logic;
				ALUOP: in std_logic_vector(5 downto 0);
				PCSource: in std_logic_vector(1 downto 0);
				
				--regB_disable: in std_logic;
				
						 IR_31downto26out : out std_logic_vector(5 downto 0)
						 
				 	);			
end datapath ;

architecture  bhv of datapath  is
		
     -- signal IR_5downto0out :  std_logic_vector(5 downto 0); 
      --signal regB_disable	: std_logic; 
    signal IR20down16:  std_logic_vector(4 downto 0); 
     -- signal PCWriteCond:  std_logic;
     -- signal PCWrite:  std_logic;
     -- signal IorD,OUTPr0_en,OUTPr1_en : std_logic;
     -- signal MemWrite,MemRead:  std_logic;
      --signal IRWrite:  std_logic;
      --signal RegDst:  std_logic;
      signal Load_LO,Load_HI:  std_logic;
      signal PC_load_en: std_logic;
      --signal regWrite,jumpAndLink:  std_logic;
      signal ALU_sel : std_logic_vector(5 downto 0);
      --signal Load_type : loadType;
      --signal store_type : storeType;
      --signal ALU_src_B,memToReg2,ALU_LO_HI_sel:  std_logic_vector(1 downto 0);
      --signal ALU_src_A,memToReg : std_logic;
      --signal ALU_OP:  std_logic_vector(4 downto 0);
      signal LO_HI_sel,ALU_LO_HI_sel:  std_logic_vector(1 downto 0);
      signal PC_or_ALU_MUX,memRegOut,sigExtd_out,Mux_A_PC_out,shifLeft_out1,LO_out,HI_out,to_HI,Address_decoder_output,to_write_MUX : std_logic_vector(31 downto 0);
      signal MUX_ALU_or_IR,writeData,readData1,readData2,MUX_B_or_IR_OUT,IR26_shifted,memRegDecoder_output: std_logic_vector(31 downto 0);
      signal memoryOutPut,IR_out,PC_out,ALU_out,RegB_out,RegA_out,inport0_reg,inport1_reg,ALU_OUT_temp,shift_left_input,RegB_out_mem  : std_logic_vector(31 downto 0);
      signal IR_MUX_OUT: std_logic_vector(4 downto 0);      
      signal Branch,Ram_wr_en,Ram_rd_en : std_logic ;
      signal address_out : std_Logic_vector(7 downto 0);
      signal OUTPr0_en,OUTPr1_en : std_logic;
begin




PC_load_en <= PCWrite or (PCWriteCond and Branch);

IR_31downto26out <= IR_out(31 downto 26);
IR20down16	<=IR_out(20 downto 16);


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
		address		=>address_out,
		clock		=>clk,
		data		=>RegB_out,
		wren		=>Ram_wr_en,
		rden 		=> MemRead,
		q			=>memoryOutPut
);


U_IR: entity work.reg
generic map (width=>32)
port map (
		input=>Address_decoder_output ,
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
    input=>writeData,    
    outputA=>readData1,
    outputB =>readData2,
	wren =>RegWrite ,
	regASel=> IR_OUT(25 downto 21),
	regBSel=>IR_OUT(20 downto 16),
	writeRegSel=>IR_MUX_OUT,
	jumpAndLink=>jumpAndLink,
	clk=>clk,
	rst=> rst		

 );



U_Mem_reg: entity work.reg
generic map (width=>32)
port map (
		input=>Address_decoder_output ,
		output=>memRegOut,
		load =>'1' ,
		rst=> rst,
		clk => clk
);

U_INPORT0: entity work.reg
generic map (width=>32)
port map (
		input=>INPr0_Input ,
		output=>inport0_reg,
		load =>INPr0_en ,
		rst=> INPORT_Reset,
		clk => clk
);

U_INPORT1: entity work.reg
generic map (width=>32)
port map (
		input=>INPr1_Input ,
		output=>inport1_reg,
		load =>INPr1_en ,
		rst=> INPORT_Reset,
		clk => clk
);

U_OUTPORT0: entity work.reg
generic map (width=>32)
port map (
		input=>RegB_out_mem ,
		output=>OUTPR0_data,
		load =>OUTPr0_en ,
		rst=> rst ,
		clk => clk
);

U_OUTPORT1: entity work.reg
generic map (width=>32)
port map (
		input=>RegB_out_mem ,
		output=>OUTPR1_data,
		load =>OUTPr1_en ,
		rst=> rst,
		clk => clk
);

U_ADDRESS_DECODER : entity work.address_decoder


port map (

		clk=>clk,
		rst=>rst,
		address=>PC_or_ALU_MUX,
		inport1=> inport1_reg,
		inport0=>inport0_reg,
		ram_input=>memoryOutPut,
		
		wr_en=>MemWrite,
		rd_en=>MemRead,
		outport1_en=>OUTPr1_en,
		outport0_en=>OUTPr0_en,
		 Ram_wr_en=>Ram_wr_en,
		 Ram_rd_en=>Ram_rd_en,
		output=>Address_decoder_output,
		address_out=>address_out

);

		
--U_memRegDecoder : entity work.memRegDecoder
--	generic map (width=>32)
--	port map(
--		input=>memRegOut,				
--		output=>memRegDecoder_output,
--		sel=>Load_type 
--		);

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
		load => regB_disable,
		rst=> rst,
		clk => clk
);


--U_regBDecoder : entity work.regBDecoder
--	generic map (width=>32)
--	port map(
--		input=>RegB_out,					
--		output=>RegB_out_mem,
--		sel=>store_type 
--		);

U_SIGNRXTD: entity work.signExtend
generic map (width=>32)
port map (
		input=> IR_OUT(15 downto 0),
		IsSigned=>IsSigned,
		output=>sigExtd_out		
);
 
 U_MUX_A_or_PC : entity work.mux2x1
	generic map (width=>32)
	port map(
		in1=>PC_out,
		in2=>RegA_out,		
		output=>Mux_A_PC_out,
		sel=>ALUsrcA 
		);
		
 U_MUX_B_or_IR : entity work.mux4x1
	generic map (width=>32)
	port map(
		in1=>RegB_out,
		in2=>x"00000004",
		in3=>sigExtd_out,
		in4=>shifLeft_out1,		
		output=>MUX_B_or_IR_OUT,
		sel=>ALUSrcB 
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
	ALUOp=>ALUOP,
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
		sel=>PCSource 
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
