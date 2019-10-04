; ******************************************************************************
; ******************************************************************************
;
;		Name : 		fornext.asm
;		Purpose : 	For/Next loop
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	4th October 2019
;
; ******************************************************************************
; ******************************************************************************
;
;		+0 		'F'			for marker
;		+1..4	~count 		current inverted count. This is incremented
;							and times out when it becomes $FFFFFFFF
;		+5..8 	loop 		Loop Position (codePtr, Y, bank)
;
; ******************************************************************************

; ******************************************************************************
;
;								FOR loop
;
; ******************************************************************************

Command_For: ;; [for]
		jsr 	StructPushCurrent 			; push current on the stack.
		;
		lda 	stack0,x 					; check zero
		ora 	stack1,x
		ora 	stack2,x
		ora 	stack3,x
		beq 	_CFZero
		;
		lda 	stack3,x 					; push 1's complement of index on 
		eor 	#$FF 						; structure stack.
		pushstruct		
		lda 	stack2,x
		eor 	#$FF
		pushstruct		
		lda 	stack1,x
		eor 	#$FF
		pushstruct		
		lda 	stack0,x
		eor 	#$FF
		pushstruct								
		;
		dex 								; pop stack value
		;
		lda 	#STM_FOR 					; push FOR marker
		pushstruct
		;
		lda 	StructSP 					; copy current so it can access it.
		sta 	ForAddr
		lda 	StructSP+1
		sta 	ForAddr+1
		rts
		
_CFZero:rerror 	"FOR count zero"

; ******************************************************************************
;
;									NEXT loop
;
; ******************************************************************************

Command_Next: ;; [next]
		lda 	(StructSP)					; check it's FOR.
		cmp 	#STM_FOR
		bne 	_CNNoFor
		;
		phy
		ldy 	#0
_CNIncrement:
		iny
		lda 	(StructSP),y 				; increment the index
		inc 	a
		sta 	(StructSP),y
		beq		_CNIncrement 				; carry out.
		;
		ldy 	#1 							; now and all the counts together
		lda 	(StructSP),y 				; on the last time round they 
		iny 								; will all be $FF
		and 	(StructSP),y
		iny
		and 	(StructSP),y
		iny
		and 	(StructSP),y
		;
		ply 								; restore Y
		inc 	a 							; so this will be zero last time round
		bne 	_CNLoop 					; loop back if non-zero
		;
		lda 	#9 							; pop 9 elements off structure stack.
		jsr 	StructPopCount
		rts
;
_CNLoop:	
		lda 	StructSP 					; copy current so it can access it.
		sta 	ForAddr
		lda 	StructSP+1
		sta 	ForAddr+1
		;
		ldy 	#5 							; restore the position
		jsr 	StructPopCurrent
		rts

_CNNoFor:
		rerror	"Missing FOR"		

; ******************************************************************************
;
;								Get current Index
;
; ******************************************************************************

Command_Index: ;; [index]
		phy
		;
		ldy 	#1 							; get the stack position of 
		;
		inx
		sec
		lda 	#$FE
		sbc 	(ForAddr),y
		sta 	stack0,x
		iny
		lda 	#$FF
		sbc 	(ForAddr),y
		sta 	stack1,x
		iny
		lda 	#$FF
		sbc 	(ForAddr),y
		sta 	stack2,x
		iny
		lda 	#$FF
		sbc 	(ForAddr),y
		sta 	stack3,x

		ply
		rts
