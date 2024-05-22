----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:53:52 02/26/2019 
-- Design Name: 
-- Module Name:    DECSTAGE - Behavioral 
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

entity DECSTAGE is
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
end DECSTAGE;

architecture Behavioral of DECSTAGE is
signal read_reg1, read_reg2, write_reg : std_logic_vector (4 downto 0);
signal write_data, immed_tmp, RF_B_raw, rf_b_byte, mem_out_byte, MEM_out_processed : std_logic_vector (31 downto 0);
signal im : std_logic_vector (15 downto 0);
signal op : std_logic_vector (5 downto 0);
signal op_lb, op_sb : std_logic;

-- Exception signals
signal CauseMuxOut, Cause : STD_LOGIC_VECTOR (31 downto 0);

component RegisterFile is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end component;

component Register_Nbits is
	 Generic (N : integer := 32);
    Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
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


begin

read_reg1 <= Instr(25 downto 21);
write_reg <= Instr(20 downto 16);
RD <= write_reg;
RS <= read_reg1;
RT <= read_reg2;

RF : RegisterFile Port Map (read_reg1, read_reg2, WBreg, RF_A, RF_B_raw, write_data, RF_WrEn, Reset, CLK);

im <= Instr(15 downto 0);
op <= Instr(31 downto 26);

process (ImmSignExt, op, im, immed_tmp)
begin	
	-- sign extend
	--if std_match(op, "11-000") or std_match(op, "-11111") or std_match(op, "00000-") or std_match(op, "00-111")then
	if ImmSignExt = '1' then
		
		immed_tmp <= std_logic_vector(resize(signed(im), 32));
	
	-- zero filling
	--elsif std_match(op, "11001-") then
	else
		immed_tmp <= std_logic_vector(resize(unsigned(im), 32));
	end if;
	
	Immed <= immed_tmp;
end process;


RF_B_SEL_MUX : MUX 	Generic Map (N => 5)
							Port Map ( A => Instr(15 downto 11),
										  B => write_reg,
										  Sel => RF_B_sel,
										  MUX_Out => read_reg2);

RF_WR_SEL_MUX : MUX2	Generic Map (N => 32)
							Port Map ( A => ALU_out,
										  B => MEM_out_processed,
										  C => Cause,
										  D => (others => '0'),
										  Sel => RF_WrData_sel,
										  MUX_Out => write_data);


op_sb <= '1' when (std_match(op, "000111")) else '0';
rf_b_byte <= RF_B_raw and X"000000FF";

SB_MUX : MUX 	Generic Map (N => 32)
					Port Map ( A => RF_B_raw,
								  B => rf_b_byte,
								  Sel => op_sb,
								  MUX_Out => RF_B);

op_lb <= '1' when (std_match(op, "000011")) else '0';
mem_out_byte <= MEM_out and X"000000FF";

LB_MUX : MUX 	Generic Map (N => 32)
					Port Map ( A => MEM_out,
								  B => mem_out_byte,
								  Sel => op_lb,
								  MUX_Out => MEM_out_processed);

EPCreg : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => ExceptionWE,
											 Reset => Reset,
											 Din => PC,
											 Dout => EPC);

CAUSEreg : Register_Nbits Generic Map (N => 32)
								Port Map (CLK => CLK,
											 WE => ExceptionWE,
											 Reset => Reset,
											 Din => CauseMuxOut,
											 Dout => Cause);

Cause_MUX : MUX 	Generic Map (N => 32)
						Port Map ( A => X"00000111",
									  B => X"00111000",
									  Sel => Cause_sel,
									  MUX_Out => CauseMuxOut);

end Behavioral;

