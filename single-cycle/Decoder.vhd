----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:14:00 02/17/2019 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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

entity Decoder is
    Port ( Inp : in  STD_LOGIC_VECTOR (4 downto 0);
           Outp : out  STD_LOGIC_VECTOR (31 downto 0));
end Decoder;

architecture Behavioral of Decoder is

begin

process(Inp)
begin
	for i in 0 to 31 loop
		if i = to_integer(unsigned(Inp)) then
			Outp(i) <= '1' after 5 ns;
		else
			Outp(i) <= '0' after 5 ns;
		end if;
	end loop;
end process;

end Behavioral;

