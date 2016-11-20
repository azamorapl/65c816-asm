LoRom

;fake block = screw & speed

!Beam = #$0000
!SuperMissile = #$0200
!PowerBombs = #$0300
!Bombs = #$0500

;power bombs open blue doors
org $84C7C4 : NOP #3 : BRA $07

;power bombs reveal tiles
org $84CF70 : CMP #$0300 : BPL $24
org $84CFA9 : CMP #$0300 : BPL $06

org $84CEED : JSR RevealByBeam : NOP #3

org $84FF75
	RevealByBeam:
		CMP !Beam : BNE +
		PHX
		LDA $1D27,y : CMP #$CCE9 : BPL +++
		SEC : SBC #$CC3C : STA $4204 : SEP #$20 : LDA #$2A : STA $4206 : BRA ++
	+++	SEC : SBC #$CCEA : STA $4204 : SEP #$20 : LDA #$1C : STA $4206
	++	PHA : PLA : PHA : PLA
		LDA $4214 : ASL A : TAX
		REP #$20
		LDA BombReveal,x : STA $1D27,y
		PLX
		RTS
	+	LDA #$0000 : STA $1C37,y ;moved
		RTS
	BombReveal:
		DW Bomb1x1Reveal, Bomb2x1Reveal, Bomb1x2Reveal, Bomb2x2Reveal
	Bomb1x1Reveal:
		DW $0001 : DW $A4C1
		DW $86BC
	Bomb2x1Reveal:
		DW $0001 : DW $A4C7
		DW $86BC
	Bomb1x2Reveal:
		DW $0001 : DW $A4CF
		DW $86BC
	Bomb2x2Reveal:
		DW $0001 : DW $A4D7
		DW $86BC