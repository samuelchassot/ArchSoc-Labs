.equ 	LEDS, 		0x2000
.equ	TIMER, 		0x2020
.equ	BUTTONS, 	0x2030
.equ	RAM,		0x1000


start: 
	br main

;------------------------------------------------------------------------------
;Start interrupts_handler
interrupt_handler:
	addi	sp, sp, -20
	stw		s0, 16(sp)
	stw		t0, 12(sp)
	stw		t1, 8(sp)
	stw		t2, 4(sp)
	stw 	t3, 0(sp)

;look if the timer request an interrupt
timer_check:
	rdctl	s0, ipending
	andi	t1, s0, 1			;isolating timer interrupts
	addi	t2, zero, 1			;t2 = 1
	bne		t1, t2,  button_check
	call	timer_irs

;look if the button request an interrupt
button_check:
	andi	t1, s0, 4			;isolating button interrupts
	addi 	t2, zero, 4			;t2 = 4
	bne 	t1, t2, continue
	call	button_irs

continue:	
	ldw		s0, 16(sp)
	ldw		t0, 12(sp)
	ldw		t1, 8(sp)
	ldw		t2, 4(sp)
	ldw		t3, 0(sp)
	addi	sp, sp, 20
	addi	ea, ea, -4
	eret
;End interrupts_handler
;------------------------------------------------------------------------------

; increments second counter, resets the timer (set TO bit to 0 to ACK the IRQ and reset the timer)
timer_irs:
	ldw 	t0, LEDS+4(zero)		; load the second count in t0
	addi	t0, t0, 1			; increment the second timer
	stw		t0, LEDS+4(zero)		; write back the second counter in memory
	stw		zero, TIMER(zero)	; write 0 in the status register (add = 0) in the TIMER to ACK the IRQ and reset it 
	ret	
	

;increments/decrements third counter, set edgecapture to 0
button_irs:
	ldw		t3, BUTTONS+4(zero)	; t3 = edgecapture register
	ldw		t0, LEDS+8(zero)		; loads third counter in t0
	andi	t2, t3, 1			; isolate in t2 the edgecapture for button 0
	addi	t1, zero, 1
	bne 	t2, t1, decr_test
	addi 	t0, t0, 1			; increments counter if button 0 is pressed

decr_test:
	andi 	t2, t3, 2			;isolate in t2 the edgecapture for button 1
	addi	t1, zero, 2
	bne 	t2, t1, end_b_irs
	addi 	t0, t0, -1			;decrements counter if button 1 is pressed

end_b_irs:
	stw		zero, BUTTONS+4(zero) ; resets edgecapture
	stw		t0, LEDS+8(zero)		;store the third counter
	ret



	



;------------------------------------------------------------------------------
main:
	addi 	sp, zero, 0xFF
	slli 	sp, sp, 8
	addi 	sp, sp, 0xFF
	addi	t0,	zero, 1
	wrctl	status, t0				;enabling interrupts
	addi 	t0, zero, 5				
	wrctl	ienable, t0				;enabling interrupts from Timer and buttons
	addi	t0, zero, 100
	stw		t0, TIMER + 8(zero)		;sets timer period to 100
	addi	t0, zero, 7
	stw 	t0, TIMER+4(zero)		;start the timer and set continue

	stw		zero, LEDS(zero)			;initialize counters
	stw		zero, LEDS+4(zero)
	stw		zero, LEDS+8(zero)

loop:
	ldw		t0, LEDS(zero)
	addi	t0, t0, 1
	stw		t0, LEDS(zero)
	br loop
	;implements 3 counters




