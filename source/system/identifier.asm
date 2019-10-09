; ******************************************************************************
; ******************************************************************************
;
;		Name : 		identifier.asm
;		Purpose : 	Identifier Manager
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	4th October 2019
;
; ******************************************************************************
; ******************************************************************************


; ******************************************************************************
;
;		Search for a new identifier. Name is at (codePtr),y. 
;		Found : CS : Set data address to idDataAddr, type is A
;		Not Found : CC
;
; ******************************************************************************

IdentifierSearch:
		lda 	(codePtr),y 				; get first character
		cmp 	#$E0 						; is it a fast var ?
		bcc 	_ISSlow
		cmp 	#$F9+1
		bcs 	_ISSlow
		;
		;		Fast variables e.g. A-Z
		;
		and 	#$1F 						; index, then x 4
		asl 	a
		asl		a
		sta 	idDataAddr					; set up addres
		lda 	#AZVariables >> 8
		sta 	idDataAddr+1
		lda 	#IDT_VARIABLE 				; type
		sec 								; return with CS.
		rts
		;
		;		Search variable tables
		;
_ISSlow:
		jsr 	IdentifierSetupHashPtr 		; set up hash table.
		;
		tya 								; set (zTemp1) to point to the
		clc 	 							; identifier to be searched.	
		adc 	codePtr
		sta 	zTemp1
		lda 	codePtr+1
		adc 	#0
		sta 	zTemp1+1
		phy 								; save Y
		;
		;		Main Search Loop
		;
_ISLoop:lda 	(zTemp0)					; follow link
		pha
		ldy 	#1
		lda 	(zTemp0),y
		sta 	zTemp0+1
		pla
		sta 	zTemp0
		;
		ora 	zTemp0+1 					; if zero, then fail.
		beq 	_ISFail

		ldy 	#6 							; copy name into zTemp2
		lda 	(zTemp0),y
		sta 	zTemp2
		iny
		lda 	(zTemp0),y
		sta 	zTemp2+1

		ldy 	#0 							; compare names at zTemp1/zTemp2
_ISCompare:
		lda 	(zTemp1),y
		cmp 	(zTemp2),y
		bne		_ISLoop 					; different ?
		iny
		cmp 	#$E0 						; until end identifiers matched.
		bcc 	_ISCompare
		;
		clc 								; set up the data pointer
		lda 	zTemp0
		adc 	#2
		sta 	idDataAddr
		lda 	zTemp0+1
		adc		#0
		sta 	idDataAddr+1
		;
		ldy 	#9 							; get the type
		lda 	(zTemp0),y
		;
		ply
		sec
		rts

_ISFail:
		ply
		clc		
		rts

; ******************************************************************************
;
;		Create a new identifier. Name is at (codePtr),y. Type is A 
;		Set data address to idDataAddr
;
; ******************************************************************************

IdentifierCreate:
		phy 								; save Y

		pha 								; save type on stack
		jsr 	IdentifierSetUpHashPtr 		; zTemp0 = address of table.
		;
		lda 	VarMemory 					; copy VarMemory to zTemp1
		sta 	zTemp1
		lda 	VarMemory+1
		sta 	zTemp1+1

		phy 								; save Y (code offset)
		ldy 	#0 							; copy next link in.
		lda 	(zTemp0),y 					; +0,+1 is the link.
		sta 	(zTemp1),y
		iny
		lda 	(zTemp0),y 
		sta 	(zTemp1),y
		iny
_IDCErase: 									; clear +2..+5 to all zero.
		lda 	#0
		sta 	(zTemp1),y		
		iny
		cpy 	#6
		bne 	_IDCErase
		;
		pla 								; original Y
		clc
		adc		codePtr 					; address of identifier +6,+7
		sta 	(zTemp1),y
		iny
		lda 	codePtr+1
		adc 	#0
		sta 	(zTemp1),y
		iny
		lda 	#0 							; +8 bank (0)
		sta 	(zTemp1),y
		pla 								; restore type
		iny 	
		sta 	(zTemp1),y 					; store at +9
		iny
		;
		tya									; add offset to VarMemory
		clc
		adc 	VarMemory
		sta 	VarMemory
		lda 	VarMemory+1 
		adc 	#0
		sta 	VarMemory+1
		;
		cmp 	AllocMemory+1 				; in the same page as allocated ?
		beq 	_IDCMemory
		;
		lda 	zTemp1 						; overwrite hash table entry
		sta 	(zTemp0)
		ldy 	#1
		lda 	zTemp1+1
		sta 	(zTemp0),y

		lda 	zTemp1 						; set up idDataAddr
		clc
		adc 	#2
		sta 	idDataAddr
		lda 	zTemp1+1
		adc 	#0
		sta 	idDataAddr+1
		ply 								; restore Y and exit
		rts

_IDCMemory:
		jmp 	OutOfMemoryError

; ******************************************************************************
;
;		For the identifier at (codePtr),y, set up the hashtable pointer.
;
; ******************************************************************************

IdentifierSetUpHashPtr:
		phy
_ISPLoop:		
		lda 	(codePtr),y 				; get the last identifier character
		iny
		cmp 	#$E0
		bcc 	_ISPLoop
		and 	#(HashTableSize-1)			; convert to a hash index
		asl 	a 							; convert to an offset, clc
		adc 	#(HashTable & $FF)			; set zTemp0 to point to hashTable entry
		sta 	zTemp0
		lda 	#(HashTable >> 8) 			; assumes table in one page
		sta 	zTemp0+1
		ply
		rts
		