-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;


-- ALU_Add Entity
entity ALU_Add_E is

	port(	ALU_rst				:	in std_logic;
			ALU_clk				:	in std_logic;
			ALU_cntrlSigCPU	:	in std_logic;		-- Control signal from CPU
			ALU_acc				:	out natural	:= 0	-- Accumulator for storing calculated signals
			);

end entity ALU_Add_E;



architecture ALU_Add_A of ALU_Add_E is
	
	
begin

	process(ALU_rst, ALU_clk, ALU_cntrlSigCPU)
	
	-- ALU just performs a counter operation  ## For testing
	variable temp_num: natural range 0 to 15 := 0;
	
	begin
		if(rising_edge(ALU_clk)) then
			
			-- Perform the ALU only when control signal is true.
			-- We can extend this by getting the OpCode, Data from CPU
			if(ALU_cntrlSigCPU = '1') then
				temp_num := temp_num + 1;		
				
				ALU_acc <= temp_num; -- Final Output in Accumulator
			end if;
			
		end if;
	end process;
	

end architecture ALU_Add_A;