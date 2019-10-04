; ******************************************************************************
; ******************************************************************************
;
;		Name : 		binary.asm
;		Purpose : 	Simple Binary Functions
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								Add top two values
;
; ******************************************************************************

Stack_Add: 	;; [+]
		dex
		clc
		lda		stack0,x
		adc 	stack0+1,x
		sta 	stack0,x
		;
		lda		stack1,x
		adc 	stack1+1,x
		sta 	stack1,x
		;
		lda		stack2,x
		adc 	stack2+1,x
		sta 	stack2,x
		;
		lda		stack3,x
		adc 	stack3+1,x
		sta 	stack3,x
		rts

; ******************************************************************************
;
;								Sub top two values
;
; ******************************************************************************

Stack_Sub: 	;; [-]
		dex
		sec
		lda		stack0,x
		sbc 	stack0+1,x
		sta 	stack0,x
		;
		lda		stack1,x
		sbc 	stack1+1,x
		sta 	stack1,x
		;
		lda		stack2,x
		sbc 	stack2+1,x
		sta 	stack2,x
		;
		lda		stack3,x
		sbc 	stack3+1,x
		sta 	stack3,x
		rts

; ******************************************************************************
;
;								And top two values
;
; ******************************************************************************

Stack_And: 	;; [and]
		dex
		lda		stack0,x
		and		stack0+1,x
		sta 	stack0,x
		;
		lda		stack1,x
		and 	stack1+1,x
		sta 	stack1,x
		;
		lda		stack2,x
		and 	stack2+1,x
		sta 	stack2,x
		;
		lda		stack3,x
		and 	stack3+1,x
		sta 	stack3,x
		rts

; ******************************************************************************
;
;								Xor top two values
;
; ******************************************************************************

Stack_Xor: 	;; [Xor]
		dex
		lda		stack0,x
		eor		stack0+1,x
		sta 	stack0,x
		;
		lda		stack1,x
		eor 	stack1+1,x
		sta 	stack1,x
		;
		lda		stack2,x
		eor 	stack2+1,x
		sta 	stack2,x
		;
		lda		stack3,x
		eor 	stack3+1,x
		sta 	stack3,x
		rts

; ******************************************************************************
;
;								Or top two values
;
; ******************************************************************************

Stack_Or: 	;; [or]
		dex
		lda		stack0,x
		ora		stack0+1,x
		sta 	stack0,x
		;
		lda		stack1,x
		ora 	stack1+1,x
		sta 	stack1,x
		;
		lda		stack2,x
		ora 	stack2+1,x
		sta 	stack2,x
		;
		lda		stack3,x
		ora 	stack3+1,x
		sta 	stack3,x
		rts

		