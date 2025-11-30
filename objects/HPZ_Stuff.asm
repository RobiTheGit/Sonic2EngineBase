



; ===========================================================================
; ----------------------------------------------------------------------------
; Object 0C - Small floating platform (unused)
; (used in CPZ in the Nick Arcade prototype)
; ----------------------------------------------------------------------------
; Sprite_20210:
Obj0C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0C_Index(pc,d0.w),d1
	jmp	Obj0C_Index(pc,d1.w)
; ===========================================================================
; off_2021E
Obj0C_Index:	offsetTable
		offsetTableEntry.w Obj0C_Init	; 0
		offsetTableEntry.w Obj0C_Main	; 2
; ===========================================================================
; loc_20222:
Obj0C_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj0C_MapUnc_202FA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_FloatPlatform,3,1),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,objoff_3E(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F0,d0
	addi.w	#$10,d0
	move.w	d0,d1
	subq.w	#1,d0
	move.w	d0,objoff_34(a0)
	move.w	d0,objoff_36(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	move.b	d0,objoff_42(a0)
	move.b	d0,objoff_43(a0)
; loc_20282:
Obj0C_Main:
	move.b	objoff_40(a0),d0
	beq.s	loc_202C0
	cmpi.b	#$80,d0
	bne.s	loc_202D0
	move.b	objoff_41(a0),d1
	bne.s	loc_202A2
	subq.b	#1,objoff_42(a0)
	bpl.s	loc_202A2
	move.b	objoff_43(a0),objoff_42(a0)
	bra.s	loc_202D0
; ===========================================================================

loc_202A2:
	addq.b	#1,objoff_41(a0)
	move.b	d1,d0
	jsrto	(CalcSine).l, JmpTo5_CalcSine
	addi.w	#8,d0
	asr.w	#6,d0
	subi.w	#$10,d0
	add.w	objoff_3E(a0),d0
	move.w	d0,y_pos(a0)
	bra.s	loc_202E6
; ===========================================================================

loc_202C0:
	move.w	(Vint_runcount+2).w,d1
	andi.w	#$3FF,d1
	bne.s	loc_202D4
	move.b	#1,objoff_41(a0)

loc_202D0:
	addq.b	#1,objoff_40(a0)

loc_202D4:
	jsrto	(CalcSine).l, JmpTo5_CalcSine
	addi.w	#8,d1
	asr.w	#4,d1
	add.w	objoff_3E(a0),d1
	move.w	d1,y_pos(a0)

loc_202E6:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#9,d3
	move.w	x_pos(a0),d4
	bsr.w	PlatformObject
	jmpto	(MarkObjGone).l, JmpTo4_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Unused sprite mappings
; ----------------------------------------------------------------------------
Obj0C_MapUnc_202FA:	BINCLUDE "mappings/sprite/obj0C.bin"
         even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo4_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo5_CalcSine ; JmpTo
	jmp	(CalcSine).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 12 - Emerald from Hidden Palace Zone (unused)
; ----------------------------------------------------------------------------
; Sprite_2031C:
Obj12:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj12_Index(pc,d0.w),d1
	jmp	Obj12_Index(pc,d1.w)
; ===========================================================================
; off_2032A
Obj12_Index:	offsetTable
		offsetTableEntry.w Obj12_Init	; 0
		offsetTableEntry.w Obj12_Main	; 2
; ===========================================================================
; loc_2032E:
Obj12_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj12_MapUnc_20382,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZ_Emerald,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#4,priority(a0)
; loc_20356:
Obj12_Main:
	move.w	#$20,d1
	move.w	#$10,d2
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo16_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo8_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings (unused)
; -------------------------------------------------------------------------------
Obj12_MapUnc_20382:	BINCLUDE "mappings/sprite/obj12.bin"
           even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo8_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo16_DeleteObject ; JmpTo
	jmp	(DeleteObject).l

	align 4
    else
JmpTo16_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 13 - Waterfall in Hidden Palace Zone (unused)
; ----------------------------------------------------------------------------
; Sprite_203AC:
Obj13:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj13_Index(pc,d0.w),d1
	jmp	Obj13_Index(pc,d1.w)
; ===========================================================================
; off_203BA
Obj13_Index:	offsetTable
		offsetTableEntry.w Obj13_Init	; 0
		offsetTableEntry.w Obj13_Main	; 2
		offsetTableEntry.w Obj13_ChkDel	; 4
; ===========================================================================
; loc_203C0:
Obj13_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj13_MapUnc_20528,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZ_Waterfall,3,1),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	#$12,mapping_frame(a0)
	bsr.s	Obj13_LoadSubObject
	move.b	#$A0,y_radius(a1)
	bset	#4,render_flags(a1)
	move.l	a1,objoff_3C(a0)
	move.w	y_pos(a0),objoff_38(a0)
	move.w	y_pos(a0),objoff_3A(a0)
	cmpi.b	#$10,subtype(a0)
	blo.s	loc_2046C
	bsr.s	Obj13_LoadSubObject
	move.l	a1,objoff_40(a0)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$98,y_pos(a1)
	bra.s	loc_2046C
; ===========================================================================
; loc_20428:
Obj13_LoadSubObject:
	jsr	(SingleObjLoad2).l
	bne.s	+	; rts
	move.l	#Obj13,(a1) ; load obj13
	addq.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	#Obj13_MapUnc_20528,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZ_Waterfall,3,1),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#1,priority(a1)
+	rts
; ===========================================================================

loc_2046C:
	moveq	#0,d1
	move.b	subtype(a0),d1
	move.w	objoff_38(a0),d0
	subi.w	#$78,d0
	lsl.w	#4,d1
	add.w	d1,d0
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_38(a0)
; loc_20486:
Obj13_Main:
	movea.l	objoff_3C(a0),a1 ; a1=object
	move.b	#$12,mapping_frame(a0)
	move.w	objoff_38(a0),d0
	move.w	(Water_Level_1).w,d1
	cmp.w	d0,d1
	bhs.s	+
	move.w	d1,d0
+
	move.w	d0,y_pos(a0)
	sub.w	objoff_3A(a0),d0
	addi.w	#$80,d0
	bmi.s	loc_204F0
	lsr.w	#4,d0
	move.w	d0,d1
	cmpi.w	#$F,d0
	blo.s	+
	moveq	#$F,d0
+
	move.b	d0,mapping_frame(a1)
	cmpi.b	#$10,subtype(a0)
	blo.s	loc_204D8
	movea.l	objoff_40(a0),a1 ; a1=object
	subi.w	#$F,d1
	bcc.s	+
	moveq	#0,d1
+
	addi.w	#$13,d1
	move.b	d1,mapping_frame(a1)

loc_204D8:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo17_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo9_DisplaySprite
; ===========================================================================

loc_204F0:
	moveq	#$13,d0
	move.b	d0,mapping_frame(a0)
	move.b	d0,mapping_frame(a1)
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo17_DeleteObject
	rts
; ===========================================================================
; loc_20510:
Obj13_ChkDel:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo17_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo9_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings (unused)
; -------------------------------------------------------------------------------
Obj13_MapUnc_20528:	BINCLUDE "mappings/sprite/obj13.bin"
          even
; ===========================================================================

    if ~~removeJmpTos
JmpTo9_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo17_DeleteObject ; JmpTo
	jmp	(DeleteObject).l

	align 4
    else
JmpTo17_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif


