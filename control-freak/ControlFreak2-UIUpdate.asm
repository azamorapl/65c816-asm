LoRom

!SelectionHackAddress = $F640

!Yellow = #$0000
!Green = #$1000
!Disabled = #$1400

!SelectedItem = $7E0A04
!PowerBomb = #$0003
!XRay = #$0005

org $91E14A
	JSL CheckMissileOnLoad : NOP #2

org $8489CB
	JSR CheckMissileOnGet : NOP

org $90BFA3
	JSR PaintBomb

org $90C4B8
	JSR PaintWeapon

org $90DDCA
	BIT $09B8

org $888735
	JSL PaintXray : NOP

org $888757
	JSL PaintXray : NOP

org $8887AE
	JSL PaintXray : NOP

org $90C4C7
	JSR SkipPowerBomb : NOP

org $80FA90
	PaintHudItem:
		PHK : PLB
		JSR $9CEA
		RTL

org $84FD00
	CheckMissileOnGet:
		PHA : PHX : PHY : PHB : PHD : PHP
		JSL ForceSelect
		PLP : PLD : PLB : PLY : PLX : PLA
		JSL $858080 ;moved
		RTS
	CheckMissileOnLoad:
		PHA : PHX : PHY : PHB : PHD : PHP
		JSL ForceSelect
		PLP : PLD : PLB : PLY : PLX : PLA
		STZ $18A8 ;moved
		RTL

org $90FAD1:
	PaintWeapon:
		PHA : PHX : PHY : PHB : PHD : PHP
		LDX !Disabled : LDA !PowerBomb : JSL PaintHudItem
		LDA $7E0AA8 : CMP #$0003 : BEQ +
		LDX !Green : BRA ++
	+	LDX !Yellow
	++	LDA !SelectedItem : JSL PaintHudItem
		PLP : PLD : PLB : PLY : PLX : PLA
		LDA $09D2 ;moved
		RTS
	PaintBomb:
		PHA : PHX : PHY : PHB : PHD : PHP
		LDX !Disabled : LDA !SelectedItem : JSL PaintHudItem
		LDX !Disabled : LDA !XRay : JSL PaintHudItem
		LDA $09BC : BIT $97 : BNE +
		LDX !Green : BRA ++
	+	LDX !Yellow
	++	LDA !PowerBomb : JSL PaintHudItem
	+++	PLP : PLD : PLB : PLY : PLX : PLA
		BIT $09B2 ;moved
		RTS
	PaintXray:
		PHA : PHX : PHY : PHB : PHD : PHP
		LDA $8B : BIT $09B8 : BNE +
		LDX !Disabled : BRA ++
	+	LDX !Yellow
	++	LDA !XRay : JSL PaintHudItem
		PLP : PLD : PLB : PLY : PLX : PLA
		LDA $8B : BIT $09B8 ;moved
		RTL
	SkipPowerBomb:
		LDA !SelectedItem : INC A ;moved
		CMP !PowerBomb
		BNE +
		INC
	+	RTS
	ForceSelect:
		LDA !SelectedItem : BNE +
		JSR !SelectionHackAddress
	+	RTL
