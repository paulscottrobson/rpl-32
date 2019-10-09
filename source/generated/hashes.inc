libfunc_1000: ; STR.LEN
	.word 0
	.dword String_Len
	.word libfunc_1000_name
	.byte 0,'C'
libfunc_1000_name:
	.byte $d2,$d3,$d1,$df,$cb,$c4,$ed
;
;	Default hash table
;
DefaultHashTable:
	.word 0
	.word 0
	.word libfunc_1000
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
