; File: 	trapex.asm
; Description:	See book Example 9.1
;
; Converts any upper case character to lower case.
; Program prompts for input character, converts character to lower case, and
; repeats until the number 7 is entered.
;
		.ORIG x3000
		LD	R2, TERM	; Load negative ASCII ‘7’ (7 is the sentinel)
		LD	R3, ASCII	; Load ASCII difference
AGAIN		TRAP	 x23		; input character
		ADD	R1, R2, R0	; Test for termination character (the sentinel)
		BRz	EXIT		; Exit if done
		ADD	R0, R0, R3	; Change to lowercase
		TRAP	 x21		; Output to monitor...
		BRnzp  AGAIN		; ... again and again...
TERM		.FILL	 xFFC9		; xFFC9 is -‘7’ (7 is ASCII code x55)
ASCII		.FILL	 x0020	 	; lowercase bit
EXIT		TRAP	 x25		; halt
		.END

