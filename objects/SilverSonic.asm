


; ===========================================================================
; ----------------------------------------------------------------------------
; Object AF - Mecha Sonic / Silver Sonic from DEZ
; (also handles Eggman's remote-control window)
; ----------------------------------------------------------------------------
; Sprite_3972C:
ObjAF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAF_Index(pc,d0.w),d1
	jmp	ObjAF_Index(pc,d1.w)
; ===========================================================================
; off_3973A:
ObjAF_Index:	offsetTable
		offsetTableEntry.w ObjAF_Init	;   0
		offsetTableEntry.w loc_397AC	;   2
		offsetTableEntry.w loc_397E6	;   4
		offsetTableEntry.w loc_397FE	;   6
		offsetTableEntry.w loc_3984A	;   8
		offsetTableEntry.w loc_398C0	;  $A
		offsetTableEntry.w loc_39B92	;  $C
		offsetTableEntry.w loc_39BBA	;  $E
		offsetTableEntry.w loc_39BCC	; $10
		offsetTableEntry.w loc_39BE2	; $12
		offsetTableEntry.w loc_39BEA	; $14
		offsetTableEntry.w loc_39C02	; $16
		offsetTableEntry.w loc_39C0A	; $18
		offsetTableEntry.w loc_39C12	; $1A
		offsetTableEntry.w loc_39C2A	; $1C
		offsetTableEntry.w loc_39C42	; $1E
		offsetTableEntry.w loc_39C50	; $20
		offsetTableEntry.w loc_39CA0	; $22
; ===========================================================================
; loc_3975E:
ObjAF_Init:
	bsr.w	LoadSubObject
	move.b	#$1B,y_radius(a0)
	move.b	#$10,x_radius(a0)
	move.b	#0,collision_flags(a0)
	move.b	#8,collision_property(a0)
	lea	(word_39DC2).l,a2
	bsr.w	LoadChildObject
	move.b	#$E,routine(a1)
	lea	(word_39DC6).l,a2
	bsr.w	LoadChildObject
	move.b	#$14,routine(a1)
	lea	(word_39DCA).l,a2
	bsr.w	LoadChildObject
	move.b	#$1A,routine(a1)
	rts
; ===========================================================================

loc_397AC:
	move.w	(Camera_X_pos).w,d0
	cmpi.w	#$224,d0
	bhs.s	loc_397BA
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_397BA:
	addq.b	#2,routine(a0)
	move.w	#$3C,objoff_2E(a0)
	move.w	#$100,y_vel(a0)
	move.w	#$224,d0
	move.w	d0,(Camera_Min_X_pos).w
	move.w	d0,(Camera_Max_X_pos).w
	move.b	#9,(Current_Boss_ID).w
	moveq	#MusID_FadeOut,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_397E6:
	subq.w	#1,objoff_2E(a0)
	bmi.s	loc_397F0
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_397F0:
	addq.b	#2,routine(a0)
	moveq	#MusID_Boss,d0
	jsrto	(PlayMusic).l, JmpTo5_PlayMusic
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_397FE:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	loc_3980E
	moveq	#SndID_Fire,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound

loc_3980E:
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bmi.s	loc_39830
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	moveq	#0,d0
	moveq	#0,d1
	movea.w	parent(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	bsr.w	loc_39D4A
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39830:
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)
	move.b	#$1A,collision_flags(a0)
	bset	#1,status(a0)
	bra.w	loc_399D6
; ===========================================================================

loc_3984A:
	bsr.w	loc_39CAE
	bsr.w	loc_39D1C
	subq.b	#1,objoff_2E(a0)
	beq.s	loc_39886
	cmpi.b	#$32,objoff_2E(a0)
	bne.s	loc_3986A
	moveq	#SndID_MechaSonicBuzz,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound
	jsrto	(DisplaySprite).l, JmpTo45_DisplaySprite

loc_3986A:
	jsr	(ObjCheckFloorDist).l
	add.w	d1,y_pos(a0)
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bsr.w	loc_39D4A
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39886:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	objoff_33(a0),d0
	andi.b	#$F,d0
	move.b	byte_398B0(pc,d0.w),routine_secondary(a0)
	addq.b	#1,objoff_33(a0)
	clr.b	objoff_32(a0)
	movea.w	objoff_40(a0),a1 ; a1=object
	move.b	#$16,routine(a1)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
byte_398B0:
	dc.b   6
	dc.b   0	; 1
	dc.b $10	; 2
	dc.b   6	; 3
	dc.b   6	; 4
	dc.b $1E	; 5
	dc.b   0	; 6
	dc.b $10	; 7
	dc.b   6	; 8
	dc.b   6	; 9
	dc.b $10	; 10
	dc.b   6	; 11
	dc.b   0	; 12
	dc.b   6	; 13
	dc.b $10	; 14
	dc.b $1E	; 15
; ===========================================================================

loc_398C0:
	bsr.w	loc_39CAE
	bsr.w	loc_39D1C
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_398F2(pc,d0.w),d1
	jsr	off_398F2(pc,d1.w)
	moveq	#0,d0
	moveq	#0,d1
	movea.w	parent(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	bsr.w	loc_39D4A
	bsr.w	Obj_AlignChildXY
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
off_398F2:	offsetTable
		offsetTableEntry.w loc_3991E	;   0
		offsetTableEntry.w loc_39946	;   2
		offsetTableEntry.w loc_39976	;   4
		offsetTableEntry.w loc_39A0A	;   6
		offsetTableEntry.w loc_39A1C	;   8
		offsetTableEntry.w loc_39A44	;  $A
		offsetTableEntry.w loc_39A68	;  $C
		offsetTableEntry.w loc_39A96	;  $E
		offsetTableEntry.w loc_39A0A	; $10
		offsetTableEntry.w loc_39A1C	; $12
		offsetTableEntry.w loc_39AAA	; $14
		offsetTableEntry.w loc_39ACE	; $16
		offsetTableEntry.w loc_39AF4	; $18
		offsetTableEntry.w loc_39B28	; $1A
		offsetTableEntry.w loc_39A96	; $1C
		offsetTableEntry.w loc_39A0A	; $1E
		offsetTableEntry.w loc_39A1C	; $20
		offsetTableEntry.w loc_39AAA	; $22
		offsetTableEntry.w loc_39ACE	; $24
		offsetTableEntry.w loc_39B44	; $26
		offsetTableEntry.w loc_39B28	; $28
		offsetTableEntry.w loc_39A96	; $2A
; ===========================================================================

loc_3991E:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#2,objoff_30(a0)

loc_3992E:
	move.b	#$20,objoff_2E(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$10,routine(a1)
	move.b	#1,anim(a1)
	rts
; ===========================================================================

loc_39946:
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_3994E
	rts
; ===========================================================================

loc_3994E:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2E(a0)
	move.b	#1,anim(a0)
	move.w	#$800,d0
	bsr.w	loc_39D60
	movea.w	parent(a0),a1 ; a1=object
	move.b	#2,anim(a1)
	moveq	#SndID_SpindashRelease,d0
	jmpto	(PlaySound).l, JmpTo12_PlaySound
; ===========================================================================

loc_39976:
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_399C2
	cmpi.b	#$20,objoff_2E(a0)
	bne.s	loc_39994
	move.b	#2,anim(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$12,routine(a1)

loc_39994:
	bsr.w	loc_39D72
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	cmpi.b	#2,anim(a0)
	bne.s	return_399C0
	cmpi.b	#2,anim_frame(a0)
	bne.s	return_399C0
	cmpi.b	#3,anim_frame_duration(a0)
	bne.s	return_399C0
	bchg	#0,render_flags(a0)

return_399C0:
	rts
; ===========================================================================

loc_399C2:
	subq.b	#1,objoff_30(a0)
	beq.s	loc_399D6
	move.b	#2,routine_secondary(a0)
	clr.w	x_vel(a0)
	bra.w	loc_3992E
; ===========================================================================

loc_399D6:
	move.b	#8,routine(a0)
	move.b	#0,anim(a0)
	move.b	#$64,objoff_2E(a0)
	clr.w	x_vel(a0)
	movea.w	parent(a0),a1 ; a1=object
	move.b	#$12,routine(a1)
	movea.w	objoff_40(a0),a1 ; a1=object
	move.b	#$18,routine(a1)
	moveq	#SndID_MechaSonicBuzz,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39A0A:
	addq.b	#2,routine_secondary(a0)
	move.b	#3,mapping_frame(a0)
	move.b	#3,anim(a0)
	rts
; ===========================================================================

loc_39A1C:
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bne.s	loc_39A2A
	rts
; ===========================================================================

loc_39A2A:
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,objoff_2E(a0)
	move.b	#4,anim(a0)
	moveq	#SndID_LaserBeam,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39A44:
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_39A56
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	rts
; ===========================================================================

loc_39A56:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2E(a0)
	move.w	#$800,d0
	bra.w	loc_39D60
; ===========================================================================

loc_39A68:
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_39A7C
	bsr.w	loc_39D72
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39A7C:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,anim(a0)
	bchg	#0,render_flags(a0)
	clr.w	x_vel(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39A96:
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	bne.w	BranchTo_loc_399D6
	rts
; ===========================================================================

BranchTo_loc_399D6 ; BranchTo
	bra.w	loc_399D6
; ===========================================================================

loc_39AAA:
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_39ABC
	lea	(off_39DE2).l,a1
	bsr.w	AnimateSprite_Checked
	rts
; ===========================================================================

loc_39ABC:
	addq.b	#2,routine_secondary(a0)
	move.b	#$40,objoff_2E(a0)
	move.w	#$400,d0
	bra.w	loc_39D60
; ===========================================================================

loc_39ACE:
	subq.b	#1,objoff_2E(a0)
	cmpi.b	#$3C,objoff_2E(a0)
	bne.s	loc_39ADE
	bsr.w	loc_39AE8

loc_39ADE:
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39AE8:
	addq.b	#2,routine_secondary(a0)
	move.w	#-$600,y_vel(a0)
	rts
; ===========================================================================

loc_39AF4:
	subq.b	#1,objoff_2E(a0)
	bmi.w	loc_39A7C
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_39B0A
	bsr.w	loc_39B1A

loc_39B0A:
	addi.w	#$38,y_vel(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B1A:
	addq.b	#2,routine_secondary(a0)
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39B28:
	subq.b	#1,objoff_2E(a0)
	bmi.w	loc_39A7C
	jsr	(ObjCheckFloorDist).l
	add.w	d1,y_pos(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B44:
	subq.b	#1,objoff_2E(a0)
	bmi.w	loc_39A7C
	tst.b	objoff_32(a0)
	bne.s	loc_39B66
	tst.w	y_vel(a0)
	bmi.s	loc_39B66
	st	objoff_32(a0)
	bsr.w	loc_39D82
	moveq	#SndID_SpikeSwitch,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound

loc_39B66:
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_39B74
	bsr.w	loc_39B84

loc_39B74:
	addi.w	#$38,y_vel(a0)
	lea	(off_39DE2).l,a1
	bra.w	AnimateSprite_Checked
; ===========================================================================

loc_39B84:
	addq.b	#2,routine_secondary(a0)
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_39B92:
	clr.b	collision_flags(a0)
	subq.w	#1,objoff_36(a0)
	bmi.s	loc_39BA4
	jsrto	(Boss_LoadExplosion).l, JmpTo_Boss_LoadExplosion
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39BA4:
	move.w	#$1000,(Camera_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w

	move.w	(Level_Music).w,d0
	jsrto	(PlayMusic).l, JmpTo5_PlayMusic
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_39BBA:
	bsr.w	LoadSubObject
	move.b	#8,width_pixels(a0)
	move.b	#0,collision_flags(a0)
	rts
; ===========================================================================

loc_39BCC:
	movea.w	objoff_30(a0),a1 ; a1=object
	bsr.w	InheritParentXYFlip
	lea	(off_39E30).l,a1
	bsr.w	AnimateSprite_Checked
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39BE2:
	andi.b	#$7F,render_flags(a0)
	rts
; ===========================================================================

loc_39BEA:
	bsr.w	LoadSubObject
	move.b	#8,width_pixels(a0)
	move.b	#$B,mapping_frame(a0)
	move.b	#3,priority(a0)
	rts
; ===========================================================================

loc_39C02:
	move.b	#0,collision_flags(a0)
	rts
; ===========================================================================

loc_39C0A:
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

loc_39C12:
	bsr.w	LoadSubObject
	move.b	#4,mapping_frame(a0)
	move.w	#$2C0,x_pos(a0)
	move.w	#$139,y_pos(a0)
	rts
; ===========================================================================

loc_39C2A:
	movea.w	objoff_30(a0),a1 ; a1=object
	bclr	#1,status(a1)
	bne.s	loc_39C3A
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C3A:
	addq.b	#2,routine(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C42:
	lea	(Ani_objAF_c).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C50:
	movea.w	objoff_30(a0),a1 ; a1=object
	lea	(MainCharacter).w,a2 ; a2=character
	btst	#2,status(a1)
	bne.s	loc_39C92
	move.b	#2,anim(a0)
	cmpi.b	#4,routine(a2)
	bne.s	loc_39C78
	move.b	#3,anim(a0)
	bra.w	loc_39C84
; ===========================================================================

loc_39C78:
	tst.b	collision_flags(a1)
	bne.s	loc_39C84
	move.b	#4,anim(a0)

loc_39C84:
	lea	(Ani_objAF_c).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39C92:
	addq.b	#2,routine(a0)
	move.b	#1,anim(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39CA0:
	lea	(Ani_objAF_c).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_39CAE:
	tst.b	collision_property(a0)
	beq.s	loc_39CF0
	tst.b	collision_flags(a0)
	bne.s	return_39CEE
	tst.b	objoff_34(a0)
	bne.s	loc_39CD0
	move.b	#$20,objoff_34(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

loc_39CD0:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	loc_39CDE
	move.w	#$EEE,d0

loc_39CDE:
	move.w	d0,(a1)
	subq.b	#1,objoff_34(a0)
	bne.s	return_39CEE
	clr.w	(Normal_palette_line2+2).w
	bsr.w	loc_39D24

return_39CEE:
	rts
; ===========================================================================

loc_39CF0:
	moveq	#100,d0
	jsr	AddPoints
	move.w	#$FF,objoff_36(a0)
	move.b	#$C,routine(a0)
	clr.b	collision_flags(a0)
	bset	#2,status(a0)
	movea.w	objoff_40(a0),a1 ; a1=object
	jsrto	(DeleteObject2).l, JmpTo6_DeleteObject2
	movea.w	parent(a0),a1 ; a1=object
	jmpto	(DeleteObject2).l, JmpTo6_DeleteObject2
; ===========================================================================

loc_39D1C:
	tst.b	collision_flags(a0)
	beq.w	return_37A48

loc_39D24:
	move.b	mapping_frame(a0),d0
	cmpi.b	#6,d0
	beq.s	loc_39D42
	cmpi.b	#7,d0
	beq.s	loc_39D42
	cmpi.b	#8,d0
	beq.s	loc_39D42
	move.b	#$1A,collision_flags(a0)
	rts
; ===========================================================================

loc_39D42:
	move.b	#$9A,collision_flags(a0)
	rts
; ===========================================================================

loc_39D4A:
	moveq	#$C,d0
	moveq	#-$C,d1
	btst	#0,render_flags(a0)
	beq.s	loc_39D58
	neg.w	d0

loc_39D58:
	movea.w	objoff_40(a0),a1 ; a1=object
	bra.w	Obj_AlignChildXY
; ===========================================================================

loc_39D60:
	tst.b	objoff_31(a0)
	bne.s	loc_39D68
	neg.w	d0

loc_39D68:
	not.b	objoff_31(a0)
	move.w	d0,x_vel(a0)
	rts
; ===========================================================================

loc_39D72:
	moveq	#$20,d0
	tst.w	x_vel(a0)
	bmi.s	loc_39D7C
	neg.w	d0

loc_39D7C:
	add.w	d0,x_vel(a0)
	rts
; ===========================================================================

loc_39D82:
	move.b	#$4A,d2
	moveq	#7,d6
	lea	(byte_39D92).l,a2
	bra.w	Obj_CreateProjectiles
; ===========================================================================
byte_39D92:
	dc.b   0,$E8,  0,$FD, $F,  0,$F0,$F0,$FE,$FE,$10,  0,$E8,  0,$FD,  0
	dc.b $11,  0,$F0,$10,$FE,  2,$12,  0,  0,$18,  0,  3,$13,  0,$10,$10; 16
	dc.b   2,  2,$14,  0,$18,  0,  3,  0,$15,  0,$10,$F0,  2,$FE,$16,  0; 32
	even
word_39DC2:
	dc.w objoff_42
	dc.l ObjAF
	dc.b $48
	even
word_39DC6:
	dc.w objoff_40
	dc.l ObjAF
	dc.b $48
	even
word_39DCA:
	dc.w objoff_3E
	dc.l ObjAF
	dc.b $A4
	even
; off_39DCE:
ObjAF_SubObjData2:
	subObjData ObjAF_Obj98_MapUnc_39E68,make_art_tile(ArtTile_ArtNem_SilverSonic,1,0),4,4,$10,$1A
; off_39DD8:
ObjAF_SubObjData3:
	subObjData ObjAF_MapUnc_3A08C,make_art_tile(ArtTile_ArtNem_DEZWindow,0,0),4,6,$10,0

; animation script
off_39DE2:	offsetTable
		offsetTableEntry.w byte_39DEE	; 0
		offsetTableEntry.w byte_39DF4	; 1
		offsetTableEntry.w byte_39DF8	; 2
		offsetTableEntry.w byte_39DFE	; 3
		offsetTableEntry.w byte_39E14	; 4
		offsetTableEntry.w byte_39E1A	; 5
byte_39DEE:
	dc.b   2,  0,  1,  2,$FF,  0
byte_39DF4:
	dc.b $45,  3,$FD,  0
byte_39DF8:
	dc.b   3,  4,  5,  4,  3,$FC
byte_39DFE:
	dc.b   3,  3,  3,  6,  6,  6,  7,  7,  7,  8,  8,  8,  6,  6,  7,  7
	dc.b   8,  8,  6,  7,  8,$FC; 16
byte_39E14:
	dc.b   2,  6,  7,  8,$FF,  0
byte_39E1A:
	dc.b   3,  8,  7,  6,  8,  8,  7,  7,  6,  6,  8,  8,  8,  7,  7,  7
	dc.b   6,  6,  6,  3,  3,$FC; 16
	even

; animation script
off_39E30:	offsetTable
		offsetTableEntry.w byte_39E36	; 0
		offsetTableEntry.w byte_39E3A	; 1
		offsetTableEntry.w byte_39E3E	; 2
byte_39E36:
	dc.b   1, $B, $C,$FF
byte_39E3A:
	dc.b   1, $D, $E,$FF
byte_39E3E:
	dc.b   1,  9, $A,$FF
	even

; animation script
; off_39E42:
Ani_objAF_c:	offsetTable
		offsetTableEntry.w byte_39E4C	; 0
		offsetTableEntry.w byte_39E54	; 1
		offsetTableEntry.w byte_39E5C	; 2
		offsetTableEntry.w byte_39E60	; 3
		offsetTableEntry.w byte_39E64	; 4
byte_39E4C:	dc.b   3,  4,  3,  2,  1,  0,$FC,  0
byte_39E54:	dc.b   3,  0,  1,  2,  3,  4,$FA,  0
byte_39E5C:	dc.b   3,  5,  5,$FF
byte_39E60:	dc.b   3,  5,  6,$FF
byte_39E64:	dc.b   3,  7,  7,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAF_Obj98_MapUnc_39E68:	BINCLUDE "mappings/sprite/objAF_a.bin"
      even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAF_MapUnc_3A08C:	BINCLUDE "mappings/sprite/objAF_b.bin"
              even
