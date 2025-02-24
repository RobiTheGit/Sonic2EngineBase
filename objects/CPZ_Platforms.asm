




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 78 - Stairs from CPZ that move down to open the way
; ----------------------------------------------------------------------------
; Sprite_291CC:
Obj78:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj78_Index(pc,d0.w),d1
	jsr	Obj78_Index(pc,d1.w)
	move.w	objoff_34(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo6_MarkObjGone2
; ===========================================================================
; off_291E2:
Obj78_Index:	offsetTable
		offsetTableEntry.w Obj78_Init	; 0
		offsetTableEntry.w Obj78_Main	; 2
		offsetTableEntry.w loc_29280	; 4
; ===========================================================================
; loc_291E8:
Obj78_Init:
	addq.b	#2,routine(a0)
	moveq	#objoff_38,d3
	moveq	#2,d4
	btst	#0,status(a0)
	beq.s	+
	moveq	#objoff_3E,d3
	moveq	#-2,d4
+
	move.w	x_pos(a0),d2
	movea.l	a0,a1
	moveq	#3,d1
	bra.s	Obj78_LoadSubObject
; ===========================================================================
; loc_29206:
Obj78_SubObjectLoop:
	jsrto	(SingleObjLoad2).l, JmpTo16_SingleObjLoad2
	bne.w	Obj78_Main
	move.b	#4,routine(a1)
; loc_29214:
Obj78_LoadSubObject:
	move.l	(a0),(a1) ; load obj78
	move.l	#Obj6B_MapUnc_2800E,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0),art_tile(a1)
	jsrto	(Adjust2PArtPointer2).l, JmpTo5_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.b	subtype(a0),subtype(a1)
	move.w	d2,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_pos(a0),objoff_34(a1)
	move.w	y_pos(a1),objoff_36(a1)
	addi.w	#$20,d2
	move.b	d3,objoff_33(a1)
	move.l	a0,objoff_40(a1)
	add.b	d4,d3
	dbf	d1,Obj78_SubObjectLoop

; loc_2926C:
Obj78_Main:
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#7,d0
	add.w	d0,d0
	move.w	Obj78_Types(pc,d0.w),d1
	jsr	Obj78_Types(pc,d1.w)

loc_29280:
	movea.l	objoff_40(a0),a2 ; a2=object
	moveq	#0,d0
	move.b	objoff_33(a0),d0
	move.w	(a2,d0.w),d0
	add.w	objoff_36(a0),d0
	move.w	d0,y_pos(a0)
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo21_SolidObject
	swap	d6
	or.b	d6,objoff_32(a2)
	rts
; ===========================================================================
; off_292B8:
Obj78_Types:	offsetTable
		offsetTableEntry.w loc_292C8	; 0
		offsetTableEntry.w loc_29334	; 1
		offsetTableEntry.w loc_292EC	; 2
		offsetTableEntry.w loc_29334	; 3
		offsetTableEntry.w loc_292C8	; 4
		offsetTableEntry.w loc_2935E	; 5
		offsetTableEntry.w loc_292EC	; 6
		offsetTableEntry.w loc_2935E	; 7
; ===========================================================================

loc_292C8:
	tst.w	objoff_30(a0)
	bne.s	loc_292E0
	move.b	objoff_32(a0),d0
	andi.b	#touch_top_mask,d0
	beq.s	return_292DE
	move.w	#$1E,objoff_30(a0)

return_292DE:
	rts
; ===========================================================================

loc_292E0:
	subq.w	#1,objoff_30(a0)
	bne.s	return_292DE
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_292EC:
	tst.w	objoff_30(a0)
	bne.s	loc_29304
	move.b	objoff_32(a0),d0
	andi.b	#touch_bottom_mask,d0
	beq.s	return_29302
	move.w	#$3C,objoff_30(a0)

return_29302:
	rts
; ===========================================================================

loc_29304:
	subq.w	#1,objoff_30(a0)
	bne.s	loc_29310
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_29310:
	lea	objoff_38(a0),a1 ; a1=object
	move.w	objoff_30(a0),d0
	lsr.b	#2,d0
	andi.b	#1,d0
	move.w	d0,(a1)+
	eori.b	#1,d0
	move.w	d0,(a1)+
	eori.b	#1,d0
	move.w	d0,(a1)+
	eori.b	#1,d0
	move.w	d0,(a1)+
	rts
; ===========================================================================

loc_29334:
	lea	objoff_38(a0),a1 ; a1=object
	cmpi.w	#$80,(a1)
	beq.s	return_2935C
	addq.w	#1,(a1)
	moveq	#0,d1
	move.w	(a1)+,d1
	swap	d1
	lsr.l	#1,d1
	move.l	d1,d2
	lsr.l	#1,d1
	move.l	d1,d3
	add.l	d2,d3
	swap	d1
	swap	d2
	swap	d3
	move.w	d3,(a1)+
	move.w	d2,(a1)+
	move.w	d1,(a1)+

return_2935C:
	rts
; ===========================================================================

loc_2935E:
	lea	objoff_38(a0),a1 ; a1=object
	cmpi.w	#-$80,(a1)
	beq.s	return_29386
	subq.w	#1,(a1)
	moveq	#0,d1
	move.w	(a1)+,d1
	swap	d1
	asr.l	#1,d1
	move.l	d1,d2
	asr.l	#1,d1
	move.l	d1,d3
	add.l	d2,d3
	swap	d1
	swap	d2
	swap	d3
	move.w	d3,(a1)+
	move.w	d2,(a1)+
	move.w	d1,(a1)+

return_29386:
	rts
; ===========================================================================

    if ~~removeJmpTos
JmpTo16_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo5_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo21_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo6_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 7A - Platform that moves back and forth on top of water in CPZ
; ----------------------------------------------------------------------------
; Sprite_293A0:
Obj7A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj7A_Index(pc,d0.w),d1
	jmp	Obj7A_Index(pc,d1.w)
; ===========================================================================
; off_293AE:
Obj7A_Index:	offsetTable
		offsetTableEntry.w Obj7A_Init		; 0
		offsetTableEntry.w Obj7A_Main		; 2
		offsetTableEntry.w Obj7A_SubObject	; 4
; ===========================================================================
byte_293B4:
	dc.b   0
	dc.b $68	; 1
	dc.b $FF	; 2
	dc.b $98	; 3
	dc.b   0	; 4
	dc.b   0	; 5
	dc.b   1	; 6
	dc.b $A8	; 7
	dc.b $FF	; 8
	dc.b $50	; 9
	dc.b   0	; 10
	dc.b $40	; 11
	dc.b   1	; 12
	dc.b $E8	; 13
	dc.b $FF	; 14
	dc.b $80	; 15
	dc.b   0	; 16
	dc.b $80	; 17
	dc.b   0	; 18
	dc.b $68	; 19
	dc.b   0	; 20
	dc.b $67	; 21
	dc.b   0	; 22
	dc.b   0	; 23
; ===========================================================================
; loc_293CC:
Obj7A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj7A_MapUnc_29564,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,1),art_tile(a0)
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj15_Obj7A_MapUnc_10256,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
+
	jsrto	(Adjust2PArtPointer).l, JmpTo41_Adjust2PArtPointer
	moveq	#0,d1
	move.b	subtype(a0),d1
	lea	byte_293B4(pc,d1.w),a2
	move.b	(a2)+,d1
	movea.l	a0,a1
	bra.s	Obj7A_LoadSubObject
; ===========================================================================
; loc_29408:
Obj7A_SubObjectLoop:
	jsrto	(SingleObjLoad2).l, JmpTo17_SingleObjLoad2
	bne.s	Obj7A_SubObjectLoop_End
	move.l	(a0),(a1) ; load obj7A
	move.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
; loc_29426:
Obj7A_LoadSubObject:
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$18,width_pixels(a1)
	move.w	x_pos(a1),objoff_34(a1)
; loc_2944A:
Obj7A_SubObjectLoop_End:
	dbf	d1,Obj7A_SubObjectLoop

	move.l	a0,objoff_40(a1)
	move.l	a1,objoff_40(a0)
	cmpi.b	#$C,subtype(a0)
	bne.s	+
	move.b	#1,objoff_3A(a0)
+
	moveq	#0,d1
	move.b	(a2)+,d1
	move.w	objoff_34(a0),d0
	sub.w	d1,d0
	move.w	d0,objoff_36(a0)
	move.w	d0,objoff_36(a1)
	add.w	d1,d0
	add.w	d1,d0
	move.w	d0,objoff_38(a0)
	move.w	d0,objoff_38(a1)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a1)
; loc_2948E:
Obj7A_Main:
	bsr.s	loc_294F4
	tst.w	(Two_player_mode).w
	beq.s	+	; if 2P VS mode is off, branch
	jmpto	(DisplaySprite).l, JmpTo24_DisplaySprite
; ===========================================================================
+
	move.w	objoff_36(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bls.s	+
	move.w	objoff_38(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	loc_294C4
+
	jmp	(DisplaySprite).l
; ===========================================================================

loc_294C4:
	movea.l	objoff_40(a0),a1 ; a1=object
	cmpa.l	a0,a1
	beq.s	+
	jsr	(DeleteObject2).l
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	JmpTo39_DeleteObject
	bclr	#7,2(a2,d0.w)

JmpTo39_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================
; loc_294EA:
Obj7A_SubObject:
	bsr.s	loc_294F4
	bsr.s	loc_2953E
	jmp	(DisplaySprite).l
; ===========================================================================

loc_294F4:
	move.w	x_pos(a0),-(sp)
	tst.b	objoff_3A(a0)
	beq.s	loc_29516
	move.w	x_pos(a0),d0
	subq.w	#1,d0
	cmp.w	objoff_36(a0),d0
	bne.s	+
	move.b	#0,objoff_3A(a0)
+
	move.w	d0,x_pos(a0)
	bra.s	loc_2952C
; ===========================================================================

loc_29516:
	move.w	x_pos(a0),d0
	addq.w	#1,d0
	cmp.w	objoff_38(a0),d0
	bne.s	+
	move.b	#1,objoff_3A(a0)
+
	move.w	d0,x_pos(a0)

loc_2952C:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#8,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject).l, JmpTo6_PlatformObject
	rts
; ===========================================================================

loc_2953E:
	movea.l	objoff_40(a0),a1 ; a1=object
	move.w	x_pos(a0),d0
	subi.w	#$18,d0
	move.w	x_pos(a1),d2
	addi.w	#$18,d2
	cmp.w	d0,d2
	bne.s	+	; rts
	eori.b	#1,objoff_3A(a0)
	eori.b	#1,objoff_3A(a1)
+
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7A_MapUnc_29564:	BINCLUDE "mappings/sprite/obj7A.bin"
        even
; ===========================================================================

    if ~~removeJmpTos
JmpTo24_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo17_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo41_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo6_PlatformObject ; JmpTo
	jmp	(PlatformObject).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 7B - Warp pipe exit spring from CPZ
; ----------------------------------------------------------------------------
; Sprite_29590:
Obj7B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj7B_Index(pc,d0.w),d1
	jsr	Obj7B_Index(pc,d1.w)
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	(DisplaySprite).l, JmpTo25_DisplaySprite
; ===========================================================================
+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo40_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo25_DisplaySprite

    if removeJmpTos
JmpTo40_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; off_295C0:
Obj7B_Index:	offsetTable
		offsetTableEntry.w Obj7B_Init	; 0
		offsetTableEntry.w Obj7B_Main	; 2
; ===========================================================================
; byte_295C4:
Obj7B_Strengths:
	; Speed applied on Sonic
	dc.w -$1000
	dc.w  -$A80
; ===========================================================================
; loc_295C8:
Obj7B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj7B_MapUnc_29780,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZTubeSpring,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	subtype(a0),d0
	andi.w	#2,d0
	move.w	Obj7B_Strengths(pc,d0.w),objoff_34(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo42_Adjust2PArtPointer
; loc_295FE:
Obj7B_Main:
	cmpi.b	#1,mapping_frame(a0)
	beq.s	loc_29648
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsrto	(SolidObject_Always_SingleCharacter).l, JmpTo4_SolidObject_Always_SingleCharacter
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	jsr	loc_296C2
+
	movem.l	(sp)+,d1-d4
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsrto	(SolidObject_Always_SingleCharacter).l, JmpTo4_SolidObject_Always_SingleCharacter
	btst	#p2_standing_bit,status(a0)
	beq.s	loc_29648
	bsr.s	loc_296C2

loc_29648:
	move.w	x_pos(a0),d4
	move.w	d4,d5
	subi.w	#$10,d4
	addi.w	#$10,d5
	move.w	y_pos(a0),d2
	move.w	d2,d3
	addi.w	#$30,d3
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	d4,d0
	blo.s	loc_29686
	cmp.w	d5,d0
	bhs.s	loc_29686
	move.w	(MainCharacter+y_pos).w,d0
	cmp.w	d2,d0
	blo.s	loc_29686
	cmp.w	d3,d0
	bhs.s	loc_29686
	cmpi.b	#2,prev_anim(a0)
	beq.s	loc_29686
	move.b	#2,anim(a0)

loc_29686:
	move.w	(Sidekick+x_pos).w,d0
	cmp.w	d4,d0
	blo.s	loc_296B6
	cmp.w	d5,d0
	bhs.s	loc_296B6
	move.w	(Sidekick+y_pos).w,d0
	cmp.w	d2,d0
	blo.s	loc_296B6
	cmp.w	d3,d0
	bhs.s	loc_296B6
	cmpi.w	#4,(Tails_CPU_routine).w	; TailsCPU_Flying
	beq.w	loc_296B6
	cmpi.b	#3,prev_anim(a0)
	beq.s	loc_296B6
	move.b	#3,anim(a0)

loc_296B6:
	lea	(Ani_obj7B).l,a1
	jmpto	(AnimateSprite).l, JmpTo8_AnimateSprite
; ===========================================================================
	rts
; ===========================================================================

loc_296C2:
	move.w	#$100,anim(a0)
	addq.w	#4,y_pos(a1)
	move.w	objoff_34(a0),y_vel(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#AniIDSonAni_Spring,anim(a1)
	move.b	#2,routine(a1)
	move.b	subtype(a0),d0
	bpl.s	+
	move.w	#0,x_vel(a1)
+
	btst	#0,d0
	beq.s	loc_29736
	move.w	#1,inertia(a1)
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Walk,anim(a1)
	move.b	#0,flips_remaining(a1)
	move.b	#4,flip_speed(a1)
	btst	#1,d0
	bne.s	+
	move.b	#1,flips_remaining(a1)
+
	btst	#0,status(a1)
	beq.s	loc_29736
	neg.b	flip_angle(a1)
	neg.w	inertia(a1)

loc_29736:
	andi.b	#$C,d0
	cmpi.b	#4,d0
	bne.s	+
	move.b	#$C,top_solid_bit(a1)
	move.b	#$D,lrb_solid_bit(a1)
+
	cmpi.b	#8,d0
	bne.s	+
	move.b	#$E,top_solid_bit(a1)
	move.b	#$F,lrb_solid_bit(a1)
+
	move.w	#SndID_Spring,d0
	jmp	(PlaySound).l
; ===========================================================================
; animation script
; off_29768:
Ani_obj7B:	offsetTable
		offsetTableEntry.w byte_29770	; 0
		offsetTableEntry.w byte_29773	; 1
		offsetTableEntry.w byte_29777	; 2
		offsetTableEntry.w byte_29777	; 3
byte_29770:	dc.b  $F,  0,$FF
		rev02even
byte_29773:	dc.b   0,  3,$FD,  0
		rev02even
byte_29777:	dc.b   5,  1,  2,  2,  2,  4,$FD,  0
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7B_MapUnc_29780:	BINCLUDE "mappings/sprite/obj7B.bin"
             even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo25_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo40_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo8_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo42_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo4_SolidObject_Always_SingleCharacter ; JmpTo
	jmp	(SolidObject_Always_SingleCharacter).l

	align 4
    endif


