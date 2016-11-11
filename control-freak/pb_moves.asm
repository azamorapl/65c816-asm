lorom

;ASM to keep running speed while landing. This is more effective than simply changing the pose table, as you can have variables, doesn't move you forward a pixel, and (from what I tested) doesn't cause a palette glitch.

;Made by SadiztykFish for Grime =)

!Spark = $05D5
org $90D34C
   JSR Set
org $90A383
   JMP Landy
SLOWDOWN:
org $90FA00         ;Uses free space from $8763A to $87663 (depending on variables)
Landy:
   PHP
   REP #$30
   LDA !Spark
   AND #$0000
   STA !Spark
   BNE SLOW

;If you want to disable the check for the SpeedBooster item, delete or comment the next 3 lines by putting a ; in front

   ;LDA $09A2
   ;AND #$2000
   ;BEQ SLOW

;If you want to disable the check for RUN (so you don't need to be holding it to keep speed), delete or comment the next 3 lines

  ; LDA $8B
  ; AND $09B6
  ; BEQ SLOW

;To keep speed even if you aren't spinning (ie, even if you just run off a ledge), uncomment the next line by removing the ; and comment/delete the next 9 lines (if you want to save space)

;   BRA END

   LDA $0A24
   CMP #$0013
   BEQ END
   CMP #$0014
   BEQ END
   CMP #$0019
   BEQ END
   CMP #$001A
   BEQ END
   CMP #$001B
   BEQ END
   CMP #$001C
   BEQ END
   CMP #$0027
   BEQ END
   CMP #$0028
   BEQ END
   CMP #$0029
   BEQ END
   CMP #$002A
   BEQ END
   CMP #$003D
   BEQ END
   CMP #$003E
   BEQ END
   CMP #$0051
   BEQ END
   CMP #$0052
   BEQ END
   CMP #$0067
   BEQ END
   CMP #$0068
   BEQ END
   CMP #$0081
   BEQ END
   CMP #$0082
   BEQ END
   CMP #$0083
   BEQ END
   CMP #$0084
   BEQ END
SLOW:
   JMP SLOWDOWN
END:
   PLP
   RTS
Set:
   LDA #$0001
   STA !Spark
   LDA $0AAF
   RTS

!FirstLift = #$0000		;How many frames before the FIRST lift. 0008 = double-jump effect
!DecayOne = #$0005		;How many frames until 1st vertical momentum slowdown
!DecayTwo = #$0010		;How many frames until 2nd vertical momentum slowdown
!DecayThree = #$0025		;How many frames until 3rd vertical momentum slowdown / after falling
!StartSpeed = #$005		;How many pixels to boost up at the start
!LiftSpeed = #$0004		;How many pixels to boost up during damage boost
!DecaySpeedOne = #$0002		;How many pixels to boost up during damage boost after 1st decay time
!DecaySpeedTwo = #$0001		;How many pixels to boost up during damage boost after 2nd decay time

org $A0868F
JSR $FF00

org $A0FF00
PHX
LDA $0A28
CMP #$004F
BEQ YAY
CMP #$0050
BEQ YAY
LDA $0A1C
CMP #$004F
BEQ WOO
CMP #$0050
BEQ WOO
ENDLIFTY:
PLX
LDA $1840 
RTS

YAY:
LDA #$0002
STA $0B36
LDA #$FFFF-!StartSpeed
JSL VERTICALCHECK
BRA ENDLIFTY

WOO:
LDX $05D5
INX
STX $05D5
CPX !FirstLift
BPL SAMUSGOUP
BRA ENDLIFTY

SAMUSGOUP:
CPX !DecayThree
BPL ENDLIFTY
CPX !DecayTwo
BPL $0A
CPX !DecayOne
BPL $0A
LDA #$FFFF-!LiftSpeed
BRA $08
LDA #$FFFF-!DecaySpeedOne
BRA $03
LDA #$FFFF-!DecaySpeedOne
JSL VERTICALCHECK
BRA ENDLIFTY
org $90F780
VERTICALCHECK:
STA $12
STZ $14
JSR $9440
RTL

org $90F63A		;I put a lot of custom ASM here, so you should check whether it's  free first
	LDA $0A23
	AND #$00FF
	CMP #$0003
	BEQ ENDAIR
	CMP #$0002
	BEQ ENDAIR
	CMP #$0006
	BEQ ENDAIR
	CMP #$0014
	BEQ ENDAIR
	JSL $9098BC
ENDAIR:
	RTL

;Note:
;Falling means you walked off a ledge or demorphed in midair
;Jumping means you used the jump button

;00: Facing forward, ala Elevator pose.
;01: Facing right, normal
;02: Facing left, normal
;03: Facing right, aiming up
;04: Facing left, aiming up
;05: Facing right, aiming upright
;06: Facing left, aiming upleft
;07: Facing right, aiming downright
;08: Facing left, aiming downleft
;09: Moving right, not aiming
;0A: Moving left, not aiming
;0B: Moving right, gun extended forward (not aiming)
;0C: Moving left, gun extended forward (not aiming)
;0D: Moving right, aiming straight up (unused?)
;0E: Moving left, aiming straight up (unused?)
;0F: Moving right, aiming upright
;10: Moving left, aiming upleft
;11: Moving right, aiming downright
;12: Moving left, aiming downleft
;13: Normal jump facing right, gun extended, not aiming or moving
;14: Normal jump facing left, gun extended, not aiming or moving
;15: Normal jump facing right, aiming up
;16: Normal jump facing left, aiming up
;17: Normal jump facing right, aiming down
;18: Normal jump facing left, aiming down
;19: Spin Jump right
;1A: Spin Jump left
;1B: Space jump right
;1C: Space jump left
;1D: Facing right as morphball, no springball
;1E: Moving right as a morphball on ground without springball
;1F: Moving left as a morphball on ground without springball
;20: Spinjump right. Unused?
;21: Spinjump right. Unused?
;22: Spinjump right. Unused?
;23: Spinjump right. Unused?
;24: Spinjump right. Unused?
;25: Starting standing right, turning left
;26: Starting standing left, turning right
;27: Crouching, facing right
;28: Crouching, facing left
;29: Falling facing right, normal pose
;2A: Falling facing left, normal pose
;2B: Falling facing right, aiming up
;2C: Falling facing left, aiming up
;2D: Falling facing right, aiming down
;2E: Falling facing left, aiming down
;2F: Starting with normal jump facing right, turning left
;30: Starting with normal jump facing left, turning right
;31: Midair morphball facing right without springball
;32: Midair morphball facing left without springball
;33: Spinjump right. Unused?
;34: Spinjump right. Unused?
;35: Crouch transition, facing right
;36: Crouch transition, facing left
;37: Morphing into ball, facing right. Ground and mid-air
;38: Morphing into ball, facing left. Ground and mid-air
;39: Midair morphing into ball, facing right? May be unused
;3A: Midair morphing into ball, facing left? May be unused
;3B: Standing from crouching, facing right
;3C: Standing from crouching, facing left
;3D: Demorph while facing right. Mid-air and on ground
;3E: Demorph while facing left. Mid-air and on ground
;3F: Some transition with morphball, facing right. Maybe unused
;40: Some transition with morphball, facing left. Maybe unused
;41: Staying still with morphball, facing left, no springball
;42: Spinjump right. Unused?
;43: Starting from crouching right, turning left
;44: Starting from crouching left, turning right
;45: Running, facing right, shooting left. Unused? (Fast moonwalk)
;46: Running, facing left, shooting right. Unused? (Fast moonwalk)
;47: Standing, facing right. Unused?
;48: Standing, facing left. Unused?
;49: Moonwalk, facing left
;4A: Moonwalk, facing right
;4B: Normal jump transition from ground(standing or crouching), facing right
;4C: Normal jump transition from ground(standing or crouching), facing left
;4D: Normal jump facing right, gun not extended, not aiming, not moving
;4E: Normal jump facing left, gun not extended, not aiming, not moving
;4F: Hurt roll back, moving right/facing left
;50: Hurt roll back, moving left/facing right
;51: Normal jump facing right, moving forward (gun extended)
;52: Normal jump facing left, moving forward (gun extended)
;53: Hurt, facing right
;54: Hurt, facing left
;55: Normal jump transition from ground, facing right and aiming up
;56: Normal jump transition from ground, facing left and aiming up
;57: Normal jump transition from ground, facing right and aiming upright
;58: Normal jump transition from ground, facing left and aiming upleft
;59: Normal jump transition from ground, facing right and aiming downright
;5A: Normal jump transition from ground, facing left and aiming downleft
;5B: Something for grapple (wall jump?), probably unused
;5C: Something for grapple (wall jump?), probably unused
;5D: Broken grapple? Facing clockwise, maybe unused
;5E: Broken grapple? Facing clockwise, maybe unused
;5F: Broken grapple? Facing clockwise, maybe unused
;60: Better broken grapple. Facing clockwise, maybe unused
;61: Nearly normal grapple. Facing clockwise, maybe unused
;62: Nearly normal grapple. Facing counterclockwise, maybe unused
;63: Facing left on grapple blocks, ready to jump. Unused?
;64: Facing right on grapple blocks, ready to jump. Unused?
;65: Glitchy jump, facing left. Used by unused grapple jump?
;66: Glitchy jump, facing right. Used by unused grapple jump?
;67: Facing right, falling, fired a shot
;68: Facing left, falling, fired a shot
;69: Normal jump facing right, aiming upright. Moving optional
;6A: Normal jump facing left, aiming upleft. Moving optional
;6B: Normal jump facing right, aiming downright. Moving optional
;6C: Normal jump facing left, aiming downleft. Moving optional
;6D: Falling facing right, aiming upright
;6E: Falling facing left, aiming upleft
;6F: Falling facing right, aiming downright
;70: Falling facing left, aiming downleft
;71: Standing to crouching, facing right and aiming upright
;72: Standing to crouching, facing left and aiming upleft
;73: Standing to crouching, facing right and aiming downright
;74: Standing to crouching, facing left and aiming downleft
;75: Moonwalk, facing left aiming upleft
;76: Moonwalk, facing right aiming upright
;77: Moonwalk, facing left aiming downleft
;78: Moonwalk, facing right aiming downright
;79: Spring ball on ground, facing right
;7A: Spring ball on ground, facing left
;7B: Spring ball on ground, moving right
;7C: Spring ball on ground, moving left
;7D: Spring ball falling, facing/moving right
;7E: Spring ball falling, facing/moving left
;7F: Spring ball jump in air, facing/moving right
;80: Spring ball jump in air, facing/moving left
;81: Screw attack right
;82: Screw attack left
;83: Walljump right
;84: Walljump left
;85: Crouching, facing right aiming up
;86: Crouching, facing left aiming up
;87: Turning from right to left while falling
;88: Turning from left to right while falling
;89: Ran into a wall on right (facing right)
;8A: Ran into a wall on left (facing left)
;8B: Turning around from right to left while aiming straight up while standing
;8C: Turning around from left to right while aiming straight up while standing
;8D: Turn around from right to left while aiming diagonal down while standing
;8E: Turn around from left to right while aiming diagonal down while standing
;8F: Turning around from right to left while aiming straight up in midair
;90: Turning around from left to right while aiming straight up in midair
;91: Turning around from right to left while aiming down or diagonal down in midair
;92: Turning around from left to right while aiming down or diagonal down in midair
;93: Turning around from right to left while aiming straight up while falling
;94: Turning around from left to right while aiming straight up while falling
;95: Turning around from right to left while aiming down or diagonal down while falling
;96: Turning around from left to right while aiming down or diagonal down while falling
;97: Turning around from right to left while aiming straight up while crouching
;98: Turning around from left to right while aiming straight up while crouching
;99: Turning around from right to left while aiming diagonal down while crouching
;9A: Turning around from left to right while aiming diagonal down while crouching
;9B: Facing forward, ala Elevator pose... with the Varia and/or Gravity Suit.
;9C: Turning around from right to left while aiming diagonal up while standing
;9D: Turning around from left to right while aiming diagonal up while standing
;9E: Turning around from right to left while aiming diagonal up in midair
;9F: Turning around from left to right while aiming diagonal up in midair
;A0: Turning around from right to left while aiming diagonal up while falling
;A1: Turning around from left to right while aiming diagonal up while falling
;A2: Turn around from right to left while aiming diagonal up while crouching
;A3: Turn around from left to right while aiming diagonal up while crouching
;A4: Landing from normal jump, facing right
;A5: Landing from normal jump, facing left
;A6: Landing from spin jump, facing right
;A7: Landing from spin jump, facing left
;A8: Just standing, facing right. Unused? (Grapple movement)
;A9: Just standing, facing left. Unused? (Grapple movement)
;AA: Just standing, facing right aiming downright. Unused? (Grapple movement)
;AB: Just standing, facing left aiming downleft. Unused? (Grapple movement)
;AC: Jumping, facing right, gun extended. Unused? (Grapple movement)
;AD: Jumping, facing left, gun extended. Unused? (Grapple movement)
;AE: Jumping, facing right, aiming down. Unused? (Grapple movement)
;AF: Jumping, facing left, aiming down. Unused? (Grapple movement)
;B0: Jumping, facing right, aiming downright. Unused? (Grapple movement)
;B1: Jumping, facing left, aiming downleft. Unused? (Grapple movement)
;B2: Grapple, facing clockwise
;B3: Grapple, facing counterclockwise
;B4: Crouching, facing right. Unused? (Grapple movement)
;B5: Crouching, facing left. Unused? (Grapple movement)
;B6: Crouching, facing right, aiming downright. Unused? (Grapple movement)
;B7: Crouching, facing left, aiming downleft. Unused? (Grapple movement)
;B8: Grapple, attached to a wall on right, facing left
;B9: Grapple, attached to a wall on left, facing right
;BA: Grabbed by Draygon, facing left, not moving
;BB: Grabbed by Draygon, facing left aiming upleft, not moving
;BC: Grabbed by Draygon, facing left and firing
;BD: Grabbed by Draygon, facing left aiming downleft, not moving
;BE: Grabbed by Draygon, facing left, moving
;BF: Jump/Turn right to left while moonwalking.
;C0: Jump/Turn left to right while moonwalking.
;C1: Jump/Turn right to left while moonwalking and aiming diagonal up.
;C2: Jump/Turn left to right while moonwalking and aiming diagonal up.
;C3: Jump/Turn right to left while moonwalking and aiming diagonal down.
;C4: Jump/Turn left to right while moonwalking and aiming diagonal down.
;C5: Morph ball, facing right. Unused? (Grabbed by Draygon movement)
;C6: Morph ball, facing left. Unused? (Grabbed by Draygon movement)
;C7: Super jump windup, facing right
;C8: Super jump windup, facing left
;C9: Horizontal super jump, right
;CA: Horizontal super jump, left
;CB: Vertical super jump, facing right
;CC: Vertical super jump, facing left
;CD: Diagonal super jump, right
;CE: Diagonal super jump, left
;CF: Samus ran right into a wall, is still holding right and is now aiming diagonal up
;D0: Samus ran left into a wall, is still holding left and is now aiming diagonal up
;D1: Samus ran right into a wall, is still holding right and is now aiming diagonal down
;D2: Samus ran left into a wall, is still holding left and is now aiming diagonal down
;D3: Crystal flash, facing right
;D4: Crystal flash, facing left
;D5: X-raying right, standing
;D6: X-raying left, standing
;D7: Crystal flash ending, facing right
;D8: Crystal flash ending, facing left
;D9: X-raying right, crouching
;DA: X-raying left, crouching
;DB: Standing transition to morphball, facing right? Unused?
;DC: Standing transition to morphball, facing left? Unused?
;DD: Morphball transition to standing, facing right? Unused?
;DE: Morphball transition to standing, facing left? Unused?
;DF: Samus is facing left as a morphball. Unused? (Grabbed by Draygon movement)
;E0: Landing from normal jump, facing right and aiming up
;E1: Landing from normal jump, facing left and aiming up
;E2: Landing from normal jump, facing right and aiming upright
;E3: Landing from normal jump, facing left and aiming upleft
;E4: Landing from normal jump, facing right and aiming downright
;E5: Landing from normal jump, facing left and aiming downleft
;E6: Landing from normal jump, facing right, firing
;E7: Landing from normal jump, facing left, firing
;E8: Samus exhausted(Metroid drain, MB attack), facing right
;E9: Samus exhausted(Metroid drain, MB attack), facing left
;EA: Samus exhausted, looking up to watch Metroid attack MB, facing right
;EB: Samus exhausted, looking up to watch Metroid attack MB, facing left
;EC: Grabbed by Draygon, facing right. Not moving
;ED: Grabbed by Draygon, facing right aiming upright. Not moving
;EC: Grabbed by Draygon, facing right and firing.
;EF: Grabbed by Draygon, facing right aiming downright. Not moving
;F0: Grabbed by Draygon, facing right. Moving
;F1: Crouch transition, facing right and aiming up
;F2: Crouch transition, facing left and aiming up
;F3: Crouch transition, facing right and aiming upright
;F4: Crouch transition, facing left and aiming upleft
;F5: Crouch transition, facing right and aiming downright
;F6: Crouch transition, facing left and aiming downleft
;F7: Crouching to standing, facing right and aiming up
;F8: Crouching to standing, facing left and aiming up
;F9: Crouching to standing, facing right and aiming upright
;FA: Crouching to standing, facing left and aiming upleft
;FB: Crouching to standing, facing right and aiming downright
;FC: Crouching to standing, facing left and aiming downleft

;8000: B button
;4000: Y button
;2000: Select
;1000: Start
;0800: Up
;0400: Down
;0200: Left
;0100: Right
;0080: A button
;0040: X button
;0020: L
;0010: R

org $919EE2
	DW T00,T01,T02,T03,T04,T05,T06,T07,T08,T09,T0A,T0B,T0C,T0D,T0E,T0F
	DW T10,T11,T12,T13,T14,T15,T16,T17,T18,T19,T1A,T1B,T1C,T1D,T1E,T1F
	DW T20,T21,T22,T23,T24,T25,T26,T27,T28,T29,T2A,T2B,T2C,T2D,T2E,T2F
	DW T30,T31,T32,T33,T34,T35,T36,T37,T38,T39,T3A,T3B,T3C,T3D,T3E,T3F
	DW T40,T41,T42,T43,T44,T45,T46,T47,T48,T49,T4A,T4B,T4C,T4D,T4E,T4F
	DW T50,T51,T52,T53,T54,T55,T56,T57,T58,T59,T5A,T5B,T5C,T5D,T5E,T5F
	DW T60,T61,T62,T63,T64,T65,T66,T67,T68,T69,T6A,T6B,T6C,T6D,T6E,T6F
	DW T70,T71,T72,T73,T74,T75,T76,T77,T78,T79,T7A,T7B,T7C,T7D,T7E,T7F
	DW T80,T81,T82,T83,T84,T85,T86,T87,T88,T89,T8A,T8B,T8C,T8D,T8E,T8F
	DW T90,T91,T92,T93,T94,T95,T96,T97,T98,T99,T9A,T9B,T9C,T9D,T9E,T9F
	DW TA0,TA1,TA2,TA3,TA4,TA5,TA6,TA7,TA8,TA9,TAA,TAB,TAC,TAD,TAE,TAF
	DW TB0,TB1,TB2,TB3,TB4,TB5,TB6,TB7,TB8,TB9,TBA,TBB,TBC,TBD,TBE,TBF
	DW TC0,TC1,TC2,TC3,TC4,TC5,TC6,TC7,TC8,TC9,TCA,TCB,TCC,TCD,TCE,TCF
	DW TD0,TD1,TD2,TD3,TD4,TD5,TD6,TD7,TD8,TD9,TDA,TDB,TDC,TDD,TDE,TDF
	DW TE0,TE1,TE2,TE3,TE4,TE5,TE6,TE7,TE8,TE9,TEA,TEB,TEC,TED,TEE,TEF
	DW TF0,TF1,TF2,TF3,TF4,TF5,TF6,TF7,TF8,TF9,TFA,TFB,TFC

T00:
T9B:
DW $0000,$0100,$0026
DW $0000,$0200,$0025
DW $FFFF

T01:
DW $0000,$4400,$0037 ;quick morph while facing right
T03:
T05:
T07:
TA4:
TA6:
TE0:
TE2:
TE4:
TE6:
DW $0080,$0800,$0055
DW $0080,$0010,$0057
DW $0080,$0020,$0059
DW $0080,$8000,$0019
DW $0080,$0000,$004B
DW $0400,$0030,$00F1
DW $0400,$0010,$00F3
DW $0400,$0020,$00F5
DW $0400,$0000,$0035
DW $0000,$0260,$0078
DW $0000,$0250,$0076
DW $0000,$0230,$0025
DW $0000,$0030,$0003
DW $0000,$0110,$000F
DW $0000,$0120,$0011
DW $0000,$0900,$000F
DW $0000,$0500,$0011
DW $0000,$0240,$004A
DW $0000,$0200,$0025
DW $0000,$0800,$0003
DW $0000,$0010,$0005
DW $0000,$0020,$0007
DW $0000,$0100,$0009
DW $FFFF

T02:
DW $0000,$4400,$0038 ;quick morph while facing left
T04:
T06:
T08:
TA5:
TA7:
TE1:
TE3:
TE5:
TE7:
DW $0080,$0800,$0056
DW $0080,$0010,$0058
DW $0080,$0020,$005A
DW $0080,$8000,$001A
DW $0080,$0000,$004C
DW $0400,$0030,$00F2
DW $0400,$0010,$00F4
DW $0400,$0020,$00F6
DW $0400,$0000,$0036
DW $0000,$0160,$0077
DW $0000,$0150,$0075
DW $0000,$0140,$0049
DW $0000,$0100,$0026
DW $0000,$0030,$0004
DW $0000,$0210,$0010
DW $0000,$0220,$0012
DW $0000,$0A00,$0010
DW $0000,$0600,$0012
DW $0000,$0800,$0004
DW $0000,$0010,$0006
DW $0000,$0020,$0008
DW $0000,$0200,$000A
DW $FFFF

T09:
T0D:
T0F:
T11:
DW $0000,$4400,$0037 ;quick morph while running right
DW $0400,$0000,$0035
DW $0080,$0000,$0019
DW $0000,$0110,$000F
DW $0000,$0120,$0011
DW $0000,$0900,$000F
DW $0000,$0500,$0011
DW $0000,$0140,$000B
DW $0000,$0100,$0009
DW $0000,$0200,$0025
DW $0000,$0800,$0003
DW $0000,$0010,$0005
DW $0000,$0020,$0007
DW $FFFF

T0A:
T0E:
T10:
T12:
DW $0000,$4400,$0038 ;quick morph while running left
DW $0400,$0000,$0036
DW $0080,$0000,$001A
DW $0000,$0210,$0010
DW $0000,$0220,$0012
DW $0000,$0A00,$0010
DW $0000,$0600,$0012
DW $0000,$0240,$000C
DW $0000,$0200,$000A
DW $0000,$0100,$0026
DW $0000,$0800,$0004
DW $0000,$0010,$0006
DW $0000,$0020,$0008
DW $FFFF

T0B:
DW $0400,$0000,$0035
DW $0080,$0000,$0019
DW $0000,$0110,$000F
DW $0000,$0120,$0011
DW $0000,$0900,$000F
DW $0000,$0500,$0011
DW $0000,$0100,$000B
DW $0000,$0200,$0025
DW $0000,$0800,$0003
DW $0000,$0010,$0005
DW $0000,$0020,$0007
DW $FFFF

T0C:
DW $0400,$0000,$0036
DW $0080,$0000,$001A
DW $0000,$0210,$0010
DW $0000,$0220,$0012
DW $0000,$0A00,$0010
DW $0000,$0600,$0012
DW $0000,$0200,$000C
DW $0000,$0100,$0026
DW $0000,$0800,$0004
DW $0000,$0010,$0006
DW $0000,$0020,$0008
DW $FFFF

T13:
DW $0000,$4400,$0037 ;quick morph during jump, right
DW $0080,$0000,$0019
DW $0000,$0900,$0069
DW $0000,$0500,$006B
DW $0000,$0190,$0069
DW $0000,$01A0,$006B
DW $0000,$0200,$002F
DW $0000,$0800,$0015
DW $0000,$0400,$0017
DW $0000,$0010,$0069
DW $0000,$0020,$006B
DW $0000,$0100,$0051
DW $0000,$0040,$0013
DW $FFFF

T14:
DW $0000,$4400,$0038 ;quick morph during jump, left
DW $0080,$0000,$001A
DW $0000,$0A00,$006A
DW $0000,$0600,$006C
DW $0000,$0290,$006A
DW $0000,$02A0,$006C
DW $0000,$0100,$0030
DW $0000,$0800,$0016
DW $0000,$0400,$0018
DW $0000,$0010,$006A
DW $0000,$0020,$006C
DW $0000,$0200,$0052
DW $0000,$0040,$0014
DW $FFFF

T15:
T4D:
T51:
T69:
T6B:
DW $0000,$0420,$0037 ;quick morph during normal jump, right
DW $0000,$4400,$0037 ;quick morph during normal jump, right
DW $0080,$0000,$0019
DW $0000,$0900,$0069
DW $0000,$0500,$006B
DW $0000,$0190,$0069
DW $0000,$01A0,$006B
DW $0000,$0200,$002F
DW $0000,$0800,$0015
DW $0000,$0400,$0017
DW $0000,$0010,$0069
DW $0000,$0020,$006B
DW $0000,$0100,$0051
DW $0000,$00C0,$0013
DW $0000,$0080,$004D
DW $0000,$0040,$0013
DW $FFFF

T16:
T4E:
T52:
T6A:
T6C:
DW $0000,$0420,$0038 ;quick morph during normal jump, right
DW $0000,$4400,$0038 ;quick morph during normal jump, left
DW $0080,$0000,$001A
DW $0000,$0A00,$006A
DW $0000,$0600,$006C
DW $0000,$0290,$006A
DW $0000,$02A0,$006C
DW $0000,$0100,$0030
DW $0000,$0800,$0016
DW $0000,$0400,$0018
DW $0000,$0010,$006A
DW $0000,$0020,$006C
DW $0000,$0200,$0052
DW $0000,$00C0,$0014
DW $0000,$0080,$004E
DW $0000,$0040,$0014
DW $FFFF

T17:
DW $0000,$4400,$0037 ;quick morph while aiming down/right
DW $0080,$0000,$0019
DW $0400,$0000,$0037
DW $0000,$0900,$0069
DW $0000,$0500,$006B
DW $0000,$0190,$0069
DW $0000,$01A0,$006B
DW $0000,$0200,$002F
DW $0000,$0800,$0015
DW $0000,$0400,$0017
DW $0000,$0010,$0069
DW $0000,$0020,$006B
DW $0000,$0100,$0051
DW $0000,$00C0,$0013
DW $0000,$0080,$0017
DW $0000,$0040,$0013
DW $FFFF

T18:
DW $0000,$4400,$0038 ;quick morph while aiming down/left
DW $0080,$0000,$001A
DW $0400,$0000,$0038
DW $0000,$0A00,$006A
DW $0000,$0600,$006C
DW $0000,$0290,$006A
DW $0000,$02A0,$006C
DW $0000,$0100,$0030
DW $0000,$0800,$0016
DW $0000,$0400,$0018
DW $0000,$0010,$006A
DW $0000,$0020,$006C
DW $0000,$0200,$0052
DW $0000,$00C0,$0014
DW $0000,$0080,$0018
DW $0000,$0040,$0014
DW $FFFF

T19:
DW $0040,$0000,$0013
DW $0000,$0840,$0015
DW $0000,$0440,$0017
DW $0000,$0050,$0069
DW $0000,$0060,$006B
DW $0000,$0180,$0019
DW $0000,$0800,$0015
DW $0000,$0010,$0069
DW $0000,$0020,$006B
;DW $0000,$4400,$0031 ;quick morph during spin jump, right
DW $0000,$0400,$0017
DW $0000,$0100,$0019
DW $0000,$0200,$001A
DW $FFFF

T1A:
DW $0040,$0000,$0014
DW $0000,$0840,$0016
DW $0000,$0440,$0018
DW $0000,$0050,$006A
DW $0000,$0060,$006C
DW $0000,$0280,$001A
DW $0000,$0800,$0016
DW $0000,$0010,$006A
DW $0000,$0020,$006C
;DW $0000,$4400,$0032 ;quick morph during spin jump, left
DW $0000,$0400,$0018
DW $0000,$0200,$001A
DW $0000,$0100,$0019
DW $FFFF

T1B:
DW $0040,$0000,$0013
DW $0000,$0840,$0015
DW $0000,$0440,$0017
;DW $0000,$4400,$0031 ;quick morph during space jump, right
DW $0000,$0050,$0069
DW $0000,$0060,$006B
DW $0000,$0180,$001B
DW $0000,$0800,$0015
DW $0000,$0010,$0069
DW $0000,$0020,$006B
DW $0000,$0400,$0017
DW $0000,$0100,$001B
DW $0000,$0200,$001C
DW $FFFF

T1C:
DW $0040,$0000,$0014
DW $0000,$0840,$0016
DW $0000,$0440,$0018
;DW $0000,$4400,$0032 ;quick morph during space jump, left
DW $0000,$0050,$006A
DW $0000,$0060,$006C
DW $0000,$0280,$001C
DW $0000,$0800,$0016
DW $0000,$0010,$006A
DW $0000,$0020,$006C
DW $0000,$0400,$0018
DW $0000,$0200,$001C
DW $0000,$0100,$001B
DW $FFFF

T1D:
T1E:
DW $0800,$0000,$003D
DW $0080,$8000,$0019 ;spinjump from morph without springball, facing right
DW $0080,$0000,$003D
T1F:
T41:
DW $0800,$0000,$003E
DW $0080,$8000,$001A ;spinjump from morph without springball, facing left
DW $0080,$0000,$003E
DW $0000,$0100,$001E
DW $0000,$0200,$001F
DW $FFFF

T20:
T21:
T22:
T23:
T24:
T2F:
;DW $0000,$0280,$0050 ;damage-boost
;DW $FFFF
T30:
;DW $0000,$0180,$004F ;damage-boost
;DW $FFFF
T33:
T34:
T35:
T36:
T37:
T38:
T39:
T3A:
T3B:
T3C:
T3D:
T3E:
T3F:
T40:
T42:
T43:
T44:
T47:
T48:
T4B:
;DW $0000,$0280,$004F ;damage-boost
;DW $FFFF
T4C:
;DW $0000,$0180,$004F ;damage-boost
;DW $FFFF
T55:
T56:
T57:
T58:
T59:
T5A:
T5B:
T5C:
T5D:
T5E:
T5F:
T60:
T61:
T62:
T63:
T64:
T65:
T66:
T87:
T88:
T8F:
T90:
T91:
T92:
T93:
T94:
T95:
T96:
T97:
T98:
T99:
T9A:
T9C:
T9D:
T9E:
T9F:
TA0:
TA1:
TA2:
TA3:
TA8:
TA9:
TAA:
TAB:
TAC:
TAD:
TAE:
TAF:
TB0:
TB1:
TB2:
TB3:
TB4:
TB5:
TB6:
TB7:
TB8:
TB9:
TC5:
TC6:
TC9:
TCA:
TCB:
TCC:
TCD:
TCE:
TD3:
TD4:
TD5:
TD6:
TD7:
TD8:
TD9:
TDA:
TDB:
TDC:
TDD:
TDE:
TE8:
TE9:
TEA:
TEB:
TF1:
TF2:
TF3:
TF4:
TF5:
TF6:
TF7:
TF8:
TF9:
TFA:
TFB:
TFC:
	DW $FFFF

T25:
;DW $0000,$0280,$001A ;1A to 50 for damage-boost
DW $0080,$0000,$004C
DW $0000,$0200,$0025
DW $FFFF

T26:
;DW $0000,$0180,$0019 ;19 to 4F for damage boost
DW $0080,$0000,$004B
DW $0000,$0100,$0026
DW $FFFF

T27:
T71:
T73:
T85:
DW $0800,$0030,$00F7
DW $0800,$0010,$00F9
DW $0800,$0020,$00FB
DW $0800,$0000,$003B
DW $0200,$0000,$0043
DW $0000,$8080,$0050 ;damage boost from crouch
DW $0400,$0000,$0037
DW $0080,$0000,$004B
DW $0000,$0030,$0085
DW $0000,$0100,$0001
DW $0000,$0010,$0071
DW $0000,$0020,$0073
DW $FFFF

T28:
T72:
T74:
T86:
DW $0800,$0030,$00F8
DW $0800,$0010,$00FA
DW $0800,$0020,$00FC
DW $0800,$0000,$003C
DW $0100,$0000,$0044
DW $0400,$0000,$0038
DW $0000,$8080,$004F ;damage boost from crouch
DW $0080,$0000,$004C
DW $0000,$0030,$0086
DW $0000,$0200,$0002
DW $0000,$0010,$0072
DW $0000,$0020,$0074
DW $FFFF

T29:
T2B:
T6D:
T6F:
DW $0000,$0420,$0037 ;quick morph while facing right
DW $0000,$4400,$0037 ;quick morph during fall, right
DW $0080,$0000,$0019
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0200,$0087
DW $0000,$0800,$002B
DW $0000,$0400,$002D
DW $0000,$0010,$006D
DW $0000,$0020,$006F
DW $0000,$0040,$0067
DW $0000,$0080,$0019 ;0029 = 0019 for spinfall
DW $0000,$8100,$0029 ;0029 = 0019 for spinfall
DW $FFFF

T2A:
T2C:
T6E:
T70:
DW $0000,$0420,$0038 ;quick morph while facing left
DW $0000,$4400,$0038 ;quick morph during fall, left
DW $0080,$0000,$001A
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0100,$0088
DW $0000,$0800,$002C
DW $0000,$0400,$002E
DW $0000,$0010,$006E
DW $0000,$0020,$0070
DW $0000,$0040,$0068
DW $0000,$0080,$001A ;002A = 001A for spinfall
DW $0000,$8200,$002A ;002A = 001A for spinfall
DW $FFFF

T2D:
DW $0080,$0000,$0019
DW $0400,$0000,$0037
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0400,$002D
DW $0000,$0200,$0087
DW $0000,$0010,$006D
DW $0000,$0020,$006F
DW $0000,$0040,$0067
DW $0000,$0100,$0029
DW $FFFF

T2E:
DW $0080,$0000,$001A
DW $0400,$0000,$0038
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0400,$002E
DW $0000,$0100,$0088
DW $0000,$0010,$006E
DW $0000,$0020,$0070
DW $0000,$0040,$0068
DW $0000,$0200,$002A
DW $FFFF

T31:
DW $0800,$0000,$003D
DW $0080,$0000,$003D
T32:
DW $0800,$0000,$003E
DW $0080,$0000,$003E
DW $0000,$0100,$0031
DW $0000,$0200,$0032
DW $FFFF

T45:
DW $0000,$0240,$0045
DW $0000,$0100,$0009
DW $0000,$0200,$0025
DW $FFFF

T46:
DW $0000,$0140,$0046
DW $0000,$0200,$000A
DW $0000,$0100,$0026
DW $FFFF

T49:
T75:
T77:
DW $0400,$0000,$0036
DW $0080,$0000,$00C0
DW $0000,$0160,$0077
DW $0000,$0150,$0075
DW $0000,$0140,$0049
DW $0000,$0200,$000A
DW $0000,$0100,$0026
DW $FFFF

T4A:
T76:
T78:
DW $0400,$0000,$0035
DW $0080,$0000,$00BF
DW $0000,$0250,$0076
DW $0000,$0260,$0078
DW $0000,$0240,$004A
DW $0000,$0100,$0009
DW $0000,$0200,$0025
DW $FFFF

T4F:
DW $0000,$0280,$0052
DW $0000,$0080,$004F ;changed from 0180 to 0080
;DW $0000,$0080,$004E
DW $FFFF

T50:
DW $0000,$0180,$0051 ;changed from 0280 to 0080
DW $0000,$0080,$0050
;DW $0000,$0080,$004D
DW $FFFF

T53:
DW $0000,$0280,$0050
DW $FFFF

T54:
DW $0000,$0180,$004F
DW $FFFF

T67:
DW $0000,$4400,$0037 ;quick morph during fall after firing a shot, right
DW $0080,$0000,$0019
DW $0000,$0900,$006D
DW $0000,$0500,$006F
DW $0000,$0800,$002B
DW $0000,$0400,$002D
DW $0000,$0200,$0087
DW $0000,$0010,$006D
DW $0000,$0020,$006F
DW $0000,$0040,$0067
DW $0000,$0100,$0067
DW $FFFF

T68:
DW $0000,$4400,$0038 ;quick morph during fall after firing a shot, left
DW $0080,$0000,$001A
DW $0000,$0A00,$006E
DW $0000,$0600,$0070
DW $0000,$0800,$002C
DW $0000,$0400,$002E
DW $0000,$0100,$0088
DW $0000,$0010,$006E
DW $0000,$0020,$0070
DW $0000,$0040,$0068
DW $0000,$0200,$0068
DW $FFFF

T79:
T7B:
DW $0800,$0000,$003D
DW $0080,$0000,$007F
T7A:
T7C:
DW $0800,$0000,$003E
DW $0080,$0000,$0080
DW $0000,$0100,$007B
DW $0000,$0200,$007C
DW $FFFF

T7D:
DW $0800,$0000,$003D
T7E:
DW $0800,$0000,$003E
DW $0000,$0100,$007D
DW $0000,$0200,$007E
DW $FFFF

T7F:
DW $0800,$0000,$003D
T80:
DW $0800,$0000,$003E
DW $0000,$0100,$007F
DW $0000,$0200,$0080
DW $FFFF

T81:
DW $0040,$0000,$0013
DW $0000,$0840,$0015
DW $0000,$0440,$0017
;DW $0000,$4400,$0031 ;quick morph during screw attack, right
DW $0000,$0050,$0069
DW $0000,$0060,$006B
DW $0000,$0180,$0081
DW $0000,$0800,$0015
DW $0000,$0010,$0069
DW $0000,$0020,$006B
DW $0000,$0400,$0017
DW $0000,$0100,$0081
DW $0000,$0200,$0082
DW $FFFF

T82:
DW $0040,$0000,$0014
DW $0000,$0840,$0016
DW $0000,$0440,$0018
;DW $0000,$4400,$0032 ;quick morph during screw attack, left
DW $0000,$0050,$006A
DW $0000,$0060,$006C
DW $0000,$0280,$0082
DW $0000,$0800,$0016
DW $0000,$0010,$006A
DW $0000,$0020,$006C
DW $0000,$0400,$0018
DW $0000,$0200,$0082
DW $0000,$0100,$0081
DW $FFFF

T83:
DW $0400,$0000,$0037 ;quick morph during wall jump, right
DW $0400,$0000,$0019
DW $0000,$0200,$001A
DW $0000,$0010,$0069
DW $0000,$0020,$006B
DW $0000,$0040,$0013
DW $0000,$0080,$0083
DW $FFFF

T84:
DW $0400,$0000,$0038 ;quick morph during wall jump, left
DW $0400,$0000,$0018
DW $0000,$0100,$0019
DW $0000,$0010,$006A
DW $0000,$0020,$006C
DW $0000,$0040,$0014
DW $0000,$0080,$0084
DW $FFFF

T89:
TCF:
TD1:
DW $0000,$4400,$0037 ;quick morph while facing right
DW $0080,$8000,$0019
DW $0080,$0000,$004B
DW $0000,$0900,$000F
DW $0000,$0500,$0011
DW $0400,$0000,$0035
DW $0000,$0220,$0078
DW $0000,$0210,$0076
DW $0000,$0800,$0003
DW $0000,$0010,$0005
DW $0000,$0020,$0007
DW $0000,$0200,$0025
DW $0000,$0100,$0009
DW $FFFF

T8A:
TD0:
TD2:
DW $0000,$4400,$0038 ;quick morph while facing left
DW $0080,$8000,$001A
DW $0080,$0000,$004C
DW $0000,$0A00,$0010
DW $0000,$0600,$0012
DW $0400,$0000,$0036
DW $0000,$0120,$0077
DW $0000,$0110,$0075
DW $0000,$0800,$0004
DW $0000,$0010,$0006
DW $0000,$0020,$0008
DW $0000,$0100,$0026
DW $0000,$0200,$000A
DW $FFFF

T8B:
T8D:
TBF:
TC1:
TC3:
DW $0080,$0200,$001A
DW $0080,$0000,$004C
DW $FFFF

T8C:
T8E:
TC0:
TC2:
TC4:
DW $0080,$0100,$0019
DW $0080,$0000,$004B
DW $FFFF

TBA:
TBB:
TBC:
TBD:
TBE:
DW $0000,$0A40,$00BB
DW $0000,$0640,$00BD
DW $0000,$0240,$00BC
DW $0000,$0010,$00BB
DW $0000,$0020,$00BD
DW $0000,$0040,$00BC
DW $0000,$0200,$00BE
DW $0000,$0100,$00BE
DW $0000,$0800,$00BE
DW $0000,$0400,$00BE
DW $FFFF

TC7:
DW $0200,$0000,$00CA
DW $0000,$0880,$00CB
DW $0000,$0010,$00CD
DW $0000,$0100,$00C9
DW $FFFF

TC8:
DW $0100,$0000,$00C9
DW $0000,$0880,$00CC
DW $0000,$0010,$00CE
DW $0000,$0200,$00CA
DW $FFFF

TDF:
DW $0800,$0000,$00DE
DW $FFFF

TEC:
TED:
TEE:
TEF:
TF0:
DW $0000,$0940,$00ED
DW $0000,$0540,$00EF
DW $0000,$0140,$00EE
DW $0000,$0010,$00ED
DW $0000,$0020,$00EF
DW $0000,$0040,$00EE
DW $0000,$0200,$00F0
DW $0000,$0100,$00F0
DW $0000,$0800,$00F0
DW $0000,$0400,$00F0
DW $FFFF

org $91FC99	
	JSL $90F63A
	RTS
