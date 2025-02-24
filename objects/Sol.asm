
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 95 - Sol (fireball-throwing orbit badnik) from HTZ
; ----------------------------------------------------------------------------
; Sprite_370FE:
Obj95:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj95_Index(pc,d0.w),d1
	jmp	Obj95_Index(pc,d1.w)
; ===========================================================================
; off_3710C:
Obj95_Index:	offsetTable
		offsetTableEntry.w Obj95_Init	; 0
		offsetTableEntry.w Obj95_WaitForPlayer	; 2
		offsetTableEntry.w loc_37224	; 4
		offsetTableEntry.w Obj95_FireballUpdate	; 6
		offsetTableEntry.w loc_372B8	; 8
; ===========================================================================
; loc_37116:
Obj95_Init:
	move.l	#Obj95_MapUnc_372E6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo64_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$B,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.w	#-$40,x_vel(a0)
	moveq	#0,d2
	lea	objoff_3B(a0),a2
	movea.l	a2,a3
	addq.w	#1,a2
	moveq	#3,d1

; loc_37152:
Obj95_NextFireball:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	loc_371AE
	addq.b	#1,(a3)
	move.w	a1,d5
	subi.w	#MainCharacter,d5
    if object_size=$40
	lsr.w	#6,d5
    else
	divu.w	#object_size,d5
    endif
	andi.w	#$7F,d5
	move.b	d5,(a2)+
	move.l	(a0),(a1) ; load obj95
	move.b	#6,routine(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#8,width_pixels(a1)
	move.b	#3,mapping_frame(a1)
	move.b	#$98,collision_flags(a1)
	move.b	d2,angle(a1)
	addi.b	#$40,d2
	move.l	a0,objoff_40(a1)
	dbf	d1,Obj95_NextFireball

loc_371AE:
	moveq	#1,d0
	btst	#0,status(a0)
	beq.s	loc_371BA
	neg.w	d0

loc_371BA:
	move.b	d0,objoff_3A(a0)
	move.b	subtype(a0),routine(a0)
	addq.b	#2,routine(a0)
	move.w	#-$40,x_vel(a0)
	btst	#0,status(a0)
	beq.s	return_371DA
	neg.w	x_vel(a0)

return_371DA:
	rts
; ===========================================================================

; loc_371DC:
Obj95_WaitForPlayer:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bcc.s	loc_371E8
	neg.w	d0

loc_371E8:
	cmpi.w	#$A0,d0
	bhs.s	loc_3720C
	move.w	(MainCharacter+y_pos).w,d0
	sub.w	y_pos(a0),d0
	bcc.s	loc_371FA
	neg.w	d0

loc_371FA:
	cmpi.w	#$50,d0
	bhs.s	loc_3720C
	tst.w	(Debug_placement_mode).w
	bne.s	loc_3720C
	move.b	#1,anim(a0)

loc_3720C:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	lea	(Ani_obj95_a).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	andi.b	#3,mapping_frame(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_37224:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	lea	(Ani_obj95_b).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	andi.b	#3,mapping_frame(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_3723C:
Obj95_FireballUpdate:
	lea	(Ani_obj95_b).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	movea.l	objoff_40(a0),a1 ; a1=object
	cmpi.l	#Obj95,(a1) ; check if parent object is still alive
	bne.w	JmpTo65_DeleteObject
	cmpi.b	#2,mapping_frame(a1)
	bne.s	Obj95_FireballOrbit
	cmpi.b	#$40,angle(a0)
	bne.s	Obj95_FireballOrbit
	addq.b	#2,routine(a0)
	move.b	#0,anim(a0)
	subq.b	#1,objoff_3B(a1)
	bne.s	loc_37278
	addq.b	#2,routine(a1)

loc_37278:
	move.w	#-$200,x_vel(a0)
	btst	#0,status(a1)
	beq.s	+
	neg.w	x_vel(a0)
+
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

; loc_3728E:
Obj95_FireballOrbit:
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	asr.w	#4,d1
	add.w	x_pos(a1),d1
	move.w	d1,x_pos(a0)
	asr.w	#4,d0
	add.w	y_pos(a1),d0
	move.w	d0,y_pos(a0)
	move.b	objoff_3A(a1),d0
	add.b	d0,angle(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_372B8:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	lea	(Ani_obj95_b).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; animation script
; off_372D2:
Ani_obj95_a:	offsetTable
		offsetTableEntry.w byte_372D6	; 0
		offsetTableEntry.w byte_372DA	; 1
byte_372D6:	dc.b  $F,  0,$FF,  0
byte_372DA:	dc.b  $F,  1,  2,$FE,  1
		even
; animation script
; off_372E0:
Ani_obj95_b:	offsetTable
		offsetTableEntry.w +
+		dc.b   5,  3,  4,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj95_MapUnc_372E6:	BINCLUDE "mappings/sprite/obj95.bin"
                  even
Invalid_SubObjData:
