; =========================================================================================
; Pig Latin
; =========================================================================================
;
; File: 	piglatin.asm
; Description:	Convert user input to piglatin
; 
; Authors:	Mike Flynn, Cory Upham
; Project:	CS 131 Assignment 7
; Date: 	10/31/2017
; 
; -----------------------------------------------------------------------------------------
; Resource Usage:
; -----------------------------------------------------------------------------------------
; 
; R0: Output
; R1: Buffer Location
; R2: Blank
; R3: Loop Iterator
; R4: Newline Check
; 
; -----------------------------------------------------------------------------------------
; Notes
; -----------------------------------------------------------------------------------------
;
; - Pre-Allocate Input Buffer Using .BLKW (IMPORTANT)
; - Input can be no more than 20 characters
; - DO NOT USE R7
; 
; -----------------------------------------------------------------------------------------
; Algorithm
; -----------------------------------------------------------------------------------------
;
; 1 ) Display: "English Word: "
; 2 ) Get input from user and store as index 0-19 until we receive the enter character (x0A)
; 3 ) Display: "Pig-Latin: "
; 4 ) Display characters between index 1 and 19 while not null
; 5 ) Display character at index 0
; 6 ) Display "ay\n"
; 7 ) Loop back to the beginning
;
; -----------------------------------------------------------------------------------------
; Code
; -----------------------------------------------------------------------------------------

	.ORIG x3000				; Start at x3000
	AND R2, R2, #0				; Make sure R2 is empty

OUTERLOOP					; Start Outer Loop
	
	LEA R1, BUFF				; Load Buffer
	LEA R3, SIZE				; Load Size

RESET						; Clear the String in the Buffer

	STR R2, R1, #0 				; Empty location at R1
	ADD R1, R1, #1 				; Increment Location
	ADD R3, R3, #-1				; Decrement Size 
	BRzp RESET				; Loop 

	LEA R0, PROMPT				; Load Prompt ( English Word )
	PUTS					; Output Prompt

	LEA R1, BUFF				; Buffer has changed, Reload Buffer

INNER						; Loop to get input

	GETC					; Get Input
	PUTC					; Show the user what they typed
	ADD R4, R0, #-10			; Check for newline
	BRz INNEREND				; Escape if newline
	STR R0, R1, #0				; Store in buffer
	ADD R1, R1, #1				; Change buffer index
	BRnzp	INNER				; Loop

INNEREND					; Excape Hatch

	LEA R0, RESPON				; Load Response Prefix ( Pig-Latin: )
	PUTS					; Output Response Prefix

	LEA R0, BUFF				; Load Buffer into output
	ADD R0, R0, #1				; Change Buffer Index to 1
	PUTS					; Output rest of Buffer

	LEA R1, BUFF				; Load Buffer for modification
	LEA R3, SIZE				; Load Buffer Size
	ADD R1, R1, #1				; Change Buffer Index to 1
	ADD R3, R3, #-1				; Change Buffer Size to 19

CLEAN						; Begin Clean 

	STR R2, R1, #0 				; Empty location at R1
	ADD R1, R1, #1 				; Increment Location
	ADD R3, R3, #-1				; Decrement Size
	BRzp CLEAN				; Loop

CLEANEND

	LEA R0, BUFF				; Load Buffer Into Output
	PUTS					; Output Buffer

	LEA R0, AFFIX				; Load Response Affix ( ay\n )
	PUTS					; Output Response Affix

BRnzp	OUTERLOOP				; Begin Again
	
	HALT					; Stop my program

; -----------------------------------------------------------------------------------------
; Variables
; -----------------------------------------------------------------------------------------

SIZE	.FILL		20			; Buffer Size
PROMPT	.STRINGZ	"English Word: "	; Input Prompt
RESPON	.STRINGZ	"Pig-Latin: "		; Response Prefix
AFFIX	.STRINGZ	"ay\n"			; Response Affix
BUFF	.BLKW		20			; Buffer

	.END					; I'm done