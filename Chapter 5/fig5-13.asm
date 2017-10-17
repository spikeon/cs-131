; File: 	fig5-13.asm
; Description:	Adds 12 numbers stored consecutively in memory
;
; Author:	Carl Reinwald
; Project:	CS 131 Chapter 5 Figure 5-13
; Version:	0.1
; Date:		2015-10-02
;
; Log:		
;	V0.1  2015-10-02
;	Initial Release
;
; Operating Conditions:
;	The 12 consecutive memory locations reside at x100 above
;	the code's origin (e.g., for .ORIG x3000, the first
;	number must be stored in location x3100).
;
;	file "fig5-13data.hex" may be used as an example data file
;
; Details:
;
;	R1:  Pointer to data value in memory
;	R2:  Count-down counter
;	R3:  Running total
;	R4:  Temp register for data value from memory
;
	.ORIG x3000
	LEA R1,xFF	; R1 <- PC + xFF (x3100)
	AND R3,R3,0 	; clear R3, used for the running sum
	AND R2,R2,0 	; clear R2, used as count-down counter
	ADD R2,R2,12 	; load R2 with #12, the number of times to add
	BRz 5		; if R2 = 0, goto PC + 5 (x300A)
	LDR R4,R1,0	; load next value from memory into R4
	ADD R3,R3,R4	; add R4 to R3 (R3 is running total)
	ADD R1,R1,1	; increment R1 (pointer to next memory location)
	ADD R2,R2,-1	; decrement R2 (counter)
	BRnzp -6	; unconditional branch to PC - 6 (x3004)
	HALT
	.END
