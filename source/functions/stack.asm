; ******************************************************************************
; ******************************************************************************
;
;		Name : 		stack.asm
;		Purpose : 	Stack functions
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								Clear Stack
;
; ******************************************************************************

Stack_Empty: 	;; [clr]
		ldx 	#0
		rts

; ******************************************************************************
;
;									Drop TOS
;
; ******************************************************************************

Stack_Drop: 	;; [drop]
		dex
		rts

; ******************************************************************************
;
;								  Duplicate TOS
;
; ******************************************************************************

Stack_Dup:		;; [dup]
		lda 	stack0,x					; copy to next up
		sta 	stack0+1,x
		lda 	stack1,x
		sta 	stack1+1,x
		lda 	stack2,x
		sta 	stack2+1,x
		lda 	stack3,x
		sta 	stack3+1,x
		inx 								; bump stack pointer
		rts

; ******************************************************************************
;
;									Nip 2nd on stack
;
; ******************************************************************************

Stack_Nip: 	;; [nip]
		lda 	stack0,x	 				; copy top to 2nd
		sta 	stack0-1,x
		lda 	stack1,x
		sta 	stack1-1,x
		lda 	stack2,x
		sta 	stack2-1,x
		lda 	stack3,x
		sta 	stack3-1,x
		dex 								; drop tos
		rts

; ******************************************************************************
;
;								Copy 2nd on stack to TOS
;
; ******************************************************************************

Stack_Over:		;; [over]
		lda 	stack0-1,x				; copy to next up
		sta 	stack0+1,x
		lda 	stack1-1,x
		sta 	stack1+1,x
		lda 	stack2-1,x
		sta 	stack2+1,x
		lda 	stack3-1,x
		sta 	stack3+1,x
		inx 							; bump stack pointer
		rts

; ******************************************************************************
;
;								Swap top two values
;
; ******************************************************************************

sswap:	.macro
		lda 	\1,x
		tay
		lda 	\1-1,x
		sta 	\1,x
		tya
		sta 	\1-1,x
		.endm

Stack_Swap:		;; [swap]
		phy
		.sswap 	stack0
		.sswap 	stack1
		.sswap 	stack2
		.sswap 	stack3
		ply
		rts		

	