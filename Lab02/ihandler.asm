.equ 	LEDS, 		0x2000
.equ	TIMER, 		0x2020
.equ	BUTTONS, 	0x2020


start: 
	br main


;Start interrupts_handler
interrupt_handler:
	addi	sp, sp, -16
	stw		s0, 12(sp)
	stw		t0, 8(sp)
	stw		t1, 4(sp)
	stw		t2, 0(sp)

	rdctl	ipending, s0
	andi	t1, s0, 1			;isolating timer interrupts
	addi	t2, zero, 1			;t2 = 1
	bne		t1, t2,  button_check
	call	timer_irs

button_check:
	andi	t1, s0, 4			;isolating button interrupts
	addi 	t2, zero, 4			;t2 = 4
	bne 	t1, t2, continue
	call	button_irs

continue:	
	ldw		s0, 12(sp)
	ldw		t0, 8(sp)
	ldw		t1, 4(sp)
	ldw		t2, 0(sp)
	addi	sp, sp, 16
	addi	ea, ea, -4
	eret
;End interrupts_handler

timer_irs:
;TODO
;increments second counter, resets the timer
	ret


button_irs:
;TODO
;incrementd/decrements third counter, reset edgecapture
	ret



	




main:
	addi	t0,	zero, 1
	wrctl	status, t0				;enabling interrupts
	addi 	t0, zero, 5				
	wrctl	ienable, t0				;enabling interrupts from Timer and buttons
	addi	t0, zero, 100
	stw		t0, TIMER + 8(zero)		;sets timer period to 100
	;TODO
	;implements 3 counters




