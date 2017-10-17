; File: 	fig5-15.asm
; Description:	Adds numbers stored consecutively in memory using sentinel
;
; Author:	Carl Reinwald
; Project:	CS 131 Chapter 5 Figure 5-15
; Version:	0.1
; Date:		2015-10-10
;
; Log:		
;	V0.1  2015-10-10
;	Initial Release
;
; Operating Conditions:
;	The consecutive memory locations reside at x100 above
;	the code's origin (e.g., for .ORIG x3000, the first
;	number must be stored in location x3100).
;
;	The sentinel is 0.
;
;	file "fig5-15data.hex" may be used as an example data file
;
; Details:
;
;	R1:  Pointer to data value in memory
;	R3:  Running total
;	R4:  Temp register for data value from memory
;
	.ORIG x3000
	LEA R1,xFF	; R1 <- PC + xFF (x3100)
	AND R3,R3,0 	; clear R3, used for the running sum
	LDR R4,R1,0	; load next value from memory into R4
	BRz 4		; if number = 0 (sentinel), goto PC + 4 (x3008)
	ADD R3,R3,R4	; add number to running sum
	ADD R1,R1,1	; increment pointer to next memory location
	LDR R4,R1,0	; load next value from memory into
	BRnzp -5	; unconditional branch to PC - 5 (x3003)
	HALT
	.END
