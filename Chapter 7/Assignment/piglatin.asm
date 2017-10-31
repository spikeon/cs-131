; File: 	piglatin.asm
; Description:	Convert a word to piglatin
; 
; Author:	Mike Flynn, Cory Upham
; Project:	CS 131 Assignment 7
; Date: 	10/30/2017
; 
; Operational Conditions:
; 
; 
; 
; 
; 
; 
; 
; Resource Usage:
; 
; 
; 
; 
; 
; Notes:
;
; Pre-Allocate Input Buffer Using .BLKW (IMPORTANT)
; Input can be no more than 20 characters
; DO NOT USE R7
; 
; Algorithm
;
; 1: Display: "English Word: "
; 2: Get input from user and store as 0-19 until we receive the enter character (x0A)
; 3: Display: "Pig-Latin: "
; 4: Display characters between 1 and 19 while not null
; 5: Display character 0
; 6: Display characters "a" and "y"
; 7: Loop back to the beginning

; Code: 

	.ORIG x3000				; Start at x3000

PROMPT	.STRINGZ	"English Word: "	; Input Prompt
RESPON	.STRINGZ	"Pig-Latin: "		; Response Prefix
AFFIX	.STRINGZ	"ay"			; Response Affix
BUFF	.BLKW		20			; Allocate Buffer
	HALT					; End the Program
	.END					;