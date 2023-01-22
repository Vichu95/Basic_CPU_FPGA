-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- CPU_ControlUnit Entity
entity CPU_ControlUnit_E is

	port(	CPU_rst			:	in typ_rst;
			CPU_clk			:	in typ_clk;
			CPU_btnNext		:	in typ_in_btn
			);


end entity CPU_ControlUnit_E;


-- CPU_ControlUnit Architecture
architecture CPU_ControlUnit_A of CPU_ControlUnit_E is

	signal CPU_crntState, CPU_nxtState : enum_CPU_state;
	
	signal CPU_cntrlALU 	: typ_cpu_cntrlsig := '0';				-- CPU control signal to trigger ALU operation
	signal CPU_cntrlOut 	: typ_cpu_cntrlsig := '0';				-- CPU control signal to trigger Output block
	
	signal CPU_flgALUWait	: typ_cpu_cntrlsig := '0';			-- CPU waiting for completion of ALU operation
	signal CPU_flgOutputWait: typ_cpu_cntrlsig := '0';			-- CPU waiting for completion of ALU operation
	
	signal CPU_regA		: typ_mem_reg 	:= 0;						-- ALU calculated output through Accumulator
									
									
begin
	
	------------
	-- Instances
	------------
	
	-- ALU entity
	ALU_inst : entity work.ALU_Add_E(ALU_Add_A) port map(CPU_rst, CPU_clk, CPU_cntrlALU, CPU_flgALUWait, CPU_regA);	
	
	-- Output entity	
	Output_inst : entity work.Output_E(Output_A) 
	port map(
		Output_rst				=> CPU_rst,
		Output_clk				=> CPU_clk,
		Output_cntrlSigCPU	=> CPU_cntrlOut,
		Output_regA				=> CPU_regA,
		Output_stOprtn			=> CPU_flgOutputWait,
		Output_LED				=> open
		);

	
	
	-- Main state machine which controls next states and control signals
	CPU_StateFlow:process(CPU_crntState,CPU_btnNext)
	begin
		CPU_nxtState <= CPU_crntState; -- by default, next state is current state					
	
		case CPU_crntState is
		
			when CPU_IDLE =>
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_READ_OPCODE;
					CPU_cntrlALU <= CPU_DISABLE; -- Reset ALU Operation
					CPU_cntrlOut <= CPU_DISABLE; -- Reset out Operation
				end if;				
				
			when CPU_READ_OPCODE =>
		
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_READ_DATA1;				
				end if ;
				
			when CPU_READ_DATA1 =>
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_READ_DATA2;
				end if;
	
			when CPU_READ_DATA2 =>
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_EXECUTE;
				end if;
	
			when CPU_EXECUTE =>
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_OUTPUT;
					
					CPU_cntrlALU <= CPU_ENABLE; -- Trigger ALU Operation
					
				end if;
	
			when CPU_OUTPUT =>
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_IDLE;
					CPU_cntrlALU <= CPU_DISABLE; -- Reset ALU Operation
					CPU_cntrlOut <= CPU_ENABLE; -- Trigger out Operation
				end if;
				
		end case;
		
	end process CPU_StateFlow;
	
	
	
	-- Sync process to update current cycle based on previous calculated next cycle
	CPU_StateSync:process(CPU_rst, CPU_clk)
	begin
		if(CPU_rst = '1') then
			CPU_crntState <= CPU_IDLE;
			
		elsif(falling_edge(CPU_clk)) then
		
			-- Only update next state when CPU is not used
			if(CPU_flgALUWait 	= CPU_NOWAIT and
				CPU_flgOutputWait = CPU_NOWAIT ) then
				CPU_crntState <= CPU_nxtState;
			end if;			
		end if;			
	
	end process CPU_StateSync;
	
	
end architecture CPU_ControlUnit_A;