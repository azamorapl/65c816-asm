LoRom

;delay for each speed increase
!RunDelay = $0003
!BoostDelay = $0003
org $91B61F : DW !RunDelay,$0001,!BoostDelay,$0001,$0002

;run timer even without speed booster
org $90855E : BRA $1D

;lower to reduce brinstar gate trigger range
;org $A19A6C : DB $80 ;was $90
;org $A19A7C : DB $90

org $9097A9 : JMP RunWithSpeedBooster
org $9097D5 : JMP RunWithoutSpeedBooster
org $9097D2 : JSR ActivateTimer
org $90858C : JSR CheckItemForShine

org $90FC01
	RunWithSpeedBooster:
		LDA #$97AC : STA $0019
		BRA DelayRunning
	RunWithoutSpeedBooster:
		LDA #$97D8 : STA $0019
	DelayRunning:
		LDA $0B3E : AND #$FF00 : CMP #$0300 : BMI +
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