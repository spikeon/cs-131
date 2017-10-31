; File: 		bitshift5.asm
; Description:		Shift bit pattern to the left by n bits.
; Implementation:	RESULT = VALUE shifted by SHIFT
; VALUE is stored in x301A; SHIFT is stored in x301B; RESULT is stored in x301C
	.ORIG x3000
	LD R3,BASEADR	; load R3 with base memory address
	LDR R1,R3,#0	; load R1 with VALUE (R3 + 0 = x301A)
	LDR R2,R3,#1	; load R2 with SHIFT (R3 + 1 = x301B)
	BRz DONE	; if shift amount = 0, goto store result
REPEAT	ADD R1,R1,R1	; shift pattern by one bit to the left
	ADD R2,R2,#-1	; decrement shift amount
	BRnp REPEAT	; if shift != 0, branch to shift again
DONE	STR R1,R3,#2	; store shifted pattern in RESULT (R3 + 2 =x301C)
	HALT
BASEADR	.FILL	  x301A ; hardcode 3 data words starting at x301A:
			; +0=VALUE, +1=SHIFT, +2=RESULT
	.END
