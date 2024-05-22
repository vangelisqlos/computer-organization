----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:20:40 05/08/2019 
-- Design Name: 
-- Module Name:    HazardUnit - Behavioral 
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

entity HazardUnit is
    Port ( rt_IF : in  STD_LOGIC_VECTOR (4 downto 0);
           rs_IF : in  STD_LOGIC_VECTOR (4 downto 0);
           rt_DEC : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_MEM_WrEn : in  STD_LOGIC;
           PC_enable : out  STD_LOGIC;
           InstReg_En : out  STD_LOGIC;
           CS_sel : out  STD_LOGIC);
end HazardUnit;

architecture Behavioral of HazardUnit is

begin

process(rt_IF, rs_IF, rt_DEC, DEC_MEM_WrEn)
begin
	if DEC_MEM_WrEn = '1' and (std_match(rt_IF, rt_DEC) or std_match(rs_IF, rt_DEC)) then
		PC_enable <= '0';
		InstReg_En <= '0';
		CS_sel <= '1';
	else
		PC_enable <= '1';
		InstReg_En <= '1';
		CS_sel <= '0';
	end if;
end process;

end Behavioral;

