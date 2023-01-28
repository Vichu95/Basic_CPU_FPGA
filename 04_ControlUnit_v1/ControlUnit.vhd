-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

-- Import user package
library work;
use work.Common_P.all;

-- ControlUnit Entity
entity ControlUnit_E is

	port(	CU_rst			:	in typ_rst;
			CU_clk			:	in typ_clk;
			CU_clkDeb		:	in typ_clk;
			CU_btnCnfrmRaw	:	in typ_in_btn;
			CU_swtDataIn	:	in typ_8bitdata;
			CU_swtOpcodIn	:	in typ_opcod;
			
			CU_ledDataInShw	:	out typ_8bitdata;
			CU_ledOpcodInShw	:	out typ_opcod;
			CU_7segOut1Shw		:	out std_logic_vector(6 downto 0);
			CU_7segOut10Shw	:	out std_logic_vector(6 downto 0);
			CU_7segOut100Shw	:	out std_logic_vector(6 downto 0)
			
			);


end entity ControlUnit_E;


-- ControlUnit Architecture
architecture ControlUnit_A of ControlUnit_E is

	-- Variables for state machine
	signal CU_crntState, CU_nxtState : enum_CU_state;
	
	-- Control Unit signals to control the modules
	signal CU_cntrlRdIn 	: typ_CU_cntrlsig := CU_DISABLE;				-- for Input 
	signal CU_cntrlPC 	: typ_CU_cntrlsig := CU_DISABLE;				-- for PC 
	signal CU_cntrlIR 	: typ_CU_cntrlsig := CU_DISABLE;				-- for IR 
	signal CU_cntrlALU 	: typ_CU_cntrlsig := CU_DISABLE;				-- for ALU 
	signal CU_cntrlOut 	: typ_CU_cntrlsig := CU_DISABLE;				-- for Output
	signal CU_cntrlMem 	: typ_CU_cntrlsig := CU_DISABLE;				-- for Memory
	
	-- Wait flags to sync the other module operations
	signal CU_flgInWait		: typ_CU_cntrlsig := CU_NOWAIT;			-- for Input
	signal CU_flgRegPCWait	: typ_CU_cntrlsig := CU_NOWAIT;			-- for PC
	signal CU_flgRegIRWait	: typ_CU_cntrlsig := CU_NOWAIT;			-- for IR
	signal CU_flgALUWait		: typ_CU_cntrlsig := CU_NOWAIT;			-- for ALU
	signal CU_flgOutWait		: typ_CU_cntrlsig := CU_NOWAIT;			-- for Output
	signal CU_flgMemWait		: typ_CU_cntrlsig := CU_NOWAIT;			-- for Memory

	-- Button Status
	signal CU_btnCnfrm	:	typ_in_btn	:= BTN_NOTPRESSED; 			--tobechecked all uses also
	-- tobechecked
	signal CU_regA		: typ_mem_reg 	:= 0;						-- ALU calculated output through Accumulator
	
	-- Connections for Memory
	signal CU_memAddr			: typ_addr := 0;						-- address to write
	signal CU_memAddrIn		: typ_addr := 0;						-- address to write
	signal CU_memAddrReg		: typ_addr := 0;						-- address to write
	
	signal CU_memDataWr		: typ_mem_reg 	:= 0;						-- data to write
	signal CU_memDataWrIn	: typ_mem_reg 	:= 0;						-- data to write
	signal CU_memDataWrReg	: typ_mem_reg 	:= 0;						-- data to write
	
	signal CU_memDataRd		: typ_mem_reg 	:= 0;						-- data that is read
	signal CU_memDataRdIn		: typ_mem_reg 	:= 0;						-- data that is read
	signal CU_memDataRdReg		: typ_mem_reg 	:= 0;						-- data that is read
	
	
	signal CU_memEnblWr		: typ_CU_cntrlsig 	:= '0';			-- data that is read
	signal CU_memEnblWrIn	: typ_CU_cntrlsig 	:= '0';			-- data that is read Reg
	signal CU_memEnblWrReg	: typ_CU_cntrlsig 	:= '0';			-- data that is read Reg
	
		
	--------------
	-- Procedures
	--------------	
	procedure CU_rstCntrlSig(
										signal CU_cntrlRdIn 	: inout typ_CU_cntrlsig;
										signal CU_cntrlPC 	: inout typ_CU_cntrlsig;
										signal CU_cntrlIR 	: inout typ_CU_cntrlsig;
										signal CU_cntrlALU 	: inout typ_CU_cntrlsig;
										signal CU_cntrlOut 	: inout typ_CU_cntrlsig
										) is
	begin
		CU_cntrlRdIn	<= CU_DISABLE;
		CU_cntrlPC		<= CU_DISABLE;
		CU_cntrlIR		<= CU_DISABLE;
		CU_cntrlALU		<= CU_DISABLE;
		CU_cntrlOut		<= CU_DISABLE;
	end procedure;

	
begin
	
	------------
	-- Instances
	------------
	
--	-- tobechecked
		
	-- Memory entity	
	Memory_inst : entity work.Memory_E(Memory_A) 
	port map(
		Memory_rst					=> CU_rst,
		Memory_clk					=> CU_clk,
		Memory_addrRd				=> CU_memAddr,
		Memory_memDataWr			=> CU_memDataWr,
		Memory_enblWr				=> CU_memEnblWr,
		Memory_cntrlCU_enblMem	=> CU_cntrlMem,
		Memory_stOprtn				=> CU_flgMemWait,
		Memory_memDataRd			=> CU_memDataRd
		);
		
	-- Input entity	
	Input_inst : entity work.Input_E(Input_A) 
	port map(
		Input_rst					=> CU_rst,
		Input_clk					=> CU_clk,
		Input_clkDeb				=> CU_clkDeb,
		Input_btnCnfrmRaw			=> CU_btnCnfrmRaw,
		Input_swtDataIn			=> CU_swtDataIn,
		Input_swtOpcodIn 			=> CU_swtOpcodIn,
		Input_cntrlCU_enblRdIn	=> CU_cntrlRdIn,
		Input_memDataRd			=>	CU_memDataRdIn,
		
		Input_stOprtn				=> CU_flgInWait,
		Input_btnCnfrm				=> CU_btnCnfrm,
		Input_memAddr				=> CU_memAddrIn,
		Input_memDataWr			=> CU_memDataWrIn,
		Input_memEnblWr			=>	CU_memEnblWrIn
		);
		
	-- ALU entity
	ALU_inst : entity work.ALU_E(ALU_A) 
		port map(
		ALU_rst					=> CU_rst,
		ALU_clk					=> CU_clk,
		ALU_cntrlCU_enblALU	=> CU_cntrlALU,
		
		ALU_stOprtn				=> CU_flgALUWait
		);
		
	-- Register entity
	Register_inst : entity work.Register_E(Register_A) 
		port map(
		Register_rst					=> CU_rst,
		Register_clk					=> CU_clk,
		Register_cntrlCU_enblPC		=> CU_cntrlPC,
		Register_cntrlCU_enblIR		=> CU_cntrlIR,
		Register_memDataRd			=>	CU_memDataRdReg,
		
		Register_stPCOprtn			=> CU_flgRegPCWait,
		Register_stIROprtn			=> CU_flgRegIRWait,
		Register_memAddr				=> CU_memAddrReg,
		Register_memDataWr			=> CU_memDataWrReg,
		Register_memEnblWr			=>	CU_memEnblWrReg
		);
	
	-- Output entity	
	Output_inst : entity work.Output_E(Output_A) 
	port map(
		Output_rst					=> CU_rst,
		Output_clk					=> CU_clk,
		Output_cntrlCU_enblOut	=> CU_cntrlOut,
		
		Output_stOprtn				=> CU_flgOutWait,
		Output_ledDataInShw		=> CU_ledDataInShw,
		Output_ledOpcodInShw		=> CU_ledOpcodInShw,
		Output_7segOut1Shw		=> CU_7segOut1Shw,
		Output_7segOut10Shw		=> CU_7segOut10Shw,
		Output_7segOut100Shw		=> CU_7segOut100Shw
		);

	
	-------------------------------------------------------------------
	-- State machine which controls next states and control signals
	-------------------------------------------------------------------
	CU_StateFlow:process(CU_crntState,CU_btnCnfrm)
	begin
		CU_nxtState <= CU_crntState; -- by default, next state is current state					
	
		case CU_crntState is
		
			when CU_IDLE_STATE =>
			
				if(CU_btnCnfrm = BTN_PRESSED) then
					CU_nxtState <= CU_READ_OPCODE_STATE;
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlPC, CU_cntrlIR, CU_cntrlALU, CU_cntrlOut);
				end if ;
				
			when CU_READ_OPCODE_STATE =>
		
				if(CU_btnCnfrm = BTN_PRESSED) then
					CU_nxtState <= CU_FETCH_STATE;
	
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlPC, CU_cntrlIR, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlRdIn <= CU_ENABLE; -- Trigger Read Operation
					--todo call memory write with MEMLAY_OPCODE
					CU_cntrlMem <= CU_ENABLE;
				end if ;
				
			when CU_FETCH_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
					--todo create a function check to see if 1 or 2 data is needed
					CU_nxtState <= CU_READ_DATA1_STATE;
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlPC, CU_cntrlIR, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlPC <= CU_ENABLE; -- Trigger PC Update
					CU_cntrlIR <= CU_ENABLE; -- Trigger IR Update
					CU_cntrlMem <= CU_ENABLE;
--					CU_memAddr <= CU_memAddrReg;
--					CU_memDataWr <= CU_memDataWrReg;
					
				end if;
				
			when CU_READ_DATA1_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
					CU_nxtState <= CU_READ_DATA2_STATE;
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlPC, CU_cntrlIR, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlRdIn <= CU_ENABLE; -- Trigger Read Operation
					--todo call memory write with MEMLAY_DATA1
				end if;
	
			when CU_READ_DATA2_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
					CU_nxtState <= CU_EXECUTE_STATE;
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlPC, CU_cntrlIR, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlRdIn <= CU_ENABLE; -- Trigger Read Operation
					--todo call memory write with MEMLAY_DATA2
				end if;
	
			when CU_EXECUTE_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
					CU_nxtState <= CU_OUTPUT_STATE;
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlPC, CU_cntrlIR, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlALU <= CU_ENABLE; -- Trigger ALU Operation
					
				end if;
	
			when CU_OUTPUT_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
					CU_nxtState <= CU_IDLE_STATE;
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlPC, CU_cntrlIR, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlOut <= CU_ENABLE; -- Trigger Output Operation
				end if;
				
		end case;
		
	end process CU_StateFlow;
	
	
	----------------------------------------------------------------------------------
	-- Sync process to update current cycle based on previous calculated next cycle
	----------------------------------------------------------------------------------
	CU_StateSync:process(CU_rst, CU_clk)
	begin
		if(CU_rst = '1') then
			CU_crntState <= CU_IDLE_STATE;
										
			
		elsif(falling_edge(CU_clk)) then
		
			-- Only update next state when no other modules are using the resources
			if(
				CU_flgInWait		= CU_NOWAIT and
				CU_flgRegPCWait	= CU_NOWAIT and
				CU_flgRegIRWait	= CU_NOWAIT and
				CU_flgALUWait		= CU_NOWAIT and
				CU_flgOutWait		= CU_NOWAIT
				) then
				CU_crntState <= CU_nxtState;
				
			end if;			
		end if;			
	
	end process CU_StateSync;
	
	
		
	-------------------------------------------------------------------
	-- State machine which controls next states and control signals
	-------------------------------------------------------------------
	CU_MemFlowReg:process(CU_memAddrReg,CU_memDataWrReg, CU_memDataRd, CU_memAddrIn,CU_memDataWrIn, CU_memDataRd)
	begin				
	
--		CU_memAddr <= CU_memAddrReg;
--		CU_memDataWr <= CU_memDataWrReg;
--		CU_memEnblWr <= CU_memEnblWrReg;
--		CU_memDataRdReg <= CU_memDataRd;	
		
		case CU_crntState is
		
			when CU_IDLE_STATE =>
				
			when CU_READ_OPCODE_STATE =>
	
				CU_memAddr <= CU_memAddrIn;
				CU_memDataWr <= CU_memDataWrIn;
				CU_memEnblWr <= CU_memEnblWrIn;
				CU_memDataRdIn <= CU_memDataRd;	
				
			when CU_FETCH_STATE =>	
				CU_memAddr <= CU_memAddrReg;
				CU_memDataWr <= CU_memDataWrReg;
				CU_memEnblWr <= CU_memEnblWrReg;
				CU_memDataRdReg <= CU_memDataRd;	
				
			when CU_READ_DATA1_STATE =>
	
			when CU_READ_DATA2_STATE =>
	
			when CU_EXECUTE_STATE =>
	
			when CU_OUTPUT_STATE =>
				
		end case;
		
	end process CU_MemFlowReg;
--	
--	CU_MemFlowIn:process(CU_memAddrIn,CU_memDataWrIn, CU_memDataRd)
--	begin				
--	
--		CU_memAddr <= CU_memAddrIn;
--		CU_memDataWr <= CU_memDataWrIn;
--		CU_memEnblWr <= CU_memEnblWrIn;
--		CU_memDataRdIn <= CU_memDataRd;	
--		
--	end process CU_MemFlowIn;
	
	
end architecture ControlUnit_A;