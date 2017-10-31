; File: 	helloworld.asm
; Description:	Hello World Example
;
; Author:	Carl Reinwald
; Project:	CS 131 Chapter 7 Example
; Date:		2016-4-16
;
; Code is NOT commented on purpose.
; Recommend using the simulator to observe what is in
; memory starting at the INBUF address after the program
; has executed.  Pay particular attention to exactly what
; has been written into memory and what has NOT been 
; written into memory.
;
	.ORIG x3000
	LEA R0,HELLO
	PUTS
	LEA R0,PROMPT
	PUTS
	LD R0,NEWLINE
	OUT

	LEA R1,INBUF
LOOP	GETC
	OUT
	ADD R2,R0,#-10
	BRz DONE

	STR R0,R1,#0
	ADD R1,R1,#1
	BRnzp LOOP

DONE 	LEA R0,INBUFPR
	PUTS

	; Output INBUF
	; As coded, there is something wrong with what is being 
	; displayed (you see more than just the input string).
	; One should implement code to fix this assumption.
	; NOTE:  the fix is not to change the ".BLKW #100,x20" to
	; ".BLKW #100" or ".BLKW #100,#0".
	;
	; Hint question:  why is "Hello World!" being displayed
	; but not "Each key entered.."?
	;
	LEA R0,INBUF
	PUTS
	HALT

INBUF	.BLKW #100,x20
NEWLINE	.FILL x0A
HELLO	.STRINGZ "Hello World!\n"
PROMPT	.STRINGZ "Each key entered will be echoed to the display, press ENTER when done"
INBUFPR	.STRINGZ "INBUF contains:\n"

	.END