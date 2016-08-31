-- Greg Stitt
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Alu_tb is
end Alu_tb;


architecture TB of Alu_tb is

    component ALU
        generic (
            WIDTH : positive := 8);
        port (			
			input1 : in std_logic_vector(WIDTH-1 downto 0);
			input2 : in std_logic_vector(WIDTH-1 downto 0);			
			sel : in std_logic_vector(3 downto 0);
			output : out std_logic_vector(WIDTH-1 downto 0);			
			zeroFlag: out std_logic);
    end component;

    constant TEST_WIDTH  : positive := 8;
    constant range_tb	: positive:=255;
   

    signal in1,in2             : std_logic_vector(TEST_WIDTH-1 downto 0);    
    
   signal outPut_sig 		   : std_logic_vector(TEST_WIDTH-1 downto 0);
   signal sel					: std_logic_vector(3 downto 0);
   
	
begin  -- TB

    U_ALU : ALU
        generic map (
            WIDTH => TEST_WIDTH)
        port map (
            input1    =>in1,
            input2    => in2,
            carryIn  => carry_in,
            carryFlag    => carryout,
           
            sel=>sel,
            output=>output_sig,
            signFlag=>s,
            
            zeroFlag=>z
            );

    
    process
        variable error_Sum        : integer;
        variable error_sum_carry        : integer;
        variable error_Subtraction        : integer;
        variable error_Subtraction_OverFlow        : integer;
        variable error_h         : integer;
        variable result_tmp      : unsigned(TEST_WIDTH downto 0);
        variable result_tmp_for_sub      : unsigned(TEST_WIDTH downto 0);
        variable temp_result  : std_logic_vector(TEST_WIDTH-1 downto 0);
        variable temp_result4  : std_logic_vector(2*TEST_WIDTH-1 downto 0);
        variable temp_result5: integer:=1;
        variable correct_result  : std_logic_vector(TEST_WIDTH-1 downto 0);
        
        variable correct_cout    : std_logic;
        variable score_rc  : integer;
        variable score_cla : integer;
        variable score_h,error_AND, error_zero  : integer;
        
        variable error_XOR  : integer;
        variable error_OR,error_shift_left,error_shift_right,error_sign   : integer;
    begin
		error_AND:=0;
		error_XOR:=0;
		error_OR:=0;
        error_sum_carry := 0;
        error_Sum := 0;
        error_Subtraction := 0;
       
        error_shift_left:=0;
        error_shift_right:=0;      
       error_zero:=0;
       error_sign:=0;
       

        for i in 0 to range_tb loop

            in1 <= std_logic_vector(to_unsigned(i, TEST_WIDTH));

            for j in 0 to  range_tb loop

                in2 <= std_logic_vector(to_unsigned(j, TEST_WIDTH));
				sel<="0000";
                for k in 0 to 1 loop
---------------------Testing Addition-----------------------------------------------------------------
                    carry_in <= std_logic(to_unsigned(k, 1)(0));
					
					
                    wait for 10 ns;
					
				
                    result_tmp     := unsigned("0"&in1) + unsigned("0"&in2) + to_unsigned(k, 1);
                    correct_result := std_logic_vector(result_tmp(TEST_WIDTH-1 downto 0));
                    correct_cout   := std_logic(result_tmp(TEST_WIDTH));

                    if (output_sig /= correct_result) then
                        error_Sum :=error_Sum+1;
                        report "Error Addition , " & integer'image(i) & " + " & integer'image(j) & " + " & integer'image(k) & " = " & integer'image(to_integer(unsigned(output_sig))) severity warning;
                    end if;
                    if ((correct_result=std_logic_vector(to_unsigned(0,test_width)) and z/='1')) then
                        error_zero :=error_zero+1;
                        report "Error zero , "  severity warning;
                      if (correct_result(test_width-1)/=s) then
                        error_sign :=error_sign+1;
                       report "Error sign , "  severity warning;
                        end if;
                    end if;
                    if (carryout /= correct_cout) then
                        error_sum_carry :=error_sum_carry+1;
                        report "Error , Addition carry from " & integer'image(i) & " + " & integer'image(j) & " + " & integer'image(k) & " = " & std_logic'image(carryout) severity warning;
                    end if;
			end loop;  -- k
---------------------Testing Subtraction-----------------------------------------------------------------                    
					wait for 10 ns;
					
					sel<="0001";
					for k in 0 to 1 loop
					carry_in <= std_logic(to_unsigned(k, 1)(0));
                    wait for 10 ns;
					
				if (k=0) then
                    result_tmp_for_sub     := unsigned("0"&in1) +  unsigned(not("0"&in2)) - 1;
                    else
					result_tmp_for_sub     := unsigned("0"&in1) +  unsigned(not("0"&in2)) ;
			end if;
                    correct_result := std_logic_vector(result_tmp_for_sub(TEST_WIDTH-1 downto 0));
                    if (output_sig /= correct_result) then
                        error_Subtraction :=error_Subtraction+1;
                        report "Error , Subtraction " & integer'image(i) & " - " & integer'image(j) & " - " & integer'image(k) & " = " & integer'image(to_integer(unsigned(output_sig))) severity warning;
                    end if;
                    if ((correct_result=std_logic_vector(to_unsigned(0,test_width)) and z/='1')) then
                        error_zero :=error_zero+1;
                        report "Error zero , "  severity warning;
                        end if;
                        if (correct_result(test_width-1)/=s) then
                        error_sign :=error_sign+1;
                       report "Error sign , "  severity warning;
                        end if;
                    
			end loop;  -- k



---------------------Testing AND-----------------------------------------------------------------                    
					wait for 10 ns;					
					sel<="0011";					
                    wait for 10 ns;				
                    temp_result     := in1 and in2;           
					if ((temp_result=std_logic_vector(to_unsigned(0,test_width)) and z/='1')) then
                        error_zero :=error_zero+1;
                        report "Error zero , "  severity warning;
                        end if;
                     if (temp_result(test_width-1)/=s) then
                        error_sign :=error_sign+1;
                       report "Error sign , "  severity warning;
                        end if;
                    if (output_sig /= temp_result) then
                        error_AND :=error_AND+1;
                        report "Error , AND " & integer'image(i) & " AND " & integer'image(j) & " = " & integer'image(to_integer(unsigned(output_sig))) severity warning;
                    end if;
      
---------------------Testing OR-----------------------------------------------------------------                    
					wait for 10 ns;					
					sel<="0100";					
                    wait for 10 ns;				
                    temp_result     := in1 OR in2;           
					if ((temp_result=std_logic_vector(to_unsigned(0,test_width)) and z/='1')) then
                        error_zero :=error_zero+1;
                        report "Error zero , "  severity warning;
                        end if;
                      if (temp_result(test_width-1)/=s) then
                        error_sign :=error_sign+1;
                       report "Error sign , "  severity warning;
                        end if;
                    if (output_sig /= temp_result) then
                        error_OR :=error_OR+1;
                        report "Error , OR " & integer'image(i) & " OR " & integer'image(j) & " = " & integer'image(to_integer(unsigned(output_sig))) severity warning;
                    end if;
          
---------------------Testing XOR-----------------------------------------------------------------                    
					wait for 10 ns;					
					sel<="0101";					
                    wait for 10 ns;				
                    temp_result     := in1 XOR in2;           
					if ((temp_result=std_logic_vector(to_unsigned(0,test_width)) and z/='1')) then
                        error_zero :=error_zero+1;
                        report "Error zero , "  severity warning;
                        end if;
                        if (temp_result(test_width-1)/=s) then
                        error_sign :=error_sign+1;
                       report "Error sign , "  severity warning;
                        end if;
                    if (output_sig /= temp_result) then
                        error_XOR :=error_XOR+1;
                        report "Error , XOR " & integer'image(i) & " XOR " & integer'image(j) & " = " & integer'image(to_integer(unsigned(output_sig))) severity warning;
                    end if;
---------------------Testing shift left-----------------------------------------------------------------                    
					wait for 10 ns;					
					sel<="0110";					
                    wait for 10 ns;
                    if (to_integer(unsigned(in2))<8) then					
                    temp_result4     := std_logic_vector(unsigned(in1)*(2**to_integer(unsigned(in2)))) ;           
					temp_result:=temp_result4(TEST_WIDTH-1 downto 0);
					if ((temp_result=std_logic_vector(to_unsigned(0,test_width)) and z/='1')) then
                        error_zero :=error_zero+1;
                        report "Error zero , "  severity warning;
                        end if;
                       if (temp_result(test_width-1)/=s) then
                        error_sign :=error_sign+1;
                       report "Error sign , "  severity warning;
                        end if;
                    if (output_sig /= temp_result) then
                        error_shift_left :=error_shift_left+1;
                        report "Error , shift left " & integer'image(i) & " left shifted is "  & integer'image(to_integer(unsigned(output_sig))) severity warning;
                    end if;               
                    end if;     
---------------------Testing shift right-----------------------------------------------------------------                    
					wait for 10 ns;					
					sel<="0111";	
					
								
                    wait for 10 ns;				
                   if (to_integer(unsigned(in2))<8) then	
                    temp_result5     := to_integer(unsigned(in1)/(2**to_integer(unsigned(in2)))) ;           
					temp_result:=std_logic_vector(to_unsigned(temp_result5,TEST_WIDTH ));
					if ((temp_result=std_logic_vector(to_unsigned(0,test_width)) and z/='1')) then
                        error_zero :=error_zero+1;
                        report "Error zero , "  severity warning;
                        end if;
                        if (temp_result(test_width-1)/=s) then
                        error_sign :=error_sign+1;
                       report "Error sign , "  severity warning;
                        end if;
                    if (output_sig /= temp_result) then
                        error_shift_right :=error_shift_right+1;
                        report "Error , shift right " & integer'image(i) & " right shifted is "  & integer'image(to_integer(unsigned(output_sig))) severity warning;
                    end if; 


                   end if;

                   


            end loop;  -- j      
        end loop;  -- i

        report "Sum errors count = "& integer'image(error_Sum );
		report "Additin carry errors count = "& integer'image(error_sum_carry);
		report "Subtraction errors count = "& integer'image(error_Subtraction );
		
		report "ANDs  errors count = "& integer'image(error_AND);
		report "OR errors count = "& integer'image(error_OR);
		report "XOR  errors count = "& integer'image(error_XOR);
		report "shifted left  errors count = "& integer'image(error_shift_left);
		report "shifted right  errors count = "& integer'image(error_shift_right);
		
		report "zeros errors count = "& integer'image(error_zero);
		report "sign errors count = "& integer'image(error_sign);
        -- Test a different width


        

        wait;

    end process;

end TB;




