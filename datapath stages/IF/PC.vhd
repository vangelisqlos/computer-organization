----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:04:56 03/03/2019 
-- Design Name: 
-- Module Name:    PC - Behavioral 
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

entity PC is
	port( clk, reset, PC_LdEn : in STD_LOGIC;
			PC_addr : in STD_LOGIC_VECTOR(31 downto 0);
			PC_out : out STD_LOGIC_VECTOR(31 downto 0));
end PC;

architecture Behavioral of PC is

begin

process(clk)
begin
	if(rising_edge(clk)) then
		if reset = '1' then
			PC_out <= (others => '0');
		elsif PC_LdEn = '1' then
			PC_out <= PC_addr;
		end if;
	end if;
end process;

end Behavioral;

