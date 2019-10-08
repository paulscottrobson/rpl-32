; ******************************************************************************
; ******************************************************************************
;
;		Name : 		extern.asm
;		Purpose : 	External functionality
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;							Extern Initialise
;
; ******************************************************************************

ExternInitialise:
		lda 	#$07 						; set colour
		sta 	646
;		lda 	#14							; lower case
;		jsr 	$FFD2
		lda 	#147 						; clear screen
		jsr 	$FFD2
		lda 	#COL_WHITE 					; white text.
		jmp 	ExternColour

; ******************************************************************************
;
;								Break Check
;
; ******************************************************************************

ExternCheckBreak:
		phx 								; make sure we keep XY
		phy
		jsr 	$FFE1						; STOP check on CBM KERNAL
		beq		_ECBExit 					; stopped
		ply 								; restore and exit.
		plx
		rts

_ECBExit:
		jmp 	WarmStart

; ******************************************************************************
;
;									Print A
;
; ******************************************************************************

ExternPrint:
		pha
		phx
		phy
		jsr 	$FFD2
		ply
		plx
		pla
		rts

; ******************************************************************************
;
;								 Switch colours
;
; ******************************************************************************

ExternColour:
		pha
		phx
		tax 	
		lda 	_ECTable,x
		jsr 	ExternPrint
		plx
		pla
		rts

_ECTable:
		.byte 	144
		.byte 	28
		.byte 	30
		.byte 	158
		.byte 	31
		.byte 	156
		.byte 	159
		.byte 	5

; ******************************************************************************
;
;			  Input a command, ASCII U/C String in InputBuffer
;
; ******************************************************************************

ExternInput:
		lda 	#(InputBuffer & $FF)
		sta 	zTemp0
		lda 	#(InputBuffer >> 8)
		sta 	zTemp0+1
		lda 	#COL_WHITE
		jsr 	ExternColour
_EIRead:jsr 	$FFCF
		cmp 	#13
		beq 	_EIExit
		sta 	(zTemp0)
		inc 	zTemp0
		bne 	_EIRead
		inc 	zTemp0+1
		bra 	_EIRead
_EIExit:lda 	#0
		sta 	(zTemp0)
		lda 	#13
		jsr 	ExternPrint
		rts

