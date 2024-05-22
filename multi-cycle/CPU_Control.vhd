----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:39:22 04/01/2019 
-- Design Name: 
-- Module Name:    CPU_Control - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CPU_Control is
    Port ( CLK : in  STD_LOGIC;
			  Reset : in STD_LOGIC;
			  opcode : in  STD_LOGIC_VECTOR (5 downto 0);
           func : in  STD_LOGIC_VECTOR (5 downto 0);
           zero : in  STD_LOGIC;
			  PC_sel : out  STD_LOGIC_VECTOR (1 downto 0);
			  PC_LdEn : out  STD_LOGIC; 
			  RF_WrEn : out  STD_LOGIC;
			  RF_WrData_sel : out  STD_LOGIC_VECTOR (1 downto 0);
			  RF_B_sel : out  STD_LOGIC;
			  ImmExt_s : out  STD_LOGIC;
			  ALU_Bin_sel : out  STD_LOGIC;
			  ALU_func : out  STD_LOGIC_VECTOR (3 downto 0);
			  Mem_WrEn : out  STD_LOGIC;
			  InstrReg_WE : out  STD_LOGIC;
			  ExceptionWE : out STD_LOGIC;
			  Cause_sel : out STD_LOGIC;
			  Handler_addr : out STD_LOGIC_VECTOR (31 downto 0);
			  ALU_out : in STD_LOGIC_VECTOR (31 downto 0));
end CPU_Control;

architecture Behavioral of CPU_Control is
type states is (Fetch, Decode, MemAddressCompute, MemRead_Write, MemWB, Exec, R_I_TypeWB, BranchCondition, Branch, Exception);
signal State, nextState : states;
signal returnedFromExceptionState : std_logic := '0';

function BOOL_TO_STDL(X : boolean; S : std_logic) return std_logic is
begin
  if X then
    return S;
  else
    return (not S);
  end if;
end BOOL_TO_STDL;

function BOOL_TO_STDL(X : boolean; Strue, Sfalse : std_logic_vector) return std_logic_vector is
begin
  if X then
    return Strue;
  else
    return Sfalse;
  end if;
end BOOL_TO_STDL;

begin

-- Go to next State
process (CLK)
begin
	if rising_edge(CLK) then
		if Reset = '1' then
			State <= Fetch after 5 ns;
			
--			PC_sel <= '0';
--			--PC_LdEn <= '0';
--			RF_WrEn <= '0';
--			RF_WrData_sel <= '0';
--			RF_B_sel <= '0';
--			ImmExt_s <= '0';
--			ALU_Bin_sel <= '0';
--			ALU_func <= "0000";
--			Mem_WrEn <= '0';
		else
			State <= nextState after 5 ns;
		end if;
	end if;
end process;


-- Calculate next State
process (State, opcode, zero, ALU_out)
begin
	case State is
		when Fetch =>
				InstrReg_WE <= '1';
				ExceptionWE <= '0';
				PC_sel <= "00";
				PC_LdEn <= '1';--not returnedFromExceptionState;
				RF_WrEn <= '0';
				Mem_WrEn <= '0';
				
				nextState <= Decode;
		
		when Decode =>
				InstrReg_WE <= '0';
				returnedFromExceptionState <= '0';
				PC_LdEn <= '0';
				RF_WrEn <= BOOL_TO_STDL(std_match(opcode, "1110--"), '1');	-- write when li, lui
				RF_WrData_sel <= "00";
				RF_B_sel <= BOOL_TO_STDL(std_match(opcode, "10----"), '0');	-- get rt in R-type instructions
				ImmExt_s <= BOOL_TO_STDL(std_match(opcode, "11001-"), '0');	-- zero fill when nandi, ori
				
				if not (std_match(opcode, "11100-") or std_match(opcode, "11001-") or std_match(opcode, "-11111") or std_match(opcode, "00000-") or std_match(opcode, "001111") or std_match(opcode, "1-0000") or std_match(opcode, "000-11") or std_match(opcode, "11111-")) then
					nextState <= Exception;
				elsif std_match(opcode, "0---1-") then		-- lb, lw, sb, sw
					nextState <= MemAddressCompute;
				elsif std_match(opcode, "1-0---") then	-- R-Type & I-Type (except li, lui)
					nextState <= Exec;
				elsif std_match(opcode, "1110--") then	-- li, lui
					nextState <= Fetch;
				elsif std_match(opcode, "11111-") then	-- b, jump_EPC		(jump_ECP opcode is 111111)
					nextState <= Branch;
				elsif std_match(opcode, "00000-") then	-- beq, bneq
					nextState <= BranchCondition;
				end if;
		
		-- Memory FSM
		when MemAddressCompute =>
				ALU_Bin_sel <= '1';
				ALU_func <= "0000";
				
				nextState <= MemRead_Write;
		
		when MemRead_Write =>
				Mem_WrEn <= BOOL_TO_STDL(std_match(opcode, "-001--") or std_match(opcode, "-111--"), '1');	-- write mem when sb, sw
				
				if std_match(opcode, "-000--") or std_match(opcode, "-011--") then		-- lb, lw
					if to_integer(unsigned(ALU_out)) > 2048 then
						nextState <= Exception;
					else
						nextState <= MemWB;
					end if;
				elsif std_match(opcode, "-001--") or std_match(opcode, "-111--") then		-- sb, sw
					nextState <= Fetch;
				end if;
		
		when MemWB =>
				RF_WrEn <= '1';
				RF_WrData_sel <= "01";
				
				nextState <= Fetch;
		
		-- R/I-Type FSM
		when Exec =>
				ALU_Bin_sel <= BOOL_TO_STDL(std_match(opcode, "10----"), '0');	-- regB when R-type, Immed when I-type
				ALU_func <= BOOL_TO_STDL(std_match(opcode, "10----"), func(3 downto 0), opcode(3 downto 0));	-- func when R-type, opcode(3..0) when I-type
				
				nextState <= R_I_TypeWB;
				
		when R_I_TypeWB =>
				RF_WrEn <= '1';
				RF_WrData_sel <= "00";
				
				nextState <= Fetch;
		
		-- Branch FSM
		when BranchCondition =>		
				PC_sel <= '0' & (opcode(0) xor Zero);
				PC_LdEn <= opcode(0) xor Zero;
				ALU_Bin_sel <= '0';
				ALU_func <= "0001";
				
				nextState <= Fetch;
		
		when Branch =>
				PC_sel <= BOOL_TO_STDL(std_match(opcode, "111110"), '1') & '1';	-- "11" when jump_EPC, "01" branch
				PC_LdEn <= '1';
				
				returnedFromExceptionState <= BOOL_TO_STDL(std_match(opcode, "111110"), '1');
				
				nextState <= Fetch;
		
		-- Exception FSM
		when Exception =>
				PC_sel <= "10";
				PC_LdEn <= '1';
				ExceptionWE <= '1';
				
				returnedFromExceptionState <= '1';
				
				if std_match(opcode, "0---1-") then
					Handler_addr <= X"00000040";
					Cause_sel <= '1';
				else
					Handler_addr <= X"00000030";
					Cause_sel <= '0';
				end if;
				
				nextState <= Fetch;
		
		when others =>
				assert false report "Illegal state in Control FSM" severity error;
	end case;
end process;

-- Calculate Control Signals
--process (State)
--begin
--	case State is
--		when Fetch =>
--				PC_sel <= '0';
--				PC_LdEn <= '1';
--				RF_WrEn <= '0';
--				--RF_WrData_sel <= ;
--				--RF_B_sel <= ;
--				--ImmExt_s <= ;
--				--ALU_Bin_sel <= ;
--				--ALU_func <= ;
--				Mem_WrEn <= '0';
--		
--		when Decode =>
--				PC_LdEn <= '0' after 1 ns;
--				RF_WrEn <= BOOL_TO_STDL(std_match(opcode, "1110--"), '1');	-- write when li, lui
--				RF_WrData_sel <= '0';
--				RF_B_sel <= BOOL_TO_STDL(std_match(opcode, "10----"), '0');	-- get rt in R-type instructions
--				ImmExt_s <= BOOL_TO_STDL(std_match(opcode, "11001-"), '0');	-- zero fill when nandi, ori
--		
--		-- Memory FSM
--		when MemAddressCompute =>
--				ALU_Bin_sel <= '1';
--				ALU_func <= "0000";
--		
--		when MemRead_Write =>
--				Mem_WrEn <= BOOL_TO_STDL(std_match(opcode, "-001--") or std_match(opcode, "-111--"), '1');	-- write mem when sb, sw
--		
--		when MemWB =>
--				RF_WrEn <= '1';
--				RF_WrData_sel <= '1';
--		
--		-- R/I-Type FSM
--		when Exec =>
--				ALU_Bin_sel <= BOOL_TO_STDL(std_match(opcode, "10----"), '0');	-- regB when R-type, Immed when I-type
--				ALU_func <= BOOL_TO_STDL(std_match(opcode, "10----"), func(3 downto 0), opcode(3 downto 0));	-- func when R-type, opcode(3..0) when I-type
--				
--		when R_I_TypeWB =>
--				RF_WrEn <= '1';
--				RF_WrData_sel <= '0';
--		
--		-- Branch FSM
--		when ComputeCondition =>
--				ALU_Bin_sel <= '0';
--				ALU_func <= "0001";
--		
--		when Branch =>
--				PC_sel <= '1';
--		
--	end case;
--end process;

end Behavioral;

