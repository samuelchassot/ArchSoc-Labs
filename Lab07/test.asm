.equ    LEDs, 0x2000




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
	ldw		t0, font_data(zero)
	nop
	nop
	nop
	stw		t0, LEDs(zero)
	br 		end
	nop
	nop
failure:
	ldw		t0, font_data+4(zero)
	nop
	nop
	nop
	stw		t0, LEDs(zero)



end:
	br end 
	nop
	nop





font_data:
    .word 0x7E427E00 ; 0
    .word 0x407E4400 ; 1
    .word 0x4E4A7A00 ; 2
    .word 0x7E4A4200 ; 3
    .word 0x7E080E00 ; 4
    .word 0x7A4A4E00 ; 5
    .word 0x7A4A7E00 ; 6
    .word 0x7E020600 ; 7
    .word 0x7E4A7E00 ; 8
    .word 0x7E4A4E00 ; 9
    .word 0x7E127E00 ; A
    .word 0x344A7E00 ; B
    .word 0x42423C00 ; C
    .word 0x3C427E00 ; D
    .word 0x424A7E00 ; E
    .word 0x020A7E00 ; F