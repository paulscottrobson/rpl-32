; ******************************************************************************
; ******************************************************************************
;
;		Name : 		alloc.asm
;		Purpose : 	Allocate Memory
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	8th October 2019
;
; ******************************************************************************
; ******************************************************************************

Allocate: ;; [alloc]
		;.byte 	$FF
		lda 	stack1,x					; check 0-32767 allocated.
		and 	#$80
		ora 	stack2,x
		ora 	stack3,x
		bne 	_ALBad
		;
		clc 								; add to varmemory pointer saving
		lda 	VarMemory 					; address
		pha
		adc 	stack0,x
		sta 	VarMemory
		;
		lda 	VarMemory+1
		pha
		adc 	stack1,x
		sta 	VarMemory+1
		;
		pla 								; pop and save
		sta 	stack1,x
		pla
		sta 	stack0,x
		;
		lda 	stack1,x 	
		cmp 	AllocMemory+1 				; check range
		bcs 	_ALBad
		;
		rts

_ALBad:	rerror 	"BAD ALLOC"		