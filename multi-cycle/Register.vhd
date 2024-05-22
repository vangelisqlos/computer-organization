----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:48:23 02/17/2019 
-- Design Name: 
-- Module Name:    Register - Behavioral 
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

entity Register_Nbits is
	 Generic (N : integer := 32);
    Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Dout : out  STD_LOGIC_VECTOR (N-1 downto 0));
end Register_Nbits;

architecture Behavioral of Register_Nbits is

begin

process (CLK)
begin
	if rising_edge(CLK) then
		if Reset = '1' then
			Dout <= (others => '0') after 5 ns;
		elsif WE = '1' then
			Dout <= Din after 5 ns;
		end if;
	end if;
end process;

end Behavioral;

