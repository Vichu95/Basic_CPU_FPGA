-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- ALU_Add Entity
entity ALU_Add_E is

	port(	ALU_rst					:	in typ_rst;
			ALU_clk					:	in typ_clk;
			ALU_cntrlSigCPU		:	in typ_cpu_cntrlsig;		-- Control signal from CPU
			ALU_stALUOprtn			:	out typ_cpu_cntrlsig	:= '0';	-- Status of ALU Operation
			ALU_acc					:	out typ_mem_reg	:= 0	-- Accumulator for storing calculated signals
			);

end entity ALU_Add_E;



architecture ALU_Add_A of ALU_Add_E is
	
	
begin

	process(ALU_rst, ALU_clk, ALU_cntrlSigCPU)
	
	-- ALU just performs a counter operation  ## For testing
	variable temp_num: natural range 0 to 15 := 0;
	
	begin
		if(rising_edge(ALU_clk)) then
						
			-- Perform the ALU only when control signal is true.
			-- We can extend this by getting the OpCode, Data from CPU
			if(ALU_cntrlSigCPU = CPU_ENABLE) then
			
				-- ALU sets the status as cpu is in use and should be holded
				ALU_stALUOprtn <= CPU_WAIT;
				
				temp_num := temp_num + 1;		
				
				ALU_acc <= temp_num; -- Final Output in Accumulator
			end if;
			
			-- This is to simulate additional cycles required by ALU to finish the operation
			-- ALU sets the status as cpu can be used
			if(temp_num >= 3) then				
				ALU_stALUOprtn <= CPU_NOWAIT; 
			end if;
			
		end if;
	end process;
	

end architecture ALU_Add_A;