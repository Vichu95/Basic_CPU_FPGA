------------------------------------------------------------------------------------------------
--		University             : Hochschule Anhalt
--		Group                  :     
--		Authors                : 
--		                         
--		Degree Course          : Electrical and Computer Engineering (M. Eng.)
--		Subject                : Harware Software Co Deisgn
--		File Name              : Input.vhd
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
-- Input Entity
--------------------------
entity Input_E is

	port(	Input_rst					:	in typ_rst;
			Input_clk					:	in typ_clk;
			Input_clkDeb				:	in typ_clk;									-- Clock used for debouncing switches
			Input_btnCnfrmRaw			:	in typ_in_btn;
			Input_swtDataIn			:	in typ_databus;
			Input_swtOpcodIn			:	in typ_opcod;
			Input_cntrlCU_enblRdIn	:	in typ_cu_cntrlsig;						-- Control signal from CPU
			Input_crntCUState			:	in enum_CU_state;							-- Current State of Control Unit
			Input_memDataRd			:	in typ_databus:= typ_databus_ini;	-- Data read from RAM
			
			Input_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of Input Operation
			Input_btnCnfrm				:	out typ_in_btn;							-- Debounced Confirm button
			Input_memAddr				:	out typ_addrbus := typ_addrbus_ini;	-- Address to read/write
			Input_memDataWr			:	out typ_databus := typ_databus_ini;	-- Data to be written
			Input_memEnblWr			:	out typ_cu_cntrlsig := CU_DISABLE	-- Read or Write enable
			);

end entity Input_E;


-----------------------------
--         Architecture
-----------------------------
architecture Input_A of Input_E is


			-- DUMMY---
	signal HW_PinData		: typ_databus 	:= 0;						-- data that is read
			-- DUMMY---
	
	
begin

	process(Input_rst, Input_clk, Input_btnCnfrmRaw, Input_cntrlCU_enblRdIn, Input_memDataRd)
	
	
	-- To store how cycles are required by the entity
	constant no_of_states 	: integer := 4;
	variable cntrState	: integer range 0 to no_of_states 		:= 0;	
	
	begin
	
		
			
			-- DUMMY---
		--Parsing of confirm button has to be done irrespective of main clock 
		Input_btnCnfrm <= Input_btnCnfrmRaw;
		--- DUMMY---
			
		
		if(Input_rst = RESET_PRESSED) then
			Input_stOprtn <= CU_NOWAIT;
			
										
			
		elsif(rising_edge(Input_clk)) then
						
			-- Perform the Input only when control signal is true.
			if(Input_cntrlCU_enblRdIn = CU_ENABLE) then
			
				-- Input sets the status as cpu is in use and should be holded
				Input_stOprtn <= CU_WAIT;
				
				
				case cntrState is
		
				when 0 =>					
					-- Reading from HW Pin
					HW_PinData <= 74;
				
				when 1 =>
					-- Storing Read data in MEMLAY_OPCODE
					Input_memEnblWr <= MEM_WRITE_EN;
					Input_memAddr <= MEMLAY_OPCODE;
					Input_memDataWr	<= HW_PinData;				
				
				
				when no_of_states =>
						--Empty
				end case;
				
				cntrState := cntrState + 1;	
				
				
			
				if(cntrState >= no_of_states) then			
					-- Input sets the status as cpu can be used
					Input_stOprtn <= CU_NOWAIT; 				
					cntrState := 0;
				end if;				
						
				
			end if;
		end if;
	end process;
	

end architecture Input_A;