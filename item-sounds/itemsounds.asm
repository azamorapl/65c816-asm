;Removes all item sound clips, and replaces them with sound FX that don't interupt the BG music (you can still play the usual sound clip if you wish)

;Uses free space from $26FD3 to $27023 ($51/81 bytes)
;Made by Sadiztyk Fish

lorom

;--------------------------------SOUNDFX VALUES----------------------------------

!None = $02			;Stops current sounds (use for no sound)
!Missile = $03			;Sound when firing a missile
!Super = $04			;Sound when firing a super missile
!Power = $01			;Sound when a powerbomb explodes
!Click = $37			;Sound when selecting a HUD item
!SpazerShield = $26		;Spazer Shield sound
!PlasmaShield = $27		;Plasma Shield sound
!WaveShield = $28		;Wave Shield sound (doesn't stop)
!IceShield = $24		;Ice Shield sound
!Grapple = $05			;Grapple fire sound
!Crumble = $3D			;Crumble block sound
!Toggle = $38			;Sound when you toggle on/off items on status screen
!Helmet = $2A			;Sound when you select a save
!Flip = $2F			;Sound when you spin underwater
!Save = $2E			;Clip when you save the game
!Hurt = $35			;Samus hurt sound

;--------------------------------SPECIALFX VALUES--------------------------------

!Energy = $01			;Sound when picking up dropped energy
!Refill = $05			;Sound when picking up dropped missiles/bombs
!Bomb = $07			;Regular Bomb explosion
!Enemy = $09			;Enemy vaporising sound (when they die)
!Screw = $0B			;Enemy explode sound (from Screw Attack)
!Splash = $0D			;Water splash, or possibly an enemy sound?
!Bubble = $0F			;A bubble sound (from lava or being underwater)
!Beep = $16			;A weird beep. I don't recognise it
!Hum = $18			;Humming of the ship
!Statue = $19			;Releasing the Statue Spirits
!Quake = $1B			;Earthquake rumble
!Chozo = $1C			;I *think* it's when the Chozo grabs you, but not sure
!Dachora = $1D			;The bird is the word =P
!Skree = $21			;Skreeeee
!Explode = $25			;Some kind of explosion, but I can't think what. Sounds cool anyway
!Laser = $26			;A fucking awesome laser sound =D Possibly from MB
!Suit = $56			;Sound when you 'don a suit' =P

;Many more values for enemy sounds. Some are song-dependent

;--------------------------------MISCFX VALUES--------------------------------

!Land = $04			;Landing sound
!DoorO = $07			;A door opening
!DoorC = $08			;A door closing
!ShipO = $14			;Ship hatch opening
!ShipC = $15			;Ship hatch closing
!CeresO = $2C			;Ceres hatch opening
!Buzz = $09			;A cool buzz. Might be related to Grapple?
!Freeze = $0A			;enemy is frozen
!Text = $0D			;Text sound from the intro
!Gate = $0E			;A gate moving
!Spark = $0F			;Shinespark sound
!ExplodeA = $10			;Another explosion sound
!Lava = $11			;Sound of rising lava
!WTF = $16			;Sounds like a gunshot?
!Pirate = $17			;Pirate laser?
!LaserA = $1C			;A short laser
!Fire = $1D			;Sounds like a Norfair fire explosion thing
!Spin = $21			;Single spin jump sound
!BubbleA = $22			;3 bubbles
!Acid = $2D			;Hurt by acid/lava

;30+ Nothing or crash from what I checked. There were also some that sounded song-dependent

;--------------------------------ITEM SOUNDS-----------------------------------

;For each item, you just need to specify which type of sound, followed by which effect. Some are done as an example, so it should be easy to figure out.
;If you want to play the normal sound clip for an item, put "DW NORMAL *newline* DB $02" (or leave it black if you haven't already changed it)

org $84E0B3			;Energy Tank
	DW SPECIALFX	;Load sound from SPECIALFX
	DB !Enemy	;Run the "energy" sound
org $84E0D8			;Missile
	DW SPECIALFX	;Load sound from SOUNDFX
	DB !Enemy	;Run the "click" sound
org $84E0FD			;Super Missile
	DW SPECIALFX
	DB !Enemy
org $84E122			;Powerbomb
	DW SPECIALFX
	DB !Enemy
org $84E43F			;Reserve Tank
	DW SPECIALFX
	DB !Enemy
org $84E46F			;Chozo Energy Tank
	DW SPECIALFX
	DB !Enemy
org $84E4A1			;Chozo Missile
	DW SPECIALFX
	DB !Enemy
org $84E4D3			;Chozo Super Missile
	DW SPECIALFX
	DB !Enemy
org $84E505			;Chozo Powerbomb
	DW SPECIALFX
	DB !Enemy
org $84E904			;Chozo Reserve Tank
	DW SPECIALFX
	DB !Enemy
org $84E93A			;Scenery Energy Tank
	DW SPECIALFX
	DB !Enemy
org $84E972			;Scenery Missile
	DW SPECIALFX
	DB !Enemy
org $84E9AA			;Scenery Super Missile
	DW SPECIALFX
	DB !Enemy
org $84E9E2			;Scenery Powerbomb
	DL SPECIALFX
	DB !Enemy
org $84EE3E			;Scenery Reserve Tank
	DW SPECIALFX
	DB !Enemy

;-------------------------DON'T EDIT THIS STUFF--------------------------

org $858491
	DW #$0020
org $82E126
	JSL CLIPCHECK
	BRA $08
org $858089
	BRA $02
org $848BF2
NORMAL:
	JSR CLIPSET

org $84EFD3			;You can safely change this address to free space in bank $84 ($20000-$27FFF)
CLIPCHECK:
	LDA $05D7
	CMP #$0002
	BEQ $0E
	LDA #$0000
	JSL $808FF7
	LDA $07F5
	JSL $808FC1
	LDA #$0000
	STA $05D7
	RTL
CLIPSET:
	LDA #$0001
	STA $05D7
	JSL $82BE17
	LDA #$0000
	RTS
SOUNDFX:
	JSR SETFX
	AND #$00FF
	JSL $809049
	RTS
SPECIALFX:
	JSR SETFX
	JSL $8090CB
	RTS
MISCFX:
	JSR SETFX
	JSL $80914D
	RTS
SETFX:
	LDA #$0002
	STA $05D7
	LDA $0000,y
	INY
	RTS
