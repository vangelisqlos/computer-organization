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
signal add, li, lw, sw : std_logic;

begin

process (Reset, Opcode, func, add, li, lw, sw)
begin
	if Reset = '1' then
		InstrReg_WE <= '0';
		
		PC_sel <= "00";
		--PC_LdEn <= '0';
		RF_WrEn <= '0';
		RF_WrData_sel <= "00";
		RF_B_sel <= '0';
		ImmExt_s <= '0';
		ALU_Bin_sel <= '0';
		ALU_func <= "0000";
		Mem_WrEn <= '0';
		
	else
		InstrReg_WE <= '1';
		
		if not (std_match(opcode, "000000")) then
--		if (add or li or lw or sw) = '1' then
			PC_sel <= "00";
			PC_LdEn <= '1';
			RF_WrEn <= not sw;
			RF_WrData_sel <= "0"&lw;
			RF_B_sel <= not add;
			ImmExt_s <= '1';
			ALU_Bin_sel <= not add;
			if add = '1' then
				ALU_func <= func(3 downto 0);
			else 
				ALU_func <= "0000";
			end if;
			Mem_WrEn <= sw;
		else
			PC_sel <= "00";
			--PC_LdEn <= '0';
			RF_WrEn <= '0';
			RF_WrData_sel <= "00";
			RF_B_sel <= '0';
			ImmExt_s <= '0';
			ALU_Bin_sel <= '0';
			ALU_func <= "0000";
			Mem_WrEn <= '0';
		end if;
		
		if (std_match(opcode, "100000")) then	-- add
			add <= '1';
			li <= '0';
			lw <= '0';
			sw <= '0';
		elsif (std_match(opcode, "110000")) then	-- li (addi)
			add <= '0';
			li <= '1';
			lw <= '0';
			sw <= '0';
		elsif (std_match(opcode, "001111")) then	-- lw
			add <= '0';
			li <= '0';
			lw <= '1';
			sw <= '0';
		elsif (std_match(opcode, "011111")) then	-- sw
			add <= '0';
			li <= '0';
			lw <= '0';
			sw <= '1';
		else 
			add <= '0';
			li <= '0';
			lw <= '0';
			sw <= '0';
		end if;
	end if;
end process;

end Behavioral;

