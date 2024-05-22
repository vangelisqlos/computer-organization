--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:17:44 02/17/2019
-- Design Name:   
-- Module Name:   C:/Users/01001001/Documents/Xilinx/workspace/Computer Organization HPY312/lab1/RegisterFile_TEST.vhd
-- Project Name:  lab1
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RegisterFile
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
USE ieee.numeric_std.ALL;
 
ENTITY RegisterFile_TEST IS
END RegisterFile_TEST;
 
ARCHITECTURE behavior OF RegisterFile_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RegisterFile
    PORT(
         Ard1 : IN  std_logic_vector(4 downto 0);
         Ard2 : IN  std_logic_vector(4 downto 0);
         Awr : IN  std_logic_vector(4 downto 0);
         Dout1 : OUT  std_logic_vector(31 downto 0);
         Dout2 : OUT  std_logic_vector(31 downto 0);
         Din : IN  std_logic_vector(31 downto 0);
         WrEn : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Ard1 : std_logic_vector(4 downto 0) := (others => '0');
   signal Ard2 : std_logic_vector(4 downto 0) := (others => '0');
   signal Awr : std_logic_vector(4 downto 0) := (others => '0');
   signal Din : std_logic_vector(31 downto 0) := (others => '0');
   signal WrEn : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal Dout1 : std_logic_vector(31 downto 0);
   signal Dout2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 14 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RegisterFile PORT MAP (
          Ard1 => Ard1,
          Ard2 => Ard2,
          Awr => Awr,
          Dout1 => Dout1,
          Dout2 => Dout2,
          Din => Din,
          WrEn => WrEn,
          CLK => CLK
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
		
		WrEn <= '1';
--		for i in 0 to 1 loop
--			Awr <= std_logic_vector(to_unsigned(i, 5));
--			Din <= (	i => '1',
--						others => '0');
--			wait for 20 ns;
--		end loop;

		Awr <= "00000";
		Din <= "00000000000000000000000000000001";
      wait for CLK_period*10;
		Awr <= "00001";
		Din <= "00000000000000000000000000000010";
      wait for CLK_period*10;
		Awr <= "00010";
		Din <= "00000000000000000000000000000100";
      wait for CLK_period*10;
		
      wait for 100 ns;	
		
		WrEn <= '0';
		Ard1 <= "00000";
		Ard2 <= "00001";
      wait for CLK_period*10;
		
		WrEn <= '1';
		Awr <= "00001";
		Din <= "01111111111111111111111111111111";
      wait for CLK_period*10;
		
		WrEn <= '0';
		Ard1 <= "00000";
		Ard2 <= "00001";
      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
