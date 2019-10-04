; ******************************************************************************
; ******************************************************************************
;
;		Name : 		variables.asm
;		Purpose : 	Variable Read/Write
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
		cmp 	#IDT_VARIABLE 				; must be a variable
		bne 	IDTypeError
		;
_IDSkip:iny
		lda 	(codePtr),y
		cmp 	#$C0
		bcs 	_IDSkip		
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
		rts

_IDUnknown:
		.rerror "Unknown variable"
IDTypeError:
		.rerror	"Variable Required"

; ******************************************************************************
;
;						Write TOS to variable at (codePtr),y
;
; ******************************************************************************

WriteVariable: ;; [^]
		jsr 	IdentifierSearch 			; does it exist
		bcc 	_WVNoIdentifier
		;
		cmp 	#IDT_VARIABLE 				; must be a variable
		beq 	_WVWriteTOS 				; if so write TOS to it.
		bra 	IDTypeError 				; not, then can't do anything.
		;
_WVNoIdentifier:
		phy 								; get current line number
		ldy 	#1
		lda 	(codePtr),y
		iny
		ora 	(codePtr),y
		ply
		beq 	_WVCantCreate 				; if zero (command line) no new vars
		;
		lda 	#IDT_VARIABLE 				; create identifier
		jsr 	IdentifierCreate 			; try to find it
		;
		;		Write TOS to variable.
		;
_WVWriteTOS:		
		dey 								; skip over identifier.
_WVSkipIdentifier:
		iny
		lda 	(codePtr),y
		cmp 	#$C0
		bcs 	_WVSkipIdentifier
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
		jmp 	Execute 					; go back and execute again.

_WVCantCreate:
		.rerror	"Cannot create variable"

		