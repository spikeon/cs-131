; File: 	trapx26echo.asm
; Description:	Get Character and Echo using TRAP x26
;
	.ORIG x3000
	TRAP x26
	HALT
	.END