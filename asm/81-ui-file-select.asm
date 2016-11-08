{; 81: FILE SELECT UI TWEAKS =================
  org $81A0A8 : JSL SwitchUIEnergyFormula : NOP #2
  org $81A0B2 : JSL ScaleUIEnergy : NOP #3
  org $81A0C5 : JSL AdjustUIEnergy : NOP #2
  org $81A0CF : JSL ScaleUIEnergy : NOP #3
  org $81A117 : JSR TweakFileEnergyDigits
  org $81A149 : JSR DisplayDifficulty : NOP

  org $81FA00
    TweakFileEnergyDigits:
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA $09C2 : CMP !StartingEnergyAddress : BPL +
      LDA !EnergyPerTankAddress : LSR A : STA !TempAddress
      PLA
      CLC : ADC !TempAddress
      PHA
    + PLA
      STA $4204 ;moved
      RTS
    DisplayDifficulty:
      STA $7E3642,x ;moved
      PHX : PHY
      LDA !DifficultyAddress : ASL A : TAY
      LDA DifficultySprites,y
      TAY
    - LDA $0000,y
      BMI +
      STA $7E366A,x
      INX : INX : INY : INY
      BRA -
    + PLY : PLX
      RTS
    DifficultySprites:
      DW NormalSprites,EasySprites,NormalSprites,HardSprites
    EasySprites:
      DW $206E,$206A,$207C,$2082,$FFFF
    NormalSprites:
      DW $2077,$2078,$207B,$2076,$206A,$2075,$FFFF
    HardSprites:
      DW $2071,$206A,$207B,$206D,$FFFF
}