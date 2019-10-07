; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		editor.asm
;		Purpose :	Edit Program
;		Date :		7th October 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;									Editor Program
;
; *******************************************************************************************

EditProgram:
		ldx 	#0
		lda 	#(TokeniseBuffer+3) & $FF
		sta 	codePtr
		lda 	#(TokeniseBuffer+3) >> 8
		sta 	codePtr+1
		ldy 	#0
		;
		ldx 	#255
		jsr 	ExtractIntegerToTOS
		;
		tya
		clc
		adc 	codePtr
		sta 	codePtr
		bcc 	_EPNoCarry
		inc 	codePtr+1
_EPNoCarry:
		jsr 	EDFindLine
		bcc 	_EPNotFound

		lda 	zTemp1
		pha
		lda 	zTemp1+1
		pha
		jsr 	EDDeleteLine
		pla
		sta 	zTemp1+1
		pla 
		sta 	zTemp1
_EPNotFound:
		lda 	(codePtr)
		beq 	_EPNoInsert
		jsr 	EDInsertLine
_EPNoInsert:
		jsr 	ResetForRun
		jmp 	NewCommand

; *******************************************************************************************
;
;		Find line. If found then return CS and zTemp1 points to the line. If
;		not found return CC and zTemp1 points to the next line after it.
;
;		Line# is in stack entry 0
;
; *******************************************************************************************

EDFindLine:		
		lda 	#ProgramStart & $FF 		; set zTemp1 to start of program 
		sta 	zTemp1
		lda 	#ProgramStart >> 8 			
		sta 	zTemp1+1
_EDFLLoop:
		ldy 	#0 							; reached the end
		lda 	(zTemp1),y 	
		beq 	_EDFLFail 					; then obviously that's the end ;-) (great comment !)
		;
		iny
		sec
		lda 	stack0						; subtract the current from the target
		sbc 	(zTemp1),y 					; so if searching for 100 and this one is 90, 
		tax	 								; this will return 10.
		lda 	stack1
		iny
		sbc 	(zTemp1),y
		bcc 	_EDFLFail					; if target < current then failed.
		bne 	_EDFLNext 					; if non-zero then goto next
		cpx 	#0 							; same for the LSB - zero if match found.
		beq 	_EDFLFound
_EDFLNext:									; go to the next.
		ldy 	#0 							; get offset
		clc 
		lda 	(zTemp1),y					
		adc 	zTemp1 						; add to pointer
		sta 	zTemp1
		bcc 	_EDFLLoop
		inc 	zTemp1+1 					; carry out.
		bra 	_EDFLLoop
_EDFLFail:
		clc
		rts		
_EDFLFound:
		sec
		rts		

; *******************************************************************************************
;
;								Delete line at zTemp1
;
; *******************************************************************************************

EDDeleteLine:	
		ldy 	#0 							; this is the offset to copy down.
		ldx 	#0
		lda 	(zTemp1),y
		tay 								; put in Y
_EDDelLoop:
		lda 	(zTemp1),y 					; get it
		sta 	(zTemp1,x) 					; write it.
		;
		lda 	zTemp1 						; check if pointer has reached the end of 
		cmp		VarMemory 					; low memory. We will have copied down an
		bne 	_EDDelNext 					; extra pile of stuff - technically should
		lda 	zTemp1+1 					; check the upper value (e.g. zTemp1+y)
		cmp 	VarMemory+1					; doesn't really matter.
		beq		_EDDelExit
		;
_EDDelNext:		
		inc 	zTemp1 						; go to next byte.
		bne 	_EDDelLoop
		inc 	zTemp1+1
		bra 	_EDDelLoop
_EDDelExit:
		jsr 	ResetVarMemory
		rts 	

; *******************************************************************************************
;
;						Insert line at (codePtr) in program space at (zTemp1)
;
;						Line Number at xStack,x
;
; *******************************************************************************************

EDInsertLine:
		lda 	VarMemory 					; copy high memory to zTemp3
		sta 	zTemp3
		lda 	VarMemory+1
		sta 	zTemp3+1
		;
		;		Work out in Y, the line length in pure characters - so NO offset,
		; 		line number or end marker. So A= 4 is 3.
		;
		ldy 	#0 							; work out the line length.
_EDGetLength:
		lda 	(codePtr),y  				; get token
		beq 	_EDGotLength 				; if 0, Y is the length
		iny
		cmp 	#3 							; 1 and 2 are ASCIIZ strings so skip them.
		bcs 	_EDGetLength
		tya 								; get original position
		dec 	a
		clc
		adc 	(codePtr),y
		tay
		bra 	_EDGetLength
		;
		;		Shift up memory to make room. Use VarMemory as we'll reset it after.
		;
_EDGotLength:
		tya
		clc
		adc 	#1+2+1 						; size required. 1 for offset, 2 for line#, 1 for end.
		pha 								; save total size (e.g. offset)
		sta 	zTemp4 						; save for copying
		tay 								; in Y
		ldx 	#0 			
_EDInsLoop:
		lda 	(zTemp3,x)					; copy it up
		sta 	(zTemp3),y
		;
		lda 	zTemp3 						; reached the insert point (zTemp1)
		cmp 	zTemp1
		bne 	_EDINextShift
		lda 	zTemp3+1
		cmp 	zTemp1+1
		beq 	_EDIShiftOver
		;
_EDINextShift:		
		lda 	zTemp3 					; decrement the copy pointer.
		bne 	_EDINoBorrow
		dec 	zTemp3+1
_EDINoBorrow:
		dec 	zTemp3			
		bra 	_EDInsLoop
		;
		;		Shift is done. So copy the new stuff in.
		;
_EDIShiftOver:		
		pla 								; this is the size + others, e.g. offset
		ldy 	#0 			 							
		sta 	(zTemp3),y 					; write that out.
		lda 	stack0 						; write LIne# out
		iny
		sta 	(zTemp3),y
		lda 	stack1
		iny
		sta 	(zTemp3),y
		iny 								; where the code goes.
		;
		;		Finally copy in the tokenised code.
		;
		ldx 	#0 							; comes from
_EDICopyCode:
		lda 	(codePtr,x)					; read from the current line
		sta 	(zTemp3),y 					; write out
		iny 								; bump pointers
		inc 	codePtr	
		bne 	_EDINoCarry
		inc 	codePtr+1
_EDINoCarry:	
		dec 	zTemp4 						; copy data in
		lda 	zTemp4 						; this is the total count - first 3 bytes seperate
		cmp 	#3 							; so exit on 3
		bne 	_EDICopyCode
		rts

