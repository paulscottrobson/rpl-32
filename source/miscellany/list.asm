; ******************************************************************************
; ******************************************************************************
;
;		Name : 		list.asm
;		Purpose : 	List Program
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	5th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								List command
;
; ******************************************************************************

Cmd_List: 	;; [list]
		jsr 	ResetCodePointer 			; back to the beginning
		stz 	zTemp2						; clear the lowest-number
		stz 	zTemp2+1
		cpx 	#0 							; stack empty ?
		beq 	_CLINone
		lda 	stack0,x 					; use tos as start line
		sta 	zTemp2
		lda 	stack1,x
		sta 	zTemp2+1
		dex 								; and pop the tos
_CLINone:		
		lda 	#30 						; list this many lines
		sta 	zTemp1
		;
		;		Listing loop
		;
_CLILoop		
		lda 	(codePtr)					; check end of program
		beq 	_CLIEnd
		ldy 	#1 							; compare line# vs the minimum
		sec
		lda 	(codePtr),y
		sbc 	zTemp2
		iny
		lda 	(codePtr),y
		sbc 	zTemp2+1
		bcc 	_CLISkip
		phx
		jsr 	ListCurrent 				; list the line.
		plx
		dec 	zTemp1 						; done all lines
		beq 	_CLIEnd
_CLISkip:
		clc
		lda 	(codePtr) 					; go to next
		adc 	codePtr
		sta 	codePtr
		bcc 	_CLILoop
		inc 	codePtr+1
		bra 	_CLILoop
_CLIEnd:				
		jmp 	WarmStart

; ******************************************************************************
;
;							List current line number
;
; ******************************************************************************

ListCurrent:
		ldy 	#3
		lda 	(codePtr),y
		cmp 	#2
		bne 	_LCList
		lda 	#13
		jsr 	ExternPrint
		jsr 	_LCList
		lda 	#13
		jsr 	ExternPrint
		rts
_LCList:
		lda 	#CTH_LINENO
		jsr 	ExternColour 				; set colour
		ldy 	#1							; print line#
		lda 	(codePtr),y
		pha
		iny
		lda 	(codePtr),y
		tay
		pla
		jsr 	ErrorPrint16
		;
		tay
_LCPadOut:									; pad out to align neatly
		lda 	#' '
		jsr 	ExternPrint
		iny
		cpy 	#5
		bne 	_LCPadOut
		ldy 	#3 							; start here
		;
		;		List loop
		;		
_LCLoop:
		lda 	#' '						; space
		jsr 	ExternPrint
_LCLoopNoSpace:
		lda 	(codePtr),y 				; get first	
		bmi 	_LCIdentConst 				; identifier or constant
		bne 	_LCStringToken
		lda 	#13
		jmp 	ExternPrint	
		;
_LCStringToken:
		cmp 	#$10 						; if < 10 it's a string.
		bcc		_LCString 
		jsr 	ListPrintToken
		lda 	(codePtr),y 				; no space if ^
		iny 								; advance pointer
		cmp 	#KWD_HAT
		beq 	_LCLoopNoSpace
		bra 	_LCLoop 					; go round again.
;
;		Print a string or comment
;
_LCString:
		lsr 	a 							; CS if 1 (string) CC if 2 (comment)
		lda 	#CTH_STRING 				; decide on colour.
		ldx 	#'"'
		bcs 	_LCSSkip
		lda 	#CTH_COMMENT
		ldx 	#"'"
_LCSSkip:
		jsr 	ExternColour 				; set colour
		txa
		pha 								; save end quote on stack.
		jsr 	ExternPrint
		iny 								; skip type size
		iny
_LCSPrint: 									; string printing loop.
		lda 	(codePtr),y
		iny
		cmp 	#0 							; 0 is end
		beq 	_LCSExit 		
		jsr 	ExternPrint
		bra 	_LCSPrint
_LCSExit: 									; restore ending quote and print
		pla
		jsr 	ExternPrint
		bra 	_LCLoop		
;
;		Identifier or constant
;
_LCIdentConst:
		cmp 	#$C0						; check if constant
		bcc 	_LCConstant
;
;		Identifier
;
		lda 	#CTH_IDENT 					; set colour
		jsr 	ExternColour 				
_LCCIdLoop:
		lda 	(codePtr),y 				; read
		and 	#$1F 						; convert
		clc
		adc 	#'A'
		cmp 	#'A'+31 					; handle '.'
		bne 	_LCCNotDot
		lda 	#'.'
_LCCNotDot:		
		jsr 	ExternPrint
		lda 	(codePtr),y 				; at end ?
		iny
		cmp 	#$E0
		bcs 	_LCLoop
		bra 	_LCCIdLoop
;
;		Constant
;
_LCConstant:
		lda 	#CTH_NUMBER 				; number colour
		jsr 	ExternColour
		ldx 	#254 						; use the topmost stack element
		jsr 	ExtractIntegerToTOS 		; so there is a very rare case
		lda 	stack3+0,x					; save stack top byte
		pha
		jsr 	IntegerToString 			; this could corrupt stack if full :)
		jsr 	ErrorPrintIntegerBuffer
		pla 								; sign back
		bpl 	_LCLoop
		lda 	#"-"
		jsr 	ExternPrint
		jmp 	_LCLoop
;
;		Print token in A
;
ListPrintToken:			
		phy
		pha 								; token colour
		lda 	#CTH_TOKEN
		jsr 	ExternColour 			
		plx
		lda 	#KeywordText & $FF
		sta 	zTemp0
		lda 	#KeywordText >> 8
		sta 	zTemp0+1
_LPTLoop:
		cpx 	#$10 						; first token is $10
		beq 	_LPTFound
		dex
		lda 	(zTemp0)
		sec									; add 1, it's length+name
		adc 	zTemp0
		sta 	zTemp0
		bcc 	_LPTLoop
		inc 	zTemp0+1
		bra 	_LPTLoop
_LPTFound:
		ldy 	#1 							; start here.
_LPTShow:
		lda 	(zTemp0),y 					; get character
		cmp 	#32 						; < 32, length, so exit
		bcc 	_LPTExit
		iny
		jsr 	ExternPrint
		bra 	_LPTShow
_LPTExit:
		ply
		rts
