------------------------------------------------------------------------------------------------
--		University             : Hochschule Anhalt
--		Group                  :     
--		Authors                : 
--		                         
--		Degree Course          : Electrical and Computer Engineering (M. Eng.)
--		Subject                : Harware Software Co Deisgn
--		File Name              : Register.vhd
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
-- Register Entity
--------------------------
entity Register_E is

	port(	Register_rst					:	in typ_rst;
			Register_clk					:	in typ_clk;
			Register_cntrlCU_enblReg	:	in typ_cu_cntrlsig;						-- Control signal from CPU
			Register_memDataRd			:	in typ_databus:= typ_databus_ini;	-- Data read from RAM
			
			Register_stOprtn				:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of Reg Operation
			Register_memAddr				:	out typ_addrbus := typ_addrbus_ini;	-- Address to read/write
			Register_memDataWr			:	out typ_databus := typ_databus_ini;	-- Data to be written
			Register_memEnblWr			:	out typ_cu_cntrlsig := CU_DISABLE	-- Read or Write enable	
			);

end entity Register_E;



-----------------------------
--         Architecture
-----------------------------
architecture Register_A of Register_E is
	
	signal temp_mem			: typ_databus 	:= typ_databus_ini; --store temporarily
	signal preVal_ReqEnbl 	: typ_cu_cntrlsig := CU_DISABLE;
	
	
begin

	process(Register_rst, Register_clk, Register_cntrlCU_enblReg, Register_memDataRd)
	
	
	-- To store how cycles are required by the entity
	constant no_of_states 	: integer := 4;
	variable cntrState		: integer range 0 to no_of_states := 0;	
	
	begin
	
		
		if(Register_rst = RESET_PRESSED) then
			Register_stOprtn <= CU_NOWAIT;
										
			
		elsif(rising_edge(Register_clk)) then
						
			-- To check for rising edge
			if(Register_cntrlCU_enblReg /= preVal_ReqEnbl) then
			  if(Register_cntrlCU_enblReg = CU_ENABLE) then
				  cntrState := 0;
				 end if;
				preVal_ReqEnbl <= Register_cntrlCU_enblReg;
			end if;	
	
	
			
			-- Run only when control signal is true
			if(Register_cntrlCU_enblReg = CU_ENABLE) then
			
				-- Register sets the status as cpu is in use and should be holded
				Register_stOprtn <= CU_WAIT;
				
				
				case cntrState is
		
				when 0 =>					
					-- Storing the Opcode address at PC
					Register_memEnblWr <= MEM_WRITE_EN;
					Register_memAddr <= MEMLAY_REG_PC;
					Register_memDataWr	<= MEMLAY_OPCODE;
				
				when 1 =>
					-- Req to Read Stored MEMLAY_OPCODE
					Register_memEnblWr <= MEM_READ_EN;
					Register_memAddr <= MEMLAY_OPCODE;
					
				when 2 =>
					-- Reading Stored MEMLAY_OPCODE
					temp_mem <= Register_memDataRd;
					
				when 3 =>
					-- Storing Read opcode value to IR
					Register_memEnblWr <= MEM_WRITE_EN;
					Register_memAddr <= MEMLAY_REG_IR;
					Register_memDataWr	<= temp_mem;				
				
				
				when no_of_states =>
						-- Empty
				end case;
				
				if (cntrState < no_of_states) then
					cntrState := cntrState + 1;
				end if;
					
				
			end if;
			
			
			if(cntrState >= no_of_states) then
				Register_stOprtn <= CU_NOWAIT;
			end if;				
						
			
		end if;
	end process;
	

end architecture Register_A;