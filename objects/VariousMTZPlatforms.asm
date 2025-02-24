


; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6A - Platform that moves when you walk off of it, from MTZ
; ----------------------------------------------------------------------------
; Sprite_27AB0:
Obj6A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6A_Index(pc,d0.w),d1
	jmp	Obj6A_Index(pc,d1.w)
; ===========================================================================
; off_27ABE:
Obj6A_Index:	offsetTable
		offsetTableEntry.w Obj6A_Init	; 0
		offsetTableEntry.w loc_27BDE	; 2
		offsetTableEntry.w loc_27C66	; 4
; ===========================================================================
; loc_27AC4:
Obj6A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj65_Obj6A_Obj6B_MapUnc_26EC8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#$C,y_radius(a0)
	move.l	#byte_27CDC,objoff_30(a0)
	move.b	#1,mapping_frame(a0)
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.w	loc_27BC4
	addq.b	#2,routine(a0)
	move.l	#Obj6A_MapUnc_27D30,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Crate,3,0),art_tile(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#$20,y_radius(a0)
	move.l	#byte_27CF4,objoff_30(a0)
	btst	#0,status(a0)
	beq.s	+
	move.l	#byte_27D12,objoff_30(a0)
+
	move.b	#0,mapping_frame(a0)
	cmpi.b	#$18,subtype(a0)
	bne.w	loc_27BD0
	jsrto	(SingleObjLoad2).l, JmpTo13_SingleObjLoad2
	bne.s	++
	bsr.s	Obj6A_InitSubObject
	addi.w	#$40,x_pos(a1)
	addi.w	#$40,y_pos(a1)
	move.b	#6,subtype(a1)
	btst	#0,status(a0)
	beq.s	+
	move.b	#$C,subtype(a1)
+
	jsrto	(SingleObjLoad2).l, JmpTo13_SingleObjLoad2
	bne.s	+
	bsr.s	Obj6A_InitSubObject
	subi.w	#$40,x_pos(a1)
	addi.w	#$40,y_pos(a1)
	move.b	#$C,subtype(a1)
	btst	#0,status(a0)
	beq.s	+
	move.b	#6,subtype(a1)
+
	bra.s	loc_27BC4
; ===========================================================================
; loc_27B9E:
Obj6A_InitSubObject:
	move.l	(a0),(a1) ; load obj6A
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_pos(a0),objoff_36(a1)
	move.w	y_pos(a0),objoff_34(a1)
	move.b	status(a0),status(a1)
	rts
; ===========================================================================

loc_27BC4:
	move.w	x_pos(a0),objoff_36(a0)
	move.w	y_pos(a0),objoff_34(a0)

loc_27BD0:
	jsrto	(Adjust2PArtPointer).l, JmpTo33_Adjust2PArtPointer
	move.b	subtype(a0),objoff_3C(a0)
	jmp	loc_27CA2
; ===========================================================================

loc_27BDE:
	move.w	x_pos(a0),-(sp)
	tst.w	objoff_3A(a0)
	bne.s	loc_27C2E
	move.b	objoff_40(a0),d1
	move.b	status(a0),d0
	btst	#p1_standing_bit,d0
	bne.s	loc_27C0A
	btst	#p1_standing_bit,d1
	beq.s	loc_27C0E
	move.b	#1,objoff_3A(a0)
	move.b	#0,objoff_40(a0)
	bra.s	loc_27C3E
; ===========================================================================

loc_27C0A:
	move.b	d0,objoff_40(a0)

loc_27C0E:
	btst	#p2_standing_bit,d0
	bne.s	loc_27C28
	btst	#p2_standing_bit,d1
	beq.s	loc_27C3E
	move.b	#1,objoff_3A(a0)
	move.b	#0,objoff_40(a0)
	bra.s	loc_27C3E
; ===========================================================================

loc_27C28:
	move.b	d0,objoff_40(a0)
	bra.s	loc_27C3E
; ===========================================================================
loc_27C2E:
	jsr	(ObjectMove).l
	subq.w	#1,objoff_38(a0)
	bne.s	loc_27C3E
	jsr	loc_27CA2

loc_27C3E:
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	loc_27C5E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	(SolidObject).l, JmpTo13_SolidObject

loc_27C5E:
	move.w	objoff_36(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo3_MarkObjGone2
; ===========================================================================

loc_27C66:
	move.w	x_pos(a0),-(sp)
	jsr	(ObjectMove).l
	subq.w	#1,objoff_38(a0)
	bne.s	loc_27C7A
	jsr	loc_27CA2

loc_27C7A:
	move.w	(sp)+,d4
	tst.b	render_flags(a0)
	bpl.s	loc_27C9A
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	(SolidObject).l, JmpTo13_SolidObject

loc_27C9A:
	move.w	objoff_36(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo3_MarkObjGone2
; ===========================================================================

loc_27CA2:
	moveq	#0,d0
	move.b	objoff_3C(a0),d0
	movea.l	objoff_30(a0),a1 ; a1=object
	lea	(a1,d0.w),a1
	move.w	(a1)+,x_vel(a0)
	move.w	(a1)+,y_vel(a0)
	move.w	(a1)+,objoff_38(a0)
	move.w	#7,objoff_3E(a0)
	move.b	#0,objoff_3A(a0)
	addq.b	#6,objoff_3C(a0)
	cmpi.b	#$18,objoff_3C(a0)
	blo.s	return_27CDA
	move.b	#0,objoff_3C(a0)

return_27CDA:
	rts
; ===========================================================================
byte_27CDC:
	dc.b   0,  0,  4,  0,  0,$10,  4,  0,$FE,  0,  0,$20,  0,  0,  4,  0
	dc.b   0,$10,$FC,  0,$FE,  0,  0,$20; 16
	even
byte_27CF4:
	dc.b   0,  0,  1,  0,  0,$40,$FF,  0,  0,  0,  0,$80,  0,  0,$FF,  0
	dc.b   0,$40,  1,  0,  0,  0,  0,$80,  1,  0,  0,  0,  0,$40; 16
	even
byte_27D12:
	dc.b   0,  0,  1,  0,  0,$40,  1,  0,  0,  0,  0,$80,  0,  0,$FF,  0
	dc.b   0,$40,$FF,  0,  0,  0,  0,$80,$FF,  0,  0,  0,  0,$40; 16
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6A_MapUnc_27D30:	BINCLUDE "mappings/sprite/obj6A.bin"
          even
; ===========================================================================

    if ~~removeJmpTos
JmpTo13_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo33_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo13_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo3_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6B - Immobile platform from MTZ
; ----------------------------------------------------------------------------
; Sprite_27D6C:
Obj6B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6B_Index(pc,d0.w),d1
	jmp	Obj6B_Index(pc,d1.w)
; ===========================================================================
; off_27D7A:
Obj6B_Index:	offsetTable
		offsetTableEntry.w Obj6B_Init	; 0
		offsetTableEntry.w Obj6B_Main	; 2
; ===========================================================================
byte_27D7E:
	dc.b $20
	dc.b  $C	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	dc.b $10	; 4
	dc.b $10	; 5
	dc.b   0	; 6
	dc.b   0	; 7
; ===========================================================================
; loc_27D86:
Obj6B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj65_Obj6A_Obj6B_MapUnc_26EC8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj6B_MapUnc_2800E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0),art_tile(a0)
+
	jsrto	(Adjust2PArtPointer).l, JmpTo34_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#2,d0
	andi.w	#$1C,d0
	lea	byte_27D7E(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,y_radius(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.w	x_pos(a0),objoff_38(a0)
	move.w	y_pos(a0),objoff_34(a0)
	move.b	status(a0),objoff_32(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	subq.w	#8,d0
	bcs.s	Obj6B_Main
	lsl.w	#2,d0
	lea	(Oscillating_Data+$2A).w,a2
	lea	(a2,d0.w),a2
	tst.w	(a2)
	bpl.s	Obj6B_Main
	bchg	#0,objoff_32(a0)
; loc_27E0E:
Obj6B_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	add.w	d0,d0
	move.w	Obj6B_Types(pc,d0.w),d1
	jsr	Obj6B_Types(pc,d1.w)
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
	jsrto	(SolidObject).l, JmpTo14_SolidObject
+
	move.w	objoff_38(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo4_MarkObjGone2
; ===========================================================================
; off_27E4E:
Obj6B_Types:	offsetTable
		offsetTableEntry.w Obj6B_Type_Immobile	;  0
		offsetTableEntry.w loc_27E68		;  1
		offsetTableEntry.w loc_27E74		;  2
		offsetTableEntry.w loc_27E96		;  3
		offsetTableEntry.w loc_27EA2		;  4
		offsetTableEntry.w loc_27EC4		;  5
		offsetTableEntry.w loc_27EE2		;  6
		offsetTableEntry.w loc_27F10		;  7
		offsetTableEntry.w loc_27F4E		;  8
		offsetTableEntry.w loc_27F60		;  9
		offsetTableEntry.w loc_27F70		; $A
		offsetTableEntry.w loc_27F80		; $B
; ===========================================================================
; return_27E66:
Obj6B_Type_Immobile:
	rts
; ===========================================================================

loc_27E68:
	move.w	#$40,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+8).w,d0
	bra.s	+
; ===========================================================================

loc_27E74:
	move.w	#$80,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$1C).w,d0
+
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
	add.w	d1,d0
+
	move.w	objoff_38(a0),d1
	sub.w	d0,d1
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_27E96:
	move.w	#$40,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+8).w,d0
	bra.s	loc_27EAC
; ===========================================================================

loc_27EA2:
	move.w	#$80,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$1C).w,d0

loc_27EAC:
	btst	#0,status(a0)
	beq.s	loc_27EB8
	neg.w	d0
	add.w	d1,d0

loc_27EB8:
	move.w	objoff_34(a0),d1
	sub.w	d0,d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_27EC4:
	move.b	(Oscillating_Data).w,d0
	lsr.w	#1,d0
	add.w	objoff_34(a0),d0
	move.w	d0,y_pos(a0)
	move.b	status(a0),d1
	andi.b	#standing_mask,d1
	beq.s	return_27EE0
	addq.b	#1,subtype(a0)

return_27EE0:
	rts
; ===========================================================================

loc_27EE2:
	move.l	y_pos(a0),d3
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d3,y_pos(a0)
	addi.w	#8,y_vel(a0)
	move.w	(Camera_Max_Y_pos_now).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0
	bhs.s	return_27F0E
	move.b	#0,subtype(a0)

return_27F0E:
	rts
; ===========================================================================

loc_27F10:
	tst.b	objoff_3C(a0)
	bne.s	loc_27F26
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_27F4C
	move.b	#8,objoff_3C(a0)

loc_27F26:
	jsrto	(ObjectMove).l, JmpTo14_ObjectMove
	andi.w	#$7FF,y_pos(a0)
	cmpi.w	#$2A8,y_vel(a0)
	bne.s	loc_27F3C
	neg.b	objoff_3C(a0)

loc_27F3C:
	move.b	objoff_3C(a0),d1
	ext.w	d1
	add.w	d1,y_vel(a0)
	bne.s	return_27F4C
	clr.b	subtype(a0)

return_27F4C:
	rts
; ===========================================================================

loc_27F4E:
	move.w	#$10,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$28).w,d0
	lsr.w	#1,d0
	move.w	(Oscillating_Data+$2A).w,d3
	bra.s	loc_27F8E
; ===========================================================================

loc_27F60:
	move.w	#$30,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$2C).w,d0
	move.w	(Oscillating_Data+$2E).w,d3
	bra.s	loc_27F8E
; ===========================================================================

loc_27F70:
	move.w	#$50,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$30).w,d0
	move.w	(Oscillating_Data+$32).w,d3
	bra.s	loc_27F8E
; ===========================================================================

loc_27F80:
	move.w	#$70,d1
	moveq	#0,d0
	move.b	(Oscillating_Data+$34).w,d0
	move.w	(Oscillating_Data+$36).w,d3

loc_27F8E:
	tst.w	d3
	bne.s	loc_27F9C
	addq.b	#1,objoff_32(a0)
	andi.b	#3,objoff_32(a0)

loc_27F9C:
	move.b	objoff_32(a0),d2
	andi.b	#3,d2
	bne.s	loc_27FBC
	sub.w	d1,d0
	add.w	objoff_38(a0),d0
	move.w	d0,x_pos(a0)
	neg.w	d1
	add.w	objoff_34(a0),d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_27FBC:
	subq.b	#1,d2
	bne.s	loc_27FDA
	subq.w	#1,d1
	sub.w	d1,d0
	neg.w	d0
	add.w	objoff_34(a0),d0
	move.w	d0,y_pos(a0)
	addq.w	#1,d1
	add.w	objoff_38(a0),d1
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_27FDA:
	subq.b	#1,d2
	bne.s	loc_27FF8
	subq.w	#1,d1
	sub.w	d1,d0
	neg.w	d0
	add.w	objoff_38(a0),d0
	move.w	d0,x_pos(a0)
	addq.w	#1,d1
	add.w	objoff_34(a0),d1
	move.w	d1,y_pos(a0)
	rts
; ===========================================================================

loc_27FF8:
	sub.w	d1,d0
	add.w	objoff_34(a0),d0
	move.w	d0,y_pos(a0)
	neg.w	d1
	add.w	objoff_38(a0),d1
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6B_MapUnc_2800E:	BINCLUDE "mappings/sprite/obj6B.bin"
         even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo34_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo14_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo4_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l
; loc_2802E:
JmpTo14_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6C - Small platform on pulleys (like at the start of MTZ2)
; ----------------------------------------------------------------------------
; Sprite_28034:
Obj6C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6C_Index(pc,d0.w),d1
	jsr	Obj6C_Index(pc,d1.w)
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	jmpto	(DisplaySprite).l, JmpTo20_DisplaySprite
; ===========================================================================
+	jmpto	(DeleteObject).l, JmpTo34_DeleteObject
; ===========================================================================
; off_2805C:
Obj6C_Index:	offsetTable
		offsetTableEntry.w Obj6C_Init	; 0
		offsetTableEntry.w Obj6C_Main	; 2
; ===========================================================================
; loc_28060:
Obj6C_Init:
	move.b	subtype(a0),d0
	bmi.w	loc_28112
	addq.b	#2,routine(a0)
	move.l	#Obj6C_MapUnc_28372,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_LavaCup,3,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo35_Adjust2PArtPointer
	move.b	#0,mapping_frame(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	d0,d1
	lsr.w	#3,d0
	andi.w	#$1E,d0
	lea	off_28252(pc),a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,objoff_3C(a0)
	move.l	a2,objoff_40(a0)
	andi.w	#$F,d1
	lsl.w	#2,d1
	move.b	d1,objoff_3C(a0)
	move.b	#4,objoff_3E(a0)
	btst	#0,status(a0)
	beq.s	loc_280F2
	neg.b	objoff_3E(a0)
	moveq	#0,d1
	move.b	objoff_3C(a0),d1
	add.b	objoff_3E(a0),d1
	cmp.b	objoff_3D(a0),d1
	blo.s	loc_280EE
	move.b	d1,d0
	moveq	#0,d1
	tst.b	d0
	bpl.s	loc_280EE
	move.b	objoff_3D(a0),d1
	subq.b	#4,d1

loc_280EE:
	move.b	d1,objoff_3C(a0)

loc_280F2:
	move.w	(a2,d1.w),d0
	add.w	objoff_34(a0),d0
	move.w	d0,objoff_38(a0)
	move.w	2(a2,d1.w),d0
	add.w	objoff_36(a0),d0
	move.w	d0,objoff_3A(a0)
	jsr	loc_281DA
	jmp	Obj6C_Main
; ===========================================================================

loc_28112:
	andi.w	#$7F,d0
	add.w	d0,d0
	lea	(off_282D6).l,a2
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d1
	movea.l	a0,a1
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	bra.s	Obj6C_LoadSubObject
; ===========================================================================
; loc_28130:
Obj6C_SubObjectsLoop:
	jsrto	(SingleObjLoad).l, JmpTo8_SingleObjLoad
	bne.s	+
; loc_28136:
Obj6C_LoadSubObject:
	move.l	#Obj6C,(a1) ; load obj6C
	move.w	(a2)+,d0
	add.w	d2,d0
	move.w	d0,x_pos(a1)
	move.w	(a2)+,d0
	add.w	d3,d0
	move.w	d0,y_pos(a1)
	move.w	d2,objoff_34(a1)
	move.w	d3,objoff_36(a1)
	move.w	(a2)+,d0
	move.b	d0,subtype(a1)
	move.b	status(a0),status(a1)
+
	dbf	d1,Obj6C_SubObjectsLoop
	addq.l	#4,sp
	rts
; ===========================================================================
; loc_28168:
Obj6C_Main:
	move.w	x_pos(a0),-(sp)
	jsr	loc_2817E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#8,d3
	move.w	(sp)+,d4
	jmpto	(PlatformObject).l, JmpTo5_PlatformObject
; ===========================================================================

loc_2817E:
	move.w	x_pos(a0),d0
	cmp.w	objoff_38(a0),d0
	bne.s	loc_281D4
	move.w	y_pos(a0),d0
	cmp.w	objoff_3A(a0),d0
	bne.s	loc_281D4
	moveq	#0,d1
	move.b	objoff_3C(a0),d1
	add.b	objoff_3E(a0),d1
	cmp.b	objoff_3D(a0),d1
	blo.s	loc_281B0
	move.b	d1,d0
	moveq	#0,d1
	tst.b	d0
	bpl.s	loc_281B0
	move.b	objoff_3D(a0),d1
	subq.b	#4,d1

loc_281B0:
	move.b	d1,objoff_3C(a0)
	movea.l	objoff_40(a0),a1 ; a1=object
	move.w	(a1,d1.w),d0
	add.w	objoff_34(a0),d0
	move.w	d0,objoff_38(a0)
	move.w	2(a1,d1.w),d0
	add.w	objoff_36(a0),d0
	move.w	d0,objoff_3A(a0)
	jsr	loc_281DA

loc_281D4:
	jsrto	(ObjectMove).l, JmpTo15_ObjectMove
	rts
; ===========================================================================

loc_281DA:
	moveq	#0,d0
	move.w	#-$100,d2
	move.w	x_pos(a0),d0
	sub.w	objoff_38(a0),d0
	bcc.s	loc_281EE
	neg.w	d0
	neg.w	d2

loc_281EE:
	moveq	#0,d1
	move.w	#-$100,d3
	move.w	y_pos(a0),d1
	sub.w	objoff_3A(a0),d1
	bcc.s	loc_28202
	neg.w	d1
	neg.w	d3

loc_28202:
	cmp.w	d0,d1
	blo.s	loc_2822C
	move.w	x_pos(a0),d0
	sub.w	objoff_38(a0),d0
	beq.s	loc_28218
	ext.l	d0
	asl.l	#8,d0
	divs.w	d1,d0
	neg.w	d0

loc_28218:
	move.w	d0,x_vel(a0)
	move.w	d3,y_vel(a0)
	swap	d0
	move.w	d0,x_sub(a0)
	clr.w	y_sub(a0)
	rts
; ===========================================================================

loc_2822C:
	move.w	y_pos(a0),d1
	sub.w	objoff_3A(a0),d1
	beq.s	loc_2823E
	ext.l	d1
	asl.l	#8,d1
	divs.w	d0,d1
	neg.w	d1

loc_2823E:
	move.w	d1,y_vel(a0)
	move.w	d2,x_vel(a0)
	swap	d1
	move.w	d1,y_sub(a0)
	clr.w	x_sub(a0)
	rts
; ===========================================================================
off_28252:	offsetTable
		offsetTableEntry.w byte_28258	; 0
		offsetTableEntry.w byte_28282	; 1
		offsetTableEntry.w byte_282AC	; 2
byte_28258:
	dc.b   0,$28,  0,  0,  0,  0,$FF,$EA,  0, $A,$FF,$E0,  0,$20,$FF,$E0
	dc.b   0,$E0,$FF,$EA,  0,$F6,  0,  0,  1,  0,  0,$16,  0,$F6,  0,$20; 16
	dc.b   0,$E0,  0,$20,  0,$20,  0,$16,  0, $A; 32
byte_28282:
	dc.b   0,$28,  0,  0,  0,  0,$FF,$EA,  0, $A,$FF,$E0,  0,$20,$FF,$E0
	dc.b   1,$60,$FF,$EA,  1,$76,  0,  0,  1,$80,  0,$16,  1,$76,  0,$20; 16
	dc.b   1,$60,  0,$20,  0,$20,  0,$16,  0, $A; 32
byte_282AC:
	dc.b   0,$28,  0,  0,  0,  0,$FF,$EA,  0, $A,$FF,$E0,  0,$20,$FF,$E0
	dc.b   1,$E0,$FF,$EA,  1,$F6,  0,  0,  2,  0,  0,$16,  1,$F6,  0,$20; 16
	dc.b   1,$E0,  0,$20,  0,$20,  0,$16,  0, $A; 32
; ---------------------------------------------------------------------------
off_282D6:	offsetTable
		offsetTableEntry.w byte_282DC	; 0
		offsetTableEntry.w byte_2830E	; 1
		offsetTableEntry.w byte_28340	; 2
byte_282DC:
	dc.b   0,  7,  0,  0,  0,  0,  0,  1,$FF,$E0,  0,$3A,  0,  3,$FF,$E0
	dc.b   0,$80,  0,  3,$FF,$E0,  0,$C6,  0,  3,  0,  0,  1,  0,  0,  6; 16
	dc.b   0,$20,  0,$C6,  0,  8,  0,$20,  0,$80,  0,  8,  0,$20,  0,$3A; 32
	dc.b   0,  8	; 48
	even
byte_2830E:
	dc.b   0,  7,  0,  0,  0,  0,  0,$11,$FF,$E0,  0,$5A,  0,$13,$FF,$E0
	dc.b   0,$C0,  0,$13,$FF,$E0,  1,$26,  0,$13,  0,  0,  1,$80,  0,$16; 16
	dc.b   0,$20,  1,$26,  0,$18,  0,$20,  0,$C0,  0,$18,  0,$20,  0,$5A; 32
	dc.b   0,$18	; 48
	even
byte_28340:
	dc.b   0,  7,  0,  0,  0,  0,  0,$21,$FF,$E0,  0,$7A,  0,$23,$FF,$E0
	dc.b   1,  0,  0,$23,$FF,$E0,  1,$86,  0,$23,  0,  0,  2,  0,  0,$26; 16
	dc.b   0,$20,  1,$86,  0,$28,  0,$20,  1,  0,  0,$28,  0,$20,  0,$7A; 32
	dc.b   0,$28	; 48
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6C_MapUnc_28372:	BINCLUDE "mappings/sprite/obj6C.bin"
       even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo20_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo34_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo8_SingleObjLoad ; JmpTo
	jmp	(SingleObjLoad).l
JmpTo35_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo5_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
; loc_283A6:
JmpTo15_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 6E - Platform moving in a circle (like at the start of MTZ3)
; ----------------------------------------------------------------------------
; Sprite_283AC:
Obj6E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj6E_Index(pc,d0.w),d1
	jmp	Obj6E_Index(pc,d1.w)
; ===========================================================================
; off_283BA:
Obj6E_Index:	offsetTable
		offsetTableEntry.w Obj6E_Init	; 0
		offsetTableEntry.w loc_28432	; 2
		offsetTableEntry.w loc_284BC	; 4
; ===========================================================================
byte_283C0:
	;    width_pixels
	;        radius
	dc.b $10, $C
	dc.b $28,  8	; 2
	dc.b $60,$18	; 4
	dc.b  $C, $C	; 6
; ===========================================================================
; loc_283C8:
Obj6E_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj6E_MapUnc_2852C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,3,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo36_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$E,d0
	lea	byte_283C0(pc,d0.w),a3
	move.b	(a3)+,width_pixels(a0)
	move.b	(a3)+,y_radius(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	move.w	x_pos(a0),objoff_38(a0)
	move.w	y_pos(a0),objoff_34(a0)
	cmpi.b	#3,d0
	bne.s	loc_28432
	addq.b	#2,routine(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzWheelIndent,3,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo36_Adjust2PArtPointer
	move.b	#5,priority(a0)
	jmp	loc_284BC
; ===========================================================================

loc_28432:

	move.w	x_pos(a0),-(sp)
	move.b	(Oscillating_Data+$20).w,d1
	subi.b	#$38,d1
	ext.w	d1
	move.b	(Oscillating_Data+$24).w,d2
	subi.b	#$38,d2
	ext.w	d2
	btst	#0,subtype(a0)
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,subtype(a0)
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	add.w	objoff_38(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_34(a0),d2
	move.w	d2,y_pos(a0)
	move.w	(sp)+,d4
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	jsrto	(SolidObject).l, JmpTo15_SolidObject
	move.w	objoff_38(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	jmp	(DisplaySprite).l
; ===========================================================================
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	jmp	(DeleteObject).l
; ===========================================================================

loc_284BC:

	move.b	(Oscillating_Data+$20).w,d1
	lsr.b	#1,d1
	subi.b	#$1C,d1
	ext.w	d1
	move.b	(Oscillating_Data+$24).w,d2
	lsr.b	#1,d2
	subi.b	#$1C,d2
	ext.w	d2
	btst	#0,subtype(a0)
	beq.s	+
	neg.w	d1
	neg.w	d2
+
	btst	#1,subtype(a0)
	beq.s	+
	neg.w	d1
	exg	d1,d2
+
	add.w	objoff_38(a0),d1
	move.w	d1,x_pos(a0)
	add.w	objoff_34(a0),d2
	move.w	d2,y_pos(a0)
	move.w	objoff_38(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	+
	jmp	(DisplaySprite).l
; ===========================================================================
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	jmp	(DeleteObject).l
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj6E_MapUnc_2852C:	BINCLUDE "mappings/sprite/obj6E.bin"
         even
; ===========================================================================

    if ~~removeJmpTos
JmpTo36_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo15_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif


