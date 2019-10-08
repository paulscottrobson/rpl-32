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
		lda 	stack1,x					; check 0-32767 allocated.
		and 	#$80
		ora 	stack2,x
		ora 	stack3,x
		bne 	_ALBad
		;
		sec 								; subtract from alloc ptr returning
		lda 	AllocMemory 				; address
		sbc 	stack0,x
		sta 	AllocMemory
		sta 	stack0,x
		;
		lda 	AllocMemory+1
		sbc 	stack1,x
		sta 	AllocMemory+1
		sta 	stack1,x
		;
		cmp 	VarMemory+1 				; check range
		beq 	_ALBad
		bcc 	_ALBad
		;
		rts

_ALBad:	rerror 	"BAD ALLOC"		