; ===========================================================================
; ---------------------------------------------------------------------------
; Pointers to primary collision indexes

; Contains an array of pointers to the primary collision index data for each
; level. 1 pointer for each level, pointing the primary collision index.
; ---------------------------------------------------------------------------
Off_ColP:
	dc.l ColP_EHZHTZ
	dc.l ColP_Invalid	; 1
	dc.l ColP_MTZ	; 2
	dc.l ColP_Invalid	; 3
	dc.l ColP_MTZ	; 4
	dc.l ColP_MTZ	; 5
	dc.l ColP_WFZSCZ	; 6
	dc.l ColP_EHZHTZ	; 7
	dc.l ColP_HPZ	; 8
	dc.l ColP_Invalid	; 9
	dc.l ColP_OOZ	; 10
	dc.l ColP_MCZ	; 11
	dc.l ColP_CNZ	; 12
	dc.l ColP_CPZDEZ	; 13
	dc.l ColP_CPZDEZ	; 14
	dc.l ColP_ARZ	; 15
	dc.l ColP_WFZSCZ	; 16
        even

; ---------------------------------------------------------------------------
; Pointers to secondary collision indexes

; Contains an array of pointers to the secondary collision index data for
; each level. 1 pointer for each level, pointing the secondary collision
; index.
; ---------------------------------------------------------------------------
Off_ColS:
	dc.l ColS_EHZHTZ
	dc.l ColP_Invalid	; 1
	dc.l ColP_MTZ	; 2
	dc.l ColP_Invalid	; 3
	dc.l ColP_MTZ	; 4
	dc.l ColP_MTZ	; 5
	dc.l ColS_WFZSCZ	; 6
	dc.l ColS_EHZHTZ	; 7
	dc.l ColS_HPZ	; 8
	dc.l ColP_Invalid	; 9
	dc.l ColP_OOZ	; 10
	dc.l ColP_MCZ	; 11
	dc.l ColS_CNZ	; 12
	dc.l ColS_CPZDEZ	; 13
	dc.l ColS_CPZDEZ	; 14
	dc.l ColS_ARZ	; 15
	dc.l ColS_WFZSCZ	; 16
         even



;---------------------------------------------------------------------------------------
; Curve and resistance mapping
;---------------------------------------------------------------------------------------
ColCurveMap:	BINCLUDE	"collision/Curve and resistance mapping.bin"
	even
;--------------------------------------------------------------------------------------
; Collision arrays
;--------------------------------------------------------------------------------------
ColArray:	BINCLUDE	"collision/Collision array 1.bin"
       even
ColArray2:	BINCLUDE	"collision/Collision array 2.bin"
	even
;---------------------------------------------------------------------------------------
; EHZ and HTZ primary 16x16 collision index (Kosinski compression)
ColP_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; EHZ and HTZ secondary 16x16 collision index (Kosinski compression)
ColS_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ secondary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; MTZ primary 16x16 collision index (Kosinski compression)
ColP_MTZ:	BINCLUDE	"collision/MTZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; HPZ primary 16x16 collision index (Kosinski compression)
ColP_HPZ:	;BINCLUDE	"collision/HPZ primary 16x16 collision index.unc"
	;even
;---------------------------------------------------------------------------------------
; HPZ secondary 16x16 collision index (Kosinski compression)
ColS_HPZ:	;BINCLUDE	"collision/HPZ secondary 16x16 collision index.unc"
	;even
;---------------------------------------------------------------------------------------
; OOZ primary 16x16 collision index (Kosinski compression)
ColP_OOZ:	BINCLUDE	"collision/OOZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; MCZ primary 16x16 collision index (Kosinski compression)
ColP_MCZ:	BINCLUDE	"collision/MCZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; CNZ primary 16x16 collision index (Kosinski compression)
ColP_CNZ:	BINCLUDE	"collision/CNZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; CNZ secondary 16x16 collision index (Kosinski compression)
ColS_CNZ:	BINCLUDE	"collision/CNZ secondary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; CPZ and DEZ primary 16x16 collision index (Kosinski compression)
ColP_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; CPZ and DEZ secondary 16x16 collision index (Kosinski compression)
ColS_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ secondary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; ARZ primary 16x16 collision index (Kosinski compression)
ColP_ARZ:	BINCLUDE	"collision/ARZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; ARZ secondary 16x16 collision index (Kosinski compression)
ColS_ARZ:	BINCLUDE	"collision/ARZ secondary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; WFZ/SCZ primary 16x16 collision index (Kosinski compression)
ColP_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ primary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------
; WFZ/SCZ secondary 16x16 collision index (Kosinski compression)
ColS_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ secondary 16x16 collision index.unc"
	even
;---------------------------------------------------------------------------------------

ColP_Invalid:
	even
