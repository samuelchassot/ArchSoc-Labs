	addi	t1, zero, 1
	addi	t2, zero, 2
	nop
	nop
	nop
	add		t1, t1, t2
	addi	t3, zero, 3
	nop
	nop
	nop
	beq		t3, t1, success
	nop
	nop
	br 		failure
	nop
	nop
	
success:
	addi	t0, zero, 31
	nop
	nop
	nop
	stw		t0, 0x2000(zero)
	br 		end
	nop
	nop
failure:
	addi	t0, zero, 1
	nop
	nop
	nop
	stw		t0,0x2000(zero)



end:
	br end 
	nop
	nop

