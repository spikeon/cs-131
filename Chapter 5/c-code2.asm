; File: 	c-code2.asm
; Description:	Convert C Code into LC-3 Assembly
;
; Author:	Carl Reinwald
; Project:	CS 131 Chapter 5 C Code Example
; Date:		2017-03-29
;
; Details:
; C code:
;  int i;	// assign to data starting address     (x3011)
;  int j;	// assign to data starting address + 1 (x3012)
;  int *ptr;	// assign to data starting address + 2 (x3013)
;
;  i = 3;
;  j = i + 2;
;  ptr = &i;
;  j = *ptr;
;
; Register Usage:
;   R0 = temp
;   R1 = data starting address
;   R2 = temp, to show difference between LD and LDI
;
	.ORIG x3000
	LEA R1, #16	; assign R1 to data starting address (x3011)

	; set i to 3
	AND R0,R0,#0	; clear R0
	ADD R0,R0,#3	; set R0 to 3
	STR R0,R1,#0	; save R0 to i

	; execute j = i + 2
	LDR R0,R1,#0	; load R0 from i
	ADD R0,R0,#2	; add 2 to R0
	STR R0,R1,#1	; save R0 to j

	; assign ptr to address of i
	ST R1,#11	; save address of i to ptr

	; not needed, just to compare LD and LDI
	LD R2,#10	; load R2 from ptr

	; set j = *ptr
	LDI R0,#9 	; load R0 from M[M[PC+9]] (= M[ptr])
	ST R0,#7	; save R0 to j

	HALT
	.END
