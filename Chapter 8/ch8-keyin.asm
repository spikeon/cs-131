; keyboard read
	.ORIG x3000
POLL	LDI	R0,KBSR		; Load value from KBSR
	BRzp	POLL		; If MSB is no set in KBSR, poll
	LDI	R0,KBDR		; Load value from KBDR
	HALT
KBSR	.FILL	xFE00	; Address of KBSR	       
KBDR	.FILL	xFE02	; Address of KBDR
	.END