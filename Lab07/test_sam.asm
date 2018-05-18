add t0, zero, zero
nop
nop
nop
stw t0, 0x1200(zero)
nop
nop
nop
loop:
	ldw t0, 0x1200(zero)
	nop
	nop
	nop
	addi t0, t0, 1
	nop
	nop
	nop
	stw t0, 0x1200(zero)
	stw t0, 0x2000(zero)
	br loop
	nop
	nop
	nop