{; 97: SPECIAL SETTINGS TILEMAPS =================
org $978DF4
incbin bin\Options.bin

org $978FCD
;incbin bin\Controller.bin
incbin bin\ControllerCF.bin

org $97938D
;incbin bin\Special.bin
incbin bin\SpecialCF.bin
}

{; 82: SPECIAL SETTINGS TEXT =================
  org $82F097 : JSR ChangeMenuValue : NOP #16
  org $82F0C2 : JSR HighlightMenu : NOP #99 : NOP #32

  org $82FD2F
    ChangeMenuValue:
      CMP #$09EA : BNE MovedValue
      LDA !PlaceholderAddress : CMP #$0002 : BEQ +
      CLC : ADC #$0001 : BRA ++
    + LDA #$0000
   ++ STA !PlaceholderAddress
      LDA #$0000 : BRA ReturnValue ;leave item cancel at 0
    MovedValue:
      LDA $0000,x : BEQ +
      LDA #$0000 : BRA ReturnValue
    + LDA #$0001
    ReturnValue:
      STA $0000,x
      RTS
    HighlightMenu:
      CMP #$09EA : BEQ + : JMP MovedHighlightCode
    + LDA !PlaceholderAddress : CMP #$0001 : BMI HighlightNormal : BEQ HighlightHard
      JMP HighlightEasy
    HighlightNormal:
      LDA $099E : ASL A : ASL A : TAX
      PHX
      LDA #$01E6 : TAX : LDY #$000E : LDA #$0000 : JSR $ED28  
      PLX
      PHX
      LDA #$0226 : TAX : LDY #$000E : LDA #$0000 : JSR $ED28  
      PLX
      PHX
      LDA #$01DC : TAX : LDY #$000A : LDA #$0400 : JSR $ED28  
      PLX
      LDA #$021C : TAX : LDY #$000A : LDA #$0400 : JSR $ED28
      RTS
    HighlightHard:
      LDA $099E : ASL A : ASL A : TAX
      PHX
      LDA #$01F4 : TAX : LDY #$000A : LDA #$0000 : JSR $ED28  
      PLX
      PHX
      LDA #$0234 : TAX : LDY #$000A : LDA #$0000 : JSR $ED28  
      PLX
      PHX
      LDA #$01E6 : TAX : LDY #$000E : LDA #$0400 : JSR $ED28  
      PLX
      LDA #$0226 : TAX : LDY #$000E : LDA #$0400 : JSR $ED28
      RTS
    HighlightEasy:
      LDA $099E : ASL A : ASL A : TAX
      PHX
      LDA #$01DC : TAX : LDY #$000A : LDA #$0000 : JSR $ED28  
      PLX
      PHX
      LDA #$021C : TAX : LDY #$000A : LDA #$0000 : JSR $ED28  
      PLX
      PHX
      LDA #$01F4 : TAX : LDY #$000A : LDA #$0400 : JSR $ED28
      PLX
      LDA #$0234 : TAX : LDY #$000A : LDA #$0400 : JSR $ED28
      RTS
    MovedHighlightCode:
      LDA $0000,x : BNE +
      LDA $099E : ASL A : ASL A : TAX
      PHX
      LDA $F149,x : TAX : LDY #$000C : LDA #$0400 : JSR $ED28
      PLX
      PHX
      LDA $F14B,x : TAX : LDY #$000C : LDA #$0400 : JSR $ED28
      PLX
      PHX
      LDA $F151,x : TAX : LDY #$000C : LDA #$0000 : JSR $ED28
      PLX
      LDA $F153,x : TAX : LDY #$000C : LDA #$0000 : JSR $ED28
      RTS
    + LDA $099E : ASL A : ASL A : TAX
      PHX
      LDA $F149,x : TAX : LDY #$000C : LDA #$0000 : JSR $ED28
      PLX
      PHX
      LDA $F14B,x : TAX : LDY #$000C : LDA #$0000 : JSR $ED28
      PLX
      PHX
      LDA $F151,x : TAX : LDY #$000C : LDA #$0400 : JSR $ED28
      PLX
      LDA $F153,x : TAX : LDY #$000C : LDA #$0400 : JSR $ED28
      RTS

  org $82F480
    DW OptionsSprites

  org $82F488
    DW OptionsSprites

  org $82F490
    DW ControllerSprites

  org $82F498
    DW ControllerSprites

  org $82F4A0
    DW SpecialSprites

  org $82F4A8
    DW SpecialSprites

  org $82D24B
    OptionsSprites:
      DB $22,$00
      DB $CC,$01,$08,$FA,$3E
      DB $D4,$01,$08,$FA,$3E
      DB $DC,$01,$08,$FA,$3E
      DB $E4,$01,$08,$FA,$3E
      DB $EC,$01,$08,$FA,$3E
      DB $F4,$01,$08,$FA,$3E
      DB $FC,$01,$08,$FA,$3E
      DB $04,$00,$08,$FA,$3E
      DB $0C,$00,$08,$FA,$3E
      DB $14,$00,$08,$FA,$3E
      DB $1C,$00,$08,$FA,$3E
      DB $24,$00,$08,$FA,$3E
      DB $2C,$00,$08,$FA,$3E

      DB $34,$00,$08,$FD,$3E
      DB $34,$00,$00,$ED,$3E
      DB $34,$00,$F8,$ED,$3E
      DB $34,$00,$F0,$FB,$3E

      DB $2C,$00,$F0,$FA,$3E
      DB $24,$00,$F0,$FA,$3E
      DB $1C,$00,$F0,$FA,$3E
      DB $14,$00,$F0,$FA,$3E
      DB $0C,$00,$F0,$FA,$3E
      DB $04,$00,$F0,$FA,$3E
      DB $FC,$01,$F0,$FA,$3E
      DB $F4,$01,$F0,$FA,$3E
      DB $EC,$01,$F0,$FA,$3E
      DB $E4,$01,$F0,$FA,$3E
      DB $DC,$01,$F0,$FA,$3E
      DB $D4,$01,$F0,$FA,$3E
      DB $CC,$01,$F0,$FA,$3E

      DB $C4,$01,$F0,$F9,$3E
      DB $C4,$01,$F8,$ED,$3E
      DB $C4,$01,$00,$ED,$3E
      DB $C4,$01,$08,$FC,$3E

  ControllerSprites:
      DB $30,$00
      DB $B4,$01,$08,$FA,$3E
      DB $BC,$01,$08,$FA,$3E
      DB $C4,$01,$08,$FA,$3E
      DB $CC,$01,$08,$FA,$3E
      DB $D4,$01,$08,$FA,$3E
      DB $DC,$01,$08,$FA,$3E
      DB $E4,$01,$08,$FA,$3E
      DB $EC,$01,$08,$FA,$3E
      DB $F4,$01,$08,$FA,$3E
      DB $FC,$01,$08,$FA,$3E
      DB $04,$00,$08,$FA,$3E
      DB $0C,$00,$08,$FA,$3E
      DB $14,$00,$08,$FA,$3E
      DB $1C,$00,$08,$FA,$3E
      DB $24,$00,$08,$FA,$3E
      DB $2C,$00,$08,$FA,$3E
      DB $34,$00,$08,$FA,$3E
      DB $3C,$00,$08,$FA,$3E
      DB $44,$00,$08,$FA,$3E
      DB $4C,$00,$08,$FA,$3E

      DB $54,$00,$08,$FD,$3E
      DB $54,$00,$00,$ED,$3E
      DB $54,$00,$F8,$ED,$3E
      DB $54,$00,$F0,$FB,$3E

      DB $4C,$00,$F0,$FA,$3E
      DB $44,$00,$F0,$FA,$3E
      DB $3C,$00,$F0,$FA,$3E
      DB $34,$00,$F0,$FA,$3E
      DB $2C,$00,$F0,$FA,$3E
      DB $24,$00,$F0,$FA,$3E
      DB $1C,$00,$F0,$FA,$3E
      DB $14,$00,$F0,$FA,$3E
      DB $0C,$00,$F0,$FA,$3E
      DB $04,$00,$F0,$FA,$3E
      DB $FC,$01,$F0,$FA,$3E
      DB $F4,$01,$F0,$FA,$3E
      DB $EC,$01,$F0,$FA,$3E
      DB $E4,$01,$F0,$FA,$3E
      DB $DC,$01,$F0,$FA,$3E
      DB $D4,$01,$F0,$FA,$3E
      DB $CC,$01,$F0,$FA,$3E
      DB $C4,$01,$F0,$FA,$3E
      DB $BC,$01,$F0,$FA,$3E
      DB $B4,$01,$F0,$FA,$3E

      DB $AC,$01,$F0,$F9,$3E
      DB $AC,$01,$F8,$ED,$3E
      DB $AC,$01,$00,$ED,$3E
      DB $AC,$01,$08,$FC,$3E

  SpecialSprites:
      DB $28,$00
      DB $C0,$01,$08,$FA,$3E
      DB $C8,$01,$08,$FA,$3E
      DB $D0,$01,$08,$FA,$3E
      DB $D8,$01,$08,$FA,$3E
      DB $E0,$01,$08,$FA,$3E
      DB $E8,$01,$08,$FA,$3E
      DB $F0,$01,$08,$FA,$3E
      DB $F8,$01,$08,$FA,$3E
      DB $00,$00,$08,$FA,$3E
      DB $08,$00,$08,$FA,$3E
      DB $10,$00,$08,$FA,$3E
      DB $18,$00,$08,$FA,$3E
      DB $20,$00,$08,$FA,$3E
      DB $28,$00,$08,$FA,$3E
      DB $30,$00,$08,$FA,$3E
      DB $38,$00,$08,$FA,$3E

      DB $40,$00,$08,$FD,$3E
      DB $40,$00,$00,$ED,$3E
      DB $40,$00,$F8,$ED,$3E
      DB $40,$00,$F0,$FB,$3E

      DB $38,$00,$F0,$FA,$3E
      DB $30,$00,$F0,$FA,$3E
      DB $28,$00,$F0,$FA,$3E
      DB $20,$00,$F0,$FA,$3E
      DB $18,$00,$F0,$FA,$3E
      DB $10,$00,$F0,$FA,$3E
      DB $08,$00,$F0,$FA,$3E
      DB $00,$00,$F0,$FA,$3E
      DB $F8,$01,$F0,$FA,$3E
      DB $F0,$01,$F0,$FA,$3E
      DB $E8,$01,$F0,$FA,$3E
      DB $E0,$01,$F0,$FA,$3E
      DB $D8,$01,$F0,$FA,$3E
      DB $D0,$01,$F0,$FA,$3E
      DB $C8,$01,$F0,$FA,$3E
      DB $C0,$01,$F0,$FA,$3E

      DB $B8,$01,$F0,$F9,$3E
      DB $B8,$01,$F8,$ED,$3E
      DB $B8,$01,$00,$ED,$3E
      DB $B8,$01,$08,$FC,$3E
}