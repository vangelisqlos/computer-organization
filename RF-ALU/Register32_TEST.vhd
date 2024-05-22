--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:47:10 02/17/2019
-- Design Name:   
-- Module Name:   C:/Users/01001001/Documents/Xilinx/workspace/Computer Organization HPY312/lab1/Register32_TEST.vhd
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Register32
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
 
ENTITY Register32_TEST IS
END Register32_TEST;
 
ARCHITECTURE behavior OF Register32_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Register32
    PORT(
         CLK : IN  std_logic;
         WE : IN  std_logic;
         Din : IN  std_logic_vector(31 downto 0);
         Dout : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal WE : std_logic := '0';
   signal Din : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Dout : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Register32 PORT MAP (
          CLK => CLK,
          WE => WE,
          Din => Din,
          Dout => Dout
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
		
		WE <= '0';
		Din <= "01010101010101010111111111111111";
      wait for CLK_period*10;
		
		WE <= '1';
		Din <= "01010101010101010111111111111111";
      wait for CLK_period*10;
		
		WE <= '1';
		Din <= "00000000000000000000000000000001";
      wait for CLK_period*10;
		
		WE <= '0';
		Din <= "11111111111111111111111111111111";
      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
