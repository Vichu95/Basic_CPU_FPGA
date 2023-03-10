------------------------------------------------------------------------------------------------
--		University             : Hochschule Anhalt
--		Group                  :     
--		Authors                : 
--		                         
--		Degree Course          : Electrical and Computer Engineering (M. Eng.)
--		Subject                : Harware Software Co Deisgn
--		File Name              : Common.vhd
--		Date                   : 
--		Description            : 
------------------------------------------------------------------------------------------------


--------------------------
-- Header File Inclusion
--------------------------
library ieee;
use ieee.std_logic_1164.all;

package Common_P is

	
	--------------------------------------------
	-- BASICS
	--------------------------------------------
	constant MORE_HALFCLK : time 	 := 60 ps; -- More than one cycle  --tobedeleted
	constant MORE_ONECLK : time 	 := 110 ps; -- More than one cycle 
	constant MORE_ONEHALFCLK : time 	 := 160 ps; -- More than one cycle 
	constant DEB_TIME_BTN 	: natural := 5000000; -- 8 -> minus 1
	constant DATABUS_WIDTH 	: natural := 7; -- 8 -> minus 1
	constant OPCODE_WIDTH 	: natural := 2; -- 3 -> minus 1
	constant ADDRBUS_WIDTH 	: natural := 7; -- 8 -> minus 1

	
	--------------------------------------------
	-- Type Definitions and its initial values
	--------------------------------------------
	
	-- Common
	subtype typ_rst 				is std_logic;												-- reset
	subtype typ_clk 				is std_logic;												-- clock
	subtype typ_opcod 			is std_logic_vector(OPCODE_WIDTH downto 0);		-- 3bit opcode
	
	-- Module : CU
	subtype typ_cu_cntrlsig 	is std_logic;
	
	-- Module : Memory
	subtype typ_databus 			is std_logic_vector(DATABUS_WIDTH downto 0);		-- 8bit data
	constant typ_databus_ini 	: 	std_logic_vector(DATABUS_WIDTH downto 0) := "00000000";
	subtype typ_addrbus 			is std_logic_vector(ADDRBUS_WIDTH downto 0);		-- 8bit address
	constant typ_addrbus_ini 	:	std_logic_vector(ADDRBUS_WIDTH downto 0) := "00000000";
	
	-- Module : Input
	subtype typ_in_btn 			is std_logic;												-- Button
	
	-- Module : Output
	subtype typ_out_7seg 		is std_logic_vector(6 downto 0);						--	7 Segment Display
	constant typ_out_7seg_ini 	:	std_logic_vector(6 downto 0) := "1111111";
	
	
	
	------------------
	-- Enumerations 
	------------------
	-- Control Unit States
	type enum_CU_state is (	CU_IDLE_STATE,
									CU_READ_OPCODE_STATE,
									CU_FETCH_STATE,
									CU_READ_DATA1_STATE,
									CU_READ_DATA2_STATE,
									CU_EXECUTE_STATE,
									CU_OUTPUT_STATE
									);
	

	------------------
	-- Constants 
	------------------		

	-- Common
	constant ENABLE 				: std_logic := '1';
	constant DISABLE 				: std_logic := '1';
	
	-- Module : CU
	constant CU_NOWAIT 			: typ_cu_cntrlsig := '0';
	constant CU_WAIT 				: typ_cu_cntrlsig := '1';
	
	constant CU_ENABLE 			: typ_cu_cntrlsig := '1';
	constant CU_DISABLE 			: typ_cu_cntrlsig := '0';
	
	
	-- Module : Input
	constant BTN_PRESSED 		: typ_in_btn := '1';
	constant BTN_NOTPRESSED 	: typ_in_btn := '0';
	constant RESET_PRESSED 		: typ_in_btn := '0';
	
	
	-- Module : Memory
	constant MEM_WRITE_EN 		: typ_cu_cntrlsig := '1';
	constant MEM_READ_EN 		: typ_cu_cntrlsig := '0';
	
	

	------------------
	-- Memory Map 
	------------------
	constant MEMLAY_OPCODE		: typ_addrbus	:= "00000001";
	constant MEMLAY_DATA1		: typ_addrbus	:= "00000010";
	constant MEMLAY_DATA2		: typ_addrbus	:= "00000011";
	constant MEMLAY_REG_R0		: typ_addrbus	:= "00000100";
	constant MEMLAY_REG_R1		: typ_addrbus	:= "00000101";
	constant MEMLAY_REG_A		: typ_addrbus	:= "00000110";
	constant MEMLAY_REG_B		: typ_addrbus	:= "00000111";
	constant MEMLAY_REG_PC		: typ_addrbus	:= "00001000";
	constant MEMLAY_REG_IR		: typ_addrbus	:= "00001001";
	constant MEMLAY_REG_MAR		: typ_addrbus	:= "00001010";
	constant MEMLAY_REG_MDR		: typ_addrbus	:= "00001011";
	
	

	------------------
	-- Instruction Set
	------------------
	constant OPCODE_ADD 			: typ_opcod		:= "001";
	constant OPCODE_SUB 			: typ_opcod		:= "010";
	constant OPCODE_INV 			: typ_opcod		:= "011";
	constant OPCODE_AND 			: typ_opcod		:= "100";
	constant OPCODE_OR 			: typ_opcod		:= "101";
	constant OPCODE_XOR 			: typ_opcod		:= "110";
	constant OPCODE_BITSHIFTL	: typ_opcod		:= "111";
	constant OPCODE_BITSHIFTR	: typ_opcod		:= "000";

	
	
	
end package Common_P;