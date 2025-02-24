

; ===========================================================================
; ----------------------------------------------------------------------------
; Object AD - Clucker's base from WFZ
; ----------------------------------------------------------------------------
; Sprite_3941C:
ObjAD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAD_Index(pc,d0.w),d1
	jmp	ObjAD_Index(pc,d1.w)
; ===========================================================================
; off_3942A:
ObjAD_Index:	offsetTable
		offsetTableEntry.w ObjAD_Init	; 0
		offsetTableEntry.w ObjAD_Main	; 2
; ===========================================================================
; loc_3942E:
ObjAD_Init:
	bsr.w	LoadSubObject
	move.b	#$C,mapping_frame(a0)
	rts
; ===========================================================================
; loc_3943A:
ObjAD_Main:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo27_SolidObject
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object AE - Clucker (chicken badnik) from WFZ
; ----------------------------------------------------------------------------
; Sprite_39452:
ObjAE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAE_Index(pc,d0.w),d1
	jmp	ObjAE_Index(pc,d1.w)
; ===========================================================================
; off_39460:
ObjAE_Index:	offsetTable
		offsetTableEntry.w ObjAE_Init	;  0
		offsetTableEntry.w loc_39488	;  2
		offsetTableEntry.w loc_394A2	;  4
		offsetTableEntry.w loc_394D2	;  6
		offsetTableEntry.w loc_394E0	;  8
		offsetTableEntry.w loc_39508	; $A
		offsetTableEntry.w loc_39516	; $C
; ===========================================================================
; loc_3946E:
ObjAE_Init:
	bsr.w	LoadSubObject
	move.b	#$15,mapping_frame(a0)
	btst	#0,render_flags(a0)
	beq.s	+
	bset	#0,status(a0)
+
	rts
; ===========================================================================

loc_39488:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$80,d2
	cmpi.w	#$100,d2
	blo.s	+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_394A2:
	move.b	routine(a0),d2
	lea	(Ani_objAE_a).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	cmp.b	routine(a0),d2
	bne.s	+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	lea	mapping_frame(a0),a1
	clr.l	(a1)
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#8,(a1)
	move.b	#6,collision_flags(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_394D2:
	lea	(Ani_objAE_b).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_394E0:
	tst.b	objoff_2E(a0)
	beq.s	+
	subq.b	#1,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	lea	mapping_frame(a0),a1
	clr.l	(a1)
	clr.w	anim_frame_duration-mapping_frame(a1)
	move.b	#$B,(a1)
	bsr.w	loc_39526
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_39508:
	lea	(Ani_objAE_c).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_39516:
	move.b	#8,routine(a0)
	move.b	#$40,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_39526:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	++	; rts
	move.l	#Obj98,(a1)  ; load obj98
	move.b	#$D,mapping_frame(a1)
	move.b	#$46,subtype(a1) ; <==  ObjAD_SubObjData3
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$B,y_pos(a1)
	move.w	#-$200,d0
	move.w	#-8,d1
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
	neg.w	d1
+
	move.w	d0,x_vel(a1)
	add.w	d1,x_pos(a1)
	lea_	Obj98_CluckerShotMove,a2
	move.l	a2,objoff_2E(a1)
+
	rts
; ===========================================================================
ObjAD_SubObjData:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),4,4,$18,0
ObjAD_SubObjData2:
	subObjData ObjAD_Obj98_MapUnc_395B4,make_art_tile(ArtTile_ArtNem_WfzScratch,0,0),4,5,$10,0

; animation script
; off_3958A
Ani_objAE_a:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,  3,  4,  5,  6,  7,$FC
		even

; animation script
; off_39596
Ani_objAE_b:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  8,  9, $A, $B, $B, $B, $B,$FC
		even

; animation script
; off_395A2
Ani_objAE_c:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $A, $B,$FC
		even

; animation script
; off_395A8
Ani_CluckerShot:offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3, $D, $E, $F,$10,$11,$12,$13,$14,$FF
		even

; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAD_Obj98_MapUnc_395B4:	BINCLUDE "mappings/sprite/objAE.bin"
                    even
