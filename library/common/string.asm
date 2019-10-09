; ******************************************************************************
; ******************************************************************************
;
;		Name : 		string.asm
;		Purpose : 	String Library
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	9th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;							Length of string on TOS
;
; ******************************************************************************

String_Len: 	;; [str.len]

		lda 	stack0,x 					; copy string address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		;
		phy
		ldy 	#255 						; find string length
_SLLoop:iny
		cpy 	#255 						; cant find EOS.
		beq 	_SLFail
		lda 	(zTemp0),y
		bne 	_SLLoop
		tya
		ply
		;
		sta 	stack0,x 					; return string
		stz 	stack1,x
		stz 	stack2,x
		stz 	stack3,x
		rts

_SLFail:rerror 	"NOT STRING"		

