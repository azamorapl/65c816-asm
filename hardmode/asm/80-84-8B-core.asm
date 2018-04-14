{; B4: COMMON FUNCTIONS =================
  org $86FA00
    IsNormalModeEnabled: ;return Z=normal z,n=easy z,N=hard
      REP #$20
      LDA !DifficultyAddress : CMP DifficultyFlags,0
      RTL
    SwitchUIEnergyFormula:
      LDA $09C2 ;moved
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA !EnergyPerTankAddress : LSR A : STA !TempAddress
      CMP !StartingEnergyAddress : BPL +
      PLA
      SEC : SBC !TempAddress
      PHA
    + PLA
      STA $4204 ;moved
      RTL
    AdjustUIEnergy:
      LDA $09C4 ;moved
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA !EnergyPerTankAddress  : LSR A : STA !TempAddress
      PLA
      SEC : SBC !TempAddress
      PHA
    + PLA
      STA $4204 ;moved
      RTL
    ScaleUIEnergy:
      PHA
      JSL IsNormalModeEnabled : SEP #$20 : BEQ + : BMI +
      PLA
      LSR A
      PHA
    + PLA
      STA $4206 ;moved
      PHA : PLA : PHA : PLA
      RTL
}

{; 8B: SAVE FLAG IN SRAM =================
  !EasyFlag = $0001
  !NormalFlag = $0002
  !HardFlag = $0003

  org $8BC113 : JSR SaveDifficultyFlag

  org $8BF7A0
    SaveDifficultyFlag:
      LDA !PlaceholderAddress : ASL A : TAX
      LDA DifficultyFlags,x : STA !DifficultyAddress
      CMP #!HardFlag : BNE +
      LDA !HardEventFlag
      JSL $8081FA ;save hardmode event bit
    + LDA $0952 ;moved
      RTS
    DifficultyFlags:
      DW !NormalFlag,!HardFlag,!EasyFlag
}

{; 80: LOAD FLAG FROM SRAM =================
  org $80858F : JSR CheckFlagInitialized

  org $80FB50
    CheckFlagInitialized: ;in case you load a slot saved before the patch
      LDA !DifficultyAddress : CMP #$0000 : BNE + ;check if flag has value
      LDA #!NormalFlag : STA !DifficultyAddress ;force normal mode
    + LDA $7E079F ;moved
      RTS
}
