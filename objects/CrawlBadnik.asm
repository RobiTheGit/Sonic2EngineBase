; ===========================================================================
; ----------------------------------------------------------------------------
; Object C8 - Crawl (shield badnik) from CNZ
; ----------------------------------------------------------------------------
; Sprite_3D23E:
ObjC8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC8_Index(pc,d0.w),d1
	jmp	ObjC8_Index(pc,d1.w)
; ===========================================================================
; off_3D24C:
ObjC8_Index:	offsetTable
		offsetTableEntry.w ObjC8_Init	; 0
		offsetTableEntry.w loc_3D27C	; 2
		offsetTableEntry.w loc_3D2A6	; 4
		offsetTableEntry.w loc_3D2D4	; 6
; ===========================================================================
; loc_3D254:
ObjC8_Init:
	bsr.w	LoadSubObject
	move.w	#$200,objoff_2E(a0)
	moveq	#$20,d0
	btst	#0,render_flags(a0)
	bne.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a0)
	move.b	#$F,y_radius(a0)
	move.b	#$10,x_radius(a0)
	rts
; ===========================================================================

loc_3D27C:
	subq.w	#1,objoff_2E(a0)
	beq.s	+
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	bsr.w	loc_3D416
	lea	(Ani_objC8).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#$3B,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D2A6:
	subq.w	#1,objoff_2E(a0)
	bmi.s	+
	bsr.w	loc_3D416
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	move.b	#2,routine(a0)
	move.w	#$200,objoff_2E(a0)
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
	bchg	#0,status(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D2D4:
	move.b	#$D7,collision_flags(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,d4
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.w	loc_3D39A
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	bhs.w	loc_3D39A
	bclr	#3,status(a0)
	bne.w	loc_3D386
	move.b	collision_property(a0),d0
	beq.s	BranchTo18_JmpTo39_MarkObjGone
	bclr	#0,collision_property(a0)
	beq.s	+++
	cmpi.b	#AniIDSonAni_Roll,anim(a1)
	bne.s	loc_3D36C
	btst	#1,status(a1)
	bne.s	++
	bsr.w	Obj_GetOrientationToPlayer
	btst	#0,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	loc_3D390
+
	bsr.s	loc_3D3A4
+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	+++
	cmpi.b	#AniIDTailsAni_Roll,anim(a1)
	bne.s	loc_3D36C
	btst	#1,status(a1)
	bne.s	++
	bsr.w	Obj_GetOrientationToPlayer
	btst	#0,render_flags(a0)
	beq.s	+
	subq.w	#2,d0
+
	tst.w	d0
	bne.s	loc_3D390
+
	bsr.s	loc_3D3A4
+
	clr.b	collision_property(a0)

BranchTo18_JmpTo39_MarkObjGone
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D36C:
	move.b	#$97,collision_flags(a0)
	btst	#status_sec_isInvincible,status_secondary(a1)
	beq.s	+
	move.b	#$17,collision_flags(a0)
+
	bset	#3,status(a0)

loc_3D386:
	move.b	#1,mapping_frame(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D390:
	move.b	#$17,collision_flags(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D39A:
	move.b	objoff_30(a0),routine(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3D3A4:
	move.b	#2,mapping_frame(a0)
	btst	#1,status(a1)
	beq.s	+
	move.b	#3,mapping_frame(a0)
+
	move.w	x_pos(a0),d1
	move.w	y_pos(a0),d2
	sub.w	x_pos(a1),d1
	sub.w	y_pos(a1),d2
	jsr	(CalcAngle).l
	move.b	(Timer_frames).w,d1
	andi.w	#3,d1
	add.w	d1,d0
	jsr	(CalcSine).l
	muls.w	#-$700,d1
	asr.l	#8,d1
	move.w	d1,x_vel(a1)
	muls.w	#-$700,d0
	asr.l	#8,d0
	move.w	d0,y_vel(a1)
	bset	#1,status(a1)
	bclr	#4,status(a1)
	bclr	#5,status(a1)
	clr.b	jumping(a1)
	move.w	#SndID_Bumper,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
	; unused
	rts
; ===========================================================================

loc_3D416:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.s	+	; rts
	addi.w	#$40,d3
	cmpi.w	#$80,d3
	bhs.s	+	; rts
	move.b	routine(a0),objoff_30(a0)
	move.b	#6,routine(a0)
	clr.b	mapping_frame(a0)
+
	rts
; ===========================================================================
; off_3D440:
ObjC8_SubObjData:
	subObjData ObjC8_MapUnc_3D450,make_art_tile(ArtTile_ArtNem_Crawl,0,1),4,3,$10,$D7
; animation script
; off_3D44A:
Ani_objC8:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b $13,  0,  1,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings ; Crawl CNZ
; ----------------------------------------------------------------------------
ObjC8_MapUnc_3D450:	BINCLUDE "mappings/sprite/objC8.bin"

                  even

ChildRefrenceDEZBOSS = $46
ParentRefrence_2 = $12 ; insted of $14
DelaySomthing = anim_frame_duration+1
