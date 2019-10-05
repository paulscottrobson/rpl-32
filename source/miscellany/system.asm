; ******************************************************************************
; ******************************************************************************
;
;		Name : 		system.asm
;		Purpose : 	System functions
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;									Run a Program
;
; ******************************************************************************

System_RUN: 	;; [run]
		jsr		ResetForRun 				; clear vars, stacks etc.
		jsr 	ResetCodePointer 			; point to first thing to do.
		jmp 	Execute						; and run

; ******************************************************************************
;
;									Run a Program
;
; ******************************************************************************

System_END: ;; [end]
		.byte 	$FF
		jmp 	WarmStart

; ******************************************************************************
;
;									Stop a Program
;
; ******************************************************************************

System_STOP: ;; [stop]
		jmp 	$FFFF
		.rerror "STOP"

; ******************************************************************************
;
;									Assert
;
; ******************************************************************************

System_Assert: ;; [assert]
		dex
		lda 	stack0+1,x
		ora 	stack1+1,x
		ora 	stack1+2,x
		ora 	stack1+3,x
		bne 	_SAOkay
		.rerror "ASSERT"
_SAOkay:rts		

; ******************************************************************************
;
;									New Program
;
; ******************************************************************************

System_New: ;; [new]		
		stz 	ProgramStart 				; zero the first offset, erases.
		jsr		ResetForRun 				; clear vars, stacks etc.
		rts

; ******************************************************************************
;
;									Old Program
;
; ******************************************************************************
		
System_Old: ;; [old]
		jsr 	ResetCodePointer 			; start of first line.
_SOFindZero:
		lda 	(codePtr),y 				; look for trailing $00
		beq 	_SOFoundEnd
		iny				
		bne 	_SOFindZero
		rerror 	"CANNOT RECOVER"			; couldn't find it.
;
_SOFoundEnd:
		iny 								; update the offset
		sty 	ProgramStart		
		jsr 	ResetForRun 				; redo all stacks etc.
		rts

; ******************************************************************************
;
;								Call Machine Code
;
; ******************************************************************************

System_Sys: ;; [sys]

		lda 	stack0,x 					; copy and drop call address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		dex

		phx
		phy

		lda 	AZVariables+('A'-'A')*4		; load AXY
		ldx 	AZVariables+('X'-'A')*4
		ldy 	AZVariables+('Y'-'A')*4
		;
		jsr 	_SSCall 					; effectively jsr (zTemp)
		;
		sta 	AZVariables+('A'-'A')*4 	; store AXY
		stx 	AZVariables+('X'-'A')*4
		sty 	AZVariables+('Y'-'A')*4

		ply
		plx
		rts

_SSCall:jmp 	(zTemp0)
