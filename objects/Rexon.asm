
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 94,96 - Rexon (lava snake badnik), from HTZ
; ----------------------------------------------------------------------------
; Sprite_37322:
Obj94:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj94_Index(pc,d0.w),d1
	jmp	Obj94_Index(pc,d1.w)
; ===========================================================================
; off_37330:
Obj94_Index:	offsetTable
		offsetTableEntry.w Obj94_Init	; 0
		offsetTableEntry.w Obj94_WaitForPlayer	; 2
		offsetTableEntry.w Obj94_ReadyToCreateHead	; 4
		offsetTableEntry.w Obj94_PostCreateHead	; 6
; ===========================================================================
; loc_37338:
Obj94_Init:
	jsr	LoadSubObject
	move.b	#2,mapping_frame(a0)
	move.w	#-$20,x_vel(a0)
	move.b	#$80,objoff_2E(a0)
	rts
; ===========================================================================

; loc_37350:
Obj94_WaitForPlayer:
	jsr	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$100,d2
	bhs.s	loc_37362
	jsr	Obj94_CreateHead

loc_37362:
	move.w	x_pos(a0),-(sp)
	jsr	Obj94_CheckTurnAround
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#$11,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo27_SolidObject
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_37380:
Obj94_CheckTurnAround:
	subq.b	#1,objoff_2E(a0)
	bpl.s	loc_37396
	move.b	#$80,objoff_2E(a0)
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)

loc_37396:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	rts
; ===========================================================================

; loc_3739C:
Obj94_ReadyToCreateHead:
	jsr	Obj_GetOrientationToPlayer
	addi.w	#$60,d2
	cmpi.w	#$100,d2
	bhs.s	loc_373AE
	jsr	Obj94_CreateHead

loc_373AE:
	jsr	Obj94_SolidCollision
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_373B6:
Obj94_SolidCollision:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jmpto	(SolidObject).l, JmpTo27_SolidObject
; ===========================================================================

; loc_373CA:
Obj94_PostCreateHead:
	bsr.s	Obj94_SolidCollision
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 97 - Rexon's head, from HTZ
; ----------------------------------------------------------------------------
; Sprite_373D0:
Obj97:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj97_Index(pc,d0.w),d1
	jmp	Obj97_Index(pc,d1.w)
; ===========================================================================
; off_373DE:
Obj97_Index:	offsetTable
		offsetTableEntry.w Obj97_Init	; 0
		offsetTableEntry.w Obj97_InitialWait	; 2
		offsetTableEntry.w Obj97_RaiseHead	; 4
		offsetTableEntry.w Obj97_Normal	; 6
		offsetTableEntry.w Obj97_DeathDrop	; 8
; ===========================================================================
; loc_373E8:
Obj97_Init:
	jsr	LoadSubObject
	move.b	#8,width_pixels(a0)
	moveq	#$28,d0
	btst	#0,render_flags(a0)
	bne.s	+
	moveq	#-$18,d0
+
	add.w	d0,x_pos(a0)
	addi.w	#$10,y_pos(a0)
	move.b	#1,objoff_3C(a0)
	movea.w	objoff_30(a0),a1 ; a1=object
	lea	objoff_32(a1),a1
	move.b	#$B,collision_flags(a0)
	moveq	#0,d0
	move.w	objoff_32(a0),d0
	cmpi.w	#8,d0
	beq.s	+
	move.b	#1,mapping_frame(a0)
	move.b	#$8B,collision_flags(a0)
	move.w	(a1,d0.w),objoff_34(a0)
+
	move.w	6(a1),objoff_36(a0)
	lsr.w	#1,d0
	move.b	byte_3744E(pc,d0.w),objoff_2E(a0)
	move.b	d0,objoff_3D(a0)
	rts
; ===========================================================================
byte_3744E:
	dc.b $1E
	dc.b $18	; 1
	dc.b $12	; 2
	dc.b  $C	; 3
	dc.b   6	; 4
	dc.b   0	; 5
; ===========================================================================

; loc_37454:
Obj97_InitialWait:
    if gameRevision<2
	jsr	Obj97_CheckHeadIsAlive
	subq.b	#1,objoff_2E(a0)
	bmi.s	Obj97_StartRaise
    else
	; fixes an occational crash when defeated
	subq.b	#1,objoff_2E(a0)
	bmi.s	Obj97_StartRaise
	jsr	Obj97_CheckHeadIsAlive
    endif
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_37462:
Obj97_StartRaise:
	addq.b	#2,routine(a0)
	move.w	#-$120,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	move.w	objoff_32(a0),d0
	subi.w	#8,d0
	neg.w	d0
	lsr.w	#1,d0
	move.b	byte_3744E(pc,d0.w),objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_37488:
Obj97_RaiseHead:
    if gameRevision<2
	jsr	Obj97_CheckHeadIsAlive
	moveq	#$10,d0
	add.w	d0,x_vel(a0)
	subq.b	#1,objoff_2E(a0)
	bmi.s	Obj97_StartNormalState
    else
	; fixes an occational crash when defeated
	moveq	#$10,d0
	add.w	d0,x_vel(a0)
	subq.b	#1,objoff_2E(a0)
	bmi.s	Obj97_StartNormalState
	jsr	Obj97_CheckHeadIsAlive
    endif
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_374A0:
Obj97_StartNormalState:
	addq.b	#2,routine(a0)
	jsr	Obj_MoveStop
	move.b	#$20,objoff_2E(a0)
	move.w	objoff_32(a0),d0
	lsr.w	#1,d0
	move.b	byte_374BE(pc,d0.w),objoff_2F(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
byte_374BE:
	dc.b $24
	dc.b $20	; 1
	dc.b $1C	; 2
	dc.b $1A	; 3
; ===========================================================================

; loc_374C2:
Obj97_Normal:
	jsr	Obj97_CheckHeadIsAlive
	cmpi.w	#8,objoff_32(a0)
	bne.s	loc_374D8
	subq.b	#1,objoff_2E(a0)
	bpl.s	loc_374D8
	jsr	Obj97_FireProjectile

loc_374D8:
	move.b	objoff_3D(a0),d0
	addq.b	#1,d0
	move.b	d0,objoff_3D(a0)
	andi.b	#3,d0
	bne.s	+
	jsr	loc_3758A
	jsr	Obj97_Oscillate
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_374F4:
Obj97_DeathDrop:
	move.w	(Camera_Max_Y_pos_now).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0
	blo.w	JmpTo65_DeleteObject
	jsrto	(ObjectMoveAndFall).l, JmpTo8_ObjectMoveAndFall
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

; loc_3750C:
Obj97_CheckHeadIsAlive:
	movea.w	objoff_36(a0),a1 ; a1=object
	cmpi.l	#Obj97,(a1)
	beq.s	+	; rts
	move.b	#8,routine(a0)
	move.w	objoff_32(a0),d0
	move.w	word_37528(pc,d0.w),x_vel(a0)
+
	rts
; ===========================================================================
word_37528:
	dc.w   $80
	dc.w -$100	; 1
	dc.w  $100	; 2
	dc.w  -$80	; 3
	dc.w   $80	; 4
; ===========================================================================

; loc_37532:
Obj97_FireProjectile:
	move.b	#$7F,objoff_2E(a0)
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	++	; rts
	move.l	#Obj98,(a1) ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$10,subtype(a1) ; <== Obj94_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	lea	(ObjectMove).l,a2
	move.l	a2,objoff_2E(a1)
	moveq	#1,d0
	moveq	#$10,d1
	btst	#0,render_flags(a0)
	bne.s	+
	neg.w	d0
	neg.w	d1
+
	move.b	d0,x_vel(a1)
	add.w	d1,x_pos(a1)
	addq.w	#4,y_pos(a1)
	move.b	#$80,1+y_vel(a1)
+
	rts
; ===========================================================================

loc_3758A:
	move.b	objoff_2F(a0),d0
	move.b	objoff_3C(a0),d1
	add.b	d1,d0
	move.b	d0,objoff_2F(a0)
	subi.b	#$18,d0
	beq.s	+
	bcs.s	+
	cmpi.b	#$10,d0
	blo.s	++	; rts
+
	neg.b	objoff_3C(a0)
+
	rts
; ===========================================================================

; loc_375AC:
Obj94_CreateHead:
	move.b	#6,routine(a0)
	bclr	#0,render_flags(a0)
	tst.w	d0
	beq.s	+
	bset	#0,render_flags(a0)
+
	jsr	Obj_MoveStop
	lea	objoff_30(a0),a2
	moveq	#0,d1
	moveq	#4,d6

loc_375CE:
	jsrto	(SingleObjLoad).l, JmpTo19_SingleObjLoad
	bne.s	+	; rts
	move.l	#Obj97,(a1) ; load obj97
	move.b	render_flags(a0),render_flags(a1)
	move.b	subtype(a0),subtype(a1)
	move.w	a0,objoff_30(a1)
	move.w	a1,(a2)+
	move.w	d1,objoff_32(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addq.w	#2,d1
	dbf	d6,loc_375CE
+
	rts
; ===========================================================================

; loc_37604:
Obj97_Oscillate:
	move.w	objoff_34(a0),d0
	beq.s	+	; rts
	movea.w	d0,a1 ; a1=object
	lea	byte_376A8(pc),a2
	moveq	#0,d0
	move.b	objoff_2F(a0),d0
	andi.b	#$7F,d0
	move.w	d0,d1
	andi.w	#$1F,d0
	add.w	d0,d0
	move.b	(a2,d0.w),d2
	ext.w	d2
	move.b	1(a2,d0.w),d3
	ext.w	d3
	lsr.w	#4,d1
	andi.w	#6,d1
	move.w	off_37652(pc,d1.w),d1
	jsr	off_37652(pc,d1.w)
	move.w	x_pos(a0),d4
	add.w	d2,d4
	move.w	d4,x_pos(a1)
	move.b	1+y_pos(a0),d5
	add.b	d3,d5
	move.b	d5,1+y_pos(a1)
+
	rts
; ===========================================================================
off_37652:	offsetTable
		offsetTableEntry.w return_3765A	;   0
		offsetTableEntry.w loc_3765C	; $20
		offsetTableEntry.w loc_37662	; $40
		offsetTableEntry.w loc_37668	; $60
; ===========================================================================

return_3765A:
	rts
; ===========================================================================

loc_3765C:
	exg	d2,d3
	neg.w	d3
	rts
; ===========================================================================

loc_37662:
	neg.w	d2
	neg.w	d3
	rts
; ===========================================================================

loc_37668:
	exg	d2,d3
	neg.w	d2
	rts
; ===========================================================================
; off_3766E:
Obj94_SubObjData:
	subObjData Obj94_Obj98_MapUnc_37678,make_art_tile(ArtTile_ArtNem_Rexon,3,0),4,4,$10,0
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj94_Obj98_MapUnc_37678:	BINCLUDE "mappings/sprite/obj97.bin"
              even
; seems to be a lookup table for oscillating horizontal position offset
byte_376A8:
	dc.b $F,  0
	dc.b $F,$FF	; 1
	dc.b $F,$FF	; 2
	dc.b $F,$FE	; 3
	dc.b $F,$FD	; 4
	dc.b $F,$FC	; 5
	dc.b $E,$FC	; 6
	dc.b $E,$FB	; 7
	dc.b $E,$FA	; 8
	dc.b $E,$FA	; 9
	dc.b $D,$F9	; 10
	dc.b $D,$F8	; 11
	dc.b $C,$F8	; 12
	dc.b $C,$F7	; 13
	dc.b $C,$F6	; 14
	dc.b $B,$F6	; 15
	dc.b $B,$F5	; 16
	dc.b $A,$F5	; 17
	dc.b $A,$F4	; 18
	dc.b  9,$F4	; 19
	dc.b  8,$F4	; 20
	dc.b  8,$F3	; 21
	dc.b  7,$F3	; 22
	dc.b  6,$F2	; 23
	dc.b  6,$F2	; 24
	dc.b  5,$F2	; 25
	dc.b  4,$F2	; 26
	dc.b  4,$F1	; 27
	dc.b  3,$F1	; 28
	dc.b  2,$F1	; 29
	dc.b  1,$F1	; 30
	dc.b  1,$F1	; 31



