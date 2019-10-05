; ******************************************************************************
; ******************************************************************************
;
;		Name : 		main.asm
;		Purpose : 	RPL/32 Main Program
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								General Syntax Error
;
; ******************************************************************************

SyntaxError:		
		rerror 	"SYNTAX ERROR"

; ******************************************************************************
;
;									Error Handler
;
; ******************************************************************************

ErrorHandler:
		pla 								; pop message address
		sta 	zTemp0
		pla
		sta 	zTemp0+1
		lda 	#CTH_ERROR
		jsr 	ExternColour
		ldy 	#1 							; print it
_ErrorPrint:
		lda 	(zTemp0),y
		jsr		ExternPrint
		iny
		lda 	(zTemp0),y
		bne 	_ErrorPrint 			
		;
		ldy 	#1 							; check if line# 0
		lda		(codePtr),y
		iny
		ora 	(codePtr)
		beq 	_ErrorNoLine 				; if so, skip
		lda 	#32
		jsr 	ExternPrint
		lda 	#'@'
		jsr 	ExternPrint
		lda 	#32
		jsr 	ExternPrint
		;
		ldy 	#1 							; load current line into YA
		lda 	(codePtr),y
		pha
		iny
		lda 	(codePtr),y
		tay
		pla		
		jsr 	ErrorPrint16 				; print YA as unsigned 16 bit integer.
		;
_ErrorNoLine:
		lda 	#13							; new line
		jsr 	ExternPrint
		jmp 	WarmStart

WarmStart:	
		jmp		WarmStart
		.byte 	$FF		

; ******************************************************************************
;
;			   Print YA as a 16 bit integer. Return digit count in A
;
; ******************************************************************************

ErrorPrint16:
		phx
		inx 								; space on stack
		sta 	stack0,x					; save on TOS
		tya
		sta 	stack1,x
		stz 	stack2,x
		stz 	stack3,x
		jsr 	IntegerToString 			; convert to string.
		plx
ErrorPrintIntegerBuffer:
		phx		
		ldx 	#0
_EP16Loop:
		lda 	SBuffer,x
		jsr 	ExternPrint
		inx		
		lda 	SBuffer,x
		bne 	_EP16Loop	
		txa	
		plx
		rts
		