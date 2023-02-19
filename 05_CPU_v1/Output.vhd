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
			Output_crntCUState		:	in enum_CU_state;
			Output_swtDataIn			:	in typ_databus;
			Output_swtOpcodIn			:	in typ_opcod;
			Output_memDataRd			:	in typ_databus:= typ_databus_ini;	-- Data read from RAM
			
			Output_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of Output Operation
			Output_ledDataInShw		:	out typ_databus;
			Output_ledOpcodInShw		:	out typ_opcod;
			Output_7segHEX0			:	out typ_out_7seg;
			Output_7segHEX1			:	out typ_out_7seg;
			Output_7segHEX2			:	out typ_out_7seg;
			Output_7segHEX3			:	out typ_out_7seg;
			Output_7segHEX4			:	out typ_out_7seg;
			Output_7segHEX5			:	out typ_out_7seg;
			Output_7segHEX6			:	out typ_out_7seg;
			Output_7segHEX7			:	out typ_out_7seg;
			Output_memAddr				:	out typ_addrbus := typ_addrbus_ini;	-- Address to read/write
			Output_memDataWr			:	out typ_databus := typ_databus_ini;	-- Data to be written
			Output_memEnblWr			:	out typ_cu_cntrlsig := CU_DISABLE	-- Read or Write enable			
			);

end entity Output_E;


-----------------------------
--         Architecture
-----------------------------
architecture Output_A of Output_E is
	
	signal temp_mem			: typ_databus 	:= typ_databus_ini; --store temporarily
	signal preVal_ReqEnbl 	: typ_cu_cntrlsig := CU_DISABLE;
	
begin

	process(Output_rst, Output_clk, Output_cntrlCU_enblOut, Output_memDataRd, Output_crntCUState)
	
	-- To store how cycles are required by the entity
	constant no_of_states 	: integer := 3;
	variable cntrState		: integer range 0 to no_of_states := 0;	
	
	begin
		
		if(Output_rst = RESET_PRESSED) then
			Output_stOprtn <= CU_NOWAIT;
			--todomartin : reset the 7segment
			--todomartin : reset the leds
			
										
			
		elsif(rising_edge(Output_clk)) then
		
			-- To check for rising edge
			if(Output_cntrlCU_enblOut /= preVal_ReqEnbl) then
			  if(Output_cntrlCU_enblOut = CU_ENABLE) then
				  cntrState := 0;
				 end if;
				preVal_ReqEnbl <= Output_cntrlCU_enblOut;
			end if;	
		
			-- Based on the state of Control Unit, output module should:
			case Output_crntCUState is
		
				when CU_IDLE_STATE =>
					--todomartin : Display the CU State as '00 Id' in 7-Segments HEX 7 to 4
					
					
				when CU_READ_OPCODE_STATE =>
					--todomartin : Display the CU State as '01 OC' in 7-Segments HEX 7 to 4
					--todomartin : Display the '= Opcode' in 7-Segments HEX 3 to 0 as per Output_swtOpcodIn[0..2]
					--todomartin : Display the Output_swtOpcodIn[0..2] in Output_ledOpcodInShw[0..2] for binary
				
				when CU_FETCH_STATE =>	
					--todomartin : Display the CU State as '02 FE' in 7-Segments HEX 7 to 4
				
				when CU_READ_DATA1_STATE =>
					--todomartin : Display the CU State as ''03 d1' in 7-Segments HEX 7 to 4
					--todomartin : Display the '= data 1' in 7-Segments HEX3 to 0 as per Output_swtDataIn[0..7]
					--todomartin : Display the Output_swtDataIn[0..7] in Output_ledDataInShw[0..7] for binary
				
				when CU_READ_DATA2_STATE =>
					-- Check if the opcode is invert, it does not need second operand
					if(Output_swtOpcodIn /= OPCODE_INV) then
						--todomartin : Display the CU State as ''04 d2' in 7-Segments HEX 7 to 4
						--todomartin : Display the '= data 2' in 7-Segments HEX3 to 0 as per Output_swtDataIn[0..7]
						--todomartin : Display the Output_swtDataIn[0..7] in Output_ledDataInShw[0..7] for binary
					end if;
				when CU_EXECUTE_STATE =>
					--todomartin : Display the CU State as '05 EC' in 7-Segments HEX 7 to 4
		
				when CU_OUTPUT_STATE =>
					
					-- Perform the Output only when control signal is true.
					if(Output_cntrlCU_enblOut = CU_ENABLE) then
						--todomartin : Display the CU State as '06 OP' in 7-Segments HEX 7 to 4					
					
						-- Output sets the status as cpu is in use and should be holded
						Output_stOprtn <= CU_WAIT;
						
						
						case cntrState is
				
						when 0 =>
							-- Req to Read Stored MEMLAY_REG_R1
							Output_memEnblWr <= MEM_READ_EN;
							Output_memAddr <= MEMLAY_REG_R1;
							
						when 1 =>
							-- Reading Stored MEMLAY_REG_R1
							temp_mem <= Output_memDataRd;
							
						when 2 =>
							--todomartin : Display the read value as '= output' in 7-Segments HEX 3 to 0					
						
						
						when no_of_states =>
								-- Empty
						end case;
						
						if (cntrState < no_of_states) then
							cntrState := cntrState + 1;
						end if;
										
						
					end if;
				
					if(cntrState >= no_of_states) then	
						-- Output sets the status as cpu can be used
						Output_stOprtn <= CU_NOWAIT; 
					end if;	
					
			end case;
			
					
			
			
		end if;
	end process;
	

end architecture Output_A;