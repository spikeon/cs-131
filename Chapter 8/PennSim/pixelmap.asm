; File: 		pixelmap.asm
; Description:	Pixel Map Display Example
;
; Author:	Carl Reinwald
; Project:	CS 131 Chapter 8
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
;          as pixelmap.asm
;
;    c.  To load the pixelmap.obj file, select 
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
		.ORIG x3000
		LD R0,SIZE		; load counter with total number of pixels
		LD R1,PIXELMAP	; load start of pixel map
		AND R2,R2,#0	; R2 contains random color
	
LOOP	ADD R2,R2,R0	; create random pixel color (using pixel counter)
		STR R2,R1,#0	; store random value as color for pixel
		ADD R1,R1,#1	; increment pixel map pointer
		ADD R0,R0,#-1	; decrement pixel counter
		BRnp LOOP

		HALT

PIXELMAP	.FILL xC000	; starting memory-mapped location for pixel display
SIZE		.FILL x3E00	; 128 x 124 display
	.END