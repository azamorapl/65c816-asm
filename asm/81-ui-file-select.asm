{; 81: FILE SELECT UI TWEAKS =================
  !A = $206A : !B = $206B : !C = $206C : !D = $206D : !E = $206E
  !F = $206F : !G = $2070 : !H = $2071 : !I = $2072 : !J = $2073
  !K = $2074 : !L = $2075 : !M = $2076 : !N = $2077 : !O = $2078
  !P = $2079 : !Q = $207A : !R = $207B : !S = $207C : !T = $207D
  !U = $207E : !V = $207F : !W = $2080 : !X = $2081 : !Y = $2082
  !Z = $2083 : !Space = $200F : !Dot = $2088 : !Star = $20B8

  org $81A0A8
    LDA $09C2 : STA $4204
    ;JSL SwitchUIEnergyFormula : NOP #2
  org $81A0B2
    STA $4206 : PHA : PLA : PHA : PLA
    ;JSL ScaleUIEnergy : NOP #3
  org $81A0C5
    LDA $09C4 : STA $4204
    ;JSL AdjustUIEnergy : NOP #2
  org $81A0CF
    STA $4206 : PHA : PLA : PHA : PLA
    ;JSL ScaleUIEnergy : NOP #3
  org $81A117
    STA $4204
    ;JSR TweakFileEnergyDigits
  org $81A149
    JSR DisplayDifficulty : NOP

  org $81FA00
    TweakFileEnergyDigits:
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      LDA $09C2 : CLC : SBC #$0001 : CMP !StartingEnergyAddress : BPL +
      LDA !EnergyPerTankAddress : LSR A : STA !TempAddress
      PLA
      CLC : ADC !TempAddress
      PHA
    + PLA
      STA $4204 ;moved
      RTS
    DisplayDifficulty:
      STA $7E3642,x ;moved
      PHY : PHX
      LDA $079F : ASL A : TAY
      LDA RegionSprites,y : TAY
    - LDA $0000,y
      BMI +
      ORA $0F96 : STA $7E366A,X
      INX : INX : INY : INY
      BRA -
    + PLX : PHX
      LDA !DifficultyAddress : ASL A : TAY
      LDA DifficultySprites,y : TAY
    - LDA $0000,y
      BMI +
      ORA $0F96 : STA $7E3698,x
      INX : INX : INY : INY
      BRA -
    + PLX : PLY
      RTS
    DifficultySprites:
      DW NormalSprites,EasySprites,NormalSprites,HardSprites
    EasySprites:
      DW !E,!A,!S,!Y,$FFFF
    NormalSprites:
      DW !N,!O,!R,!M,!A,!L,$FFFF
    HardSprites:
      DW !H,!A,!R,!D,$FFFF
    RegionSprites:
      DW CrateriaSprites,BrinstarSprites,NorfairSprites,WreckedShipSprites,MaridiaSprites,TourianSprites,CeresSprites,DebugSprites
    CrateriaSprites:
      DW !C,!R,!A,!T,!E,!R,!I,!A,$FFFF
    BrinstarSprites:
      DW !B,!R,!I,!N,!S,!T,!A,!R,$FFFF
    NorfairSprites:
      DW !N,!O,!R,!F,!A,!I,!R,$FFFF
    WreckedShipSprites:
      DW !W,!Dot,!Space,!S,!H,!I,!P,$FFFF
    MaridiaSprites:
      DW !M,!A,!R,!I,!D,!I,!A,$FFFF
    TourianSprites:
      DW !T,!O,!U,!R,!I,!A,!N,$FFFF
    CeresSprites:
      DW !C,!O,!L,!O,!N,!Y,$FFFF
    DebugSprites:
      DW !D,!E,!B,!U,!G,$FFFF
}