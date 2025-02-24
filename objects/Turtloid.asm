
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9A - Turtloid (turtle badnik) from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37936:
Obj9A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9A_Index(pc,d0.w),d1
	jmp	Obj9A_Index(pc,d1.w)
; ===========================================================================
; off_37944:
Obj9A_Index:	offsetTable
		offsetTableEntry.w Obj9A_Init	; 0
		offsetTableEntry.w Obj9A_Main	; 2
; ===========================================================================
; loc_37948:
Obj9A_Init:
	jsr	LoadSubObject
	move.w	#-$80,x_vel(a0)
	jsr	loc_37A4A
	lea	(Ani_obj9A).l,a1
	movea.l	a1,objoff_32(a0)
	jsr	MakeChildJetThing
	move.b  #1,objoff_12(a1)
	rts
; ===========================================================================
; loc_37964:
Obj9A_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3797A(pc,d0.w),d1
	jsr	off_3797A(pc,d1.w)
	jsr	loc_37982
	jmp	Obj_DeleteBehindScreen
; ===========================================================================
off_3797A:	offsetTable
		offsetTableEntry.w loc_379A0	; 0
		offsetTableEntry.w loc_379CA	; 2
		offsetTableEntry.w loc_379EA	; 4
		offsetTableEntry.w return_37A04	; 6
; ===========================================================================

loc_37982:
	move.w	x_pos(a0),-(sp)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jsr	loc_36776
	move.w	#$18,d1
	move.w	#8,d2
	move.w	#$E,d3
	move.w	(sp)+,d4
	jmpto	(PlatformObject).l, JmpTo9_PlatformObject
; ===========================================================================

loc_379A0:
	jsr	Obj_GetOrientationToPlayer
	tst.w	d0
	bmi.w	return_37A48
	cmpi.w	#$80,d2
	bhs.w	return_37A48
	addq.b	#2,routine_secondary(a0)
	move.w	#0,x_vel(a0)
	move.b	#4,objoff_2E(a0)
	move.b	#1,mapping_frame(a0)
	rts
; ===========================================================================

loc_379CA:
	subq.b	#1,objoff_2E(a0)
	bpl.w	return_37A48
	addq.b	#2,routine_secondary(a0)
	move.b	#8,objoff_2E(a0)
	movea.w	objoff_30(a0),a1 ; a1=object
	move.b	#3,mapping_frame(a1)
	jmp	loc_37AF2
; ===========================================================================

loc_379EA:
	subq.b	#1,objoff_2E(a0)
	bpl.s	return_37A02
	addq.b	#2,routine_secondary(a0)
	move.w	#-$80,x_vel(a0)
	clr.b	mapping_frame(a0)
	movea.w	objoff_30(a0),a1 ; a1=object

return_37A02:
	rts
; ===========================================================================

return_37A04:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9B - Turtloid rider from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37A06:
Obj9B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9B_Index(pc,d0.w),d1
	jmp	Obj9B_Index(pc,d1.w)
; ===========================================================================
; off_37A14:
Obj9B_Index:	offsetTable
		offsetTableEntry.w Obj9B_Init	; 0
		offsetTableEntry.w Obj9B_Main	; 2
; ===========================================================================
; BranchTo_LoadSubObject
Obj9B_Init:
	jmp	LoadSubObject
; ===========================================================================
; loc_37A1C:
Obj9B_Main:
	movea.w	objoff_30(a0),a1 ; a1=object
	lea	word_37A2C(pc),a2
	jsr	loc_37A30
	jmp	Obj_DeleteBehindScreen
; ===========================================================================
word_37A2C:
	dc.w	 4	; 0
	dc.w  -$18	; 1
; ===========================================================================

loc_37A30:
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,y_pos(a0)

return_37A48:
	rts
; ===========================================================================

loc_37A4A:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	return_37A80
	move.l	#Obj9B,(a1) ; load obj9B
	move.b	#2,mapping_frame(a1)
	move.b	#$18,subtype(a1) ; <== Obj9B_SubObjData
	move.w	a0,objoff_30(a1)
	move.w	a1,objoff_30(a0)
	move.w	x_pos(a0),x_pos(a1)
	addq.w	#4,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	subi.w	#$18,y_pos(a1)

return_37A80:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 9C - Balkiry's jet from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37A82:
Flicker_Set = status+1
Obj9C:
	jsr	LoadSubObject
	move.l  #Obj9C_Main,(a0)
; ===========================================================================
; loc_37A98:
Obj9C_Main:
	movea.w	objoff_30(a0),a1 ; a1=object
	tst.l   (a1)
	beq.s   DeleteChildS2
	cmpi.l  #Obj27,(a1)       ; is the parent an exploation ?
        beq.s   DeleteChildS2     ; mark child object destroyed
        cmpi.l  #Obj58,(a1)       ; is the parent an exploation ? (if this routine is used in a boss)
        beq.s   DeleteChildS2     ; mark child object destroyed
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
Flicker_Obj_SCZ:
        tst.b   objoff_12(a0)
	bne.s   Turtle_Enemy
	bchg	#0,Flicker_Set(a0)
	beq.w   +
Turtle_Enemy:
	movea.l	objoff_32(a0),a1
	jsr	(AnimateSprite).l
	jmp	Obj_DeleteBehindScreen
DeleteChildS2:
	jmp   DeleteObject
; ===========================================================================


; this code is for Obj9A

loc_37AF2:
	jsrto	(SingleObjLoad).l, JmpTo19_SingleObjLoad
	bne.s	+	; rts
	move.l	#Obj98,(a1) ; load obj98
	move.b	#6,mapping_frame(a1)
	move.b	#$1C,subtype(a1) ; <== Obj9A_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	subi.w	#$14,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#$A,y_pos(a1)
	move.w	#-$100,x_vel(a1)
	lea_	Obj98_TurtloidShotMove,a2
	move.l	a2,objoff_2E(a1)
+
	rts
; ===========================================================================
; off_37B32:
Obj9A_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),4,5,$18,0
; off_37B3C:
Obj9B_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),4,4,$C,$1A
; off_37B46:
Obj9C_SubObjData:
	subObjData Obj9A_Obj98_MapUnc_37B62,make_art_tile(ArtTile_ArtNem_Turtloid,0,0),4,5,8,0

; animation script
; off_37B50: TurtloidShotAniData:
Ani_TurtloidShot: offsetTable
		offsetTableEntry.w +
+		dc.b   1,  4,  5,$FF
		even

; animation script
; off_37B56:
Ani_obj9A:	offsetTable
		offsetTableEntry.w +
+		dc.b   1,  6,  7,$FF
		even

; animation script
; off_37B5C:
Ani_obj9C:	offsetTable
		offsetTableEntry.w +
+		dc.b   1,  8,  9,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj9A_Obj98_MapUnc_37B62:	BINCLUDE "mappings/sprite/obj9C.bin"
                even


