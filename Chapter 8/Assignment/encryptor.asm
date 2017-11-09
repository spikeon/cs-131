; =========================================================================================
; Encryptor
; =========================================================================================
;
; File: 	encryptor.asm
; Description:	Encrypt or Decrypt String
; 
; Authors:	Mike Flynn, Cory Upham, Jose Carlos Sagrero
; Project:	CS 131 Assignment 8
; Date: 	11/08/2017
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
; R6: 
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
; 1 ) Prompt "Enter E)ncrypt or D)ecrypt"
; 2 ) Get Encrypt or Decrypt
; 3 ) Loop if not E or D (Minus 68, if zero Encrypt, Minus 1, If zero Decrypt, else loop)
; 4 ) Prompt "Enter Encryption Key (1-9)"
; 5 ) Get Key
; 6 ) If not 1-9, loop
; 7 ) Convert Key from ASCII to Int (Minus 48, if negative loop, minus 10, if positive or zero loop, plus 10 store)
; 8 ) Prompt "Enter Message (<20 char, press <ENTER> when done)"
; 9 ) Get input from user and store as index 0-19 until we receive the enter character (x0A)
; 10) Encrypt or Decrypt
; 11) Display Result
; 12) Loop back to the beginning
;
; -----------------------------------------------------------------------------------------
; Code
; -----------------------------------------------------------------------------------------

	.ORIG x3000				; Begin Program at x3000
	AND R2, R2, #0				; Make absolutely sure R2 is empty


MAIN						; Load Values	
	LEA R1, BUFFER				; - Load Buffer
	LD R3, SIZE				; - Load Size
	
RESET						; Reset Buffer
	STR R2, R1, #0 				; - Set current location to null
	ADD R1, R1, #1 				; - Increment location
	ADD R3, R3, #-1				; - Decrement size 
	BRp RESET 
						; Display Prompt

	BRnzp USERINPUTA

PROMPTA	.STRINGZ	"\nEnter E)ncrypt or D)ecrypt"	; Input Prompt

USERINPUTA					
	LEA R0, PROMPTA				; - Load Prompt 
	PUTS					; - Output Prompt

	GETC					; - Load character from keyboard
	PUTC
	ADD R4, R0, #-10			
	ADD R4, R4, #-10			
	ADD R4, R4, #-10			
	ADD R4, R4, #-10			
	ADD R4, R4, #-10			
	ADD R4, R4, #-10			
	ADD R4, R4, #-8			
	BRz ENCRYPT
	ADD R4, R4, #-1
	BRz DECRYPT
	BRnp USERINPUTA			
ENCRYPT
	AND R0, R0, #0
	ADD R0, R0, #1
	LEA R1, ACTION
	STR R0, R1, #0				 
	BRnzp USERINPUTB
DECRYPT
	AND R0, R0, #0
	ADD R0, R0, #-1
	LEA R1, ACTION
	STR R0, R1, #0				 
	BRnzp USERINPUTB

PROMPTB .STRINGZ	"\nEnter Encryption Key (1-9)"
ACTION	.FILL		x0000			; 1 if encrypt, -1 if decrypt, 0 if not set
KEY	.FILL		x0000			; Encryption Key, 0 if not set, positive if set

USERINPUTB					
	LEA R0, PROMPTB				; - Load Prompt 
	PUTS					; - Output Prompt
	GETC
	PUTC
	ADD R4, R0, #-10
	ADD R4, R4, #-10
	ADD R4, R4, #-10
	ADD R4, R4, #-10
	ADD R4, R4, #-8
	BRnz USERINPUTB
	ADD R4, R4, #-10
	BRzp USERINPUTB
	ADD R4, R4, #10
	LEA R1, KEY
	STR R4, R1, #0

	BRnzp USERINPUTC

PROMPTC	.STRINGZ	"\nEnter Message (<20 char, press <ENTER> when done)"

USERINPUTC					
	LEA R0, PROMPTC				; - Load Prompt 
	PUTS					; - Output Prompt
	LEA R1, BUFFER				
	AND R5, R5, #0				; - Set Character Counter to zero

USERINPUTCI
						; Get User Input

	GETC					; - Load character from keyboard
	ADD R4, R0, #-10			; - Excape loop on newline
	BRz RESPONSE				 
						; - Validate Input
	ADD R4, R0, #-8				; -- Ignore backspace
	BRz USERINPUTCI				 
	ADD R4, R5, #-10			; -- Only allow 20 characters
	ADD R4, R4, #-10			
	BRzp USERINPUTCI
	PUTC					; - Display value on the screen
	STR R0, R1, #0				; - Store character in buffer
	ADD R1, R1, #1				; - Increment buffer index
	ADD R5, R5, #1				; - Increment Character Counter
	BRnzp USERINPUTCI				

RESPONSE					; Display Response Prefix
	PUTC					; - Display Last Character ( always enter )
	LEA R0, RESPON				; - Load Response Prefix
	PUTS					; - Output Response Prefix

	LEA R1, BUFFER
CRYPTO
	LDR R0, R1, #0 ; Not working
	BRz FIN
	LD R3, KEY
	LD R4, ACTION

	; Flip the bit
	
	; If bit is odd, minus 1
	; If bit is even, add 1

	BRn DCRYPTO
	BRp ECRYPTO
	BRz MAIN ; ERROR
DCRYPTO
	; Subtract Key
	BRnzp ENDCRYPTO
ECRYPTO
	; Add Key
	BRnzp ENDCRYPTO
ENDCRYPTO
	STR R0, R1, #0 
	ADD R1, R1, #1
	BRnzp CRYPTO
FIN		

	PUTS

BRnzp	MAIN					

	HALT

; -----------------------------------------------------------------------------------------
; Variables
; -----------------------------------------------------------------------------------------
RESPON	.STRINGZ	"Result: "		; Response Prefix
SIZE	.FILL		20			; Buffer Size
BUFFER	.BLKW		21			; Input Buffer
	.END					; I'm done
