{; 86: DROP RATE & REFILL SCALING =================
  org $86F16D : JSR ScaleDropRate : NOP
  org $86F0BE : JSR ScaleEnergyOrbValue : NOP
  org $86F0CD : JSR ScaleEnergyOrbValue : NOP
  org $86F0EB : JSR ScaleMissileAmmo : NOP

  org $86F5A0
    ScaleDropRate:
      LDA $B40003,x ;moved
      PHA
      JSL IsNormalModeEnabled : SEP #$20 : BEQ + : BMI +
      PLA
      CMP #$10 : BPL ++ ;buff enemies with less than 10%
      CLC : ADC #$01
   ++ ASL A
      PHA
    + PLA
      RTS    
    ScaleEnergyOrbValue:
      JSR ScaleRefill
      JSL $91DF12 ;moved
      RTS    
    ScaleMissileAmmo:
      JSR ScaleRefill
      JSL $91DF80 ;moved
      RTS
    ScaleRefill:
      PHA
      JSL IsNormalModeEnabled : BEQ + : BMI +
      PLA
      LSR A
      PHA
    + PLA
      RTS
}