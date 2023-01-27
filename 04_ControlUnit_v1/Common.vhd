-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

package Common_P is

	
	--------------------------------------------
	-- BASICS
	--------------------------------------------
	constant DATABUS_WIDTH 	: natural := 7; -- 8 -> minus 1
	constant OPCODE_WIDTH 	: natural := 2; -- 3 -> minus 1

	
	--------------------------------------------
	-- Type Definitions and its initial values
	--------------------------------------------
	
	-- Common
	subtype typ_rst is std_logic;		-- reset
	subtype typ_clk is std_logic;		-- clock
	subtype typ_8bitdata is std_logic_vector(DATABUS_WIDTH downto 0);		-- 8bit data
	subtype typ_opcod is std_logic_vector(OPCODE_WIDTH downto 0);		-- 3bit opcode
`	
	
	-- Module : CU
	subtype typ_cu_cntrlsig is std_logic;
	
	-- Module : Memory
	subtype typ_mem_reg is natural;
	
	-- Module : Input
	subtype typ_in_btn is std_logic;
	

	
	
	
	
	
	------------------
	-- Enumerations 
	------------------
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
	constant ENABLE 		: std_logic := '1';
	constant DISABLE 		: std_logic := '1';
	
	-- Module : CU
	constant CU_NOWAIT 	: typ_cu_cntrlsig := '0';
	constant CU_WAIT 		: typ_cu_cntrlsig := '1';
	
	constant CU_ENABLE 	: typ_cu_cntrlsig := '1';
	constant CU_DISABLE 	: typ_cu_cntrlsig := '0';
	
	
	-- Module : Input
	constant BTN_PRESSED 	: std_logic := '1'; --tobechecked all
	constant BTN_NOTPRESSED : std_logic := '0'; --tobechecked all
	
	

	------------------
	-- Memory Map 
	------------------
	constant MEMLAY_OPCODE		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_DATA1		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_DATA2		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_R0		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_R1		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_A		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_B		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_PC		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_IR		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_MAR		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	constant MEMLAY_REG_MDR		: std_logic_vector(DATABUS_WIDTH downto 0):= "00000000";
	
	
	

	------------------
	-- Instruction Set
	------------------
	constant OPCODE_ADD 			: std_logic_vector(OPCODE_WIDTH downto 0):= "001";
	constant OPCODE_SUB 			: std_logic_vector(OPCODE_WIDTH downto 0):= "010";
	constant OPCODE_INV 			: std_logic_vector(OPCODE_WIDTH downto 0):= "011";
	constant OPCODE_AND 			: std_logic_vector(OPCODE_WIDTH downto 0):= "100";
	constant OPCODE_OR 			: std_logic_vector(OPCODE_WIDTH downto 0):= "101";
	constant OPCODE_XOR 			: std_logic_vector(OPCODE_WIDTH downto 0):= "110";
	constant OPCODE_BITSHIFT	: std_logic_vector(OPCODE_WIDTH downto 0):= "111";

	
	
	
end package Common_P;