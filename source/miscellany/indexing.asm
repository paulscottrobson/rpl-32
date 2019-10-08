; ******************************************************************************
; ******************************************************************************
;
;		Name : 		indexing.asm
;		Purpose : 	Handle array indexing / subscripts
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	4th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;		  Address of variable data in idDataAddr - check for indexing.
;
; ******************************************************************************

IndexCheck:
		lda 	(codePtr),y 				; check next character
		cmp 	#KWD_LSQPAREN 				; is it [ ?
		bne 	_ICExit
		iny
		lda 	(codePtr),y 				; next is ] ?
		cmp 	#KWD_RSQPAREN
		beq 	_ICArrayAccess
		and 	#$C0 						; is it a constant
		cmp 	#$80
		beq 	_ICConstAccess 
_ICSyntax:
		jmp 	SyntaxError
		;
_ICExit:
		rts
		;
		;		Subscript by constant
		;
_ICConstAccess:
		lda 	(codePtr),y 				; get constant, copy in.
		and 	#$3F 						; to subscript in zTemp1
		sta 	zTemp1
		stz 	zTemp1+1
		iny
		lda 	(codePtr),y 				; get next
		iny
		cmp 	#KWD_CONSTANT_PLUS 			; ok if K+
		bne 	_ICSyntax
		lda 	(codePtr),y 				; get next
		iny
		cmp 	#KWD_RSQPAREN 				; ok if ]
		bne 	_ICSyntax		
		bra 	_ICAddSubscript
		;
		;		Subscript by TOS
		;		
_ICArrayAccess:
		iny 								; point to next
		;
		lda 	stack0,x 					; copy TOS to zTemp1
		sta 	zTemp1 						; no point in the rest !
		lda 	stack1,x
		sta 	zTemp1+1
		dex
		;
_ICAddSubscript:
		asl 	zTemp1 						; subscript x 4
		rol 	zTemp1+1
		asl 	zTemp1 						
		rol 	zTemp1+1
		;
		phy 								
		lda 	(idDataAddr)				; check indirecting through 0
		ldy 	#1 
		ora 	(idDataAddr),y 				; probably means uninitialised
		iny
		ora 	(idDataAddr),y
		iny
		ora 	(idDataAddr),y
		beq 	_ICZero

		clc									; add zTemp1 to value at (idDataAddr)
		lda 	(idDataAddr)
		adc 	zTemp1
		pha
		;
		ldy 	#1
		lda 	(idDataAddr),y
		adc 	zTemp1+1
		sta 	idDataAddr+1 				; write it out		
		pla
		sta 	idDataAddr
		;
		stz 	idDataAddr+2 				; extend to 32 bits
		stz 	idDataAddr+3
		ply
		rts

_ICZero:
		.rerror "UNINITIALISED ARRAY"		

