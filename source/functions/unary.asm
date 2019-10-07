; ******************************************************************************
; ******************************************************************************
;
;		Name : 		unary.asm
;		Purpose : 	Unary functions
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;									Unary Absolute
;
; ******************************************************************************

Unary_Absolute: 	;; [abs]
		lda 	stack3,x
		bmi 	Unary_Negate
		rts
		
; ******************************************************************************
;
;									Unary Negation
;
; ******************************************************************************

Unary_Negate: 	;; [negate]
		sec
		lda		#0
		sbc 	stack0,x
		sta 	stack0,x
		;
		lda		#0
		sbc 	stack1,x
		sta 	stack1,x
		;
		lda		#0
		sbc 	stack2,x
		sta 	stack2,x
		;
		lda		#0
		sbc 	stack3,x
		sta 	stack3,x
		rts

; ******************************************************************************
;
;									Unary 1's Complement
;
; ******************************************************************************

Unary_Not: 	;; [not]
		lda 	stack0,x
		eor 	#$FF
		sta 	stack0,x
		;
		lda 	stack1,x
		eor 	#$FF
		sta 	stack1,x
		;
		lda 	stack2,x
		eor 	#$FF
		sta 	stack2,x
		;
		lda 	stack3,x
		eor 	#$FF
		sta 	stack3,x
		rts

; ******************************************************************************
;
;									Unary Increment
;
; ******************************************************************************

Unary_Increment: ;; [++]
		inc 	stack0,x
		bne 	_UIExit
		inc 	stack1,x
		bne 	_UIExit
		inc 	stack2,x
		bne 	_UIExit
		inc 	stack3,x
_UIExit:
		rts		

; ******************************************************************************
;
;									Unary Increment
;
; ******************************************************************************

Unary_Decrement: ;; [--]
		sec 
		lda 	stack0,x
		sbc 	#1
		sta 	stack0,x
		;
		lda 	stack1,x
		sbc 	#0
		sta 	stack1,x
		;
		lda 	stack2,x
		sbc 	#0
		sta 	stack2,x
		;
		lda 	stack3,x
		sbc 	#0
		sta 	stack3,x
		rts		

; ******************************************************************************
;
;								  Left Shift Logical
;
; ******************************************************************************

Unary_Shl: ;; [<<]
		asl 	stack0,x
		rol 	stack1,x
		rol 	stack2,x
		rol 	stack3,x
		rts		

; ******************************************************************************
;
;								  Right Shift Logical
;
; ******************************************************************************

Unary_Shr: ;; [>>]
		lsr 	stack3,x
		ror 	stack2,x
		ror 	stack1,x
		ror 	stack0,x
		rts		

