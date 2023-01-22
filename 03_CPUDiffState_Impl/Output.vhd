-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;


-- Output Entity
entity Output_E is

	port(	Output_rst				:	in typ_rst;
			Output_clk				:	in typ_clk;
			Output_cntrlSigCPU	:	in typ_cpu_cntrlsig;		-- Control signal from CPU
			Output_regA				:	in typ_mem_reg;			-- Register or bus storing output data
			Output_stOprtn			:	out typ_cpu_cntrlsig	:= '0';	-- Status of Output Operation
			Output_LED				:	out typ_mem_reg	:= 0	-- LED showing output
			);

end entity Output_E;



architecture Output_A of Output_E is
	
	
begin

	process(Output_rst, Output_clk, Output_cntrlSigCPU)
	
	-- For testing
	variable temp_num2: natural range 0 to 15 := 0;
	--variable Output_LED: typ_mem_reg;
	
	begin
		if(rising_edge(Output_clk)) then
		
							
			-- Output copies data from bus/register to LED/LCD/7seg
			if(Output_cntrlSigCPU = CPU_ENABLE) then
			
				-- Output module sets the status as cpu is in use and should be holded
				Output_stOprtn <= CPU_WAIT;
				
				Output_LED <= Output_regA; -- Final Output in LED
				
				temp_num2 := temp_num2 + 1;		
				
			end if;
			
			-- This is to simulate additional cycles required by Output module to finish the operation
			-- Output module sets the status as cpu can be used
			if(temp_num2 >= 3) then				
				Output_stOprtn <= CPU_NOWAIT; 
			end if;
			
			
			
		end if;
	end process;
	

end architecture Output_A;