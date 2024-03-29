; ******************************************************************************
; ******************************************************************************
;
;		Name : 		main.asm
;		Purpose : 	RPL/32 Main Program
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

		.include "data.asm"
		.include "macro.asm"

		* = $F00 							; just for booting.
		jmp 	Start

		* = BuildAddress
Start:
		ldx 	#$FF 						; reset the stack.
		txs
		jsr 	ExternInitialise 			; interface setup

		ldx 	#0 							; display boot message
_Display:
		lda 	BootMessage,x
		jsr 	ExternPrint
		inx		
		lda 	BootMessage,x
		bne 	_Display

		lda 	#(MemoryEnd-ProgramStart) & $FF
		ldy 	#(MemoryEnd-ProgramStart) >>8
		ldx 	#0
		jsr 	ErrorPrint16
		
		ldx 	#0 							; clear extended data area
_ClearX:stz 	ExtDataArea,x 				; this is so any library data
		inx 								; is zeroed on start up.
		bne 	_ClearX

		inc 	ReturnDefZero
		
		lda 	#13
		jsr 	ExternPrint
		jsr 	ExternPrint

		lda 	#MemoryEnd >> 8 			; set top of memory address.
		sta 	AllocMemory+1
		stz 	AllocMemory

		jsr 	ResetForRun
		jsr 	ResetCodePointer

		.if debug==1
		jmp 	System_Run
		.endif

WarmStart:
		lda 	#COL_CYAN
		jsr 	ExternColour
		lda 	#"O"
		jsr 	ExternPrint
		lda 	#"K"
		jsr 	ExternPrint
		lda 	#13
		jsr 	ExternPrint
NewCommand:
		txa
		ldx 	#$FF 						; reset stack colour
		txs
		tax
		lda 	#COL_WHITE
		jsr 	ExternColour
		jsr 	ExternInput 				; input text
		lda 	#InputBuffer & $FF 			; codePtr = input buffer
		sta 	codePtr
		lda 	#InputBuffer >> 8
		sta 	codePtr+1
		lda 	#(TokeniseBuffer+3) & $FF 	; zTemp1 is set up as a fake line
		sta 	zTemp1 						; with line number 0 by being
		lda 	#(TokeniseBuffer+3) >> 8 	; prefixed with three zeros
		sta 	zTemp1+1
		stz 	TokeniseBuffer+0			; put in those three zeroes
		stz		TokeniseBuffer+1
		stz 	TokeniseBuffer+2
		jsr 	Tokenise

		ldy 	#0 							; see what's at the start re numbers
SkipSpaces:
		lda 	InputBuffer,y
		iny
		cmp 	#' '
		beq 	SkipSpaces
		cmp 	#'0'
		bcc 	ExecuteCLI
		cmp 	#'9'+1
		bcs 	ExecuteCLI
		lda 	InputBuffer
		cmp 	#' '
		beq 	ExecuteCLI
		jmp		EditProgram

ExecuteCLI:
		lda 	#TokeniseBuffer & 255 		; set tokenise buffer as faux line
		sta 	codePtr
		lda 	#TokeniseBuffer >> 8 
		sta 	codePtr+1
		ldy 	#3
		jmp 	Execute 					; and run it

BootMessage:
		.include "generated/bootmessage.inc"

		.include "generated/tables.inc" 	; keyword tables, constants, vector table.
		.include "system/extern.asm"		; external functions.
		.include "system/execute.asm"		; execution functions.	
		.include "system/identifier.asm"	; identifier search/create
		.include "system/reset.asm"			; reset variables etc., reset code to start
		.include "system/scan.asm" 			; scan through code looking for procedures.
		.include "system/error.asm" 		; error handling.
		.include "system/inttostr.asm"		; integer to ASCII routines.
		.include "system/intfromstr.asm"	; integer to ASCII routines.
		.include "system/tokeniser.asm"		; tokeniser
		.include "system/editor.asm"		; find/delete/edit lines
		.include "functions/stack.asm"		; stack manipulation
		.include "functions/unary.asm"		; unary functions.
		.include "functions/memory.asm"		; memory r/w functions
		.include "functions/binary.asm"		; simple binary functions
		.include "functions/multiply.asm"	; multiply
		.include "functions/divide.asm" 	; divide
		.include "functions/compare.asm"	; comparison functions
		.include "miscellany/alloc.asm"		; memory allocation
		.include "miscellany/list.asm"		; list command
		.include "miscellany/renumber.asm"	; renumber command
		.include "miscellany/system.asm"	; system functions.
		.include "miscellany/saveload.asm"	; save/load.
		.include "miscellany/variables.asm"	; variable handlers.
		.include "miscellany/indexing.asm"	; array indexing
		.include "structures/if.asm"		; if code
		.include "structures/fornext.asm"	; for/next code
		.include "structures/repeat.asm"	; repeat/until code.
		.include "structures/structures.asm"; structure utility code.

		.include "generated/hashes.inc"		; hash structure for library code
		.include "generated/library.inc"	; library code.

		* = ProgramStart
		.include "generated/testcode.inc"
		.byte 	0
