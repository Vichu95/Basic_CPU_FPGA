-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- Memory_Add Entity
entity Memory_E is

	port(	Memory_rst					:	in typ_rst;
			Memory_clk					:	in typ_clk;
			Memory_addrRd				:	in typ_addr;
			Memory_cntrlCU_enblMem	:	in typ_cu_cntrlsig;						-- Control signal from CPU
			Memory_ram					: inout ram_type;
			Memory_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT	-- Status of Memory Operation
			);

end entity Memory_E;



architecture Memory_A of Memory_E is
--	
--	type ram_type is array (0 to 3) of integer;
--	signal ram : ram_type;
	
	
begin

	process(Memory_rst, Memory_clk, Memory_cntrlCU_enblMem)
	
	
	begin
			
		if(rising_edge(Memory_clk)) then
						
			-- Perform the Memory only when control signal is true.
			if(Memory_cntrlCU_enblMem = CU_ENABLE) then
			
				-- Memory sets the status as cpu is in use and should be holded
				Memory_stOprtn <= CU_WAIT;
				
				
				Memory_ram(Memory_addrRd) <= 5;
				
					
				-- Memory sets the status as cpu can be used
				Memory_stOprtn <= CU_NOWAIT; 
			
				
			end if;
			
				
			
			
		end if;
	end process;
	

end architecture Memory_A;