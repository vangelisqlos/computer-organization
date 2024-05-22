----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:49:27 03/04/2019 
-- Design Name: 
-- Module Name:    IFSTAGE - Behavioral 
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

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_Sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  Instr : out STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Structural of IFSTAGE is

signal pc_out_tmp : STD_LOGIC_VECTOR (31 downto 0);

component PC_IF is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_Sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  PC_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component RAM is
	port (
	 clk : in std_logic;
	 inst_addr : in std_logic_vector(10 downto 0);
	 inst_dout : out std_logic_vector(31 downto 0);
	 data_we : in std_logic;
	 data_addr : in std_logic_vector(10 downto 0);
	 data_din : in std_logic_vector(31 downto 0);
	 data_dout : out std_logic_vector(31 downto 0));
end component;

begin

	pc_module: PC_IF port map( PC_Immed => PC_Immed,
								  PC_Sel => PC_Sel,
								  PC_LdEn => PC_LdEn,
								  Reset => Reset,
								  clk => clk,
								  PC_out => pc_out_tmp);
								  
	if_mem: RAM port map( clk => clk,
								 inst_addr => pc_out_tmp(12 downto 2),
								 inst_dout => Instr,
								 data_we => '0',
								 data_addr => (others => '0'),
								 data_din => (others => '0'));
								 
end Structural;

