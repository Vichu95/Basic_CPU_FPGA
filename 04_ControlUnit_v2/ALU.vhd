------------------------------------------------------------------------------------------------
--		University             : Hochschule Anhalt
--		Group                  :     
--		Authors                : 
--		                         
--		Degree Course          : Electrical and Computer Engineering (M. Eng.)
--		Subject                : Harware Software Co Deisgn
--		File Name              : ALU.vhd
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
-- ALU Entity
--------------------------
entity ALU_E is

	port(	ALU_rst					:	in typ_rst;
			ALU_clk					:	in typ_clk;
			ALU_cntrlCU_enblALU	:	in typ_cu_cntrlsig;						-- Control signal from CPU
			ALU_memDataRd			:	in typ_databus:= typ_databus_ini;	-- Data read from RAM
			
			ALU_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of ALU Operation
			ALU_memAddr				:	out typ_addrbus := typ_addrbus_ini;	-- Address to read/write
			ALU_memDataWr			:	out typ_databus := typ_databus_ini;	-- Data to be written
			ALU_memEnblWr			:	out typ_cu_cntrlsig := CU_DISABLE	-- Read or Write enable	
			);

end entity ALU_E;


-----------------------------
--         Architecture
-----------------------------
architecture ALU_A of ALU_E is
	
	
begin

	process(ALU_rst, ALU_clk, ALU_cntrlCU_enblALU)
	
	
	--- DUMMY---
	-- ALU just performs a counter operation
	variable temp_num: natural range 0 to 15 := 0;	
	--- DUMMY---
	
	begin
	
		if(ALU_rst = RESET_PRESSED) then
			ALU_stOprtn <= CU_NOWAIT;
										
			
		elsif(rising_edge(ALU_clk)) then
						
			-- Perform the ALU only when control signal is true.
			-- We can extend this by getting the OpCode, Data from CPU
			if(ALU_cntrlCU_enblALU = CU_ENABLE) then
			
				-- ALU sets the status as cpu is in use and should be holded
				ALU_stOprtn <= CU_WAIT;
				
				
				
					-- DUMMY---
				
				temp_num := temp_num + 1;				
				--ALU_acc <= temp_num; -- Final Output in Accumulator
				
				
				
				
					--- DUMMY---
					
			end if;
			
			
			
			-- DUMMY---
			-- This is to simulate additional cycles required by ALU to finish the operation
			-- ALU sets the status as cpu can be used
			if(temp_num >= 3) then			
		
		
				-- NOT DUMMY :Include this line at the end of process
				ALU_stOprtn <= CU_NOWAIT; 
				
				
			end if;			
			--- DUMMY---
			
			
		end if;
	end process;
	

end architecture ALU_A;