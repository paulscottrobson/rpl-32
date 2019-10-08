; ******************************************************************************
; ******************************************************************************
;
;		Name : 		renumber.asm
;		Purpose : 	Renumber lines
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	8th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								Line Renumber
;
; ******************************************************************************

Cmd_Renumber: ;; [renumber]
		lda 	#ProgramStart & $FF
		sta 	zTemp1
		lda 	#ProgramStart >> 8
		sta 	zTemp1+1
		;
		lda 	#1000 & $FF
		sta 	zTemp2
		lda 	#1000 >> 8
		sta 	zTemp2+1

_CRLoop:
		lda 	(zTemp1)
		beq 	_CRExit
		ldy 	#1
		lda 	zTemp2
		sta 	(zTemp1),y
		iny
		lda 	zTemp2+1
		sta 	(zTemp1),y
		;
		clc
		lda 	zTemp2
		adc 	#10
		sta 	zTemp2
		bcc 	_CRNoCarry
		inc 	zTemp2+1
_CRNoCarry:
		;
		clc
		lda 	(zTemp1)
		adc 	zTemp1
		sta 	zTemp1
		bcc 	_CRLoop
		inc 	zTemp1+1
		bra 	_CRLoop


_CRExit:
		rts				
