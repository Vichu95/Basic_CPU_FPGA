-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- Input_Add Entity
entity Input_E is

	port(	Input_rst					:	in typ_rst;
			Input_clk					:	in typ_clk;
			Input_clkDeb				:	in typ_clk;
			Input_btnCnfrmRaw			:	in typ_in_btn;
			Input_swtDataIn			:	in typ_8bitdata;
			Input_swtOpcodIn			:	in typ_opcod;
			Input_cntrlCU_enblRdIn	:	in typ_cu_cntrlsig;						-- Control signal from CPU
			
			Input_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of Input Operation
			Input_btnCnfrm				:	out typ_in_btn								-- Debounced Confirm button
			);

end entity Input_E;



architecture Input_A of Input_E is
	
	
begin

	process(Input_rst, Input_clk, Input_btnCnfrmRaw, Input_cntrlCU_enblRdIn)
	
	
	begin
	
		
			
			-- DUMMY---
		--Parsing of confirm button has to be done irrespective of main clock 
		Input_btnCnfrm <= Input_btnCnfrmRaw;			
		
		
		
	
		--- DUMMY---
			
		if(rising_edge(Input_clk)) then
						
			-- Perform the Input only when control signal is true.
			if(Input_cntrlCU_enblRdIn = CU_ENABLE) then
			
				-- Input sets the status as cpu is in use and should be holded
				Input_stOprtn <= CU_WAIT;
				
				
				
				
					
				-- Input sets the status as cpu can be used
				Input_stOprtn <= CU_NOWAIT; 
			
				
			end if;
			
				
			
			
		end if;
	end process;
	

end architecture Input_A;