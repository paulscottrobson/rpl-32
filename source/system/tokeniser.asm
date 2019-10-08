; ******************************************************************************
; ******************************************************************************
;
;		Name : 		tokenise.asm
;		Purpose : 	RPL/32 Tokeniser
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	6th October 2019
;
; ******************************************************************************
; ******************************************************************************

;TTest:	stz 	zTemp1
;		lda 	#$0B
;		sta		zTemp1+1
;		lda 	#Test & 255
;		sta 	codePtr
;		lda 	#Test >> 8
;		sta 	codePtr+1
;		jsr 	Tokenise
;		.byte 	$FF
;h1:		bra 	h1
;		
;Test:	.text 	" 6 66 66- + --DEF REPEATX 4 'sing'"
;		.text 	'5"double'
;		.byte 	0

; ******************************************************************************
;
;					Tokenise (codePtr) to (zTemp1)
;
;						(needs to be capitalised)
; ******************************************************************************

Tokenise:
		phx
		ldy 	#255 						; predecrement
_TKSkip:
		iny
_TKMainLoop:		
		lda 	(codePtr),y 				; get and check end.
		beq 	_TKExit
		cmp 	#" "
		beq 	_TKSkip
		bra 	_TKNotEnd
		;
_TKExit:sta 	(zTemp1) 					; and ending $00
		plx
		rts
		;
		;		Handle quoted strings, either type.
		;
_TKNotEnd:
		cmp 	#'"'
		beq 	_TKIsQuote
		cmp 	#"'"
		bne 	_TKNotQuote
_TKIsQuote:
		jsr		TOKQuotedString
		bra 	_TKMainLoop
		;
		;		Check for decimal constant
		;
_TKNotQuote:		
		;
		;		Update codePtr by adding Y to it, so codePtr points
		;		to the current token. Also copy this to zTemp0
		;		for string->integer conversion.
		;		
		tya 								; current pos -> zTemp0
		clc
		adc 	codePtr
		sta 	zTemp0
		sta 	codePtr
		lda 	codePtr+1
		adc 	#0
		sta 	zTemp0+1
		sta 	codePtr+1

		ldy 	#0 							; reset and get character
		lda 	(codePtr),y

		cmp 	#"&"						; hex marker
		beq 	_TKIsNumber
		cmp 	#"0"						; check for decimal.						
		bcc 	_TKNotNumber
		cmp 	#"9"+1
		bcs 	_TKNotNumber
		;
_TKIsNumber:		
		inx
		jsr 	IntFromString 				; convert to integer
		pha
		jsr 	TokWriteConstant 			; do constant recursively.
		ply
		dex
		;
		lda 	(codePtr),y
		cmp 	#"-"						; followed by minus
		bne 	_TKIsPositive
		iny									; skip it
		lda 	#KWD_CONSTANT_MINUS
		jsr 	TokWriteToken 				; write token out
		bra 	_TKMainLoop 				; loop back.
_TKIsPositive:
		lda 	#KWD_CONSTANT_PLUS
		jsr 	TokWriteToken 				; write token out
		bra 	_TKMainLoop 				; loop back.
		;
		;		Search token table
		;
_TKNotNumber:
		lda 	#KeywordText & $FF 			; zTemp2 -> token table
		sta 	zTemp2
		lda 	#KeywordText >> 8
		sta 	zTemp2+1
		stz 	zTemp3 						; clear 'best'
		lda 	#$10
		sta 	zTemp3+1 					; set current token
		;		
		;		Check next token
		;
_TKSearch:
		ldy 	#0
		;
		;		Name comparison loop
		;
_TKCompare:
		lda 	(codePtr),y 	 			; get char from buffer
		iny
		cmp 	(zTemp2),y 					; does it match.
		bne 	_TKNext		
		tya
		cmp 	(zTemp2) 					; Y = length
		bne 	_TKCompare 					; found a match.
		bra 	_TKFound
		;
		;		Go to next token
		;
_TKNext:lda 	(zTemp2)					; get length
		sec 								; add length+1 to current
		adc 	zTemp2
		sta 	zTemp2
		bcc 	_TKNNC
		inc 	zTemp2+1
_TKNNC:	inc 	zTemp3+1 					; increment current token
		lda 	(zTemp2) 					; reached then end
		bne 	_TKSearch 					; go try again.
		bra 	_TKComplete
		;
		;		Found a matching token
		;
_TKFound:		
		tya
		cmp 	zTemp3 						; check best
		bcc 	_TKNext 					; if < best try next
		beq 	_TKNext 					; if equal this is one of the special +- tokens
		sta 	zTemp3 						; update best
		lda 	zTemp3+1 					; save current token.
		sta 	zTemp4
		bra 	_TKNext
		;
		;		Checked all the tokens.
		;
_TKComplete:
		lda 	zTemp3 						; get "best score"
		beq		_TKTokenFail 				; if zero no match occurred
		;
		;		Check if it is an identifier token, if so, check
		;		it is a 'complete' identifier e.g. we don't have
		;		REPEATNAME 
		;	
		ldy 	zTemp3 						; length in Y
		lda 	(codePtr) 					; look at first character
		jsr 	TOKIsIdentifier 			; identifier character
		bcc 	_TKOutput 					; if not, then token is okay
		;
		lda 	(codePtr),y 				; look at character after
		jsr 	TOKIsIdentifier 			; is that an identifier
		bcs 	_TKTokenFail 				; if so it must be something like DEFAULT (DEF-AULT)
_TKOutput:
		lda 	zTemp4 						; output actual token
		jsr 	TOKWriteToken
		jmp 	_TKMainLoop					; go round again
		;
		;		Not a token. Output an identifier sequence, if
		;		no such sequence present, report an error
		;
_TKTokenFail:
		ldy 	#0
		lda 	(codePtr) 					; is the first an identifier ?
		jsr 	TOKIsIdentifier
		bcs 	_TKCopyIdent 				; if yes copy it
		rerror	"CANNOT TOKENISE"			; can't encode the line
;
_TKCopyIdent:
		iny 								; get next
		lda 	(codePtr),y
		jsr 	TOKIsIdentifier 			; if identifier
		php 								; save CS on stack
		;
		dey 								; back to character
		lda 	(codePtr),y 				; get it
		iny
		cmp 	#"."
		bne 	_TKNotDot
		lda 	#'A'+31 					; to map . to 31
_TKNotDot:
		sec
		sbc		#'A'
		ora 	#$C0 						; in right range
		plp 								; CS if next is identifier
		php
		bcs 	_TKNotLast					; CC if next is not identifier
		ora 	#$E0 						; range E0-FF 
_TKNotLast:
		jsr 	TOKWriteToken 				; write out
		plp 								; get test result
		bcs 	_TKCopyIdent 				; get the next identifier.
		jmp 	_TKMainLoop
		

; ******************************************************************************
;
;							CS if token is identifier
;
; ******************************************************************************

TOKIsIdentifier:
		cmp 	#"."
		beq 	_TIIYes
		cmp 	#"A"
		bcc 	_TIINo
		cmp 	#"Z"+1
		bcs 	_TIINo
_TIIYes:
		sec
		rts
_TIINo:
		clc
		rts

; ******************************************************************************
;
;		Write a single byte out to the token
;	
; ******************************************************************************

TokWriteToken:
		sta 	(zTemp1)
		inc 	zTemp1
		bne 	_TWTExit
		inc 	zTemp1+1
_TWTExit:
		rts				
; ******************************************************************************
;
;		Recursive constant write
;
; ******************************************************************************

TokWriteConstant:
		lda 	stack0,x 					; get current
		and		#63 		
		pha 								; save on stack
		;
		lda 	stack0,x 					; check if < 64
		and 	#$C0
		ora 	stack1,x
		ora 	stack2,x
		ora 	stack3,x
		beq 	_TWCNoCall 					; no, don't call.
		phy
		;
		;		Yes, divide by 64 and call that.
		;
		ldy 	#6
_TWCShift:		
		jsr 	Unary_Shr
		dey
		bne 	_TWCShift
		ply
		jsr 	TokWriteConstant
_TWCNoCall:
		pla
		ora 	#$80						; make digit token
		bra 	TokWriteToken 				; and write it out.		

; ******************************************************************************
;
;		Tokenise a quoted string. Quote "type" in A
;
; ******************************************************************************

TokQuotedString:
		sta 	zTemp2 						; save quote
		eor 	#'"'						; now zero if double quotes
		beq 	_TQDouble
		lda 	#1
_TQDouble:
		inc 	a 							; 1 for double, 2 for single
		jsr 	TOKWriteToken 				; write out
		lda 	zTemp1 						; copy zTemp1 to zTemp3 (byte count addr)
		sta 	zTemp3
		lda 	zTemp1+1
		sta 	zTemp3+1
		lda 	#3 							; 3 is the size if it is empty - type,size,null
		jsr 	TOKWriteToken
		;
_TQLoop:
		iny 								; next character
		lda 	(codePtr),y
		beq 	_TQExit 					; if zero exit
		cmp 	zTemp2 						; matching quote
		beq 	_TQSkipExit 				; skip it and exit
		jsr 	TOKWriteToken 				; write out
		lda 	(zTemp3)					; inc char count
		inc 	a
		sta 	(zTemp3)
		bra 	_TQLoop						; go round

_TQSkipExit:
		iny
_TQExit:
		lda 	#0 							; write out ASCIIZ
		jsr 	TOKWriteToken
		rts
