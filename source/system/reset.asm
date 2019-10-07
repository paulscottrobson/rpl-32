; ******************************************************************************
; ******************************************************************************
;
;		Name : 		reset.asm
;		Purpose : 	Reset the tables and pointers for Running
;					Reset the code pointer to the start.
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;			  Reset the code pointer/Y to the start of the program
;
; ******************************************************************************

ResetCodePointer:
		pha
		lda 	#ProgramStart >> 8 			; set up line pointer
		sta 	codePtr+1
		stz 	codePtr
		ldy 	#3 							; point to first piece of code
		pla
		rts
		
; ******************************************************************************
;
;			Reset Variable State : Done when program changed, or on RUN.
;
; ******************************************************************************

ResetForRun:
		pha
		phy
		;
		;		Erase the variable hash tables
		;
		ldx 	#0 							; erase the hash table
_RRErase: 					
		stz		HashTable,x
		inx
		cpx 	#HashTableSize * 2
		bne 	_RRErase
		;
		;		Reset VarMemory to byte after program
		;
		jsr 	ResetVarMemory
		;
		;		Copy high memory to Alloc Memory 
		;
		lda 	#MemoryEnd >> 8
		sta 	AllocMemory+1
		stz 	AllocMemory
		;
		;		Reset the structure pointer
		;
		lda 	#StructureStack & $FF
		sta 	StructSP
		lda 	#StructureStack >> 8
		sta 	StructSP+1
		lda 	#$FF 						; put a value that will fail structure tests
		sta 	(StructSP)
		;
		;		Scan for procedures
		;
		jsr 	ProcedureScan
		;
		;		Clear the stack.
		;
		ldx 	#0 							; empty the stack
		ply
		pla
		rts

; ******************************************************************************
;
;							Find the end of program pointer
;
; ******************************************************************************

ResetVarMemory:
		jsr 	ResetCodePointer 			; code Pointer to start of program
_RRFindEnd:
		lda 	(codePtr)					; at end ?
		beq 	_RRFoundEnd
		clc 								; no, add offset to pointer.
		adc 	codePtr
		sta 	codePtr
		bcc 	_RRFindEnd
		inc 	codePtr+1
		bra 	_RRFindEnd		
_RRFoundEnd:
		clc 								; add 1 to this, as it points to the last
		lda 	codePtr 					; offset, and store in Variable Memory pointer
		adc 	#1
		sta 	VarMemory
		lda 	codePtr+1
		adc 	#0
		sta 	VarMemory+1
		rts
