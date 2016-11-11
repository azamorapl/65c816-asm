LoRom

;enable demo
org $82EEBB
  DB $07
org $8B9F29
  DB $CE

;reduce demo1 timer
org $828774
  DW $91F8 : DW $896A : DW $0001 : DW $0400 : DW $0400 : DW $0040 : DW $0001 : DW $04C9 : DW $8925