;-----------------------------------------------------------------
; File:             tictactoe.asm
; Description:      Tic-Tac-Toe game
; Date:             2017-05-08
;
; Original Author:  Yale Patt, EE 306,
;                   University of Texas at Austin 11/26/02
;
; Update Author:    Carl Reinwald, CS 131,
;                   Hancock College, Santa Maria, CA
;
; Student Authors:  Mike Flynn, Cory Upham, Jose Carlos Sagrero
;		    Hancock College, Santa Maria, CA 11/27/2017
;
;
; Changes from original:
;
;  1.  Added INITBOARD subroutine to reinitialize square table and 
;      player so program can be run more than once by simply
;      resetting the PC to x3000.
;  2.  Included some addition helper code to simplify assignment.
;
;
; ASSIGNMENT:  SEARCH FOR "***" AND ADD REQUIRED CODE TO 
;              COMPLETE PROGRAM.
;
; NOTE:  After HALT (TRAP x25) is executed, if you run the program
;        without reseting the PC to x3000, the memory will get 
;        corrupted.  One symptom of corrupted memory is funny
;        characters on the displayed tic-tac-toe table. Just
;        reinitialize the machine (File->Reinitialize Machine)
;        and reload the tictactoe.obj file to recover.
;
;-----------------------------------------------------------------
; Main Program
;-----------------------------------------------------------------
 		.ORIG x3000
MAIN		LEA 	R0, WELCOME
		TRAP 	x22
		LD	R0, NEWLINE
		TRAP 	x21
		LD	R2, INITBOARD_ADDR
		JSRR	R2
		LD	R2, DRAWBOARD_ADDR
		JSRR 	R2
		LD	R2, EVALBOARD_ADDR
		JSRR 	R2
;-----------------------------------------------------------------
; After EVALBOARD, R1 contains an exit code
; 0 = Keep Playing
; 1 = X wins
; 2 = O wins
; 3 = Cat Game
;-----------------------------------------------------------------
CHECK		ADD	R1, R1, #0	; Load condition codes
		BRp	GAMEOVER
MOVE		LD	R2, GETVALIDINPUT_ADDR
		JSRR	R2		
;-----------------------------------------------------------------
; After GETVALIDINPUT, R1 contains valid input char
;-----------------------------------------------------------------
		LD	R0, NEG_ASCII_x	
		ADD	R0, R0, R1	
		BRz	FINALMESSAGE	; User opted to exit
		;
		LD	R0, NEG_ASCII_q	
		ADD	R0, R0, R1	
		BRz	CONTMESSAGE	; User opted to quit
		;
		LD	R2, UPDATEBOARD_ADDR
		JSRR	R2
		;
		LD	R2, DRAWBOARD_ADDR
		JSRR	R2
		;
		LD	R2, EVALBOARD_ADDR
		JSRR	R2
		BRnzp	CHECK
GAMEOVER	LD	R2, PRINTOUTCOME_ADDR
		JSRR	R2
CONTMESSAGE	LEA	R0, PLAYAGAIN
		TRAP	x22
		TRAP	x20
		BRnzp	MAIN
FINALMESSAGE	LEA	R0, THANKS
		TRAP	x22
		TRAP	x25	
;-----------------------------------------------------------------
; Pointer table to subroutines.
;-----------------------------------------------------------------
INITBOARD_ADDR		.FILL	INITBOARD
EVALBOARD_ADDR		.FILL	EVALBOARD
GETVALIDINPUT_ADDR	.FILL	GETVALIDINPUT
UPDATEBOARD_ADDR	.FILL	UPDATEBOARD
DRAWBOARD_ADDR		.FILL	DRAWBOARD
PRINTOUTCOME_ADDR	.FILL	PRINTOUTCOME
;-----------------------------------------------------------------
; Constants
;-----------------------------------------------------------------
ROW1		.STRINGZ	"   |   |   "
ROW2		.STRINGZ	"   |   |   "
ROW3		.STRINGZ	"   |   |   "
ROW4		.STRINGZ	"-----------"
ROW5 		.STRINGZ	"   |   |   "
ROW6		.STRINGZ	"   |   |   "
ROW7		.STRINGZ	"   |   |   "
ROW8		.STRINGZ	"-----------"
ROW9		.STRINGZ	"   |   |   "
ROW10		.STRINGZ	"   |   |   "
ROW11 		.STRINGZ	"   |   |   "
WELCOME		.STRINGZ	"\nWelcome to Tic-Tac-Toe"
THANKS		.STRINGZ	"Thanks for playing Tic-Tac-Toe\n"
ASCII_X		.FILL 		x0058	
ASCII_O		.FILL		x004f	
NEG_ASCII_X	.FILL		xFFA8
NEG_ASCII_O	.FILL		xFFB1
NEG_ASCII_q	.FILL		xFF8F	; Negative of x0071 (ASCII 'q')
NEG_ASCII_x	.FILL		x-78	; Negative of x0078 (ASCII 'x')
NEG_ASCII_SP	.FILL		xFFE0   
NEWLINE		.FILL		x000A	; LineFeed Character
PLAYAGAIN	.STRINGZ	"Press any key to play another game of Tic-Tac-Toe\n"
;-----------------------------------------------------------------
; EVALBOARD subroutine -
; Args: 
;	R1 - Upon exit, contains a code indicating 
;	     the status of the game.
;		0 = game still in progress
;		1 = X wins
;   		2 = O wins
;		3 = Cat Game (draw)
;
; 1. Determine if the board is full (to detect cat game)
; 2. Check all 8 possible win scenarios
; 3. Set exit code in R1
;-----------------------------------------------------------------
EVALBOARD	ST	R0, EV_R0	; Save R0
		ST	R2, EV_R2	; Save R2
		ST	R3, EV_R3	; Save R3
		ST	R4, EV_R4	; Save R4	
		ST	R5, EV_R5	; Save R5
		ST	R6, EV_R6	; Save R6
		ST	R7, EV_R7	; Save Return Address
;-----------------------------------------------------------------
; Setup the base of the pointer table
;-----------------------------------------------------------------
		LD	R0, SQRCENTERS_ADDR
		ADD	R0, R0, #-1	; R0 contains base of pointer table
					; (handle indexes 1 - 9)
;-----------------------------------------------------------------
; First check for a full board and set EV_FULLBOARD to:
; 0 = board is full
; 1 = board contains at least one empty square
;-----------------------------------------------------------------
		AND	R2, R2, #0
		ADD	R2, R2, #9
		LD	R3, NEG_ASCII_SP
		AND	R4, R4, #0	; R4 countains the value we'll store to EV_FULLBOARD
EV_LOOP		ADD	R5, R0, R2
		LDR	R5, R5, #0	; pointer to square n 
		LDR	R5, R5, #0	; square n 
		ADD	R5, R5, R3
		BRz	EV_FOUNDSPACE	; if we find a space, note it and exit loop
		ADD	R2, R2, #-1	
		BRp	EV_LOOP		
		BRnzp	EV_NOSPACE	
EV_FOUNDSPACE	ADD	R4, R4, #1
EV_NOSPACE	ST	R4, EV_FULLBOARD
;-----------------------------------------------------------------
; Now check all 8 possible win combinations
;-----------------------------------------------------------------
		AND	R1, R1, #0	; R1 contains our exit code
 		ADD	R2, R0, #5	; pointer to pointer to center square (square 5)
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 5 ('X', 'O', or ' ') = center square
		LD	R3, NEG_ASCII_SP
		ADD	R3, R3, R2
		BRz	EV_CHECK5	; If the center square is a space, 
					; skip these four checks
		NOT	R3, R2		
		ADD	R3, R3, #1	; now we have ASCII_NEG_X or ASCII_NEG_O
EV_CHECK1	ADD	R2, R0, #4	; pointer to pointer to square 4
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 4 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECK2
		ADD	R2, R0, #6	; pointer to pointer to square 6
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 6 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
EV_CHECK2	ADD	R2, R0, #2	; pointer to pointer to square 2
		LDR	R2, R2, #0	
		LDR	R2, R2, #0	; square 2 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECK3
		ADD	R2, R0, #8	; pointer to pointer to square 8
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 8 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
EV_CHECK3	ADD	R2, R0, #1	; pointer to pointer to square 1
		LDR	R2, R2, #0	
		LDR	R2, R2, #0	; square 1 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECK4
		ADD	R2, R0, #9	; pointer to pointer to square 9
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 9 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
EV_CHECK4	ADD	R2, R0, #3	; pointer to pointer to square 3
		LDR	R2, R2, #0	
		LDR	R2, R2, #0	; square 3 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECK5
		ADD	R2, R0, #7	; pointer to pointer to square 7
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 7 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
EV_CHECK5	ADD	R2, R0, #1	; pointer to pointer to square 1
		LDR	R2, R2, #0		
		LDR	R2, R2, #0	; square 1 ('X', 'O', or ' ') = top left
		LD	R3, NEG_ASCII_SP
		ADD	R3, R3, R2
		BRz	EV_CHECK6	; If the top left square is a space, 
					; skip these two checks
		NOT	R3, R2		
		ADD	R3, R3, #1	; now we have ASCII_NEG_X or ASCII_NEG_O
		ADD	R2, R0, #4	; pointer to pointer to square 4
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 4 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECK6
		ADD	R2, R0, #7	; pointer to pointer to square 7
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 7 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
EV_CHECK6	ADD	R2, R0, #2	; pointer to pointer to square 2
		LDR	R2, R2, #0		
		LDR	R2, R2, #0	; square 2 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECK7
		ADD	R2, R0, #3	; pointer to pointer to square 3
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 3 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
EV_CHECK7	ADD	R2, R0, #9	; pointer to pointer to square 9
		LDR	R2, R2, #0		
		LDR	R2, R2, #0	; square 9 ('X', 'O', or ' ') = bottoom right
		LD	R3, NEG_ASCII_SP
		ADD	R3, R3, R2
		BRz	EV_CHECK8	; If the bottom right square is a space, 
					; skip these two checks
		NOT	R3, R2		
		ADD	R3, R3, #1	; now we have ASCII_NEG_X or ASCII_NEG_O
		ADD	R2, R0, #6	; pointer to pointer to square 6
		LDR	R2, R2, #0		
		LDR	R2, R2, #0	; square 6 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECK8
		ADD	R2, R0, #3	; pointer to pointer to square 3
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 3 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
EV_CHECK8	ADD	R2, R0, #8	; pointer to pointer to square 8
		LDR	R2, R2, #0		
		LDR	R2, R2, #0	; square 8 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRnp	EV_CHECKCAT
		ADD	R2, R0, #7	; pointer to pointer to square 7
		LDR	R2, R2, #0
		LDR	R2, R2, #0	; square 7 ('X', 'O', or ' ')
		ADD	R2, R2, R3	
		BRz	EV_WINNER	; found a winner!
;-----------------------------------------------------------------
; If we didn't have a winner, check to see if we had a cat game
;-----------------------------------------------------------------
EV_CHECKCAT	LD	R2, EV_FULLBOARD
		BRp	EV_EXIT
		ADD	R1, R1, #3	; R1 = 3 indicating we had a cat game.
		BRnzp	EV_EXIT
;-----------------------------------------------------------------
; If we have a winner, R3 contains the negative ascii code 
; of the winner's character
;-----------------------------------------------------------------
EV_WINNER	LD	R2, ASCII_X
		ADD	R2, R2, R3
		BRnp	EV_O_WINS	
		ADD	R1, R1, #1	; R1 = 1 indicating X won
		BRnzp	EV_EXIT				
EV_O_WINS	ADD	R1, R1, #2	; R1 = 2 indicating O won
;-----------------------------------------------------------------
; Restore the registers and return with exit code in R1
;-----------------------------------------------------------------
EV_EXIT		LD	R0, EV_R0	; Restore R0
		LD	R2, EV_R2	; Restore R2
		LD	R3, EV_R3	; Restore R3
		LD	R4, EV_R4	; Restore R4
		LD	R5, EV_R5	; Restore R5
		LD	R6, EV_R6	; Restore R6
		LD	R7, EV_R7	; Restore R7
		RET
EV_FULLBOARD	.BLKW 	1		
EV_R0		.BLKW	1
EV_R2 		.BLKW	1
EV_R3 		.BLKW	1
EV_R4		.BLKW	1
EV_R5		.BLKW	1
EV_R6 		.BLKW	1
EV_R7 		.BLKW	1
;-----------------------------------------------------------------
; INITBOARD subroutine -
; 1. Initializes SQRCENTERS array with pointers to the center
;    of each square.
; 2. Sets value of each square to a blank
; 3. Set first player to X
;-----------------------------------------------------------------
INITBOARD	LD	R0, SQRCENTERS_ADDR
		LD	R2, IB_ASCII_SP

		LD 	R1, ROW2_ADDR
		ADD	R1, R1, #1
		STR	R1, R0, #0	; sq 1 center addr
		STR	R2, R1, #0	; store ASCII blank
		ADD	R1, R1, #4
		STR	R1, R0, #1	; sq 2 center addr
		STR	R2, R1, #0	; store ASCII blank
		ADD	R1, R1, #4
		STR	R1, R0, #2	; sq 3 center addr
		STR	R2, R1, #0	; store ASCII blank

		LD 	R1, ROW6_ADDR
		ADD	R1, R1, #1
		STR	R1, R0, #3	; sq 4 center addr
		STR	R2, R1, #0	; store ASCII blank
		ADD	R1, R1, #4
		STR	R1, R0, #4	; sq 5 center addr
		STR	R2, R1, #0	; store ASCII blank
		ADD	R1, R1, #4
		STR	R1, R0, #5	; sq 6 center addr
		STR	R2, R1, #0	; store ASCII blank

		LD 	R1, ROW10_ADDR
		ADD	R1, R1, #1
		STR	R1, R0, #6	; sq 7 center addr
		STR	R2, R1, #0	; store ASCII blank
		ADD	R1, R1, #4
		STR	R1, R0, #7	; sq 8 center addr
		STR	R2, R1, #0	; store ASCII blank
		ADD	R1, R1, #4
		STR	R1, R0, #8	; sq 9 center addr
		STR	R2, R1, #0	; store ASCII blank
;-----------------------------------------------------------------
; Set first player to X
;-----------------------------------------------------------------
		AND	R2, R2, #0
		ADD	R2, R2, #1
		ST	R2, PLAYER		
		RET
IB_ASCII_SP	.FILL	x20		; ASCII space
;-----------------------------------------------------------------
; PLAYER : 0 = O
;          1 = X
; X always goes first (thus we initialize
; the memory location to 1.)
;-----------------------------------------------------------------
PLAYER		.FILL	x0001
;-----------------------------------------------------------------
; GETPLAYER subroutine
; 1.  Returns either ASCII 'X' or 'O' in R0.
;-----------------------------------------------------------------
GETPLAYER	LD 	R0, PLAYER	; Load R0 with player: 0=O, 1=X
		BRz 	GP_O_TURN
		LD 	R0, ASCII__X
		BR 	GP_DONE
GP_O_TURN	LD 	R0, ASCII__O
GP_DONE		RET		
;-----------------------------------------------------------------
; Pointer table to constants defined above.
;-----------------------------------------------------------------
; Contains table of nine addresses where each address
; corresponds to one of the nine centers of a square
SQRCENTERS	.BLKW	9
SQRCENTERS_ADDR	.FILL 	SQRCENTERS
ROW1_ADDR	.FILL	ROW1		
ROW2_ADDR	.FILL	ROW2
ROW3_ADDR	.FILL	ROW3
ROW4_ADDR	.FILL	ROW4	
ROW5_ADDR	.FILL	ROW5
ROW6_ADDR	.FILL	ROW6
ROW7_ADDR	.FILL	ROW7
ROW8_ADDR	.FILL	ROW8
ROW9_ADDR	.FILL	ROW9
ROW10_ADDR	.FILL	ROW10
ROW11_ADDR	.FILL	ROW11
GETPLAYER_ADDR	.FILL	GETPLAYER
ASCII__X	.FILL	x0058 ; Notice there are two underscores
ASCII__O	.FILL	x004F 
NEW_LINE	.FILL	x000A 
;-----------------------------------------------------------------
; UPDATEBOARD subroutine
; Args:
;	R1 - contains an ASCII code for a number 1-9 
; 
; 1. Based on MEMORY[PLAYER] you know whether X or O just took a turn.
; 2. Store the appropriate charater (X or O) in memory to the middle
;    of the Tic-Tac-Toe square denoted by the contents of R1.
;    (i.e. MEMORY[PLAYER] = 1 and R1 = 7, store an 'X' in the
;    middle of the bottom-left square on the board.
;-----------------------------------------------------------------
UPDATEBOARD	ST 	R0, GI_R0	; save registers
		ST 	R2, GI_R2
		ST 	R3, GI_R3
		ST 	R4, GI_R4
		ST 	R7, GI_R7

		LD 	R2, GETPLAYER_ADDR
		JSRR	R2		; returns 'X' or 'O' in R0
		
		LD	R3, SQRCENTERS_ADDR
		ADD	R3, R3, #-1	; R0 contains base of pointer table
					; (handle indexes 1 - 9)
		LD	R4, GI_NEG_ASCII_0
		ADD 	R2, R1, R4	; translate ASCII to integer 1 - 9
		ADD 	R3, R3, R2	; compute pointer to pointer to square centers table
		LDR	R3, R3, #0
		STR	R0, R3, #0	; store 'X' or 'O' into appropriate square

; Toggler player
		LD 	R2, PLAYER	; Load R2 with player: 0=O, 1=X
		BRz 	UB_X_TURN
		AND	R2, R2, #0	; O's turn
		BR 	UB_DONE
UB_X_TURN	ADD	R2, R2, #1	; X's turn

UB_DONE		ST	R2, PLAYER
		LD 	R0, GI_R0	; restore registers
		LD 	R2, GI_R2
		LD 	R3, GI_R3
		LD 	R4, GI_R4
		LD 	R7, GI_R7		
		RET
;-----------------------------------------------------------------
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; DO NOT MODIFY ANY CODE ABOVE THIS LINE! 
; MAKE ALL YOUR CHANGES AND ADDITIONS BELOW THIS LINE!
;-----------------------------------------------------------------
; GETVALIDINPUT subroutine 
; Args:
;	R1 - When subroutine returns, this register 
;	     contains the input, ASCII 1-9, or ASCII 'q'.
; 
; 1. Prompt the current player for which square he/she wants.
; 2. If the player inputs anything other than a number 1-9 or the 
;    letter 'q', print an error message and reprompt them.
; 3. If the player chooses an occupied square, print an error message
;    and reprompt them.
;-----------------------------------------------------------------
GETVALIDINPUT	ST 	R0, GI_R0	; save registers
		ST 	R2, GI_R2
		ST 	R3, GI_R3
		ST 	R4, GI_R4
		ST 	R7, GI_R7
;-----------------------------------------------------------------
; Display prompt and get user input.
; 1. First display either 'X' or 'O' based on player's turn,
;    then display remainder of prompt
; 2. Get user input and store entered character in R1
;-----------------------------------------------------------------
GI_LOOP		LD 	R2, GETPLAYER_ADDR
		JSRR	R2		; returns 'X' or 'O' in R0
;                     
; ******************** Start User Code ***************************
;   Add code to display user prompt (including the 'X' / 'O')
;   The entered character should be in R1 by the end of this code block.
;
;   Display User Prompt

		PUTC
		LEA R0, GI_USERPROMPT
		PUTS

;   Get User Input

		GETC 
		PUTC
		ADD R1, R0, #0

		AND R0, R0, #0
		ADD R0, R0, x000A
		
		PUTC 

; ********************* End User Code ****************************
;-----------------------------------------------------------------
; Validate input:  must be 1 - 9 or 'q' or 'x'
; 1. R1 contains entered character (ASCII code)
; 2. After verifying 1 - 9, branch to GI_CHK_SQUARE to
;    check if square is occupied.
; Hint:  check for 'x' and 'q' before performing 1-9 range check
;-----------------------------------------------------------------
; ******************** Start User Code ***************************
;   Add code to validate the ASCII character in R1.
;   If character is 'q' or 'x', branch to GI_DONE.
;   If character is invalid, branch to GI_INVALID.
;   Once character is validated (i.e., is between 1 - 9 inclusive),
;     either just drop through or branch to GI_CHK_SQUARE.
;   Hint: rememeber the Encryption Key range check in Encryptor assignment.

;   Check for q

		LD R4, GI_NEG_ASCII_q
		ADD R4, R4, R1
		BRz GI_DONE

;   Check for x

		LD R4, GI_NEG_ASCII_x
		ADD R4, R4, R1
		BRz GI_DONE	

;   Check for less than 1  

		LD R4, GI_NEG_ASCII_1
		ADD R4, R4, R1
		BRn GI_INVALID

;   Check for greater than 9  

		LD R4, GI_NEG_ASCII_9
		ADD R4, R4, R1
		BRp GI_INVALID

; ********************* End User Code ****************************
;-----------------------------------------------------------------
; Check if selected square ia already occupied
; 1.  Entering this code, R1 contains the ASCII code 1 - 9
;     and R2, R3, and R4 are available as temporary registers
;-----------------------------------------------------------------
GI_CHK_SQUARE	LD	R3, SQRCENTERS_ADDR
		ADD	R3, R3, #-1	; R0 contains base of pointer table
					; (handle indexes 1 - 9)
		LD	R4, GI_NEG_ASCII_0
		ADD 	R2, R1, R4	; translate ASCII to integer 1 - 9
		ADD 	R3, R3, R2	; compute pointer to pointer to square centers table

		LDR	R3, R3, #0
		LDR	R3, R3, #0	; get square's contents
		LD	R4, GI_NEG_ASCII_SP
		ADD	R2, R3, R4	; check if square is blank
		BRz	GI_DONE

		LEA 	R0, GI_SPACE_OCP
		PUTS
		BRp 	GI_LOOP		; square is occuppied

GI_DONE		LD 	R0, GI_R0	; restore registers
		LD 	R2, GI_R2
		LD 	R3, GI_R3
		LD 	R4, GI_R4
		LD 	R7, GI_R7
		RET

; Invalid input code
GI_INVALID	LEA 	R0, GI_INVALID_INP
		PUTS
		BR 	GI_LOOP

GI_USERPROMPT	.STRINGZ	" - Which square? [1-9,q,x]: "
GI_INVALID_INP	.STRINGZ 	"Invalid input\n"
GI_SPACE_OCP	.STRINGZ 	"Space occupied\n"

GI_NEG_ASCII_q	.FILL		x-71	; Negative of ASCII 'q'
GI_NEG_ASCII_x	.FILL		x-78	; Negative of ASCII 'x'
GI_NEG_ASCII_0	.FILL 		x-30	; Negative of ASCII '0'
GI_NEG_ASCII_1	.FILL 		x-31	; Negative of ASCII '1'
GI_NEG_ASCII_9	.FILL 		x-39	; Negative of ASCII '9'
GI_NEG_ASCII_SP	.FILL 		x-20	; Negative of ASCII 'space'
GI_ASCII_x	.FILL		x78
GI_R0		.BLKW		1
GI_R2		.BLKW		1
GI_R3		.BLKW		1
GI_R4		.BLKW		1
GI_R7		.BLKW		1
;-----------------------------------------------------------------
; DRAWBOARD - Print the board
; 1.  Save registers R0 and R7
; 2.  Print out each row.  Use ROW1_ADDR, ROW2_ADDR, 
;     through ROW11_ADDR. Example:
;         LD R0, ROW1_ADDR  ; loads ROW1 string pointer into R0
; 3.  Restore registers R0 and R7.
;-----------------------------------------------------------------
DRAWBOARD
;-----------------------------------------------------------------
; ******************** Start User Code ***************************
;

; Store R0, R2, R7
		ST R0, GI_R0
		ST R7, GI_R7

; Print out each row


		LD R0, ROW1_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW2_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW3_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW4_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW5_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW6_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW7_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW8_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW9_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW10_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 

		LD R0, ROW11_ADDR

		PUTS
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC 


; Restore R0, R2, R7

		LD R0, GI_R0
		LD R7, GI_R7

		RET

;
; ********************* End User Code ****************************
;-----------------------------------------------------------------
; PRINTOUTCOME subroutine
; Args : 
;	R1 - Contains a number 1-3
;		1 = X wins
;		2 = O wins
; 		3 = Cat Game
; 1. Print a message declaring the outcome of the game.
;-----------------------------------------------------------------
PRINTOUTCOME
;-----------------------------------------------------------------
; ******************** Start User Code ***************************
;

; Store R4
		ST R0, GI_R0
		ST R4, GI_R4
		ST R7, GI_R7


; Print Outcome
O_X		LD R4, OC_CHECK_X
		ADD R4, R4, R1
		BRnp O_O
		LEA R0, OC_X
		PUTS
		BR O_END

O_O		LD R4 OC_CHECK_O
		ADD R4, R4, R1
		BRnp O_CAT
		LEA R0, OC_O
		PUTS
		BR O_END

O_CAT		LD R4 OC_CHECK_CAT
		ADD R4, R4, R1
		BRnp O_END
		LEA R0, OC_CAT
		PUTS
		BR O_END

O_END
; New Line
		AND R0, R0, #0
		ADD R0, R0, x000A
		PUTC
		
; Restore R4
		LD R0, GI_R0
		LD R4, GI_R4
		LD R7, GI_R7




		

		RET

OC_CHECK_X	.FILL	x-1
OC_CHECK_O	.FILL	x-2
OC_CHECK_CAT	.FILL	x-3

OC_X 		.STRINGZ "X wins"
OC_O 		.STRINGZ "O wins"
OC_CAT		.STRINGZ "Cat Game"


;
; ********************* End User Code ****************************
		.END
