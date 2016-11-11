LoRom

org $82C3B4 : DW $2086
org $82C3BB : DW $2087
org $82B8AA : JSR CheckItemIcons
org $82F800
EndItems: PLA : PLY : PLX
	LDA $0000,X : RTS
CheckItemIcons: PHX : PHY
	LDA $079F : ASL A : TAX : LDA ItemAreaTable,X : TAX : PHX
-	LDA $0000,X : BMI EndItems
			LDA $0002,X : AND #$00FF : STA $04 : ASL #3 : SEC : SBC $B1 : STA $00
			LDA $0003,X : AND #$00FF : STA $06 : ASL #3 : SEC : SBC $B3 : STA $02
				STX $0A
					LDA $04 : AND #$0020 : ASL #2 : STA $08
					LDA $04 : AND #$001F : LSR #3 : CLC : ADC $08 : STA $08
					LDA $06 : ASL #2 : CLC : ADC $08 : TAY
					LDA $04 : AND #$0007 : TAX
					SEP #$20 : LDA $07F7,Y : AND MapBitTable,X : REP #$20 : BNE +
						LDA $0789 : BEQ +++ : LDA $079F : XBA : STY $08 : CLC : ADC $08 : TAY
						SEP #$20 : LDA $9727,Y : AND MapBitTable,X : REP #$20 : BEQ +++
			+	LDX $0A
		LDA #$0E00 : STA $03
		LDA $0000,X : PHX : JSL $80818E
			LDA $7ED870,X : PLX : BIT $05E7 : BEQ +
				LDA #$000D : BRA ++
			+	LDA #$000C
		++	LDY $02 : LDX $00 : JSL $81891F
+++	PLX : INX #4 : PHX : JMP -
MapBitTable: DB $80,$40,$20,$10,$08,$04,$02,$01
ItemAreaTable: DW CrateriaItems,BrinstarItems,NorfairItems,WreckedShipItems,MaridiaItems,TourianItems,CeresItems,DebugItems
CrateriaItems:
	DW $0000 : DB $21,$02
	DW $0001 : DB $26,$06
;	DW $0002 : DB $27,$01
	DW $0003 : DB $26,$03
	DW $0004 : DB $24,$05
	DW $0005 : DB $11,$03
	DW $0006 : DB $14,$13
	DW $0007 : DB $19,$07
	DW $0008 : DB $0C,$07
	DW $0009 : DB $0B,$04
	DW $000A : DB $0B,$04
	DW $000B : DB $18,$0A
	DW $000C : DB $10,$08
	DW $FFFF
BrinstarItems:
	DW $000D : DB $0C,$08
	DW $000E : DB $18,$0A
	DW $000F : DB $0B,$05
	DW $0010 : DB $0A,$04
	DW $0011 : DB $0D,$05
	DW $0012 : DB $0E,$05
	DW $0013 : DB $0E,$05
	DW $0014 : DB $0C,$08
	DW $0015 : DB $11,$08
	DW $0016 : DB $11,$0B
	DW $0017 : DB $11,$0C
	DW $0018 : DB $0F,$09
	DW $0019 : DB $16,$0C
	DW $001A : DB $19,$0B
	DW $001B : DB $17,$0B
	DW $001C : DB $20,$0B
;	DW $001D : DB $1F,$0B
	DW $001E : DB $06,$0B
	DW $001F : DB $05,$0B
	DW $0021 : DB $08,$0E
	DW $0022 : DB $1C,$0C
	DW $0023 : DB $15,$09
	DW $0024 : DB $1D,$09
	DW $0025 : DB $1D,$09
	DW $0026 : DB $17,$10
	DW $0027 : DB $23,$09
	DW $0028 : DB $23,$0C
	DW $0029 : DB $22,$0C
	DW $002A : DB $26,$12
	DW $002B : DB $2B,$14
;	DW $002C : DB $2F,$13
	DW $0030 : DB $3F,$18
	DW $FFFF
NorfairItems:
;	DW $0031 : DB $10,$05
	DW $0032 : DB $05,$03
;	DW $0033 : DB $02,$05
	DW $0034 : DB $13,$0B
	DW $0035 : DB $07,$07
	DW $0036 : DB $0B,$07
	DW $0037 : DB $08,$06
	DW $0038 : DB $09,$06
	DW $0039 : DB $09,$0B
	DW $003A : DB $0E,$10
	DW $003B : DB $08,$10
	DW $003C : DB $03,$11
	DW $003D : DB $12,$03
	DW $003E : DB $12,$03
	DW $003F : DB $15,$03
	DW $0040 : DB $17,$06
;	DW $0041 : DB $24,$03
	DW $0042 : DB $25,$03
	DW $0043 : DB $1A,$05
	DW $0044 : DB $1D,$05
	DW $0046 : DB $12,$10
	DW $0047 : DB $13,$10
	DW $0049 : DB $1C,$0B
	DW $004A : DB $23,$06
	DW $004B : DB $25,$07
	DW $004C : DB $20,$0F
	DW $004D : DB $1D,$06
;	DW $004E : DB $16,$12
	DW $004F : DB $14,$11
	DW $0050 : DB $25,$0C
	DW $FFFF
WreckedShipItems:
	DW $0080 : DB $0C,$11
	DW $0081 : DB $0F,$0C
;	DW $0082 : DB $0D,$0E
	DW $0083 : DB $15,$0B
	DW $0084 : DB $12,$0E
	DW $0085 : DB $0F,$12
	DW $0086 : DB $15,$12
	DW $0087 : DB $0A,$0E
	DW $FFFF
MaridiaItems:
	DW $0088 : DB $0A,$0D
	DW $0089 : DB $0B,$0C
	DW $008A : DB $12,$0D
;	DW $008B : DB $13,$0E
	DW $008C : DB $0C,$07
	DW $008D : DB $0C,$07
	DW $008E : DB $14,$07
	DW $008F : DB $1C,$03
	DW $0090 : DB $14,$0F
	DW $0091 : DB $14,$0F
	DW $0092 : DB $17,$0F
	DW $0093 : DB $18,$10
	DW $0094 : DB $18,$0A
	DW $0095 : DB $19,$0A
	DW $0096 : DB $21,$11
;	DW $0097 : DB $2A,$08
	DW $0098 : DB $1D,$09
	DW $009A : DB $3A,$1F
	DW $FFFF
TourianItems:
	DW $FFFF
CeresItems:
	DW $FFFF
DebugItems:
	DW $FFFF