; File:		bitshift.asm
; Author:	Mike Flynn
; Description:	Shift a bit pattern to the left

; Add the value to itself x number of times, where x is the number of times to shift

; Register Usage
;	R0 = temp
;	R1 = Bit Value Location
;	R2 = Shift Value Location
;	R3 = Result Location
;	R4 = Counter

	.ORIG x3000	; Start at x3000

	LEA R1, #25	; Bit Value Location
	LEA R2, #25	; Shift Value Location
	LEA R3, #25	; Result Location

	LDR R0,R1,#0	; Load Bit Value to R0
	LDR R4,R2,#0	; Load Counter
	
	BRz 3
	ADD R0,R0,R0	; Add R0 to R0 and store in R0
	ADD R4,R4,#-1	; Decrease Counter
	BRnzp -4
	
	STR R0,R3,#0

	HALT
	.END