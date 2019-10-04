; ******************************************************************************
; ******************************************************************************
;
;		Name : 		data.asm
;		Purpose : 	Data Allocation.
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

BuildAddress = $6000 						; build the interpreter here
StackAddress = $0C00 						; 1k of stack space (256 x 32 bits)
MemoryStart = $1000 						; system memory starts here
MemoryEnd = $6000 							; and ends here.

StructureStack = $0BFF 						; structure stack (works down to $xx00)

HashTableSize = 16 							; hash tables to search.

; ******************************************************************************
;
;							Allocate Zero Page usage
;
; ******************************************************************************

		* = $0000

CodePtr: 		.word ? 					; code pointer
StructSP: 		.word ?						; structure stack pointer

zTemp0:			.word ?						; temporary words
zTemp1: 		.word ?
zTemp2: 		.word ?

zLTemp1:		.dword ?					; temporary longs

breakCount:		.byte ? 					; used to stop break firing every execution.

idDataAddr:		.word ? 					; data address.

SignCount:		.byte ?						; sign count for divide

ForAddr:		.byte ? 					; points to current FOR structure

; ******************************************************************************
;
;				Allocate Memory in the current instance space
;
; ******************************************************************************

		* = MemoryStart

AZVariables:	.fill	26*4 				; 26 x 4 byte variables, which are A-Z

HashTable: 		.fill 	HashTableSize * 2 	; n x 2 links for the hash tables.

VarMemory:		.word 	0 					; next free byte available for VARIABLES (going up)

AllocMemory: 	.word 	0 					; last free byte availabel for ALLOC (going down)

ProgramStart	= MemoryStart + $100 		; where code actually goes.

; ******************************************************************************
;
;				Stack - actually four 1/4 stacks, one for each byte.
;
; ******************************************************************************

stack0 = StackAddress
stack1 = StackAddress+256
stack2 = StackAddress+512
stack3 = StackAddress+768

; ******************************************************************************
;
;									Other constants
;
; ******************************************************************************
;
;		Identifiers used in internal storage
;
IDT_VARIABLE = 'V'							; type markers for the information store.
IDT_PROCEDURE = 'P'							; standard procedure (e.g. in code)
IDT_CODEPROC = 'C'							; machine language procedure.
;
;		Markers used on the structure stack.
;
STM_FOR = 'F'								; structure markers (for/next)
STM_CALL = 'C'								; call & return  (& ;)
STM_REPEAT = 'R'							; repeat & until
