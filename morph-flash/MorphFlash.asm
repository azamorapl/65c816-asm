lorom

!timer = $1F60		;unused stack

org $91FDE7    		;morphin'
	JSL Morph : NOP

org $91ECFB      	;unmorphin'
	JSL UnMorph : NOP #2

org $90FBA0
Morph:
    PHA : PHX : PHY : PHB : PHD : PHP
    JSL CHECK
    PLP : PLD : PLB : PLY : PLX : PLA
    STA $0B00 : LDA $12 ;moved
    RTL
UnMorph:
    PHA : PHX : PHY : PHB : PHD : PHP
	JSL CHECK
    PLP : PLD : PLB : PLY : PLX : PLA
    AND #$00FF : STA $0B00 ;moved
	RTL


org $A0868F ;main hijack point, runs every frame

JSR $FFB0


org $A0FFB0 ; push stuff in case it's needed later
PHA : PHX : PHY
JSL MORPH_FLASH
PLY : PLX : PLA
LDA $1840 ;pull stuff after the routine is run and do what the hijack jump overwrote
RTS

org $85A000
CHECK:
		PHA
		CMP #$0007
		BNE +
		LDA #$0015
		STA !timer
		 ;LDA #$001C
		 ;JSL $809143
         ;33 ;3a ;3f
		 LDA #$0018
		 JSL $8090C1		;play sound
		 ;LDA #$0040
		 ;JSL $8090C1		;play sound
+
		PLA
		RTL

MORPH_FLASH:

        LDA !timer      ;can be 8, 7, 6, 5, 4, 3, 2 and 1
        BEQ QUIT        ;if timer is 0, go, we're done already.
        BMI QUIT        ;should the timer ever be negative, go as well
        CMP #$0016
        BCS QUIT        ;if the timer is greater than 8 for any reason, get the hell outta here!
        DEC a           ;subtract 1 to save us an additional table entry
        ASL a
        TAX             ;used as an index now
        LDA $09A2       ;equipped items
        AND #$0021      ;wipe out the other items
        BEQ NORMAL      ;if it's equal we have power suit
        BIT #$0020      ;check for gravity suit
        BNE GRAVITY
        BIT #$0001      ;check for varia suit
        BNE VARIA

NORMAL:
        LDA #$0000      ;normal suit
        BRA FLASH

GRAVITY:
        LDA #$0200      ;to get 9A20
        BRA FLASH
VARIA:
        LDA #$0100      ;to get 9920

FLASH:
        STA $12         ;temporary
        LDA FLASH_PATTERN, x    ;load palette pointer from pattern table (timer used as index)
        CLC
        ADC $12                 ;add our values for suit palette addresses
        TAX                    ;now we have a source pointer in X
        LDY #$C180              ;now we have a destination pointer in Y
        LDA #$0020              ;how many bytes to transfer (palette lines are 0x20 bytes each)
        MVN $9B7E               ;9B is the bank where the charge palette is, 7E is RAM
;       JSR FLASH_STORE         ;no need for this, so you can get rid of that
        DEC !timer              ;decrease timer
QUIT:                           ;at the end, pull stuff that was once pushed (very important)
        RTL                     ;end

;9820 is the start of normal suit charge palette
;9920 is the start of varia suit charge palette, 0x9820 + 0x0100
;9A20 is start start of gravity suit charge palette 0x9820 + 0x0200



FLASH_PATTERN:

    DW $9820        ; palette line 0x0, regular palette
    DW $9840        ; palette line 0x1
            DW $9840        ; palette line 0x1
            DW $9840        ; palette line 0x1
    DW $9860        ; palette line 0x2
            DW $9860        ; palette line 0x2
            DW $9860        ; palette line 0x2
    DW $9880        ; palette line 0x3
            DW $9880        ; palette line 0x3
            DW $9880        ; palette line 0x3
    DW $98A0        ; palette line 0x4
            DW $98A0        ; palette line 0x4
                DW $98A0        ; palette line 0x4
    DW $98C0        ; palette line 0x5
            DW $98C0        ; palette line 0x5
        DW $98E0        ; palette line 0x6
                DW $98E0        ; palette line 0x6
        DW $9900        ; palette line 0x7
                DW $9900        ; palette line 0x7
        DW $98A0        ; palette line 0x4
                DW $98A0        ; palette line 0x4
