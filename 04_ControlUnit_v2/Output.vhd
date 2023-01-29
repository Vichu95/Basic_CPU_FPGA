------------------------------------------------------------------------------------------------
--		University             : Hochschule Anhalt
--		Group                  :     
--		Authors                : 
--		                         
--		Degree Course          : Electrical and Computer Engineering (M. Eng.)
--		Subject                : Harware Software Co Deisgn
--		File Name              : Output.vhd
--		Date                   : 
--		Description            : 
------------------------------------------------------------------------------------------------


--------------------------
-- Header File Inclusion
--------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

--------------------------
-- Output Entity
--------------------------
entity Output_E is

	port(	Output_rst					:	in typ_rst;
			Output_clk					:	in typ_clk;
			Output_cntrlCU_enblOut	:	in typ_cu_cntrlsig;						-- Control signal from CPU
			Output_memDataRd			:	in typ_databus:= typ_databus_ini;	-- Data read from RAM
			
			Output_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of Output Operation
			Output_ledDataInShw		:	out typ_databus;
			Output_ledOpcodInShw		:	out typ_opcod;
			Output_7segOut1Shw		:	out typ_out_7seg;
			Output_7segOut10Shw		:	out typ_out_7seg;
			Output_7segOut100Shw		:	out typ_out_7seg;
			Output_memAddr				:	out typ_addrbus := typ_addrbus_ini;	-- Address to read/write
			Output_memDataWr			:	out typ_databus := typ_databus_ini;	-- Data to be written
			Output_memEnblWr			:	out typ_cu_cntrlsig := CU_DISABLE	-- Read or Write enable			
			);

end entity Output_E;


-----------------------------
--         Architecture
-----------------------------
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