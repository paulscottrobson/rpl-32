libfunc_1000: ; CLS
	.word 0
	.dword IO_Clear
	.word libfunc_1000_name
	.byte 0,'C'
libfunc_1000_name:
	.byte $c2,$cb,$f2
libfunc_1001: ; VERA.S
	.word libfunc_1000
	.dword Vera_Sprite
	.word libfunc_1001_name
	.byte 0,'C'
libfunc_1001_name:
	.byte $d5,$c4,$d1,$c0,$df,$f2
libfunc_1002: ; RND
	.word 0
	.dword System_Random
	.word libfunc_1002_name
	.byte 0,'C'
libfunc_1002_name:
	.byte $d1,$cd,$e3
libfunc_1003: ; EMIT
	.word libfunc_1002
	.dword IO_Emit
	.word libfunc_1003_name
	.byte 0,'C'
libfunc_1003_name:
	.byte $c4,$cc,$c8,$f3
libfunc_1004: ; VERA.SET
	.word libfunc_1003
	.dword Vera_SetAddress
	.word libfunc_1004_name
	.byte 0,'C'
libfunc_1004_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$c4,$f3
libfunc_1005: ; VERA.GET
	.word libfunc_1004
	.dword Vera_GetAddress
	.word libfunc_1005_name
	.byte 0,'C'
libfunc_1005_name:
	.byte $d5,$c4,$d1,$c0,$df,$c6,$c4,$f3
libfunc_1006: ; VERA.PALETTE
	.word 0
	.dword Vera_SetPalette
	.word libfunc_1006_name
	.byte 0,'C'
libfunc_1006_name:
	.byte $d5,$c4,$d1,$c0,$df,$cf,$c0,$cb,$c4,$d3,$d3,$e4
libfunc_1007: ; VERA.S.MOVE
	.word libfunc_1006
	.dword Vera_SpriteMove
	.word libfunc_1007_name
	.byte 0,'C'
libfunc_1007_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$cc,$ce,$d5,$e4
libfunc_1008: ; VERA.S.SIZE
	.word libfunc_1007
	.dword Vera_SetSize
	.word libfunc_1008_name
	.byte 0,'C'
libfunc_1008_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$d2,$c8,$d9,$e4
libfunc_1009: ; VERA.S.OFF
	.word 0
	.dword Vera_SpriteDisable
	.word libfunc_1009_name
	.byte 0,'C'
libfunc_1009_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$ce,$c5,$e5
libfunc_1010: ; VERA.W
	.word 0
	.dword Vera_ByteW
	.word libfunc_1010_name
	.byte 0,'C'
libfunc_1010_name:
	.byte $d5,$c4,$d1,$c0,$df,$f6
libfunc_1011: ; VERA.S.GFX
	.word 0
	.dword Vera_SpriteSetup
	.word libfunc_1011_name
	.byte 0,'C'
libfunc_1011_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$c6,$c5,$f7
libfunc_1012: ; STR.LEN
	.word 0
	.dword String_Len
	.word libfunc_1012_name
	.byte 0,'C'
libfunc_1012_name:
	.byte $d2,$d3,$d1,$df,$cb,$c4,$ed
libfunc_1013: ; VERA.S.ON
	.word libfunc_1012
	.dword Vera_SpriteEnable
	.word libfunc_1013_name
	.byte 0,'C'
libfunc_1013_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$ce,$ed
;
;	Default hash table
;
DefaultHashTable:
	.word 0
	.word 0
	.word libfunc_1001
	.word libfunc_1005
	.word libfunc_1008
	.word libfunc_1009
	.word libfunc_1010
	.word libfunc_1011
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word libfunc_1013
	.word 0
	.word 0
