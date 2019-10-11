libfunc_1000: ; ORA
	.word 0
	.dword $FFFF0100
	.word libfunc_1000_name
	.byte 0,'A'
libfunc_1000_name:
	.byte $ce,$d1,$e0
libfunc_1001: ; STA
	.word libfunc_1000
	.dword $FFFF0180
	.word libfunc_1001_name
	.byte 0,'A'
libfunc_1001_name:
	.byte $d2,$d3,$e0
libfunc_1002: ; LDA
	.word libfunc_1001
	.dword $FFFF01A0
	.word libfunc_1002_name
	.byte 0,'A'
libfunc_1002_name:
	.byte $cb,$c3,$e0
libfunc_1003: ; BEQ
	.word libfunc_1002
	.dword $FFFF04F0
	.word libfunc_1003_name
	.byte 0,'A'
libfunc_1003_name:
	.byte $c1,$c4,$f0
libfunc_1004: ; PHA
	.word libfunc_1003
	.dword $FFFF0648
	.word libfunc_1004_name
	.byte 0,'A'
libfunc_1004_name:
	.byte $cf,$c7,$e0
libfunc_1005: ; PLA
	.word libfunc_1004
	.dword $FFFF0668
	.word libfunc_1005_name
	.byte 0,'A'
libfunc_1005_name:
	.byte $cf,$cb,$e0
libfunc_1006: ; TYA
	.word libfunc_1005
	.dword $FFFF0698
	.word libfunc_1006_name
	.byte 0,'A'
libfunc_1006_name:
	.byte $d3,$d8,$e0
libfunc_1007: ; TXA
	.word libfunc_1006
	.dword $FFFF068A
	.word libfunc_1007_name
	.byte 0,'A'
libfunc_1007_name:
	.byte $d3,$d7,$e0
libfunc_1008: ; BRA
	.word libfunc_1007
	.dword $FFFF0480
	.word libfunc_1008_name
	.byte 0,'A'
libfunc_1008_name:
	.byte $c1,$d1,$e0
libfunc_1009: ; EOR
	.word 0
	.dword $FFFF0140
	.word libfunc_1009_name
	.byte 0,'A'
libfunc_1009_name:
	.byte $c4,$ce,$f1
libfunc_1010: ; LSR
	.word libfunc_1009
	.dword $FFFF0240
	.word libfunc_1010_name
	.byte 0,'A'
libfunc_1010_name:
	.byte $cb,$d2,$f1
libfunc_1011: ; ROR
	.word libfunc_1010
	.dword $FFFF0260
	.word libfunc_1011_name
	.byte 0,'A'
libfunc_1011_name:
	.byte $d1,$ce,$f1
libfunc_1012: ; JSR
	.word libfunc_1011
	.dword $FFFF0520
	.word libfunc_1012_name
	.byte 0,'A'
libfunc_1012_name:
	.byte $c9,$d2,$f1
libfunc_1013: ; CLS
	.word 0
	.dword IO_Clear
	.word libfunc_1013_name
	.byte 0,'C'
libfunc_1013_name:
	.byte $c2,$cb,$f2
libfunc_1014: ; VERA.S
	.word libfunc_1013
	.dword Vera_Sprite
	.word libfunc_1014_name
	.byte 0,'C'
libfunc_1014_name:
	.byte $d5,$c4,$d1,$c0,$df,$f2
libfunc_1015: ; ADC
	.word libfunc_1014
	.dword $FFFF0160
	.word libfunc_1015_name
	.byte 0,'A'
libfunc_1015_name:
	.byte $c0,$c3,$e2
libfunc_1016: ; SBC
	.word libfunc_1015
	.dword $FFFF01E0
	.word libfunc_1016_name
	.byte 0,'A'
libfunc_1016_name:
	.byte $d2,$c1,$e2
libfunc_1017: ; DEC
	.word libfunc_1016
	.dword $FFFF063A
	.word libfunc_1017_name
	.byte 0,'A'
libfunc_1017_name:
	.byte $c3,$c4,$e2
libfunc_1018: ; INC
	.word libfunc_1017
	.dword $FFFF061A
	.word libfunc_1018_name
	.byte 0,'A'
libfunc_1018_name:
	.byte $c8,$cd,$e2
libfunc_1019: ; BVC
	.word libfunc_1018
	.dword $FFFF0450
	.word libfunc_1019_name
	.byte 0,'A'
libfunc_1019_name:
	.byte $c1,$d5,$e2
libfunc_1020: ; BVS
	.word libfunc_1019
	.dword $FFFF0470
	.word libfunc_1020_name
	.byte 0,'A'
libfunc_1020_name:
	.byte $c1,$d5,$f2
libfunc_1021: ; BCC
	.word libfunc_1020
	.dword $FFFF0490
	.word libfunc_1021_name
	.byte 0,'A'
libfunc_1021_name:
	.byte $c1,$c2,$e2
libfunc_1022: ; BCS
	.word libfunc_1021
	.dword $FFFF04B0
	.word libfunc_1022_name
	.byte 0,'A'
libfunc_1022_name:
	.byte $c1,$c2,$f2
libfunc_1023: ; RTS
	.word libfunc_1022
	.dword $FFFF0660
	.word libfunc_1023_name
	.byte 0,'A'
libfunc_1023_name:
	.byte $d1,$d3,$f2
libfunc_1024: ; CLC
	.word libfunc_1023
	.dword $FFFF0618
	.word libfunc_1024_name
	.byte 0,'A'
libfunc_1024_name:
	.byte $c2,$cb,$e2
libfunc_1025: ; SEC
	.word libfunc_1024
	.dword $FFFF0638
	.word libfunc_1025_name
	.byte 0,'A'
libfunc_1025_name:
	.byte $d2,$c4,$e2
libfunc_1026: ; TXS
	.word libfunc_1025
	.dword $FFFF069A
	.word libfunc_1026_name
	.byte 0,'A'
libfunc_1026_name:
	.byte $d3,$d7,$f2
libfunc_1027: ; RND
	.word 0
	.dword System_Random
	.word libfunc_1027_name
	.byte 0,'C'
libfunc_1027_name:
	.byte $d1,$cd,$e3
libfunc_1028: ; EMIT
	.word libfunc_1027
	.dword IO_Emit
	.word libfunc_1028_name
	.byte 0,'C'
libfunc_1028_name:
	.byte $c4,$cc,$c8,$f3
libfunc_1029: ; VERA.SET
	.word libfunc_1028
	.dword Vera_SetAddress
	.word libfunc_1029_name
	.byte 0,'C'
libfunc_1029_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$c4,$f3
libfunc_1030: ; VERA.GET
	.word libfunc_1029
	.dword Vera_GetAddress
	.word libfunc_1030_name
	.byte 0,'C'
libfunc_1030_name:
	.byte $d5,$c4,$d1,$c0,$df,$c6,$c4,$f3
libfunc_1031: ; VERA.LOAD
	.word libfunc_1030
	.dword Vera_Load
	.word libfunc_1031_name
	.byte 0,'C'
libfunc_1031_name:
	.byte $d5,$c4,$d1,$c0,$df,$cb,$ce,$c0,$e3
libfunc_1032: ; AND
	.word libfunc_1031
	.dword $FFFF0120
	.word libfunc_1032_name
	.byte 0,'A'
libfunc_1032_name:
	.byte $c0,$cd,$e3
libfunc_1033: ; BIT
	.word libfunc_1032
	.dword $FFFF0320
	.word libfunc_1033_name
	.byte 0,'A'
libfunc_1033_name:
	.byte $c1,$c8,$f3
libfunc_1034: ; CLD
	.word libfunc_1033
	.dword $FFFF06D8
	.word libfunc_1034_name
	.byte 0,'A'
libfunc_1034_name:
	.byte $c2,$cb,$e3
libfunc_1035: ; SED
	.word libfunc_1034
	.dword $FFFF06F8
	.word libfunc_1035_name
	.byte 0,'A'
libfunc_1035_name:
	.byte $d2,$c4,$e3
libfunc_1036: ; VERA.PALETTE
	.word 0
	.dword Vera_SetPalette
	.word libfunc_1036_name
	.byte 0,'C'
libfunc_1036_name:
	.byte $d5,$c4,$d1,$c0,$df,$cf,$c0,$cb,$c4,$d3,$d3,$e4
libfunc_1037: ; VERA.S.MOVE
	.word libfunc_1036
	.dword Vera_SpriteMove
	.word libfunc_1037_name
	.byte 0,'C'
libfunc_1037_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$cc,$ce,$d5,$e4
libfunc_1038: ; VERA.S.SIZE
	.word libfunc_1037
	.dword Vera_SetSize
	.word libfunc_1038_name
	.byte 0,'C'
libfunc_1038_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$d2,$c8,$d9,$e4
libfunc_1039: ; BNE
	.word libfunc_1038
	.dword $FFFF04D0
	.word libfunc_1039_name
	.byte 0,'A'
libfunc_1039_name:
	.byte $c1,$cd,$e4
libfunc_1040: ; VERA.S.OFF
	.word 0
	.dword Vera_SpriteDisable
	.word libfunc_1040_name
	.byte 0,'C'
libfunc_1040_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$ce,$c5,$e5
libfunc_1041: ; CLV
	.word libfunc_1040
	.dword $FFFF06B8
	.word libfunc_1041_name
	.byte 0,'A'
libfunc_1041_name:
	.byte $c2,$cb,$f5
libfunc_1042: ; VERA.W
	.word 0
	.dword Vera_ByteW
	.word libfunc_1042_name
	.byte 0,'C'
libfunc_1042_name:
	.byte $d5,$c4,$d1,$c0,$df,$f6
libfunc_1043: ; VERA.S.GFX
	.word 0
	.dword Vera_SpriteSetup
	.word libfunc_1043_name
	.byte 0,'C'
libfunc_1043_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$c6,$c5,$f7
libfunc_1044: ; STX
	.word libfunc_1043
	.dword $FFFF0280
	.word libfunc_1044_name
	.byte 0,'A'
libfunc_1044_name:
	.byte $d2,$d3,$f7
libfunc_1045: ; LDX
	.word libfunc_1044
	.dword $FFFF02A0
	.word libfunc_1045_name
	.byte 0,'A'
libfunc_1045_name:
	.byte $cb,$c3,$f7
libfunc_1046: ; CPX
	.word libfunc_1045
	.dword $FFFF03E0
	.word libfunc_1046_name
	.byte 0,'A'
libfunc_1046_name:
	.byte $c2,$cf,$f7
libfunc_1047: ; INX
	.word libfunc_1046
	.dword $FFFF06E8
	.word libfunc_1047_name
	.byte 0,'A'
libfunc_1047_name:
	.byte $c8,$cd,$f7
libfunc_1048: ; TAX
	.word libfunc_1047
	.dword $FFFF06AA
	.word libfunc_1048_name
	.byte 0,'A'
libfunc_1048_name:
	.byte $d3,$c0,$f7
libfunc_1049: ; TSX
	.word libfunc_1048
	.dword $FFFF06BA
	.word libfunc_1049_name
	.byte 0,'A'
libfunc_1049_name:
	.byte $d3,$d2,$f7
libfunc_1050: ; DEX
	.word libfunc_1049
	.dword $FFFF06CA
	.word libfunc_1050_name
	.byte 0,'A'
libfunc_1050_name:
	.byte $c3,$c4,$f7
libfunc_1051: ; JIX
	.word libfunc_1050
	.dword $FFFF057C
	.word libfunc_1051_name
	.byte 0,'A'
libfunc_1051_name:
	.byte $c9,$c8,$f7
libfunc_1052: ; PHX
	.word libfunc_1051
	.dword $FFFF06DA
	.word libfunc_1052_name
	.byte 0,'A'
libfunc_1052_name:
	.byte $cf,$c7,$f7
libfunc_1053: ; PLX
	.word libfunc_1052
	.dword $FFFF06FA
	.word libfunc_1053_name
	.byte 0,'A'
libfunc_1053_name:
	.byte $cf,$cb,$f7
libfunc_1054: ; STY
	.word 0
	.dword $FFFF0380
	.word libfunc_1054_name
	.byte 0,'A'
libfunc_1054_name:
	.byte $d2,$d3,$f8
libfunc_1055: ; LDY
	.word libfunc_1054
	.dword $FFFF03A0
	.word libfunc_1055_name
	.byte 0,'A'
libfunc_1055_name:
	.byte $cb,$c3,$f8
libfunc_1056: ; CPY
	.word libfunc_1055
	.dword $FFFF03C0
	.word libfunc_1056_name
	.byte 0,'A'
libfunc_1056_name:
	.byte $c2,$cf,$f8
libfunc_1057: ; BMI
	.word libfunc_1056
	.dword $FFFF0430
	.word libfunc_1057_name
	.byte 0,'A'
libfunc_1057_name:
	.byte $c1,$cc,$e8
libfunc_1058: ; JMI
	.word libfunc_1057
	.dword $FFFF056C
	.word libfunc_1058_name
	.byte 0,'A'
libfunc_1058_name:
	.byte $c9,$cc,$e8
libfunc_1059: ; RTI
	.word libfunc_1058
	.dword $FFFF0640
	.word libfunc_1059_name
	.byte 0,'A'
libfunc_1059_name:
	.byte $d1,$d3,$e8
libfunc_1060: ; DEY
	.word libfunc_1059
	.dword $FFFF0688
	.word libfunc_1060_name
	.byte 0,'A'
libfunc_1060_name:
	.byte $c3,$c4,$f8
libfunc_1061: ; TAY
	.word libfunc_1060
	.dword $FFFF06A8
	.word libfunc_1061_name
	.byte 0,'A'
libfunc_1061_name:
	.byte $d3,$c0,$f8
libfunc_1062: ; INY
	.word libfunc_1061
	.dword $FFFF06C8
	.word libfunc_1062_name
	.byte 0,'A'
libfunc_1062_name:
	.byte $c8,$cd,$f8
libfunc_1063: ; CLI
	.word libfunc_1062
	.dword $FFFF0658
	.word libfunc_1063_name
	.byte 0,'A'
libfunc_1063_name:
	.byte $c2,$cb,$e8
libfunc_1064: ; SEI
	.word libfunc_1063
	.dword $FFFF0678
	.word libfunc_1064_name
	.byte 0,'A'
libfunc_1064_name:
	.byte $d2,$c4,$e8
libfunc_1065: ; PHY
	.word libfunc_1064
	.dword $FFFF065A
	.word libfunc_1065_name
	.byte 0,'A'
libfunc_1065_name:
	.byte $cf,$c7,$f8
libfunc_1066: ; PLY
	.word libfunc_1065
	.dword $FFFF067A
	.word libfunc_1066_name
	.byte 0,'A'
libfunc_1066_name:
	.byte $cf,$cb,$f8
libfunc_1067: ; BRK
	.word 0
	.dword $FFFF0600
	.word libfunc_1067_name
	.byte 0,'A'
libfunc_1067_name:
	.byte $c1,$d1,$ea
libfunc_1068: ; ASL
	.word 0
	.dword $FFFF0200
	.word libfunc_1068_name
	.byte 0,'A'
libfunc_1068_name:
	.byte $c0,$d2,$eb
libfunc_1069: ; ROL
	.word libfunc_1068
	.dword $FFFF0220
	.word libfunc_1069_name
	.byte 0,'A'
libfunc_1069_name:
	.byte $d1,$ce,$eb
libfunc_1070: ; BPL
	.word libfunc_1069
	.dword $FFFF0410
	.word libfunc_1070_name
	.byte 0,'A'
libfunc_1070_name:
	.byte $c1,$cf,$eb
libfunc_1071: ; STR.LEN
	.word 0
	.dword String_Len
	.word libfunc_1071_name
	.byte 0,'C'
libfunc_1071_name:
	.byte $d2,$d3,$d1,$df,$cb,$c4,$ed
libfunc_1072: ; VERA.S.ON
	.word libfunc_1071
	.dword Vera_SpriteEnable
	.word libfunc_1072_name
	.byte 0,'C'
libfunc_1072_name:
	.byte $d5,$c4,$d1,$c0,$df,$d2,$df,$ce,$ed
libfunc_1073: ; CMP
	.word 0
	.dword $FFFF01C0
	.word libfunc_1073_name
	.byte 0,'A'
libfunc_1073_name:
	.byte $c2,$cc,$ef
libfunc_1074: ; JMP
	.word libfunc_1073
	.dword $FFFF054C
	.word libfunc_1074_name
	.byte 0,'A'
libfunc_1074_name:
	.byte $c9,$cc,$ef
libfunc_1075: ; PHP
	.word libfunc_1074
	.dword $FFFF0608
	.word libfunc_1075_name
	.byte 0,'A'
libfunc_1075_name:
	.byte $cf,$c7,$ef
libfunc_1076: ; PLP
	.word libfunc_1075
	.dword $FFFF0628
	.word libfunc_1076_name
	.byte 0,'A'
libfunc_1076_name:
	.byte $cf,$cb,$ef
libfunc_1077: ; NOP
	.word libfunc_1076
	.dword $FFFF06EA
	.word libfunc_1077_name
	.byte 0,'A'
libfunc_1077_name:
	.byte $cd,$ce,$ef
;
;	Default hash table
;
DefaultHashTable:
	.word libfunc_1008
	.word libfunc_1012
	.word libfunc_1026
	.word libfunc_1035
	.word libfunc_1039
	.word libfunc_1041
	.word libfunc_1042
	.word libfunc_1053
	.word libfunc_1066
	.word 0
	.word libfunc_1067
	.word libfunc_1070
	.word 0
	.word libfunc_1072
	.word 0
	.word libfunc_1077
