	.ORIG x3000
START	LDI	R1, KBSR  ; Test for character input  
	BRzp	START				       
	LDI	R0, KBDR				       
ECHO	LDI	R1, DSR	  ; Test output register ready
	BRzp	ECHO				       
	STI	R0, DDR				       
	BRnzp	NEXT       
KBSR	.FILL	xFE00	; Address of KBSR	       
KBDR	.FILL	xFE02	; Address of KBDR	       
DSR	.FILL	xFE04	; Address of DSR	       
DDR	.FILL	xFE06	; Address of DDR             

NEXT	GETC		; use trap x20 to get keyboard character
	OUT		; use trap x21 to display character
	HALT
	.END