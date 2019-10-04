; ******************************************************************************
; ******************************************************************************
;
;		Name : 		memory.asm
;		Purpose : 	Memory I/O functions
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;								c@, read a byte
;
; ******************************************************************************

Mem_Peek:	;; [c@]
		lda 	stack0,x 					; copy address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		lda 	(zTemp0)					; read byte
		sta 	stack0,x 					; write to stack
		stz 	stack1,x 				
		stz 	stack2,x 				
		stz 	stack3,x 				
		rts

; ******************************************************************************
;
;								w@ read a word
;
; ******************************************************************************

Mem_WPeek:	;; [w@]
		lda 	stack0,x 					; copy address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		lda 	(zTemp0)					; read byte
		sta 	stack0,x 					; write to stack
		phy 								; read msb
		ldy 	#1
		lda 	(zTemp0),y
		ply
		sta 	stack1,x 				; write to stack
		stz 	stack2,x 				
		stz 	stack3,x 				
		rts

; ******************************************************************************
;
;								@ read a dword
;
; ******************************************************************************

Mem_DPeek:	;; [@]
		lda 	stack0,x 					; copy address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		lda 	(zTemp0)					; read byte

		sta 	stack0,x 					; write to stack
		phy 								; read msb
		ldy 	#1
		lda 	(zTemp0),y
		sta 	stack1,x 				; write to stack
		iny
		lda 	(zTemp0),y
		stz 	stack2,x 				
		iny
		lda 	(zTemp0),y
		stz 	stack3,x 				
		ply
		rts

; ******************************************************************************
;
;								c! write a byte
;
; ******************************************************************************

Mem_Poke:	;; [c!]
		lda 	stack0,x 					; copy address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		;
		lda 	stack0-1,x 				; byte to write
		sta 	(zTemp0)
		dex
		dex
		rts

; ******************************************************************************
;
;								w! write a word
;
; ******************************************************************************

Mem_WPoke:	;; [w!]
		lda 	stack0,x 					; copy address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		;
		lda 	stack0-1,x 				; byte to write
		sta 	(zTemp0)
		phy 
		ldy 	#1
		lda 	stack3-1,x 				; byte to write
		sta 	(zTemp0),y
		ply
		dex
		dex	
		rts

; ******************************************************************************
;
;								! write a dword
;
; ******************************************************************************

Mem_DPoke:	;; [!]
		lda 	stack0,x 					; copy address
		sta 	zTemp0
		lda 	stack1,x
		sta 	zTemp0+1
		;
		lda 	stack0-1,x 					; byte to write
		sta 	(zTemp0)
		phy 
		ldy 	#1
		lda 	stack1-1,x 						
		iny
		sta 	(zTemp0),y
		lda 	stack2-1,x 						
		iny
		sta 	(zTemp0),y
		lda 	stack3-1,x 						
		iny
		sta 	(zTemp0),y
		ply
		dex
		dex	
		rts
