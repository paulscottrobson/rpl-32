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

