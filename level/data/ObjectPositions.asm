
; --------------------------------------------------------------------------------------
; Offset index of object locations
; --------------------------------------------------------------------------------------
Off_Objects: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w  Objects_EHZ_1	; 0  $00
	zoneOffsetTableEntry.w  Objects_EHZ_2	; 1
	zoneOffsetTableEntry.w  Objects_Null	; 2  $01
	zoneOffsetTableEntry.w  Objects_Null	; 3
	zoneOffsetTableEntry.w  Objects_Null	; 4  $02
	zoneOffsetTableEntry.w  Objects_Null	; 5
	zoneOffsetTableEntry.w  Objects_Null	; 6  $03
	zoneOffsetTableEntry.w  Objects_Null	; 7
	zoneOffsetTableEntry.w  Objects_MTZ_1	; 8  $04
	zoneOffsetTableEntry.w  Objects_MTZ_2	; 9
	zoneOffsetTableEntry.w  Objects_MTZ_3	; 10 $05
	zoneOffsetTableEntry.w  Objects_MTZ_3	; 11
	zoneOffsetTableEntry.w  Objects_WFZ_1	; 12 $06
	zoneOffsetTableEntry.w  Objects_WFZ_2	; 13
	zoneOffsetTableEntry.w  Objects_HTZ_1	; 14 $07
	zoneOffsetTableEntry.w  Objects_HTZ_2	; 15
	zoneOffsetTableEntry.w  Objects_HPZ_1	; 16 $08
	zoneOffsetTableEntry.w  Objects_HPZ_2	; 17
	zoneOffsetTableEntry.w  Objects_Null	; 18 $09
	zoneOffsetTableEntry.w  Objects_Null	; 19
	zoneOffsetTableEntry.w  Objects_OOZ_1	; 20 $0A
	zoneOffsetTableEntry.w  Objects_OOZ_2	; 21
	zoneOffsetTableEntry.w  Objects_MCZ_1	; 22 $0B
	zoneOffsetTableEntry.w  Objects_MCZ_2	; 23
	zoneOffsetTableEntry.w  Objects_CNZ_1	; 24 $0C
	zoneOffsetTableEntry.w  Objects_CNZ_2	; 25
	zoneOffsetTableEntry.w  Objects_CPZ_1	; 26 $0D
	zoneOffsetTableEntry.w  Objects_CPZ_2	; 27
	zoneOffsetTableEntry.w  Objects_DEZ_1	; 28 $0E
	zoneOffsetTableEntry.w  Objects_DEZ_2	; 29
	zoneOffsetTableEntry.w  Objects_ARZ_1	; 30 $0F
	zoneOffsetTableEntry.w  Objects_ARZ_2	; 31
	zoneOffsetTableEntry.w  Objects_SCZ_1	; 32 $10
	zoneOffsetTableEntry.w  Objects_SCZ_2	; 33
    zoneTableEnd
;---------------------------------------------------------------------------------------
; CNZ object layouts for 2-player mode (various objects were deleted)
;---------------------------------------------------------------------------------------

; Macro for marking the boundaries of an object layout file
ObjectLayoutBoundary macro
	dc.w	$FFFF, $0000, $0000
    endm

	; [Bug] Sonic Team forgot to put a boundary marker here,
	; meaning the game could potentially read past the start
	; of the file and load random objects.
	;ObjectLayoutBoundary

    ; a Crawl badnik was moved slightly further away from a ledge
    ; 2 flippers were moved closer to a wall
Objects_CNZ1_2P:	BINCLUDE	"level/object_pos/CNZ_1_2P.bin"
    even
	ObjectLayoutBoundary
    ; 4 Crawl badniks were slightly moved, placing them closer/farther away from ledges
    ; 2 flippers were moved away from a wall to keep players from getting stuck behind them
Objects_CNZ2_2P:	BINCLUDE	"level/object_pos/CNZ_2_2P.bin"
    even
	ObjectLayoutBoundary

	; These things act as boundaries for the object layout parser, so it doesn't read past the end/beginning of the file
	ObjectLayoutBoundary
Objects_EHZ_1:	BINCLUDE	"level/object_pos/EHZ_1.bin"
	ObjectLayoutBoundary
Objects_EHZ_2:	BINCLUDE	"level/object_pos/EHZ_2.bin"
	ObjectLayoutBoundary
Objects_MTZ_1:	BINCLUDE	"level/object_pos/MTZ_1.bin"
	ObjectLayoutBoundary
Objects_MTZ_2:	BINCLUDE	"level/object_pos/MTZ_2.bin"
	ObjectLayoutBoundary
Objects_MTZ_3:	BINCLUDE	"level/object_pos/MTZ_3.bin"
	ObjectLayoutBoundary
Objects_WFZ_1:	BINCLUDE	"level/object_pos/WFZ_1.bin"
	ObjectLayoutBoundary
Objects_WFZ_2:	BINCLUDE	"level/object_pos/WFZ_2.bin"
	ObjectLayoutBoundary
Objects_HTZ_1:	BINCLUDE	"level/object_pos/HTZ_1.bin"
	ObjectLayoutBoundary
Objects_HTZ_2:	BINCLUDE	"level/object_pos/HTZ_2.bin"
	ObjectLayoutBoundary
Objects_HPZ_1:	BINCLUDE	"level/object_pos/HPZ_1.bin"
	ObjectLayoutBoundary
Objects_HPZ_2:	BINCLUDE	"level/object_pos/HPZ_2.bin"
	ObjectLayoutBoundary
	; Oddly, there's a gap for another layout here
	ObjectLayoutBoundary
Objects_OOZ_1:	BINCLUDE	"level/object_pos/OOZ_1.bin"
	ObjectLayoutBoundary
Objects_OOZ_2:	BINCLUDE	"level/object_pos/OOZ_2.bin"
	ObjectLayoutBoundary
Objects_MCZ_1:	BINCLUDE	"level/object_pos/MCZ_1.bin"
	ObjectLayoutBoundary
Objects_MCZ_2:	BINCLUDE	"level/object_pos/MCZ_2.bin"
	ObjectLayoutBoundary
Objects_CNZ_1:	BINCLUDE	"level/object_pos/CNZ_1.bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"level/object_pos/CNZ_2.bin"
	ObjectLayoutBoundary
Objects_CPZ_1:	BINCLUDE	"level/object_pos/CPZ_1.bin"
	ObjectLayoutBoundary
Objects_CPZ_2:	BINCLUDE	"level/object_pos/CPZ_2.bin"
	ObjectLayoutBoundary
Objects_DEZ_1:	BINCLUDE	"level/object_pos/DEZ_1.bin"
	ObjectLayoutBoundary
Objects_DEZ_2:	BINCLUDE	"level/object_pos/DEZ_2.bin"
	ObjectLayoutBoundary
Objects_ARZ_1:	BINCLUDE	"level/object_pos/ARZ_1.bin"
	ObjectLayoutBoundary
Objects_ARZ_2:	BINCLUDE	"level/object_pos/ARZ_2.bin"
	ObjectLayoutBoundary
Objects_SCZ_1:	BINCLUDE	"level/object_pos/SCZ_1.bin"
	ObjectLayoutBoundary
Objects_SCZ_2:	BINCLUDE	"level/object_pos/SCZ_2.bin"
	ObjectLayoutBoundary

Objects_Null:
	ObjectLayoutBoundary
	; Another strange space for a layout
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
	even
