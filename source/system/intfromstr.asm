; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		intfromstr.asm
;		Purpose :	Convert String to integer
;		Date :		4th October 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;		Convert string at zTemp0 into next stack space. Return CC if okay, CS on error
;		On successful exit Y is the characters consumed from the string. 
;		Does not handle -ve numbers.
;
; *******************************************************************************************

IntFromString:		
		ldy 	#0 							; from (zTemp0)
		sty 	IFSHexFlag
		lda 	(zTemp0)					; check &
		cmp 	#"&"
		bne 	_IFSNotHex
		dec 	IFSHexFlag 					; hex flag = $FF
		iny 								; skip
_IFSNotHex:		
		inx 								; space on stack
		jsr 	IFSClearTOS
;
;		Main conversion loop
;
_IFSLoop:		
		lda 	IFSHexFlag 					; check in hex mode ?
		beq 	_IFSDecOnly
		lda 	(zTemp0),y 					; get next
		cmp 	#"A"
		bcc 	_IFSDecOnly
		cmp 	#"F"+1
		bcc 	_IFSOkDigit		
_IFSDecOnly:
		lda 	(zTemp0),y 					; get next
		cmp 	#"0"						; validate it as range 0-9
		bcc 	_IFSExit
		cmp 	#"9"+1
		bcs 	_IFSExit
		;
		;		Multiply mantissa by 10 or 16
		;
_IFSOkDigit:		
		lda 	IFSHexFlag 	
		bne 	_IFSHexShift
		jsr 	Stack_Dup 					; duplicate tos
		jsr 	Unary_Shl	 				; x 2
		jsr 	Unary_Shl 					; x 4
		jsr 	Stack_Add 					; x 5
		jsr 	Unary_Shl 					; x 10
		bra 	_IFSAddIn
_IFSHexShift:
		jsr 	Unary_Shl	 				; x 2
		jsr 	Unary_Shl	 				; x 4
		jsr 	Unary_Shl	 				; x 8
		jsr 	Unary_Shl	 				; x 16
		;
		;		Add the new value in.
		;
_IFSAddIn:		
		inx  								; create space next up
		jsr 	IFSClearTOS
		lda 	(zTemp0),y 					; add digit		
		cmp 	#"A"
		bcc 	_IFSDec
		sec 								; hex fixup.
		sbc 	#7
_IFSDec:		
		and 	#15
		sta 	stack0,x 					; tos is new add
		jsr 	Stack_Add 					; add to tos
		iny
		bra 	_IFSLoop
;		
_IFSExit:
		tya
		sec
		beq 	_IFSSkipFail
		clc
_IFSSkipFail:		
		rts

IFSClearTOS:
		stz		stack0,x
		stz		stack1,x
		stz		stack2,x
		stz		stack3,x
		rts
