EggmanParentStuff = parent3

; ===========================================================================
; ----------------------------------------------------------------------------
; Object C6 - Eggman
; ----------------------------------------------------------------------------
; Sprite_3CED0:
ObjC6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC6_Index(pc,d0.w),d1
	jmp	ObjC6_Index(pc,d1.w)
; ===========================================================================
; off_3CEDE: ObjC6_States:
ObjC6_Index:	offsetTable
		offsetTableEntry.w ObjC6_Init	; 0
		offsetTableEntry.w ObjC6_State2	; 2
		offsetTableEntry.w ObjC6_State3	; 4
		offsetTableEntry.w ObjC6_State4	; 6
; ===========================================================================
; loc_3CEE6:
ObjC6_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$A4,d0
	move.b	d0,routine(a0) ; => ObjC6_State2, ObjC6_State3, or ObjC6_State4 ??
	rts
; ===========================================================================
; loc_3CEF8:
ObjC6_State2:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC6_State2_States(pc,d0.w),d1
	jmp	ObjC6_State2_States(pc,d1.w)
; ===========================================================================
; off_3CF06:
ObjC6_State2_States: offsetTable
	offsetTableEntry.w ObjC6_State2_State1	; 0
	offsetTableEntry.w ObjC6_State2_State2	; 2
	offsetTableEntry.w ObjC6_State2_State3	; 4
	offsetTableEntry.w ObjC6_State2_State4	; 6
	offsetTableEntry.w ObjC6_State2_State5	; 8
; ===========================================================================
; loc_3CF10:
ObjC6_State2_State1: ; a1=object (set in loc_3D94C)
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State2
        jsr	(SingleObjLoad2).l
	bne.s	+	; rts
	move.w	a1,objoff_42(a0) ; store pointer to child in parent's SST
	move.l	(a0),(a1) ; load obj
	move.b	#$A8,subtype(a1)
	move.w	a0,objoff_30(a1) ; store pointer to parent in child's SST
	move.w	#$3F8,x_pos(a1)
	move.w	#$160,y_pos(a1)


	move.w	a0,(DEZ_Eggman).w
+
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF32:
ObjC6_State2_State2:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$5C,d2
	cmpi.w	#$B8,d2
	blo.s	loc_3CF44
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF44:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State3
	move.w	#$18,objoff_2E(a0)
	move.b	#1,mapping_frame(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF58:
ObjC6_State2_State3:
	subq.w	#1,objoff_2E(a0)
	bmi.s	loc_3CF62
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3CF62:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State4
	bset	#2,status(a0)
	move.w	#$200,x_vel(a0)
	move.w	#$10,objoff_2E(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CF7C:
ObjC6_State2_State4:
	cmpi.w	#$810,x_pos(a0)
	bhs.s	loc_3CFC0
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$50,d2
	cmpi.w	#$A0,d2
	bhs.s	+
	move.w	x_pos(a1),d0
	addi.w	#$50,d0
	move.w	d0,x_pos(a0)
+
	subq.w	#1,objoff_2E(a0)
	bpl.s	+
	move.w	#$20,objoff_2E(a0)
	bsr.w	loc_3D00C
+
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	lea	(Ani_objC5_objC6).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_3CFC0:
	move.b	#2,mapping_frame(a0)
	clr.w	x_vel(a0)
	tst.b	render_flags(a0)
	bpl.s	+
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State2_State5
	move.w	#$80,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#$50,objoff_2E(a0)
	bset	#3,status(a0)
+
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3CFF6:
ObjC6_State2_State5:
	subq.w	#1,objoff_2E(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_3D00C:
	lea	(word_3D0D4).l,a2
	bsr.w	LoadChildObject
	move.b	#$AA,subtype(a1) ; <== ObjC6_SubObjData
	move.b	#5,mapping_frame(a1)
	move.w	#-$100,x_vel(a1)
	subi.w	#$18,y_pos(a1)
	move.w	#8,objoff_2E(a1)
	rts
; ===========================================================================
; loc_3D036:
ObjC6_State3:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjC6_State3_States(pc,d0.w),d1
	jmp	ObjC6_State3_States(pc,d1.w)
; ===========================================================================
; off_3D044:
ObjC6_State3_States: offsetTable
	offsetTableEntry.w ObjC6_State3_State1	; 0
	offsetTableEntry.w ObjC6_State3_State2	; 2
	offsetTableEntry.w ObjC6_State3_State3	; 4
; ===========================================================================
; loc_3D04A:
ObjC6_State3_State1:
	movea.w	objoff_30(a0),a1 ; a1=object
	btst	#2,status(a1)
	bne.s	loc_3D05E
	bsr.w	loc_3D086
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
loc_3D05E:
	addq.b	#2,routine_secondary(a0) ; => ObjC6_State3_State2
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D066:
ObjC6_State3_State2:
	bsr.w	loc_3D086
	lea	(Ani_objC6).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3D078:
ObjC6_State3_State3:
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#5,status(a1)
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_3D086:
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	(sp)+,d4
	jmpto	(SolidObject).l, JmpTo27_SolidObject
; ===========================================================================
; loc_3D09C:
ObjC6_State4:
	subq.w	#1,objoff_2E(a0)
	bmi.w	JmpTo65_DeleteObject
	addi.w	#$10,y_vel(a0)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; off_3D0B2:
ObjC6_SubObjData3:
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,5,$18,0
; off_3D0BC:
ObjC6_SubObjData4:
	subObjData ObjC6_MapUnc_3D1DE,make_art_tile(ArtTile_ArtNem_ConstructionStripes_1,1,0),4,1,8,0
; off_3D0C6:
ObjC6_SubObjData:
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,5,4,0
word_3D0D0:
	dc.w objoff_42
	dc.L ObjC6
	dc.b $A8
	even
word_3D0D4:
	dc.w objoff_40
	dc.l ObjC6
	dc.b $AA
	even
; animation script
; off_3D0D8:
Ani_objC5_objC6:offsetTable
		offsetTableEntry.w byte_3D0DC	; 0
		offsetTableEntry.w byte_3D0E2	; 1
byte_3D0DC:	dc.b   5,  2,  3,  4,$FF,  0
byte_3D0E2:	dc.b   5,  6,  7,$FF
		even
; animation script
; off_3D0E6:
Ani_objC6:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,$FA
		even
; ----------------------------------------------------------------------------
; sprite mappings ; Robotnik running
; ----------------------------------------------------------------------------
ObjC6_MapUnc_3D0EE:	BINCLUDE "mappings/sprite/objC6_a.bin"
 even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC6_MapUnc_3D1DE:	BINCLUDE "mappings/sprite/objC6_b.bin"
                      even

