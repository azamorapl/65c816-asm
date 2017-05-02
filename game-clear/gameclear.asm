LoRom

org $978DF4
incbin Options.bin

!ClearAddress = $7ED8F4 ;sram that stores if game was cleared

org $8BD480 : JSR SaveClearFlag : NOP
org $81A143 : JSL DrawClearFlag : NOP #2
org $82ED6E : JSL SkipLanguageFlagSelectionDown
org $82ED4F : JSL SkipLanguageFlagSelectionUp : NOP #3
org $82EDF2 : JSL EnableFirstRow : NOP #2
org $82EDFE : JSL EnableSecondRow : NOP #2
org $82EE0A : JSL DisableFirstRow : NOP #2
org $82EE16 : JSL DisableSecondRow : NOP #2
org $82EE24 : JSL EnableFirstRow : NOP #2
org $82EE30 : JSL EnableSecondRow : NOP #2
org $82EE3C : JSL DisableFirstRow : NOP #2
org $82EE48 : JSL DisableSecondRow : NOP #2
org $82EDBD : JSL RestartGame

org $8BFCA0
	SaveClearFlag:
		LDA $09E0 : PHA ;hours
		LDA $09DE : PHA ;minutes
		LDA $09DC : PHA ;seconds
		LDA $09DA : PHA ;frames
		LDA $7ED82D : PHA ;event
		LDA $7ED820 : PHA ;event
		LDA $0952 : JSL $818085 ;load
		LDA #$0001 : STA !ClearAddress
		LDA $0952 : JSL $818000 ;save
		PLA : STA $7ED820
		PLA : STA $7ED82D
		PLA : STA $09DA
		PLA : STA $09DC
		PLA : STA $09DE
		PLA : STA $09E0
		STZ $AB : STZ $A7 ;moved
		RTS
	DrawClearFlag:
		PHA
		LDA !ClearAddress : BEQ +
		LDA #$20B8 : ORA $0F96 : STA $7E3668,x
	+	PLA
		ADC #$2060 : ORA $0F96 ;moved
		RTL
	SkipLanguageFlagSelectionDown:
		LDA $099E : INC A ;moved
		CMP #$0002 : BNE +
		LDA #$0003 : STA $099E
	+	RTL
	SkipLanguageFlagSelectionUp:
		JSL $809049 : LDA $099E : DEC A ;moved
		CMP #$0002 : BNE +
		LDA #$0001
	+	STA $099E : CMP #$0000
		RTL
	EnableFirstRow:
		LDX #$02A6 : LDY #$0006
		RTL
	EnableSecondRow:
		LDX #$02E6 : LDY #$0006
		RTL
	DisableFirstRow:
		LDX #$02B4 : LDY #$0006
		RTL
	DisableSecondRow:
		LDX #$02F4 : LDY #$0006
		RTL
	RestartGame:
		LDA $7E09E2 : BEQ +
		LDA !ClearAddress
		PHA
		LDA $0952 : STA $7E19B7 : JSL ClearSave
		PLA
		STA !ClearAddress
		LDA #$0063 : STA $7E09C2
		LDA #$0006 : STA $079F
		STZ $7E09E2
		LDA $0952 : JSL $818000 ;save
	+	LDA $7ED914 ;moved
		RTL
		;LDA $7E09E2 : BEQ +
		;LDA !ClearAddress : PHA
		;LDA $7E0952 : PHA ;slot
		;LDA $7ED8F2 : PHA ;difficulty
		;LDA $7E09E4 : PHA ;moonwalk
		;LDA $7E09EA : PHA ;item cancel
		;LDA #$0003 : STA $7E19B9
		;LDA $7E0952 : STA $7E19B7
		;JSL ClearSave
		;PLA : STA $7E09EA
		;PLA : STA $7E09E4
		;PLA : STA $7ED8F2
		;PLA : STA $7E0952
		;PLA : STA !ClearAddress
		;LDA #$0063 : STA $7E09C2
		;LDA #$0006 : STA $079F
		;STZ $7E09E2
		;LDA $7E0952 : JSL $818000 ;save
	;+	LDA $7ED914 ;moved
		;RTL

org $81F9F9
	ClearSave:
		JSR $9C9E
		RTL