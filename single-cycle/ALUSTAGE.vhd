----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:38:53 02/26/2019 
-- Design Name: 
-- Module Name:    ALUSTAGE - Behavioral 
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

entity ALUSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0));
end ALUSTAGE;

architecture Behavioral of ALUSTAGE is
signal ALU_Bin : std_logic_vector (31 downto 0);

component ALU2 is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_Out : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end component;

component MUX is
	 Generic (N : integer);
    Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
           B : in  STD_LOGIC_VECTOR (N-1 downto 0);
           Sel : in  STD_LOGIC;
           MUX_Out : out  STD_LOGIC_VECTOR (N-1 downto 0));
end component;

begin

ALU_S : ALU2 Port Map (RF_A, ALU_Bin, ALU_func, ALU_out, open, open, open);

ALU_Bin_SEL_MUX : MUX 	Generic Map (N => 5)
								Port Map ( A => RF_B,
											  B => Immed,
											  Sel => ALU_Bin_sel,
											  MUX_Out => ALU_Bin);


end Behavioral;

