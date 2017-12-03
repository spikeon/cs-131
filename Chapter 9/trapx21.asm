; File: 	trap21.asm
; Description:	LC-3 character output service routine (fig 9.5)
;
; Wait for Display Status Register to be ready for output.
; Write character to Display Data Register.
;
; Install service routine at address x21.
;
		.ORIG x0430		; system call starting address
		ST	R7, SaveR7	; save R7 & R1
		ST	R1, SaveR1	; R1 used for DSR polling
; Write character
TryWrite	LDI	R1, DSR		; get status
		BRzp	TryWrite	; look for bit 15, (display is ready)
WriteIt		STI	R0, DDR		; write character
; Return from TRAP
Return		LD	R1, SaveR1	; restore R1 & R7
		LD	R7, SaveR7
		RET			; return from trap (JMP R7)
DSR		.FILL	xFE04		; address of Display Status Register
DDR		.FILL	xFE06		; address of Display Data Register
SaveR1		.FILL	0
SaveR7		.FILL	0
		.END
