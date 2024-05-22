----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:09:47 03/03/2019 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_Out : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;
           Cout : out  STD_LOGIC;
           Ovf : out  STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
signal temp : std_logic_vector(32 downto 0);
signal eval1, eval2 : std_logic;

begin

process (Op, A, B)
begin
	if Op = "0000" then
		temp <= std_logic_vector(to_signed(to_integer(signed(A)) + to_integer(signed(B)), 33));
	elsif Op = "0001" then
		temp <= std_logic_vector(to_signed(to_integer(signed(A)) - to_integer(signed(B)), 33));
	elsif Op = "0010" then
		temp(31 downto 0) <= A and B;
	elsif Op = "0011" then
		temp(31 downto 0) <= A or B;
	elsif Op = "0100" then
		temp(31 downto 0) <= not A;
	elsif Op = "0110" then
		temp(31 downto 0) <= A nand B;
	elsif Op = "1000" then
		temp(30 downto 0) <= A(31 downto 1);
		temp(31) <= A(31);
	elsif Op = "1001" then
		temp(30 downto 0) <= A(31 downto 1);
		temp(31) <= '0';
	elsif Op = "1010" then
		temp(31 downto 1) <= A(30 downto 0);
		temp(0) <= '0';
	elsif Op = "1100" then
		temp(31 downto 1) <= A(30 downto 0);
		temp(0) <= A(31);
	elsif Op = "1101" then
		temp(30 downto 0) <= A(31 downto 1);
		temp(31) <= A(0);
	else
		
	end if;
end process;

process (temp, Op, A, B, eval1, eval2)
begin
	ALU_Out <= temp(31 downto 0) after 10ns;
	
	if temp = "00000000000000000000000000000000" then
		Zero <= '1' after 10ns;
	else
		Zero <= '0' after 10ns;
	end if;
	
	eval1 <= (A(31) xnor B(31)) and (temp(31) and not A(31));
	eval2 <= (A(31) xor B(31)) and (temp(31) and not A(31));
	
	if (Op = "0000" and eval1 = '1') or (Op = "0001" and eval2 = '1') then
		Ovf <= '1' after 10 ns;
	else
		Ovf <= '0' after 10 ns;
	end if;
	
	if (Op(3 downto 1) = "000") then
		Cout <= temp(32) after 10 ns;
	else
		Cout <= '0' after 10 ns;
	end if;

end process;

end Behavioral;


