----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:43:22 03/04/2019 
-- Design Name: 
-- Module Name:    MEMSTAGE - Behavioral 
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

entity MEMSTAGE is
    Port ( clk : in  STD_LOGIC;
           MEM_WrEn : in  STD_LOGIC;
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0);
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end MEMSTAGE;

architecture Structural of MEMSTAGE is

signal tmp_addr : STD_LOGIC_VECTOR(31 downto 0);

component address_adder is
    Port ( ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           Address_out : out  STD_LOGIC_VECTOR (31 downto 0));
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

	addrADD: address_adder port map( ALU_MEM_Addr => ALU_MEM_Addr,
												Address_out => tmp_addr);
												
	memory: RAM port map( clk => clk,
								 inst_addr => (others => '0'),
								 data_addr => tmp_addr(12 downto 2),
								 data_we => MEM_WrEn,
								 data_din => MEM_DataIn,
								 data_dout => MEM_DataOut);


end Structural;

