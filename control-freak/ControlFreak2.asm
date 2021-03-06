;Super Metroid Control Freak:
;Autorun unless Walk is held - DONE
;X-ray scope on a button (old item cancel) - DONE
;Aim down becomes seperate fire button - DONE
;will have a new hack allowing any buttons to anything - DONE
;Redo control menu tiles too - DONE

;Check charge beam to see if it works acceptably. - It's a bit abusable and ugly. Will fix failed-shot release palette, but leave in. - DONE
;Actually make the Special Settings options work. - DONE

;Intro movies need to be fixed. Demo movies too, maybe? - DONE

;Run routine will change branch on Run - DONE
;Change demos to Walk instead of Run - DONE
;Transitions will change to act as if Run were held - er. Actually no transitions check this. DONE
;X-Ray scope checks for Item Cancel - DONE

;Remove other cases of Item Cancel - DONE
;Select cycles, otherwise no movement - DONE
;Empty items selectable - DONE
;Aim down becomes toggle to selected - DONE

;Remove old Item Cancel checks - DONE

;Redo transition table for aim up/down - DONE. A few breaks but they're acceptable
;[22:04] <Kejardon> getting hit breaks aim-lock, that one makes sense though. It'd also be nigh-impossible to fix without an overarching aim-lock code though.
;Maybe fix spin/space jump aiming - DONE

;81B339 is part of new game initialization, probably leave alone.
;8BBC08 inits controls for new game demos, I guess. I think I should leave it alone. Next routine returns controls
;Noteworthy BITs: 90C4BF, 90C4CB, 91822B, 91826B, 918299
;91882D inits controls for title screen demos
;8180E1 loads controls
;82F241 restores defaults
;82F558 writes to controls after controls menu (uses 82F54A)
;82F4DC loads from controls for controls menu (uses 82F54A)

;UPDATE: 8/17/09
;Adding power-bomb-always when Brandish is pressed.

lorom
;Powerbomb checks Brandish instead of selected item. I would like this to take $12 bytes
org $90BFA0
	LDA $008B	;So I don't need a NOP
	BIT $09B2
	BEQ LayNothing
	BIT $09BC	;Check Brandish, not selected item
	BEQ LayBomb
	LDA $09CE	;Whoops... fix a nasty bug that was in the original CF I think
	BNE LayPB
;org $90BFB2
LayNothing:

org $90BFCA
LayBomb:

org $90C01C
LayPB:

;Stupid powerbomb bug fixes. NINTENDO WHY DO YOU MAKE SILLY CODE
org $90C04C
	LDA #$0003
org $90C099
	BRA PBCheck
org $90C0A1
PBCheck:


org $8BBC08
	LDA $09B2
	STA $0D82
	LDA $09B4
	STA $0D84
	LDA $09B6
	STA $0D86
	LDA $09B8
	STA $0D88
	LDA $09BA
	STA $0D8A
	LDA $09BC
	STA $0D8C
	LDA $09BE
	STA $0D8E
	LDA $09E4
	STA $0D90
	LDA #$0040
	STA $09B2
	LDA #$0080
	STA $09B4
	LDA #$8000
	STA $09B6
	LDA #$4000
	STA $09B8
	LDA #$2000
	STA $09BA
	LDA #$0020
	STA $09BC
	LDA #$0010
	STA $09BE
	STZ $09E4
	RTS
Restore:
	LDA $0D90
	STA $09E4
	LDA $0D82
	STA $09B2
	LDA $0D84
	STA $09B4
	LDA $0D86
	STA $09B6
	LDA $0D88
	STA $09B8
	LDA $0D8A
	STA $09BA
	LDA $0D8C
	STA $09BC
	LDA $0D8E
	STA $09BE
	RTS

org $8BB769
	JSR Restore

org $82F5CA
	RTS	;Show aim and brandish button graphics

;Old item cancel checks
org $91822E
	DB $80
org $91826E
	DB $80
org $91829C
	DB $80


org $90DDCA
	BIT $09B8	;Item Cancel is now X-Ray scope

org $91CAE3
	BIT $09B8	;Item Cancel is now X-Ray scope

org $888737
	BIT $09B8	;Item Cancel is now X-Ray scope

org $888759
	BIT $09B8	;Item Cancel is now X-Ray scope

org $8887B0
	BIT $09B8	;Item Cancel is now X-Ray scope

;org $90DD3D	;Handle currently selected item. I'll just do everything in the selection routine, so skipping this.
;	PHP
;	REP #$30
;	LDA $0D32
;	CMP #$C4F0
;	BEQ +
;	LDX #$0008
;	BRA ++
;+
;	LDA $0A78
;	BEQ +
;	LDX #$000A
;	BRA ++
;+
;	LDA $09D2
;	ASL A
;	TAX    
;++
;	JSR ($DD61, X)  ;  $85D61 IN ROM
;	PLP
;	RTS

org $90BF20
	PLP	;Skip one-shot and depleted cancel checks for missiles
	RTS

org $90C08C
	PLP	;Skip one-shot and depleted cancel checks for powerbombs
	RTS

org $809C55
	LDA $0A04	;Use new value instead of 09D2

org $809C6C
	LDA $0A04
	
org $90C4EC
	LDA $0A04	;Use new value instead of 09D2

org $9BC8B9
	RTS	;Skip one-shot for grapple

org $9BC9AE
	RTS	;Skip one-shot for grapple

org $9BCA59
	RTS	;Skip one-shot for grapple

org $9BCBEF
	RTS	;Skip one-shot for grapple

org $888A97
	PLP	;Skip one-shot for x-ray
	RTS

org $809C96
	BRA $12	;Skip graphic effect of one-shot

org $90AD70
	STZ $0A04
	JSR SelectionHack

org $90F640
SelectionHack:
	LDA $8F
	PHA
	LDA $09BA
	STA $8F
	JSR $C4B5
	PLA
	STA $8F
	RTS

AutoRunCheck:
	AND $09B6
	PHX
	LDX $09E4
	BEQ +
	EOR $09B6
+
	PLX
	BIT $09B6	
	RTS

SuitPallete:
	JSL $91DEBA
	LDA $0DC2
	RTS	
	

org $90B98B
	JSR SuitPallete

org $90C4B5	;Select routine. Need to add all my features into this.
	PHP
	REP #$30
	LDA $09D2
	STA $12
	LDA $8F
	BIT $09BA
	BEQ +
	LDA $0A04
	INC
	CMP #$0005
	BNE ++
	LDA #$0001
++
-
	STA $0A04
	ASL
	TAX
	SEC
	JSR (SelectionTests-2,X)
	BCC +
	LDA $0A04
	INC
	BRA -
+
	LDA $8B
	BIT $09B8
	BEQ +
	LDA $09A2
	BPL +
	LDA #$0005
	STA $09D2
	PLP
	RTS
+
	STZ $09D2
	BIT $09BC
	BEQ +
	LDA $0A04
	STA $09D2
+
	LDA $09D2
	CMP $12
	BNE +
	LDA $0AAA
	INC A
	CMP #$0003
	BMI ++
	LDA #$0002
++
	STA $0AAA
	PLP
	RTS
+
	LDA #$0001
	STA $0AAA
	PLP
	RTS

SelectionTests:
	DW MissileST,SuperST,PBST,GrappleST,NoneST

MissileST:
	LDA $09C8
	BEQ +
	CLC
+
	RTS
SuperST:
	LDA $09CC
	BEQ +
	CLC
+
	RTS
PBST:
	LDA $09D0
	BEQ +
	CLC
+
	RTS
GrappleST:
	LDA $09A2
	BIT #$4000
	BEQ +
	CLC
+
	RTS
NoneST:
	STZ $0A04
	LDA $09C8
	BNE +
	LDA $09CC
	BNE +
	LDA $09D0
	BNE +
	LDA $09A2
	BIT #$4000
	BNE +
	CLC
+
	RTS

org $9181A9
	PHB
	PEA $B8B8
	PLB
	PLB
	LDA $8B
	BEQ +
	JSR KeySetup
	LDA $0A1C
	ASL A
	TAX
	LDY $8000, X
	LDA $0000, Y
	INC A
	BEQ ++
-
	DEC A
	BEQ +++
	AND $12
	BNE $07	;++++
+++
	LDA $0002, Y
	AND $14
	BEQ +++
;++++
	TYA
	CLC
	ADC #$0006
	TAY
	LDA $0000, Y
	INC A
	BNE -
+
	STZ $0A18
	JSL $9182D9  ;  $882D9 IN ROM
++
-
	CLC
	PLB
	RTS

+++
	LDA $0004, Y
	CMP $0A1C
	BEQ -
	STA $0A28
	STZ $0A56
	SEC
	PLB
	RTS

KeySetup:
	LDA $8F
	AND #$0F00
	STA $12
	LDA $8B
	AND #$0F00
	STA $14
	LDY $8F
	TYA
	BIT $09B2
	BEQ +
	LDA #$0040
	TSB $12
	TYA
+
	BIT $09B4
	BEQ +
	LDA #$0080
	TSB $12
	TYA
+
	BIT $09B6
	BEQ +
	LDA #$8000
	TSB $12
	TYA
+
	BIT $09B8
	BEQ +
	LDA #$4000
	TSB $12
	TYA
+
	BIT $09BE
	BEQ +
	LDA #$0010
	TSB $12
+
	LDA $12
	EOR #$FFFF
	STA $12
	LDY $8B
	TYA
	BIT $09B2
	BEQ +
	LDA #$0040
	TSB $14
	TYA
+
	BIT $09B4
	BEQ +
	LDA #$0080
	TSB $14
	TYA
+
	BIT $09B6
	BEQ +
	LDA #$8000
	TSB $14
	TYA
+
	BIT $09B8
	BEQ +
	LDA #$4000
	TSB $14
	TYA
+
	BIT $09BE
	BEQ +
	LDA #$0010
	TSB $14
+
	LDA $14
	EOR #$FFFF
	STA $14
	RTS

org $92DF30
	DW $1600
org $92DF34
	DW $1600
org $92DF38
	DW $1600
org $92DF44
	DW $1600
org $92DF48
	DW $1600
org $92DF4C
	DW $1600
org $92DF58
	DW $1700
org $92DF5C
	DW $1700
org $92DF60
	DW $1700
org $92DF6C
	DW $1700
org $92DF70
	DW $1700
org $92DF74
	DW $1700

org $91E8FE
	LDX $0A1C
	LDA FallTransitions,X
	AND #$00FF
	STA $0A28
	LDA #$0005
	STA $0A2E
	RTS

org $919EE2
FallTransitions:	;29, 2A, 31, 32, 33, 34, 7D, 7E
	;Adding 2B, 6D, 6F
	DB $29,$29,$2A,$2B,$2C,$6D,$6E,$6F,$70,$29,$2A,$29,$2A,$2B,$2C,$6D
	DB $6E,$6F,$70,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$31,$31,$32
	DB $33,$33,$33,$34,$33,$FF,$FF,$29,$2A,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DB $FF,$32,$34,$FF,$FF,$29,$2A,$29,$2A,$29,$2A,$FF,$FF,$FF,$FF,$FF
	DB $FF,$FF,$FF,$29,$2A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$29,$2A,$29
	DB $2A,$FF,$FF,$29,$2A,$29,$2A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DB $FF,$6D,$6E,$6F,$70,$6D,$6E,$6F,$70,$7D,$7E,$7D,$7E,$FF,$FF,$FF
	DB $FF,$FF,$FF,$FF,$FF,$2B,$2C,$FF,$FF,$29,$2A,$FF,$FF,$FF,$FF,$FF
	DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$29,$FF,$FF,$FF,$FF
	DB $FF,$FF,$FF,$FF,$29,$2A,$29,$2A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$6D
	DB $6E,$6F,$70,$FF,$FF,$29,$2A,$29,$2A,$29,$2A,$FF,$FF,$FF,$FF,$FF
	DB $2B,$2C,$6D,$6E,$6F,$70,$29,$2A,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	DB $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF

org $9284CF
;Need to copy pattern from other running tilemaps(904F7 and 9050B) and apply to 97FF and 981A bases
;5798 5798 E39C B29D E39C 5798 5798 E39C B29D E39C
;7298 7298 FE9C CD9D FE9C 7298 7298 FE9C CD9D FE9C
DW $97FF,$97FF,RAimUpFrame2,RAimUpFrame3,RAimUpFrame2,$97FF,$97FF,RAimUpFrame2,RAimUpFrame3,RAimUpFrame2
DW $981A,$981A,LAimUpFrame2,LAimUpFrame3,LAimUpFrame2,$981A,$981A,LAimUpFrame2,LAimUpFrame3,LAimUpFrame2

;97FF
;0500
;F901 F9 0228
;F901 F1 0328
;FE01 E1 0428
;FE01 E9 0528
;F9C3 F1 0028

org $92EDF4
RAimUpFrame2:
DB $05,$00
DB $F9,$01,$F7,$02,$28
DB $F9,$01,$EF,$03,$28
DB $FE,$01,$E0,$04,$28
DB $FE,$01,$E8,$05,$28
DB $F9,$C3,$F0,$00,$28

RAimUpFrame3:
DB $05,$00
DB $F9,$01,$F7,$02,$28
DB $F9,$01,$EF,$03,$28
DB $FE,$01,$DF,$04,$28
DB $FE,$01,$E7,$05,$28
DB $F9,$C3,$EF,$00,$28

;981A
;0500
;FF01 F9 0228
;FF01 F1 0328
;FA01 E1 0468
;F7C3 F1 0028
;FA01 E9 0568

LAimUpFrame2:
DB $05,$00
DB $FF,$01,$F7,$02,$28
DB $FF,$01,$EF,$03,$28
DB $FA,$01,$E0,$04,$68
DB $F7,$C3,$F0,$00,$28
DB $FA,$01,$E8,$05,$68

LAimUpFrame3:
DB $05,$00
DB $FF,$01,$F7,$02,$28
DB $FF,$01,$EF,$03,$28
DB $FA,$01,$DF,$04,$68
DB $F7,$C3,$EF,$00,$28
DB $FA,$01,$E7,$05,$68





;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $97FF
;	DW $981A
;	DW $981A
;	DW $981A
;	DW $981A
;	DW $981A
;	DW $981A
;	DW $981A
;	DW $981A
;	DW $981A
;	DW $981A

org $9183DF
	JSR ToggleWalk

org $91FFEE
ToggleWalk:
	LDA $0A86
	EOR #$0020
	STA $0A86
	LDA $0A84
	EOR #$0020
	RTS

org $8BAF44
	STA $0A04

org $908542
	JSR AutoRunCheck
	BNE $03
	
org $909781
	JSR AutoRunCheck
	BNE $03

org $B88000
	DW T00,T01,T02,T03,T04,T05,T06,T07,T08,T09,T0A,T0B,T0C,T0D,T0E,T0F
	DW T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T1A,T1B,T1C,T1D,T1E,T1F
	DW T20,T21,T22,T23,T24,T25,T26,T27,T28,T29,T2A,T2B,T2C,T2D,T2E,T2F
	DW T30,T31,T32,T33,T34,T35,T36,T37,T38,T39,T3A,T3B,T3C,T3D,T3E,T3F
	DW T40,T41,T42,T43,T44,T45,T46,T47,T48,T49,T4A,T4B,T4C,T4D,T4E,T4F
	DW T50,T51,T52,T53,T54,T55,T56,T57,T58,T59,T5A,T5B,T5C,T5D,T5E,T5F
	DW T60,T61,T62,T63,T64,T65,T66,T67,T68,T69,T6A,T6B,T6C,T6D,T6E,T6F
	DW T70,T71,T72,T73,T74,T75,T76,T77,T78,T79,T7A,T7B,T7C,T7D,T7E,T7F
	DW T80,T81,T82,T83,T84,T85,T86,T87,T88,T89,T8A,T8B,T8C,T8D,T8E,T8F
	DW T90,T91,T92,T93,T94,T95,T96,T97,T98,T99,T9A,T9B,T9C,T9D,T9E,T9F
	DW TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7,TA8,TA9,TAA,TAB,TAC,TAD,TAE,TAF
	DW TB0,TB1,TB2,TB3,TB4,TB5,TB6,TB7,TB8,TB9,TBA,TBB,TBC,TBD,TBE,TBF
	DW TC0,TC1,TC2,TC3,TC4,TC5,TC6,TC7,TC8,TC9,TCA,TCB,TCC,TCD,TCE,TCF
	DW TD0,TD1,TD2,TD3,TD4,TD5,TD6,TD7,TD8,TD9,TDA,TDB,TDC,TDD,TDE,TDF
	DW TE0,TE1,TE2,TE3,TE4,TE5,TE6,TE7,TE8,TE9,TEA,TEB,TEC,TED,TEE,TEF
	DW TF0,TF1,TF2,TF3,TF4,TF5,TF6,TF7,TF8,TF9,TFA,TFB,TFC

T00:
T9B:
DW $0000,$0100,$0026
DW $0000,$0200,$0025
DW $FFFF

T03:	;U
TE0:	;U
DW $0080,$0800,$0055	;U
DW $0080,$0410,$0059	;DR
DW $0080,$0010,$0055	;U
DW $0080,$0000,$004B	;R
DW $0400,$0010,$0005	;UR
DW $0400,$0000,$0035	;R
DW $0000,$0110,$000D	;U
DW $0000,$0900,$000F	;UR
DW $0000,$0500,$0011	;DR
DW $0000,$0210,$008B	;U
DW $0000,$0200,$0025	;R
DW $0000,$0010,$0003	;U
DW $0000,$0800,$0003	;U
DW $0000,$0100,$0009	;R
DW $FFFF

T05:	;UR
TE2:	;UR
TCF:	;UR
DW $0880,$0010,$0055	;U
DW $0480,$0010,$0059	;DR
DW $0080,$0010,$0057	;UR
DW $0080,$0800,$0055	;U
DW $0080,$0000,$004B	;R
DW $0400,$0010,$0007	;DR
DW $0400,$0000,$0035	;R
DW $0800,$0110,$000D	;U
DW $0000,$0110,$000F	;UR
DW $0800,$0100,$000F	;UR
DW $0000,$0210,$009C	;UR
DW $0000,$0200,$0025	;R
DW $0800,$0010,$0003	;U
DW $0000,$0010,$0005	;UR
DW $0000,$0800,$0003	;U
DW $0000,$0100,$0009	;R
DW $FFFF

T07:	;DR
TD1:	;DR
TE4:	;DR
DW $0080,$0800,$0055	;U
DW $0080,$0010,$0059	;DR
DW $0080,$0000,$004B	;R
DW $0400,$0010,$00F5	;DR
DW $0400,$0000,$0035	;R
DW $0800,$0110,$000F	;U
DW $0000,$0110,$0011	;DR
DW $0000,$0210,$008D	;DR
DW $0000,$0200,$0025	;R
DW $0800,$0010,$0005	;UR
DW $0000,$0010,$0007	;DR
DW $0000,$0800,$0003	;U
DW $0000,$0100,$0009	;R
DW $FFFF

T01:	;R
TA4:	;R
TA6:	;R
TE6:	;R
T89:	;R
DW $0080,$0800,$0055	;U
DW $0080,$0410,$0059	;DR
DW $0080,$0010,$0057	;UR
DW $0080,$0000,$004B	;R
DW $0400,$0010,$0007	;DR
DW $0400,$0000,$0035	;R
DW $0000,$0910,$000D	;U
DW $0000,$0110,$000F	;UR
DW $0000,$0900,$000F	;UR
DW $0000,$0500,$0011	;DR
DW $0000,$0200,$0025	;R
DW $0000,$0810,$0003	;U
DW $0000,$0410,$0007	;DR
DW $0000,$0010,$0005	;UR
DW $0000,$0800,$0003	;U
DW $0000,$0100,$0009	;R
DW $FFFF



T04:	;U
TE1:	;U
DW $0080,$0800,$0056	;U
DW $0080,$0410,$005A	;DL
DW $0080,$0010,$0056	;U
DW $0080,$0000,$004C	;L
DW $0400,$0010,$0006	;DL
DW $0400,$0000,$0036	;L
DW $0000,$0210,$000E	;U
DW $0000,$0A00,$0010	;UL
DW $0000,$0110,$008C	;U
DW $0000,$0100,$0026	;L
DW $0000,$0010,$0004	;U
DW $0000,$0800,$0004	;U
DW $0000,$0200,$000A	;L
DW $FFFF

T06:	;UL
TD0:	;UL
TE3:	;UL
DW $0880,$0010,$0056	;U
DW $0480,$0010,$005A	;DL
DW $0080,$0010,$0058	;UL
DW $0080,$0800,$0056	;U
DW $0080,$0000,$004C	;L
DW $0400,$0010,$0008	;DL
DW $0400,$0000,$0036	;L
DW $0800,$0210,$000E	;U
DW $0000,$0210,$0010	;UL
DW $0800,$0200,$0010	;UL
DW $0000,$0110,$009D	;UL
DW $0000,$0100,$0026	;L
DW $0800,$0010,$0004	;U
DW $0000,$0010,$0006	;UL
DW $0000,$0800,$0004	;U
DW $0000,$0200,$000A	;L
DW $FFFF

TD2:	;DL
T08:	;DL
TE5:	;DL
DW $0880,$0810,$0058	;U
DW $0080,$0800,$0056	;U
DW $0080,$0010,$005A	;DL
DW $0080,$0000,$004C	;L
DW $0400,$0010,$00F6	;DL
DW $0400,$0000,$0036	;L
DW $0800,$0210,$0010	;U
DW $0000,$0210,$0012	;DL
DW $0000,$0110,$008E	;DL
DW $0000,$0100,$0026	;L
DW $0800,$0010,$0006	;UL
DW $0000,$0010,$0008	;DL
DW $0000,$0800,$0004	;U
DW $0000,$0200,$000A	;L
DW $FFFF


T02:	;L
T8A:	;L
TA5:	;L
TA7:	;L
TE7:	;L
DW $0080,$0800,$0056	;U
DW $0080,$0410,$005A	;DL
DW $0080,$0010,$0058	;UL
DW $0080,$0000,$004C	;L
DW $0400,$0010,$0008	;DL
DW $0400,$0000,$0036	;L
DW $0000,$0A10,$000E	;U
DW $0000,$0210,$0010	;UL
DW $0000,$0A00,$0010	;UL
DW $0000,$0600,$0012	;DL
DW $0000,$0100,$0026	;L
DW $0000,$0810,$0004	;U
DW $0000,$0410,$0008	;DL
DW $0000,$0010,$0006	;UL
DW $0000,$0800,$0004	;U
DW $0000,$0200,$000A	;L
DW $FFFF


T09:	;R
DW $0400,$0110,$0011	;DR
DW $0400,$0010,$0007	;DR
DW $0400,$0000,$0035	;R
DW $0080,$0000,$0019	;Spinjump
DW $0000,$0910,$000D	;U
DW $0000,$0900,$000F	;UR
DW $0000,$0500,$0011	;DR
DW $0000,$0110,$000F	;UR
DW $0000,$0140,$000B	;R
DW $0000,$0100,$0009	;R
DW $0000,$0200,$0025	;R
DW $0000,$0800,$0003	;U
DW $0000,$0410,$0007	;DR
DW $0000,$0010,$0005	;UR
DW $FFFF

T0D:	;U
DW $0400,$0110,$000F	;DR
DW $0400,$0010,$0005	;DR
DW $0400,$0000,$0035	;R
DW $0080,$0010,$0055	;Spinjump
DW $0080,$0000,$0019	;Spinjump
DW $0000,$0910,$000D	;U
DW $0000,$0900,$000F	;UR
DW $0000,$0110,$000D	;U
DW $0000,$0140,$000B	;R
DW $0000,$0100,$0009	;R
DW $0000,$0210,$008B	;U
DW $0000,$0200,$0025	;R
DW $0000,$0800,$0003	;U
DW $0000,$0010,$0003	;U
DW $FFFF

T0F:	;UR
DW $0400,$0110,$0011	;DR
DW $0400,$0010,$0007	;DR
DW $0400,$0000,$0035	;R
DW $0080,$0010,$0057	;Spinjump
DW $0080,$0000,$0019	;Spinjump
DW $0800,$0110,$000D	;U
DW $0000,$0110,$000F	;UR
DW $0000,$0900,$000F	;UR
DW $0000,$0140,$000B	;R
DW $0000,$0100,$0009	;R
DW $0000,$0210,$009C	;UR
DW $0000,$0010,$0005	;UR
DW $0000,$0200,$0025	;R
DW $0000,$0800,$0003	;U
DW $FFFF

T11:	;DR
DW $0400,$0010,$00F5	;DR
DW $0400,$0000,$0035	;R
DW $0080,$0010,$0059	;DR
DW $0080,$0000,$0019	;Spinjump
DW $0800,$0110,$000F	;U
DW $0000,$0500,$0011	;DR
DW $0000,$0110,$0011	;DR
DW $0000,$0140,$000B	;R
DW $0000,$0900,$000F	;UR
DW $0000,$0100,$0009	;R
DW $0000,$0210,$008D	;DR
DW $0000,$0200,$0025	;R
DW $0000,$0800,$0003	;U
DW $0000,$0010,$0007	;DR
DW $FFFF


T0A:	;L
DW $0400,$0210,$0012	;DL
DW $0400,$0010,$0008	;DL
DW $0400,$0000,$0036	;L
DW $0080,$0000,$001A	;Spinjump
DW $0000,$0A10,$000E	;U
DW $0000,$0A00,$0010	;UL
DW $0000,$0600,$0012	;DL
DW $0000,$0210,$0010	;UL
DW $0000,$0240,$000C	;L
DW $0000,$0200,$000A	;L
DW $0000,$0100,$0026	;L
DW $0000,$0800,$0004	;U
DW $0000,$0410,$0008	;DL
DW $0000,$0010,$0006	;UL
DW $FFFF

T0E:	;U
DW $0400,$0210,$0010	;DL
DW $0400,$0010,$0006	;DL
DW $0400,$0000,$0036	;L
DW $0080,$0010,$0056	;U
DW $0080,$0000,$001A	;Spinjump
DW $0000,$0A10,$000E	;U
DW $0000,$0A00,$0010	;UL
DW $0000,$0210,$000E	;U
DW $0000,$0240,$000C	;L
DW $0000,$0200,$000A	;L
DW $0000,$0110,$008C	;U
DW $0000,$0100,$0026	;L
DW $0000,$0800,$0004	;U
DW $0000,$0010,$0004	;U
DW $FFFF

T10:	;UL
DW $0400,$0210,$0012	;DL
DW $0400,$0010,$0008	;DL
DW $0400,$0000,$0036	;L
DW $0080,$0010,$0058	;UL
DW $0080,$0000,$001A	;Spinjump
DW $0800,$0210,$000E	;U
DW $0000,$0210,$0010	;UL
DW $0000,$0A00,$0010	;UL
DW $0000,$0240,$000C	;L
DW $0000,$0200,$000A	;L
DW $0000,$0110,$009D	;UL
DW $0000,$0010,$0006	;UL
DW $0000,$0100,$0026	;L
DW $0000,$0800,$0004	;U
DW $FFFF

T12:	;DL
DW $0400,$0010,$00F6	;DL
DW $0400,$0000,$0036	;L
DW $0080,$0010,$005A	;DL
DW $0080,$0000,$001A	;Spinjump
DW $0800,$0210,$0010	;U
DW $0000,$0600,$0012	;DL
DW $0000,$0210,$0012	;DL
DW $0000,$0240,$000C	;L
DW $0000,$0A00,$0010	;UL
DW $0000,$0200,$000A	;L
DW $0000,$0110,$008E	;DL
DW $0000,$0100,$0026	;L
DW $0000,$0800,$0004	;U
DW $0000,$0010,$0008	;DL
DW $FFFF

T0B:	;R
DW $0400,$0110,$0011	;DR
DW $0400,$0010,$0007	;DR
DW $0400,$0000,$0035	;R
DW $0080,$0000,$0019	;Spinjump
DW $0000,$0910,$000D	;U
DW $0000,$0900,$000F	;UR
DW $0000,$0500,$0011	;DR
DW $0000,$0110,$000F	;UR
DW $0000,$0100,$000B	;R
DW $0000,$0200,$0025	;R
DW $0000,$0800,$0003	;U
DW $0000,$0410,$0007	;DR
DW $0000,$0010,$0005	;UR
DW $FFFF

T0C:
DW $0400,$0210,$0012	;DR
DW $0400,$0010,$0008	;DR
DW $0400,$0000,$0036	;R
DW $0080,$0000,$001A	;Spinjump
DW $0000,$0A10,$000E	;U
DW $0000,$0A00,$0010	;UR
DW $0000,$0600,$0012	;DR
DW $0000,$0210,$0010	;UR
DW $0000,$0200,$000C	;R
DW $0000,$0100,$0026	;R
DW $0000,$0800,$0004	;U
DW $0000,$0410,$0008	;DR
DW $0000,$0010,$0006	;UR
DW $FFFF

T13:	;R
DW $0000,$0910,$0015	;U. Not sure if this will work
DW $0000,$0900,$0069	;UR
DW $0000,$0500,$006B	;DR
DW $0000,$0190,$0069	;UR
DW $0000,$0200,$002F	;R
DW $0000,$0800,$0015	;U
DW $0000,$0410,$006B	;DR
DW $0000,$0400,$0017	;D
DW $0000,$0010,$0069	;UR
DW $0000,$0100,$0051	;R
DW $0000,$0040,$0013	;R
DW $FFFF

T14:	;L
DW $0000,$0A10,$0016	;U. Not sure if this will work
DW $0000,$0A00,$006A	;UL
DW $0000,$0600,$006C	;DL
DW $0000,$0290,$006A	;UL
DW $0000,$0100,$0030	;L
DW $0000,$0800,$0016	;U
DW $0000,$0410,$006C	;DL
DW $0000,$0400,$0018	;D
DW $0000,$0010,$006A	;UL
DW $0000,$0200,$0052	;L
DW $0000,$0040,$0014	;L
DW $FFFF

T15:	;U
DW $0000,$0910,$0015	;U. Not sure if this will work
DW $0000,$0900,$0069	;UR
DW $0000,$0190,$0015	;U, not sure
DW $0000,$0200,$002F	;R
DW $0000,$0800,$0015	;U
DW $0400,$0010,$0069	;DR
DW $0000,$0010,$0015	;U
DW $0000,$0500,$006B	;DR
DW $0000,$0400,$0017	;D
DW $0000,$0100,$0051	;R
DW $0000,$00C0,$0013	;R
DW $0000,$0080,$004D	;R
DW $0000,$0040,$0013	;R
DW $FFFF

T4D:	;R
T51:	;R
DW $0000,$0910,$0015	;U. Not sure if this will work
DW $0000,$0900,$0069	;UR
DW $0000,$0500,$006B	;DR
DW $0000,$0190,$0069	;UR
DW $0000,$0200,$002F	;R
DW $0000,$0800,$0015	;U
DW $0000,$0410,$006B	;DR
DW $0000,$0400,$0017	;D
DW $0000,$0010,$0069	;UR
DW $0000,$0100,$0051	;R
DW $0000,$00C0,$0013	;R
DW $0000,$0080,$004D	;R
DW $0000,$0040,$0013	;R
DW $FFFF

T69:	;UR
DW $0000,$0200,$002F	;R
DW $0800,$0010,$0015	;U. Not sure if this will work
DW $0400,$0010,$006B	;DR
DW $0000,$0010,$0069	;UR
DW $0000,$0900,$0069	;UR
DW $0000,$0500,$006B	;DR
DW $0000,$0800,$0015	;U
DW $0000,$0400,$0017	;D
DW $0000,$0100,$0051	;R
DW $0000,$00C0,$0013	;R
DW $0000,$0080,$004D	;R
DW $0000,$0040,$0013	;R
DW $FFFF

T6B:	;DR
DW $0000,$0200,$002F	;R
DW $0800,$0010,$0069	;U. Not sure if this will work
DW $0000,$0010,$006B	;UR
DW $0000,$0900,$0069	;UR
DW $0000,$0500,$006B	;DR
DW $0000,$0800,$0015	;U
DW $0000,$0400,$0017	;D
DW $0000,$0100,$0051	;R
DW $0000,$00C0,$0013	;R
DW $0000,$0080,$004D	;R
DW $0000,$0040,$0013	;R
DW $FFFF



T16:	;U
DW $0000,$0A10,$0016	;U. Not sure if this will work
DW $0000,$0A00,$006A	;UL
DW $0000,$0290,$0016	;U, not sure
DW $0000,$0100,$0030	;L
DW $0000,$0800,$0016	;U
DW $0400,$0010,$006A	;DL
DW $0000,$0010,$0016	;U
DW $0000,$0600,$006C	;DL
DW $0000,$0400,$0018	;D
DW $0000,$0200,$0052	;L
DW $0000,$00C0,$0014	;L
DW $0000,$0080,$004E	;L
DW $0000,$0040,$0014	;L
DW $FFFF

T4E:	;L
T52:	;L
DW $0000,$0A10,$0016	;U. Not sure if this will work
DW $0000,$0A00,$006A	;UL
DW $0000,$0600,$006C	;DL
DW $0000,$0290,$006A	;UL
DW $0000,$0100,$0030	;L
DW $0000,$0800,$0016	;U
DW $0000,$0410,$006C	;DL
DW $0000,$0400,$0018	;D
DW $0000,$0010,$006A	;UL
DW $0000,$0200,$0052	;L
DW $0000,$00C0,$0014	;L
DW $0000,$0080,$004E	;L
DW $0000,$0040,$0014	;L
DW $FFFF

T6A:	;UL
DW $0000,$0100,$0030	;L
DW $0800,$0010,$0016	;DL
DW $0400,$0010,$006C	;DL
DW $0000,$0010,$006A	;UL
DW $0000,$0A00,$006A	;UL
DW $0000,$0600,$006C	;DL
DW $0000,$0400,$0018	;D
DW $0000,$0800,$0016	;U
DW $0000,$0200,$0052	;L
DW $0000,$00C0,$0014	;L
DW $0000,$0080,$004E	;L
DW $0000,$0040,$0014	;L
DW $FFFF


T6C:	;DL
DW $0000,$0100,$0030	;L
DW $0800,$0010,$006A	;U. Not sure if this will work
DW $0000,$0010,$006C	;UL
DW $0000,$0600,$006C	;DL
DW $0000,$0800,$0016	;U
DW $0000,$0400,$0018	;D
DW $0000,$0200,$0052	;L
DW $0000,$00C0,$0014	;L
DW $0000,$0080,$004E	;L
DW $0000,$0040,$0014	;L
DW $FFFF


T17:	;D
DW $0400,$0000,$0037	;Morph
DW $0000,$0910,$0015	;U. Not sure if this will work
DW $0000,$0900,$0069	;UR
DW $0000,$0500,$006B	;DR
DW $0000,$0190,$0069	;UR
DW $0000,$0200,$002F	;R
DW $0000,$0800,$0015	;U
DW $0000,$0410,$006B	;DR
DW $0000,$0400,$0017	;D
DW $0000,$0010,$006B	;UR
DW $0000,$0100,$0051	;R
DW $0000,$00C0,$0013	;R
DW $0000,$0080,$0017	;R
DW $0000,$0040,$0013	;R
DW $FFFF

T18:	;D
DW $0400,$0000,$0038	;Morph
DW $0000,$0A10,$0016	;U. Not sure if this will work
DW $0000,$0A00,$006A	;UL
DW $0000,$0600,$006C	;DL
DW $0000,$0290,$006A	;UL
DW $0000,$0100,$0030	;L
DW $0000,$0800,$0016	;U
DW $0000,$0410,$006C	;DL
DW $0000,$0400,$0018	;D
DW $0000,$0010,$006C	;UL
DW $0000,$0200,$0052	;L
DW $0000,$00C0,$0014	;L
DW $0000,$0080,$0018	;D
DW $0000,$0040,$0014	;L
DW $FFFF

T19:	;Spinjump
DW $0000,$0810,$0015
DW $0000,$0410,$006B
DW $0000,$0010,$0069
DW $0040,$0900,$0069
DW $0040,$0500,$006B
DW $0040,$0400,$0017
DW $0040,$0000,$0013
DW $0000,$0100,$0019
DW $0000,$0200,$001A
DW $0000,$0800,$0015
DW $0000,$0400,$0017
DW $FFFF

T1A:	;Spinjump
DW $0000,$0810,$0016
DW $0000,$0410,$006C
DW $0000,$0010,$006A
DW $0040,$0A00,$006A
DW $0040,$0600,$006C
DW $0040,$0400,$0018
DW $0040,$0000,$0014
DW $0000,$0200,$001A
DW $0000,$0100,$0019
DW $0000,$0800,$0016
DW $0000,$0400,$0018
DW $FFFF

T1B:	;Spacejump
DW $0000,$0810,$0015
DW $0000,$0410,$006B
DW $0000,$0010,$0069
DW $0040,$0900,$0069
DW $0040,$0500,$006B
DW $0040,$0400,$0017
DW $0040,$0000,$0013
DW $0000,$0100,$001B
DW $0000,$0200,$001C
DW $0000,$0800,$0015
DW $0000,$0400,$0017
DW $FFFF

T1C:	;Spacejump
DW $0000,$0810,$0016
DW $0000,$0410,$006C
DW $0000,$0010,$006A
DW $0040,$0A00,$006A
DW $0040,$0600,$006C
DW $0040,$0400,$0018
DW $0040,$0000,$0014
DW $0000,$0200,$001C
DW $0000,$0100,$001B
DW $0000,$0800,$0016
DW $0000,$0400,$0018
DW $FFFF

T1D:	;No changes
T1E:	;No changes
DW $0800,$0000,$003D
DW $0080,$0000,$003D
T1F:	;No changes
T41:	;No changes
DW $0800,$0000,$003E
DW $0080,$0000,$003E
DW $0000,$0100,$001E
DW $0000,$0200,$001F
DW $FFFF

T20:
T21:
T22:
T23:
T24:
T2F:
T30:
T33:
T34:
T35:
T36:
T37:
T38:
T39:
T3A:
T3B:
T3C:
T3D:
T3E:
T3F:
T40:
T42:
T43:
T44:
T47:
T48:
T4B:
T4C:
T55:
T56:
T57:
T58:
T59:
T5A:
T5B:
T5C:
T5D:
T5E:
T5F:
T60:
T61:
T62:
T63:
T64:
T65:
T66:
T87:
T88:
T8F:
T90:
T91:
T92:
T93:
T94:
T95:
T96:
T97:
T98:
T99:
T9A:
T9C:
T9D:
T9E:
T9F:
TA0:
TA1:
TA2:
TA3:
TA8:
TA9:
TAA:
TAB:
TAC:
TAD:
TAE:
TAF:
TB0:
TB1:
TB2:
TB3:
TB4:
TB5:
TB6:
TB7:
TB8:
TB9:
TC5:
TC6:
TC9:
TCA:
TCB:
TCC:
TCD:
TCE:
TD3:
TD4:
TD5:
TD6:
TD7:
TD8:
TD9:
TDA:
TDB:
TDC:
TDD:
TDE:
TE8:
TE9:
TEA:
TEB:
TF1:
TF2:
TF3:
TF4:
TF5:
TF6:
TF7:
TF8:
TF9:
TFA:
TFB:
TFC:
T49:
T75:
T77:
T4A:
T76:
T78:
	DW $FFFF

T25:	;Turning
DW $0000,$0280,$001A
DW $0080,$0000,$004C
DW $0000,$0200,$0025
DW $FFFF

T26:	;Turning
DW $0000,$0180,$0019
DW $0080,$0000,$004B
DW $0000,$0100,$0026
DW $FFFF


T27:	;R
DW $0800,$0010,$0085	;U
DW $0800,$0000,$003B	;R
DW $0200,$0000,$0043	;R
DW $0080,$0000,$004B	;R
DW $0000,$0410,$0073	;DR
DW $0400,$0000,$0037	;Morph
DW $0000,$0110,$0005	;UR
DW $0000,$0100,$0001	;R
DW $0000,$0010,$0071	;UR
DW $FFFF

T71:	;UR
DW $0800,$0010,$0085	;U
DW $0800,$0000,$003B	;R
DW $0200,$0000,$0043	;R
DW $0080,$0000,$0057	;R
DW $0400,$0010,$0073	;DR
DW $0400,$0000,$0037	;Morph
DW $0000,$0110,$0005	;UR
DW $0000,$0100,$0001	;R
DW $0000,$0010,$0071	;UR
DW $FFFF


T73:	;DR
DW $0800,$0010,$0071	;U
DW $0800,$0000,$003B	;R
DW $0200,$0000,$0043	;R
DW $0080,$0000,$004B	;R
DW $0400,$0000,$0037	;Morph
DW $0000,$0110,$0007	;DR
DW $0000,$0100,$0001	;R
DW $0000,$0010,$0073	;DR
DW $FFFF

T85:	;U
DW $0800,$0000,$00F7	;R
DW $0200,$0000,$0043	;R
DW $0080,$0000,$004B	;R
DW $0400,$0010,$0071	;DR
DW $0400,$0000,$0037	;Morph
DW $0000,$0110,$0003	;U
DW $0000,$0100,$0001	;R
DW $0000,$0010,$0085	;U
DW $FFFF

T28:
DW $0800,$0010,$0086
DW $0800,$0000,$003C
DW $0100,$0000,$0044
DW $0080,$0000,$004C
DW $0000,$0410,$0074
DW $0400,$0000,$0038
DW $0000,$0210,$0006
DW $0000,$0200,$0002
DW $0000,$0010,$0072
DW $FFFF

T72:
DW $0800,$0010,$0086
DW $0800,$0000,$003C
DW $0100,$0000,$0044
DW $0080,$0000,$0058
DW $0400,$0010,$0074
DW $0400,$0000,$0038
DW $0000,$0210,$0006
DW $0000,$0200,$0002
DW $0000,$0010,$0072
DW $FFFF


T74:
DW $0800,$0010,$0072
DW $0800,$0000,$003C
DW $0100,$0000,$0044
DW $0080,$0000,$004C
DW $0400,$0000,$0038
DW $0000,$0210,$0008
DW $0000,$0200,$0002
DW $0000,$0010,$0074
DW $FFFF

T86:
DW $0800,$0000,$00F8
DW $0100,$0000,$0044
DW $0080,$0000,$004C
DW $0400,$0010,$0072
DW $0400,$0000,$0038
DW $0000,$0210,$0004
DW $0000,$0200,$0002
DW $0000,$0010,$0086
DW $FFFF

T2D:	;D
DW $0400,$0000,$0037
DW $0000,$0200,$0087
DW $0000,$0810,$002B
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0410,$006F
DW $0000,$0400,$002D
DW $0000,$0010,$006F
DW $0000,$0040,$0067
DW $0000,$0100,$0029
DW $FFFF

T29:	;R
DW $0000,$0200,$0087
DW $0000,$0810,$002B
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0410,$006F
DW $0000,$0400,$002D
DW $0000,$0010,$006D
DW $0000,$0040,$0067
DW $0000,$0100,$0029
DW $FFFF

T6D:	;UR
DW $0000,$0200,$0087
DW $0800,$0010,$002B
DW $0400,$0010,$006F
DW $0000,$0010,$006D
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0400,$002D
DW $0000,$0040,$0067
DW $0000,$0100,$0029
DW $FFFF

T2B:	;U
DW $0000,$0200,$0087
DW $0400,$0010,$006D
DW $0000,$0010,$002B
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0400,$002D
DW $0000,$0040,$0067
DW $0000,$0100,$0029
DW $FFFF

T6F:	;DR
DW $0000,$0200,$0087
DW $0800,$0010,$006D
DW $0000,$0010,$006F
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0400,$002D
DW $0000,$0040,$0067
DW $0000,$0100,$0029
DW $FFFF

T2E:
DW $0400,$0000,$0038
DW $0000,$0100,$0088
DW $0000,$0810,$002C
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0410,$0070
DW $0000,$0400,$002E
DW $0000,$0010,$0070
DW $0000,$0040,$0068
DW $0000,$0200,$002A
DW $FFFF

T2A:
DW $0000,$0100,$0088
DW $0000,$0810,$002C
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0410,$0070
DW $0000,$0400,$002E
DW $0000,$0010,$006E
DW $0000,$0040,$0068
DW $0000,$0200,$002A
DW $FFFF

T6E:
DW $0000,$0100,$0088
DW $0800,$0010,$002C
DW $0400,$0010,$0070
DW $0000,$0010,$006E
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0400,$002E
DW $0000,$0040,$0068
DW $0000,$0200,$002A
DW $FFFF

T2C:
DW $0000,$0100,$0088
DW $0400,$0010,$006E
DW $0000,$0010,$002C
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0400,$002E
DW $0000,$0040,$0068
DW $0000,$0200,$002A
DW $FFFF

T70:
DW $0000,$0100,$0088
DW $0800,$0010,$006E
DW $0000,$0010,$0070
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0400,$002E
DW $0000,$0040,$0068
DW $0000,$0200,$002A
DW $FFFF

T31:
DW $0800,$0000,$003D
DW $0080,$0000,$003D
T32:
DW $0800,$0000,$003E
DW $0080,$0000,$003E
DW $0000,$0100,$0031
DW $0000,$0200,$0032
DW $FFFF

T45:
DW $0000,$0240,$0045
DW $0000,$0100,$0009
DW $0000,$0200,$0025
DW $FFFF

T46:
DW $0000,$0140,$0046
DW $0000,$0200,$000A
DW $0000,$0100,$0026
DW $FFFF

T4F:
DW $0000,$0280,$0052
DW $0000,$0180,$004F
DW $0000,$0080,$004E
DW $FFFF

T50:
DW $0000,$0280,$0050
DW $0000,$0180,$0051
DW $0000,$0080,$004D
DW $FFFF

T53:
DW $0000,$0280,$0050
DW $FFFF

T54:
DW $0000,$0180,$004F
DW $FFFF

T67:
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0400,$002D
DW $0000,$0200,$0087
DW $0000,$0410,$006F
DW $0000,$0010,$006D
DW $0000,$0040,$0067
DW $0000,$0100,$0067
DW $FFFF

T68:
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0400,$002E
DW $0000,$0100,$0088
DW $0000,$0410,$0070
DW $0000,$0010,$006E
DW $0000,$0040,$0068
DW $0000,$0200,$0068
DW $FFFF

T79:
T7B:
DW $0800,$0000,$003D
DW $0080,$0000,$007F
T7A:
T7C:
DW $0800,$0000,$003E
DW $0080,$0000,$0080
DW $0000,$0100,$007B
DW $0000,$0200,$007C
DW $FFFF

T7D:
DW $0800,$0000,$003D
T7E:
DW $0800,$0000,$003E
DW $0000,$0100,$007D
DW $0000,$0200,$007E
DW $FFFF

T7F:
DW $0800,$0000,$003D
T80:
DW $0800,$0000,$003E
DW $0000,$0100,$007F
DW $0000,$0200,$0080
DW $FFFF

T81:
DW $0000,$0810,$0015
DW $0000,$0410,$006B
DW $0000,$0010,$0069
DW $0040,$0900,$0069
DW $0040,$0500,$006B
DW $0040,$0400,$0017
DW $0040,$0000,$0013
DW $0000,$0100,$0081
DW $0000,$0200,$0082
DW $0000,$0800,$0015
DW $0000,$0400,$0017
DW $FFFF

T82:
DW $0000,$0810,$0016
DW $0000,$0410,$006C
DW $0000,$0010,$006A
DW $0040,$0A00,$006A
DW $0040,$0600,$006C
DW $0040,$0400,$0018
DW $0040,$0000,$0014
DW $0000,$0200,$0082
DW $0000,$0100,$0081
DW $0000,$0800,$0016
DW $0000,$0400,$0018
DW $FFFF

T83:
DW $0400,$0000,$0037	;Insta walljump morph
DW $0000,$0200,$001A
DW $0000,$0810,$0015
DW $0000,$0410,$006B
DW $0000,$0010,$0069
DW $0000,$0040,$0013
DW $0000,$0080,$0083
DW $FFFF

T84:
DW $0400,$0000,$0038
DW $0000,$0100,$0019
DW $0000,$0810,$0016
DW $0000,$0410,$006C
DW $0000,$0010,$006A
DW $0000,$0040,$0014
DW $0000,$0080,$0084
DW $FFFF




T8B:
T8D:
TBF:
TC1:
TC3:
DW $0080,$0200,$001A
DW $0080,$0000,$004C
DW $FFFF

T8C:
T8E:
TC0:
TC2:
TC4:
DW $0080,$0100,$0019
DW $0080,$0000,$004B
DW $FFFF

TBD:	;DL
DW $0000,$0810,$00BB
DW $0000,$0010,$00BD
TBA:	;L
TBB:	;UL
TBC:	;L
TBE:	;L
DW $0000,$0410,$00BD
DW $0000,$0010,$00BB
DW $0000,$0A40,$00BB
DW $0000,$0640,$00BD
DW $0000,$0040,$00BC
DW $0000,$0200,$00BE
DW $0000,$0100,$00BE
DW $0000,$0800,$00BE
DW $0000,$0400,$00BE
DW $FFFF

TC7:
DW $0000,$0880,$00CB
DW $0000,$0090,$00CD
DW $0000,$0180,$00C9
DW $FFFF

TC8:
DW $0000,$0880,$00CC
DW $0000,$0090,$00CE
DW $0000,$0280,$00CA
DW $FFFF

TDF:
DW $0800,$0000,$00DE
DW $FFFF

TEF:
DW $0000,$0810,$00ED
DW $0000,$0010,$00EF
TEC:
TED:
TEE:
TF0:
DW $0000,$0410,$00EF
DW $0000,$0010,$00ED
DW $0000,$0940,$00ED
DW $0000,$0540,$00EF
DW $0000,$0040,$00EE
DW $0000,$0200,$00F0
DW $0000,$0100,$00F0
DW $0000,$0800,$00F0
DW $0000,$0400,$00F0
DW $FFFF

warnpc $B8FFFF

; CONTROL FREAK

; START GAME

; ENGLISH TEXT
; JAPANESE TEXT (ASFLKJ)

; BUTTON CONFIGURATION

; SPECIAL SETTINGS


; BUTTON CONFIGURATION

; FIRE
; JUMP
; WALK/RUN
; SELECT ITEM
; X-RAY SCOPE
; AIM LOCK
; READY ITEM
; END
; RESTORE DEFAULTS


; SPECIAL SETTINGS

; ITEM RESET  DOOR   MANUAL
;(REVERTS TO MISSILES
; WHEN ENTERING DOORS)
; AUTO RUN     ON      OFF

; END

org $978DF4
incbin CMenu1.bin

org $978FCD
incbin CMenu2.bin

org $97938D
incbin CMenu3.bin


org $82F70F
FreeSpace:

org $82F480
	DW OptionsSprites

org $82F488
	DW OptionsSprites

org $82F490
	DW ControllerSprites

org $82F498
	DW ControllerSprites

org $82F4A0
	DW SpecialSprites

org $82F4A8
	DW SpecialSprites

org $82D24B
OptionsSprites:
DB $22,$00
DB $CC,$01,$08,$FA,$3E
DB $D4,$01,$08,$FA,$3E
DB $DC,$01,$08,$FA,$3E
DB $E4,$01,$08,$FA,$3E
DB $EC,$01,$08,$FA,$3E
DB $F4,$01,$08,$FA,$3E
DB $FC,$01,$08,$FA,$3E
DB $04,$00,$08,$FA,$3E
DB $0C,$00,$08,$FA,$3E
DB $14,$00,$08,$FA,$3E
DB $1C,$00,$08,$FA,$3E
DB $24,$00,$08,$FA,$3E
DB $2C,$00,$08,$FA,$3E

DB $34,$00,$08,$FD,$3E
DB $34,$00,$00,$ED,$3E
DB $34,$00,$F8,$ED,$3E
DB $34,$00,$F0,$FB,$3E

DB $2C,$00,$F0,$FA,$3E
DB $24,$00,$F0,$FA,$3E
DB $1C,$00,$F0,$FA,$3E
DB $14,$00,$F0,$FA,$3E
DB $0C,$00,$F0,$FA,$3E
DB $04,$00,$F0,$FA,$3E
DB $FC,$01,$F0,$FA,$3E
DB $F4,$01,$F0,$FA,$3E
DB $EC,$01,$F0,$FA,$3E
DB $E4,$01,$F0,$FA,$3E
DB $DC,$01,$F0,$FA,$3E
DB $D4,$01,$F0,$FA,$3E
DB $CC,$01,$F0,$FA,$3E

DB $C4,$01,$F0,$F9,$3E
DB $C4,$01,$F8,$ED,$3E
DB $C4,$01,$00,$ED,$3E
DB $C4,$01,$08,$FC,$3E

ControllerSprites:
DB $30,$00
DB $B4,$01,$08,$FA,$3E
DB $BC,$01,$08,$FA,$3E
DB $C4,$01,$08,$FA,$3E
DB $CC,$01,$08,$FA,$3E
DB $D4,$01,$08,$FA,$3E
DB $DC,$01,$08,$FA,$3E
DB $E4,$01,$08,$FA,$3E
DB $EC,$01,$08,$FA,$3E
DB $F4,$01,$08,$FA,$3E
DB $FC,$01,$08,$FA,$3E
DB $04,$00,$08,$FA,$3E
DB $0C,$00,$08,$FA,$3E
DB $14,$00,$08,$FA,$3E
DB $1C,$00,$08,$FA,$3E
DB $24,$00,$08,$FA,$3E
DB $2C,$00,$08,$FA,$3E
DB $34,$00,$08,$FA,$3E
DB $3C,$00,$08,$FA,$3E
DB $44,$00,$08,$FA,$3E
DB $4C,$00,$08,$FA,$3E

DB $54,$00,$08,$FD,$3E
DB $54,$00,$00,$ED,$3E
DB $54,$00,$F8,$ED,$3E
DB $54,$00,$F0,$FB,$3E

DB $4C,$00,$F0,$FA,$3E
DB $44,$00,$F0,$FA,$3E
DB $3C,$00,$F0,$FA,$3E
DB $34,$00,$F0,$FA,$3E
DB $2C,$00,$F0,$FA,$3E
DB $24,$00,$F0,$FA,$3E
DB $1C,$00,$F0,$FA,$3E
DB $14,$00,$F0,$FA,$3E
DB $0C,$00,$F0,$FA,$3E
DB $04,$00,$F0,$FA,$3E
DB $FC,$01,$F0,$FA,$3E
DB $F4,$01,$F0,$FA,$3E
DB $EC,$01,$F0,$FA,$3E
DB $E4,$01,$F0,$FA,$3E
DB $DC,$01,$F0,$FA,$3E
DB $D4,$01,$F0,$FA,$3E
DB $CC,$01,$F0,$FA,$3E
DB $C4,$01,$F0,$FA,$3E
DB $BC,$01,$F0,$FA,$3E
DB $B4,$01,$F0,$FA,$3E

DB $AC,$01,$F0,$F9,$3E
DB $AC,$01,$F8,$ED,$3E
DB $AC,$01,$00,$ED,$3E
DB $AC,$01,$08,$FC,$3E


SpecialSprites:
DB $28,$00

DB $C0,$01,$08,$FA,$3E
DB $C8,$01,$08,$FA,$3E
DB $D0,$01,$08,$FA,$3E
DB $D8,$01,$08,$FA,$3E
DB $E0,$01,$08,$FA,$3E
DB $E8,$01,$08,$FA,$3E
DB $F0,$01,$08,$FA,$3E
DB $F8,$01,$08,$FA,$3E
DB $00,$00,$08,$FA,$3E
DB $08,$00,$08,$FA,$3E
DB $10,$00,$08,$FA,$3E
DB $18,$00,$08,$FA,$3E
DB $20,$00,$08,$FA,$3E
DB $28,$00,$08,$FA,$3E
DB $30,$00,$08,$FA,$3E
DB $38,$00,$08,$FA,$3E

DB $40,$00,$08,$FD,$3E
DB $40,$00,$00,$ED,$3E
DB $40,$00,$F8,$ED,$3E
DB $40,$00,$F0,$FB,$3E

DB $38,$00,$F0,$FA,$3E
DB $30,$00,$F0,$FA,$3E
DB $28,$00,$F0,$FA,$3E
DB $20,$00,$F0,$FA,$3E
DB $18,$00,$F0,$FA,$3E
DB $10,$00,$F0,$FA,$3E
DB $08,$00,$F0,$FA,$3E
DB $00,$00,$F0,$FA,$3E
DB $F8,$01,$F0,$FA,$3E
DB $F0,$01,$F0,$FA,$3E
DB $E8,$01,$F0,$FA,$3E
DB $E0,$01,$F0,$FA,$3E
DB $D8,$01,$F0,$FA,$3E
DB $D0,$01,$F0,$FA,$3E
DB $C8,$01,$F0,$FA,$3E
DB $C0,$01,$F0,$FA,$3E

DB $B8,$01,$F0,$F9,$3E
DB $B8,$01,$F8,$ED,$3E
DB $B8,$01,$00,$ED,$3E
DB $B8,$01,$08,$FC,$3E
