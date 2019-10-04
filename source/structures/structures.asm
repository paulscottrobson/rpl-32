; ******************************************************************************
; ******************************************************************************
;
;		Name : 		structures.asm
;		Purpose :	Common structures function
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	4th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;					Pop A bytes off the structure stack
;
; ******************************************************************************

StructPopCount:
		clc
		adc 	StructSP
		sta 	StructSP
		rts

; ******************************************************************************
;
;					Push current position onto stack
;
; ******************************************************************************

StructPushCurrent:
		lda 	#0							; push bank
		pushstruct		
		tya									; y Offset
		pushstruct
		lda 	codePtr+1 					; codeptr high
		pushstruct
		lda 	codePtr 					; codeptr low
		pushstruct		
		rts

; ******************************************************************************
;
;				Pop current position off stack, at (StructSP),y
;
; ******************************************************************************

StructPopCurrent:
		lda 	(StructSP),y 				; codeptr low
		sta 	codePtr
		iny
		lda 	(StructSP),y 				; codeptr high
		sta 	codePtr+1
		iny 								
		lda 	(StructSP),y				; y offset
		tay
		rts		
		