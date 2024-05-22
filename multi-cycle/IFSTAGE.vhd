----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:56:43 02/26/2019 
-- Design Name: 
-- Module Name:    BranchUnit - Behavioral 
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

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC_VECTOR (1 downto 0);
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0);
			  EPC : in STD_LOGIC_VECTOR (31 downto 0);
			  Handler_addr : in STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Structural of IFSTAGE is
signal MUX_out, PC_out : std_logic_vector (31 downto 0);

component Register_Nbits is
    Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

PC_reg : Register_Nbits Port Map (CLK, PC_LdEn, Reset, MUX_out, PC_out);

process (PC_sel, PC_out, PC_Immed, Handler_addr, EPC)
begin
	if PC_sel = "00" then
		MUX_out <= std_logic_vector(signed(PC_out) + 4) after 5 ns;
	elsif PC_sel = "01" then
		MUX_out <= std_logic_vector(signed(PC_out) + shift_left(signed(PC_Immed), 2)) after 5 ns;
	elsif PC_sel = "10" then
		MUX_out <= Handler_addr after 5 ns;
	elsif PC_sel = "11" then
		MUX_out <= EPC after 5 ns;
	end if;
end process;

PC <= PC_out;

end Structural;

