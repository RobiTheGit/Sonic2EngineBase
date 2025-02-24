
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 92 - Spiker (drill badnik) from HTZ
; ----------------------------------------------------------------------------
; Sprite_36F0E:
Obj92:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj92_Index(pc,d0.w),d1
	jmp	Obj92_Index(pc,d1.w)
; ===========================================================================
; off_36F1C:
Obj92_Index:	offsetTable
		offsetTableEntry.w Obj92_Init	; 0
		offsetTableEntry.w loc_36F3C	; 2
		offsetTableEntry.w loc_36F68	; 4
		offsetTableEntry.w loc_36F90	; 6
; ===========================================================================
; loc_36F24:
Obj92_Init:
	jsr	LoadSubObject
	move.b	#$40,objoff_2E(a0)
	move.w	#$80,x_vel(a0)
	bchg	#0,status(a0)
	rts
; ===========================================================================

loc_36F3C:
	jsr	loc_3703E
	bne.s	loc_36F48
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_36F5A

loc_36F48:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	lea	(Ani_obj92).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F5A:
	addq.b	#2,routine(a0)
	move.b	#$10,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F68:
	jsr	loc_3703E
	bne.s	+
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_36F78
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F78:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2E(a0)
	neg.w	x_vel(a0)
	bchg	#0,status(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F90:
	move.b	objoff_32(a0),d0
	cmpi.b	#8,d0
	beq.s	loc_36FA4
	subq.b	#1,d0
	move.b	d0,objoff_32(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36FA4:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	loc_36FDC
	st	objoff_2F(a0)
	move.l	#Obj93,(a1) ; load obj93
	move.b	subtype(a0),subtype(a1)
	move.w	a0,objoff_30(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#2,mapping_frame(a0)
	move.b	#1,anim(a0)

loc_36FDC:
	move.b	objoff_33(a0),routine(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 93 - Drill thrown by Spiker from HTZ
; ----------------------------------------------------------------------------
; Sprite_36FE6:
Obj93:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj93_Index(pc,d0.w),d1
	jmp	Obj93_Index(pc,d1.w)
; ===========================================================================
; off_36FF4:
Obj93_Index:	offsetTable
		offsetTableEntry.w Obj93_Init	; 0
		offsetTableEntry.w loc_37028	; 2
; ===========================================================================
; loc_36FF8:
Obj93_Init:
	jsr	LoadSubObject
	ori.b	#$80,render_flags(a0)
	ori.b	#$80,collision_flags(a0)
	movea.w	objoff_30(a0),a1 ; a1=object
	move.b	render_flags(a1),d0
	andi.b	#3,d0
	or.b	d0,render_flags(a0)
	moveq	#2,d1
	btst	#1,d0
	bne.s	+
	neg.w	d1
+
	move.b	d1,y_vel(a0)
	rts
; ===========================================================================

loc_37028:
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	bchg	#0,render_flags(a0)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3703E:
	tst.b	objoff_2F(a0)
	bne.s	loc_37062
	tst.b	render_flags(a0)
	bpl.s	loc_37062
	jsr	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	bhs.s	loc_37062
	addi.w	#$80,d3
	cmpi.w	#$100,d3
	blo.s	loc_37066

loc_37062:
	moveq	#0,d0
	rts
; ===========================================================================

loc_37066:
	move.b	routine(a0),objoff_33(a0)
	move.b	#6,routine(a0)
	move.b	#$10,objoff_32(a0)
	moveq	#1,d0
	rts
; ===========================================================================
; off_3707C:
Obj92_SubObjData:
	subObjData Obj92_Obj93_MapUnc_37092,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,4,$10,$12
; animation script
; off_37086:
Ani_obj92:	offsetTable
		offsetTableEntry.w byte_3708A	; 0
		offsetTableEntry.w byte_3708E	; 2
byte_3708A:	dc.b   9,  0,  1,$FF
byte_3708E:	dc.b   9,  2,  3,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Obj92_Obj93_MapUnc_37092:	BINCLUDE "mappings/sprite/obj93.bin"
        even
