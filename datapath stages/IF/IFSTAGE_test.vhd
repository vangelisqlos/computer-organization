--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:38:15 03/06/2019
-- Design Name:   
-- Module Name:   C:/Users/Vangelis/Desktop/proxwrhmenh/HPY312_LAB2/IFSTAGE_test.vhd
-- Project Name:  HPY312_LAB2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IFSTAGE
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
USE ieee.numeric_std.ALL;
 
ENTITY IFSTAGE_test IS
END IFSTAGE_test;
 
ARCHITECTURE behavior OF IFSTAGE_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IFSTAGE
    PORT(
         PC_Immed : IN  std_logic_vector(31 downto 0);
         PC_Sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         Reset : IN  std_logic;
         clk : IN  std_logic;
         Instr : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal PC_Immed : std_logic_vector(31 downto 0) := (others => '0');
   signal PC_Sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal Reset : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal Instr : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IFSTAGE PORT MAP (
          PC_Immed => PC_Immed,
          PC_Sel => PC_Sel,
          PC_LdEn => PC_LdEn,
          Reset => Reset,
          clk => clk,
          Instr => Instr
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		Reset <= '1';
      wait for clk_period;
		
		Reset <= '0';
		PC_Immed <= "00000000000000000000000000000100";
		PC_Sel <= '1';
      wait for clk_period;
		
		PC_LdEn <= '1';
		wait for clk_period;


--		Reset <= '1';
--      wait for 100 ns;	
--	
--		PC_Immed <= std_logic_vector(to_unsigned(32, PC_Immed'length));
--		PC_sel <= '0';
--		PC_LdEn <= '0';
--		Reset <= '0';
--      wait for CLK_period;
--		
--		PC_Immed <= std_logic_vector(to_unsigned(32, PC_Immed'length));
--		PC_sel <= '0';
--		PC_LdEn <= '1';
--		Reset <= '0';
--      wait for CLK_period;
--		
--		PC_Immed <= std_logic_vector(to_unsigned(32, PC_Immed'length));
--		PC_sel <= '0';
--		PC_LdEn <= '0';
--		Reset <= '0';
--      wait for CLK_period;
--		
--		PC_Immed <= std_logic_vector(to_unsigned(32, PC_Immed'length));
--		PC_sel <= '1';
--		PC_LdEn <= '1';
--		Reset <= '0';
--      wait for CLK_period;
--		
--		PC_Immed <= std_logic_vector(to_unsigned(32, PC_Immed'length));
--		PC_sel <= '0';
--		PC_LdEn <= '1';
--		Reset <= '1';
--      wait for CLK_period;
--		
--		PC_Immed <= std_logic_vector(to_unsigned(128, PC_Immed'length));
--		PC_sel <= '0';
--		PC_LdEn <= '1';
--		Reset <= '0';
--      wait for CLK_period;
--		
	   -- insert stimulus here 

      wait;
   end process;

END;
