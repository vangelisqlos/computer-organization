--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:06:07 03/06/2019
-- Design Name:   
-- Module Name:   C:/Users/Vangelis/Desktop/proxwrhmenh/HPY312_LAB2/incr_test.vhd
-- Project Name:  HPY312_LAB2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: plus4_adder
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
 
ENTITY incr_test IS
END incr_test;
 
ARCHITECTURE behavior OF incr_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT plus4_adder
    PORT(
         Add_in : IN  std_logic_vector(31 downto 0);
         Add_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Add_in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Add_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   --constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: plus4_adder PORT MAP (
          Add_in => Add_in,
          Add_out => Add_out
        );

   -- Clock process definitions
--   <clock>_process :process
--   begin
--		<clock> <= '0';
--		wait for <clock>_period/2;
--		<clock> <= '1';
--		wait for <clock>_period/2;
--   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		Add_in <= "00000000000000000000000000000000";
      wait for 100 ns;	
		
		Add_in <= "00000000000000000000000000000001";
      wait for 100 ns;
		
		Add_in <= "00000000000000000000000000000010";
      wait for 100 ns;
      --wait for <clock>_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
