; File: 		bitshift8.asm
; Description:		Shift bit pattern to the left by n bits.
; Implementation:	RESULT = VALUE shifted by SHIFT
	.ORIG x3000
START	LD R1,VALUE	; load R1 with VALUE
	LEA R0,PROMPT	; load prompt address into R0
	PUTS		; display prompt
	GETC		; get shift value from keyboard
	OUT		; echo shift value to display
	LD R2,ASCII	; load ASCII-to-int converter
	ADD R2,R0,R2	; convert saved ASCII to integer
	LD R0,LF	; load line feed character
	OUT		; display line feed
	ST R2,SHIFT	; store input SHIFT value in memory
	ADD R2,R2,#0	; must load R2 with same value to set CC
	BRz DONE	; if shift amount = 0, goto store result
REPEAT	ADD R1,R1,R1	; shift pattern by one bit to the left
	ADD R2,R2,#-1	; decrement shift amount
	BRnp REPEAT	; if shift != 0, branch to shift again
DONE	ST R1,RESULT	; store shifted pattern in RESULT
	BRnzp START	; prompt again
	HALT
VALUE	.FILL	  xABCD	; allocate and initialize test case
SHIFT	.BLKW	  1	; allocate
RESULT	.BLKW	  1	; allocate
ASCII	.FILL	  x-30	; ASCII-to-integer conversion (-48)
LF	.FILL	  #10	; line feed ASCII character
PROMPT	.STRINGZ  "Enter shift value: "
	.END
