----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:25:57 03/15/2019 
-- Design Name: 
-- Module Name:    CPU_Datapath - Behavioral 
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

entity CPU_Datapath is
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
end CPU_Datapath;

architecture Behavioral of CPU_Datapath is
signal ALUStage_out, MEM_Addr, RF_A, RF_B, Immed, PC : STD_LOGIC_VECTOR (31 downto 0);
signal ALU_out_ALUreg, RF_A_DECreg, RF_B_DECreg, Immed_DECreg, Instr_MEMreg, MEM_DataOut_MEMreg : STD_LOGIC_VECTOR (31 downto 0);

-- Exception signal
signal EPC : STD_LOGIC_VECTOR (31 downto 0);

component ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
			  ALU_Zero : out STD_LOGIC;
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           RF_B_sel : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  ImmSignExt : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  ExceptionWE : in STD_LOGIC;
			  PC : in STD_LOGIC_VECTOR (31 downto 0);
			  EPC : out STD_LOGIC_VECTOR (31 downto 0);
			  Cause_Sel : in STD_LOGIC);
end component;

component IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0);
			  EPC : in  STD_LOGIC_VECTOR (31 downto 0);
			  Handler_addr : in STD_LOGIC_VECTOR (31 downto 0));
end component;

--component RAM is
--	port (
--		clk : in std_logic;
--		inst_addr : in std_logic_vector(10 downto 0);
--		inst_dout : out std_logic_vector(31 downto 0);
--		data_we : in std_logic;
--		data_addr : in std_logic_vector(10 downto 0);
--		data_din : in std_logic_vector(31 downto 0);
--		data_dout : out std_logic_vector(31 downto 0));
--end component;

component Register_Nbits is
	 Generic (N : integer := 32);
    Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

begin
ALU : ALUSTAGE PORT MAP (RF_A => RF_A_DECreg,
								 RF_B => RF_B_DECreg,
								 Immed => Immed_DECreg,
								 ALU_Bin_sel => ALU_Bin_sel,
								 ALU_func => ALU_func,
								 ALU_Zero => ALU_Zero,
								 ALU_out => ALUStage_out);

ALUreg : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => ALUStage_out,
											 Dout => ALU_out_ALUreg);

ALU_out <= ALU_out_ALUreg;

IF_S : IFSTAGE PORT MAP ( PC_Immed => Immed_DECreg,
								  PC_sel => PC_sel,
								  PC_LdEn => PC_LdEn,
								  Reset => Reset,
								  CLK => CLK,
								  PC => PC,
								  EPC => EPC,
								  Handler_addr => Handler_addr);

DEC : DECSTAGE PORT MAP (Instr => Instr_MEMreg,
								 RF_WrEn => RF_WrEn,
								 ALU_out => ALU_out_ALUreg,
								 MEM_out => MEM_DataOut,
								 RF_WrData_sel => RF_WrData_sel,
								 RF_B_sel => RF_B_sel,
								 Reset => Reset,
								 CLK => CLK,
								 ImmSignExt => ImmExt_s,
								 Immed => Immed,
								 RF_A => RF_A,
								 RF_B => RF_B,
								 ExceptionWE => ExceptionWE,
							    PC => PC,
							    EPC => EPC,
							    Cause_Sel => Cause_sel);

DECreg1 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => RF_A,
											 Dout => RF_A_DECreg);

DECreg2 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => RF_B,
											 Dout => RF_B_DECreg);

DECreg3 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => Immed,
											 Dout => Immed_DECreg);

--MEM : RAM Port Map (	clk => CLK,
--							inst_addr => PC_IFreg(12 downto 2),
--							inst_dout => Instr,
--							data_we => Mem_WrEn,
--							data_addr => MEM_Addr(10 downto 0),
--							data_din => RF_B_DECreg,
--							data_dout => MEM_DataOut);

Instr_addr <= PC(12 downto 2);
Mem_Data_addr <= MEM_Addr(10 downto 0);
Mem_DataIn <= RF_B_DECreg;

MEMreg1 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => InstrReg_WE,
											 Reset => Reset,
											 Din => Instr_in,
											 Dout => Instr_MEMreg);
InstrReg_out <= Instr_MEMreg;

MEMreg2 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => MEM_DataOut,
											 Dout => MEM_DataOut_MEMreg);

MEM_Addr <= std_logic_vector(unsigned(ALU_out_ALUreg) + 1024);

end Behavioral;
