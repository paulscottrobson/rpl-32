; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		multiply.asm
;		Purpose :	Multiply 32 bit integers
;		Date :		4th October 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

MulInteger32: ;; [*]
		dex

		lda 	stack0,x					; copy +0 to workspace
		sta 	zLTemp1
		lda 	stack1,x			
		sta 	zLTemp1+1
		lda 	stack2,x			
		sta 	zLTemp1+2
		lda 	stack3,x			
		sta 	zLTemp1+3
		;
		stz 	stack0,x 					; zero +0, where the result goes.
		stz 	stack1,x
		stz 	stack2,x
		stz 	stack3,x
		;
_BFMMultiply:
		lda 	zLTemp1 					; get LSBit of 8-11
		and 	#1
		beq 	_BFMNoAdd
		jsr 	Stack_Add_No_Dex 			; co-opt this code
_BFMNoAdd:
		;
		asl 	stack0+1,x 					; shift +4 left
		rol 	stack1+1,x
		rol 	stack2+1,x
		rol 	stack3+1,x
		;
		lsr 	zLTemp1+3 					; shift +8 right
		ror 	zLTemp1+2
		ror 	zLTemp1+1
		ror 	zLTemp1
		;
		lda 	zLTemp1 					; continue if +8 is nonzero
		ora 	zLTemp1+1
		ora 	zLTemp1+2
		ora 	zLTemp1+3
		bne 	_BFMMultiply
		;
		rts
