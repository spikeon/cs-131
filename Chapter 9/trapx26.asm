; File: 	trapx26.asm
; Description:	Get Character and Echo TRAP
;
; Get character input console.
; Display character on console.
; Return character in R0.
;
	.ORIG x600	; must match TRAPX26 in trapx26install.asm
	
	ST R7,X26_R7
	GETC
	OUT
	LD R7,X26_R7
	RET

X26_R7	.BLKW 1		; Saved R7
	.END