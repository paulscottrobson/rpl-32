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
		rts

; *******************************************************************************************
;
;									Load Program
;
; *******************************************************************************************

System_Load: ;; [load]
		jsr 	SLGetFileName 				; get filename -> zTemp0
		jsr 	ExternLoad
		jsr 	ResetForRun 				; re-initialise everything
		rts

; *******************************************************************************************
;
;							Get filename -> zTemp0
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
		sta 	zTemp0+1 					; copy the filename address
		lda 	stack0,x
		sta 	zTemp0
		rts

_SLFNFail:
		rerror	"BAD FILENAME"
