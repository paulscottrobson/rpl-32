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

		jsr 	ResetForRun
		jsr 	ResetCodePointer

		jmp 	System_RUN

BootMessage:
		.include "generated/bootmessage.inc"

		.include "generated/tables.inc" 	; keyword tables, constants, vector table.
		.include "system/extern.asm"		; external functions.
		.include "system/execute.asm"		; execution functions.	
		.include "system/identifier.asm"	; identifier search/create
		.include "system/reset.asm"			; reset variables etc., reset code to start
		.include "system/scan.asm" 			; scan through code looking for procedures.
		.include "system/indexing.asm"		; array indexing
		.include "system/error.asm" 		; error handling.
		.include "system/inttostr.asm"		; integer to ASCII routines.
		.include "functions/stack.asm"		; stack manipulation
		.include "functions/unary.asm"		; unary functions.
		.include "functions/memory.asm"		; memory r/w functions
		.include "functions/binary.asm"		; simple binary functions
		.include "functions/multiply.asm"	; multiply
		.include "functions/divide.asm" 	; divide
		.include "functions/compare.asm"	; comparison functions
		.include "miscellany/system.asm"	; system functions.
		.include "miscellany/variables.asm"	; variable handlers.
		.include "miscellany/inttostr.asm"	; conversion
		.include "miscellany/intfromstr.asm"; conversion
		.include "structures/fornext.asm"	; for/next code
		.include "structures/structures.asm"; structure utility code.


		* = ProgramStart
		.include "generated/testcode.inc"
		.byte 	0
