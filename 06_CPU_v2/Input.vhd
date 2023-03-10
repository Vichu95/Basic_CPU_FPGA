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
			Input_btnInputCnfrmRaw	:	in typ_in_btn;
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
	
	signal preVal_ReqEnbl 	: typ_cu_cntrlsig := CU_DISABLE;
	
	-- For button debounce
	signal counter_btnCfrm : integer range 0 to DEB_TIME_BTN :=0;
	signal preVal_RawCnfrm 	: typ_in_btn := '1';
	signal rising_RawCnfrm 	: typ_in_btn := '0';
	signal Input_btnInputCnfrm : typ_in_btn; --todomartin : remove this when added in debounce block
	signal counter_btnInputCfrm : integer range 0 to DEB_TIME_BTN :=0;
	signal preVal_RawInputCnfrm 	: typ_in_btn := '1';
	signal rising_RawInputCnfrm 	: typ_in_btn := '0';
	
begin



	-------------- DEBOUNCE BUTTONS ------------
	
		--	 Input_btnInputCnfrm <= Input_btnInputCnfrmRaw;
		--	 Input_btnCnfrm <= Input_btnCnfrmRaw;

	process(Input_clkDeb, Input_btnCnfrmRaw, Input_btnInputCnfrmRaw)
	begin
		
	-------------- CONTROL UNIT STATE CONFIRM BUTTON ------------
	  if (Input_clkDeb'event and Input_clkDeb = '1') then
	  
	  		-- To check for rising edge
			if(Input_btnCnfrmRaw /= preVal_RawCnfrm) then
				if(Input_btnCnfrmRaw = '0') then
					 rising_RawCnfrm <= '1';
				 end if;
				preVal_RawCnfrm <= Input_btnCnfrmRaw;
			end if;	
	
	
	  
			if (rising_RawCnfrm = '1') then
				 if (counter_btnCfrm = DEB_TIME_BTN) then					  
					 Input_btnCnfrm <= '1';
					  counter_btnCfrm <= 1;
					 rising_RawCnfrm <= '0';
				 else
					  counter_btnCfrm <= counter_btnCfrm + 1;		  
					  Input_btnCnfrm <= '0';    
				 end if;
			else

				if (counter_btnCfrm = 0) then					  
					 Input_btnCnfrm <= '0';
					  counter_btnCfrm <= 0;
				 else
					  counter_btnCfrm <= counter_btnCfrm - 1;		 
				 end if;

				 
				 
			end if;
			
					
		
		
	-------------- INPUT CONFIRM BUTTON ------------
	  		-- To check for rising edge
			if(Input_btnInputCnfrmRaw /= preVal_RawInputCnfrm) then
				if(Input_btnInputCnfrmRaw = '0') then
					 rising_RawInputCnfrm <= '1';
				 end if;
				preVal_RawInputCnfrm <= Input_btnInputCnfrmRaw;
			end if;	
	
	
	  
			if (rising_RawInputCnfrm = '1') then
				 if (counter_btnInputCfrm = DEB_TIME_BTN) then					  
					 Input_btnInputCnfrm <= '1';
					  counter_btnInputCfrm <= 1;
					 rising_RawInputCnfrm <= '0';
				 else
					  counter_btnInputCfrm <= counter_btnInputCfrm + 1;		  
					  Input_btnInputCnfrm <= '0';    
				 end if;
			else
				if (counter_btnInputCfrm = 0) then					  
					 Input_btnInputCnfrm <= '0';
					 counter_btnInputCfrm <= 0;
				else
					  counter_btnInputCfrm <= counter_btnInputCfrm - 1;		 
				end if;				 
			end if;
			
			
			
	  end if;	--Rising edge of debounce clock
	 
	 
	end process;
	
	
	
	
	
	
	
		
				--todo : Debounce logic for confirm button
				--todomartin : the final state should also be stored in Input_btnCnfrm_int. This is used in this module as Input_btnCnfrm cannot be used due to build error.
	-- CHANGE NOTE: Debounce logic added; variable names adapted to match the port section

	
	process(Input_rst, Input_clk, Input_btnCnfrmRaw, Input_cntrlCU_enblRdIn, Input_memDataRd)
	
	
	-- To store how cycles are required by the entity. Also to make sure it executes only ones
	constant no_of_states 	: integer := 1;
	variable cntrState		: integer range 0 to no_of_states := 0;	
	
	begin
						
		  
		if(Input_rst = RESET_PRESSED) then
			Input_stOprtn <= CU_NOWAIT;
			
										
			
		elsif(rising_edge(Input_clk)) then
			
			
			-- To check for rising edge
			if(Input_cntrlCU_enblRdIn /= preVal_ReqEnbl) then
			  if(Input_cntrlCU_enblRdIn = CU_ENABLE) then
				  cntrState := 0;
				 end if;
				preVal_ReqEnbl <= Input_cntrlCU_enblRdIn;
			end if;	
		
	
	
			-- Perform the Input only when control signal is true.
			if(Input_cntrlCU_enblRdIn = CU_ENABLE) then
			
				-- Input sets the status as cpu is in use and should be holded
				Input_stOprtn <= CU_WAIT;
				
				
				
				case cntrState is
		
				when 0 =>	
						-- Based on the state of Control Unit, input module should:
						case Input_crntCUState is
					
							when CU_IDLE_STATE =>
								--do nothing
								Input_stOprtn <= CU_NOWAIT;
								cntrState := cntrState + 1;
								
								
							when CU_READ_OPCODE_STATE =>
								
								if(Input_btnInputCnfrm = BTN_PRESSED) then
								
									-- Storing Read data in MEMLAY_OPCODE
									Input_memEnblWr <= MEM_WRITE_EN;
									Input_memAddr <= MEMLAY_OPCODE;
									--Input_memDataWr	<= "00000001";			--todomartin : Read the Opcode from FPGA through Input_swtOpcodIn[0..2]
									
									Input_memDataWr <= "00000" & Input_swtOpcodIn;
				
									Input_stOprtn <= CU_NOWAIT;
									cntrState := cntrState + 1;
									
								end if;
							
							when CU_FETCH_STATE =>	
								--do nothing
								Input_stOprtn <= CU_NOWAIT;
								cntrState := cntrState + 1;
							
							when CU_READ_DATA1_STATE =>
								
								if(Input_btnInputCnfrm = BTN_PRESSED) then
								
									-- Storing Read data in MEMLAY_DATA1
									Input_memEnblWr <= MEM_WRITE_EN;
									Input_memAddr <= MEMLAY_DATA1;
									--Input_memDataWr	<= "00000001";			--todomartin : Read the Opcode from FPGA through Input_swtDataIn[0..7]	
						
									Input_memDataWr <= Input_swtDataIn;
									
									Input_stOprtn <= CU_NOWAIT;
									cntrState := cntrState + 1;
						
								end if;
							
							when CU_READ_DATA2_STATE =>
								-- Check if the opcode is invert, it does not need second operand
								if(Input_swtOpcodIn /= OPCODE_INV) then
									
									if(Input_btnInputCnfrm = BTN_PRESSED) then
									
										-- Storing Read data in MEMLAY_DATA1
										Input_memEnblWr <= MEM_WRITE_EN;
										Input_memAddr <= MEMLAY_DATA2;
										--Input_memDataWr	<= "00000001";		--todomartin : Read the Opcode from FPGA through Input_swtDataIn[0..7]	
						
										Input_memDataWr <= Input_swtDataIn;
											
											
										Input_stOprtn <= CU_NOWAIT;
										cntrState := cntrState + 1;
							
									end if;
								end if;
							when CU_EXECUTE_STATE =>
								--do nothing
								Input_stOprtn <= CU_NOWAIT;
								cntrState := cntrState + 1;
					
							when CU_OUTPUT_STATE =>
								--do nothing
								Input_stOprtn <= CU_NOWAIT;
								cntrState := cntrState + 1;
								
						end case;
			
				
				when no_of_states =>
						-- Empty
						Input_stOprtn <= CU_NOWAIT;
				end case;			
				
				
			end if;
			
			
--			if(cntrState >= no_of_states) then
--				Input_stOprtn <= CU_NOWAIT;
--			end if;	
			
						
		end if;
	end process;
	

end architecture Input_A;