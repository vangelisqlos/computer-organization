--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:15:44 03/06/2019
-- Design Name:   
-- Module Name:   C:/Users/Vangelis/Desktop/proxwrhmenh/HPY312_LAB2/addrsAdd_test.vhd
-- Project Name:  HPY312_LAB2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: address_adder
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
 
ENTITY addrsAdd_test IS
END addrsAdd_test;
 
ARCHITECTURE behavior OF addrsAdd_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT address_adder
    PORT(
         ALU_MEM_Addr : IN  std_logic_vector(31 downto 0);
         Address_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ALU_MEM_Addr : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Address_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: address_adder PORT MAP (
          ALU_MEM_Addr => ALU_MEM_Addr,
          Address_out => Address_out
        );

   -- Clock process definitions
   --<clock>_process :process
   --begin
	--	<clock> <= '0';
	--	wait for <clock>_period/2;
	--	<clock> <= '1';
	--	wait for <clock>_period/2;
   --end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		ALU_MEM_Addr <= "00000000000000000000000000000000";
      wait for 100 ns;	
		
		ALU_MEM_Addr <= "00000000000000000000000000000001";
      wait for 100 ns;
		
		ALU_MEM_Addr <= "00000000000000000000000000000010";
      wait for 100 ns;	

      --wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
