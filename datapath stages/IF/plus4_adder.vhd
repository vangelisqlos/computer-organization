----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:35:50 03/03/2019 
-- Design Name: 
-- Module Name:    plus4_adder - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity plus4_adder is
    Port ( Add_in : in  STD_LOGIC_VECTOR (31 downto 0);
           Add_out : out  STD_LOGIC_VECTOR (31 downto 0));
end plus4_adder;

architecture Behavioral of plus4_adder is

begin
	Add_out <= STD_LOGIC_VECTOR(to_signed(to_integer(signed(Add_in)) + 4, 32));

end Behavioral;

