; ******************************************************************************
; ******************************************************************************
;
;		Name : 		compare.asm
;		Purpose : 	Simple Compare Functions
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;							Equal/NotEqual check.
;
; ******************************************************************************

Comp_Equal: 	;; [=]
		sec
		bra 	Comp_CheckEqual

Comp_NotEqual:	;; [<>]
		clc
		;
		;		$FF if not equal, $00 if equal, CS flips that.
		;
Comp_CheckEqual:
		php 		
		dex

		lda		stack0,x
		eor 	stack0+1,x
		bne 	_CCENonZero
		;
		lda		stack1,x
		eor 	stack1+1,x
		bne 	_CCENonZero
		;
		lda		stack2,x
		eor 	stack2+1,x
		bne 	_CCENonZero
		;
		lda		stack3,x
		eor 	stack3+1,x
_CCENonZero:	
		beq 	_CCENotSet
		lda 	#$FF 						; $FF if not-equal
_CCENotSet:
		;
		;		At this point, A is $00 or $FF. Popping P off the stack flips that
		;		if the carry flag is set.
		;
CompCheckFlip:		
		plp 								; if carry set, we want $FF if equal
		bcc 	CompReturn
		eor 	#$FF
CompReturn:
		sta 	stack0,x 					; save result on stack.
		sta 	stack1,x
		sta 	stack2,x
		sta 	stack3,x
		rts

; ******************************************************************************
;
;							Less/Greater Equal check.
;
; ******************************************************************************
				
Comp_Less:	;; [<]
		clc
		bra 	Comp_LessCont
Comp_GreaterEqual: ;; [>=]
		sec

Comp_LessCont:
		php
		dex
		sec
		lda 	stack0,x 					; do a subtraction w/o storing the result
		sbc 	stack0+1,x
		lda 	stack1,x
		sbc 	stack1+1,x
		lda 	stack2,x
		sbc 	stack2+1,x
		lda 	stack3,x
		sbc 	stack3+1,x
		;
		bvc 	_CLNoFlip 					; unsigned -> signed
		eor 	#$80
_CLNoFlip:
		and 	#$80 						; 0 if >= here, so flip if CS.
		beq 	CompCheckFlip
		lda 	#$FF 						; -1 if < here, so flip if CS.
		bra 	CompCheckFlip

; ******************************************************************************
;
;							Less Equal/Greater check.
;
; ******************************************************************************
				
Comp_LessEqual:	;; [<=]
		clc
		bra 	Comp_LessEqualCont
Comp_Greater:	;; [>]
		sec

Comp_LessEqualCont:
		php
		dex
		sec
		lda 	stack0+1,x 					; do a subtraction w/o storing the result, backwards
		sbc 	stack0,x
		lda 	stack1+1,x
		sbc 	stack1,x
		lda 	stack2+1,x
		sbc 	stack2,x
		lda 	stack3+1,x
		sbc 	stack3,x
		;
		bvc 	_CLENoFlip 					; unsigned -> signed
		eor 	#$80
_CLENoFlip:
		and 	#$80 						; 0 if > here, so flip if CS
		beq 	CompCheckFlip
		lda 	#$FF 						; -1 if >= here, so flip if CS
		bra 	CompCheckFlip
