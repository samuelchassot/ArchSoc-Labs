.equ 	LEDS, 		0x2000
.equ	TIMER, 		0x2020
.equ	BUTTONS, 	0x2030
.equ	RAM,		0x1000


start: 
	br main


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
	rdctl	ipending, s0
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

timer_irs:
	ldw 	t0, RAM+4(zero)		; load the second count in t0
	addi	t0, t0, 1			; increment the second timer
	stw		t0, RAM+4(zero)		; write back the second counter in memory
	stw		zero, TIMER(zero)	; write 0 in the status register (add = 0) in the TIMER to ACK the IRQ and reset it 
	ret	
; increments second counter, resets the timer (set TO bit to 0 to ACK the IRQ and reset the timer)
	


button_irs:
	ldw		t3, BUTTONS+4(zero)	; t3 = edgecapture register
	andi	t2, t3, 1			;isolate in t2 the edgecapture for button 0 
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




