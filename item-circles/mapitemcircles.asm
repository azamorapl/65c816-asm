LoRom

org $82C3B4 : DW $2086
org $82C3BB : DW $2087
org $82B8AA : JSR CheckItemIcons

!Ball = #$0008
!Open = #$000C
!Closed = #$000D

org $82B7C6
	NOP #2 ;remove save icon

org $82F800
EndItems: 
	PLA : PLY : PLX
	LDA $0000,X : RTS
CheckItemIcons:
	PHX : PHY
	JSR CheckUpgradeIcons
	LDA $079F : ASL A : TAX : LDA ItemAreaTable,X : TAX : PHX ;which map?
StartLoop:
	LDA $0000,X ;which room?
	BMI EndItems
			LDA $0002,X : STA $7ED452 ;store link
			LDA $0004,X : AND #$00FF : STA $04 : ASL #3 : SEC : SBC $B1 : STA $00 ;which X?
			LDA $0005,X : AND #$00FF : STA $06 : ASL #3 : SEC : SBC $B3 : STA $02 ;which Y?
			DoStuff:
				STX $0A
						LDA $04 : AND #$0020 : ASL #2 : STA $08
						LDA $04 : AND #$001F : LSR #3 : CLC : ADC $08 : STA $08
						LDA $06 : ASL #2 : CLC : ADC $08 : TAY
						LDA $04 : AND #$0007 : TAX
						SEP #$20 : LDA $07F7,Y : AND MapBitTable,X : REP #$20 : BNE Woohoo ;sprite to draw
							LDA $0789 : BRA IncreaseIndex ; WAS BEQ
							LDA $079F : XBA : STY $08 : CLC : ADC $08 : TAY
							SEP #$20 : LDA $9727,Y : AND MapBitTable,X : REP #$20 : BEQ IncreaseIndex
				Woohoo:	LDX $0A
			LDA #$0E00 : STA $03
			LDA $7ED452 : BPL Skip ;read link, if exists skip
			Load: LDA $0000,X
			Skip: PHX : JSL $80818E
				LDA $7ED870,X : PLX : BIT $05E7 : BEQ DrawOpen ;load items flag from memory
					LDA $7ED452 : BMI DrawClosed : LDA #$FFFF : STA $7ED452 : BRA Load
					DrawClosed: LDA !Closed : BRA Draw ;draw closed
					DrawOpen: LDA !Open ;draw open
		Draw:
			LDY $02 : LDX $00 : JSL $81891F
IncreaseIndex:
	PLX : INX #6 : PHX : JMP StartLoop
EndUpgrades:
	PLA : PLY : PLX
	RTS
CheckUpgradeIcons:
	PHX : PHY
	LDA $079F : ASL A : TAX : LDA UpgradeAreaTable,X : TAX : PHX ;which map?
StartLoopUpgrade:
	LDA $0000,X ;which room?
	BMI EndUpgrades
			LDA $0002,X : AND #$00FF : STA $04 : ASL #3 : SEC : SBC $B1 : STA $00 ;which X?
			LDA $0003,X : AND #$00FF : STA $06 : ASL #3 : SEC : SBC $B3 : STA $02 ;which Y?
				STX $0A
					LDA $04 : AND #$0020 : ASL #2 : STA $08
					LDA $04 : AND #$001F : LSR #3 : CLC : ADC $08 : STA $08
					LDA $06 : ASL #2 : CLC : ADC $08 : TAY
					LDA $04 : AND #$0007 : TAX
					SEP #$20 : LDA $07F7,Y : AND MapBitTable,X : REP #$20 : BNE + ;sprite to draw
						LDA $0789 : BRA IncreaseIndexUpgrade ; WAS BEQ - show on all maps
						LDA $079F : XBA : STY $08 : CLC : ADC $08 : TAY
						SEP #$20 : LDA $9727,Y : AND MapBitTable,X : REP #$20 : BEQ IncreaseIndexUpgrade
			+	LDX $0A
		LDA #$0E00 : STA $03
		LDA $0000,X
		PHX : JSL $80818E
			LDA $7ED870,X : PLX : BIT $05E7 : BEQ + ;load items flag from memory ;;82F89F
				LDA !Closed : BRA DrawUpgrade ;draw closed
			+	LDA !Ball ;draw open
		DrawUpgrade:
			LDY $02 : LDX $00 : JSL $81891F
IncreaseIndexUpgrade:
	PLX : INX #4 : PHX : JMP StartLoopUpgrade	
MapBitTable: DB $80,$40,$20,$10,$08,$04,$02,$01
ItemAreaTable: DW CrateriaItems,BrinstarItems,NorfairItems,WreckedShipItems,MaridiaItems,TourianItems,CeresItems,DebugItems
UpgradeAreaTable: DW CrateriaUpgrades,BrinstarUpgrades,NorfairUpgrades,WreckedShipUpgrades,MaridiaUpgrades,CeresUpgrades,DebugUpgrades
CrateriaItems:
	DW $0000 : DW $FFFF : DB $21,$02
	DW $0001 : DW $FFFF : DB $26,$06
	DW $0002 : DW $FFFF : DB $27,$01
	DW $0003 : DW $FFFF : DB $26,$03
	DW $0004 : DW $FFFF : DB $24,$05
	DW $0005 : DW $FFFF : DB $11,$03
	DW $0006 : DW $FFFF : DB $14,$13
	DW $0008 : DW $FFFF : DB $0C,$07
	DW $0009 : DW $000A : DB $0B,$04 ;;;;;;;;;
	;DW $000A : DW $0009 : DB $0B,$04 ;;;;;;;;;
	DW $000B : DW $FFFF : DB $18,$0A
	DW $000C : DW $FFFF : DB $10,$08
	DW $FFFF
BrinstarItems:
	DW $000D : DW $FFFF : DB $0C,$08
	DW $000E : DW $FFFF : DB $18,$0A
	DW $000F : DW $FFFF : DB $0B,$05
	DW $0010 : DW $FFFF : DB $0A,$04
	DW $0011 : DW $FFFF : DB $0D,$05
	DW $0012 : DW $0013 : DB $0E,$05 ;;;;;;;;;;
	;DW $0013 : DW $0012 : DB $0E,$05 ;;;;;;;;;;
	;DW $0014 : DB $0C,$08
	DW $0015 : DW $FFFF : DB $11,$08
	DW $0016 : DW $FFFF : DB $11,$0B
	DW $0018 : DW $FFFF : DB $0F,$09
	DW $0019 : DW $FFFF : DB $16,$0C
	DW $001B : DW $FFFF : DB $17,$0B
	DW $001C : DW $FFFF : DB $20,$0B
	DW $001D : DW $FFFF : DB $1F,$0B
	DW $001E : DW $FFFF : DB $06,$0B
	DW $001F : DW $FFFF : DB $05,$0B
	DW $0021 : DW $FFFF : DB $08,$0E
	DW $0022 : DW $FFFF : DB $1C,$0C
	DW $0023 : DW $FFFF : DB $15,$09
	DW $0024 : DW $0025 : DB $1D,$09 ;;;;;;;;;;;
	;DW $0025 : DW $0024 : DB $1D,$09 ;;;;;;;;;;;
	DW $0027 : DW $FFFF : DB $23,$09
	DW $0028 : DW $FFFF : DB $23,$0C
	DW $0029 : DW $FFFF : DB $22,$0C
	DW $002B : DW $FFFF : DB $2B,$14
	DW $002C : DW $FFFF : DB $2F,$13
	DW $FFFF
NorfairItems:
	DW $0031 : DW $FFFF : DB $10,$05
	DW $0033 : DW $FFFF : DB $02,$05
	DW $0034 : DW $FFFF : DB $13,$0B
	DW $0036 : DW $FFFF : DB $0B,$07
	DW $0037 : DW $FFFF : DB $08,$06
	DW $0038 : DW $FFFF : DB $09,$06
	DW $0039 : DW $FFFF : DB $09,$0B
	DW $003A : DW $FFFF : DB $0E,$10
	DW $003B : DW $FFFF : DB $08,$10
	DW $003D : DW $003E : DB $12,$03 ;;;;;;;;;;
	;DW $003E : DW $003D : DB $12,$03 ;;;;;;;;;;
	DW $003F : DW $FFFF : DB $15,$03
	DW $0040 : DW $FFFF : DB $17,$06
	DW $0041 : DW $FFFF : DB $24,$03
	DW $0043 : DW $FFFF : DB $1A,$05
	DW $0046 : DW $FFFF : DB $12,$10
	DW $0047 : DW $FFFF : DB $13,$10
	DW $0049 : DW $FFFF : DB $1C,$0B
	DW $004A : DW $FFFF : DB $23,$06
	DW $004B : DW $FFFF : DB $25,$07
	DW $004C : DW $FFFF : DB $20,$0F
	DW $004D : DW $FFFF : DB $1D,$06
	DW $004E : DW $FFFF : DB $16,$12
	DW $0050 : DW $FFFF : DB $25,$0C
	DW $FFFF
WreckedShipItems:
	DW $0080 : DW $FFFF : DB $0C,$11
	DW $0081 : DW $FFFF : DB $0F,$0C
	DW $0082 : DW $FFFF : DB $0D,$0E
	DW $0083 : DW $FFFF : DB $15,$0B
	DW $0084 : DW $FFFF : DB $12,$0E
	DW $0085 : DW $FFFF : DB $0F,$12
	DW $0086 : DW $FFFF : DB $15,$12
	DW $FFFF
MaridiaItems:
	DW $0088 : DW $FFFF : DB $0A,$0D
	DW $0089 : DW $FFFF : DB $0B,$0C
	DW $008A : DW $FFFF : DB $12,$0D
	DW $008B : DW $FFFF : DB $13,$0E
	DW $008C : DW $008D : DB $0C,$07 ;;;;;;;;;
	;DW $008D : DW $008C : DB $0C,$07 ;;;;;;;;;
	DW $008E : DW $FFFF : DB $14,$07
	DW $0090 : DW $0091 : DB $14,$0F ;;;;;;;;;
	;DW $0091 : DW $0090 : DB $14,$0F ;;;;;;;;;
	DW $0092 : DW $FFFF : DB $17,$0F
	DW $0093 : DW $FFFF : DB $18,$10
	DW $0094 : DW $FFFF : DB $18,$0A
	DW $0095 : DW $FFFF : DB $19,$0A
	DW $0097 : DW $FFFF : DB $2A,$08
	DW $0098 : DW $FFFF : DB $1D,$09
	DW $FFFF
TourianItems:
	DW $FFFF
CeresItems:
	DW $FFFF
DebugItems:
	DW $FFFF
CrateriaUpgrades:
	DW $0007 : DB $19,$07 ;BOMBS
	DW $FFFF
BrinstarUpgrades:
	DW $0017 : DB $11,$0C ;CHARGE BEAM
	DW $001A : DB $19,$0B ;MORPH BALL
	DW $0026 : DB $17,$10 ;XRAY SCOPE
	DW $002A : DB $26,$12 ;SPAZER BEAM
	DW $0030 : DB $39,$14 ;VARIA SUIT (?)
	DW $FFFF
NorfairUpgrades:
	DW $0032 : DB $05,$03 ;ICE BEAM
	DW $0035 : DB $07,$07 ;HIJUMP BOOTS	
	DW $003C : DB $03,$11 ;GRAPPLING HOOK
	DW $0042 : DB $25,$03 ;SPEED BOOSTER
	DW $0044 : DB $1D,$05 ;WAVE BEAM
	DW $004F : DB $14,$11 ;SCREW ATTACK
	DW $FFFF
WreckedShipUpgrades:
	DW $0087 : DB $0A,$0E ;SPACE JUMP
	DW $FFFF
MaridiaUpgrades:
	DW $008F : DB $1C,$03 ;PLASMA BEAM
	DW $0096 : DB $21,$11 ;SPRING BALL
	DW $009A : DB $26,$0B ;SPACE JUMP (?)
	DW $FFFF
TourianUpgrades:
	DW $FFFF
CeresUpgrades:
	DW $FFFF
DebugUpgrades:
	DW $FFFF