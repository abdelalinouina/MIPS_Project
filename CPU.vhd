library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.library_file.all;

entity CPU is 
generic (width  :     positive := 32);
		port 	(rst	: 	  in std_logic;
				 INPr0_en: 	  in std_logic;
				 INPr1_en: 	  in std_logic;
				 INPr1_Input : in std_logic_vector(31 downto 0);
				 INPr0_Input : in std_logic_vector(31 downto 0);
				 OUTPR0_data :out std_logic_vector(31 downto 0);
				 OUTPR1_data :out std_logic_vector(31 downto 0);
				 rst_peripheral	: 	  in std_logic;
				 clk	: 	  in std_logic	);

end CPU;


Architecture bhv of CPU is 




		signal regB_disable: std_logic; 
	
       signal IR_31downto26out :std_logic_vector(5 downto 0); 
       signal IR20down16: std_logic_vector(4 downto 0);      
        signal PCWriteCond: std_logic; 
		signal PCWrite: std_logic;         
       signal  IorD : std_logic; 
      signal   MemRead: std_logic; 
      signal   MemWrite: std_logic; 
     signal    IRWrite: std_logic; 
       signal  RegDst: std_logic; 
       signal  MemToReg: std_logic; 
       signal  regWrite: std_logic; 
       signal  ALUsrcB: std_logic_vector(1 downto 0); 
      signal   ALUsrcA: std_logic; 
      signal   ALUOP : std_logic_vector(5 downto 0);
      signal   PCSource: std_logic_vector(1 downto 0); 
--      signal   Load_type: loadType;
--       signal  store_type: storeType;
       signal  jumpAndLink : std_logic;
       signal IsSigned : std_logic;


begin 


U_controller : entity work.controller	
	port map(
		rst=>rst,
		regB_disable=>regB_disable,
		clk	=> clk,
        IR_5downto0out =>IR_31downto26out, 
        IR20down16=>IR20down16,      
        PCWriteCond=>PCWriteCond,
		PCWrite=>PCWrite,        
        IorD =>IorD,
        MemRead=>MemRead,
        MemWrite=>MemWrite,
        IRWrite=>IRWrite,
        RegDst=>RegDst,
        MemToReg=>memToReg,
        regWrite=>regWrite,
        ALUsrcB=>ALUsrcB,
        ALUsrcA=>ALUsrcA,
        ALUOP=>ALUOP,
        PCSource=>PCSource,
--        Load_type=>Load_type,
--        store_type=> store_type,
        IsSigned=>IsSigned,
        jumpAndLink=>jumpAndLink
        		
);
U_DATAPATH : entity work.datapath	
	port map(
		rst=>rst,
		regB_disable=>regB_disable,
		clk	=> clk,
        IR_31downto26out =>IR_31downto26out, 
        --IR20down16=>IR20down16,      
        PCWriteCond=>PCWriteCond,
		PCWrite=>PCWrite,        
        IorD =>IorD,
        MemRead=>MemRead,
        MemWrite=>MemWrite,
        IRWrite=>IRWrite,
        RegDst=>RegDst,
        MemToReg=>memToReg,
        regWrite=>regWrite,
        ALUsrcB=>ALUsrcB,
        ALUsrcA=>ALUsrcA,
        ALUOP=>ALUOP,
        PCSource=>PCSource,
--        Load_type=>Load_type,
--        store_type=> store_type,
        IsSigned=>IsSigned,
        jumpAndLink=>jumpAndLink,
        
        
				 INPr0_en=>INPr0_en,
				 INPr1_en=>INPr1_en,
				 INPr1_Input =>INPr1_Input,
				 INPr0_Input=>INPr0_Input,
				 OUTPR0_data =>OUTPR0_data,
				 OUTPR1_data =>OUTPR1_data,
				 INPORT_Reset	=>rst_peripheral
				 
        		
);


end bhv;