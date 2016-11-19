LoRom

;delay for each speed increase
!RunDelay = $0003
!BoostDelay = $0003
org $91B61F : DW !RunDelay,$0001,!BoostDelay,$0001,$0002

;remove running without speed booster
org $909F19 : DW $0000
org $909F1F : DW $0000

org $9097A9 : JMP RunWithSpeedBooster

org $90FC01
	RunWithSpeedBooster:
		LDA $0B3E : AND #$FF00 : CMP #$0200 : BMI +
		LDA $0B42 ;moved
		JMP $97AC ;run
	+	JMP $9813 ;skip