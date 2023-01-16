-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;


-- CPU_ControlUnit Entity
entity CPU_ControlUnit_E is

	port(	CPU_rst			:	in std_logic;
			CPU_clk			:	in std_logic;
			CPU_btnNext		:	in std_logic;
			CPU_opcodRead	:	in std_logic
			);


end entity CPU_ControlUnit_E;


-- CPU_ControlUnit Architecture
architecture CPU_ControlUnit_A of CPU_ControlUnit_E is
	--Definitions
	type CPU_stateEnum is (	CPU_IDLE,
									CPU_READ_OPCODE,
									CPU_READ_DATA1,
									CPU_READ_DATA2,
									CPU_EXECUTE,
									CPU_OUTPUT
									);
	signal CPU_crntState, CPU_nxtState : CPU_stateEnum;
									

begin
	
	CPU_StateFlow:process(CPU_crntState, CPU_btnNext)
	begin
		CPU_nxtState <= CPU_crntState; -- by default, next state is current state
		
		case CPU_crntState is
		
			when CPU_IDLE =>
				if(CPU_btnNext = '1') then
					CPU_nxtState <= CPU_READ_OPCODE;
				end if;				
				
			when CPU_READ_OPCODE =>
				if(CPU_btnNext = '1') then
					CPU_nxtState <= CPU_READ_DATA1;
				end if;
				
			when CPU_READ_DATA1 =>
				if(CPU_btnNext = '1') then
					CPU_nxtState <= CPU_READ_DATA2;
				end if;
	
			when CPU_READ_DATA2 =>
				if(CPU_btnNext = '1') then
					CPU_nxtState <= CPU_EXECUTE;
				end if;
	
			when CPU_EXECUTE =>
				if(CPU_btnNext = '1') then
					CPU_nxtState <= CPU_OUTPUT;
				end if;
	
			when CPU_OUTPUT =>
				if(CPU_btnNext = '1') then
					CPU_nxtState <= CPU_IDLE;
				end if;
				
		end case;
	end process CPU_StateFlow;
	
	
	CPU_StateSync:process(CPU_rst, CPU_clk)
	begin
		if(CPU_rst = '1') then
			CPU_crntState <= CPU_IDLE;
			
		elsif(rising_edge(CPU_clk)) then
			CPU_crntState <= CPU_nxtState;
		end if;
			
	
	end process CPU_StateSync;
	
	
end architecture CPU_ControlUnit_A;