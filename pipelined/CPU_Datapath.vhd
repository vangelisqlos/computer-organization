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
			Mem_WrEn : in STD_LOGIC;
			Mem_WrEn_pip : out STD_LOGIC;
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
signal ALU_out_ALUreg, ALU_out_MEMreg, RF_A_DECreg, RF_B_DECreg, RF_B_ALUreg, Immed_DECreg, Instr_MEMreg, MEM_DataOut_MEMreg : STD_LOGIC_VECTOR (31 downto 0);
signal DECregCS_MUX_in, DECregCS_in, DECtoALU_CS : STD_LOGIC_VECTOR (8 downto 0);
signal ALUtoMEM_CS : STD_LOGIC_VECTOR (3 downto 0);
signal MEMtoWB_CS : STD_LOGIC_VECTOR (2 downto 0);
signal RF_WrEn_pipreg, MEM_WrEn_pipreg, ALU_Bin_SEL_pipreg : STD_LOGIC;
signal ALU_func_pipreg : STD_LOGIC_VECTOR (3 downto 0);
signal RF_WrData_sel_pipreg, ForwardA, ForwardB : STD_LOGIC_VECTOR (1 downto 0);
signal rs, rt, rd, rs_DECreg, rt_DECreg, rd_DECreg, rd_ALUreg, rd_MEMreg : STD_LOGIC_VECTOR (4 downto 0);
signal RF_write_data, RF_A_forwarded, RF_B_forwarded : STD_LOGIC_VECTOR (31 downto 0);
signal PC_enable, InstReg_En, CS_sel, PC_En : STD_LOGIC;

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
			  WBreg : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WrData_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           RF_B_sel : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  ImmSignExt : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
			  RS : out STD_LOGIC_VECTOR (4 downto 0);
			  RT : out STD_LOGIC_VECTOR (4 downto 0);
			  RD : out STD_LOGIC_VECTOR (4 downto 0);
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
           Din : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Dout : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component MUX is
	 Generic (N : integer);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in  STD_LOGIC;
           MUX_Out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component MUX2 is
	 Generic (N : integer);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  C : in  STD_LOGIC_VECTOR (N-1 downto 0);
           D : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           MUX_Out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

component ForwardingUnit is
    Port ( ALUtoMEM_RF_WrEn : in STD_LOGIC;
           MEMtoWB_RF_WrEn : in STD_LOGIC;
			  ALUtoMEM_rd : in  STD_LOGIC_VECTOR (4 downto 0);
			  MEMtoWB_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rs : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rt : in  STD_LOGIC_VECTOR (4 downto 0);
           ForwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           ForwardB : out  STD_LOGIC_VECTOR (1 downto 0));
end component;

component HazardUnit is
    Port ( rt_IF : in  STD_LOGIC_VECTOR (4 downto 0);
           rs_IF : in  STD_LOGIC_VECTOR (4 downto 0);
           rt_DEC : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_MEM_WrEn : in  STD_LOGIC;
           PC_enable : out  STD_LOGIC;
           InstReg_En : out  STD_LOGIC;
           CS_sel : out  STD_LOGIC);
end component;

begin

RF_SEL_MUX : MUX	Generic Map (N => 32)
						Port Map ( A => ALU_out_MEMreg,
									  B => MEM_DataOut_MEMreg,
									  Sel => RF_WrData_sel_pipreg(0),
									  MUX_Out => RF_write_data);

FWA_MUX : MUX2 	Generic Map (N => 32)
						Port Map ( A => RF_A_DECreg,
									  B => RF_write_data,
									  C => ALU_out_ALUreg,
									  D => X"00000000",
									  Sel => ForwardA,
									  MUX_Out => RF_A_forwarded);

FWB_MUX : MUX2 	Generic Map (N => 32)
						Port Map ( A => RF_B_DECreg,
									  B => RF_write_data,
									  C => ALU_out_ALUreg,
									  D => X"00000000",
									  Sel => ForwardB,
									  MUX_Out => RF_B_forwarded);

ALU : ALUSTAGE PORT MAP (RF_A => RF_A_forwarded,
								 RF_B => RF_B_forwarded,
								 Immed => Immed_DECreg,
								 ALU_Bin_sel => ALU_Bin_sel_pipreg,
								 ALU_func => ALU_func_pipreg,
								 ALU_Zero => ALU_Zero,
								 ALU_out => ALUStage_out);

ALUreg1 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => ALUStage_out,
											 Dout => ALU_out_ALUreg);

ALU_out <= ALU_out_ALUreg;

ALUreg2 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => RF_B_forwarded,
											 Dout => RF_B_ALUreg);

ALUreg3 : Register_Nbits Generic Map (N => 5)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => rd_DECreg,
											 Dout => rd_ALUreg);

ALUregCS : Register_Nbits Generic Map (N => 4)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => DECtoALU_CS(8 downto 5),
											 Dout => ALUtoMEM_CS);

MEM_WrEn_pip <= ALUtoMEM_CS(0);

IF_S : IFSTAGE PORT MAP ( PC_Immed => Immed_DECreg,
								  PC_sel => PC_sel,
								  PC_LdEn => PC_En,
								  Reset => Reset,
								  CLK => CLK,
								  PC => PC,
								  EPC => EPC,
								  Handler_addr => Handler_addr);

DEC : DECSTAGE PORT MAP (Instr => Instr_MEMreg,
								 RF_WrEn => RF_WrEn_pipreg,
								 ALU_out => ALU_out_MEMreg,
								 MEM_out => MEM_DataOut_MEMreg,
								 WBreg => rd_MEMreg,
								 RF_WrData_sel => RF_WrData_sel_pipreg,
								 RF_B_sel => RF_B_sel,
								 Reset => Reset,
								 CLK => CLK,
								 ImmSignExt => ImmExt_s,
								 Immed => Immed,
								 RF_A => RF_A,
								 RF_B => RF_B,
								 RS => rs,
								 RT => rt,
								 RD => rd,
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

DECreg4 : Register_Nbits Generic Map (N => 5)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => rs,
											 Dout => rs_DECreg);

DECreg5 : Register_Nbits Generic Map (N => 5)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => rt,
											 Dout => rt_DECreg);

DECreg6 : Register_Nbits Generic Map (N => 5)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => rd,
											 Dout => rd_DECreg);

DECregCS_MUX_in <= RF_WrEn & RF_WrData_sel & MEM_WrEn & ALU_Bin_Sel & ALU_func;
DECregCS_MUX : MUX 	Generic Map (N => 9)
							Port Map ( A => DECregCS_MUX_in,
										  B => "000000000",
										  Sel => CS_sel,
										  MUX_Out => DECregCS_in);

DECregCS : Register_Nbits Generic Map (N => 9)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => DECregCS_in,
											 Dout => DECtoALU_CS);

ALU_Bin_SEL_pipreg <= DECtoALU_CS(4);
ALU_func_pipreg <= DECtoALU_CS(3 downto 0);

--MEM : RAM Port Map (	clk => CLK,
--							inst_addr => PC_IFreg(12 downto 2),
--							inst_dout => Instr,
--							data_we => Mem_WrEn,
--							data_addr => MEM_Addr(10 downto 0),
--							data_din => RF_B_DECreg,
--							data_dout => MEM_DataOut);

Instr_addr <= PC(12 downto 2);
Mem_Data_addr <= MEM_Addr(10 downto 0);
Mem_DataIn <= RF_B_ALUreg;

MEMreg1 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => InstReg_En,
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

MEMreg3 : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => ALU_out_ALUreg,
											 Dout => ALU_out_MEMreg);

MEMreg4 : Register_Nbits Generic Map (N => 5)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => rd_ALUreg,
											 Dout => rd_MEMreg);

MEMregCS : Register_Nbits Generic Map (N => 3)
								Port Map (CLK => CLK,
											 WE => '1',
											 Reset => Reset,
											 Din => ALUtoMEM_CS(3 downto 1),
											 Dout => MEMtoWB_CS);

RF_WrEn_pipreg <= MEMtoWB_CS(2);
RF_WrData_sel_pipreg <= MEMtoWB_CS(1 downto 0);

MEM_Addr <= std_logic_vector(unsigned(ALU_out_ALUreg) + 1024);


FU : ForwardingUnit Port Map(ALUtoMEM_RF_WrEn => ALUtoMEM_CS(3),
									  MEMtoWB_RF_WrEn => RF_WrEn_pipreg,
									  ALUtoMEM_rd => rd_ALUreg,
									  MEMtoWB_rd => rd_MEMreg,
									  DEC_rs => rs_DECreg,
									  DEC_rt => rt_DECreg,
									  ForwardA => ForwardA,
									  ForwardB => ForwardB);

HU : HazardUnit Port Map (rt_IF => rt,
								  rs_IF => rs,
								  rt_DEC => rt_DECreg,
								  DEC_MEM_WrEn => DECtoALU_CS(6),
								  PC_enable => pc_en,
								  InstReg_En => InstReg_En,
								  CS_sel => CS_sel);

end Behavioral;
