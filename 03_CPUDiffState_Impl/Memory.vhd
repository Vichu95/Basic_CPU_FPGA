-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;


-- Memory Entity
entity Memory_E is

	port(	Memory_rst				:	in typ_rst;
			Memory_clk				:	in typ_clk;
			Memory_cntrlSigCPU	:	in typ_cpu_cntrlsig;		-- Control signal from CPU
			Memory_regA				:	in typ_mem_reg;			-- Register or bus storing Memory data
			Memory_stOprtn			:	out typ_cpu_cntrlsig	:= '0'	-- Status of Memory Operation
			);

end entity Memory_E;



architecture Memory_A of Memory_E is
	
	
begin

	process(Memory_rst, Memory_clk, Memory_cntrlSigCPU)
	
	-- For testing
	variable temp_num3: natural range 0 to 15 := 0;
	--variable Memory_LED: typ_mem_reg;
	
	begin
		if(rising_edge(Memory_clk)) then
		
							
			-- Memory
			if(Memory_cntrlSigCPU = CPU_ENABLE) then
			
				-- Memory module sets the status as cpu is in use and should be holded
				Memory_stOprtn <= CPU_WAIT;
				
				
				temp_num3 := temp_num3 + 1;		
				
			end if;
			
			-- This is to simulate additional cycles required by Memory module to finish the operation
			-- Memory module sets the status as cpu can be used
			if(temp_num3 >= 3) then				
				Memory_stOprtn <= CPU_NOWAIT; 
				temp_num3 := 0;
			end if;
			
			
			
		end if;
	end process;
	

end architecture Memory_A;