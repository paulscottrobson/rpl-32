; ******************************************************************************
; ******************************************************************************
;
;		Name : 		repeat.asm
;		Purpose : 	Repeat/Until loop
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	6th October 2019
;
; ******************************************************************************
; ******************************************************************************
;
;		+0 		'R'			Repeat marker
;		+1..4 	loop 		Loop Position (codePtr, Y, bank)
;
; ******************************************************************************

; ******************************************************************************
;
;								REPEAT top
;
; ******************************************************************************

Command_Repeat: ;; [repeat]
		jsr 	StructPushCurrent 			; push current on the stack.
		lda 	#STM_REPEAT 				; push marker
		pushstruct
		rts

; ******************************************************************************
;
;									UNTIL loop
;
; ******************************************************************************

Command_Until: ;; [until]
		lda 	(StructSP)					; check it's REPEAT
		cmp 	#STM_REPEAT
		bne 	_CUNoRepeat
		;
		dex 								; pop
		lda 	stack0+1,x 					; check old TOS zero
		ora 	stack1+1,x
		ora 	stack2+1,x
		ora 	stack3+1,x
		beq 	_CULoop
		lda 	#5 							; pop 5 elements off structure stack.
		jsr 	StructPopCount
		rts
		;
_CULoop:		
		ldy 	#1 							; restore the position
		jsr 	StructPopCurrent
		rts

_CUNoRepeat:
		rerror	"MISSING REPEAT"		
