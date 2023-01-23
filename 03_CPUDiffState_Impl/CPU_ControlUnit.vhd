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
	signal Mem_crntState, Mem_nxtState : enum_mem_state;
	
	signal CPU_cntrlALU 	: typ_cpu_cntrlsig := '0';				-- CPU control signal to trigger ALU operation
	signal CPU_cntrlOut 	: typ_cpu_cntrlsig := '0';				-- CPU control signal to trigger Output block
	signal CPU_cntrlMem 	: typ_cpu_cntrlsig := '0';				-- CPU control signal to trigger Memory block
	signal CPU_flgMemAcc	: typ_cpu_cntrlsig := '0';				-- CPU control signal to start Memory SM
	
	signal CPU_flgALUWait	: typ_cpu_cntrlsig := '0';			-- CPU waiting for completion of ALU operation
	signal CPU_flgOutputWait: typ_cpu_cntrlsig := '0';			-- CPU waiting for completion of Output operation
	signal CPU_flgMemoryWait: typ_cpu_cntrlsig := '0';			-- CPU waiting for completion of Memory operation
	
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
		
	-- Memory entity	
	Memory_inst : entity work.Memory_E(Memory_A) 
	port map(
		Memory_rst				=> CPU_rst,
		Memory_clk				=> CPU_clk,
		Memory_cntrlSigCPU	=> CPU_cntrlMem,
		Memory_regA				=> CPU_regA,
		Memory_stOprtn			=> CPU_flgMemoryWait
		);

	
	
	-- Main state machine which controls next states and control signals
	CPU_StateFlow:process(CPU_crntState,CPU_btnNext)
	begin
		CPU_nxtState <= CPU_crntState; -- by default, next state is current state					
		
		
		if(Mem_crntState = MEM_END) then
			CPU_flgMemAcc <= CPU_DISABLE;
		end if;				
		
		
		case CPU_crntState is
		
			when CPU_IDLE =>
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_READ_OPCODE;
					CPU_cntrlALU <= CPU_DISABLE; -- Reset ALU Operation
					CPU_cntrlOut <= CPU_DISABLE; -- Reset out Operation
					CPU_flgMemAcc <= CPU_DISABLE;-- Reset mem access
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
					
					CPU_flgMemAcc <= CPU_ENABLE; -- Need Memory Access
					
				end if;
	
			when CPU_OUTPUT =>
				if(CPU_btnNext = BTN_PRESSED) then
					CPU_nxtState <= CPU_IDLE;
					CPU_cntrlALU <= CPU_DISABLE; -- Reset ALU Operation
					CPU_cntrlOut <= CPU_ENABLE; -- Trigger out Operation
				end if;
				
		end case;
		
	end process CPU_StateFlow;
	
	
	
	-- Main state machine which controls next states of Memory
	Mem_StateFlow:process(Mem_crntState,CPU_flgMemAcc)
	begin
		Mem_nxtState <= Mem_crntState; -- by default, next state is current state					
	
		case Mem_crntState is
		
			when MEM_IDLE =>
				CPU_cntrlMem <= CPU_DISABLE;
				if(CPU_flgMemAcc = CPU_ENABLE) then
					Mem_nxtState <= MEM_START;
				end if;				
				
			when MEM_START =>
						
				Mem_nxtState <= MEM_END;
				CPU_cntrlMem <= CPU_ENABLE;
				
--			when MEM_READ =>
--				if(CPU_btnNext = BTN_PRESSED) then
--					Mem_nxtState <= MEM_END;
--				end if;
--	
--			when MEM_WRITE =>
--				if(CPU_btnNext = BTN_PRESSED) then
--					Mem_nxtState <= MEM_END;
--				end if;
	
			when MEM_END =>
				Mem_nxtState <= MEM_IDLE;
				CPU_cntrlMem <= CPU_DISABLE;
					
		end case;
		
	end process Mem_StateFlow;
	
	
	
	-- Sync process to update current cycle based on previous calculated next cycle
	CPU_StateSync:process(CPU_rst, CPU_clk)
	begin
		if(CPU_rst = '1') then
			CPU_crntState <= CPU_IDLE;
			
		elsif(falling_edge(CPU_clk)) then
		
			-- Only update next state when CPU is not used
			if(CPU_flgALUWait 	= CPU_NOWAIT and
				CPU_flgOutputWait = CPU_NOWAIT and
				CPU_flgMemoryWait = CPU_NOWAIT ) then
				
				if(CPU_flgMemAcc 	= CPU_DISABLE ) then
					CPU_crntState <= CPU_nxtState;
				else
					Mem_crntState <= Mem_nxtState;
				end if;			
				
			end if;			
		end if;			
	
	end process CPU_StateSync;
	
	
end architecture CPU_ControlUnit_A;