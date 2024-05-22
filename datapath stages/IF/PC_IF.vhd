----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:58:05 03/06/2019 
-- Design Name: 
-- Module Name:    PC_IF - Behavioral 
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

entity PC_IF is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_Sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
			  clk : in  STD_LOGIC;
			  PC_out : out STD_LOGIC_VECTOR (31 downto 0));
end PC_IF;

architecture Structural of PC_IF is

signal mux_tmp_out, add_tmp, immed_tmp, pc_out_tmp : std_logic_vector (31 downto 0);

component PC is
	port( clk, reset, PC_LdEn : in STD_LOGIC;
			PC_addr : in STD_LOGIC_VECTOR(31 downto 0);
			PC_out : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component plus4_adder is
    Port ( Add_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Add_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Immed_adder is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_incr : in  STD_LOGIC_VECTOR (31 downto 0);
           D_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component MUX_2to1 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Sel : in  STD_LOGIC;
           D_out : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

	pc_reg: PC port map( clk => clk,
								reset => Reset,
								PC_LdEn => PC_LdEn,
								PC_addr => mux_tmp_out,
								PC_out => PC_out);
						  
	mux: MUX_2to1 port map( A => add_tmp,
									B => immed_tmp,
									Sel => PC_Sel,
									D_out => mux_tmp_out);
									
	incr: plus4_adder port map( Add_in => pc_out_tmp,
										 Add_out => add_tmp);
										 
	immed: Immed_adder port map( PC_Immed => PC_Immed,
										  PC_incr => add_tmp,
										  D_out => immed_tmp);
										  
end Structural;

