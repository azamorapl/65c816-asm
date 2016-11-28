lorom

;org $90B860 : DB $3C	;how long charge beam must be held MoveLeft to fire a beam (default 3C)	
;org $91D756 : DB $3C	;charge beam timer check for samus palette to change (should be equal to above value, default 3C)

!SamusX = $0AF6
!SamusY = $0AFA
!DropX = $1A4B
!DropY = $1A93

!MinDistance = #$0096

org $86EFE5 : JSR AttractDrops
org $86F057 : LDA $0AF6 ;in case you had Black Falcon's patch

org $86F600
	AttractDrops:
		LDA $0B62 : BEQ Exit
		TestX:
			LDA !SamusX : SEC : SBC !DropX,x : BEQ TestY : BMI +
			CMP !MinDistance : BPL Exit : BRA MoveLeft
		+	EOR #$FFFF : CMP !MinDistance : BPL Exit
		MoveRight:
			JSR CalculateXVelocity
			EOR #$FFFF : CLC : ADC !DropX,x : STA !DropX,x : BRA TestY
		MoveLeft:
			JSR CalculateXVelocity
			CLC : ADC !DropX,x : STA !DropX,x
		TestY:
			LDA !SamusY : SEC : SBC !DropY,x : BEQ Exit : BMI +
			CMP !MinDistance : BPL Exit : BRA MoveDown
		+	EOR #$FFFF : CMP !MinDistance : BPL Exit
		MoveUp:
			JSR CalculateYVelocity
			EOR #$FFFF : CLC : ADC !DropY,x : STA !DropY,x : BRA Exit
		MoveDown:
			JSR CalculateYVelocity
			CLC : ADC !DropY,x : STA !DropY,x
		Exit:
			LDA $1B23,X ;moved
			RTS
		CalculateXVelocity:
			CMP #$0055 : BPL +
			LDA #$0003 : BRA ++
		+	LDA #$0002
		++	RTS
		CalculateYVelocity:
			CMP #$0055 : BPL +
			LDA #$0002 : BRA ++
		+	LDA #$0001
		++	RTS
		VerticalSpeeds:
			DW $0002,$0001
		HorizontalSpeeds:
			DW $0003,$0002
		DistanceThresholds:
			DW $0055,$0096