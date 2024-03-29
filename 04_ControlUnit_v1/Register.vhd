-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- Register_Add Entity
entity Register_E is

	port(	Register_rst					:	in typ_rst;
			Register_clk					:	in typ_clk;
			Register_cntrlCU_enblPC		:	in typ_cu_cntrlsig;						-- Control signal from CPU
			Register_cntrlCU_enblIR		:	in typ_cu_cntrlsig;						-- Control signal from CPU
			Register_memDataRd			:	in typ_mem_reg;							-- Memory Data Read
			
			Register_stPCOprtn			:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of PC Operation
			Register_stIROprtn			:	out typ_cu_cntrlsig	:= CU_NOWAIT;	-- Status of IR Operation
			Register_memAddr				:	out typ_addr := 0;						-- Memory Address
			Register_memDataWr			:	out typ_mem_reg;							-- Memory Data Write
			Register_memEnblWr			:	out typ_cu_cntrlsig := '0'							-- Memory Data Write
			);

end entity Register_E;



architecture Register_A of Register_E is
	
	signal tempStrg		: typ_mem_reg 	:= 0;						-- data that is read
	
begin

	process(Register_rst, Register_clk, Register_cntrlCU_enblPC)
	
	-- To store how cycles are required by the entity
	variable cntrState	: integer range 0 to 4 		:= 0;	
	
	
	begin
		if(rising_edge(Register_clk)) then
						
			-- Perform the Register only when control signal is true.
			if(Register_cntrlCU_enblPC = CU_ENABLE and
				Register_cntrlCU_enblIR = CU_ENABLE) then
			
				-- Register sets the status as cpu is in use and should be holded
				Register_stPCOprtn <= CU_WAIT;
				
				
				case cntrState is
		
				when 0 =>					
					-- Storing PC
					Register_memEnblWr <= '1';
					Register_memAddr <= MEMLAY_REG_PC;
					Register_memDataWr	<= 2;
				
				when 1 =>
					-- Req to Read Stored DATA1
					Register_memEnblWr <= '0';
					Register_memAddr <= MEMLAY_DATA1;
					
				when 2 =>
					-- Reading Stored DATA1
					tempStrg <= Register_memDataRd;
					
				when 3 =>
					-- Storing Read PC in IR
					Register_memEnblWr <= '1';
					Register_memAddr <= MEMLAY_REG_IR;
					Register_memDataWr	<= tempStrg;				
				
				
				when 4 =>
						--Empty
				end case;
				
				cntrState := cntrState + 1;	
				
			end if;
			
			
			if(cntrState >= 4) then			
		
				Register_stPCOprtn <= CU_NOWAIT; 				
				cntrState := 0;
			end if;				
						
			
		end if;
	end process;
	

end architecture Register_A;