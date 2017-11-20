; =========================================================================================
; Encryptor
; =========================================================================================
;
; File: 	encryptor.asm
; Description:	Encrypt or Decrypt String
; 
; Authors:	Mike Flynn, Cory Upham, Jose Carlos Sagrero
; Project:	CS 131 Assignment 8
; Date: 	11/20/2017
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
; 12) Loop forever
;
; -----------------------------------------------------------------------------------------
; Code
; -----------------------------------------------------------------------------------------

	.ORIG x3000				
MAIN						
; Make sure R2 is zero

	AND R2, R2, #0				

; Reset Buffer

	LEA R1, BUFFER				
	LD R3, SIZE					
RESET						
	STR R2, R1, #0 				
	ADD R1, R1, #1 				
	ADD R3, R3, #-1				
	BRp RESET 
	BRnzp USERINPUTA

; Get Encrypt or Decrypt, store for later

USERINPUTA					
	LEA R0, PROMPTA				
	PUTS					
	GETC					
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

; Get Key, store for later

USERINPUTB					
	LEA R0, PROMPTB				
	PUTS					
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

; Get string

USERINPUTC					
	LEA R0, PROMPTC				
	PUTS					
	LEA R1, BUFFER				
	AND R5, R5, #0				

USERINPUTCI

	GETC					
	ADD R4, R0, #-10			
	BRz RESPONSE				 
						
	ADD R4, R0, #-8				
	BRz USERINPUTCI				 
	ADD R4, R5, #-10			
	ADD R4, R4, #-10			
	BRzp USERINPUTCI

	LD R4, MIN
	NOT R4, R4
	ADD R4, R4, 1
	ADD R4, R0, R4
	BRn USERINPUTCI

	LD R4, MAX
	NOT R4, R4
	ADD R4, R4, 1
	ADD R4, R0, R4
	BRp USERINPUTCI
	

	PUTC					
	STR R0, R1, #0				
	ADD R1, R1, #1				
	ADD R5, R5, #1				
	BRnzp USERINPUTCI				

; Begin Response

RESPONSE					
	STR R2, R1, #0
	PUTC					
	LEA R0, RESPON				
	PUTS					

	LEA R1, BUFFER
CRYPTO
	; Load next character, if null we're done
	LDR R0, R1, #0 
	BRz FIN
	
DOACTION
	; Load Encrypt or Decrypt
	LD R4, ACTION
	BRn ECRYPTO
	BRp DCRYPTO
	BRz MAIN ; ERROR
DCRYPTO
	; Do Decrypt
	LD R3, KEY
	NOT R3, R3
	ADD R3, R3, #1
	ADD R0, R0, R3

	AND R2, R0, X0001
	BRp DODD
	BRz DEVEN
DODD	ADD R0, R0, #-1
	BRnzp DENDFLIP
DEVEN	ADD R0, R0, #1
DENDFLIP

	BRnzp ENDCRYPTO
ECRYPTO
	; Do Encrypt
	AND R2, R0, X0001
	BRp EODD
	BRz EEVEN
EODD	ADD R0, R0, #-1
	BRnzp EENDFLIP
EEVEN	ADD R0, R0, #1
EENDFLIP
	LD R3, KEY
	ADD R0, R0, R3
	BRnzp ENDCRYPTO
ENDCRYPTO
	STR R0, R1, #0 
	ADD R1, R1, #1
	BRnzp CRYPTO
FIN		
	LEA R0, BUFFER
	PUTS

; Loop Forever

BRnzp	MAIN					

	HALT

; -----------------------------------------------------------------------------------------
; Variables
; -----------------------------------------------------------------------------------------
PROMPTA	.STRINGZ	"\nEnter E)ncrypt or D)ecrypt\n"	; Input Prompt
PROMPTC	.STRINGZ	"\nEnter Message (<20 char, press <ENTER> when done)\n"
PROMPTB .STRINGZ	"\nEnter Encryption Key (1-9)\n"
ACTION	.FILL		x0000			; 1 if encrypt, -1 if decrypt, 0 if not set
KEY	.FILL		x0000			; Encryption Key, 0 if not set, positive if set

MIN	.FILL		x0020
MAX	.FILL		x0060

; MINEKEY	.FILL		x0040



RESPON	.STRINGZ	"\nResult: "		; Response Prefix
SIZE	.FILL		20			; Buffer Size
BUFFER	.BLKW		21			; Input Buffer
	.END					; I'm done
