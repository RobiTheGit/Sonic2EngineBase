
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 45 - Pressure spring from OOZ
; ----------------------------------------------------------------------------
; Sprite_240F8:
Obj45:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj45_Index(pc,d0.w),d1
	jsr	Obj45_Index(pc,d1.w)
	jmpto	(MarkObjGone).l, JmpTo11_MarkObjGone
; ===========================================================================
; off_2410A:
Obj45_Index:	offsetTable
		offsetTableEntry.w Obj45_Init	; 0
		offsetTableEntry.w loc_24186	; 2
		offsetTableEntry.w loc_2427A	; 4
; ===========================================================================
; loc_24110:
Obj45_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj45_MapUnc_2451A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_PushSpring,2,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$E,d0
	move.w	Obj45_InitRoutines(pc,d0.w),d0
	jmp	Obj45_InitRoutines(pc,d0.w)
; ===========================================================================
; off_24146:
Obj45_InitRoutines: offsetTable
	offsetTableEntry.w loc_2416E	; 0
	offsetTableEntry.w loc_2414A	; 2
; ===========================================================================

loc_2414A:
	move.b	#4,routine(a0)
	move.b	#1,anim(a0)
	move.b	#$A,mapping_frame(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_PushSpring,2,0),art_tile(a0)
	move.b	#$14,width_pixels(a0)
	move.w	x_pos(a0),objoff_38(a0)

loc_2416E:
	move.b	subtype(a0),d0
	andi.w	#2,d0
	move.w	word_24182(pc,d0.w),objoff_34(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo20_Adjust2PArtPointer
	rts
; ===========================================================================
word_24182:
	dc.w $F000
	dc.w $F600	; 1
; ===========================================================================

loc_24186:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	loc_2419C
	tst.b	objoff_36(a0)
	beq.s	loc_241A8
	subq.b	#1,objoff_36(a0)
	bra.s	loc_241A8
; ===========================================================================

loc_2419C:
	cmpi.b	#9,objoff_36(a0)
	beq.s	loc_241C6
	addq.b	#1,objoff_36(a0)

loc_241A8:
	moveq	#0,d3
	move.b	objoff_36(a0),d3
	move.b	d3,mapping_frame(a0)
	add.w	d3,d3
	move.w	#$1B,d1
	move.w	#$14,d2
	move.w	x_pos(a0),d4
	jsrto	(SolidObject45).l, JmpTo_SolidObject45
	rts
; ===========================================================================

loc_241C6:
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	bsr.s	loc_241D4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6

loc_241D4:
	bclr	d6,status(a0)
	beq.w	return_24278
	move.w	objoff_34(a0),y_vel(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#AniIDSonAni_Spring,anim(a1)
	move.b	#2,routine(a1)
	move.b	subtype(a0),d0
	bpl.s	loc_24206
	move.w	#0,x_vel(a1)

loc_24206:
	btst	#0,d0
	beq.s	loc_24246
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#0,flips_remaining(a1)
	move.b	#4,flip_speed(a1)
	btst	#1,d0
	bne.s	loc_24236
	move.b	#1,flips_remaining(a1)

loc_24236:
	btst	#0,status(a1)
	beq.s	loc_24246
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_24246:
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	loc_2425C
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)

loc_2425C:
	cmpi.b	#8,d0
	bne.s	loc_2426E
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)

loc_2426E:
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================

return_24278:
	rts
; ===========================================================================

loc_2427A:
	move.b	#0,objoff_3A(a0)
	move.w	#$1F,d1
	move.w	#$C,d2
	move.w	#$D,d3
	move.w	x_pos(a0),d4
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsrto	(SolidObject_Always_SingleCharacter).l, JmpTo_SolidObject_Always_SingleCharacter
	cmpi.w	#1,d4
	bne.s	loc_242C0
	move.b	status(a0),d1
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	bcs.s	loc_242B6
	eori.b	#1,d1

loc_242B6:
	andi.b	#1,d1
	bne.s	loc_242C0
	jsr	loc_2433C

loc_242C0:
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsrto	(SolidObject_Always_SingleCharacter).l, JmpTo_SolidObject_Always_SingleCharacter
	cmpi.w	#1,d4
	bne.s	loc_242EE
	move.b	status(a0),d1
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	bcs.s	loc_242E6
	eori.b	#1,d1

loc_242E6:
	andi.b	#1,d1
	bne.s	loc_242EE
	bsr.s	loc_2433C

loc_242EE:
	tst.b	objoff_3A(a0)
	bne.s	return_2433A
	move.w	objoff_38(a0),d0
	cmp.w	x_pos(a0),d0
	beq.s	return_2433A
	bhs.s	loc_2431C
	subq.b	#4,mapping_frame(a0)
	subq.w	#4,x_pos(a0)
	cmp.w	x_pos(a0),d0
	blo.s	loc_24336
	move.b	#$A,mapping_frame(a0)
	move.w	objoff_38(a0),x_pos(a0)
	bra.s	loc_24336
; ===========================================================================

loc_2431C:
	subq.b	#4,mapping_frame(a0)
	addq.w	#4,x_pos(a0)
	cmp.w	x_pos(a0),d0
	bhs.s	loc_24336
	move.b	#$A,mapping_frame(a0)
	move.w	objoff_38(a0),x_pos(a0)

loc_24336:
	jsr	loc_243D0

return_2433A:
	rts
; ===========================================================================

loc_2433C:
	btst	#0,status(a0)
	beq.s	loc_24378
	btst	#0,status(a1)
	bne.w	return_243CE
	tst.w	d0
	bne.w	loc_2435E
	tst.w	inertia(a1)
	beq.s	return_243CE
	bpl.s	loc_243C8
	bra.s	return_243CE
; ===========================================================================

loc_2435E:
	move.w	objoff_38(a0),d0
	addi.w	#$12,d0
	cmp.w	x_pos(a0),d0
	beq.s	loc_243C8
	addq.w	#1,x_pos(a0)
	moveq	#1,d0
	move.w	#$40,d1
	bra.s	loc_243A6
; ===========================================================================

loc_24378:
	btst	#0,status(a1)
	beq.s	return_243CE
	tst.w	d0
	bne.w	loc_2438E
	tst.w	inertia(a1)
	bmi.s	loc_243C8
	bra.s	return_243CE
; ===========================================================================

loc_2438E:
	move.w	objoff_38(a0),d0
	subi.w	#$12,d0
	cmp.w	x_pos(a0),d0
	beq.s	loc_243C8
	subq.w	#1,x_pos(a0)
	moveq	#-1,d0
	move.w	#-$40,d1

loc_243A6:
	add.w	d0,x_pos(a1)
	move.w	d1,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	objoff_38(a0),d0
	sub.w	x_pos(a0),d0
	bcc.s	loc_243C0
	neg.w	d0

loc_243C0:
	addi.w	#$A,d0
	move.b	d0,mapping_frame(a0)

loc_243C8:
	move.b	#1,objoff_3A(a0)

return_243CE:
	rts
; ===========================================================================

loc_243D0:
	move.b	status(a0),d0
	andi.b	#pushing_mask,d0
	beq.w	return_244D0
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_pushing_bit,d6
	bsr.s	loc_243EA
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_pushing_bit,d6

loc_243EA:
	bclr	d6,status(a0)
	beq.w	return_244D0
	move.w	objoff_38(a0),d0
	sub.w	x_pos(a0),d0
	bcc.s	loc_243FE
	neg.w	d0

loc_243FE:
	addi.w	#$A,d0
	lsl.w	#7,d0
	neg.w	d0
	move.w	d0,x_vel(a1)
	subq.w	#4,x_pos(a1)
	bset	#0,status(a1)
	btst	#0,status(a0)
	bne.s	loc_2442C
	bclr	#0,status(a1)
	addi.w	#8,x_pos(a1)
	neg.w	x_vel(a1)

loc_2442C:
	move.w	#$F,move_lock(a1)
	move.w	x_vel(a1),inertia(a1)
	btst	#2,status(a1)
	bne.s	loc_24446
	move.b	#AniIDSonAni_Walk,anim(a1)

loc_24446:
	move.b	subtype(a0),d0
	bpl.s	loc_24452
	move.w	#0,y_vel(a1)

loc_24452:
	btst	#0,d0
	beq.s	loc_24492
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#1,flips_remaining(a1)
	move.b	#8,flip_speed(a1)
	btst	#1,d0
	bne.s	loc_24482
	move.b	#3,flips_remaining(a1)

loc_24482:
	btst	#0,status(a1)
	beq.s	loc_24492
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_24492:
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	loc_244A8
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)

loc_244A8:
	cmpi.b	#8,d0
	bne.s	loc_244BA
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)

loc_244BA:
	bclr	#5,status(a1)
	move.b	#AniIDSonAni_Run,prev_anim(a1)	; Force character's animation to restart
	move.w	#SndID_Spring,d0 ; play spring bounce sound
	jmp	(PlaySound).l
; ===========================================================================

return_244D0:
	rts
; ===========================================================================
; off_244D2:
; Unused animation script
Ani_obj45:	offsetTable
		offsetTableEntry.w byte_244D6	; 0
		offsetTableEntry.w byte_244F8	; 1
byte_244D6:
	dc.b   0,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9,  9,  9,  9,  9,  9
	dc.b   9,  9,  8,  7,  6,  5,  4,  3,  2,  1,  0,  0,  0,  0,  0,  0; 16
	dc.b   0,$FF	; 32
	even
byte_244F8:
	dc.b   0, $A, $B, $C, $D, $E, $F,$10,$11,$12,$13,$13,$13,$13,$13,$13
	dc.b $13,$13,$12,$11,$10, $F, $E, $D, $C, $B, $A, $A, $A, $A, $A, $A; 16
	dc.b  $A,$FF	; 32
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj45_MapUnc_2451A:	BINCLUDE "mappings/sprite/obj45.bin"
         even
