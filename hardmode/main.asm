LoRom

!DifficultyAddress = $7ED8F0 ;sram that stores difficulty used by game.
!PlaceholderAddress = $7ED8F2 ;sram that stores difficulty, only for the main menu.
!TempAddress = $7ED452 ;ram where some temporary values are stored.
!HardEventFlag = #$00F0 ;event flag that indicates hard mode is activated.
!EnergyPerTankAddress = $84E0B8 ;amount of energy given by an e-tank.
!StartingEnergyAddress = $81B2CE ;amount of energy samus has when starting a new game.

{; Basic functionality, required by other files. =================
incsrc asm\80-84-8B-core.asm
}

{; Scale values according to difficulty. =================
incsrc asm\A0-armor-damage.asm
incsrc asm\86-drop-refill.asm
incsrc asm\84-expansion.asm
incsrc asm\8B-ending-calculation.asm
incsrc asm\80-countdown-timer.asm
}

{; UI tweaks, these probably have more chance of conflict. =================
incsrc asm\80-ui-hud.asm
incsrc asm\81-ui-file-select.asm
incsrc asm\82-ui-status-screen.asm
incsrc asm\82-97-ui-settings-tilemaps.asm
}

{; Sample edits. Changes are too numerous, so it's only safe to apply on vanilla ROM. =================
incsrc asm\sample\vanilla-adjustments.asm
incsrc asm\sample\enemy-behavior.asm
incsrc asm\sample\rooms.asm
}