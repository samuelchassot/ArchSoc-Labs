.equ RAM, 0x1000 
main:
	addi 	t0, 	zero, 	1  	; t0 = 1
	addi 	t1, 	zero, 	2 	; t1 = 2
	add 	t2, 	t0, 	t1	; t2 = t0 + t1
	sub 	t3, 	t2, 	t0 	; t3 = t2 - t0
	stw 	t0, 	RAM(zero) 	; RAM[0] = t0
	ldw 	t4, 	RAM(zero) 	; t4 = RAM[0]
	add 	t5, 	t4, 	t0 	;t5 =t4 + t0
end:
	br end 
	nop
	nop