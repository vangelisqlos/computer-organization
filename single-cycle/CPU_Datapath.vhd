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
			PC_sel : in  STD_LOGIC; 
			PC_LdEn : in  STD_LOGIC; 
			RF_WrEn : in  STD_LOGIC;
			RF_WrData_sel : in  STD_LOGIC; --Mem out 
			RF_B_sel : in  STD_LOGIC; --rt
			ImmExt_s : in  STD_LOGIC; -- dont care
			ALU_Bin_sel : in  STD_LOGIC;  --RF_B
			ALU_func : in  STD_LOGIC_VECTOR (3 downto 0); --nand		
			Mem_WrEn : in  STD_LOGIC);
end CPU_Datapath;

architecture Behavioral of CPU_Datapath is
signal ALU_out, MEM_Addr, RF_A, RF_B, Immed ,PC, MEM_DataOut, Instr : STD_LOGIC_VECTOR (31 downto 0);

component ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
			  ImmSignExt : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component RAM is
	port (
		clk : in std_logic;
		inst_addr : in std_logic_vector(10 downto 0);
		inst_dout : out std_logic_vector(31 downto 0);
		data_we : in std_logic;
		data_addr : in std_logic_vector(10 downto 0);
		data_din : in std_logic_vector(31 downto 0);
		data_dout : out std_logic_vector(31 downto 0)
	);
end component;

begin
ALU : ALUSTAGE PORT MAP (RF_A => RF_A,
								 RF_B => RF_B,
								 Immed => Immed,
								 ALU_Bin_sel => ALU_Bin_sel,
								 ALU_func => ALU_func,
								 ALU_out => ALU_out);

IF_S : IFSTAGE PORT MAP ( PC_Immed => Immed,
								  PC_sel => PC_sel,
								  PC_LdEn => PC_LdEn,
								  Reset => Reset,
								  CLK => CLK,
								  PC => PC);

DEC : DECSTAGE PORT MAP (Instr => Instr,
								 RF_WrEn => RF_WrEn,
								 ALU_out => ALU_out,
								 MEM_out => MEM_DataOut,
								 RF_WrData_sel => RF_WrData_sel,
								 RF_B_sel => RF_B_sel,
								 Reset => Reset,
								 CLK => CLK,
								 ImmSignExt => ImmExt_s,
								 Immed => Immed,
								 RF_A => RF_A,
								 RF_B => RF_B);
							  
MEM : RAM Port Map (	clk => CLK,
							inst_addr => PC(12 downto 2),
							inst_dout => Instr,
							data_we => Mem_WrEn,
							data_addr => MEM_Addr(10 downto 0),
							data_din => RF_B,
							data_dout => MEM_DataOut);

MEM_Addr <= std_logic_vector(unsigned(ALU_out) + 1024);

end Behavioral;
