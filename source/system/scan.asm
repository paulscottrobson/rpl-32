; ******************************************************************************
; ******************************************************************************
;
;		Name : 		scan.asm
;		Purpose : 	Scan the available code for procedures
;		Author : 	Paul Robson (paul@robsons.org.uk)
;		Created : 	3rd October 2019
;
; ******************************************************************************
; ******************************************************************************

; ******************************************************************************
;
;		Scan through the code looking for def [spaces?] [identifier]. Add
;		the identifier to the identifier system as a procedure type, and
;		set its value to the first non-space byte after the identifier.
;
; ******************************************************************************

ProcedureScan:
		rts
		