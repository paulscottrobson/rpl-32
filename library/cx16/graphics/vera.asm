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

