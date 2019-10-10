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

; ******************************************************************************
; ******************************************************************************
;
;		Name : 		io.asm
;		Purpose : 	I/O Library
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	10th October 2019
;
; ******************************************************************************
; ******************************************************************************

IO_Clear:	;; [cls]
	lda 	#SCM_CLS
	jmp 	ExternPrint

IO_Emit:	;; [emit]
	lda 	stack0,x
	dex
	jmp 	ExternPrint
; ******************************************************************************
; ******************************************************************************
;
;		Name : 		string.asm
;		Purpose : 	String Library
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	9th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;							Length of string on TOS
;
; ******************************************************************************

String_Len: 	;; [str.len]

		lda 	stack0,x 					; copy string address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		;
		phy
		ldy 	#255 						; find string length
_SLLoop:iny
		cpy 	#255 						; cant find EOS.
		beq 	_SLFail
		lda 	(zTemp0),y
		bne 	_SLLoop
		tya
		ply
		;
		sta 	stack0,x 					; return string
		stz 	stack1,x
		stz 	stack2,x
		stz 	stack3,x
		rts

_SLFail:rerror 	"NOT STRING"

; ******************************************************************************
; ******************************************************************************
;
;		Name : 		vera.asm
;		Purpose : 	CX16 Graphics
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	9th October 2019
;
; ******************************************************************************
; ******************************************************************************

Vera_Base = $9F20
		.section 	dataArea

veraCurrentLayer:
		.byte 		? 						; current layer (0-1)
veraCurrentSprite:
		.byte 		?						; current sprite (0-127)
veraSpriteMode:
		.byte 		? 						; 0 4 bit, 1 8 bit

		.send 		dataArea

; ******************************************************************************
;
;						Set VERA R/W Address [ s -> ]
;
; ******************************************************************************

Vera_SetAddress: ;; [vera.set]
		lda 	stack0,x
		sta 	Vera_Base
		lda 	stack1,x
		sta 	Vera_Base+1
		lda 	stack2,x
		cmp 	#16
		bcs 	_VSASetInc
		ora 	#16
_VSASetInc:
		sta 	Vera_Base+2
		dex
		rts

; ******************************************************************************
;
;						Get VERA R/W Address [ -> s]
;
; ******************************************************************************

Vera_GetAddress: ;; [vera.get]
		inx
		lda 	Vera_Base
		sta 	stack0,x
		lda 	Vera_Base+1
		sta 	stack1,x
		lda 	Vera_Base+2
		sta 	stack2,x
		stz 	stack3,x
		rts

; ******************************************************************************
;
;						  Set Palette [rgb col -> ]
;
; ******************************************************************************

Vera_SetPalette: ;; [vera.palette]
		lda 	stack0,x
		sta 	Vera_Base
		lda 	stack1,x
		and 	#$01
		ora 	#$10
		sta 	Vera_Base+1
		lda 	#$1F
		sta 	Vera_Base+2
		dex
		;
		lda 	stack0,x
		sta 	Vera_Base+3
		lda 	stack1,x
		sta 	Vera_Base+3
		dex
		rts

; ******************************************************************************
;
;							Select working sprite
;
; ******************************************************************************

Vera_Sprite: ;; [vera.s]
		lda 	stack0,x
		and 	#$7F
		sta 	veraCurrentSprite
		dex
		rts

; ******************************************************************************
;
;								Enable/Disable Sprite
;
; ******************************************************************************

Vera_SpriteEnable: ;; [vera.s.on]
		lda 	#1
		bra 	Vera_SpriteControl
Vera_SpriteDisable: ;; [vera.s.off]
		lda 	#0
Vera_SpriteControl:
		pha
		lda 	#$00
		sta 	Vera_Base
		lda 	#$40
		sta 	Vera_Base+1
		lda 	#$1F
		sta 	Vera_Base+2
		pla
		and 	#1
		sta 	Vera_Base+3
		stz 	Vera_Base+3
		rts

; ******************************************************************************
;
;								Move Current Sprite
;
; ******************************************************************************

Vera_SpriteMove: ;; [vera.s.move]
		lda 	#2 							; physical position
		jsr 	Vera_CurrentSprite
		jsr 	_VSMOutPosition
_VSMOutPosition:
		dex
		lda 	stack0+1,x
		sta 	Vera_Base+3
		lda 	stack1+1,x
		and 	#$03
		sta 	Vera_Base+3
		rts

; ******************************************************************************
;
;						Set Sprite Graphic Data address
;
; ******************************************************************************

Vera_SpriteSetup: ;; [vera.s.gfx]
		lda 	#0
		jsr 	Vera_CurrentSprite
		;
		dex
		lda 	stack0+1,x
		sta 	zTemp0
		lda 	stack1+1,x
		sta 	zTemp0+1
		lda 	stack2+1,x
		sta 	zTemp1
		phy
		ldy 	#5
_VSSS:	lsr 	zTemp1
		ror 	zTemp0+1
		ror 	zTemp0
		dey
		bne 	_VSSS
		ply
		lda 	zTemp0
		sta 	Vera_Base+3
		lda 	zTemp0+1
		ora 	veraSpriteMode
		sta 	Vera_Base+3
		;
		rts

; ******************************************************************************
;
;						Set size (0-3) 8x8 16x16 32x32 64x64
;							(also resets depth,flip etc.)
;
; ******************************************************************************

Vera_SetSize: ;; [vera.s.size]
		lda 	#6
		jsr 	Vera_CurrentSprite
		lda 	#$1C
		sta 	Vera_Base+3
		dex
		lda 	stack0+1,x
		and 	#3
		sta 	zTemp0
		asl 	a
		asl 	a
		ora 	zTemp0
		asl 	a
		asl 	a
		asl 	a
		asl 	a
		sta 	Vera_Base+3
		rts

; ******************************************************************************
;
;								Write byte to vera
;
; ******************************************************************************

Vera_ByteW: ;; [vera.w]
		lda 	stack0,x
		sta 	Vera_Base+3
		dex
		rts

; ******************************************************************************
;
;					Point Address to currentSprite x 128 + A
;
; ******************************************************************************

Vera_CurrentSprite:
		pha 								; save offset
		lda 	veraCurrentSprite 			; address in zTemp0
		asl 	a
		sta 	zTemp0		 				; sprite# x 2
		stz 	zTemp0+1
		;
		asl 	zTemp0 						; x 8
		rol 	zTemp0+1
		asl 	zTemp0
		;
		pla 								; fix up address
		ora 	zTemp0
		sta  	Vera_Base+0
		;
		lda 	zTemp0+1
		ora 	#$50
		sta 	Vera_Base+1
		lda 	#$1F
		sta 	Vera_Base+2
		rts
