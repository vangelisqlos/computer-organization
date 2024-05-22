--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:02:08 03/15/2019
-- Design Name:   
-- Module Name:   C:/Users/Alex/Documents/Xilinx/workspace/HRY312_lab3/CPU_Datapath_TEST.vhd
-- Project Name:  HRY312_lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: CPU_Datapath
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
 
ENTITY CPU_Datapath_TEST IS
END CPU_Datapath_TEST;
 
ARCHITECTURE behavior OF CPU_Datapath_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT CPU_Datapath
    PORT(
         CLK : IN  std_logic;
         Reset : IN  std_logic;
         PC_sel : IN  std_logic;
         PC_LdEn : IN  std_logic;
         RF_WrEn : IN  std_logic;
         RF_WrData_sel : IN  std_logic;
         RF_B_sel : IN  std_logic;
         ImmExt_s : IN  std_logic;
         ALU_Bin_sel : IN  std_logic;
         ALU_func : IN  std_logic_vector(3 downto 0);
         Mem_WrEn : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal Reset : std_logic := '0';
   signal PC_sel : std_logic := '0';
   signal PC_LdEn : std_logic := '0';
   signal RF_WrEn : std_logic := '0';
   signal RF_WrData_sel : std_logic := '0';
   signal RF_B_sel : std_logic := '0';
   signal ImmExt_s : std_logic := '0';
   signal ALU_Bin_sel : std_logic := '0';
   signal ALU_func : std_logic_vector(3 downto 0) := (others => '0');
   signal Mem_WrEn : std_logic := '0';

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: CPU_Datapath PORT MAP (
          CLK => CLK,
          Reset => Reset,
          PC_sel => PC_sel,
          PC_LdEn => PC_LdEn,
          RF_WrEn => RF_WrEn,
          RF_WrData_sel => RF_WrData_sel,
          RF_B_sel => RF_B_sel,
          ImmExt_s => ImmExt_s,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_func => ALU_func,
          Mem_WrEn => Mem_WrEn
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
		Reset <= '1';
		wait for clk_period*1;
		
		PC_sel <='0'; 
		
		PC_LdEn <='0'; 
		Reset <= '0';
		wait for clk_period*1;
		--wait for 10 ns ;
		Reset <= '0';


		  -- addi r5,r0,8

		PC_sel <='0'; 
		PC_LdEn<='1'; 
		RF_WrEn <='1';
		RF_WrData_sel <='0'; --Alu out 
		RF_B_sel  <='0';
		ImmExt_s<='1';  -- SIGN EXT
		ALU_Bin_sel <='1';  --Immed
		ALU_func <="0000"; --add			
		Mem_WrEn  <='0';

		wait for clk_period*1;
		
		-- ori r3,r0,ABCD]
		
		PC_sel <='0'; 			
		PC_LdEn <='1'; 
		RF_WrEn <='1';
		RF_WrData_sel <='0'; --Alu out 
		RF_B_sel  <='0';
		ImmExt_s<='0'; --zero fill
		ALU_Bin_sel <='1';  --Immed
		ALU_func <="0011"; --OR			
		Mem_WrEn  <='0';
		wait for clk_period*1;
		
		-- sw r3 4(r0)
		
		PC_sel <='0'; 
		PC_LdEn <='1'; 
		RF_WrEn <='0';
		RF_WrData_sel <='1'; --Mem out dont care
		RF_B_sel  <='1';
		ImmExt_s<='1';
		ALU_Bin_sel <='1';  --Immed
		ALU_func  <="0000";	--add	
		Mem_WrEn  <='1'; 
		wait for clk_period*1;

		-- lw r10,-4(r5)
		 
		PC_sel <='0'; 
		PC_LdEn <='1'; 
		RF_WrEn <='1';
		RF_WrData_sel <='1'; --Mem out 
		RF_B_sel  <='0';
		ImmExt_s <= '1';
		ALU_Bin_sel <='1';  --Immed
		ALU_func  <="0000";--add		
		Mem_WrEn  <='0';  
		wait for clk_period*1;
		
		-- lb r16 4(r0)
		
		PC_sel <='0'; 
		PC_LdEn <='1'; 
		RF_WrEn <='1';
		RF_WrData_sel <='1'; --Mem out 
		RF_B_sel  <='0';
		ImmExt_s <= '1';
		ALU_Bin_sel <='1';  --Immed
		ALU_func  <="0000"; --add		
		Mem_WrEn  <='0';  

		wait for clk_period*1;
		
		-- nand r4,r0,r16
		PC_sel <='0'; 
		PC_LdEn <='1'; 
		RF_WrEn <='1';
		RF_WrData_sel <='0'; --Mem out 
		RF_B_sel  <='0'; --rt
		ImmExt_s <= 'X'; -- dont care
		ALU_Bin_sel <='0';  --RF_B
		ALU_func  <="0010"; --nand		
		Mem_WrEn  <='0';
      wait for CLK_period;

      wait;
   end process;

END;
