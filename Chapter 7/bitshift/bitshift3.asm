; File: 		bitshift3.asm
; Description:		Shift bit pattern to the left by n bits.
; Implementation:	RESULT = VALUE shifted by SHIFT
	.ORIG x3000
	LD R1,VALUE	; load R1 with VALUE
	LD R2,SHIFT	; load R2 with SHIFT
	BRz DONE	; if shift amount = 0, goto store result
REPEAT	ADD R1,R1,R1	; shift pattern by one bit to the left
	ADD R2,R2,#-1	; decrement shift amount
	BRnp REPEAT	; if shift != 0, branch to shift again
DONE	ST R1,RESULT	; store shifted pattern in RESULT
	HALT
VALUE	.FILL	  xABCD	; allocate and initialize test case
SHIFT	.FILL	  4	; allocate and initialize test case
RESULT	.BLKW	  1	; allocate
	.END