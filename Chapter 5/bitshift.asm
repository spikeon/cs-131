; File:		bitshift.asm
; Description:	Shift a bit pattern to the left by n bits
;
; Author:	Mike Flynn
; Project	CS 131 Assignment 5
; Date:		10/23/2017
; 
; Operational Conditions:
; 
; 	x301A : Starting Bit Pattern
; 	x301B : Left Shift Value
; 	x301C : Result
; 
; 	The shift value may be any number between 0 and 16 inclusive.
; 	Note: No range checking is performed on the shift value
; 
; Resource Usage:
;
;	R0 : temp
;	R1 : Bit Value Location
;	R2 : Shift Value Location
;	R3 : Result Location
;	R4 : Counter

	.ORIG x3000	; Start at x3000

	LEA R1, #25	; Bit Value Location
	LEA R2, #25	; Shift Value Location
	LEA R3, #25	; Result Location

	LDR R0,R1,#0	; Load Bit Value to R0
	LDR R4,R2,#0	; Load Counter
			
			; Start Loop
	BRz 3		; Skip next three lines when counter reaches zero
	ADD R0,R0,R0	; Add R0 to R0 and store in R0
	ADD R4,R4,#-1	; Decrease Counter
	BRnzp -4	; Return to beginning of loop
	
	STR R0,R3,#0	; Store the value in R0 into the location at R3

	HALT		; End the program
	.END