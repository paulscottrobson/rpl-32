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
;			  (simple, as the line numbers are purely for editing)
;
; ******************************************************************************

Cmd_Renumber: ;; [renumber]
		lda 	#ProgramStart & $FF 		; zTemp1 line number being changed
		sta 	zTemp1
		lda 	#ProgramStart >> 8
		sta 	zTemp1+1
		;
		lda 	#1000 & $FF 				; zTemp2 new number
		sta 	zTemp2
		lda 	#1000 >> 8
		sta 	zTemp2+1

_CRLoop:
		lda 	(zTemp1) 					; check end of program
		beq 	_CRExit
		ldy 	#1 							; copy new number in
		lda 	zTemp2
		sta 	(zTemp1),y
		iny
		lda 	zTemp2+1
		sta 	(zTemp1),y
		;
		clc 								; add 10 to new number
		lda 	zTemp2
		adc 	#10
		sta 	zTemp2
		bcc 	_CRNoCarry
		inc 	zTemp2+1
_CRNoCarry:
		;
		clc 								; go to next line
		lda 	(zTemp1)
		adc 	zTemp1
		sta 	zTemp1
		bcc 	_CRLoop
		inc 	zTemp1+1
		bra 	_CRLoop


_CRExit:
		rts				
