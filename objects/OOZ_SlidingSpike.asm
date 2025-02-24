
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 43 - Sliding spike obstacle thing from OOZ
; ----------------------------------------------------------------------------
; Sprite_23E40:
Obj43:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj43_Index(pc,d0.w),d1
	jmp	Obj43_Index(pc,d1.w)
; ===========================================================================
; off_23E4E:
Obj43_Index:	offsetTable
		offsetTableEntry.w Obj43_Init	; 0
		offsetTableEntry.w loc_23F0A	; 2
		offsetTableEntry.w loc_23F5C	; 4
; ---------------------------------------------------------------------------
byte_23E54:
	dc.b   0
	dc.b $68	; 1
	dc.b   0	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   0	; 5
	dc.b   1	; 6
	dc.b $E8	; 7
	dc.b $FF	; 8
	dc.b $E8	; 9
	dc.b   0	; 10
	dc.b $18	; 11
	dc.b   1	; 12
	dc.b $A8	; 13
	dc.b $FF	; 14
	dc.b $A8	; 15
	dc.b $FF	; 16
	dc.b $D8	; 17
; ===========================================================================
; loc_23E66:
Obj43_Init:
	addq.b	#2,routine(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpikyThing,2,1),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo19_Adjust2PArtPointer
	moveq	#0,d1
	move.b	subtype(a0),d1
	lea	byte_23E54(pc,d1.w),a2
	move.b	(a2)+,d1
	movea.l	a0,a1
	bra.s	loc_23EA8
; ===========================================================================

loc_23E84:
	jsrto	(SingleObjLoad2).l, JmpTo8_SingleObjLoad2
	bne.s	loc_23ED4
	move.l	(a0),(a1) ; load obj43
	move.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#1,objoff_3A(a1)

loc_23EA8:
	move.l	#Obj43_MapUnc_23FE0,mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#4,priority(a1)
	move.b	#$18,width_pixels(a1)
	move.b	#$A5,collision_flags(a1)
	move.w	x_pos(a1),objoff_34(a1)

loc_23ED4:
	dbf	d1,loc_23E84
	move.l	a0,objoff_40(a1)
	move.l	a1,objoff_40(a0)
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

loc_23F0A:
	bsr.s	loc_23F66
	move.w	objoff_36(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bls.s	JmpTo13_DisplaySprite
	move.w	objoff_38(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	loc_23F36

JmpTo13_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
; ===========================================================================

loc_23F36:
	movea.l	objoff_40(a0),a1 ; a1=object
	cmpa.l	a0,a1
	beq.s	loc_23F44
	jsr	(DeleteObject2).l

loc_23F44:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	JmpTo24_DeleteObject
	bclr	#7,2(a2,d0.w)

JmpTo24_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; ===========================================================================

loc_23F5C:
	bsr.s	loc_23F66
	bsr.s	loc_23FB0
	jmp	(DisplaySprite).l
; ===========================================================================

loc_23F66:
	tst.b	objoff_3A(a0)
	bne.s	loc_23F8E
	move.w	x_pos(a0),d1
	subq.w	#1,d1
	cmp.w	objoff_36(a0),d1
	bne.s	loc_23F88
	move.b	#1,objoff_3A(a0)
	move.w	#SndID_SlidingSpike,d0
	jsr	(PlaySoundLocal).l

loc_23F88:
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_23F8E:
	move.w	x_pos(a0),d1
	addq.w	#1,d1
	cmp.w	objoff_38(a0),d1
	bne.s	loc_23FAA
	move.b	#0,objoff_3A(a0)
	move.w	#SndID_SlidingSpike,d0
	jsr	(PlaySoundLocal).l

loc_23FAA:
	move.w	d1,x_pos(a0)
	rts
; ===========================================================================

loc_23FB0:
	movea.l	objoff_40(a0),a1 ; a1=object
	move.w	x_pos(a0),d0
	subi.w	#$18,d0
	move.w	x_pos(a1),d2
	addi.w	#$18,d2
	cmp.w	d0,d2
	bne.s	return_23FDE
	eori.b	#1,objoff_3A(a0)
	eori.b	#1,objoff_3A(a1)
	move.w	#SndID_SlidingSpike,d0
	jsr	(PlaySoundLocal).l

return_23FDE:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj43_MapUnc_23FE0:	BINCLUDE "mappings/sprite/obj43.bin"
          even
; ===========================================================================

    if ~~removeJmpTos
JmpTo8_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo19_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif


