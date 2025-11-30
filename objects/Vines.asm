
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 7F - Vine switch that you hang off in MCZ
; ----------------------------------------------------------------------------
; Sprite_297E4:
Obj7F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj7F_Index(pc,d0.w),d1
	jmp	Obj7F_Index(pc,d1.w)
; ===========================================================================
; off_297F2:
Obj7F_Index:	offsetTable
		offsetTableEntry.w Obj7F_Init	; 0
		offsetTableEntry.w Obj7F_Main	; 2
; ===========================================================================
; loc_297F6:
Obj7F_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj7F_MapUnc_29938,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_VineSwitch,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#8,width_pixels(a0)
	move.b	#4,priority(a0)
; loc_2981E:
Obj7F_Main:
	lea	objoff_34(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1).w,d0
	bsr.s	Obj7F_Action
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d0
	bsr.s	Obj7F_Action
	jmpto	(MarkObjGone).l, JmpTo24_MarkObjGone
; ===========================================================================
; loc_2983C:
Obj7F_Action:
	tst.b	(a2)
	beq.s	loc_29890
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	return_29936
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#$12,2(a2)
	andi.w	#(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
	beq.s	+
	move.b	#$3C,2(a2)
+
	move.w	#-$300,y_vel(a1)
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	lea	(a3,d0.w),a3
	bclr	#0,(a3)
	move.b	#0,mapping_frame(a0)
	tst.w	objoff_34(a0)
	beq.s	+
	move.b	#1,mapping_frame(a0)
+
	jmp	return_29936
; ===========================================================================

loc_29890:
	tst.b	2(a2)
	beq.s	+
	subq.b	#1,2(a2)
	bne.w	return_29936
+
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$C,d0
	cmpi.w	#$18,d0
	bhs.w	return_29936
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	subi.w	#$28,d1
	cmpi.w	#$10,d1
	bhs.w	return_29936
	tst.b	obj_control(a1)
	bmi.s	return_29936
	cmpi.b	#4,routine(a1)
	bhs.s	return_29936
	tst.w	(Debug_placement_mode).w
	bne.s	return_29936
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$30,y_pos(a1)
	move.b	#AniIDSonAni_Hang2,anim(a1)
	move.b	#1,obj_control(a1)
	move.b	#1,(a2)
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	bset	#0,(a3,d0.w)
	move.w	#SndID_Blip,d0
	jsr	(PlaySound).l
	move.b	#0,mapping_frame(a0)
	tst.w	objoff_34(a0)
	beq.s	return_29936
	move.b	#1,mapping_frame(a0)

return_29936:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj7F_MapUnc_29938:	BINCLUDE "mappings/sprite/obj7F.bin"
            even
; ===========================================================================

    if ~~removeJmpTos
JmpTo24_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 80 - Vine that you hang off and it moves down from MCZ
; ----------------------------------------------------------------------------
; Sprite_2997C:
Obj80:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj80_Index(pc,d0.w),d1
	jmp	Obj80_Index(pc,d1.w)
; ===========================================================================
; off_2998A:
Obj80_Index:	offsetTable
		offsetTableEntry.w Obj80_Init		; 0 - Init
		offsetTableEntry.w Obj80_MCZ_Main	; 2 - MCZ Vine
		offsetTableEntry.w Obj80_WFZ_Main	; 4 - WFZ Hook
; ===========================================================================
; loc_29990:
Obj80_Init:
	addq.b	#2,routine(a0)
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	#$80,y_radius(a0)
	bset	#4,render_flags(a0)
	move.w	y_pos(a0),objoff_40(a0)
	cmpi.b	#wing_fortress_zone,(Current_Zone).w
	bne.s	Obj80_MCZ_Init
	addq.b	#2,routine(a0)
	move.l	#Obj80_MapUnc_29DD0,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_WfzHook_Fudge,1,0),art_tile(a0)
	move.w	#$A0,objoff_32(a0)
	move.b	subtype(a0),d0
	move.b	d0,d1
	andi.b	#$F,d0
	beq.s	+
	move.w	#$60,objoff_32(a0)
+
	move.b	subtype(a0),d0
	move.w	#2,objoff_3E(a0)
	andi.b	#$70,d1
	beq.s	+
	move.w	objoff_32(a0),d0
	move.w	d0,objoff_3C(a0)
	move.b	#1,objoff_3A(a0)
	add.w	d0,y_pos(a0)
	lsr.w	#4,d0
	addq.w	#1,d0
	move.b	d0,mapping_frame(a0)
+
	jmp	Obj80_WFZ_Main
; ===========================================================================
; loc_29A1C:
Obj80_MCZ_Init:
	move.l	#Obj80_MapUnc_29C64,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_VinePulley,3,0),art_tile(a0)
	move.w	#$B0,objoff_32(a0)
	move.b	subtype(a0),d0
	bpl.s	+
	move.b	#1,objoff_38(a0)
+
	move.w	#2,objoff_3E(a0)
	andi.b	#$70,d0
	beq.s	Obj80_MCZ_Main
	move.w	objoff_32(a0),d0
	move.w	d0,objoff_3C(a0)
	move.b	#1,objoff_3A(a0)
	add.w	d0,y_pos(a0)
	lsr.w	#5,d0
	addq.w	#1,d0
	move.b	d0,mapping_frame(a0)
; loc_29A66:
Obj80_MCZ_Main:
	tst.b	objoff_3A(a0)
	beq.s	loc_29A74
	tst.w	objoff_34(a0)
	bne.s	loc_29A8A
	bra.s	loc_29A7A
; ===========================================================================

loc_29A74:
	tst.w	objoff_34(a0)
	beq.s	loc_29A8A

loc_29A7A:
	move.w	objoff_3C(a0),d2
	cmp.w	objoff_32(a0),d2
	beq.s	loc_29AAE
	add.w	objoff_3E(a0),d2
	bra.s	loc_29A94
; ===========================================================================

loc_29A8A:
	move.w	objoff_3C(a0),d2
	beq.s	loc_29AAE
	sub.w	objoff_3E(a0),d2

loc_29A94:
	move.w	d2,objoff_3C(a0)
	move.w	objoff_40(a0),d0
	add.w	d2,d0
	move.w	d0,y_pos(a0)
	move.w	d2,d0
	beq.s	+
	lsr.w	#5,d0
	addq.w	#1,d0
+
	move.b	d0,mapping_frame(a0)

loc_29AAE:
	lea	objoff_34(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1).w,d0
	bsr.s	Obj80_Action
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d0
	bsr.s	Obj80_Action
	jmpto	(MarkObjGone).l, JmpTo25_MarkObjGone
; ===========================================================================
; loc_29ACC:
Obj80_Action:
	tst.b	(a2)
	beq.w	loc_29B5E
	tst.b	render_flags(a1)
	bpl.s	loc_29B42
	cmpi.b	#4,routine(a1)
	bhs.s	loc_29B42
	andi.b	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.w	loc_29B50
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#$12,2(a2)
	andi.w	#(button_up_mask|button_down_mask|button_left_mask|button_right_mask)<<8,d0
	beq.w	+
	move.b	#$3C,2(a2)
+
	btst	#(button_left+8),d0
	beq.s	+
	move.w	#-$200,x_vel(a1)
+
	btst	#(button_right+8),d0
	beq.s	+
	move.w	#$200,x_vel(a1)
+
	move.w	#-$380,y_vel(a1)
	bset	#1,status(a1)
	tst.b	objoff_38(a0)
	beq.s	+	; rts
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	lea	(a3,d0.w),a3
	bclr	#0,(a3)
+
	rts
; ===========================================================================

loc_29B42:
	clr.b	obj_control(a1)
	clr.b	(a2)
	move.b	#$3C,2(a2)
	rts
; ===========================================================================

loc_29B50:
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$94,y_pos(a1)
	rts
; ===========================================================================

loc_29B5E:
	tst.b	2(a2)
	beq.s	+
	subq.b	#1,2(a2)
	bne.w	return_29BF8
+
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.w	return_29BF8
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	subi.w	#$88,d1
	cmpi.w	#$18,d1
	bhs.w	return_29BF8
	tst.b	obj_control(a1)
	bmi.s	return_29BF8
	cmpi.b	#4,routine(a1)
	bhs.s	return_29BF8
	tst.w	(Debug_placement_mode).w
	bne.s	return_29BF8
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$94,y_pos(a1)
	move.b	#AniIDSonAni_Hang2,anim(a1)
	move.b	#1,obj_control(a1)
	move.b	#1,(a2)
	tst.b	objoff_38(a0)
	beq.s	return_29BF8
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	lea	(ButtonVine_Trigger).w,a3
	bset	#0,(a3,d0.w)
	move.w	#SndID_Blip,d0
	jsr	(PlaySound).l

return_29BF8:
	rts
; ===========================================================================
; loc_29BFA:
Obj80_WFZ_Main:
	tst.b	objoff_3A(a0)
	beq.s	loc_29C08
	tst.w	objoff_34(a0)
	bne.s	loc_29C1E
	bra.s	loc_29C0E
; ===========================================================================

loc_29C08:
	tst.w	objoff_34(a0)
	beq.s	loc_29C1E

loc_29C0E:
	move.w	objoff_3C(a0),d2
	cmp.w	objoff_32(a0),d2
	beq.s	loc_29C42
	add.w	objoff_3E(a0),d2
	bra.s	loc_29C28
; ===========================================================================

loc_29C1E:
	move.w	objoff_3C(a0),d2
	beq.s	loc_29C42
	sub.w	objoff_3E(a0),d2

loc_29C28:
	move.w	d2,objoff_3C(a0)
	move.w	objoff_40(a0),d0
	add.w	d2,d0
	move.w	d0,y_pos(a0)
	move.w	d2,d0
	beq.s	+
	lsr.w	#4,d0
	addq.w	#1,d0
+
	move.b	d0,mapping_frame(a0)

loc_29C42:
	lea	objoff_34(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	(Ctrl_1).w,d0
	jsr	Obj80_Action
	lea	(Sidekick).w,a1 ; a1=character
	addq.w	#1,a2
	move.w	(Ctrl_2).w,d0
	jsr	Obj80_Action
	jmpto	(MarkObjGone).l, JmpTo25_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj80_MapUnc_29C64:	BINCLUDE "mappings/sprite/obj80_a.bin"
              even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj80_MapUnc_29DD0:	BINCLUDE "mappings/sprite/obj80_b.bin"
            even
; ===========================================================================

    if ~~removeJmpTos
JmpTo25_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 81 - Drawbridge (MCZ)
; ----------------------------------------------------------------------------
; Sprite_2A000:
Obj81:
	btst	#6,render_flags(a0)
	bne.w	+
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj81_Index(pc,d0.w),d1
	jmp	Obj81_Index(pc,d1.w)
; ===========================================================================
+
	move.w	#$280,d0
	jmpto	(DisplaySprite3).l, JmpTo2_DisplaySprite3
; ===========================================================================
; off_2A020:
Obj81_Index:	offsetTable
		offsetTableEntry.w Obj81_Init		; 0
		offsetTableEntry.w Obj81_BridgeUp	; 2
		offsetTableEntry.w loc_2A18A		; 4
; ===========================================================================
; loc_2A026:
Obj81_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj81_MapUnc_2A24E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#5,priority(a0)
	move.b	#8,width_pixels(a0)
	ori.b	#$80,status(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_36(a0)
	subi.w	#$48,y_pos(a0)
	move.b	#-$40,angle(a0)
	moveq	#-$10,d4
	btst	#1,status(a0)
	beq.s	+
	addi.w	#$90,y_pos(a0)
	move.b	#$40,angle(a0)
	neg.w	d4
+
	move.w	#$100,d1
	btst	#0,status(a0)
	beq.s	+
	neg.w	d1
+
	move.w	d1,objoff_38(a0)
	jsrto	(SingleObjLoad2).l, JmpTo18_SingleObjLoad2
	bne.s	Obj81_BridgeUp
	move.l	(a0),(a1) ; load obj81
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$40,mainspr_width(a1)
	move.w	objoff_34(a0),d2
	move.w	objoff_36(a0),d3
	moveq	#8,d1
	move.b	d1,mainspr_childsprites(a1)
	subq.w	#1,d1
	lea	sub2_x_pos(a1),a2

-	add.w	d4,d3
	move.w	d2,(a2)+	; sub?_x_pos
	move.w	d3,(a2)+	; sub?_y_pos
	move.w	#1,(a2)+	; sub?_mapframe
	dbf	d1,-

	move.w	sub6_x_pos(a1),x_pos(a1)
	move.w	sub6_y_pos(a1),y_pos(a1)
	move.l	a1,objoff_40(a0)
	move.b	#$40,mainspr_height(a1)
	bset	#4,render_flags(a1)
; loc_2A0FE:
Obj81_BridgeUp:
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	btst	#0,(a2,d0.w)
	beq.s	+
	tst.b	objoff_3A(a0)
	bne.s	+
	move.b	#1,objoff_3A(a0)
	move.w	#SndID_DrawbridgeMove,d0
	jsr	(PlaySoundStereo).l
	cmpi.b	#$81,status(a0)
	bne.s	+
	move.w	objoff_34(a0),x_pos(a0)
	subi.w	#$48,x_pos(a0)
+
	tst.b	objoff_3A(a0)
	beq.s	loc_2A188
	move.w	#$48,d1
	tst.b	angle(a0)
	beq.s	loc_2A154
	cmpi.b	#$80,angle(a0)
	bne.s	loc_2A180
	neg.w	d1

loc_2A154:
	move.w	objoff_36(a0),y_pos(a0)
	move.w	objoff_34(a0),x_pos(a0)
	add.w	d1,x_pos(a0)
	move.b	#$40,width_pixels(a0)
	move.b	#0,objoff_3A(a0)
	move.w	#SndID_DrawbridgeDown,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)
	bra.s	loc_2A188
; ===========================================================================

loc_2A180:
	move.w	objoff_38(a0),d0
	add.w	d0,angle(a0)

loc_2A188:
	bsr.s	loc_2A1EA

loc_2A18A:
	move.w	#$13,d1
	move.w	#$40,d2
	move.w	#$41,d3
	move.b	angle(a0),d0
	beq.s	loc_2A1A8
	cmpi.b	#$40,d0
	beq.s	loc_2A1B4
	cmpi.b	#-$40,d0
	bhs.s	loc_2A1B4

loc_2A1A8:
	move.w	#$4B,d1
	move.w	#8,d2
	move.w	#9,d3

loc_2A1B4:
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo22_SolidObject
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	(DisplaySprite).l, JmpTo26_DisplaySprite
; ---------------------------------------------------------------------------
+
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	+
	jmpto	(DisplaySprite).l, JmpTo26_DisplaySprite
; ---------------------------------------------------------------------------
+
	movea.l	objoff_40(a0),a1 ; a1=object
	jsrto	(DeleteObject2).l, JmpTo3_DeleteObject2
	jmpto	(DeleteObject).l, JmpTo41_DeleteObject
; ===========================================================================

loc_2A1EA:
	tst.b	objoff_3A(a0)
	beq.s	return_2A24C
	moveq	#0,d0
	moveq	#0,d1
	move.b	angle(a0),d0
	jsrto	(CalcSine).l, JmpTo9_CalcSine
	move.w	objoff_36(a0),d2
	move.w	objoff_34(a0),d3
	moveq	#0,d6
	movea.l	objoff_40(a0),a1 ; a1=object
	move.b	mainspr_childsprites(a1),d6
	subq.w	#1,d6
	bcs.s	return_2A24C
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
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

	move.w	sub6_x_pos(a1),x_pos(a1)
	move.w	sub6_y_pos(a1),y_pos(a1)

return_2A24C:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj81_MapUnc_2A24E:	BINCLUDE "mappings/sprite/obj81.bin"
        even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo26_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo41_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo3_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo18_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo9_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo22_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif


