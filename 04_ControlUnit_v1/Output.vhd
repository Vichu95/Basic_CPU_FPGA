-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- Output_Add Entity
entity Output_E is

	port(	Output_rst					:	in typ_rst;
			Output_clk					:	in typ_clk;
			Output_cntrlCU_enblOut	:	in typ_cu_cntrlsig;						-- Control signal from CPU
			
			Output_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of Output Operation
			Output_ledDataInShw		:	out typ_8bitdata;
			Output_ledOpcodInShw		:	out typ_opcod;
			Output_7segOut1Shw		:	out std_logic_vector(6 downto 0);
			Output_7segOut10Shw		:	out std_logic_vector(6 downto 0);
			Output_7segOut100Shw		:	out std_logic_vector(6 downto 0)
			);

end entity Output_E;



architecture Output_A of Output_E is
	
	
begin

	process(Output_rst, Output_clk, Output_cntrlCU_enblOut)
	
	
	begin
		if(rising_edge(Output_clk)) then
						
			-- Perform the Output only when control signal is true.
			if(Output_cntrlCU_enblOut = CU_ENABLE) then
			
				-- Output sets the status as cpu is in use and should be holded
				Output_stOprtn <= CU_WAIT;
				
				
				
					-- DUMMY---
				
				
				
			
				--- DUMMY---
				
				
					
				-- Output sets the status as cpu can be used
				Output_stOprtn <= CU_NOWAIT; 
			
				
			end if;
			
			
			
			
		end if;
	end process;
	

end architecture Output_A;