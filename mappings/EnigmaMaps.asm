;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "SEGA" mappings		; MapEng_74D0E:
	even
MapEng_SEGA:	BINCLUDE	"mappings/misc/SEGA mappings.bin"
;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; Mappings for title screen background	; ArtNem_74DC6:
	even
MapEng_TitleScreen:	BINCLUDE	"mappings/misc/Mappings for title screen background.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed art mappings
; Mappings for title screen background (smaller part, water/horizon)	; MapEng_74E3A:
	even
MapEng_TitleBack:	BINCLUDE	"mappings/misc/Mappings for title screen background 2.bin"
;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "Sonic the Hedgehog 2" title screen logo mappings	; MapEng_74E86:
	even
MapEng_TitleLogo:	BINCLUDE	"mappings/misc/Sonic the Hedgehog 2 title screen logo mappings.bin"
;---------------------------------------------------------------------------------------
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 1 of end of game sequence	; MapEng_906E0:
	even
MapEng_Ending1:	BINCLUDE	"mappings/misc/End of game sequence frame 1.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 2 of end of game sequence	; MapEng_906F8:
	even
MapEng_Ending2:	BINCLUDE	"mappings/misc/End of game sequence frame 2.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 3 of end of game sequence	; MapEng_90722:
	even
MapEng_Ending3:	BINCLUDE	"mappings/misc/End of game sequence frame 3.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 4 of end of game sequence	; MapEng_9073C:
	even
MapEng_Ending4:	BINCLUDE	"mappings/misc/End of game sequence frame 4.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Closeup of Tails flying plane in ending sequence	; MapEng_9076E:
	even
MapEng_EndingTailsPlane:	BINCLUDE	"mappings/misc/Closeup of Tails flying plane in ending sequence.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Closeup of Sonic flying plane in ending sequence	; MapEng_907C0:
	even
MapEng_EndingSonicPlane:	BINCLUDE	"mappings/misc/Closeup of Sonic flying plane in ending sequence.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (duplicate of MapEng_EndGameLogo)
	even
; MapEng_9082A:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 1.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_90852:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 2.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_9087A:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 3.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_908A2:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 4.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_908CA:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 5.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_908F2:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 6.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_9091A:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 7.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_90942:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 8.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_9096A:
	BINCLUDE	"mappings/misc/Strange unused mappings 2.bin"
;--------------------------------------------------------------------------------------
;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; Sonic/Miles animated background mappings	; MapEng_7CB80:
	even
MapEng_MenuBack:	BINCLUDE	"mappings/misc/Sonic and Miles animated background.bin"
	even
; --------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "Sonic the Hedgehog 2" mappings		; MapEng_B23A:
	even
MapEng_EndGameLogo:	BINCLUDE	"mappings/misc/Sonic 2 end of game logo.bin"
	even

; 2P single act results screen (enigma compressed)
; byte_8804:
Map_2PActResults:	BINCLUDE "mappings/misc/2P Act Results.bin"
                    even
; 2P zone results screen (enigma compressed)
; byte_88CE:
Map_2PZoneResults:	BINCLUDE "mappings/misc/2P Zone Results.bin"
                        even
; 2P game results screen (after all 4 zones) (enigma compressed)
; byte_8960:
Map_2PGameResults:	BINCLUDE "mappings/misc/2P Game Results.bin"
                      even
; 2P special stage act results screen (enigma compressed)
; byte_8AA4:
Map_2PSpecialStageActResults:	BINCLUDE "mappings/misc/2P Special Stage Act Results.bin"
                        even
; 2P special stage zone results screen (enigma compressed)
; byte_8B30:
Map_2PSpecialStageZoneResults:	BINCLUDE "mappings/misc/2P Special Stage Zone Results.bin"
	even
; level select picture palettes
; byte_9880:
Pal_LevelIcons:	BINCLUDE "art/palettes/Level Select Icons.bin"
           even
; 2-player level select screen mappings (Enigma compressed)
; byte_9A60:
	even
MapEng_LevSel2P:	BINCLUDE "mappings/misc/Level Select 2P.bin"

; options screen mappings (Enigma compressed)
; byte_9AB2:
	even
MapEng_Options:	BINCLUDE "mappings/misc/Options Screen.bin"

; level select screen mappings (Enigma compressed) (Kept for borders and the emblem exclusivley)
; byte_9ADE:
	even
MapEng_LevSel:	BINCLUDE "mappings/misc/Level Select.bin"

; 1P and 2P level select icon mappings (Enigma compressed)
; byte_9C32:
	even
MapEng_LevSelIcon:	BINCLUDE "mappings/misc/Level Select Icons.bin"
	even
