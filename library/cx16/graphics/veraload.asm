; ******************************************************************************
; ******************************************************************************
;
;		Name : 		veraload.asm
;		Purpose : 	Load a file to VERA memory
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	10th October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;							Load TOS file to Vera
;
;	Note: Because the sequential read doesn't work, this reads it into block
;	254 and sends it to Vera that way. So there is an 8k upper limit on this
; 	file.
;
; ******************************************************************************

Vera_Load: ;; [vera.load]
		phx
		phy
		lda 	stack0,x 					; filename in zTemp0
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		;
		ldx 	#0 							; copy load code to input buffer
_VLCopy:lda 	_VLCopiableCode,x
		sta 	InputBuffer,x
		inx
		cpx 	#_VLCopiableEnd-_VLCopiableCode
		bne 	_VLCopy

		jsr 	EXGetLength 				; get file name length -> A
		jsr 	InputBuffer
		bcs 	_VLError
		;
		ply
		plx
		dex 								; drop tos
		rts

_VLError:
		rerror 	"VERA LOAD FAIL"


_VLCopiableCode:
		tax 								; length in X

		lda 	$9F61 						; save current bank
		pha

		lda 	#254 						; switch to useable buffer
		sta 	$9F61

		txa
		ldx 	zTemp0
		ldy 	zTemp0+1
		jsr 	$FFBD 						; set name
		;
		lda 	#1
		ldx 	#1	 						; device #1
		ldy 	#0
		jsr 	$FFBA 						; set LFS		

		ldy 	#$A0 						; set target to $A000 and call load
		lda 	#$00
		jsr 	$FFD5
		bcs 	_VLExit
		;
		lda 	#$A0 						; send it all to VERA
		sta 	zTemp0+1
		stz 	zTemp0
		ldy 	#0
_VLSendVera:
		lda 	(zTemp0),y
		sta 	$9F23
		iny
		bne 	_VLSendVera
		inc 	zTemp0+1
		lda 	zTemp0+1
		cmp 	#$C0
		bne 	_VLSendVera
		;
		clc
_VLExit:		
		pla 								; restore original bank
		sta 	$9F61
		rts
_VLCopiableEnd:

