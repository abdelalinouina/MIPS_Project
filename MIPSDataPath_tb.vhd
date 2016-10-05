library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.MIPS_LIB.all;
use work.library_file.all;   -- Store_type and Load_type are defined here. 
							 --	To be deleted if you are using Std_logic



				-- The Test bench will Mimic the functionality of the controller in order to
				-- test the correct connectivity of your DataPath.
				-- You are expected to make the necessay adjustments in order this test bench 
				-- will interface correctly to your DataPath.  

entity MIPSDataPath_tb is 
end MIPSDataPath_tb;


architecture TB of MIPSDataPath_tb is

		
		signal clk			: std_logic:='0';
		signal clkEn		: std_logic:='1';		  
        signal rst			: std_logic:='0';
		signal regB_disable	: std_logic;            
        signal PCWriteCond	: std_logic; 
		signal PCWrite		: std_logic;         
		signal IorD 		: std_logic; 
		signal MemRead		: std_logic; 
		signal MemWrite		: std_logic; 
		signal IRWrite		: std_logic; 
        signal RegDst		: std_logic; 
        signal MemToReg		: std_logic; 
        signal regWrite		: std_logic; 
        signal ALUsrcB		: std_logic_vector(1 downto 0); 
        signal ALUsrcA		: std_logic; 
        signal ALUOP 		: std_logic_vector(5 downto 0);
        signal PCSource		: std_logic_vector(1 downto 0); 
        signal INPr0_en		: std_logic;
		signal INPr1_en		: std_logic;
		signal INPr1_Input  : std_logic_vector(31 downto 0);
		signal INPr0_Input  : std_logic_vector(31 downto 0);
		signal OUTPR0_data  : std_logic_vector(31 downto 0);
		signal OUTPR1_data  : std_logic_vector(31 downto 0);
		signal INPORT_Reset :std_logic;
		signal IR_31downto26out: std_logic_vector(5 downto 0);
		

begin

U_UUT : entity work.datapath	
	port map(

		-- You need to change the internal signals name to match your signals defintion
		rst=>rst,		
		clk	=> clk,
        IR_31downto26out =>IR_31downto26out,             
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
        INPr0_en=>INPr0_en,
        INPr1_en=>INPr1_en,
        INPr1_Input=> x"00000000",
        INPr0_Input=> x"00000000",
        OUTPR0_data =>OUTPR0_data,
		OUTPR1_data =>OUTPR1_data,
        INPORT_Reset=>'0',
        regB_disable=>'1', -- To be deleted if necessary.
        IsSigned =>'1',  	
        jumpAndLink =>'0'  -- This signals is used for the jump and link instruction. to be deleted if necessary.
        
        
        		
);

 clk <= not clk and clkEn after 20 ns;
 
process 


begin
		-- Initializing signals
		PCWriteCond <= '0';
		PCWrite <= '0';        
        IorD <= '0';
        MemRead <= '0';
        MemWrite <= '0';
        IRWrite <= '0';
        RegDst <= '0';
        MemToReg <= '1';
        regWrite <= '0';
        ALUsrcB <= "00";
        ALUsrcA <= '0';
        ALUOP <= add; -- Select Add operation. To be modified if necessary
        PCSource <= "00";
        
				rst <='1'; -- reset the program
			wait for 10 ns;
				rst <='0';
			wait until rising_edge(clk);

for i in 0 to 4 loop   -- This loop will load the values 1, 2, 3, 4,and 5 to $s1, $s2, $s2, $s3, and $s5 consecutively 
	memRead <='1';   	-- Read from the memory the data pointed by the program counter 
	PCWrite<='0';
	wait until rising_edge(clk);
	memRead <='0';
	IRWrite<='1';		-- Copy the memory data to IR. IR should be selecting the correct write register
	
	wait until rising_edge(clk);
	IRWrite<='0';	
	aluSRCA<='0';		-- The following 4 line will encrease PC by 4
	ALUSrcB<="01";
	PCWrite<='1';
	PCSource<="00";
wait until rising_edge(clk);
	
	PCWrite<='0';
wait until rising_edge(clk);	
	memRead <='1';   -- reading the data we want to store
	
wait until rising_edge(clk);
	memRead <='0';

wait until rising_edge(clk);
	regWrite <='1';  -- storing the data in the register selected by the IR
wait until rising_edge(clk);
	regWrite <='0';
	
		aluSRCA<='0';		-- The following 4 line will encrease PC by 4
		ALUSrcB<="01";
		PCWrite<='1';
		PCSource<="00";
			
wait until rising_edge(clk);
			PCWrite<='0';
wait until rising_edge(clk);

end loop;

	memRead <='1';  -- read the next instruction
					-- This instruction will multiply $s4 and $s5 and store the result in $LO and $HI.
					-- $LO = 0x14. $HI = 0
	PCWrite<='0';
	wait until rising_edge(clk);
	memRead <='0';
	IRWrite<='1';
	regDSt <='1';   -- R-Type
	
	wait until rising_edge(clk);
	IRWrite<='0';
	regDSt <='0';
	wait until rising_edge(clk);
	ALUSrcA<= '1';
	ALUSrcB<= "00";
	ALUOp <= r_type;   -- Select the R-type operation. to be modified if necessay
						-- Notice that the IR(5 downto 0) will decide the type of operation.
						-- In this case will be the multiplication.
	wait until rising_edge(clk);
	wait until rising_edge(clk);
	aluSRCA<='0';		-- The following 5 line will encrease PC by 4
		ALUOp <= add;
		ALUSrcB<="01";
		PCWrite<='1';
		PCSource<="00";
	wait until rising_edge(clk);
		
		
	PCWrite<='0';
	wait until rising_edge(clk);
	memRead <='1';   -- read the next instruction
	wait until rising_edge(clk);
	memRead <='0';
	wait until rising_edge(clk);
	IRWrite<='1';		-- copy to IR
						-- This instruction will move $LO to $s6
	wait until rising_edge(clk);
	IRWrite<='0';
	wait until rising_edge(clk);
	memToReg <='0';     
	ALUOp <= R_TYPE;		-- R-Type. To be modified if necessary.
							-- Notice that the IR(5 downto 0) will decide the type of operation.
							-- In this case will be the Move from $LO.
	wait until rising_edge(clk);
	RegWrite<='1';
	wait until rising_edge(clk);
	RegWrite<='0';
	wait until rising_edge(clk);
	IRWrite<='0';	
	aluSRCA<='0';		-- The following 4 line will encrease PC by 4
	ALUSrcB<="01";
	PCWrite<='1';
	PCSource<="00";
wait until rising_edge(clk);
	
	PCWrite<='0';
wait until rising_edge(clk);	
	memRead <='1';   -- reading the data we want to store
	
wait until rising_edge(clk);
	memRead <='0';

wait until rising_edge(clk);
	regWrite <='1';  -- storing the data in the register selected by the IR
wait until rising_edge(clk);
	regWrite <='0';
wait until rising_edge(clk);	
		aluSRCA<='0';		-- The following 5 line will encrease PC by 4
		ALUOp <= add;
		ALUSrcB<="01";
		PCWrite<='1';

		PCSource<="00";
	
	
	wait until rising_edge(clk);
	
	PCWrite<='0';
	memRead <='1';   -- read the next instruction
	wait until rising_edge(clk);
	memRead <='0';
	wait until rising_edge(clk);
	IRWrite<='1';		-- copy to IR
						-- This instruction will move $LO to $s6
	wait until rising_edge(clk);
	IRWrite<='0';
wait until rising_edge(clk);
	aluSRCA<='0';
	IorD <='1';
	MemWrite<='1';
wait until rising_edge(clk);
	IorD <='0';
	MemWrite<='0';

	
	
	wait until rising_edge(clk);
	wait until rising_edge(clk);
	wait until rising_edge(clk);
	wait until rising_edge(clk);
clkEn <= '0';	
wait; 
end process;



end TB;