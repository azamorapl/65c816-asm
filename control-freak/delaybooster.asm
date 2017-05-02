LoRom

;delay for each speed increase
!RunDelay = $0002
!BoostDelay = $0002
org $91B61F : DW !RunDelay,$0001,!BoostDelay,$0001,$0002

;run timer even without speed booster
org $90855E : BRA $1D

;disable running with spring ball
org $909774 : AND #$00FF

;disable running without speed booster
org $909F19 : DW $0000,$0000 ;0002,0001
org $91B5D1 : DB $E8,$B5 ;D3,B5

;momentum sp/f, max momentum p/f, max momentum sp/f
org $909F63 : DW $3000,$0002,$C000,$0000,$8000			;3000,0002,C000 / 0003,2000
			DW $0000,$C000,$0002,$4000,$0000,$8000 	 	;02 = normal jump
			DW $0000,$C000,$0002,$6000,$0000,$8000 	 	;03 = spin jump

org $9097A9 : JMP RunWithSpeedBooster
org $9097D5 : JMP RunWithoutSpeedBooster
org $9097D2 : JSR ActivateTimer
org $90858C : JSR CheckItemForShine

org $90FC05
	RunWithSpeedBooster:
		LDA #$97AC : STA $0019
		BRA DelayRunning
	RunWithoutSpeedBooster:
		LDA #$97D8 : STA $0019
	DelayRunning:
		LDA $0B3E : AND #$FF00 : CMP #$0200 : BMI +
		LDA $0B42 ;moved
		JMP ($0019) ;run
	+	JMP $9813 ;skip
	ActivateTimer:
		STA $0AD0
		LDA #$0003 : STA $0B3E
		STZ $0ACE
		RTS
	CheckItemForShine:
		PHA
		BIT #$0400 : BNE +
		LDA $09A2 : BIT #$2000 : BNE +
		PLA
		LDA #$0000 : STA $0B3E
		PHA
	+	PLA
		BIT #$0400 ;moved
		RTS
