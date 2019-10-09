libfunc_1000: ; VERA.SET
	.word 0
	.dword Vera_SetAddress
	.word libfunc_1000_name
	.byte 0,'C'
libfunc_1000_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$c4,$f3
libfunc_1001: ; VERA.GET
	.word libfunc_1000
	.dword Vera_GetAddress
	.word libfunc_1001_name
	.byte 0,'C'
libfunc_1001_name:
	.byte $d5,$c4,$d1,$c0,$df,$c6,$c4,$f3
libfunc_1002: ; VERA.PALETTE
	.word 0
	.dword Vera_SetPalette
	.word libfunc_1002_name
	.byte 0,'C'
libfunc_1002_name:
	.byte $d5,$c4,$d1,$c0,$df,$cf,$c0,$cb,$c4,$d3,$d3,$e4
libfunc_1003: ; STR.LEN
	.word 0
	.dword String_Len
	.word libfunc_1003_name
	.byte 0,'C'
libfunc_1003_name:
	.byte $d2,$d3,$d1,$df,$cb,$c4,$ed
;
;	Default hash table
;
DefaultHashTable:
	.word 0
	.word 0
	.word 0
	.word libfunc_1001
	.word libfunc_1002
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word libfunc_1003
	.word 0
	.word 0
