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
	
	signal Input_btnCnfrm_int : typ_in_btn; --todomartin : remove this when added in debounce block
	
begin


	
	--todomartin : Debounce logic for confirm button
	--todomartin : the final state should also be stored in Input_btnCnfrm_int. This is used in this module as Input_btnCnfrm cannot be used due to build error.


	process(Input_rst, Input_clk, Input_btnCnfrmRaw, Input_cntrlCU_enblRdIn, Input_memDataRd)
	
		
	
	begin
				
		
		if(Input_rst = RESET_PRESSED) then
			Input_stOprtn <= CU_NOWAIT;
			
										
			
		elsif(rising_edge(Input_clk)) then
				
						
			-- Perform the Input only when control signal is true.
			if(Input_cntrlCU_enblRdIn = CU_ENABLE) then
			
				-- Input sets the status as cpu is in use and should be holded
				Input_stOprtn <= CU_WAIT;
				
				
				
				-- Based on the state of Control Unit, input module should:
				case Input_crntCUState is
			
					when CU_IDLE_STATE =>
						--do nothing
						
						
					when CU_READ_OPCODE_STATE =>
						if(Input_btnCnfrm_int = BTN_PRESSED) then
						
							-- Storing Read data in MEMLAY_OPCODE
							Input_memEnblWr <= MEM_WRITE_EN;
							Input_memAddr <= MEMLAY_OPCODE;
							Input_memDataWr	<= "00000001";			--todomartin : Read the Opcode from FPGA through Input_swtOpcodIn[0..2]
				
						end if;
					
					when CU_FETCH_STATE =>	
						--do nothing
					
					when CU_READ_DATA1_STATE =>
						
						if(Input_btnCnfrm_int = BTN_PRESSED) then
						
							-- Storing Read data in MEMLAY_DATA1
							Input_memEnblWr <= MEM_WRITE_EN;
							Input_memAddr <= MEMLAY_DATA1;
							Input_memDataWr	<= "00000001";			--todomartin : Read the Opcode from FPGA through Input_swtDataIn[0..7]	
				
						end if;
					
					when CU_READ_DATA2_STATE =>
						-- Check if the opcode is invert, it does not need second operand
						if(Input_swtOpcodIn /= OPCODE_INV) then
							
							if(Input_btnCnfrm_int = BTN_PRESSED) then
							
								-- Storing Read data in MEMLAY_DATA1
								Input_memEnblWr <= MEM_WRITE_EN;
								Input_memAddr <= MEMLAY_DATA1;
								Input_memDataWr	<= "00000001";		--todomartin : Read the Opcode from FPGA through Input_swtDataIn[0..7]	
					
							end if;
						end if;
					when CU_EXECUTE_STATE =>
						--do nothing
			
					when CU_OUTPUT_STATE =>
						--do nothing
						
				end case;
				
				Input_stOprtn <= CU_NOWAIT;				
				
			end if;
			
						
		end if;
	end process;
	

end architecture Input_A;