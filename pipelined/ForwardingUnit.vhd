----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:12:37 05/08/2019 
-- Design Name: 
-- Module Name:    ForwardingUnit - Behavioral 
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

entity ForwardingUnit is
    Port ( ALUtoMEM_RF_WrEn : in STD_LOGIC;
           MEMtoWB_RF_WrEn : in STD_LOGIC;
			  ALUtoMEM_rd : in  STD_LOGIC_VECTOR (4 downto 0);
			  MEMtoWB_rd : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rs : in  STD_LOGIC_VECTOR (4 downto 0);
           DEC_rt : in  STD_LOGIC_VECTOR (4 downto 0);
           ForwardA : out  STD_LOGIC_VECTOR (1 downto 0);
           ForwardB : out  STD_LOGIC_VECTOR (1 downto 0));
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is

begin

process(ALUtoMEM_RF_WrEn, MEMtoWB_RF_WrEn, ALUtoMEM_rd, MEMtoWB_rd, DEC_rs, DEC_rt)
begin
	if MEMtoWB_RF_WrEn = '1' and (not std_match(MEMtoWB_rd, "00000")) and std_match(MEMtoWB_rd, DEC_rs) then
		ForwardA <= "01";
	elsif ALUtoMEM_RF_WrEn = '1' and (not std_match(ALUtoMEM_rd, "00000")) and std_match(ALUtoMEM_rd, DEC_rs) then
		ForwardA <= "10";
	else
		ForwardA <= "00";
	end if;
	
	if MEMtoWB_RF_WrEn = '1' and (not std_match(MEMtoWB_rd, "00000")) and std_match(MEMtoWB_rd, DEC_rt) then
		ForwardB <= "01";
	elsif ALUtoMEM_RF_WrEn = '1' and (not std_match(ALUtoMEM_rd, "00000")) and std_match(ALUtoMEM_rd, DEC_rt) then
		ForwardB <= "10";
	else
		ForwardB <= "00";
	end if;
end process;

end Behavioral;

