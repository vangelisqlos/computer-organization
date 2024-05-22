--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   22:21:56 02/16/2019
-- Design Name:   
-- Module Name:   C:/Users/01001001/Documents/Xilinx/workspace/Computer Organization HPY312/lab1/ALU2_TEST.vhd
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU2
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY ALU2_TEST IS
END ALU2_TEST;
 
ARCHITECTURE behavior OF ALU2_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU2
    PORT(
         A : IN  std_logic_vector(31 downto 0);
         B : IN  std_logic_vector(31 downto 0);
         Op : IN  std_logic_vector(3 downto 0);
         ALU_Out : OUT  std_logic_vector(31 downto 0);
         Zero : OUT  std_logic;
         Cout : OUT  std_logic;
         Ovf : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal Op : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal ALU_Out : std_logic_vector(31 downto 0);
   signal Zero : std_logic;
   signal Cout : std_logic;
   signal Ovf : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU2 PORT MAP (
          A => A,
          B => B,
          Op => Op,
          ALU_Out => ALU_Out,
          Zero => Zero,
          Cout => Cout,
          Ovf => Ovf
        );

   

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
		
		A <= "00000000000000000000000000000001";
		B <= "00000000000000000000000000000001";
		Op <= "0000";
		wait for 100 ns;
      
		A <= "00000000000000000000000000000001";
		B <= "00000000000000000000000000000001";
		Op <= "0001";
		wait for 100 ns;
		
		A <= "01111111111111111111111111111111";
		B <= "01111111111111111111111111111111";
		Op <= "0000";
		wait for 100 ns;
		
		A <= "00000000000000000000000000101111";
		B <= "00000000000000000000000000010110";
		Op <= "0010";
		wait for 100 ns;
		
		A <= "00000000000000000000000000101111";
		B <= "00000000000000000000000000010110";
		Op <= "0011";
		wait for 100 ns;
		
		A <= "00000000000000000000000000101111";
		Op <= "0100";
		wait for 100 ns;
		
		
		
		A <= "10000000000000000000000000000010";
		B <= "00000000000000000000000000000000";
		Op <= "1000";
		wait for 100 ns;
		
		A <= "10000000000000000000000000000010";
		Op <= "1001";
		wait for 100 ns;
		
		A <= "00000000000000000000000000000001";
		Op <= "1010";
		wait for 100 ns;
		
		A <= "10000000000000000000000000000001";
		Op <= "1100";
		wait for 100 ns;
		
		A <= "10000000000000000000000000000001";
		Op <= "1101";
		wait for 100 ns;

      wait;
   end process;

END;
