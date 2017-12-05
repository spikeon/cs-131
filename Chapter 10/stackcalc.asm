; File: 	stackcalc.asm
; Description:	Stack Calculator Example
;
; Author:	Carl Reinwald
; Date:		2017-5-14
;
; Hardcoded stack calculator that computes
;
;     RESULT = A + B + C
;
; by implementing
;
;     RESULT = A Push B Push C + + Pop
;
		.ORIG x3000
		BRnzp 	START
;
;  Memory Locations for input numbers A, B, and C
;  along with the RESULT.
;
;  Note:  inputs must be between -9999 and 9999.
;
A		.FILL	1234	
B		.FILL	3210
C		.FILL	-1455
RESULT		.FILL	0		; = 2,989 = 0xBAD

START		LEA	R4,INIT_STACK
		JSRR	R4
		
		AND 	R0, R0, #0
		ST	R0, RESULT	; clear result

		LD 	R0, A
		LEA	R4, PUSH	; push A
		JSRR R4
		BRp	STACK_FAIL

		LD	R0, B
		LEA	R4, PUSH	; push B
		JSRR R4
		BRp	STACK_FAIL

		LD	R0, C
		LEA	R4, PUSH	; push C
		JSRR R4
		BRp	STACK_FAIL

		LEA	R4, OpAdd
		JSRR R4			; B + C

		LEA	R4, OpAdd
		JSRR R4			; A + (B + C from previous operation)

		LEA	R4, POP
		JSRR R4			; retrieve result
		BRp	STACK_FAIL

		ST	R0, RESULT	; store result
		BRnzp	DONE

STACK_FAIL	LEA	R0, STACK_FAIL_MSG
		PUTS

DONE		HALT

STACK_FAIL_MSG	.STRINGZ	"Stack operation failed\n"

;
;        Routine to pop the top two elements from the stack,
;        add them, and push the sum onto the stack.  R6 is
;        the stack pointer.
;
 OpAdd 		ST      R7,OA_Save7	; save return address
		JSR	POP             ; Get first source operand.
		ADD	R5,R5,#0        ; Test if POP was successful.
		BRp	OA_Exit         ; Branch if not successful.
		ADD     R1,R0,#0        ; Make room for second operand
		JSR     POP             ; Get second source operand.
		ADD     R5,R5,#0        ; Test if POP was successful.
		BRp     OA_Restore1     ; Not successful, put back first.
		ADD     R0,R0,R1        ; THE Add.
		JSR     RangeCheck      ; Check size of result.
		BRp     OA_Restore2     ; Out of range, restore both.
		JSR     PUSH            ; Push sum on the stack.
		BRnzp	OA_Exit		; return to caller
OA_Restore2	ADD     R6,R6,#-1       ; Decrement stack pointer.
OA_Restore1	ADD     R6,R6,#-1       ; Decrement stack pointer.
OA_Exit		LD	R7,OA_Save7	; restore return address
		RET
OA_Save7	.FILL   x0000

;
;     Routine to check that the magnitude of a value is 
;     between -999 and +999.
;
RangeCheck    LD        R5,Neg9999
              ADD       R4,R0,R5   ; Recall that R0 contains the 
              BRp       BadRange   ; result being checked.
              LD        R5,Pos9999
              ADD       R4,R0,R5
              BRn       BadRange
              AND       R5,R5,#0   ; R5 <-- success
              RET
BadRange      ST        R7,RC_Save7; R7 is needed by TRAP/RET
              LEA       R0,RangeErrorMsg
              TRAP      x22        ; Output character string
              LD        R7,RC_Save7
              AND       R5,R5,#0   ; 
              ADD       R5,R5,#1   ; R5 <-- failure
              RET
Neg9999       .FILL     #-9999
Pos9999       .FILL     #9999
RC_Save7      .FILL     x0000
RangeErrorMsg .FILL     x000A
              .STRINGZ  "Error: Number is out of range.\n"
	      
;
;  Slightly modified version of figure 10.5, The Stack Protocol
;
; Subroutines for carrying out the PUSH and POP functions.  This 
; program works with a stack consisting of memory locations x3100
; (BASE) through x30F8 (MAX).  R6 is the stack pointer.
;
INIT_STACK	LD	R6,BASE
		NOT	R6,R6
		ADD	R6,R6,#1
		RET

POP		ST      R2,Save2       ; are needed by POP.
		ST      R1,Save1
		LD      R1,BASE
		ADD     R1,R1,#-1 	
		ADD     R2,R6,R1       ; Compare stack pointer to BASE-1
		BRz     fail_exit      ; Branch if stack is empty.
		LDR     R0,R6,#0       ; The actual "pop."
		ADD     R6,R6,#1       ; Adjust stack pointer
		BRnzp   success_exit

PUSH		ST      R2,Save2       ; Save registers that 
		ST      R1,Save1       ; are needed by PUSH.
		LD      R1,MAX         
		ADD     R2,R6,R1       ; Compare stack pointer to MAX
		BRz     fail_exit      ; Branch if stack is full.
		ADD     R6,R6,#-1      ; Adjust stack pointer
		STR     R0,R6,#0       ; The actual "push"
success_exit	LD      R1,Save1       ; Restore original 
		LD      R2,Save2       ; register values.
		AND     R5,R5,#0       ; R5 <-- success.
		RET
fail_exit	LD      R1,Save1       ; Restore original
		LD      R2,Save2       ; register values.
		AND     R5,R5,#0      
		ADD     R5,R5,#1       ; R5 <-- failure. 
		RET

BASE		.FILL   x-3100         ; BASE contains
MAX		.FILL   x-30F8         ; MAX contains
Save1         	.FILL   x0000
Save2           .FILL   x0000

		.END
