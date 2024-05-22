----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:46:52 03/04/2019 
-- Design Name: 
-- Module Name:    address_adder - Behavioral 
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

entity address_adder is
    Port ( ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0);
           Address_out : out  STD_LOGIC_VECTOR (31 downto 0));
end address_adder;

architecture Behavioral of address_adder is

begin
	Address_out <= STD_LOGIC_VECTOR(to_signed(to_integer(signed(ALU_MEM_Addr)) + 1024, 32));

end Behavioral;

