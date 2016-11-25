LoRom

org $82B7C6
	NOP #2 ;remove save icon

!Ball = #$0008
!Circle = #$000C
!Dot = #$000D
!ShiftBall = #$FFF3
!ShiftCircle = #$001A
!ShiftDot = #$000D

org $82C3B4 : DW $2086
org $82C3BB : DW $2087
org $82B8AA : JSR DrawMapItems
org $90AAC4 : JSR ShiftMinimap
org $90AAEB : JSR ShiftMinimap
org $90AB28 : JSR ShiftMinimap
org $90AAB4 : JSR ResetYCounter
org $90AADB : JSR IncreaseYCounter
org $90AB18 : JSR IncreaseYCounter
org $90AAA0 : JSR ResetXCounter
org $90AB46 : JMP IncreaseXCounter
org $90A94B : JSR SaveX
org $90A971 : JSR SaveY

org $90FC4F
	ShiftMinimap:
		ORA #$2800 ;moved
		PHB : PHP : PHX : PHY : PHA
		LDA $079F : ASL A : TAY ;region
		PEA $B8B8 : PLB : PLB
		LDA $40 : ASL A : CLC : ADC ItemIndexTable,Y : TAX ;x
		LDA $34 : ASL A : CLC : ADC $0000,X : TAX ;y
		LDA $0000,X : TAX ;x/y
			LDA $0002,X : BMI + ;item 2
			PHX : JSL $80818E : LDA $7ED870,X : PLX : BIT $05E7 : BEQ ++
		+	LDA $0000,X : BMI +++ ;item 1
			PHX : JSL $80818E : LDA $7ED870,X : PLX : BIT $05E7 : BEQ ++
			PLA : CLC : ADC !ShiftDot : PHA : BRA +++
		++  PLA : CLC : ADC $0004,X : PHA ;shift qt
		+++	PLA : PLY : PLX : PLP : PLB
		RTS
	ResetXCounter:
		LDA #$FFFE : CLC : ADC $36 : STA $40
		LDA $0789 ;moved
		RTS	
	IncreaseXCounter:
		INC $40
		JMP $AAA4 ;moved
	ResetYCounter:
		ORA #$2C00 ;moved
		PHA
		LDA #$FFFF : CLC : ADC $38 : STA $34
		PLA
		RTS
	IncreaseYCounter:
		ORA #$2C00 ;moved
		INC $34
		RTS
	SaveX:
		ADC $07A1 ;moved
		STA $36
		RTS		
	SaveY:
		STA $38
		STA $16 : CLC ;moved
		RTS

org $82F800
	Return:
		PLA : PLY : PLX
		LDA $0000,X ;moved
		RTS
	DrawMapItems:
		PHX : PHY
		LDA $079F : ASL A : TAY : LDA ItemAreaTable,Y : TAX : PHX ;region
	-	LDA $0000,X : BMI Return
				LDA $0004,X : AND #$00FF : STA $04 : ASL #3 : SEC : SBC $B1 : STA $00 ;x
				LDA $0005,X : AND #$00FF : STA $06 : ASL #3 : SEC : SBC $B3 : STA $02 ;y
				STX $0A
						LDA $04 : AND #$0020 : ASL #2 : STA $08
						LDA $04 : AND #$001F : LSR #3 : CLC : ADC $08 : STA $08
						LDA $06 : ASL #2 : CLC : ADC $08 : TAY
						LDA $04 : AND #$0007 : TAX
						SEP #$20 : LDA $07F7,Y : AND MapBitTable,X : REP #$20 : BNE + ;sprite
							BRA +++
				+	LDX $0A
				LDA #$0E00 : STA $03
				LDA $0002,X : BMI + ;item 2
					PHX : JSL $80818E : LDA $7ED870,X : PLX : BIT $05E7 : BEQ +
			+	LDA $0000,X ;item 1
					PHX : JSL $80818E : LDA $7ED870,X : PLX : BIT $05E7 : BEQ +
						LDA !Dot : BRA ++
					+	LDA $0006,X ;icon
				++	LDY $02 : LDX $00 : JSL $81891F
	+++	PLX : INX #8 : PHX : JMP -
	MapBitTable:
		DB $80,$40,$20,$10,$08,$04,$02,$01
	ItemAreaTable:
		DW CrateriaItems,BrinstarItems,NorfairItems,WreckedShipItems,MaridiaItems,TourianItems,CeresItems,DebugItems
	CrateriaItems:
		DW $0000,$FFFF : DB $21,$02 : DW !Circle
		DW $0001,$FFFF : DB $26,$06 : DW !Circle
		DW $0002,$FFFF : DB $27,$01 : DW !Circle
		DW $0003,$FFFF : DB $26,$03 : DW !Circle
		DW $0004,$FFFF : DB $24,$05 : DW !Circle
		DW $0005,$FFFF : DB $11,$03 : DW !Circle
		DW $0006,$FFFF : DB $14,$13 : DW !Circle
		DW $0007,$FFFF : DB $19,$07 : DW !Ball ;BOMBS
		DW $0009,$000A : DB $0B,$04 : DW !Circle
		DW $0008,$FFFF : DB $0C,$07 : DW !Circle
		DW $000B,$FFFF : DB $18,$0A : DW !Circle
		DW $000C,$FFFF : DB $10,$08 : DW !Circle
		DW $FFFF
	BrinstarItems:
		DW $000D,$FFFF : DB $0C,$08 : DW !Circle
		DW $000E,$FFFF : DB $18,$0A : DW !Circle
		DW $000F,$FFFF : DB $0B,$05 : DW !Circle
		DW $0010,$FFFF : DB $0A,$04 : DW !Circle
		DW $0011,$FFFF : DB $0D,$05 : DW !Circle
		DW $0012,$0013 : DB $0E,$05 : DW !Circle
		DW $0015,$FFFF : DB $11,$08 : DW !Circle
		DW $0016,$FFFF : DB $11,$0B : DW !Circle
		DW $0017,$FFFF : DB $11,$0C : DW !Ball ;CHARGE BEAM
		DW $0018,$FFFF : DB $0F,$09 : DW !Circle
		DW $0019,$FFFF : DB $16,$0C : DW !Circle
		DW $001A,$FFFF : DB $19,$0B : DW !Ball ;MORPH BALL
		DW $001B,$FFFF : DB $17,$0B : DW !Circle
		DW $001C,$FFFF : DB $20,$0B : DW !Circle
		DW $001D,$FFFF : DB $1F,$0B : DW !Circle
		DW $001E,$FFFF : DB $06,$0B : DW !Circle
		DW $001F,$FFFF : DB $05,$0B : DW !Circle
		DW $0021,$FFFF : DB $08,$0E : DW !Circle
		DW $0022,$FFFF : DB $1C,$0C : DW !Circle
		DW $0023,$FFFF : DB $15,$09 : DW !Circle
		DW $0024,$0025 : DB $1D,$09 : DW !Circle
		DW $0026,$FFFF : DB $17,$10 : DW !Ball ;XRAY SCOPE
		DW $0027,$FFFF : DB $23,$09 : DW !Circle
		DW $0028,$FFFF : DB $23,$0C : DW !Circle
		DW $0029,$FFFF : DB $22,$0C : DW !Circle
		DW $002A,$FFFF : DB $26,$12 : DW !Ball ;SPAZER BEAM
		DW $002B,$FFFF : DB $2B,$14 : DW !Circle
		DW $002C,$FFFF : DB $2F,$13 : DW !Circle
		DW $0030,$FFFF : DB $39,$14 : DW !Ball ;VARIA SUIT
		DW $FFFF
	NorfairItems:
		DW $0031,$FFFF : DB $10,$05 : DW !Circle
		DW $0032,$FFFF : DB $05,$03 : DW !Ball ;ICE BEAM
		DW $0033,$FFFF : DB $02,$05 : DW !Circle
		DW $0034,$FFFF : DB $13,$0B : DW !Circle
		DW $0035,$FFFF : DB $07,$07 : DW !Ball ;HIJUMP BOOTS	
		DW $0036,$FFFF : DB $0B,$07 : DW !Circle
		DW $0037,$FFFF : DB $08,$06 : DW !Circle
		DW $0038,$FFFF : DB $09,$06 : DW !Circle
		DW $0039,$FFFF : DB $09,$0B : DW !Circle
		DW $003A,$FFFF : DB $0E,$10 : DW !Circle
		DW $003B,$FFFF : DB $08,$10 : DW !Circle
		DW $003C,$FFFF : DB $03,$11 : DW !Ball ;GRAPPLING HOOK
		DW $003D,$003E : DB $12,$03 : DW !Circle
		DW $003F,$FFFF : DB $15,$03 : DW !Circle
		DW $0040,$FFFF : DB $17,$06 : DW !Circle
		DW $0041,$FFFF : DB $24,$03 : DW !Circle
		DW $0042,$FFFF : DB $25,$03 : DW !Ball ;SPEED BOOSTER
		DW $0043,$FFFF : DB $1A,$05 : DW !Circle
		DW $0044,$FFFF : DB $1D,$05 : DW !Ball ;WAVE BEAM
		DW $0046,$FFFF : DB $12,$10 : DW !Circle
		DW $0047,$FFFF : DB $13,$10 : DW !Circle
		DW $0049,$FFFF : DB $1C,$0B : DW !Circle
		DW $004A,$FFFF : DB $23,$06 : DW !Circle
		DW $004B,$FFFF : DB $25,$07 : DW !Circle
		DW $004C,$FFFF : DB $20,$0F : DW !Circle
		DW $004D,$FFFF : DB $1D,$06 : DW !Circle
		DW $004E,$FFFF : DB $16,$12 : DW !Circle
		DW $004F,$FFFF : DB $14,$11 : DW !Ball ;SCREW ATTACK
		DW $0050,$FFFF : DB $25,$0C : DW !Circle
		DW $FFFF
	WreckedShipItems:		
		DW $0080,$FFFF : DB $0C,$11 : DW !Circle
		DW $0081,$FFFF : DB $0F,$0C : DW !Circle
		DW $0082,$FFFF : DB $0D,$0E : DW !Circle
		DW $0083,$FFFF : DB $15,$0B : DW !Circle
		DW $0084,$FFFF : DB $12,$0E : DW !Circle
		DW $0085,$FFFF : DB $0F,$12 : DW !Circle
		DW $0086,$FFFF : DB $15,$12 : DW !Circle
		DW $0087,$FFFF : DB $0A,$0E : DW !Ball ;SPACE JUMP
		DW $FFFF
	MaridiaItems:
		DW $0088,$FFFF : DB $0A,$0D : DW !Circle
		DW $0089,$FFFF : DB $0B,$0C : DW !Circle
		DW $008A,$FFFF : DB $12,$0D : DW !Circle
		DW $008B,$FFFF : DB $13,$0E : DW !Circle
		DW $008C,$008D : DB $0C,$07 : DW !Circle
		DW $008E,$FFFF : DB $14,$07 : DW !Circle
		DW $008F,$FFFF : DB $1C,$03 : DW !Ball ;PLASMA BEAM
		DW $0090,$0091 : DB $14,$0F : DW !Circle
		DW $0092,$FFFF : DB $17,$0F : DW !Circle
		DW $0093,$FFFF : DB $18,$10 : DW !Circle
		DW $0094,$FFFF : DB $18,$0A : DW !Circle
		DW $0095,$FFFF : DB $19,$0A : DW !Circle
		DW $0096,$FFFF : DB $21,$11 : DW !Ball ;SPRING BALL
		DW $0097,$FFFF : DB $2A,$08 : DW !Circle
		DW $0098,$FFFF : DB $1D,$09 : DW !Circle
		DW $009A,$FFFF : DB $26,$0B : DW !Ball ;SPACE JUMP
		DW $FFFF
	TourianItems:
		DW $FFFF
	CeresItems:
		DW $FFFF
	DebugItems:
		DW $FFFF

org $B89630
	ItemIndexTable:
		DW CrateriaX,BrinstarX,NorfairX,WreckedShipX,MaridiaX,TourianX,CeresX,DebugX
	CrateriaX:
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,CrateriaX0B,CrateriaX0C,NoItem,NoItem,NoItem
		DW CrateriaX10,CrateriaX11,NoItem,NoItem,CrateriaX14,NoItem,NoItem,NoItem
		DW CrateriaX18,CrateriaX19,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,CrateriaX21,NoItem,NoItem,CrateriaX24,NoItem,CrateriaX26,CrateriaX27
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem
	BrinstarX:
		DW NoItem,NoItem,NoItem,NoItem,NoItem,BrinstarX05,BrinstarX06,NoItem
		DW BrinstarX08,NoItem,BrinstarX0A,BrinstarX0B,BrinstarX0C,BrinstarX0D,BrinstarX0E,BrinstarX0F
		DW NoItem,BrinstarX11,NoItem,NoItem,NoItem,BrinstarX15,BrinstarX16,BrinstarX17
		DW BrinstarX18,BrinstarX19,NoItem,NoItem,BrinstarX1C,BrinstarX1D,NoItem,BrinstarX1F
		DW BrinstarX20,NoItem,BrinstarX22,BrinstarX23,NoItem,NoItem,BrinstarX26,NoItem
		DW NoItem,NoItem,NoItem,BrinstarX2B,NoItem,NoItem,NoItem,BrinstarX2F
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW BrinstarX39,NoItem
	NorfairX:
		DW NoItem,NoItem,NorfairX02,NorfairX03,NoItem,NorfairX05,NoItem,NorfairX07
		DW NorfairX08,NorfairX09,NoItem,NorfairX0B,NoItem,NoItem,NorfairX0E,NoItem
		DW NorfairX10,NoItem,NorfairX12,NorfairX13,NorfairX14,NorfairX15,NorfairX16,NorfairX17
		DW NoItem,NoItem,NorfairX1A,NoItem,NorfairX1C,NorfairX1D,NoItem,NoItem
		DW NorfairX20,NoItem,NoItem,NorfairX23,NorfairX24,NorfairX25,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem
	WreckedShipX:
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,WreckedShipX0A,NoItem,WreckedShipX0C,WreckedShipX0D,NoItem,WreckedShipX0F
		DW NoItem,NoItem,WreckedShipX12,NoItem,NoItem,WreckedShipX15,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem
	MaridiaX:
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,MaridiaX0A,MaridiaX0B,MaridiaX0C,NoItem,NoItem,NoItem
		DW NoItem,NoItem,MaridiaX12,MaridiaX13,MaridiaX14,NoItem,NoItem,MaridiaX17
		DW MaridiaX18,MaridiaX19,NoItem,NoItem,MaridiaX1C,MaridiaX1D,NoItem,NoItem
		DW NoItem,MaridiaX21,NoItem,NoItem,NoItem,NoItem,MaridiaX26,NoItem
		DW NoItem,NoItem,MaridiaX2A,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem
	TourianX:
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem
	CeresX:
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem
	DebugX:
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem,NoItem
		DW NoItem,NoItem
	NoItem:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX0B:
		DW Empty,Empty,Empty,Empty,CrateriaX0BY04,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX0C:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,CrateriaX0CY07
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX10:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW CrateriaX10Y08,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX11:
		DW Empty,Empty,Empty,CrateriaX11Y03,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX14:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,CrateriaX14Y13,Empty,Empty,Empty,Empty
	CrateriaX18:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,CrateriaX18Y0A,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX19:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,CrateriaX19Y07
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX21:
		DW Empty,Empty,CrateriaX21Y02,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX24:
		DW Empty,Empty,Empty,Empty,Empty,CrateriaX24Y05,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX26:
		DW Empty,Empty,Empty,CrateriaX26Y03,Empty,Empty,CrateriaX26Y06,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX27:
		DW Empty,CrateriaX27Y01,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX05:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,BrinstarX05Y0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX06:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,BrinstarX06Y0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX08:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,BrinstarX08Y0E,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX0A:
		DW Empty,Empty,Empty,Empty,BrinstarX0AY04,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX0B:
		DW Empty,Empty,Empty,Empty,Empty,BrinstarX0BY05,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX0C:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW BrinstarX0CY08,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX0D:
		DW Empty,Empty,Empty,Empty,Empty,BrinstarX0DY05,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX0E:
		DW Empty,Empty,Empty,Empty,Empty,BrinstarX0EY05,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX0F:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,BrinstarX0FY09,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX11:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW BrinstarX11Y08,Empty,Empty,BrinstarX11Y0B,BrinstarX11Y0C,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX15:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,BrinstarX15Y09,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX16:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,BrinstarX16Y0C,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX17:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,BrinstarX17Y0B,Empty,Empty,Empty,Empty
		DW BrinstarX17Y10,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX18:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,BrinstarX18Y0A,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX19:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,BrinstarX19Y0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX1C:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,BrinstarX1CY0C,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX1D:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,BrinstarX1DY09,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX1F:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,BrinstarX1FY0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX20:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,BrinstarX20Y0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX22:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,BrinstarX22Y0C,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX23:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,BrinstarX23Y09,Empty,Empty,BrinstarX23Y0C,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	BrinstarX26:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,BrinstarX26Y12,Empty,Empty,Empty,Empty,Empty
	BrinstarX2B:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,BrinstarX2BY14,Empty,Empty,Empty
	BrinstarX2F:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,BrinstarX2FY13,Empty,Empty,Empty,Empty
	BrinstarX39:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,BrinstarX39Y14,Empty,Empty,Empty
	NorfairX02:
		DW Empty,Empty,Empty,Empty,NorfairX02Y05,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX03:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,NorfairX03Y11,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX05:
		DW Empty,Empty,Empty,NorfairX05Y03,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX07:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,NorfairX07Y07
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX08:
		DW Empty,Empty,Empty,Empty,Empty,Empty,NorfairX08Y06,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW NorfairX08Y10,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX09:
		DW Empty,Empty,Empty,Empty,Empty,Empty,NorfairX09Y06,Empty
		DW Empty,Empty,Empty,NorfairX09Y0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX0B:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,NorfairX0BY07
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX0E:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW NorfairX0EY10,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX10:
		DW Empty,Empty,Empty,Empty,Empty,NorfairX10Y05,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX12:
		DW Empty,Empty,Empty,NorfairX12Y03,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW NorfairX12Y10,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX13:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,NorfairX13Y0B,Empty,Empty,Empty,Empty,Empty
		DW NorfairX13Y10,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX14:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,NorfairX14Y11,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX15:
		DW Empty,Empty,Empty,NorfairX15Y03,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX16:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,NorfairX16Y12,Empty,Empty,Empty,Empty,Empty
	NorfairX17:
		DW Empty,Empty,Empty,Empty,Empty,Empty,NorfairX17Y06,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX1A:
		DW Empty,Empty,Empty,Empty,Empty,NorfairX1AY05,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX1C:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,NorfairX1CY0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX1D:
		DW Empty,Empty,Empty,Empty,Empty,NorfairX1DY05,NorfairX1DY06,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX20:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,NorfairX20Y0F
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX23:
		DW Empty,Empty,Empty,Empty,Empty,Empty,NorfairX23Y06,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX24:
		DW Empty,Empty,Empty,NorfairX24Y03,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	NorfairX25:
		DW Empty,Empty,Empty,NorfairX25Y03,Empty,Empty,Empty,NorfairX25Y07
		DW Empty,Empty,Empty,NorfairX25Y0C,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	WreckedShipX0A:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,WreckedShipX0AY0E,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	WreckedShipX0C:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,WreckedShipX0CY0C,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	WreckedShipX0D:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,WreckedShipX0DY0E,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	WreckedShipX0F:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,WreckedShipX0FY12,Empty,Empty,Empty,Empty,Empty
	WreckedShipX12:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,WreckedShipX12Y0E,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	WreckedShipX15:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,WreckedShipX15Y0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,WreckedShipX15Y15,Empty,Empty
	MaridiaX0A:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,MaridiaX0AY0D,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX0B:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,MaridiaX0BY0C,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX0C:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,MaridiaX0CY07
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX12:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,MaridiaX12Y0D,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX13:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,MaridiaX13Y0E,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX14:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,MaridiaX14Y07
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,MaridiaX14Y0F
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX17:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,MaridiaX17Y0F
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX18:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,MaridiaX18Y0A,Empty,Empty,Empty,Empty,Empty
		DW MaridiaX18Y10,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX19:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,MaridiaX19Y0A,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX1C:
		DW Empty,Empty,Empty,MaridiaX1CY03,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX1D:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,MaridiaX1DY09,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX21:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,MaridiaX21Y11,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX26:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,MaridiaX26Y0B,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	MaridiaX2A:
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW MaridiaX2AY08,Empty,Empty,Empty,Empty,Empty,Empty,Empty
		DW Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty
	CrateriaX0BY04:
		DW $0009,$000A : DW !ShiftCircle
	CrateriaX0CY07:
		DW $0008,$FFFF : DW !ShiftCircle
	CrateriaX10Y08:
		DW $000C,$FFFF : DW !ShiftCircle
	CrateriaX11Y03:
		DW $0005,$FFFF : DW !ShiftCircle
	CrateriaX14Y13:
		DW $0006,$FFFF : DW !ShiftCircle
	CrateriaX18Y0A:
		DW $000B,$FFFF : DW !ShiftCircle
	CrateriaX19Y07:
		DW $0007,$FFFF : DW !ShiftBall
	CrateriaX21Y02:
		DW $0000,$FFFF : DW !ShiftCircle
	CrateriaX24Y05:
		DW $0004,$FFFF : DW !ShiftCircle
	CrateriaX26Y03:
		DW $0003,$FFFF : DW !ShiftCircle
	CrateriaX26Y06:
		DW $0001,$FFFF : DW !ShiftCircle
	CrateriaX27Y01:
		DW $0002,$FFFF : DW !ShiftCircle
	BrinstarX05Y0B:
		DW $001F,$FFFF : DW !ShiftCircle
	BrinstarX06Y0B:
		DW $001E,$FFFF : DW !ShiftCircle
	BrinstarX08Y0E:
		DW $0021,$FFFF : DW !ShiftCircle
	BrinstarX0AY04:
		DW $0010,$FFFF : DW !ShiftCircle
	BrinstarX0BY05:
		DW $000F,$FFFF : DW !ShiftCircle
	BrinstarX0CY08:
		DW $000D,$FFFF : DW !ShiftCircle
	BrinstarX0DY05:
		DW $0011,$FFFF : DW !ShiftCircle
	BrinstarX0EY05:
		DW $0012,$0013 : DW !ShiftCircle
	BrinstarX0FY09:
		DW $0018,$FFFF : DW !ShiftCircle
	BrinstarX11Y08:
		DW $0015,$FFFF : DW !ShiftCircle
	BrinstarX11Y0B:
		DW $0016,$FFFF : DW !ShiftCircle
	BrinstarX11Y0C:
		DW $0017,$FFFF : DW !ShiftBall
	BrinstarX15Y09:
		DW $0023,$FFFF : DW !ShiftCircle
	BrinstarX16Y0C:
		DW $0019,$FFFF : DW !ShiftCircle
	BrinstarX17Y0B:
		DW $001B,$FFFF : DW !ShiftCircle
	BrinstarX17Y10:
		DW $0026,$FFFF : DW !ShiftBall
	BrinstarX18Y0A:
		DW $000E,$FFFF : DW !ShiftCircle
	BrinstarX19Y0B:
		DW $001A,$FFFF : DW !ShiftBall
	BrinstarX1CY0C:
		DW $0022,$FFFF : DW !ShiftCircle
	BrinstarX1DY09:
		DW $0024,$0025 : DW !ShiftCircle
	BrinstarX1FY0B:
		DW $001D,$FFFF : DW !ShiftCircle
	BrinstarX20Y0B:
		DW $001C,$FFFF : DW !ShiftCircle
	BrinstarX22Y0C:
		DW $0029,$FFFF : DW !ShiftCircle
	BrinstarX23Y09:
		DW $0027,$FFFF : DW !ShiftCircle
	BrinstarX23Y0C:
		DW $0028,$FFFF : DW !ShiftCircle
	BrinstarX26Y12:
		DW $002A,$FFFF : DW !ShiftBall
	BrinstarX2BY14:
		DW $002B,$FFFF : DW !ShiftCircle
	BrinstarX2FY13:
		DW $002C,$FFFF : DW !ShiftCircle
	BrinstarX39Y14:
		DW $0030,$FFFF : DW !ShiftBall
	NorfairX02Y05:
		DW $0033,$FFFF : DW !ShiftCircle
	NorfairX03Y11:
		DW $003C,$FFFF : DW !ShiftBall
	NorfairX05Y03:
		DW $0032,$FFFF : DW !ShiftBall
	NorfairX07Y07:
		DW $0035,$FFFF : DW !ShiftBall
	NorfairX08Y06:
		DW $0037,$FFFF : DW !ShiftCircle
	NorfairX08Y10:
		DW $003B,$FFFF : DW !ShiftCircle
	NorfairX09Y06:
		DW $0038,$FFFF : DW !ShiftCircle
	NorfairX09Y0B:
		DW $0039,$FFFF : DW !ShiftCircle
	NorfairX0BY07:
		DW $0036,$FFFF : DW !ShiftCircle
	NorfairX0EY10:
		DW $003A,$FFFF : DW !ShiftCircle
	NorfairX10Y05:
		DW $0031,$FFFF : DW !ShiftCircle
	NorfairX12Y03:
		DW $003D,$003E : DW !ShiftCircle
	NorfairX12Y10:
		DW $0046,$FFFF : DW !ShiftCircle
	NorfairX13Y0B:	
		DW $0034,$FFFF : DW !ShiftCircle
	NorfairX13Y10:
		DW $0047,$FFFF : DW !ShiftCircle
	NorfairX14Y11:
		DW $004F,$FFFF : DW !ShiftBall
	NorfairX15Y03:
		DW $003F,$FFFF : DW !ShiftCircle
	NorfairX16Y12:
		DW $004E,$FFFF : DW !ShiftCircle
	NorfairX17Y06:
		DW $0040,$FFFF : DW !ShiftCircle
	NorfairX1AY05:
		DW $0043,$FFFF : DW !ShiftCircle
	NorfairX1CY0B:
		DW $0049,$FFFF : DW !ShiftCircle
	NorfairX1DY05:
		DW $0044,$FFFF : DW !ShiftBall
	NorfairX1DY06:
		DW $004D,$FFFF : DW !ShiftCircle
	NorfairX20Y0F:
		DW $004C,$FFFF : DW !ShiftCircle
	NorfairX23Y06:
		DW $004A,$FFFF : DW !ShiftCircle
	NorfairX24Y03:
		DW $0041,$FFFF : DW !ShiftCircle
	NorfairX25Y03:
		DW $0042,$FFFF : DW !ShiftBall
	NorfairX25Y07:
		DW $004B,$FFFF : DW !ShiftCircle
	NorfairX25Y0C:
		DW $0002,$FFFF : DW !ShiftCircle
	WreckedShipX0AY0E:
		DW $0087,$FFFF : DW !ShiftBall
	WreckedShipX0CY0C:
		DW $0080,$FFFF : DW !ShiftCircle
	WreckedShipX0DY0E:
		DW $0082,$FFFF : DW !ShiftCircle
	WreckedShipX0FY12:
		DW $0085,$FFFF : DW !ShiftCircle
	WreckedShipX12Y0E:
		DW $0084,$FFFF : DW !ShiftCircle
	WreckedShipX15Y0B:
		DW $0083,$FFFF : DW !ShiftCircle
	WreckedShipX15Y15:
		DW $0086,$FFFF : DW !ShiftCircle
	MaridiaX0AY0D:
		DW $0088,$FFFF : DW !ShiftCircle
	MaridiaX0BY0C:
		DW $0089,$FFFF : DW !ShiftCircle
	MaridiaX0CY07:
		DW $008C,$008D : DW !ShiftCircle
	MaridiaX12Y0D:
		DW $008A,$FFFF : DW !ShiftCircle
	MaridiaX13Y0E:
		DW $008B,$FFFF : DW !ShiftCircle
	MaridiaX14Y07:
		DW $008E,$FFFF : DW !ShiftCircle
	MaridiaX14Y0F:
		DW $0090,$0091 : DW !ShiftCircle
	MaridiaX17Y0F:
		DW $0092,$FFFF : DW !ShiftCircle
	MaridiaX18Y10:
		DW $0093,$FFFF : DW !ShiftCircle
	MaridiaX18Y0A:
		DW $0094,$FFFF : DW !ShiftCircle
	MaridiaX19Y0A:
		DW $0095,$FFFF : DW !ShiftCircle
	MaridiaX1CY03:
		DW $008F,$FFFF : DW !ShiftBall
	MaridiaX1DY09:
		DW $0098,$FFFF : DW !ShiftCircle
	MaridiaX21Y11:
		DW $0096,$FFFF : DW !ShiftBall
	MaridiaX26Y0B:
		DW $009A,$FFFF : DW !ShiftBall
	MaridiaX2AY08:
		DW $0097,$FFFF : DW !ShiftCircle	
	Empty:
		DW $FFFF
