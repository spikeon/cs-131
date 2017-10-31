; File: 		bitshift6.asm
; Description:		Shift bit pattern to the left by n bits.
; Implementation:	RESULT = VALUE shifted by SHIFT
	.ORIG x3000
	LD R1,VALUE	; load R1 with VALUE
	GETC		; get shift value from keyboard
	OUT		; echo shift value to display
	LD R2,ASCII	; load ASCII-to-int converter
	ADD R2,R0,R2	; convert ASCII to integer
	ST R2,SHIFT	; store input SHIFT value in memory
	BRz DONE	; if shift amount = 0, goto store result
REPEAT	ADD R1,R1,R1	; shift pattern by one bit to the left
	ADD R2,R2,#-1	; decrement shift amount
	BRnp REPEAT	; if shift != 0, branch to shift again
DONE	ST R1,RESULT	; store shifted pattern in RESULT
	HALT
VALUE	.FILL	  xABCD	; allocate and initialize test case
SHIFT	.BLKW	  1	; allocate
RESULT	.BLKW	  1	; allocate
ASCII	.FILL	  x-30	; ASCII-to-integer conversion (-48)
	.END
