----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:15:01 04/02/2019 
-- Design Name: 
-- Module Name:    processor - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity processor is
	Port (CLK : in STD_LOGIC;
			Reset : in STD_LOGIC);
end processor;

architecture Behavioral of processor is
signal opcode, func : STD_LOGIC_VECTOR (5 downto 0);
signal InstrReg_out : STD_LOGIC_VECTOR (31 downto 0);

-- Control signals
signal zero, PC_LdEn, RF_WrEn, RF_B_sel, ImmExt_s, ALU_Bin_sel, Mem_WrEn, InstrReg_WE : STD_LOGIC;
signal PC_sel, RF_WrData_sel : STD_LOGIC_VECTOR (1 downto 0);
signal ALU_func : STD_LOGIC_VECTOR (3 downto 0);

-- Memory interface signals
signal Instr_addr, Mem_Data_addr : STD_LOGIC_VECTOR (10 downto 0);
signal Instr_in, Mem_DataIn, Mem_DataOut : STD_LOGIC_VECTOR (31 downto 0);

-- Exception signals
signal ExceptionWE, Cause_sel : STD_LOGIC;
signal Handler_addr, ALU_out : STD_LOGIC_VECTOR (31 downto 0);

component CPU_Control is
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
end component;

component CPU_Datapath is
	Port (CLK : in  STD_LOGIC;
			Reset : in  STD_LOGIC;
			PC_sel : in  STD_LOGIC_VECTOR (1 downto 0);
			PC_LdEn : in  STD_LOGIC; 
			RF_WrEn : in  STD_LOGIC;
			RF_WrData_sel : in  STD_LOGIC_VECTOR (1 downto 0);
			RF_B_sel : in  STD_LOGIC;
			ImmExt_s : in  STD_LOGIC;
			ALU_Bin_sel : in  STD_LOGIC;
			ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			ALU_Zero : out STD_LOGIC;
			Instr_addr : out STD_LOGIC_VECTOR (10 downto 0);
			Instr_in : in STD_LOGIC_VECTOR (31 downto 0);
			Mem_Data_addr : out std_logic_vector(10 downto 0);
			Mem_DataIn : out STD_LOGIC_VECTOR (31 downto 0);
			Mem_DataOut : in STD_LOGIC_VECTOR (31 downto 0);
			InstrReg_WE : in STD_LOGIC;
			InstrReg_out : out STD_LOGIC_VECTOR (31 downto 0);
			ExceptionWE : in STD_LOGIC;
			Cause_sel : in STD_LOGIC;
			Handler_addr : in STD_LOGIC_VECTOR (31 downto 0);
			ALU_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component RAM is
	Port (CLK : in std_logic;
			inst_addr : in std_logic_vector(10 downto 0);
			inst_dout : out std_logic_vector(31 downto 0);
			data_we : in std_logic;
			data_addr : in std_logic_vector(10 downto 0);
			data_din : in std_logic_vector(31 downto 0);
			data_dout : out std_logic_vector(31 downto 0));
end component;

begin

control : CPU_Control Port Map (CLK => CLK,
										  Reset => Reset,
										  opcode => opcode,
										  func => func,
										  zero => zero,
										  PC_sel => PC_sel,
										  PC_LdEn => PC_LdEn,
										  RF_WrEn => RF_WrEn,
										  RF_WrData_sel => RF_WrData_sel,
										  RF_B_sel => RF_B_sel,
										  ImmExt_s => ImmExt_s,
										  ALU_Bin_sel => ALU_Bin_sel,
										  ALU_func => ALU_func,
										  Mem_WrEn => Mem_WrEn,
										  InstrReg_WE => InstrReg_WE,
										  ExceptionWE => ExceptionWE,
										  Cause_sel => Cause_sel,
										  Handler_addr => Handler_addr,
										  ALU_out => ALU_out);

datapath : CPU_Datapath Port Map (  CLK => CLK,
												Reset => Reset,
												PC_sel => PC_sel,
												PC_LdEn => PC_LdEn,
												RF_WrEn => RF_WrEn,
												RF_WrData_sel => RF_WrData_sel,
												RF_B_sel => RF_B_sel,
												ImmExt_s => ImmExt_s,
												ALU_Bin_sel => ALU_Bin_sel,
												ALU_func => ALU_func,
												ALU_Zero => zero,
												Instr_addr => Instr_addr,
												Instr_in => Instr_in,
												Mem_Data_addr => Mem_Data_addr,
												Mem_DataIn => Mem_DataIn,
												Mem_DataOut => Mem_DataOut,
												InstrReg_WE => InstrReg_WE,
												InstrReg_out => InstrReg_out,
												ExceptionWE => ExceptionWE,
												Cause_sel => Cause_sel,
												Handler_addr => Handler_addr,
												ALU_out => ALU_out);

MEM : RAM Port Map (	CLK => CLK,
							inst_addr => Instr_addr,
							inst_dout => Instr_in,
							data_we => Mem_WrEn,
							data_addr => Mem_Data_addr,
							data_din => Mem_DataIn,
							data_dout => Mem_DataOut);

opcode <= InstrReg_out(31 downto 26);
func <= InstrReg_out(5 downto 0);

end Behavioral;

