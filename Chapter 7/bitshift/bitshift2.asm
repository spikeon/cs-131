; File: 		bitshift2.asm
; Description:		Shift bit pattern to the left by n bits.
; Implementation:	RESULT = VALUE shifted by SHIFT
; VALUE is stored in x301A; SHIFT is stored in x301B; RESULT is stored in x301C
	.ORIG x3000
	LD R1,#25	; load R1 with VALUE (PC + 25 = x301A)
	LD R2,#25	; load R2 with SHIFT (PC + 25 = x301B)
	BRz DONE	; if shift amount = 0, goto store result
REPEAT	ADD R1,R1,R1	; shift pattern by one bit to the left
	ADD R2,R2,#-1	; decrement shift amount
	BRnp REPEAT	; if shift != 0, branch to shift again
DONE	ST R1,#21	; store shifted pattern in RESULT (PC+21 = x301C)
	HALT
	.END
