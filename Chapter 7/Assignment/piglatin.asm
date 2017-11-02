; =========================================================================================
; Pig Latin
; =========================================================================================
;
; File: 	piglatin.asm
; Description:	Convert user input to piglatin
; 
; Authors:	Mike Flynn, Cory Upham, Jose Carlos Sagrero
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
; R5: Character Counter
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

	.ORIG x3000				; Begin Program at x3000
	AND R2, R2, #0				; Make absolutely sure R2 is empty

MAIN						; Load Values	
	LEA R1, BUFFER				; - Load Buffer
	LEA R3, SIZE				; - Load Size

RESET						; Reset Buffer
	STR R2, R1, #0 				; - Set current location to null
	ADD R1, R1, #1 				; - Increment location
	ADD R3, R3, #-1				; - Decrement size 
	BRzp RESET 
						; Display Prompt
	LEA R0, PROMPT				; - Load Prompt 
	PUTS					; - Output Prompt
	LEA R1, BUFFER				
						; Get User Input
	AND R5, R5, #0				; - Set Character Counter to zero
USERINPUT					
	GETC					; - Load character from keyboard
	ADD R4, R0, #-10			; - Excape loop on newline
	BRz RESPONSE				 
						; - Validate Input
	ADD R4, R0, #-8				; -- Ignore backspace
	BRz USERINPUT				 
	ADD R4, R5, #-10			; -- Only allow 20 characters
	ADD R4, R4, #-10			
	BRzp USERINPUT
	PUTC					; - Display value on the screen
	STR R0, R1, #0				; - Store character in buffer
	ADD R1, R1, #1				; - Increment buffer index
	ADD R5, R5, #1				; - Increment Character Counter
	BRnzp USERINPUT				
RESPONSE					; Display Response Prefix
	PUTC					; - Display Last Character ( always enter )
	LEA R0, RESPON				; - Load Response Prefix
	PUTS					; - Output Response Prefix

						; Display all but the first character
	LEA R0, BUFFER				; - Load Buffer into output
	ADD R0, R0, #1				; - Change Buffer Index to 1
	PUTS					; - Output rest of Buffer

						; Forget all but the first character
	LEA R1, BUFFER				; - Load Buffer for modification
	STR R2, R1, #1 				; - Set Second Character to 0

						; Display the first character
	LEA R0, BUFFER				; - Load Buffer Into Output Register
	PUTS					; - Output Buffer

						; Display Response Affix
	LEA R0, AFFIX				; - Load Response Affix
	PUTS					; - Output Response Affix

BRnzp	MAIN					

	HALT

; -----------------------------------------------------------------------------------------
; Variables
; -----------------------------------------------------------------------------------------

PROMPT	.STRINGZ	"English Word: "	; Input Prompt
RESPON	.STRINGZ	"Pig-Latin: "		; Response Prefix
AFFIX	.STRINGZ	"ay\n"			; Response Affix

SIZE	.FILL		20			; Buffer Size
BUFFER	.BLKW		20			; Input Buffer

	.END					; I'm done