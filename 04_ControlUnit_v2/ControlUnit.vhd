------------------------------------------------------------------------------------------------
--		University             : Hochschule Anhalt
--		Group                  :     
--		Authors                : 
--		                         
--		Degree Course          : Electrical and Computer Engineering (M. Eng.)
--		Subject                : Harware Software Co Deisgn
--		File Name              : ControlUnit.vhd
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
-- ControlUnit Entity
--------------------------
entity ControlUnit_E is

	port(	CU_rst				:	in typ_rst;
			CU_clk				:	in typ_clk;
			CU_clkDeb			:	in typ_clk;
			CU_btnCnfrmRaw		:	in typ_in_btn;
			CU_swtDataIn		:	in typ_databus;
			CU_swtOpcodIn		:	in typ_opcod;
			
			CU_ledDataInShw	:	out typ_databus;
			CU_ledOpcodInShw	:	out typ_opcod;
			CU_7segOut1Shw		:	out typ_out_7seg;
			CU_7segOut10Shw	:	out typ_out_7seg;
			CU_7segOut100Shw	:	out typ_out_7seg 
			);
end entity ControlUnit_E;


-----------------------------
--         Architecture
-----------------------------
architecture ControlUnit_A of ControlUnit_E is

	--------------------
	--  S I G N A L S     
	--------------------
	-- F or state machine
	signal CU_crntState, CU_nxtState : enum_CU_state;
	
	-- Control Unit signals to control the modules
	signal CU_cntrlRdIn 		: typ_CU_cntrlsig := CU_DISABLE;					-- for Input 
	signal CU_cntrlReg 		: typ_CU_cntrlsig := CU_DISABLE;					-- for Reg
	signal CU_cntrlALU 		: typ_CU_cntrlsig := CU_DISABLE;					-- for ALU 
	signal CU_cntrlOut 		: typ_CU_cntrlsig := CU_DISABLE;					-- for Output
	signal CU_cntrlMem 		: typ_CU_cntrlsig := CU_DISABLE;					-- for Memory
	
	-- Wait flags to sync with the other module operations
	signal CU_flgInWait		: typ_CU_cntrlsig := CU_NOWAIT;					-- for Input
	signal CU_flgRegWait		: typ_CU_cntrlsig := CU_NOWAIT;					-- for Reg
	signal CU_flgALUWait		: typ_CU_cntrlsig := CU_NOWAIT;					-- for ALU
	signal CU_flgOutWait		: typ_CU_cntrlsig := CU_NOWAIT;					-- for Output
	signal CU_flgMemWait		: typ_CU_cntrlsig := CU_NOWAIT;					-- for Memory

	-- Button Confirm - Debounced value from Input module
	signal CU_btnCnfrm		:	typ_in_btn	:= BTN_NOTPRESSED;
		
	-- Connections to interact with Memory module
	signal CU_memAddr			: typ_addrbus := typ_addrbus_ini;				-- Address passed to Memory Unit to read from or write to
	signal CU_memAddrIn		: typ_addrbus := typ_addrbus_ini;				-- Address requested from each modules
	signal CU_memAddrOut		: typ_addrbus := typ_addrbus_ini;
	signal CU_memAddrALU		: typ_addrbus := typ_addrbus_ini;
	signal CU_memAddrReg		: typ_addrbus := typ_addrbus_ini;
	
	signal CU_memDataWr		: typ_databus 	:= typ_databus_ini;				-- Data to be written is passed to Memory Unit
	signal CU_memDataWrIn	: typ_databus 	:= typ_databus_ini;				-- Data to be written from each modules
	signal CU_memDataWrOut	: typ_databus 	:= typ_databus_ini;
	signal CU_memDataWrALU	: typ_databus 	:= typ_databus_ini;
	signal CU_memDataWrReg	: typ_databus 	:= typ_databus_ini;
	
	signal CU_memDataRd		: typ_databus 	:= typ_databus_ini;				-- Data that is read coming from Memory unit
	signal CU_memDataRdIn	: typ_databus 	:= typ_databus_ini;				-- Data read is passed to each module
	signal CU_memDataRdOut	: typ_databus 	:= typ_databus_ini;
	signal CU_memDataRdALU	: typ_databus 	:= typ_databus_ini;
	signal CU_memDataRdReg	: typ_databus 	:= typ_databus_ini;
	
	signal CU_memEnblWr		: typ_CU_cntrlsig 	:= CU_DISABLE;				-- Enable Write signal passed to Memory Unit
	signal CU_memEnblWrIn	: typ_CU_cntrlsig 	:= CU_DISABLE;				-- Read or Write request from each module
	signal CU_memEnblWrOut	: typ_CU_cntrlsig 	:= CU_DISABLE;	
	signal CU_memEnblWrALU	: typ_CU_cntrlsig 	:= CU_DISABLE;	
	signal CU_memEnblWrReg	: typ_CU_cntrlsig 	:= CU_DISABLE;	
	
		
	-------------------------
	-- P R O C E D U R E S
	-------------------------	
	-- CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
	procedure CU_rstCntrlSig(
										signal CU_cntrlRdIn 	: inout typ_CU_cntrlsig;
										signal CU_cntrlReg 	: inout typ_CU_cntrlsig;
										signal CU_cntrlMem 	: inout typ_CU_cntrlsig;
										signal CU_cntrlALU 	: inout typ_CU_cntrlsig;
										signal CU_cntrlOut 	: inout typ_CU_cntrlsig
										) is
	begin
		CU_cntrlRdIn	<= CU_DISABLE;
		CU_cntrlReg		<= CU_DISABLE;
		CU_cntrlMem		<= CU_DISABLE;
		CU_cntrlALU		<= CU_DISABLE;
		CU_cntrlOut		<= CU_DISABLE;
	end procedure;

	
begin
	
	----------------------
	-- I N S T A N C E S
	----------------------
	
--	-- tobechecked
		
	-- Memory entity --	
	Memory_inst : entity work.Memory_E(Memory_A) 
	port map(
		-- in
		Memory_rst					=> CU_rst,
		Memory_clk					=> CU_clk,
		Memory_enblWr				=> CU_memEnblWr,
		Memory_addr					=> CU_memAddr,
		Memory_memDataWr			=> CU_memDataWr,
		Memory_cntrlCU_enblMem	=> CU_cntrlMem,
		-- out
		Memory_stOprtn				=> CU_flgMemWait,
		Memory_memDataRd			=> CU_memDataRd
		);
		
	-- Input entity	
	Input_inst : entity work.Input_E(Input_A) 
	port map(
		-- in
		Input_rst					=> CU_rst,
		Input_clk					=> CU_clk,
		Input_clkDeb				=> CU_clkDeb,
		Input_btnCnfrmRaw			=> CU_btnCnfrmRaw,
		Input_swtDataIn			=> CU_swtDataIn,
		Input_swtOpcodIn 			=> CU_swtOpcodIn,
		Input_cntrlCU_enblRdIn	=> CU_cntrlRdIn,
		Input_crntCUState			=> CU_crntState,
		Input_memDataRd			=>	CU_memDataRdIn,
		-- out
		Input_stOprtn				=> CU_flgInWait,
		Input_btnCnfrm				=> CU_btnCnfrm,
		Input_memAddr				=> CU_memAddrIn,
		Input_memDataWr			=> CU_memDataWrIn,
		Input_memEnblWr			=>	CU_memEnblWrIn
		);
		
	-- ALU entity
	ALU_inst : entity work.ALU_E(ALU_A) 
		port map(
		-- in
		ALU_rst					=> CU_rst,
		ALU_clk					=> CU_clk,
		ALU_cntrlCU_enblALU	=> CU_cntrlALU,
		ALU_memDataRd			=> CU_memDataRdALU,
		-- out
		ALU_stOprtn				=> CU_flgALUWait,
		ALU_memAddr				=> CU_memAddrALU,
		ALU_memDataWr			=> CU_memDataWrALU,
		ALU_memEnblWr			=> CU_memEnblWrALU
		);
		
	-- Register entity
	Register_inst : entity work.Register_E(Register_A) 
		port map(
		-- in
		Register_rst					=> CU_rst,
		Register_clk					=> CU_clk,
		Register_cntrlCU_enblReg	=> CU_cntrlReg,
		Register_memDataRd			=>	CU_memDataRdReg,
		-- out
		Register_stOprtn				=> CU_flgRegWait,
		Register_memAddr				=> CU_memAddrReg,
		Register_memDataWr			=> CU_memDataWrReg,
		Register_memEnblWr			=>	CU_memEnblWrReg
		);
	
	-- Output entity	
	Output_inst : entity work.Output_E(Output_A) 
	port map(
		-- in
		Output_rst					=> CU_rst,
		Output_clk					=> CU_clk,
		Output_cntrlCU_enblOut	=> CU_cntrlOut,
		Output_memDataRd			=> CU_memDataRdOut,
		-- out
		Output_stOprtn				=> CU_flgOutWait,
		Output_ledDataInShw		=> CU_ledDataInShw,
		Output_ledOpcodInShw		=> CU_ledOpcodInShw,
		Output_7segOut1Shw		=> CU_7segOut1Shw,
		Output_7segOut10Shw		=> CU_7segOut10Shw,
		Output_7segOut100Shw		=> CU_7segOut100Shw,
		Output_memAddr				=> CU_memAddrOut,
		Output_memDataWr			=> CU_memDataWrOut,
		Output_memEnblWr			=> CU_memEnblWrOut
		);

	
	------------------------------------------------------------------------------------------
	
	---------										P R O C E S S										---------
	------------------------------------------------------------------------------------------
	
	
	-------------------------------------------------------------------
	-- State machine which controls next states and control signals
	-------------------------------------------------------------------
	CU_StateFlow:process(CU_crntState,CU_btnCnfrm)
	begin
		CU_nxtState <= CU_crntState; -- by default, next state is current state					
	
		case CU_crntState is
		
			when CU_IDLE_STATE =>
			
				if(CU_btnCnfrm = BTN_PRESSED) then
				
					CU_nxtState <= CU_READ_OPCODE_STATE;	-- next state
					
					-- Reset Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
				end if ;
				
				
				
			when CU_READ_OPCODE_STATE =>
		
				if(CU_btnCnfrm = BTN_PRESSED) then
					
					CU_nxtState <= CU_FETCH_STATE;	-- next state
	
					-- Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlRdIn <= CU_ENABLE; 	-- Trigger Read Operation
					CU_cntrlMem <= CU_ENABLE;		-- Allow Memory Access
				end if ;
				
				
				
			when CU_FETCH_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
					--todo create a function check to see if 1 or 2 data is needed. Eithger in input module
					
					CU_nxtState <= CU_READ_DATA1_STATE;		-- next state
					
					-- Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlReg <= CU_ENABLE; 		-- Trigger Register Update
					CU_cntrlMem <= CU_ENABLE;		-- Allow Memory Access
					
				end if;
				
				
				
			when CU_READ_DATA1_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
				
					CU_nxtState <= CU_READ_DATA2_STATE;		-- next state	
	
					-- Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlRdIn <= CU_ENABLE; 	-- Trigger Read Operation
					CU_cntrlMem <= CU_ENABLE;		-- Allow Memory Access
				end if;
				
				
				
			when CU_READ_DATA2_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
				
					CU_nxtState <= CU_EXECUTE_STATE;		-- next state	
	
					-- Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlRdIn <= CU_ENABLE; 	-- Trigger Read Operation
					CU_cntrlMem <= CU_ENABLE;		-- Allow Memory Access
				end if;
				
				
				
			when CU_EXECUTE_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
				
					CU_nxtState <= CU_OUTPUT_STATE;		-- next state	
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlALU <= CU_ENABLE; -- Trigger ALU Operation
					CU_cntrlMem <= CU_ENABLE;		-- Allow Memory Access
					
				end if;
				
				
				
			when CU_OUTPUT_STATE =>
				if(CU_btnCnfrm = BTN_PRESSED) then
				
					CU_nxtState <= CU_IDLE_STATE;		-- next state	
					
					-- Trigger Control Signals
					CU_rstCntrlSig(CU_cntrlRdIn, CU_cntrlReg, CU_cntrlMem, CU_cntrlALU, CU_cntrlOut);
					CU_cntrlOut <= CU_ENABLE; -- Trigger Output Operation
					CU_cntrlMem <= CU_ENABLE;		-- Allow Memory Access
				end if;
				
		end case;
		
	end process CU_StateFlow;
	
	
	----------------------------------------------------------------------------------
	-- Sync process to update current cycle based on previous calculated next cycle
	----------------------------------------------------------------------------------
	CU_StateSync:process(CU_rst, CU_clk)
	begin
		if(CU_rst = RESET_PRESSED) then
			CU_crntState <= CU_IDLE_STATE;
										
			
		elsif(falling_edge(CU_clk)) then
		
			-- Only update next state when no other modules are using the resources
			if(
				CU_flgInWait		= CU_NOWAIT and
				CU_flgRegWait		= CU_NOWAIT and
				CU_flgMemWait		= CU_NOWAIT and
				CU_flgALUWait		= CU_NOWAIT and
				CU_flgOutWait		= CU_NOWAIT
				) then
				CU_crntState <= CU_nxtState;
				
			end if;			
		end if;			
	
	end process CU_StateSync;
	
	
		
	-------------------------------------------------------------------
	-- Redirects the correct request to Memory
	-------------------------------------------------------------------
	CU_MemFlow:process(	CU_memAddrIn,	CU_memDataWrIn,	CU_memEnblWrIn,
								CU_memAddrOut, CU_memDataWrOut,	CU_memEnblWrOut,
								CU_memAddrALU,	CU_memDataWrALU,	CU_memEnblWrALU,
								CU_memAddrReg,	CU_memDataWrReg,	CU_memEnblWrReg,
								CU_memDataRd)
								-- Any change in address/enable/DataWr from modules or Read data from Memory Module
	begin	
		
		case CU_crntState is
		
			when CU_IDLE_STATE =>
				-- Do nothing
			when CU_READ_OPCODE_STATE|CU_READ_DATA1_STATE|CU_READ_DATA2_STATE=>
				-- Input Module
				CU_memAddr 			<= CU_memAddrIn;
				CU_memDataWr 		<= CU_memDataWrIn;
				CU_memEnblWr 		<= CU_memEnblWrIn;
				CU_memDataRdIn		<= CU_memDataRd;	
				
			when CU_FETCH_STATE =>	
				CU_memAddr			<= CU_memAddrReg;
				CU_memDataWr 		<= CU_memDataWrReg;
				CU_memEnblWr 		<= CU_memEnblWrReg;
				CU_memDataRdReg 	<= CU_memDataRd;					
	
			when CU_EXECUTE_STATE =>
				-- ALU Module
				CU_memAddr 			<= CU_memAddrALU;
				CU_memDataWr 		<= CU_memDataWrALU;
				CU_memEnblWr 		<= CU_memEnblWrOut;
				CU_memDataRdALU 	<= CU_memDataRd;	
	
			when CU_OUTPUT_STATE =>
				-- Output Module
				CU_memAddr 			<= CU_memAddrOut;
				CU_memDataWr 		<= CU_memDataWrOut;
				CU_memEnblWr 		<= CU_memEnblWrOut;
				CU_memDataRdOut	<= CU_memDataRd;	
				
		end case;
		
	end process CU_MemFlow;

	
end architecture ControlUnit_A;