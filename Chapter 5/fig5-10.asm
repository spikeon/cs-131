; File: 	fig5-10.asm
; Description:	Book Section 5.3.5 An Example
;      		Figure 5.10 Addressing Mode Example
;
	.ORIG x30F6
	LEA    R1, #-3  	; R1 <- PC - 3    
	ADD    R2, R1, #14    	; R2 <- R1 + 14 = x3102
	ST     R2, #-5     	; M[x30F4] <- R2
	AND    R2, R2, #0     	; R2 <- 0
	ADD    R2, R2, #5     	; R2 <- R2 + 5
	STR    R2, R1, #14    	; M[R1 + 14] <- R2
	LDI    R3, #-9     	; R3 <- M[M[x3F04]]
	HALT
	.END