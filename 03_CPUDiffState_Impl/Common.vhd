-- Header File Inclusion
library ieee;
use ieee.std_logic_1164.all;

package Common_P is

	---------------------
	-- Type Definitions
	---------------------
	
	-- Common
	subtype typ_rst is std_logic;		-- reset
	subtype typ_clk is std_logic;		-- clock
	
	
	-- Module : CPU
	subtype typ_cpu_cntrlsig is std_logic;
	
	
	-- Module : Memory
	subtype typ_mem_reg is natural;
	
	-- Module : Input
	subtype typ_in_btn is std_logic;
	
	
	
	
	
	------------------
	-- Enumerations 
	------------------
	type enum_CPU_state is (	CPU_IDLE,
									CPU_READ_OPCODE,
									CPU_READ_DATA1,
									CPU_READ_DATA2,
									CPU_EXECUTE,
									CPU_OUTPUT
									);
									
									
	type enum_mem_state is (	MEM_IDLE,
										MEM_START,
--										MEM_READ,
--										MEM_WRITE,
										MEM_END
									);
									
									
	
	------------------
	-- Constants 
	------------------		

	-- Common
	constant ENABLE 		: std_logic := '1';
	constant DISABLE 		: std_logic := '1';
	
	-- Module : CPU
	constant CPU_NOWAIT 		: typ_cpu_cntrlsig := '0';
	constant CPU_WAIT 		: typ_cpu_cntrlsig := '1';
	
	constant CPU_ENABLE 		: typ_cpu_cntrlsig := '1';
	constant CPU_DISABLE 	: typ_cpu_cntrlsig := '0';
	
	
	-- Module : Input
	constant BTN_PRESSED 	: std_logic := '1';
	
	
	-- Module : Memory
	constant MEM_OPR_READ 		: std_logic := '0';
	constant MEM_OPR_WRITE 		: std_logic := '1';
	
	
	
	
end package Common_P;