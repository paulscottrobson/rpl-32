; ******************************************************************************
; ******************************************************************************
;
;		Name : 		execute.asm
;		Purpose : 	Main execution loop
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;							Advance to next line
;
; ******************************************************************************

EXNextLine:
		lda 	(codePtr) 					; is it run from the buffer (offset 0)
		beq 	_EXNLWarmStart
		clc 								; advance code pointer to next line
		adc 	codePtr
		sta 	codePtr
		bcc 	_EXNLNoBump
		inc 	codePtr+1
_EXNLNoBump:

		ldy 	#3 							; position in that line
		lda 	(codePtr) 					; read offset
		bne 	Execute 					; not end of program
_EXNLWarmStart:
		jmp 	System_END

; ******************************************************************************
;
;				Execute the next instruction at the code pointer
;
; ******************************************************************************

Execute:
		inc 	BreakCount 					; break occasionally. too slow otherwise.
		bne 	_EXNoBreak
		jsr 	ExternCheckBreak
_EXNoBreak:		
		;
_EXGetNext:		
		lda 	(codePtr),y 				; load the character
		beq 	EXNextLine 					; reached end of the line.
		iny 								; advance pointer.
		cmp 	#KWD_SPACE 					; skip spaces
		beq 	_ExGetNext
		;
		cmp 	#$10 						; is it 01-0F, which means a string/comment ?
		bcc 	EXStringComment
		cmp 	#$80 						; if it 10-7F, token
		bcc 	EXTokenExecute
		cmp 	#$C0 						; is it a numeric constant 80-BF
		bcc 	EXPushConstant 
		jmp 	Identifier 					; it's an identifier C0-FF

; ******************************************************************************
;
;				Extract a numeric constant and push on the stack.
;		
; ******************************************************************************

EXPushConstant:
		dey 
		jsr 	ExtractIntegerToTOS 		; extract integer
		bra 	Execute

; ******************************************************************************
;
;								Execute a token
;		
; ******************************************************************************

EXTokenExecute:
		asl 	a 							; double token, also clears carry
		phx 								; save X, put token x 2 in X
		tax
		lda 	KeywordVectorTable-$20,x 	; copy vector. The -$20 is because the tokens
		sta 	zTemp0 						; start at $10.
		lda 	KeywordVectorTable-$20+1,x
		sta 	zTemp0+1
		plx 								; restore X
		jsr 	_EXTCall 					; call the routine
		bra 	Execute
		;
_EXTCall:
		jmp 	(zTemp0)		

; ******************************************************************************
;
;				Skip, and push optionally, a string address
;		
; ******************************************************************************

EXStringComment:
		cmp 	#$02 						; 02 is the token for single quoted string
		beq 	EXStringSkip 				; (comment), so just skip it.
		;
		inx 								; push Y + 1 + codePtr on the stack
		tya
		sec
		adc 	codePtr
		sta 	stack0,x
		lda 	codePtr+1
		adc 	#0
		sta 	stack1,x
		stz 	stack2,x 					; clear the upper 2 bytes.
		stz 	stack3,x
		;
EXStringSkip:
		tya 								; the current position in A
		clc
		adc 	(codePtr),y					; add the total length
		tay 			 					; and make that the current position.
		dey 								; back one because of the initial skip
		bra 	Execute

; ******************************************************************************
;	
;					Shift 5 byte entity A:Top of Stack right once.
;
; ******************************************************************************

EXShiftTOSRight:
		lsr 	a
		ror 	stack3,x
		ror 	stack2,x
		ror 	stack1,x
		ror 	stack0,x
		rts

; ******************************************************************************
;
;					Extract integer at (codePtr),y to TOS
;
; ******************************************************************************
		
ExtractIntegerToTOS:		
		lda 	(codePtr),y
		iny
		inx 								; make stack space
		and 	#$3F 						; to start with, it's just that value
		sta 	stack0,x
		stz 	stack1,x
		stz 	stack2,x
		stz 	stack3,x
_EXConstantLoop:		
		lda 	(codePtr),y 				; look at next ?
		and 	#$C0 						; in range 80-FF e.g. 10xx xxxx
		cmp 	#$80 
		bne		_EXDone 					; no then exit
		;
		;		First multiply the whole thing by 256, preserving the MSB
		;
		lda 	stack3,x 					; put the MSB in A
		pha
		lda 	stack2,x 					; shift every byte up one, e.g. x 256
		sta 	stack3,x
		lda 	stack1,x
		sta 	stack2,x
		lda 	stack0,x
		sta 	stack1,x
		stz 	stack0,x
		pla
		;
		jsr 	EXShiftTOSRight 				; shift the whole A:Top of Stack right twice
		jsr 	EXShiftTOSRight				; which will be x64
		;
		lda 	(codePtr),y 				; get and skip constant shift
		iny
		and 	#$3F
		ora 	stack0,x 					; or into low byte
		sta 	stack0,x
		bra 	_EXConstantLoop
_EXDone:
		rts		
