; *******************************************************************************************
; *******************************************************************************************
;
;		Name : 		saveload.asm
;		Purpose :	Save/Load program
;		Date :		8th October 2019
;		Author : 	Paul Robson (paul@robsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

; *******************************************************************************************
;
;									Save Program
;
; *******************************************************************************************

System_Save: ;; [save]
		jsr 	ResetVarMemory 				; make sure start/end are right
		jsr 	SLGetFileName 				; get filename -> zTemp0
		jsr 	ExternSave
		jmp 	WarmStart

; *******************************************************************************************
;
;									Load Program
;
; *******************************************************************************************

System_Load: ;; [load]
		jsr 	SLGetFileName 				; get filename -> zTemp0
		jsr 	ExternLoad
		jsr 	ResetForRun 				; re-initialise everything
		jmp 	WarmStart
		
; *******************************************************************************************
;
;							Get filename -> zTemp1
;
; *******************************************************************************************

SLGetFileName:
		cpx 	#0 							; gotta be something on the stack
		beq 	_SLFNFail
		lda 	stack2,x 					; must be a tokenise buffer address
		ora 	stack3,x
		bne 	_SLFNFail
		lda 	stack1,x
		cmp 	#TokeniseBuffer >> 8
		bne 	_SLFNFail
		sta 	zTemp1+1 					; copy the filename address to zTemp0/1
		lda 	stack0,x
		sta 	zTemp1

		lda 	#InputBuffer & $FF 			; f/n in input buffer.
		sta 	zTemp0
		lda 	#InputBuffer >> 8
		sta 	zTemp0+1

		phx 								; save XY
		phy
		ldy 	#255 						; go to the end, copying into input buffer
_SLCheckEnd: 								; (it may be in the tokenised buffer.)
		iny
		lda 	(zTemp1),y
		sta 	InputBuffer,y
		bne 	_SLCheckEnd 	
		sty 	zTemp2 						; save end position
		;
		ldx 	#3 							; check to see if ends in .RPL
_SLCheckDotRPL:
		dey 
		lda 	_SLEXT,x
		cmp 	(zTemp1),y
		bne 	_SLNotMatch
		dex
		bpl 	_SLCheckDotRPL
		bra 	_SLExit 					; yes it does
		;
_SLNotMatch: 								; it doesn't, add it.
		ldx 	#0
		ldy 	zTemp2 
_SLAppend:
		lda 	_SLEXT,x
		sta 	(zTemp0),y
		beq 	_SLExit
		inx
		iny
		bra 	_SLAppend		
_SLExit:
		ply		
		plx
		rts

_SLFNFail:
		rerror	"BAD FILENAME"

_SLEXT:	
		.text 	".RPL",0
