----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:25:47 03/04/2019 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DECSTAGE is
    Port ( Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0));
end DECSTAGE;

architecture Structural of DECSTAGE is

signal mux_tmp, instr_tmp : STD_LOGIC_VECTOR (4 downto 0);
signal write_tmp : STD_LOGIC_VECTOR (31 downto 0);

component RegisterFile is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end component;

component MUX_2to1 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           D_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX_5bit is
    Port ( A : in  STD_LOGIC_VECTOR (4 downto 0);
           B : in  STD_LOGIC_VECTOR (4 downto 0);
           Sel : in  STD_LOGIC;
           D_out : out  STD_LOGIC_VECTOR (4 downto 0));
end component;

component SignExtender is
    Port ( Instr : in  STD_LOGIC_VECTOR (15 downto 0);
           Immed : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

	rf: RegisterFile port map( Ard1 => Instr(25 downto 21),
										Ard2 => mux_tmp,
										Awr => instr_tmp,
										Dout1 => RF_A,
										Dout2 => RF_B,
										Din => write_tmp,
										WrEn => RF_WrEn,
										CLK => clk);

	mux5bit: MUX_5bit port map( A => Instr(15 downto 11),
										 B => instr_tmp,
										 Sel => RF_B_sel,
										 D_out => mux_tmp);
										 
	write_mux: MUX_2to1 port map( A => MEM_out,
											B => ALU_out,
											Sel => RF_WrData_sel,
											D_out => write_tmp);
											
	se: SignExtender port map( Instr => Instr(15 downto 0),
										Immed => Immed);

	instr_tmp <= Instr(20 downto 16);
	
end Structural;

