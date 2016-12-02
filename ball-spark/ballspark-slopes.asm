LoRom

!IsBallsparking = $7ED454 ;unused ram
!ShineLeftPose = #$00CA
!ShineRightPose = #$00C9
!SpringMovingLeftPose = #$007C
!SpringMovingRightPose = #$007B
org $948884 : JSR ContinueShining

org $94B1F0
	ContinueShining:
		LDA $0A1C : CMP !ShineRightPose
		BEQ ShineRight
		CMP !ShineLeftPose
		BEQ ShineLeft
		LDA #$0001 : RTS       
	ShineRight:
		LDA $8B : BIT $09B0 : BNE +
		LDA #$0001 : RTS
	+	LDA !IsBallsparking : BEQ ++
		LDA #$0000 : STA !IsBallsparking
		LDA !SpringMovingRightPose : BRA +++
	++	LDA #$0009
	+++	STA $0A28 
		LDA #$0008 : STA $0A1E
		LDA !IsBallsparking : BEQ +
		LDA #$0011 : BRA ++
	+	LDA #$0001
	++	STA $0A1F
	Setup:
		LDA #$0009 : STA $0B42 
		LDA #$FFFE : STA $12
		STZ $14
		JSL $949763
		LDA #$0001 : STA $0A6E : STA $0B3C 
		LDA #$0402 : STA $0B3E
		STZ $0B36
		LDA #$A337 : STA $0A58 
		LDA #$E913 : STA $0A60 
		RTS
	ShineLeft:
		LDA $8B : BIT $09AE : BNE +  
		LDA #$0001 : RTS
	+	LDA !IsBallsparking : BEQ ++
		LDA #$0000 : STA !IsBallsparking
		LDA !SpringMovingLeftPose : BRA +++
	++	LDA #$000A
	+++	STA $0A28 
		LDA #$0004 : STA $0A1E 
		LDA !IsBallsparking : BEQ +
		LDA #$0011 : BRA ++
	+	LDA #$0001
	++	STA $0A1F
		JMP Setup
