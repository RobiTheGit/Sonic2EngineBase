; ===========================================================================
; --------------------------------------------------------------------------------------
; CHARACTER START LOCATION ARRAY

; 2 entries per act, corresponding to the X and Y locations that you want the player to
; appear at when the level starts.
; --------------------------------------------------------------------------------------
StartLocations: zoneOrderedTable 2,4	; WrdArr_StartLoc
	zoneTableBinEntry	2, "startpos/EHZ_1.bin"	; $00
	zoneTableBinEntry	2, "startpos/EHZ_2.bin"
	zoneTableEntry.w	$60,	$28F		; $01
	zoneTableEntry.w	$60,	$2AF
	zoneTableEntry.w	$60,	$1AC		; $02
	zoneTableEntry.w	$60,	$1AC
	zoneTableEntry.w	$60,	$28F		; $03
	zoneTableEntry.w	$60,	$2AF
	zoneTableBinEntry	2, "startpos/MTZ_1.bin"	; $04
	zoneTableBinEntry	2, "startpos/MTZ_2.bin"
	zoneTableBinEntry	2, "startpos/MTZ_3.bin"	; $05
	zoneTableEntry.w	$60,	$2AF
	zoneTableBinEntry	2, "startpos/WFZ.bin"	; $06
	zoneTableEntry.w	$1E0,	$4CC
	zoneTableBinEntry	2, "startpos/HTZ_1.bin"	; $07
	zoneTableBinEntry	2, "startpos/HTZ_2.bin"
	zoneTableEntry.w	$230,	$1AC		; $08
	zoneTableEntry.w	$230,	$1AC
	zoneTableEntry.w	$60,	$28F		; $09
	zoneTableEntry.w	$60,	$2AF
	zoneTableBinEntry	2, "startpos/OOZ_1.bin"	; $0A
	zoneTableBinEntry	2, "startpos/OOZ_2.bin"
	zoneTableBinEntry	2, "startpos/MCZ_1.bin"	; $0B
	zoneTableBinEntry	2, "startpos/MCZ_2.bin"
	zoneTableBinEntry	2, "startpos/CNZ_1.bin"	; $0C
	zoneTableBinEntry	2, "startpos/CNZ_2.bin"
	zoneTableBinEntry	2, "startpos/CPZ_1.bin"	; $0D
	zoneTableBinEntry	2, "startpos/CPZ_2.bin"
	zoneTableBinEntry	2, "startpos/DEZ.bin"	; $0E
	zoneTableEntry.w	$60,	$12D
	zoneTableBinEntry	2, "startpos/ARZ_1.bin"	; $0F
	zoneTableBinEntry	2, "startpos/ARZ_2.bin"
	zoneTableBinEntry	2, "startpos/SCZ.bin"	; $10
	zoneTableEntry.w	$140,	$70
    zoneTableEnd
