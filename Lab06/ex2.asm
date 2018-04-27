main: 
	addi	a0,	zero,	data	; a0: Array memory address
	addi 	a1,	zero,	2		; a1 : Number of elements
	call proc
	nop
	nop

end:
	br	end
	nop
	nop

proc:
	add 	v0,	zero,	zero	;v0 = 0
	add 	t0,	zero,	zero	;t0 = 0
proc_outer:
	bge		t0, a1, proc_return	; if (t0 >= a1 ) goto return
	nop
	nop
	ldw		t3, 0(a0)			; t3 = mem[a0]
	addi	t4, zero,	32		; t4 =32
proc_inner:
	beq		t4,	zero,	proc_next ;if (!t4) goto next
	nop
	nop
	andi	t1,	t3,	1			;t1 = t3 & 1
	add 	v0,	v0,	t1			;v0 = v0 + t1
	srli 	t3,	t3,	1			;t3 = t3 >> 1
	addi	t4,	t4,	-1			; t4 = t4 -1
	br		proc_inner			;goto inner
	nop
	nop
proc_next:
	addi	t0,	t0,	1			;t0 = t0 + 1
	addi 	a0,	a0,	4			;a0 = a0 + 4
	br		proc_outer			;goto outer
	nop
	nop
proc_return:
	ret 						;return to caller
	nop
	nop	

data:
	.word 0x080A0103
	.word 0x0F0F0F0F