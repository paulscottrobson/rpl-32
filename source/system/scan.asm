; ******************************************************************************
; ******************************************************************************
;
;		Name : 		scan.asm
;		Purpose : 	Scan the available code for procedures
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;		Scan through the code looking for def [spaces?] [identifier]. Add
;		the identifier to the identifier system as a procedure type, and
;		set its value to the first non-space byte after the identifier.
;
; ******************************************************************************

ProcedureScan:		
		jsr 	ResetCodePointer 			; reset the code pointer.
		;
		;		Scan loop
		;
_PSMain:lda 	(codePtr)					; check if end
		beq 	_PSExit
		ldy 	#3 							; start of line
		lda 	(codePtr),y 				; skip over spaces
		cmp 	#KWD_DEF 					; first thing is DEF ?
		bne 	_PSNext
		iny 								; skip over def first, any following spaces
		lda 	(codePtr),y
		;
		lda 	#IDT_PROCEDURE 				; create a procedure 
		jsr 	IdentifierCreate
		;
_PSSkipIdentifier: 							; go past the identifier.
		lda 	(codePtr),y
		iny
		cmp 	#$C0
		bcs 	_PSSkipIdentifier
		dey 								; undo last, points at first non ID
		tya  								; save the address in the data slot.
		clc 								; changing Y doesn't matter.
		adc 	codePtr
		sta 	(idDataAddr)
		lda 	codePtr+1
		adc 	#0
		ldy 	#1
		sta 	(idDataAddr),y
		;
_PSNext:
		clc 								; go to next
		lda 	(codePtr)		
		adc 	codePtr
		sta 	codeptr
		bcc 	_PSMain
		inc 	codePtr+1
		bra 	_PSMain
_PSExit:				
		rts
		
		