-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;


-- Output Entity
entity Output_E is

	port(	Output_rst				:	in std_logic;
			Output_clk				:	in std_logic;
			Output_cntrlSigCPU	:	in std_logic;		-- Control signal from CPU
			Output_regA				:	in natural;			-- Register or bus storing output data
			Output_LED				:	out natural	:= 0	-- LED showing output
			);

end entity Output_E;



architecture Output_A of Output_E is
	
	
begin

	process(Output_rst, Output_clk, Output_cntrlSigCPU)
	
	
	begin
		if(rising_edge(Output_clk)) then
			
			-- Output copies data from bus/register to LED/LCD/7seg
			if(Output_cntrlSigCPU = '1') then				
				Output_LED <= Output_regA; -- Final Output in LED
			end if;
			
		end if;
	end process;
	

end architecture Output_A;