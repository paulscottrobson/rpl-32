libfunc_1000: ; VERA.S
	.word 0
	.dword Vera_Sprite
	.word libfunc_1000_name
	.byte 0,'C'
libfunc_1000_name:
	.byte $d5,$c4,$d1,$c0,$df,$f2
libfunc_1001: ; VERA.SET
	.word 0
	.dword Vera_SetAddress
	.word libfunc_1001_name
	.byte 0,'C'
libfunc_1001_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$c4,$f3
libfunc_1002: ; VERA.GET
	.word libfunc_1001
	.dword Vera_GetAddress
	.word libfunc_1002_name
	.byte 0,'C'
libfunc_1002_name:
	.byte $d5,$c4,$d1,$c0,$df,$c6,$c4,$f3
libfunc_1003: ; VERA.PALETTE
	.word 0
	.dword Vera_SetPalette
	.word libfunc_1003_name
	.byte 0,'C'
libfunc_1003_name:
	.byte $d5,$c4,$d1,$c0,$df,$cf,$c0,$cb,$c4,$d3,$d3,$e4
libfunc_1004: ; VERA.S.MOVE
	.word libfunc_1003
	.dword Vera_SpriteMove
	.word libfunc_1004_name
	.byte 0,'C'
libfunc_1004_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$cc,$ce,$d5,$e4
libfunc_1005: ; VERA.S.SIZE
	.word libfunc_1004
	.dword Vera_SetSize
	.word libfunc_1005_name
	.byte 0,'C'
libfunc_1005_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$d2,$c8,$d9,$e4
libfunc_1006: ; VERA.S.OFF
	.word 0
	.dword Vera_SpriteDisable
	.word libfunc_1006_name
	.byte 0,'C'
libfunc_1006_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$ce,$c5,$e5
libfunc_1007: ; VERA.S.GFX
	.word 0
	.dword Vera_SpriteSetup
	.word libfunc_1007_name
	.byte 0,'C'
libfunc_1007_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$c6,$c5,$f7
libfunc_1008: ; STR.LEN
	.word 0
	.dword String_Len
	.word libfunc_1008_name
	.byte 0,'C'
libfunc_1008_name:
	.byte $d2,$d3,$d1,$df,$cb,$c4,$ed
libfunc_1009: ; VERA.S.ON
	.word libfunc_1008
	.dword Vera_SpriteEnable
	.word libfunc_1009_name
	.byte 0,'C'
libfunc_1009_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$ce,$ed
;
;	Default hash table
;
DefaultHashTable:
	.word 0
	.word 0
	.word libfunc_1000
	.word libfunc_1002
	.word libfunc_1005
	.word libfunc_1006
	.word 0
	.word libfunc_1007
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word libfunc_1009
	.word 0
	.word 0
