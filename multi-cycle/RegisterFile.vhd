----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:11:34 02/17/2019 
-- Design Name: 
-- Module Name:    RegisterFile - Behavioral 
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

entity RegisterFile is
    Port ( Ard1 : in  STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in  STD_LOGIC_VECTOR (4 downto 0);
           Awr : in  STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR (31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR (31 downto 0);
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end RegisterFile;

architecture Structural of RegisterFile is
signal Dec_Awr : std_logic_vector (31 downto 0);
signal WE_regI : std_logic_vector (31 downto 1);
type slv_array is array (0 to 31) of std_logic_vector (31 downto 0);
signal Dout_regI : slv_array;

component Decoder is
    Port ( Inp : in  STD_LOGIC_VECTOR (4 downto 0);
           Outp : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Register_Nbits is
    Port ( CLK : in  STD_LOGIC;
           WE : in  STD_LOGIC;
			  Reset : in  STD_LOGIC;
           Din : in  STD_LOGIC_VECTOR (31 downto 0);
           Dout : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

begin

dec : Decoder Port Map (Awr, Dec_Awr);

zero_reg : Register_Nbits Port Map (CLK, '1', Reset, X"00000000", Dout_regI(0));

GEN_RF : for i in 1 to 31 generate
reg : Register_Nbits Port Map (CLK, WE_regI(i), Reset, Din, Dout_regI(i));
end generate GEN_RF;

process (Dec_Awr, WrEn)
begin
	for i in 1 to 31 loop
		WE_regI(i) <= (WrEn and Dec_Awr(i)) after 2 ns;
	end loop;
end process;

process (Ard1, Ard2, Dout_regI)
begin
	for i in 0 to 31 loop
		if i = to_integer(unsigned(Ard1)) then
			Dout1 <= Dout_regI(i) after 5 ns;
		end if;
		
		if i = to_integer(unsigned(Ard2)) then
			Dout2 <= Dout_regI(i) after 5 ns;
		end if;
	end loop;
end process;

end Structural;

