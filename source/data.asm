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

BuildAddress = $A000 						; build the interpreter here
StackAddress = $0C00 						; 1k of stack space (256 x 32 bits)
MemoryStart = $1000 						; system memory starts here
MemoryEnd = $9F00 							; and ends here.

StructureStack = $0BFF 						; structure stack (works down to $xx00)

ExtDataArea = $0800 						; space where non zp data goes
InputBuffer = $0900 						; Input Buffer
TokeniseBuffer = $0A00						; Tokenising buffer

HashTableSize = 16 							; hash tables to search.

		* = $0010
		.dsection zeroPage
		.cerror * > $8F,"Page Zero Overflow"

		* = ExtDataArea
		.dsection dataArea
		;.cerror * > ExtDataArea+$100,"Data Area Overflow"

	
; ******************************************************************************
;
;							Allocate Zero Page usage
;
; ******************************************************************************

		.section zeroPage

CodePtr: 		.word ? 					; code pointer
StructSP: 		.word ?						; structure stack pointer

zTemp0:			.word ?						; temporary words
zTemp1: 		.word ?
zTemp2: 		.word ?
zTemp3: 		.word ?
zTemp4:			.word ?

zLTemp1:		.dword ?					; temporary longs

idDataAddr:		.word ? 					; data address.

ForAddr:		.byte ? 					; points to current FOR structure

		.send zeroPage

; ******************************************************************************
;
;							Non zero page data area
;
; ******************************************************************************

		.section dataArea

SBuffer:		.fill 32 					; string buffer

SBPosition:		.byte ? 					; position in String Buffer

NumConvCount:	.byte ? 					; used in int to string

breakCount:		.byte ? 					; used to stop break firing every execution.

SignCount:		.byte ?						; sign count for divide

NumSuppress:	.byte ? 					; zero suppression flag

IFSHexFlag:		.byte ? 					; $FF if hex, $00 if dec

		.send dataArea

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
;
;		Colours.
;
COL_BLACK = 0 		
COL_RED = 1
COL_GREEN = 2
COL_YELLOW = 3
COL_BLUE = 4
COL_MAGENTA = 5
COL_CYAN = 6
COL_WHITE = 7
;
;		Theming
;
CTH_ERROR = COL_MAGENTA
CTH_TOKEN = COL_GREEN
CTH_IDENT = COL_YELLOW
CTH_COMMENT = COL_WHITE
CTH_STRING = COL_MAGENTA
CTH_NUMBER = COL_CYAN
CTH_LINENO = COL_MAGENTA
