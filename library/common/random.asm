; ******************************************************************************
; ******************************************************************************
;
;		Name : 		random.asm
;		Purpose : 	32 bit RNG
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	9th October 2019
;
; ******************************************************************************
; ******************************************************************************

		.section 	dataArea
RandomSeed:
		.dword 		?
		.send 		dataArea

System_Random:	;; [rnd]
	lda 	RandomSeed
	ora 	RandomSeed+1
	ora 	RandomSeed+2
	ora 	RandomSeed+3
	bne 	_SRSeeded
	inc 	RandomSeed+1
	dec 	RandomSeed+3
	jsr 	System_Random
_SRSeeded:
	phy
	ldy RandomSeed+2 ; will move to RandomSeed+3 at the end
	lda RandomSeed+1
	sta RandomSeed+2
	; compute RandomSeed+1 ($C5>>1 = %1100010)
	lda RandomSeed+3 ; original high byte
	lsr
	sta RandomSeed+1 ; reverse: 100011
	lsr
	lsr
	lsr
	lsr
	eor RandomSeed+1
	lsr
	eor RandomSeed+1
	eor RandomSeed+0 ; combine with original low byte
	sta RandomSeed+1
	; compute RandomSeed+0 ($C5 = %11000101)
	lda RandomSeed+3 ; original high byte
	asl
	eor RandomSeed+3
	asl
	asl
	asl
	asl
	eor RandomSeed+3
	asl
	asl
	eor RandomSeed+3
	sty RandomSeed+3 ; finish rotating byte 2 into 3
	sta RandomSeed+0

	inx
	lda	RandomSeed+0
	sta stack0,x
	lda	RandomSeed+1
	sta stack1,x
	lda	RandomSeed+2
	sta stack2,x
	lda	RandomSeed+3
	sta stack3,x
	ply
	rts

