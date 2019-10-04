; ******************************************************************************
; ******************************************************************************
;
;		Name : 		main.asm
;		Purpose : 	RPL/65 Main Program
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	2nd October 2019
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
		lda 	#10 						; reset the base
		sta 	CurrentBase

		jsr 	ResetForRun
		jsr 	ResetCodePointer
		jmp 	System_RUN

		.include "generated/tables.inc" 	; keyword tables, constants, vector table.
		.include "system/extern.asm"		; external functions.
		.include "system/execute.asm"		; execution functions.	
		.include "system/identifier.asm"	; identifier search/create
		.include "system/reset.asm"			; reset variables etc., reset code to start
		.include "system/scan.asm" 			; scan through code looking for procedures.
		.include "functions/stack.asm"		; stack manipulation
		.include "functions/unary.asm"		; unary functions.
		.include "functions/memory.asm"		; memory r/w functions
		.include "functions/binary.asm"		; simple binary functions
		.include "functions/compare.asm"	; comparison functions
		.include "miscellany/system.asm"	; system functions.
		.include "miscellany/variables.asm"	; variable handlers.

SyntaxError:		
		.byte 	$FF		
		ldx 	#2
WarmStart:	
		.byte 	$FF		
		ldx 	#3
ErrorHandler:
		.byte 	$FF		
		ldx 	#4
Identifier:
		.byte 	$FF		
		ldx 	#5

		* = ProgramStart
		.include "generated/testcode.inc"
		.byte 	0

