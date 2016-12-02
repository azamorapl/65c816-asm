LoRom

!IsBallsparking = $7ED454 ;unused ram
!PrepareShineLeftPose = #$00C7
!ShineLeftPose = #$00CA
!ShineRightPose = #$00C9
!ShineUpLeftPose = #$00CC
!ShineUpRightPose = #$00CB
!ShineDiagonalLeftPose = #$00CE
!ShineDiagonalRightPose = #$00CD
!SpringLeftPose = #$007A
!SpringRightPose = #$0079
!SpringMovingLeftPose = #$007C
!SpringMovingRightPose = #$007B

org $91FA56 : JSL CheckSpringPose : NOP #2
org $908606 : JSR FakeAnimation
org $90EC25 : JSR FakeAnimation
org $9082EB : JSR FakeAnimation
org $908606 : JSR FakeAnimation
org $928011 : JSL SkipAnimation
org $92804C : JSL SkipAnimation
org $90D4B3 : JSR ReturnToBallLeft
org $90D4AB : JSR ReturnToBallRight
org $90ECA5 : JSR RestoreHeight
org $90ECAE : JSR RestorePreviousHeight
org $9088DC : JSR FakeEchoAnimation
org $908928 : JSR FakeEchoAnimation
org $90EF0B : JSR AdjustEchoHeight
org $9088AD : JSR AdjustFinalEchoHeight
org $9088FB : JSR AdjustFinalEchoHeight
org $908874 : JSR AdjustFinalEchoHeight

org $90FCE2
	CheckSpringPose:
		LDA !IsBallsparking : BNE +
		LDA $0A68 : BEQ +
		LDA $8B : BIT $09B4 : BEQ +
		LDA #$001B : STA $0A1F
		LDA $0AFA : SEC : SBC #$0010 : STA $0AFA : STA $0B14
		LDA !PrepareShineLeftPose : STA $0A1C
		LDA #$0001 : STA !IsBallsparking
		JSL $90CFFA
	+	LDA $0A23 : AND #$00FF ;moved
		RTL
	SkipAnimation:
		JSR FakeAnimation : ASL A
		RTL
	FakeAnimation:
		LDA !IsBallsparking : BEQ +
		LDA !SpringRightPose : RTS
	+	LDA $0A1C : RTS
	ReturnToBallLeft:
		LDA !IsBallsparking : BEQ +
		LDA !SpringLeftPose : RTS
	+	LDA #$0002 : RTS
	ReturnToBallRight:
		LDA !IsBallsparking : BEQ +
		LDA !SpringRightPose : RTS
	+	LDA #$0001 : RTS
	RestoreHeight:
		ADC $0AFA
		JSR AdjustHeight
		RTS
	RestorePreviousHeight:
		ADC $0B14
		JSR AdjustHeight
		PHA : LDA #$0000 : STA !IsBallsparking : PLA
		RTS
	AdjustHeight:
		PHA
		LDA !IsBallsparking : BEQ +
		PLA : SEC : SBC #$000C : PHA
	+	PLA
		RTS
	FakeEchoAnimation:
		PHA
		LDA !IsBallsparking : BEQ +
		PLA : LDA #$0743 : BRA ++
	+	PLA : ADC $0A96 ;moved
	++	RTS
	AdjustEchoHeight:
		PHA
		LDA !IsBallsparking : BEQ +
		PLA : SEC : SBC #$0007 : PHA
	+	PLA : STA $0AB8,x
		RTS
	AdjustFinalEchoHeight:
		PHA
		LDA !IsBallsparking : BEQ +
		PLA : CLC : ADC #$0010 : PHA : SEC
	+	PLA : SBC $0915
		RTS
