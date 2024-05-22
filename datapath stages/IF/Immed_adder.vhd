----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:42:06 03/03/2019 
-- Design Name: 
-- Module Name:    Immed_adder - Behavioral 
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

entity Immed_adder is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_incr : in  STD_LOGIC_VECTOR (31 downto 0);
           D_out : out  STD_LOGIC_VECTOR (31 downto 0));
end Immed_adder;

architecture Behavioral of Immed_adder is

begin
	D_out <= std_logic_vector(to_signed(to_integer(signed(PC_Immed)) + to_integer(signed(PC_incr)), 32));

end Behavioral;

