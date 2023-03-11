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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.NUMERIC_STD.all;

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
	
	signal reg0_opcode			: typ_databus 	:= typ_databus_ini;
	signal reg1_data1				: typ_databus 	:= typ_databus_ini;
	signal reg2_data2				: typ_databus 	:= typ_databus_ini;
	signal reg3_out				: typ_databus 	:= typ_databus_ini;
	signal preVal_ReqEnbl 		: typ_cu_cntrlsig := CU_DISABLE;
	
begin

	process(ALU_rst, ALU_clk, ALU_cntrlCU_enblALU)
	
	-- To store how cycles are required by the entity
	constant no_of_states 	: integer := 8;
	variable cntrState		: integer range 0 to no_of_states := 0;	
	
	begin
	
		if(ALU_rst = RESET_PRESSED) then
			ALU_stOprtn <= CU_NOWAIT;
										
			
		elsif(rising_edge(ALU_clk)) then
		
			-- To check for rising edge
			if(ALU_cntrlCU_enblALU /= preVal_ReqEnbl) then
			  if(ALU_cntrlCU_enblALU = CU_ENABLE) then
				  cntrState := 0;
				 end if;
				preVal_ReqEnbl <= ALU_cntrlCU_enblALU;
			end if;	
	
						
			-- Perform the ALU only when control signal is true.
			if(ALU_cntrlCU_enblALU = CU_ENABLE) then
			
				-- ALU sets the status as cpu is in use and should be holded
				ALU_stOprtn <= CU_WAIT;
				
				
				case cntrState is
		
					when 0 =>
						-- Req to Read content of MEMLAY_OPCODE
						ALU_memEnblWr <= MEM_READ_EN;
						ALU_memAddr <= MEMLAY_OPCODE;
					
					when 1 =>
						-- Reading Stored MEMLAY_OPCODE
						reg0_opcode <= ALU_memDataRd;
						
					when 2 =>
						-- Req to Read content of MEMLAY_DATA1
						ALU_memEnblWr <= MEM_READ_EN;
						ALU_memAddr <= MEMLAY_DATA1;
						
					when 3 =>
						-- Reading Stored MEMLAY_DATA1
						reg1_data1 <= ALU_memDataRd;				
					
					when 4 =>				
						-- Check if the opcode is invert, it does not need second operand
						if(reg0_opcode(OPCODE_WIDTH downto 0) /= OPCODE_INV) then
							-- Req to Read content of MEMLAY_DATA2
							ALU_memEnblWr <= MEM_READ_EN;
							ALU_memAddr <= MEMLAY_DATA2;
						end if;
						
					when 5 =>
						-- Check if the opcode is invert, it does not need second operand
						if(reg0_opcode(OPCODE_WIDTH downto 0) /= OPCODE_INV) then
						-- Reading Stored MEMLAY_DATA2
							reg2_data2 <= ALU_memDataRd;	
						end if;
						
					when 6 =>
						-- Perform the ALU functions and store output to reg3_out
						
						case(reg0_opcode(OPCODE_WIDTH downto 0)) is
							when OPCODE_ADD => -- Addition
							 reg3_out <= reg1_data1 + reg2_data2 ; 
							 
							when OPCODE_SUB => -- Subtraction
							 reg3_out <= reg1_data1 - reg2_data2 ;
							 
							when OPCODE_BITSHIFTL => -- Logical shift left
							 reg3_out <= std_logic_vector(unsigned(reg1_data1) sll conv_integer(reg2_data2));
							 
							when OPCODE_BITSHIFTR => -- Logical shift right
							 reg3_out <= std_logic_vector(unsigned(reg1_data1) srl conv_integer(reg2_data2));
							 
							when OPCODE_AND => -- Logical and 						
							 reg3_out <= reg1_data1 and reg2_data2;
							 
							when OPCODE_OR => -- Logical or
							 reg3_out <= reg1_data1 or reg2_data2;
							 
							when OPCODE_XOR => -- Logical xor 
							 reg3_out <= reg1_data1 xor reg2_data2;
							 
							when OPCODE_INV => -- Logical not
							 reg3_out <= not(reg1_data1);
							 
							when others =>
							 NULL;
						end case;
						
						
						
					when 7 =>
						-- Write the calculated output to the memory MEMLAY_REG_R1
						ALU_memEnblWr <= MEM_WRITE_EN;
						ALU_memAddr <= MEMLAY_REG_R1;
						ALU_memDataWr	<= reg3_out;	
					
					when no_of_states =>
							-- Empty
				end case;
				
				if (cntrState < no_of_states) then
					cntrState := cntrState + 1;
				end if;
					
				
					
			end if;
			
			
			if(cntrState >= no_of_states) then
				ALU_stOprtn <= CU_NOWAIT;
			end if;
			
			
		end if;
	end process;
	

end architecture ALU_A;