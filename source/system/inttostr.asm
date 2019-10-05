; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		inttostr.asm
;		Purpose :	Convert integer to string at current buffer position
;		Date :		4th October 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;				Convert integer in at TOS to ASCII String at Num_Buffer
;
; *******************************************************************************************

IntegerToString:
		pha
		phy
		;
		;			Check sign.
		;
		lda 		stack3,x 				; check -ve
		bpl 		_ITSNotMinus
		lda 		#"-"
		jsr 		ITSOutputCharacter
		jsr 		Unary_Negate
_ITSNotMinus:		
		stz 		SBPosition 				; reset string buffer position
		stz 		NumSuppress 			; clear zero suppression flag
		;
		txa 								; use Y for the integer index.
		tay
		ldx 		#0 						; X is index into dword subtraction table.
		;
		;		Loop round seeing how many times you can subtract each.
		;
_ITSNextSubtractor:		
		lda 		#"0" 					; count of subtractions count in ASCII.
		sta 		NumConvCount
		;
		;		Subtraction attempt loop
		;
_ITSSubtract:
		sec
		lda 		stack0,y 			; subtract number and push on stack
		sbc 		_ITSSubtractors+0,x 	; only update if actually can subtract it.
		pha
		lda 		stack1,y
		sbc 		_ITSSubtractors+1,x
		pha
		lda 		stack2,y
		sbc 		_ITSSubtractors+2,x
		pha
		lda 		stack3,y
		sbc 		_ITSSubtractors+3,x
		bcc 		_ITSCantSubtract 		; if CC, then gone too far, can't subtract
		;
		sta 		stack3,y 		; save subtract off stack as it's okay
		pla 		
		sta 		stack2,y
		pla 		
		sta 		stack1,y
		pla 		
		sta 		stack0,y
		;
		inc 		NumConvCount 			; bump count.
		bra 		_ITSSubtract 			; go round again.
		;
		;			Got here when the mantissa < current subtractor
		;
_ITSCantSubtract:
		pla 								; throw away interim answers
		pla 								; (the subtraction that failed)
		pla
		lda 		NumConvCount 			; if not zero then no suppression check
		cmp 		#"0" 
		bne 		_ITSOutputDigit
		;
		lda 		NumSuppress 			; if suppression check zero, then don't print it.
		beq	 		_ITSGoNextSubtractor
_ITSOutputDigit:
		dec 		NumSuppress 			; suppression check will be non-zero from now on.

		lda 		NumConvCount 			; count of subtractions
		jsr 		ITSOutputCharacter 		; output it.
		;
_ITSGoNextSubtractor:
		inx 								; next dword in subtractor table.
		inx
		inx
		inx
		cpx 		#_ITSSubtractorsEnd-_ITSSubtractors
		bne 		_ITSNextSubtractor 		; do all the subtractors.
		tya 								; X is back as the mantissa index
		tax
		;
		lda 		stack0,x 		; and the last digit is left.
		ora 		#"0"					
		jsr 		ITSOutputCharacter
		ply 								; and exit
		pla
		rts		
;
;		Powers of 10 table.
;
_ITSSubtractors:
		.dword 		1000000000
		.dword 		100000000
		.dword 		10000000
		.dword 		1000000
		.dword 		100000
		.dword 		10000
		.dword 		1000
		.dword 		100
		.dword 		10
_ITSSubtractorsEnd:

; *******************************************************************************************
;
;							Output A to Number output buffer
;
; *******************************************************************************************

ITSOutputCharacter:
		pha
		phx
		ldx 	SBPosition 					; save digit
		sta 	SBuffer,x
		stz 	SBuffer+1,x
		inc 	SBPosition					; bump pointer.
		plx	
		pla
		rts
