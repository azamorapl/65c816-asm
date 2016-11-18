{; 80: HUD UI TWEAKS =================
  org $809B96
    ;LDA $09C2 : STA $4204
    JSL SwitchUIEnergyFormula : NOP #2
  org $809BA0
    ;STA $4206 : PHA : PLA : PHA : PLA
    JSL ScaleUIEnergy : NOP #3
  org $809BB3
    ;LDA $09C4 : STA $4204
    JSL AdjustUIEnergy : NOP #2
  org $809BBD
    ;STA $4206 : PHA : PLA : PHA : PLA
    JSL ScaleUIEnergy : NOP #3
  org $809BF3
    ;LDX #$008C
    JSR HUDEnergyDigits

  org $80FF00
    HUDEnergyDigits:
      LDX #$008C ;moved
      LDA $09C2 : CLC : SBC #$0001 : CMP !StartingEnergyAddress : BPL +
      LDA $09C2 : STA $7E0012 ;moved
    + RTS      
}