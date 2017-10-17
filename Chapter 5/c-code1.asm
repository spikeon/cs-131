; File: 	c-code1.asm
; Description:	Convert C Code into LC-3 Assembly
;
; Author:	Carl Reinwald
; Project:	CS 131 Chapter 5 C Code Example
; Date:		2017-03-12
;
; Details:
; C code:
;  int i;	// assign to data starting address     (x301C)
;  int j;	// assign to data starting address + 1 (x301D)
;
;  i = 3;
;  j = i + 2;
;
; Note:  Must manually assign R1 to data starting address (x301C)
;        prior to executing code.
;
; Register Usage:
;   R0 = temp
;   R1 = data starting address
;
	.ORIG x3000

	; set i to 3
	AND R0,R0,#0	; clear R0
	ADD R0,R0,#3	; set R0 to 3
	STR R0,R1,#0	; save R0 to i

	; execute j = i + 2
	LDR R0,R1,#0	; set R0 to i
	ADD R0,R0,#2	; increment R0 by 2
	STR R0,R1,#1	; save R0 to j

	HALT
	.END
