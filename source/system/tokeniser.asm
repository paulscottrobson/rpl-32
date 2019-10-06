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

TTest:	stz 	zTemp1
		lda 	#$0B
		sta		zTemp1+1
		lda 	#Test & 255
		sta 	codePtr
		lda 	#Test >> 8
		sta 	codePtr+1
		jsr 	Tokenise
h1:		bra 	h1
		
Test:	.text 	" 517 REPEATX"
		.byte 	0
; ******************************************************************************
;
;					Tokenise (codePtr) to (zTemp1)
;
;						(needs to be capitalised)
; ******************************************************************************

Tokenise:
		ldy 	#0
		;
		;		Skip any leading spaces
		;
_TKSkip:lda 	(codePtr),y 				; get next
		beq 	_TKExit 					; exit if zero.
		iny
		cmp 	#" "
		beq 	_TKSkip 					; skip leading spaces.
		dey
		;
		;		Main Loop
		;
_TKMainLoop:		
		lda 	(codePtr),y 				; get and check end.
		bne 	_TKNotEnd
		;
_TKExit:sta 	(zTemp1) 					; and ending $00
		rts
		;
		;		Check for space, quotes
		;
_TKNotEnd:
		cmp 	#" " 						; is it space ?		
		bne 	_TKNotSpace
		lda 	#KWD_SPACE 					; write space token
		jsr 	TokWriteToken
		bra 	_TKSkip 					; skip multiple spaces.
		;
		;		Check for decimal constant
		;
_TKNotSpace:
		cmp 	#'"'
		beq 	_TKIsQuote
		cmp 	#"'"
		bne 	_TKNotQuote
		;
		;		Handle quoted strings, either type.
		;
_TKIsQuote:
		.byte 	$FF
		bra 	_TKMainLoop
		;
		;		Update codePtr by adding Y to it, so codePtr points
		;		to the current token. Also copy this to zTemp0
		;		for string->integer conversion.
		;
		; // TODO		
_TKNotQuote:		
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

		cmp 	#"0"						; check for decimal.						
		bcc 	_TKNotNumber
		cmp 	#"9"+1
		bcs 	_TKNotNumber
		;
		inx
		jsr 	IntFromString 				; convert to integer
		pha
		jsr 	TokWriteConstant 			; do constant recursively.
		ply
		dex
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
		sta 	zTemp3 						; update best
		lda 	zTemp3+1 					; save current token.
		sta 	zTemp4
		bra 	_TKNext
		;
		;		Checked all the tokens.
		;
_TKComplete:
		.byte 	$FF
		.byte 	$FF
		lda 	zTemp3 						; get "best score"
		beq		_TKTokenFail
		;
		;		Check if it is an identifier token, if so, check
		;		it is a 'complete' identifier e.g. we don't have
		;		REPEATNAME 
		;  // TODO
		;
		.byte 	$FF
_TKTokenFail:
		;
		;		Not a token. Output an identifier sequence, if
		;		no such sequence present, report an error
		;
		;  // TODO
_TKTokenFail:

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
