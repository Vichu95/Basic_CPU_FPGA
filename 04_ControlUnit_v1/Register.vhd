-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- Register_Add Entity
entity Register_E is

	port(	Register_rst					:	in typ_rst;
			Register_clk					:	in typ_clk;
			Register_cntrlCU_enblPC		:	in typ_cu_cntrlsig;						-- Control signal from CPU
			Register_cntrlCU_enblIR		:	in typ_cu_cntrlsig;						-- Control signal from CPU
			
			Register_stPCOprtn			:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of PC Operation
			Register_stIROprtn			:	out typ_cu_cntrlsig	:= CU_NOWAIT	-- Status of IR Operation
			);

end entity Register_E;



architecture Register_A of Register_E is
	
	
begin

	process(Register_rst, Register_clk, Register_cntrlCU_enblPC)
	
	
	
	begin
		if(rising_edge(Register_clk)) then
						
			-- Perform the Register only when control signal is true.
			-- We can extend this by getting the OpCode, Data from CPU
			if(Register_cntrlCU_enblPC = CU_ENABLE) then
			
				-- Register sets the status as cpu is in use and should be holded
				Register_stPCOprtn <= CU_WAIT;
				
				
				
					-- DUMMY---
						
				
				
				
				
					--- DUMMY---
					
					Register_stPCOprtn <= CU_NOWAIT;
					
			end if;
			
						
			
		end if;
	end process;
	

end architecture Register_A;