
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 73 - Solid rotating ring thing from Mystic Cave Zone
; (unused, but can be seen in debug mode)
; ----------------------------------------------------------------------------
; Sprite_289D4:
Obj73:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj73_Index(pc,d0.w),d1
	jmp	Obj73_Index(pc,d1.w)
; ===========================================================================
; off_289E2:
Obj73_Index:	offsetTable
		offsetTableEntry.w Obj73_Init		; 0
		offsetTableEntry.w Obj73_Main		; 2
		offsetTableEntry.w Obj73_SubObject	; 4
; ===========================================================================
; loc_289E8:
Obj73_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj73_MapUnc_28B9C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a0)

	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	x_pos(a0),objoff_3E(a0)
	move.w	y_pos(a0),objoff_3C(a0)
	move.b	#0,collision_flags(a0)
	bset	#7,status(a0)
	move.b	subtype(a0),d1
	andi.b	#$F0,d1
	ext.w	d1
	asl.w	#3,d1
	move.w	d1,objoff_42(a0)
	move.b	status(a0),d0
	ror.b	#2,d0
	andi.b	#$C0,d0
	move.b	d0,angle(a0)
	lea	objoff_2D(a0),a2
	move.b	subtype(a0),d1
	andi.w	#7,d1
	move.b	#0,(a2)+
	move.w	d1,d3
	lsl.w	#4,d3
	move.b	d3,objoff_40(a0)
	subq.w	#1,d1
	bcs.s	Obj73_LoadSubObject_End
	btst	#3,subtype(a0)
	beq.s	Obj73_LoadSubObject
	subq.w	#1,d1
	bcs.s	Obj73_LoadSubObject_End
; loc_28A6E:
Obj73_LoadSubObject:
	jsrto	(SingleObjLoad).l, JmpTo9_SingleObjLoad
	bne.s	Obj73_LoadSubObject_End
	addq.b	#1,objoff_2D(a0)
	move.w	a1,d5
	subi.w	#Object_RAM,d5
    if object_size=$40
	lsr.w	#6,d5
    else
	divu.w	#object_size,d5
    endif
	andi.w	#$7F,d5
	move.b	d5,(a2)+
	move.b	#4,routine(a1)
	move.l	(a0),(a1) ; load obj73
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	priority(a0),priority(a1)
	move.b	width_pixels(a0),width_pixels(a1)
	move.b	collision_flags(a0),collision_flags(a1)
	move.b	status(a0),status(a1)
	subi.b	#$10,d3
	move.b	d3,objoff_40(a1)
	dbf	d1,Obj73_LoadSubObject
; loc_28AC8:
Obj73_LoadSubObject_End:

	move.w	a0,d5
	subi.w	#Object_RAM,d5
    if object_size=$40
	lsr.w	#6,d5
    else
	divu.w	#object_size,d5
    endif
	andi.w	#$7F,d5
	move.b	d5,(a2)+
; loc_28AD6:
Obj73_Main:
	move.w	x_pos(a0),-(sp)
	jsr	loc_28AF4
	move.w	#8,d1
	move.w	#8,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo17_SolidObject
	jmp	loc_28B46
; ===========================================================================

loc_28AF4:
	move.w	objoff_42(a0),d0
	add.w	d0,angle(a0)
	move.b	angle(a0),d0
	jsr	(CalcSine).l
	move.w	objoff_3C(a0),d2
	move.w	objoff_3E(a0),d3
	lea	objoff_2D(a0),a2
	moveq	#0,d6
	move.b	(a2)+,d6

loc_28B16:
	moveq	#0,d4
	move.b	(a2)+,d4
    if object_size=$40
	lsl.w	#6,d4
    else
	mulu.w	#object_size,d4
    endif
	addi.l	#Object_RAM,d4
	movea.l	d4,a1 ; a1=object
	moveq	#0,d4
	move.b	objoff_40(a1),d4
	move.l	d4,d5
	muls.w	d0,d4
	asr.l	#8,d4
	muls.w	d1,d5
	asr.l	#8,d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d4,y_pos(a1)
	move.w	d5,x_pos(a1)
	dbf	d6,loc_28B16
	rts
; ===========================================================================

loc_28B46:
	move.w	objoff_3E(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	+
	jmpto	(DisplaySprite).l, JmpTo21_DisplaySprite
; ===========================================================================
+
	moveq	#0,d2
	lea	objoff_2D(a0),a2

	move.b	(a2)+,d2
-	moveq	#0,d0
	move.b	(a2)+,d0
    if object_size=$40
	lsl.w	#6,d0
    else
	mulu.w	#object_size,d0
    endif
	addi.l	#Object_RAM,d0
	movea.l	d0,a1	; a1=object
	jsrto	(DeleteObject2).l, JmpTo_DeleteObject2
	dbf	d2,-
	rts
; ===========================================================================
; loc_28B7E:
Obj73_SubObject:
	move.w	#8,d1
	move.w	#8,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	objoff_3A(a0),d4
	jsrto	(SolidObject).l, JmpTo17_SolidObject
	move.w	x_pos(a0),objoff_3A(a0)
	jmpto	(DisplaySprite).l, JmpTo21_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj73_MapUnc_28B9C:	BINCLUDE "mappings/sprite/obj73.bin"
        even
; ===========================================================================

    if ~~removeJmpTos
JmpTo21_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo9_SingleObjLoad ; JmpTo
	jmp	(SingleObjLoad).l
JmpTo_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo37_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo17_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 75 - Brick from MCZ
; ----------------------------------------------------------------------------
; Sprite_28BC8:
Obj75:
	btst	#6,render_flags(a0)
	bne.w	+
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj75_Index(pc,d0.w),d1
	jmp	Obj75_Index(pc,d1.w)
; ===========================================================================
+
	move.w	#$280,d0
	jmpto	(DisplaySprite3).l, JmpTo_DisplaySprite3
; ===========================================================================
; off_28BE8:
Obj75_Index:	offsetTable
		offsetTableEntry.w Obj75_Init	; 0
		offsetTableEntry.w Obj75_Main	; 2
		offsetTableEntry.w loc_28D6C	; 4
; ===========================================================================
; loc_28BEE:
Obj75_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj75_MapUnc_28D8A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,1,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo38_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#5,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_36(a0)
	move.b	subtype(a0),d1
	move.b	d1,d0
	andi.w	#$F,d1
	andi.b	#$F0,d0
	ext.w	d0
	asl.w	#3,d0
	move.w	d0,objoff_38(a0)
	move.b	status(a0),d0
	ror.b	#2,d0
	andi.b	#$C0,d0
	move.b	d0,angle(a0)
	cmpi.b	#$F,d1
	bne.s	+
	addq.b	#2,routine(a0)
	move.b	#4,priority(a0)
	move.b	#2,mapping_frame(a0)
	rts
; ===========================================================================
+
	move.b	#$9A,collision_flags(a0)
	jsrto	(SingleObjLoad2).l, JmpTo15_SingleObjLoad2
	bne.s	Obj75_Main
	move.l	(a0),(a1) ; load obj75
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$40,mainspr_width(a1)
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	move.b	d1,mainspr_childsprites(a1)
	subq.w	#1,d1
	lea	sub2_x_pos(a1),a2

-	move.w	d2,(a2)+	; sub?_x_pos
	move.w	d3,(a2)+	; sub?_y_pos
	move.w	#1,(a2)+	; sub?_mapframe
	dbf	d1,-

	move.w	d2,x_pos(a1)
	move.w	d3,y_pos(a1)
	move.b	#0,mainspr_mapframe(a1)
	move.l	a1,objoff_40(a0)
	move.b	#$40,mainspr_height(a1)
	bset	#4,render_flags(a1)
; loc_28CCA:
Obj75_Main:
	moveq	#0,d0
	moveq	#0,d1
	move.w	objoff_38(a0),d0
	add.w	d0,angle(a0)
	move.b	angle(a0),d0
	jsrto	(CalcSine).l, JmpTo8_CalcSine
	move.w	objoff_36(a0),d2
	move.w	objoff_34(a0),d3
	moveq	#0,d6
	movea.l	objoff_40(a0),a1 ; a1=object
	move.b	mainspr_childsprites(a1),d6
	subq.w	#1,d6
	bcs.s	loc_28D3E
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	moveq	#0,d4
	moveq	#0,d5
	lea	sub2_x_pos(a1),a2

-	movem.l	d4-d5,-(sp)
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,(a2)+	; sub?_x_pos
	move.w	d4,(a2)+	; sub?_y_pos
	movem.l	(sp)+,d4-d5
	add.l	d0,d4
	add.l	d1,d5
	addq.w	#next_subspr-4,a2
	dbf	d6,-

	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,x_pos(a0)
	move.w	d4,y_pos(a0)
	move.w	sub6_x_pos(a1),x_pos(a1)
	move.w	sub6_y_pos(a1),y_pos(a1)

loc_28D3E:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	(DisplaySprite).l, JmpTo22_DisplaySprite
; ===========================================================================
+
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	+
	jmpto	(DisplaySprite).l, JmpTo22_DisplaySprite
; ===========================================================================
+
	movea.l	objoff_40(a0),a1 ; a1=object
	jsrto	(DeleteObject2).l, JmpTo2_DeleteObject2
	jmpto	(DeleteObject).l, JmpTo38_DeleteObject
; ===========================================================================

loc_28D6C:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo18_SolidObject
	jmpto	(MarkObjGone).l, JmpTo22_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj75_MapUnc_28D8A:	BINCLUDE "mappings/sprite/obj75.bin"
         even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo22_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo38_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo22_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo2_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo15_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo38_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo8_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo18_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 76 - Spike block that slides out of the wall from MCZ
; ----------------------------------------------------------------------------
sliding_spikes_remaining_movement = objoff_3A
; Sprite_28DF8:
Obj76:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj76_Index(pc,d0.w),d1
	jmp	Obj76_Index(pc,d1.w)
; ===========================================================================
; off_28E06:
Obj76_Index:	offsetTable
		offsetTableEntry.w Obj76_Init	; 0
		offsetTableEntry.w Obj76_Main	; 2
; ===========================================================================
; byte_28E0A:
Obj76_InitData:
	dc.b $40	; width_pixels
	dc.b $10	; y_radius
	dc.b   0	; mapping_frame
	even
; ===========================================================================
; loc_28E0E:
Obj76_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj76_MapUnc_28F3A,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo39_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0	; this is always 0 in the original layouts...
	lsr.w	#2,d0
	andi.w	#$1C,d0
	lea	Obj76_InitData(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,y_radius(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.w	x_pos(a0),objoff_38(a0)
	move.w	y_pos(a0),objoff_34(a0)
	andi.w	#$F,subtype(a0)
; loc_28E5E:
Obj76_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	Obj76_Modes(pc,d0.w),d1
	jsr	Obj76_Modes(pc,d1.w)
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	loc_28EC2
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	(SolidObject).l, JmpTo19_SolidObject
	swap	d6
	andi.w	#touch_side_mask,d6
	beq.s	loc_28EC2
	move.b	d6,d0
	andi.b	#p1_touch_side,d0
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	jsrto	(Touch_ChkHurt2).l, JmpTo_Touch_ChkHurt2
	bclr	#p1_pushing_bit,status(a0)
+
	andi.b	#p2_touch_side,d6
	beq.s	loc_28EC2
	lea	(Sidekick).w,a1 ; a1=character
	jsrto	(Touch_ChkHurt2).l, JmpTo_Touch_ChkHurt2
	bclr	#p2_pushing_bit,status(a0)

loc_28EC2:
	move.w	objoff_38(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo5_MarkObjGone2
; ===========================================================================
; off_28ECA:
Obj76_Modes:	offsetTable
		offsetTableEntry.w Obj76_CheckPlayers	; 0
		offsetTableEntry.w Obj76_SlideOut	; 2
; ===========================================================================
; loc_28ECE:
Obj76_CheckPlayers:
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	Obj76_CheckPlayer
	lea	(Sidekick).w,a1 ; a1=character
; loc_28ED8:
Obj76_CheckPlayer:
	btst	#1,status(a1)
	bne.s	++	; rts
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$C0,d0
	btst	#0,status(a0)
	beq.s	+
	subi.w	#$100,d0
+
	cmpi.w	#$80,d0
	bhs.s	+	; rts
	move.w	y_pos(a1),d0
	sub.w	y_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.s	+	; rts
	move.b	#2,subtype(a0)
	move.w	#$80,sliding_spikes_remaining_movement(a0)
+	rts
; ===========================================================================
; loc_28F1E:
Obj76_SlideOut:
	tst.w	sliding_spikes_remaining_movement(a0)
	beq.s	++	; rts
	subq.w	#1,sliding_spikes_remaining_movement(a0)
	moveq	#-1,d0
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
+	add.w	d0,x_pos(a0)
+	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj76_MapUnc_28F3A:	BINCLUDE "mappings/sprite/obj76.bin"
             even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_Touch_ChkHurt2 ; JmpTo
	jmp	(Touch_ChkHurt2).l
JmpTo39_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo19_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo5_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 77 - Bridge from MCZ
; ----------------------------------------------------------------------------
; Sprite_28F88:
Obj77:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj77_Index(pc,d0.w),d1
	jmp	Obj77_Index(pc,d1.w)
; ===========================================================================
; off_28F96:
Obj77_Index:	offsetTable
		offsetTableEntry.w Obj77_Init	; 0
		offsetTableEntry.w Obj77_Main	; 2
; ===========================================================================
; loc_28F9A:
Obj77_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj77_MapUnc_29064,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo40_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$80,width_pixels(a0)
; loc_28FBC:
Obj77_Main:
	tst.b	objoff_38(a0)
	bne.s	+
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	btst	#0,(a2,d0.w)
	beq.s	+
	move.b	#1,objoff_38(a0)
	bchg	#0,anim(a0)
	tst.b	render_flags(a0)
	bpl.s	+
	move.w	#SndID_DoorSlam,d0
	jsr	(PlaySound).l
+
	lea	(Ani_obj77).l,a1
	jsr	(AnimateSprite).l
	tst.b	mapping_frame(a0)
	bne.s	Obj77_DropCharacters
	move.w	#$4B,d1
	move.w	#8,d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo20_SolidObject
	jmpto	(MarkObjGone).l, JmpTo23_MarkObjGone
; ===========================================================================

; Check if the characters are standing on it. If a character is standing on the
; bridge, the "standing on object" flag is cleared so that it falls.

; loc_2901A:
Obj77_DropCharacters:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+++
	move.b	d0,d1
	andi.b	#p1_standing,d0
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#3,status(a1)
+
	andi.b	#p2_standing,d1
	beq.s	+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#3,status(a1)
+
	andi.b	#~standing_mask,status(a0)
+
	jmpto	(MarkObjGone).l, JmpTo23_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; animation script
; ----------------------------------------------------------------------------
; off_29050:
Ani_obj77:	offsetTable
		offsetTableEntry.w Ani_obj77_Close	; 0
		offsetTableEntry.w Ani_obj77_Open	; 1
; byte_29054:
Ani_obj77_Close:
	dc.b   3,  4,  3,  2,  1,  0,$FE,  1
; byte_2905C:
Ani_obj77_Open:
	dc.b   3,  0,  1,  2,  3,  4,$FE,  1
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj77_MapUnc_29064:	BINCLUDE "mappings/sprite/obj77.bin"
          even
; ===========================================================================

    if ~~removeJmpTos
JmpTo23_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo40_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo20_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif
