


; ===========================================================================
; ----------------------------------------------------------------------------
; Object A4 - Asteron (exploding starfish badnik) from MTZ
; ----------------------------------------------------------------------------
; Sprite_3899C:
ObjA4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA4_Index(pc,d0.w),d1
	jmp	ObjA4_Index(pc,d1.w)
; ===========================================================================
; off_389AA:
ObjA4_Index:	offsetTable
		offsetTableEntry.w ObjA4_Init	; 0
		offsetTableEntry.w loc_389B6	; 2
		offsetTableEntry.w loc_389DA	; 4
		offsetTableEntry.w loc_38A2C	; 6
; ===========================================================================
; BranchTo3_LoadSubObject
ObjA4_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_389B6:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	bhs.s	BranchTo6_JmpTo39_MarkObjGone
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	blo.s	loc_389D2

BranchTo6_JmpTo39_MarkObjGone
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_389D2:
	addq.b	#2,routine(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_389DA:
	bsr.w	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$10,d2
	blo.s	loc_389FA
	cmpi.w	#$60,d2
	bhs.s	loc_389FA
	move.w	word_38A1A(pc,d0.w),x_vel(a0)
	bsr.w	loc_38A1E

loc_389FA:
	abs.w	d3
	cmpi.w	#$10,d3
	blo.s	BranchTo7_JmpTo39_MarkObjGone
	cmpi.w	#$60,d3
	bhs.s	BranchTo7_JmpTo39_MarkObjGone
	move.w	word_38A1A(pc,d1.w),y_vel(a0)
	bsr.w	loc_38A1E

BranchTo7_JmpTo39_MarkObjGone
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
word_38A1A:
	dc.w  -$40	; 0
	dc.w   $40	; 1
; ===========================================================================

loc_38A1E:
	move.b	#6,routine(a0)
	move.b	#$40,objoff_2E(a0)
	rts
; ===========================================================================

loc_38A2C:
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_38A44
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	lea	(Ani_objA4).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_38A44:
        move.l	#Exploation_High_Priority,(a0) ; DeleteMain
	move.b	#0,routine(a0)  ; no points and animal
	bsr.w	loc_38A58
	jmp	(MarkObjGone).l
; ===========================================================================

loc_38A58:
	move.b	#$30,d2
	moveq	#4,d6
	lea	(word_38A68).l,a2
	jmp	Obj_CreateProjectiles
; ===========================================================================
word_38A68:
	dc.w $F8
	dc.w $FC
	dc.w $200
	dc.w $8FC
	dc.w $3FF
	dc.w $301
	dc.w $808
	dc.w $303
	dc.w $401
	dc.w $F808
	dc.w $FD03
	dc.w $400
	dc.w $F8FC
	dc.w $FDFF
	dc.w $300
	even
; off_38A86:
ObjA4_SubObjData:
	subObjData ObjA4_Obj98_MapUnc_38A96,make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1),4,4,$10,$B
; animation script
; off_38A90:
Ani_objA4:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjA4_Obj98_MapUnc_38A96:	BINCLUDE "mappings/sprite/objA4.bin"
                    even
