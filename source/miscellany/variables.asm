; ******************************************************************************
; ******************************************************************************
;
;		Name : 		variables.asm
;		Purpose : 	Variable Read/Write, Procedures, M/C Routines
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	4th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;				Read an Identifier, push the contents on the stack
;
; ******************************************************************************

Identifier:
		dey 								; wind back to identifier start
		jsr 	IdentifierSearch 			; try to find it.
		bcc 	_IDUnknown 					; not known, give up.
		pha
		;
_IDSkip:
		lda 	(codePtr),y
		iny
		cmp 	#$E0
		bcc 	_IDSkip		
		;
		pla
		cmp 	#IDT_VARIABLE 				; check a variable
		bne 	_IDCall
		;
		jsr 	IndexCheck 					; check index/subscript
		;
		phy
		inx 								; make space on stack
		ldy 	#0 							; copy it back
		lda 	(idDataAddr),y
		sta 	stack0,x
		iny
		lda 	(idDataAddr),y
		sta 	stack1,x
		iny
		lda 	(idDataAddr),y
		sta 	stack2,x
		iny
		lda 	(idDataAddr),y
		sta 	stack3,x
		ply
		;
		jmp 	Execute

_IDUnknown:
		lda 	ReturnDefZero				; unknown identifiers return 0
		bne 	_IDDefault
		.rerror "UNKNOWN VARIABLE"
_IDDefault: 								; skip over identifiers.
		lda 	(codePtr),y
		iny
		cmp 	#$E0
		bcc 	_IDDefault
		inx
		stz 	stack0,x
		stz 	stack1,x
		stz 	stack2,x
		stz 	stack3,x
		jmp 	Execute
		;
		;		Handle Procedure Call
		;
_IDCall:
		cmp 	#IDT_PROCEDURE
		bne 	_IDCode
		jsr 	StructPushCurrent 			; push current on the stack.
		lda 	#STM_CALL 					; push marker
		pushstruct		
		;
		ldy 	#1 							; line address
		lda 	(idDataAddr)
		sta 	codePtr
		lda 	(idDataAddr),y
		sta 	codePtr+1
		ldy 	#3 							; line position
		lda 	(idDataAddr),y
		tay
		jmp 	Execute

_IDCode:
		lda 	(idDataAddr) 				; copy the address
		sta 	zTemp0
		phy
		ldy 	#1
		lda 	(idDataAddr),y
		sta 	zTemp0+1
		ply
		jsr 	_IDCallZTemp0 				; call the routine
		jmp 	Execute

_IDCallZTemp0:
		jmp 	(zTemp0)

; ******************************************************************************
;
;								Handle Return
;
; ******************************************************************************

ProcReturn: ;; [;]
ProcReturn2: ;; [return]

		lda 	(StructSP)					; check it's CALL
		cmp 	#STM_CALL
		ldy 	#1 							; restore the position
		jsr 	StructPopCurrent
		lda 	#5 							; pop 5 elements off structure stack.
		jsr 	StructPopCount
		rts

; ******************************************************************************
;
;						Write TOS to variable at (codePtr),y
;
; ******************************************************************************

WriteVariable: ;; [^]
		lda 	(codePtr),y 				; check variable 
		cmp 	#$C0
		bcc 	_WVTypeError
		;
		jsr 	IdentifierSearch 			; does it exist
		bcc 	_WVNoIdentifier
		;
		cmp 	#IDT_VARIABLE 				; must be a variable
		beq 	_WVWriteTOS 				; if so write TOS to it.
		bra 	_WVTypeError 				; not, then can't do anything.
		;
_WVNoIdentifier:
		phy 								; get current line number
		ldy 	#1
		lda 	(codePtr),y
		iny
		ora 	(codePtr),y
		beq 	_WVCantCreate 				; if zero (command line) no new vars
		ply
		;
		lda 	#IDT_VARIABLE 				; create identifier
		jsr 	IdentifierCreate 			; try to find it
		;
		;		Write TOS to variable.
		;
_WVWriteTOS:		
		dey 								; skip over identifier.
_WVSkipIdentifier:
		lda 	(codePtr),y
		iny
		cmp 	#$E0
		bcc 	_WVSkipIdentifier
		;
		jsr 	IndexCheck 					; check index/subscript
		;
		phy									; copy TOS in
		ldy 	#0
		lda 	stack0,x
		sta 	(idDataAddr),y
		iny
		lda 	stack1,x
		sta 	(idDataAddr),y
		iny
		lda 	stack2,x
		sta 	(idDataAddr),y
		iny
		lda 	stack3,x
		sta 	(idDataAddr),y
		ply
		dex 								; drop 
		;
		;		skip over identifier.
		;
		rts									; go back and execute again.

_WVCantCreate:
		.rerror	"CANNOT CREATE VARIABLE"
_WVTypeError:
		.rerror "WRONG TYPE"
		