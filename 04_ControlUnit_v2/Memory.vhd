------------------------------------------------------------------------------------------------
--		University             : Hochschule Anhalt
--		Group                  :     
--		Authors                : 
--		                         
--		Degree Course          : Electrical and Computer Engineering (M. Eng.)
--		Subject                : Harware Software Co Deisgn
--		File Name              : Memory.vhd
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
-- Memory Entity
--------------------------
entity Memory_E is

	port(	Memory_rst					:	in typ_rst;
			Memory_clk					:	in typ_clk;
			Memory_enblWr				:	IN typ_cu_cntrlsig := CU_DISABLE;	-- Signal to check if its read or write
			Memory_addrRd				:	in typ_addrbus := typ_addrbus_ini;	-- Address
			Memory_memDataWr			:	in typ_databus := typ_databus_ini;	-- Data to be written to RAM
			Memory_cntrlCU_enblMem	:	in typ_cu_cntrlsig := CU_DISABLE;	-- Control signal from CPU
			
			Memory_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of Memory Operation
			Memory_memDataRd			:	out typ_databus := typ_databus_ini	-- Data that is read from RAM
			);
end entity Memory_E;


-----------------------------
--         Architecture
-----------------------------
architecture Memory_A of Memory_E is
	
	type ram_type is array (0 to 12) of integer;
	--signal Memory_ram : ram_type :=(others=>(others=>0));
	signal Memory_ram : ram_type := (1 to 3=>56, others=>0);
	
begin

	process(Memory_rst, Memory_clk, Memory_cntrlCU_enblMem, Memory_addrRd, Memory_enblWr,Memory_memDataWr)
	
	
	begin
			
		--if(rising_edge(Memory_clk)) then
						
			-- Perform the Memory only when control signal is true.
			if(Memory_cntrlCU_enblMem = CU_ENABLE) then
			
				-- Memory sets the status as cpu is in use and should be holded
				Memory_stOprtn <= CU_WAIT;
				
				
				if(Memory_enblWr = '1') then
					Memory_ram(Memory_addrRd) <= Memory_memDataWr;
				else
					Memory_memDataRd <= Memory_ram(Memory_addrRd);
				end if;
					
				-- Memory sets the status as cpu can be used
				Memory_stOprtn <= CU_NOWAIT; 
			
				
			end if;
			
				
			
			
		--end if;
	end process;
	

end architecture Memory_A;