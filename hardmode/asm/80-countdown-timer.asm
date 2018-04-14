{; 80: COUNTDOWN TIMER ADJUSTMENT =================
  !CeresCountdownSeconds = $809E0E
  !MotherBrainCountdownSeconds = $809E21

  org $809E10 : JSR TweakCeresCountdown : NOP
  org $809E23 : JSR TweakMotherBrainCountdown : NOP

  org $80FA00
    TweakCeresCountdown:
      PHX
      LDX !CeresCountdownSeconds
      JSR AdjustCountdown
      PLX
      JSL $809E8C ;moved
      RTS
    TweakMotherBrainCountdown:
      PHX
      LDX !MotherBrainCountdownSeconds
      JSR AdjustCountdown
      PLX
      JSL $809E8C ;moved
      RTS
    AdjustCountdown:
      TXA
      PHA
      AND #$00FF : CMP #$0000 : BNE ++ ;lazy, only works if seconds are 00
      JSL IsNormalModeEnabled : BEQ ++ : BMI +
      PLA
      SEC : SBC #$00D0
      PHA
      BRA ++
    + PLA
      CLC : ADC #$0030
      PHA
   ++ PLA
      RTS
}