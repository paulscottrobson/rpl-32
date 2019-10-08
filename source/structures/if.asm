; ******************************************************************************
; ******************************************************************************
;
;		Name : 		if.asm
;		Purpose :	Conditional Structure
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	8th October 2019
;
; ******************************************************************************
; ******************************************************************************
;
;	If has two forms. All must be on a single line, hence it is more like
;	BASIC than multiline equivalents in languages like C or Pascal.
;	These are very simple and cannot be nested.
;
;	<condition> 	IF 	<code> 	ENDIF	
;	<condition> 	IF <code> ELSE <code> ENDIF
;
;	Hence
;
;	IF 		checks TOS. If zero, it scans forward looking for ELSE or ENDIF
;			it runs *after* either
;	ELSE 	when executed, this is after an IF was successful. when found
;			it scans forward looking for ENDIF.
;	ENDIF 	is ignored
;
;			if any scan reaches EOL it terminates there.
;
; ******************************************************************************

; ******************************************************************************
;
;								 IF command
;
; ******************************************************************************

Struct_IF: 	;; [if]
		lda 	stack0,x 					; check TOS
		ora 	stack1,x
		ora 	stack2,x
		ora 	stack3,x
		beq 	_SIFSkipForward
		rts
		;
_SIFSkipForward:
		lda 	#KWD_ELSE 		
		jmp 	StructSkipForward

; ******************************************************************************
;
;								 ELSE command
;
; ******************************************************************************

Struct_ELSE: ;; [else]
		lda 	#KWD_ENDIF
		jmp 	StructSkipForward

; ******************************************************************************
;
;							   ENDIF does nothing
;
; ******************************************************************************

Struct_ENDIF: ;; [endif]
		rts

; ******************************************************************************
;
;		Scan forward from the current position looking for either [A] or
;		ENDIF. Move the pointer to the position after the found token.
;
; ******************************************************************************

StructSkipForward:		
		.byte 	$FF

