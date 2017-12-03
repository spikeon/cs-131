; File: 	twoscomp.asm
; Description:	Example of Two's Complement Subroutine (using both JSR and JSRR)
;
; Need to compute R3 = R1 - R2 and then R5 = R3 - R4
; Note: Caller should save R0 if we’ll need it later!
;
	.ORIG x3000
; Populate registers with test values
	LD	R1, R1value
	LD	R2, R2value
	LD	R4, R4value

; Perform R3 = R1 - R2 using JSR
	ADD	R0, R2, #0	; copy R2 to R0
	JSR	TwosComp	; take 2's comp
	ADD	R3, R1, R0	; add to R1

	NOP	; just to provide some visual space when viewing in simulator

; Perform R5 = R3 - R4 using JSRR
	ADD	R0, R4, #0	; copy R4 to R0
	LD	R6, TC_Adr	; load TwosComp address in R6
	JSRR	R6		; take 2's comp (TwosComp address is in R6)
	ADD	R5, R3, R0	; add to R3

;	...
	HALT
	NOP	; just to provide some visual space when viewing in simulator
;
; Pointer Table
;
TC_Adr	.FILL TwosComp	; create memory pointer to TwosComp

	NOP	; just to provide some visual space when viewing in simulator
;
; Two's Complement Subroutine
;
;  Input:   R0, contains value to be converted
;  Output:  R0, contains 2's complement of input value
;
TwosComp
	NOT	R0, R0	 	; flip bits
	ADD	R0, R0, #1	; add one
	RET			; return to caller

	NOP	; just to provide some visual space when viewing in simulator

R1value	.FILL #9
R2value	.FILL #2
R4value	.FILL #4
	.END
