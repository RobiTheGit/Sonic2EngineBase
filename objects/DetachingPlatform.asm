

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 82 - Platform that is usually swinging, from ARZ
; ----------------------------------------------------------------------------
; Sprite_2A290:
Obj82:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj82_Index(pc,d0.w),d1
	jmp	Obj82_Index(pc,d1.w)
; ===========================================================================
; off_2A29E:
Obj82_Index:	offsetTable
		offsetTableEntry.w Obj82_Init	; 0
		offsetTableEntry.w Obj82_Main	; 2
; ===========================================================================
; byte_2A2A2:
Obj82_Properties:
	;    width_pixels
	;        y_radius
	dc.b $20,  8	; 0
	dc.b $1C,$30	; 2
	; Unused and broken; these don't have an associated frame, so using them crashes the game
	dc.b $10,$10	; 4
	dc.b $10,$10	; 6
; ===========================================================================
; loc_2A2AA:
Obj82_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj82_MapUnc_2A476,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo46_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$E,d0
	lea	Obj82_Properties(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2),y_radius(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	move.w	x_pos(a0),objoff_38(a0)
	move.w	y_pos(a0),objoff_34(a0)
	move.b	subtype(a0),d0
	andi.b	#$F,d0
	beq.s	+
	cmpi.b	#7,d0
	beq.s	+
	move.b	#1,objoff_3C(a0)
+
	andi.b	#$F,subtype(a0)
; loc_2A312:
Obj82_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	add.w	d0,d0
	move.w	Obj82_Types(pc,d0.w),d1
	jsr	Obj82_Types(pc,d1.w)
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	+

	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	(SolidObject).l, JmpTo23_SolidObject
	swap	d6
	move.b	d6,objoff_43(a0)
	jsr	loc_2A432
+
	move.w	objoff_38(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo7_MarkObjGone2
; ===========================================================================
; off_2A358:
Obj82_Types:	offsetTable
		offsetTableEntry.w return_2A368	; 0
		offsetTableEntry.w loc_2A36A	; 1
		offsetTableEntry.w loc_2A392	; 2
		offsetTableEntry.w loc_2A36A	; 3
		offsetTableEntry.w loc_2A3B6	; 4
		offsetTableEntry.w loc_2A3D8	; 5
		offsetTableEntry.w loc_2A392	; 6
		offsetTableEntry.w loc_2A3EC	; 7
; ===========================================================================

return_2A368:
	rts
; ===========================================================================

loc_2A36A:
	tst.w	objoff_3A(a0)
	bne.s	loc_2A382
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_2A380
	move.w	#$1E,objoff_3A(a0)

return_2A380:
	rts
; ===========================================================================

loc_2A382:
	subq.w	#1,objoff_3A(a0)
	bne.s	return_2A380
	addq.b	#1,subtype(a0)
	clr.b	objoff_3C(a0)
	rts
; ===========================================================================

loc_2A392:
	jsrto	(ObjectMove).l, JmpTo16_ObjectMove
	addi.w	#8,y_vel(a0)
	jsrto	(ObjCheckFloorDist).l, JmpTo2_ObjCheckFloorDist
	tst.w	d1
	bpl.w	return_2A3B4
	addq.w	#1,d1
	add.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	clr.b	subtype(a0)

return_2A3B4:
	rts
; ===========================================================================

loc_2A3B6:
	jsrto	(ObjectMove).l, JmpTo16_ObjectMove
	subi.w	#8,y_vel(a0)
	jsrto	(ObjCheckCeilingDist).l, JmpTo_ObjCheckCeilingDist
	tst.w	d1
	bpl.w	return_2A3D6
	sub.w	d1,y_pos(a0)
	clr.w	y_vel(a0)
	clr.b	subtype(a0)

return_2A3D6:
	rts
; ===========================================================================

loc_2A3D8:
	move.b	objoff_43(a0),d0
	andi.b	#3,d0
	beq.s	return_2A3EA
	addq.b	#1,subtype(a0)
	clr.b	objoff_3C(a0)

return_2A3EA:
	rts
; ===========================================================================

loc_2A3EC:
	move.w	(Water_Level_1).w,d0
	sub.w	y_pos(a0),d0
	beq.s	return_2A430
	bcc.s	loc_2A414
	cmpi.w	#-2,d0
	bge.s	loc_2A400
	moveq	#-2,d0

loc_2A400:
	add.w	d0,y_pos(a0)
	jsrto	(ObjCheckCeilingDist).l, JmpTo_ObjCheckCeilingDist
	tst.w	d1
	bpl.w	return_2A412
	sub.w	d1,y_pos(a0)

return_2A412:
	rts
; ===========================================================================

loc_2A414:
	cmpi.w	#2,d0
	ble.s	loc_2A41C
	moveq	#2,d0

loc_2A41C:
	add.w	d0,y_pos(a0)
	jsrto	(ObjCheckFloorDist).l, JmpTo2_ObjCheckFloorDist
	tst.w	d1
	bpl.w	return_2A430
	addq.w	#1,d1
	add.w	d1,y_pos(a0)

return_2A430:
	rts
; ===========================================================================

loc_2A432:
	tst.b	objoff_3C(a0)
	beq.s	return_2A474
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	loc_2A44E
	tst.b	objoff_42(a0)
	beq.s	return_2A474
	subq.b	#4,objoff_42(a0)
	bra.s	loc_2A45A
; ===========================================================================

loc_2A44E:
	cmpi.b	#$40,objoff_42(a0)
	beq.s	return_2A474
	addq.b	#4,objoff_42(a0)

loc_2A45A:
	move.b	objoff_42(a0),d0
	jsr	(CalcSine).l
	move.w	#$400,d1
	muls.w	d1,d0
	swap	d0
	add.w	objoff_34(a0),d0
	move.w	d0,y_pos(a0)

return_2A474:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj82_MapUnc_2A476:	BINCLUDE "mappings/sprite/obj82.bin"
    even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_ObjCheckFloorDist ; JmpTo
	jmp	(ObjCheckFloorDist).l
JmpTo46_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_ObjCheckCeilingDist ; JmpTo
	jmp	(ObjCheckCeilingDist).l
JmpTo23_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo7_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l
; loc_2A4F6:
JmpTo16_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 83 - 3 adjoined platforms from ARZ that rotate in a circle
; ----------------------------------------------------------------------------
; OST Variables:
Obj83_last_x_pos	= objoff_30	; word
Obj83_speed		= objoff_32	; word
Obj83_initial_x_pos	= objoff_34	; word
Obj83_initial_y_pos	= objoff_36	; word
; Child object RAM pointers
Obj83_childobjptr_chains	= objoff_38	; longword	; chain multisprite object
Obj83_childobjptr_platform2	= objoff_3C	; longword	; 2nd platform object (parent object is 1st platform)
Obj83_childobjptr_platform3	= objoff_40	; longword	; 3rd platform object

; Sprite_2A4FC:
Obj83:
	btst	#6,render_flags(a0)
	bne.w	.isMultispriteObject
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj83_Index(pc,d0.w),d1
	jmp	Obj83_Index(pc,d1.w)
; ===========================================================================
.isMultispriteObject:
	move.w	#$280,d0
	jmpto	(DisplaySprite3).l, JmpTo3_DisplaySprite3
; ===========================================================================
; off_2A51C:
Obj83_Index:	offsetTable
		offsetTableEntry.w Obj83_Init			; 0
		offsetTableEntry.w Obj83_Main			; 2
		offsetTableEntry.w Obj83_PlatformSubObject	; 4
; ===========================================================================
; loc_2A522:
Obj83_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj15_Obj83_MapUnc_1021E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo47_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$20,width_pixels(a0)
	move.w	x_pos(a0),Obj83_initial_x_pos(a0)
	move.w	y_pos(a0),Obj83_initial_y_pos(a0)

	; Setup subtype variables (rotation speed and other unused variable)
	move.b	subtype(a0),d1
	move.b	d1,d0
	andi.w	#$F,d1	; The lower 4 bits of subtype are unused, making these instructions useless
	andi.b	#$F0,d0
	ext.w	d0
	asl.w	#3,d0
	move.w	d0,Obj83_speed(a0)

	; Set angle according to X-flip and Y-flip
	move.b	status(a0),d0
	ror.b	#2,d0
	andi.b	#$C0,d0
	move.b	d0,angle(a0)

	; Create child object (chain multisprite)
	jsrto	(SingleObjLoad2).l, JmpTo19_SingleObjLoad2
	bne.s	.noRAMforChildObjects

	move.l	(a0),(a1) ; load obj83
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$40,mainspr_width(a1)
	moveq	#8,d1
	move.b	d1,mainspr_childsprites(a1)
	subq.w	#1,d1
	lea	sub2_x_pos(a1),a2

.nextChildSprite:
	addq.w	#next_subspr-2,a2
	move.w	#1,(a2)+	; sub?_mapframe
	dbf	d1,.nextChildSprite

	move.b	#1,mainspr_mapframe(a1)
	move.b	#$40,mainspr_height(a1)
	bset	#4,render_flags(a1)
	move.l	a1,Obj83_childobjptr_chains(a0)

	; Create remaining child objects: platform 2 and 3
	bsr.s	Obj83_LoadSubObject
	move.l	a1,Obj83_childobjptr_platform2(a0)
	bsr.s	Obj83_LoadSubObject
	move.l	a1,Obj83_childobjptr_platform3(a0)

.noRAMforChildObjects:
	bra.s	Obj83_Main
; ===========================================================================
; loc_2A5DE:
Obj83_LoadSubObject:
	jsrto	(SingleObjLoad2).l, JmpTo19_SingleObjLoad2
	bne.s	.noRAMforChildObject	; rts
	addq.b	#4,routine(a1)
	move.l	(a0),(a1) ; load obj
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$20,width_pixels(a1)
	move.w	x_pos(a0),Obj83_initial_x_pos(a1)
	move.w	y_pos(a0),Obj83_initial_y_pos(a1)
	move.w	x_pos(a0),Obj83_last_x_pos(a1)

.noRAMforChildObject:
	rts
; ===========================================================================
; loc_2A620:
Obj83_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	moveq	#0,d1
	move.w	Obj83_speed(a0),d0
	add.w	d0,angle(a0)
	move.w	Obj83_initial_y_pos(a0),d2
	move.w	Obj83_initial_x_pos(a0),d3
	moveq	#0,d6
	movea.l	Obj83_childobjptr_chains(a0),a1 ; a1=object
	lea	sub2_x_pos(a1),a2

	; Update first row of chains
	move.b	angle(a0),d0
	jsrto	(CalcSine).l, JmpTo10_CalcSine
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,x_pos(a1)	; update chainlink mainsprite x_pos
	move.w	d4,y_pos(a1)	; update chainlink mainsprite y_pos
	move.l	d0,d4
	move.l	d1,d5
	add.l	d0,d4
	add.l	d1,d5
	moveq	#1,d6	; Update 2 chainlink childsprites (the third chainlink is the mainsprite, which has already been updated)
	jsr	Obj83_UpdateChainSpritePosition
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,x_pos(a0)
	move.w	d4,y_pos(a0)

	; Update second row of chains
	move.b	angle(a0),d0
	addi.b	#256/3,d0	; 360 degrees = 256
	jsrto	(CalcSine).l, JmpTo10_CalcSine
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
	moveq	#2,d6	; Update 3 chainlink childsprites
	jsr	Obj83_UpdateChainSpritePosition
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	movea.l	Obj83_childobjptr_platform2(a0),a1 ; a1=object
	move.w	d5,x_pos(a1)
	move.w	d4,y_pos(a1)

	; Update third row of chains
	move.b	angle(a0),d0
	subi.b	#256/3,d0	; 360 degrees = 256
	jsrto	(CalcSine).l, JmpTo10_CalcSine
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	move.l	d0,d4
	move.l	d1,d5
	moveq	#2,d6	; Update 3 chainlink childsprites
	jsr	Obj83_UpdateChainSpritePosition
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	movea.l	Obj83_childobjptr_platform3(a0),a1 ; a1=object
	move.w	d5,x_pos(a1)
	move.w	d4,y_pos(a1)

	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject).l, JmpTo7_PlatformObject
	tst.w	(Two_player_mode).w
	beq.s	.notTwoPlayerMode
	jmpto	(DisplaySprite).l, JmpTo27_DisplaySprite
; ===========================================================================
.notTwoPlayerMode:
	move.w	Obj83_initial_x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	.objectOffscreen
	jmpto	(DisplaySprite).l, JmpTo27_DisplaySprite
; ===========================================================================
.objectOffscreen:
	movea.l	Obj83_childobjptr_chains(a0),a1 ; a1=object
	jsrto	(DeleteObject2).l, JmpTo4_DeleteObject2
	jmpto	(DeleteObject).l, JmpTo42_DeleteObject
; ===========================================================================
; loc_2A72E:
Obj83_UpdateChainSpritePosition:
.nextChainSprite:
	movem.l	d4-d5,-(sp)
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
	dbf	d6,.nextChainSprite
	rts
; ===========================================================================
; loc_2A74E: Obj83_SubObject:
Obj83_PlatformSubObject:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	Obj83_last_x_pos(a0),d4
	jsrto	(PlatformObject).l, JmpTo7_PlatformObject
	move.w	x_pos(a0),Obj83_last_x_pos(a0)
	move.w	Obj83_initial_x_pos(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo8_MarkObjGone2
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo3_DisplaySprite3 ; JmpTo
	jmp	(DisplaySprite3).l
JmpTo27_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo42_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo4_DeleteObject2 ; JmpTo
	jmp	(DeleteObject2).l
JmpTo19_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo47_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo10_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo7_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
JmpTo8_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif



