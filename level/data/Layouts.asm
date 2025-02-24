;---------------------------------------------------------------------------------------
; Offset index of level layouts
; Two entries per zone, pointing to the level layouts for acts 1 and 2 of each zone
; respectively.
;---------------------------------------------------------------------------------------
Off_Level: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w Level_EHZ1
	zoneOffsetTableEntry.w Level_EHZ2	; 1
	zoneOffsetTableEntry.w Level_EHZ1	; 2
	zoneOffsetTableEntry.w Level_EHZ1	; 3
	zoneOffsetTableEntry.w Level_EHZ1	; 4
	zoneOffsetTableEntry.w Level_EHZ1	; 5
	zoneOffsetTableEntry.w Level_EHZ1	; 6
	zoneOffsetTableEntry.w Level_EHZ1	; 7
	zoneOffsetTableEntry.w Level_MTZ1	; 8
	zoneOffsetTableEntry.w Level_MTZ2	; 9
	zoneOffsetTableEntry.w Level_MTZ3	; 10
	zoneOffsetTableEntry.w Level_MTZ3	; 11
	zoneOffsetTableEntry.w Level_WFZ	; 12
	zoneOffsetTableEntry.w Level_WFZ	; 13
	zoneOffsetTableEntry.w Level_HTZ1	; 14
	zoneOffsetTableEntry.w Level_HTZ2	; 15
	zoneOffsetTableEntry.w Level_HPZ1	; 16
	zoneOffsetTableEntry.w Level_HPZ1	; 17
	zoneOffsetTableEntry.w Level_EHZ1	; 18
	zoneOffsetTableEntry.w Level_EHZ1	; 19
	zoneOffsetTableEntry.w Level_OOZ1	; 20
	zoneOffsetTableEntry.w Level_OOZ2	; 21
	zoneOffsetTableEntry.w Level_MCZ1	; 22
	zoneOffsetTableEntry.w Level_MCZ2	; 23
	zoneOffsetTableEntry.w Level_CNZ1	; 24
	zoneOffsetTableEntry.w Level_CNZ2	; 25
	zoneOffsetTableEntry.w Level_CPZ1	; 26
	zoneOffsetTableEntry.w Level_CPZ2	; 27
	zoneOffsetTableEntry.w Level_DEZ	; 28
	zoneOffsetTableEntry.w Level_DEZ	; 29
	zoneOffsetTableEntry.w Level_ARZ1	; 30
	zoneOffsetTableEntry.w Level_ARZ2	; 31
	zoneOffsetTableEntry.w Level_SCZ	; 32
	zoneOffsetTableEntry.w Level_SCZ	; 33
    zoneTableEnd
;---------------------------------------------------------------------------------------
; EHZ act 1 level layout (Kosinski compression)
Level_EHZ1:	BINCLUDE	"level/layout/EHZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; EHZ act 2 level layout (Kosinski compression)
Level_EHZ2:	BINCLUDE	"level/layout/EHZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ act 1 level layout (Kosinski compression)
Level_MTZ1:	BINCLUDE	"level/layout/MTZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ act 2 level layout (Kosinski compression)
Level_MTZ2:	BINCLUDE	"level/layout/MTZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ act 3 level layout (Kosinski compression)
Level_MTZ3:	BINCLUDE	"level/layout/MTZ_3.bin"
	even
;---------------------------------------------------------------------------------------
; WFZ level layout (Kosinski compression)
Level_WFZ:	BINCLUDE	"level/layout/WFZ.bin"
	even
;---------------------------------------------------------------------------------------
; HTZ act 1 level layout (Kosinski compression)
Level_HTZ1:	BINCLUDE	"level/layout/HTZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; HTZ act 2 level layout (Kosinski compression)
Level_HTZ2:	BINCLUDE	"level/layout/HTZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; HPZ act 1 level layout (Kosinski compression)
Level_HPZ1:	;BINCLUDE	"level/layout/HPZ_1.bin"
	;even
;---------------------------------------------------------------------------------------
; OOZ act 1 level layout (Kosinski compression)
Level_OOZ1:	BINCLUDE	"level/layout/OOZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; OOZ act 2 level layout (Kosinski compression)
Level_OOZ2:	BINCLUDE	"level/layout/OOZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; MCZ act 1 level layout (Kosinski compression)
Level_MCZ1:	BINCLUDE	"level/layout/MCZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; MCZ act 2 level layout (Kosinski compression)
Level_MCZ2:	BINCLUDE	"level/layout/MCZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ act 1 level layout (Kosinski compression)
Level_CNZ1:	BINCLUDE	"level/layout/CNZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ act 2 level layout (Kosinski compression)
Level_CNZ2:	BINCLUDE	"level/layout/CNZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ act 1 level layout (Kosinski compression)
Level_CPZ1:	BINCLUDE	"level/layout/CPZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ act 2 level layout (Kosinski compression)
Level_CPZ2:	BINCLUDE	"level/layout/CPZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; DEZ level layout (Kosinski compression)
Level_DEZ:	BINCLUDE	"level/layout/DEZ.bin"
	even
;---------------------------------------------------------------------------------------
; ARZ act 1 level layout (Kosinski compression)
Level_ARZ1:	BINCLUDE	"level/layout/ARZ_1.bin"
	even

;---------------------------------------------------------------------------------------
; ARZ act 2 level layout (Kosinski compression)
Level_ARZ2:	BINCLUDE	"level/layout/ARZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; SCZ level layout (Kosinski compression)
Level_SCZ:	BINCLUDE	"level/layout/SCZ.bin"
	even
