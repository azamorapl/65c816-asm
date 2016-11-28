lorom


org $90B860		;how long charge beam must be held down to fire a beam

	DB $3C		;$3C

org $91D756		;charge beam timer check for samus palette to change

	DB $3C

org $86F057		;gets rid of the old hijack point

	LDA $0AF6

org $86EFE5 : JSR CHARGE

org $86F4AB
CHARGE:
	LDA $0CD0 : BEQ GTFO
	LDA $0AF6 : CMP $1A4B,x : BEQ NEXT : BMI UP : BPL DOWN : BRA GTFO

NEXT:
	LDA $1A93,x : CMP $0AFA : BEQ GTFO : BMI LEFT : BPL RIGHT
UP:
	DEC $1A4B,x : BRA NEXT
DOWN:
	INC $1A4B,x : BRA NEXT
LEFT:
	INC $1A93,x : BRA GTFO
RIGHT:
	DEC $1A93,x
GTFO:
	LDA $1B23,x : RTS
