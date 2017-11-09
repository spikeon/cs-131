; File: 		pixelbox.asm
; Description:	Draw Pixel Box Example
;
; Author:	Carl Reinwald
; Project:	CS 131 Chapter 8 Example
; Date:		2016-04-16
;
; Notes:
;
; 1. THIS PROGRAM ONLY PRODUCES VISIBLE RESULTS
;    ON THE PENN STATE JAVA SIMULATOR (PennSim.jar).
;
; 2. One must first load the lc3os.obj file to
;    install the operating system.  Compile the
;    lc3os.asm file using the PennSim as follows:
;
;    a.  Copy the PennSim.jar and lc3os.asm files
;        into the same directory.
;
;    b.  Execute PennSim.jar.
;
;    c.  Click the mouse in the box just under
;        the Next button, a cursor should appear.
;
;    d.  In the box, type the following:
;
;           as lc3os.asm
;
;        This should generate an lc3os.obj file.
;
;    e.  To load the lc3os.obj file, select 
;        File->Open .obj File from the menu,
;        select the lc3os.obj file, and then
;        select the Open button.
;
;    If all went well, the bottom visible address
;    in the Memory window should be x0200 and
;    it should contain the "OS_START" label.
;
; 3. Now that the LC3 OS is loaded, assemble and
;    load this program using either the LC3Edit 
;    assembler or do the following:
;
;    a. Copy this file into the same directory as
;       the PennSim.jar file.
;
;    b. Enter the following in the box below
;       the Next button:
;
;          as pixelbox.asm
;
;    c.  To load the pixelbox.obj file, select 
;        File->Open .obj File from the menu,
;        select the pixel.obj file, and then
;        select the Open button.
;
; 4. Execute the program by selecting the
;    Continue button.  Although the PC starts
;    at x0200, the user code at x3000 will
;    be executed.
;
;
;  Memory-mapped pixels resides at memory xC000 - xFDFF:
;
;    xC000 - xC07F is first row of display
;    xC080 - xC0FF is second row of display
;    . . .
;    xFD80 - xFDFF is last row of display (row 124)

;  Color represented by a 16-bit value:
;    5 bits per red/green/blue
;    2^15 = 32768 distinct colors
;
;      [4:0]  = blue
;      [9:5]  = green
;     [14:10] = red
;      [15]   = ignored
;   
;    |15|14    10|9      5|4      0|
;    -------------------------------
;    |xx|   Red  |  Green |  Blue  |
;    -------------------------------
;
;  NOTE:  this code draws each horizontal lines from 
;         right to left (not left to right)
;
		.ORIG x3000
		LD R0,NUMLINE	; horizontal line counter
		LD R1,STADR		; starting address for first pixel
		LD R2,LINELEN	; number of pixels per drawn line
		LD R3,COLOR		; pixel color
		LD R4,HWIDTH	; number of pixels for each line on display
		; R5 temp register containing pixel memory location
		; R6 pixel counter (per horizontal line)
		
		; draw NUMLINE number of horizontal lines
		; where each line is LINELEN long
NEXTL	ADD R5,R1,R2	; initialize pixel memory location
		ADD R6,R2,#0	; initialize pixel counter
LLOOP	BRz LDONE
		ADD R6,R6,#-1	; decrement pixel counter
		ADD R5,R1,R6	; compute pixel location
		STR R3,R5,#0	; store color in pixel location
		ADD R6,R6,#0	; required to set CC again
		BRnp LLOOP

LDONE	ADD R1,R1,R4	; increment to start of next horizontal line
		ADD R0,R0,#-1	; decrement horizontal line counter	
		BRnp NEXTL
		
		HALT
		
NUMLINE	.FILL 10		; number of horizontal lines
STADR	.FILL xC000		; starting memory-mapped location for first line of box
COLOR	.FILL x03FF		; light blue (full green and full blue, no red)
;STADR	.FILL xDB38		; starting memory-mapped location for first line of box
;COLOR	.FILL x7C1F		; pink (full red and full blue, no green)
LINELEN	.FILL 20		; length of one horizontal length
HWIDTH	.FILL x80		; horizontal width (number of memory locations per horizontal line)

		.END