----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:42:47 03/19/2019 
-- Design Name: 
-- Module Name:    MUX - Behavioral 
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

entity MUX is
	 Generic (N : integer);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in  STD_LOGIC;
           MUX_Out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end MUX;

architecture Behavioral of MUX is

begin

process (A, B, Sel)
begin
	if Sel = '0' then
		MUX_Out <= A after 5 ns;
	else
		MUX_Out <= B after 5 ns;
	end if;
end process;

end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2 is
	 Generic (N : integer);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
			  C : in  STD_LOGIC_VECTOR (N-1 downto 0);
           D : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in  STD_LOGIC_VECTOR (1 downto 0);
           MUX_Out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end MUX2;

architecture Behavioral of MUX2 is

begin

with Sel select MUX_Out <= A when "00",
									B when "01",
									C when "10",
									D when "11";

end Behavioral;

