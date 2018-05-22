-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"
-- CREATED		"Tue May 22 10:52:22 2018"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY CPU IS 
	PORT
	(
		reset_n :  IN  STD_LOGIC;
		clk :  IN  STD_LOGIC;
		D_rddata :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		I_rddata :  IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
		D_read :  OUT  STD_LOGIC;
		D_write :  OUT  STD_LOGIC;
		D_addr :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		D_wrdata :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
		I_addr :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END CPU;

ARCHITECTURE bdf_type OF CPU IS 

COMPONENT alu
	PORT(a : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 s : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT extend
	PORT(signed : IN STD_LOGIC;
		 imm16 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 imm32 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pipeline_reg_mw
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 rf_wren_in : IN STD_LOGIC;
		 mux_1_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_2_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 rf_wren_out : OUT STD_LOGIC;
		 mux_1_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_2_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pipeline_reg_fd
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 I_rddata_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 next_addr_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 I_rddata_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 next_addr_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pipeline_reg_em
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 sel_mem_in : IN STD_LOGIC;
		 rf_wren_in : IN STD_LOGIC;
		 mux_1_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_2_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 sel_mem_out : OUT STD_LOGIC;
		 rf_wren_out : OUT STD_LOGIC;
		 mux_1_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_2_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pipeline_reg_de
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 sel_b_in : IN STD_LOGIC;
		 read_in : IN STD_LOGIC;
		 write_in : IN STD_LOGIC;
		 sel_pc_in : IN STD_LOGIC;
		 branch_op_in : IN STD_LOGIC;
		 sel_mem_in : IN STD_LOGIC;
		 rf_wren_in : IN STD_LOGIC;
		 a_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 b_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 d_imm_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_in : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 next_addr_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 op_alu_in : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 sel_b_out : OUT STD_LOGIC;
		 read_out : OUT STD_LOGIC;
		 write_out : OUT STD_LOGIC;
		 sel_pc_out : OUT STD_LOGIC;
		 branch_op_out : OUT STD_LOGIC;
		 sel_mem_out : OUT STD_LOGIC;
		 rf_wren_out : OUT STD_LOGIC;
		 a_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 b_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 d_imm_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 mux_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		 next_addr_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 op_alu_out : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
	);
END COMPONENT;

COMPONENT pc
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 sel_a : IN STD_LOGIC;
		 sel_imm : IN STD_LOGIC;
		 branch : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 d_imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 e_imm : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 pc_addr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
		 addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 next_addr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END COMPONENT;

COMPONENT controller
	PORT(op : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 opx : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		 imm_signed : OUT STD_LOGIC;
		 sel_b : OUT STD_LOGIC;
		 read : OUT STD_LOGIC;
		 write : OUT STD_LOGIC;
		 sel_pc : OUT STD_LOGIC;
		 branch_op : OUT STD_LOGIC;
		 sel_mem : OUT STD_LOGIC;
		 rf_wren : OUT STD_LOGIC;
		 pc_sel_imm : OUT STD_LOGIC;
		 pc_sel_a : OUT STD_LOGIC;
		 sel_ra : OUT STD_LOGIC;
		 sel_rC : OUT STD_LOGIC;
		 op_alu : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
		 rf_retaddr : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2x5
	PORT(sel : IN STD_LOGIC;
		 i0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 i1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 o : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END COMPONENT;

COMPONENT mux2x32
	PORT(sel : IN STD_LOGIC;
		 i0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 i1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 o : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

COMPONENT register_file
	PORT(clk : IN STD_LOGIC;
		 wren : IN STD_LOGIC;
		 aa : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 ab : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 aw : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		 wrdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		 a : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		 b : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	a :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	alu_res :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	d_imm_in :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	d_imm_out :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	I :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_10 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_11 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_12 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_13 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_14 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_15 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_16 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_17 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_18 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_19 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_20 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_21 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_22 :  STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_23 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_24 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_25 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_43 :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_27 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_28 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_30 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_31 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_32 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_33 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_34 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_35 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_36 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_37 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_38 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_39 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_40 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_41 :  STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_42 :  STD_LOGIC_VECTOR(31 DOWNTO 0);


BEGIN 
D_wrdata <= SYNTHESIZED_WIRE_32;
SYNTHESIZED_WIRE_28 <= '0';



b2v_alu_0 : alu
PORT MAP(a => SYNTHESIZED_WIRE_0,
		 b => SYNTHESIZED_WIRE_1,
		 op => SYNTHESIZED_WIRE_2,
		 s => alu_res);



b2v_inst1 : extend
PORT MAP(signed => SYNTHESIZED_WIRE_3,
		 imm16 => I(21 DOWNTO 6),
		 imm32 => d_imm_in);


b2v_inst2 : pipeline_reg_mw
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 rf_wren_in => SYNTHESIZED_WIRE_4,
		 mux_1_in => SYNTHESIZED_WIRE_5,
		 mux_2_in => SYNTHESIZED_WIRE_6,
		 rf_wren_out => SYNTHESIZED_WIRE_40,
		 mux_1_out => SYNTHESIZED_WIRE_42,
		 mux_2_out => SYNTHESIZED_WIRE_41);


b2v_inst3 : pipeline_reg_fd
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 I_rddata_in => I_rddata,
		 next_addr_in => SYNTHESIZED_WIRE_7,
		 I_rddata_out => I,
		 next_addr_out => SYNTHESIZED_WIRE_21);


b2v_inst4 : pipeline_reg_em
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 sel_mem_in => SYNTHESIZED_WIRE_8,
		 rf_wren_in => SYNTHESIZED_WIRE_9,
		 mux_1_in => SYNTHESIZED_WIRE_10,
		 mux_2_in => SYNTHESIZED_WIRE_11,
		 sel_mem_out => SYNTHESIZED_WIRE_33,
		 rf_wren_out => SYNTHESIZED_WIRE_4,
		 mux_1_out => SYNTHESIZED_WIRE_34,
		 mux_2_out => SYNTHESIZED_WIRE_6);


b2v_inst5 : pipeline_reg_de
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 sel_b_in => SYNTHESIZED_WIRE_12,
		 read_in => SYNTHESIZED_WIRE_13,
		 write_in => SYNTHESIZED_WIRE_14,
		 sel_pc_in => SYNTHESIZED_WIRE_15,
		 branch_op_in => SYNTHESIZED_WIRE_16,
		 sel_mem_in => SYNTHESIZED_WIRE_17,
		 rf_wren_in => SYNTHESIZED_WIRE_18,
		 a_in => a,
		 b_in => SYNTHESIZED_WIRE_19,
		 d_imm_in => d_imm_in,
		 mux_in => SYNTHESIZED_WIRE_20,
		 next_addr_in => SYNTHESIZED_WIRE_21,
		 op_alu_in => SYNTHESIZED_WIRE_22,
		 sel_b_out => SYNTHESIZED_WIRE_31,
		 read_out => D_read,
		 write_out => D_write,
		 sel_pc_out => SYNTHESIZED_WIRE_35,
		 branch_op_out => SYNTHESIZED_WIRE_27,
		 sel_mem_out => SYNTHESIZED_WIRE_8,
		 rf_wren_out => SYNTHESIZED_WIRE_9,
		 a_out => SYNTHESIZED_WIRE_0,
		 b_out => SYNTHESIZED_WIRE_32,
		 d_imm_out => d_imm_out,
		 mux_out => SYNTHESIZED_WIRE_11,
		 next_addr_out => SYNTHESIZED_WIRE_43,
		 op_alu_out => SYNTHESIZED_WIRE_2);


b2v_inst6 : pc
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 sel_a => SYNTHESIZED_WIRE_23,
		 sel_imm => SYNTHESIZED_WIRE_24,
		 branch => SYNTHESIZED_WIRE_25,
		 a => a(15 DOWNTO 0),
		 d_imm => d_imm_in(15 DOWNTO 0),
		 e_imm => d_imm_out(15 DOWNTO 0),
		 pc_addr => SYNTHESIZED_WIRE_43,
		 addr => I_addr,
		 next_addr => SYNTHESIZED_WIRE_7);


b2v_inst7 : controller
PORT MAP(op => I(5 DOWNTO 0),
		 opx => I(16 DOWNTO 11),
		 imm_signed => SYNTHESIZED_WIRE_3,
		 sel_b => SYNTHESIZED_WIRE_12,
		 read => SYNTHESIZED_WIRE_13,
		 write => SYNTHESIZED_WIRE_14,
		 sel_pc => SYNTHESIZED_WIRE_15,
		 branch_op => SYNTHESIZED_WIRE_16,
		 sel_mem => SYNTHESIZED_WIRE_17,
		 rf_wren => SYNTHESIZED_WIRE_18,
		 pc_sel_imm => SYNTHESIZED_WIRE_24,
		 pc_sel_a => SYNTHESIZED_WIRE_23,
		 sel_ra => SYNTHESIZED_WIRE_37,
		 sel_rC => SYNTHESIZED_WIRE_30,
		 op_alu => SYNTHESIZED_WIRE_22,
		 rf_retaddr => SYNTHESIZED_WIRE_39);


SYNTHESIZED_WIRE_25 <= alu_res(0) AND SYNTHESIZED_WIRE_27;


b2v_inst9 : extend
PORT MAP(signed => SYNTHESIZED_WIRE_28,
		 imm16 => SYNTHESIZED_WIRE_43,
		 imm32 => SYNTHESIZED_WIRE_36);


b2v_mux_aw : mux2x5
PORT MAP(sel => SYNTHESIZED_WIRE_30,
		 i0 => I(26 DOWNTO 22),
		 i1 => I(21 DOWNTO 17),
		 o => SYNTHESIZED_WIRE_38);


b2v_mux_b : mux2x32
PORT MAP(sel => SYNTHESIZED_WIRE_31,
		 i0 => d_imm_out,
		 i1 => SYNTHESIZED_WIRE_32,
		 o => SYNTHESIZED_WIRE_1);


b2v_mux_mem : mux2x32
PORT MAP(sel => SYNTHESIZED_WIRE_33,
		 i0 => SYNTHESIZED_WIRE_34,
		 i1 => D_rddata,
		 o => SYNTHESIZED_WIRE_5);


b2v_mux_mem1 : mux2x32
PORT MAP(sel => SYNTHESIZED_WIRE_35,
		 i0 => alu_res,
		 i1 => SYNTHESIZED_WIRE_36,
		 o => SYNTHESIZED_WIRE_10);


b2v_mux_ra : mux2x5
PORT MAP(sel => SYNTHESIZED_WIRE_37,
		 i0 => SYNTHESIZED_WIRE_38,
		 i1 => SYNTHESIZED_WIRE_39,
		 o => SYNTHESIZED_WIRE_20);


b2v_register_file_0 : register_file
PORT MAP(clk => clk,
		 wren => SYNTHESIZED_WIRE_40,
		 aa => I(31 DOWNTO 27),
		 ab => I(26 DOWNTO 22),
		 aw => SYNTHESIZED_WIRE_41,
		 wrdata => SYNTHESIZED_WIRE_42,
		 a => a,
		 b => SYNTHESIZED_WIRE_19);

D_addr(15 DOWNTO 0) <= alu_res(15 DOWNTO 0);

END bdf_type;