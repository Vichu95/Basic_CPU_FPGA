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


		--NOTES: BCD conversion uses direct input from the switches; might be changed to read from memory
		--		  	Cases for data1 and data 2 use direct input from the switches; might be changed to read from memory
		--      	Same code segment is called for data1, data2 (and calculation output display); should be called in a sub function
		-- 	  	BCD conversion for displaying the calculation output uses variable CU_memDataRd; is this correct? 
		--			
		--			the green LEDs (8 downto 0) need to be added to prevent from glow
		--			the red LEDs (14 downto 8) need to be added to prevent from glow
		--			LCD_ON pin needs to be added to switch off the LC display
					


--------------------------
-- Header File Inclusion
--------------------------
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

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
			Output_7segHEX0			:	out typ_out_7seg	:= typ_out_7seg_ini;
			Output_7segHEX1			:	out typ_out_7seg	:= typ_out_7seg_ini;
			Output_7segHEX2			:	out typ_out_7seg	:= typ_out_7seg_ini;
			Output_7segHEX3			:	out typ_out_7seg	:= typ_out_7seg_ini;
			Output_7segHEX4			:	out typ_out_7seg	:= typ_out_7seg_ini;
			Output_7segHEX5			:	out typ_out_7seg	:= typ_out_7seg_ini;
			Output_7segHEX6			:	out typ_out_7seg	:= typ_out_7seg_ini;
			Output_7segHEX7			:	out typ_out_7seg	:= typ_out_7seg_ini;
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
	
	variable bcd1 : std_logic_vector (3 downto 0); 
	variable bcd2 : std_logic_vector (3 downto 0); 
	variable bcd3 : std_logic_vector (3 downto 0); 
	variable binx : std_logic_vector (7 downto 0);
	variable bcd : std_logic_vector (11 downto 0);
	
	begin
		
		if(Output_rst = RESET_PRESSED) then
			Output_stOprtn <= CU_NOWAIT;
						--todomartin : reset the 7segment
						--todomartin : reset the leds
			-- DONE
			
			-- Reset 7Segment 
			Output_7segHEX0 <= typ_out_7seg_ini;
			Output_7segHEX1 <= typ_out_7seg_ini;
			Output_7segHEX2 <= typ_out_7seg_ini;
			Output_7segHEX3 <= typ_out_7seg_ini;
			Output_7segHEX4 <= typ_out_7seg_ini;
			Output_7segHEX5 <= typ_out_7seg_ini;
			Output_7segHEX6 <= typ_out_7seg_ini;
			Output_7segHEX7 <= typ_out_7seg_ini;
	
			-- Reset LEDs (data & opcode)				
			Output_ledDataInShw	<= "00000000";	
			Output_ledOpcodInShw	<= "000";
			
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
					
						Output_7segHEX7 <= "1000000";
						Output_7segHEX6 <= "1000000";
						Output_7segHEX5 <= "1111001";
						Output_7segHEX4 <= "0100001";
						Output_7segHEX3 <= "1111111";
						Output_7segHEX2 <= "1111111";
						Output_7segHEX1 <= "1111111";
						Output_7segHEX0 <= "1111111";
						
						-- Reset LEDs (data & opcode)				
						Output_ledDataInShw	<= "00000000";	
						Output_ledOpcodInShw	<= "000";


						
				when CU_READ_OPCODE_STATE =>
					--todomartin : Display the CU State as '01 OC' in 7-Segments HEX 7 to 4
					--todomartin : Display the '= Opcode' in 7-Segments HEX 3 to 0 as per Output_swtOpcodIn[0..2]
					--todomartin : Display the Output_swtOpcodIn[0..2] in Output_ledOpcodInShw[0..2] for binary
					
						Output_7segHEX7 <= "1000000";
						Output_7segHEX6 <= "1111001";
						Output_7segHEX5 <= "1000000";
						Output_7segHEX4 <= "1000110";
						Output_7segHEX3 <= "0110111";
					
					  
	
					case("00000" & Output_swtOpcodIn) is
						
							when "00000001" => -- Add
								Output_7segHEX2 <= "0001000";
								Output_7segHEX1 <= "0100001";
								Output_7segHEX0 <= "0100001";

							when "00000010" => -- Sub
								Output_7segHEX2 <= "0010010";
								Output_7segHEX1 <= "1100011";
								Output_7segHEX0 <= "0000011";
								
							when "00000011" => -- Inv
								Output_7segHEX2 <= "1111001";
								Output_7segHEX1 <= "0101011";
								Output_7segHEX0 <= "1100011";
							
							when "00000100" => -- And
								Output_7segHEX2 <= "0001000";
								Output_7segHEX1 <= "0101011";
								Output_7segHEX0 <= "0100001";

							when "00000101" => -- Or
								Output_7segHEX2 <= "1000000";
								Output_7segHEX1 <= "0101111";
								Output_7segHEX0 <= "1111111";

							when "00000110" => -- Xor
								Output_7segHEX2 <= "0001001";
								Output_7segHEX1 <= "0100011";
								Output_7segHEX0 <= "0101111";
				
							when "00000000" => -- Bitshift right [Sh |-]
								Output_7segHEX2 <= "0010010";
								Output_7segHEX1 <= "0001011";
								Output_7segHEX0 <= "0001111";

							when "00000111" => -- Bitshift left [Sh -|]
								Output_7segHEX2 <= "0010010";
								Output_7segHEX1 <= "0001011";
								Output_7segHEX0 <= "0111001";
							
							when others => 
								Output_7segHEX2 <= "1111111";
								Output_7segHEX1 <= "1111111";
								Output_7segHEX0 <= "1111111";
					end case;
				
				when CU_FETCH_STATE =>	
					--todomartin : Display the CU State as '02 FE' in 7-Segments HEX 7 to 4
					
						Output_7segHEX7 <= "1000000";
						Output_7segHEX6 <= "0100100";
						Output_7segHEX5 <= "0001110";
						Output_7segHEX4 <= "0000110";
						Output_7segHEX3 <= "1111111";
						Output_7segHEX2 <= "1111111";
						Output_7segHEX1 <= "1111111";	
						Output_7segHEX0 <= "1111111";
				
				when CU_READ_DATA1_STATE =>
					--todomartin : Display the CU State as ''03 d1' in 7-Segments HEX 7 to 4
					--todomartin : Display the '= data 1' in 7-Segments HEX3 to 0 as per Output_swtDataIn[0..7]
					--todomartin : Display the Output_swtDataIn[0..7] in Output_ledDataInShw[0..7] for binary
					
				
					
						Output_7segHEX7 <= "1000000";
						Output_7segHEX6 <= "0110000";
						Output_7segHEX5 <= "0100001";
						Output_7segHEX4 <= "1111001";
						Output_7segHEX3 <= "0110111";
					
						------------ BCD Conversion--------------
						bcd         := (others => '0');
						binx        := Output_swtDataIn;

						for i in binx'range loop
						  if bcd(3 downto 0) > "0100" then
							 bcd(3 downto 0) := std_logic_vector(unsigned(bcd(3 downto 0)) + "0011"); 

						  end if ;
						  if bcd(7 downto 4) > "0100" then
							  bcd(7 downto 4) := std_logic_vector(unsigned(bcd(7 downto 4)) + "0011");    
						  end if ;
						  bcd := bcd(10 downto 0) & binx(7); 
						  binx := binx(6 downto 0) & '0'; 
						end loop ;

						bcd3 := bcd(11 downto 8);
						bcd2 := bcd(7  downto 4);
						bcd1 := bcd(3  downto 0);

						Output_ledDataInShw <= binx;
						
						------------ ONES -------------------------

							case (bcd1) is

								 when "0000" => -- 0
									Output_7segHEX0 <= "1000000";	
							 
								 when "0001" => -- 1
									Output_7segHEX0 <= "1111001";

								 when "0010" => -- 2
									Output_7segHEX0 <= "0100100";	
							 
								 when "0011" => -- 3
									Output_7segHEX0 <= "0110000";	

								 when "0100" => -- 4
									Output_7segHEX0 <= "0011001";		
								
								 when "0101" => -- 5
									Output_7segHEX0 <= "0010010";		

								 when "0110" => -- 6
									Output_7segHEX0 <= "0000010";	

								 when "0111" => -- 7
									Output_7segHEX0 <= "1111000";	

								 when "1000" => -- 8
									Output_7segHEX0 <= "0000000";	

								 when "1001" => -- 9
									Output_7segHEX0 <= "0010000";
								 when others =>
									Output_7segHEX0 <= "1111111";
						end case;

						------------ TENS -------------------------

							case (bcd2) is

								 when "0000" => -- 0
									Output_7segHEX1 <= "1000000";	
							 
								 when "0001" => -- 1
									Output_7segHEX1 <= "1111001";

								 when "0010" => -- 2
									Output_7segHEX1 <= "0100100";	
							 
								 when "0011" => -- 3
									Output_7segHEX1 <= "0110000";	

								 when "0100" => -- 4
									Output_7segHEX1 <= "0011001";		
								
								 when "0101" => -- 5
									Output_7segHEX1 <= "0010010";		

								 when "0110" => -- 6
									Output_7segHEX1 <= "0000010";	

								 when "0111" => -- 7
									Output_7segHEX1 <= "1111000";	

								 when "1000" => -- 8
									Output_7segHEX1 <= "0000000";	

								 when "1001" => -- 9
									Output_7segHEX1 <= "0010000";
								 when others =>
									Output_7segHEX1 <= "1111111";
						end case;	

						------------ HUNDREDS ---------------------

							case (bcd3) is

								 when "0000" => -- 0
									Output_7segHEX2 <= "1000000";	
							 
								 when "0001" => -- 1
									Output_7segHEX2 <= "1111001";

								 when "0010" => -- 2
									Output_7segHEX2 <= "0100100";		
								 when others =>
									Output_7segHEX2 <= "1111111";
							end case;		
					
				when CU_READ_DATA2_STATE =>
					-- Check if the opcode is invert, it does not need second operand
					
					Output_7segHEX7 <= "1000000";
					Output_7segHEX6 <= "0011001";
					Output_7segHEX5 <= "1111111";
					Output_7segHEX4 <= "1111111";
					Output_7segHEX3 <= "1111111";
					Output_7segHEX2 <= "1111111";
					Output_7segHEX1 <= "1111111";	
					Output_7segHEX0 <= "1111111";
					
					if(Output_swtOpcodIn(OPCODE_WIDTH downto 0) /= OPCODE_INV) then
						--todomartin : Display the CU State as ''04 d2' in 7-Segments HEX 7 to 4
						--todomartin : Display the '= data 2' in 7-Segments HEX3 to 0 as per Output_swtDataIn[0..7]
						--todomartin : Display the Output_swtDataIn[0..7] in Output_ledDataInShw[0..7] for binary
						
						Output_7segHEX5 <= "0100001";
						Output_7segHEX4 <= "0100100";
						Output_7segHEX3 <= "0110111";	
						
						
						------------ BCD Conversion--------------						
						bcd         := (others => '0');
						binx        := Output_swtDataIn;

						for i in binx'range loop
						  if bcd(3 downto 0) > "0100" then
							 bcd(3 downto 0) := std_logic_vector(unsigned(bcd(3 downto 0)) + "0011"); 

						  end if ;
						  if bcd(7 downto 4) > "0100" then
							  bcd(7 downto 4) := std_logic_vector(unsigned(bcd(7 downto 4)) + "0011");    
						  end if ;
						  bcd := bcd(10 downto 0) & binx(7); 
						  binx := binx(6 downto 0) & '0'; 
						end loop ;

						bcd3 := bcd(11 downto 8);
						bcd2 := bcd(7  downto 4);
						bcd1 := bcd(3  downto 0);

						Output_ledDataInShw <= binx;
						
						------------ ONES -------------------------

							case (bcd1) is

								 when "0000" => -- 0
									Output_7segHEX0 <= "1000000";	
							 
								 when "0001" => -- 1
									Output_7segHEX0 <= "1111001";

								 when "0010" => -- 2
									Output_7segHEX0 <= "0100100";	
							 
								 when "0011" => -- 3
									Output_7segHEX0 <= "0110000";	

								 when "0100" => -- 4
									Output_7segHEX0 <= "0011001";		
								
								 when "0101" => -- 5
									Output_7segHEX0 <= "0010010";		

								 when "0110" => -- 6
									Output_7segHEX0 <= "0000010";	

								 when "0111" => -- 7
									Output_7segHEX0 <= "1111000";	

								 when "1000" => -- 8
									Output_7segHEX0 <= "0000000";	

								 when "1001" => -- 9
									Output_7segHEX0 <= "0010000";
								 when others =>
									Output_7segHEX0 <= "1111111";
						end case;

						------------ TENS -------------------------

							case (bcd2) is

								 when "0000" => -- 0
									Output_7segHEX1 <= "1000000";	
							 
								 when "0001" => -- 1
									Output_7segHEX1 <= "1111001";

								 when "0010" => -- 2
									Output_7segHEX1 <= "0100100";	
							 
								 when "0011" => -- 3
									Output_7segHEX1 <= "0110000";	

								 when "0100" => -- 4
									Output_7segHEX1 <= "0011001";		
								
								 when "0101" => -- 5
									Output_7segHEX1 <= "0010010";		

								 when "0110" => -- 6
									Output_7segHEX1 <= "0000010";	

								 when "0111" => -- 7
									Output_7segHEX1 <= "1111000";	

								 when "1000" => -- 8
									Output_7segHEX1 <= "0000000";	

								 when "1001" => -- 9
									Output_7segHEX1 <= "0010000";
								 when others =>
									Output_7segHEX1 <= "1111111";
						end case;	

						------------ HUNDREDS ---------------------

							case (bcd3) is

								 when "0000" => -- 0
									Output_7segHEX2 <= "1000000";	
							 
								 when "0001" => -- 1
									Output_7segHEX2 <= "1111001";

								 when "0010" => -- 2
									Output_7segHEX2 <= "0100100";		
								 when others =>
									Output_7segHEX2 <= "1111111";
							end case;							
									
					end if;
				when CU_EXECUTE_STATE =>
					--todomartin : Display the CU State as '05 EC' in 7-Segments HEX 7 to 4
		
					Output_7segHEX7 <= "1000000";
					Output_7segHEX6 <= "0010010";
					Output_7segHEX5 <= "0000110";
					Output_7segHEX4 <= "1000110";
					Output_7segHEX3 <= "1111111";
					Output_7segHEX2 <= "1111111";
					Output_7segHEX1 <= "1111111";	
					Output_7segHEX0 <= "1111111";
		
				when CU_OUTPUT_STATE =>
					
					-- Perform the Output only when control signal is true.
					if(Output_cntrlCU_enblOut = CU_ENABLE) then
						--todomartin : Display the CU State as '06 OP' in 7-Segments HEX 7 to 4					
					
					
					Output_7segHEX7 <= "1000000";
					Output_7segHEX6 <= "0000010";
					Output_7segHEX5 <= "1000000";
					Output_7segHEX4 <= "0001100";
					Output_7segHEX3 <= "0110111";
					
					
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
						
									------------ BCD Conversion--------------
									bcd         := (others => '0');
									binx        := temp_mem;

									for i in binx'range loop
									  if bcd(3 downto 0) > "0100" then
										 bcd(3 downto 0) := std_logic_vector(unsigned(bcd(3 downto 0)) + "0011"); 

									  end if ;
									  if bcd(7 downto 4) > "0100" then
										  bcd(7 downto 4) := std_logic_vector(unsigned(bcd(7 downto 4)) + "0011");    
									  end if ;
									  bcd := bcd(10 downto 0) & binx(7); 
									  binx := binx(6 downto 0) & '0'; 
									end loop ;

									bcd3 := bcd(11 downto 8);
									bcd2 := bcd(7  downto 4);
									bcd1 := bcd(3  downto 0);

									Output_ledDataInShw <= binx;
									
									------------ ONES -------------------------

										case (bcd1) is

											 when "0000" => -- 0
												Output_7segHEX0 <= "1000000";	
										 
											 when "0001" => -- 1
												Output_7segHEX0 <= "1111001";

											 when "0010" => -- 2
												Output_7segHEX0 <= "0100100";	
										 
											 when "0011" => -- 3
												Output_7segHEX0 <= "0110000";	

											 when "0100" => -- 4
												Output_7segHEX0 <= "0011001";		
											
											 when "0101" => -- 5
												Output_7segHEX0 <= "0010010";		

											 when "0110" => -- 6
												Output_7segHEX0 <= "0000010";	

											 when "0111" => -- 7
												Output_7segHEX0 <= "1111000";	

											 when "1000" => -- 8
												Output_7segHEX0 <= "0000000";	

											 when "1001" => -- 9
												Output_7segHEX0 <= "0010000";
											 when others =>
												Output_7segHEX0 <= "1111111";
									end case;

									------------ TENS -------------------------

										case (bcd2) is

											 when "0000" => -- 0
												Output_7segHEX1 <= "1000000";	
										 
											 when "0001" => -- 1
												Output_7segHEX1 <= "1111001";

											 when "0010" => -- 2
												Output_7segHEX1 <= "0100100";	
										 
											 when "0011" => -- 3
												Output_7segHEX1 <= "0110000";	

											 when "0100" => -- 4
												Output_7segHEX1 <= "0011001";		
											
											 when "0101" => -- 5
												Output_7segHEX1 <= "0010010";		

											 when "0110" => -- 6
												Output_7segHEX1 <= "0000010";	

											 when "0111" => -- 7
												Output_7segHEX1 <= "1111000";	

											 when "1000" => -- 8
												Output_7segHEX1 <= "0000000";	

											 when "1001" => -- 9
												Output_7segHEX1 <= "0010000";
											 when others =>
												Output_7segHEX1 <= "1111111";
									end case;	

									------------ HUNDREDS ---------------------

										case (bcd3) is

											 when "0000" => -- 0
												Output_7segHEX2 <= "1000000";	
										 
											 when "0001" => -- 1
												Output_7segHEX2 <= "1111001";

											 when "0010" => -- 2
												Output_7segHEX2 <= "0100100";		
											 when others =>
												Output_7segHEX2 <= "1111111";
										end case;
						
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