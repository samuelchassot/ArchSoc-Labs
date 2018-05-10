restart -f
force clk 0 0
force reset_n 0 0
force pc_addr 16#1234 0
force branch 0 0
force e_imm 16#1111 0
force a 16#2222 0
force d_imm 16#3333 0
force sel_imm 1 0
force sel_a 0 0
run 50
force reset_n 1 0
run 50
force clk 1 0
run 50
force clk 0 0
force sel_imm 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
force clk 1 0
run 50
force clk 0 0
run 50
