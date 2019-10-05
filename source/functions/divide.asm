; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		divide.asm
;		Purpose :	Divide 32 bit integers
;		Date :		4th October 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

DivInteger32: 	;; [/] 
		dex 

		lda 	stack0+1,x 					; check for division by zero.
		ora 	stack1+1,x
		ora 	stack2+1,x
		ora 	stack3+1,x
		bne 	_BFDOkay
		rerror	"DIVISION BY ZERO"
		;
		;		Reset the interim values
		;
_BFDOkay:
		stz 	zLTemp1 					; Q/Dividend/Left in +0
		stz 	zLTemp1+1 					; M/Divisor/Right in +4
		stz 	zLTemp1+2
		stz 	zLTemp1+3
		stz 	SignCount 					; Count of signs.
		;
		;		Remove and count signs from the integers.
		;
		jsr 	CheckIntegerNegate 			; negate (and bump sign count)
		inx
		jsr 	CheckIntegerNegate
		dex

		phy 								; Y is the counter
		;
		;		Main division loop
		;
		ldy 	#32 						; 32 iterations of the loop.
_BFDLoop:
		asl 	stack0,x 					; shift AQ left.
		rol 	stack1,x
		rol 	stack2,x
		rol 	stack3,x
		rol 	zLTemp1
		rol 	zLTemp1+1
		rol 	zLTemp1+2
		rol 	zLTemp1+3
		;
		sec
		lda 	zLTemp1+0 					; Calculate A-M on stack.
		sbc 	stack0+1,x
		pha
		lda 	zLTemp1+1
		sbc 	stack1+1,x
		pha
		lda 	zLTemp1+2
		sbc 	stack2+1,x
		pha
		lda 	zLTemp1+3
		sbc 	stack3+1,x
		bcc 	_BFDNoAdd
		;
		sta 	zLTemp1+3 					; update A
		pla
		sta 	zLTemp1+2
		pla
		sta 	zLTemp1+1
		pla
		sta 	zLTemp1+0
		;
		lda 	stack0,x 			; set Q bit 1.
		ora 	#1
		sta 	stack0,x
		bra 	_BFDNext
_BFDNoAdd:
		pla 								; Throw away the intermediate calculations
		pla
		pla		
_BFDNext:									; do 32 times.
		dey
		bne 	_BFDLoop
		ply 								; restore Y
		;
		lsr 	SignCount 					; if sign count odd,
		bcs		IntegerNegateAlways 		; negate the result
		rts

; *******************************************************************************************
;
;						Check / Negate integer, counting negations
;
; *******************************************************************************************

CheckIntegerNegate:
		lda 	stack3,x 					; is it -ve = MSB set ?
		bmi 	IntegerNegateAlways 		; if so negate it
		rts
IntegerNegateAlways:
		inc 	SignCount 					; bump the count of signs
		jmp 	Unary_Negate
		
; *******************************************************************************************
;
;								Modulus uses the division code
;
; *******************************************************************************************

ModInteger32:	;; [mod]
		jsr 	DivInteger32
		lda 	zLTemp1
		sta 	stack0,x
		lda 	zLTemp1+1
		sta 	stack1,x
		lda 	zLTemp1+2
		sta 	stack2,x
		lda 	zLTemp1+3
		sta 	stack3,x
		rts

