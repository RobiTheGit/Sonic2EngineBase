
; ===========================================================================
; ----------------------------------------------------------------------------
; Object D3 - Bomb prize from CNZ
; ----------------------------------------------------------------------------
; Note: see object DC (ring prize) for SST entries (casino_prize_*)

; Sprite_2B84C:
ObjD3:
	moveq	#0,d1
	move.w	casino_prize_machine_x_pos(a0),d1
	swap	d1
	move.l	casino_prize_x_pos(a0),d0
	sub.l	d1,d0
	asr.l	#4,d0
	sub.l	d0,casino_prize_x_pos(a0)
	move.w	casino_prize_x_pos(a0),x_pos(a0)
	moveq	#0,d1
	move.w	casino_prize_machine_y_pos(a0),d1
	swap	d1
	move.l	casino_prize_y_pos(a0),d0
	sub.l	d1,d0
	asr.l	#4,d0
	sub.l	d0,casino_prize_y_pos(a0)
	move.w	casino_prize_y_pos(a0),y_pos(a0)
	subq.w	#1,casino_prize_display_delay(a0)
	bne.w	JmpTo28_DisplaySprite
	movea.l	objoff_2E(a0),a1
	subq.w	#1,(a1)
	cmpi.w	#5,(Bonus_Countdown_3).w
	blo.s	+
	clr.w	(Bonus_Countdown_3).w
	move.w	#SndID_HurtBySpikes,d0
	jsr	(PlaySoundStereo).l
+
	tst.b	parent+1(a0)
	beq.s	++
	tst.w	(Ring_count_2P).w
	beq.s	+
	subq.w	#1,(Ring_count_2P).w
	ori.b	#$81,(Update_HUD_rings_2P).w
+
	tst.w	(Two_player_mode).w
	bne.s	BranchTo_JmpTo44_DeleteObject
+
	tst.w	(Ring_count).w
	beq.s	BranchTo_JmpTo44_DeleteObject
	subq.w	#1,(Ring_count).w
	ori.b	#$81,(Update_HUD_rings).w

BranchTo_JmpTo44_DeleteObject ; BranchTo
	jmpto	(DeleteObject).l, JmpTo44_DeleteObject

    if removeJmpTos
JmpTo28_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
    endif
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD3_MapUnc_2B8D4:	BINCLUDE "mappings/sprite/objD6_a.bin"
           even
; ===========================================================================

    if ~~removeJmpTos
JmpTo28_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo44_DeleteObject ; JmpTo
	jmp	(DeleteObject).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object D4 - Big block from CNZ that moves back and forth
; ----------------------------------------------------------------------------
; Sprite_2B8EC:
ObjD4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD4_Index(pc,d0.w),d1
	jmp	ObjD4_Index(pc,d1.w)
; ===========================================================================
; off_2B8FA:
ObjD4_Index:	offsetTable
		offsetTableEntry.w ObjD4_Init	; 0
		offsetTableEntry.w ObjD4_Main	; 2
; ===========================================================================
; loc_2B8FE:
ObjD4_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD4_MapUnc_2B9CA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo52_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_36(a0)
	move.w	#$8000,x_sub(a0)
	move.w	#$8000,y_sub(a0)
	tst.b	subtype(a0)
	bne.s	loc_2B95A
	subi.w	#$60,x_pos(a0)
	btst	#0,status(a0)
	beq.s	ObjD4_Main
	addi.w	#$C0,x_pos(a0)
	bra.s	ObjD4_Main
; ===========================================================================

loc_2B95A:
	subi.w	#$60,y_pos(a0)
	btst	#1,status(a0)
	beq.s	ObjD4_Main
	addi.w	#$C0,y_pos(a0)
; loc_2B96E:
ObjD4_Main:
	move.w	x_pos(a0),-(sp)
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.w	ObjD4_Types(pc,d0.w),d1
	jsr	ObjD4_Types(pc,d1.w)
	jsrto	(ObjectMove).l, JmpTo17_ObjectMove
	move.w	#$2B,d1
	move.w	#$20,d2
	move.w	#$21,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo25_SolidObject
	move.w	objoff_34(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo10_MarkObjGone2
; ===========================================================================
; off_2B99E:
ObjD4_Types:	offsetTable
		offsetTableEntry.w ObjD4_Horizontal	; 0
		offsetTableEntry.w ObjD4_Vertical	; 2
; ===========================================================================
; loc_2B9A2:
ObjD4_Horizontal:
	moveq	#4,d1
	move.w	objoff_34(a0),d0
	cmp.w	x_pos(a0),d0
	bhi.s	+
	neg.w	d1
+
	add.w	d1,x_vel(a0)
	rts
; ===========================================================================
; loc_2B9B6:
ObjD4_Vertical:
	moveq	#4,d1
	move.w	objoff_36(a0),d0
	cmp.w	y_pos(a0),d0
	bhi.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD4_MapUnc_2B9CA:	BINCLUDE "mappings/sprite/objD4.bin"
         even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo52_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo25_SolidObject ; JmpTo
	jmp	(SolidObject).l
JmpTo10_MarkObjGone2 ; JmpTo
	jmp	(MarkObjGone2).l
; loc_2BA02:
JmpTo17_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object D5 - Elevator from CNZ
; ----------------------------------------------------------------------------
; Sprite_2BA08:
ObjD5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD5_Index(pc,d0.w),d1
	jmp	ObjD5_Index(pc,d1.w)
; ===========================================================================
; off_2BA16:
ObjD5_Index:	offsetTable
		offsetTableEntry.w ObjD5_Init	; 0
		offsetTableEntry.w ObjD5_Main	; 2
; ===========================================================================
; loc_2BA1A:
ObjD5_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD5_MapUnc_2BB40,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZElevator,2,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo53_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_36(a0)
	move.w	#$8000,y_sub(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#2,d0
	sub.w	d0,y_pos(a0)
	btst	#0,status(a0)
	beq.s	ObjD5_Main
	add.w	d0,d0
	add.w	d0,y_pos(a0)
; loc_2BA68:
ObjD5_Main:
	jsrto	(ObjectMove).l, JmpTo18_ObjectMove
	move.w	objoff_38(a0),d0
	move.w	off_2BA94(pc,d0.w),d1
	jsr	off_2BA94(pc,d1.w)
	cmpi.w	#6,objoff_38(a0)
	bhs.s	+
	move.w	#$10,d1
	move.w	#9,d3
	move.w	x_pos(a0),d4
	jsrto	(PlatformObjectD5).l, JmpTo_PlatformObjectD5
+
	jmpto	(MarkObjGone).l, JmpTo28_MarkObjGone
; ===========================================================================
off_2BA94:	offsetTable
		offsetTableEntry.w loc_2BA9C	; 0
		offsetTableEntry.w loc_2BAB6	; 2
		offsetTableEntry.w loc_2BAEE	; 4
		offsetTableEntry.w loc_2BB08	; 6
; ===========================================================================

loc_2BA9C:
	move.b	status(a0),d0
	andi.w	#standing_mask,d0
	beq.s	+	; rts
	move.w	#SndID_CNZElevator,d0
	jsr	(PlaySound).l
	addq.w	#2,objoff_38(a0)
+
	rts
; ===========================================================================

loc_2BAB6:
	moveq	#8,d1
	move.w	objoff_36(a0),d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	bne.s	+	; rts
	addq.w	#2,objoff_38(a0)
	move.w	d0,y_pos(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#2,d0
	sub.w	d0,y_pos(a0)
	btst	#0,status(a0)
	bne.s	+	; rts
	add.w	d0,d0
	add.w	d0,y_pos(a0)
+
	rts
; ===========================================================================

loc_2BAEE:
	move.b	status(a0),d0
	andi.w	#standing_mask,d0
	bne.s	+	; rts
	move.w	#SndID_CNZElevator,d0
	jsr	(PlaySound).l
	addq.w	#2,objoff_38(a0)
+
	rts
; ===========================================================================

loc_2BB08:
	moveq	#8,d1
	move.w	objoff_36(a0),d0
	cmp.w	y_pos(a0),d0
	bhs.s	+
	neg.w	d1
+
	add.w	d1,y_vel(a0)
	bne.s	+	; rts
	clr.w	objoff_38(a0)
	move.w	d0,y_pos(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#2,d0
	sub.w	d0,y_pos(a0)
	btst	#0,status(a0)
	beq.s	+	; rts
	add.w	d0,d0
	add.w	d0,y_pos(a0)
+
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD5_MapUnc_2BB40:	BINCLUDE "mappings/sprite/objD5.bin"
       even
; ===========================================================================

    if ~~removeJmpTos
JmpTo28_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo53_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_PlatformObjectD5 ; JmpTo
	jmp	(PlatformObjectD5).l
; loc_2BB66:
JmpTo18_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object D6 - Pokey that gives out points from CNZ
; ----------------------------------------------------------------------------
; Sprite_2BB6C:
ObjD6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD6_Index(pc,d0.w),d1
	jmp	ObjD6_Index(pc,d1.w)
; ===========================================================================
; off_2BB7A:
ObjD6_Index:	offsetTable
		offsetTableEntry.w ObjD6_Init	; 0
		offsetTableEntry.w ObjD6_Main	; 2
; ===========================================================================
; loc_2BB7E:
ObjD6_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD6_MapUnc_2BEBC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZCage,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo54_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#1,priority(a0)
; loc_2BBA6:
ObjD6_Main:
	move.w	#$23,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	lea	objoff_34(a0),a2
	lea	(MainCharacter).w,a1 ; a1=character
	moveq	#p1_standing_bit,d6
	movem.l	d1-d4,-(sp)
	jsr	loc_2BBE8
	movem.l	(sp)+,d1-d4
	lea	objoff_38(a0),a2 ; a2=object
	lea	(Sidekick).w,a1 ; a1=character
	moveq	#p2_standing_bit,d6
	jsr	loc_2BBE8
	lea	(Ani_objD6).l,a1
	jsrto	(AnimateSprite).l, JmpTo10_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo29_MarkObjGone
; ===========================================================================

loc_2BBE8:
	move.w	(a2),d0
	move.w	off_2BBF2(pc,d0.w),d0
	jmp	off_2BBF2(pc,d0.w)
; ===========================================================================
off_2BBF2:	offsetTable
		offsetTableEntry.w loc_2BBF8	; 0
		offsetTableEntry.w loc_2BDF8	; 2
		offsetTableEntry.w loc_2BE9C	; 4
; ===========================================================================

loc_2BBF8:
	tst.b	obj_control(a1)
	bne.w	return_2BC84
	tst.b	subtype(a0)
	beq.s	loc_2BC0C
	tst.w	(SlotMachineInUse).w
	bne.s	return_2BC84

loc_2BC0C:
	jsrto	(SolidObject_Always_SingleCharacter).l, JmpTo7_SolidObject_Always_SingleCharacter
	tst.w	d4
	bpl.s	return_2BC84
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.w	#0,inertia(a1)
	move.b	#$81,obj_control(a1)
	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.b	#1,anim(a0)
	addq.w	#2,(a2)+
	move.w	#$78,(a2)
	move.w	a1,parent(a0)
	tst.b	subtype(a0)
	beq.s	return_2BC84
	cmpi.b	#$18,(SlotMachine_Routine).w	; Is it the null routine?
	bne.s	return_2BC84					; Branch if not
	move.b	#8,(SlotMachine_Routine).w		; => SlotMachine_Routine3
	clr.w	objoff_32(a0)
	move.w	#-1,(SlotMachineInUse).w
	move.w	#-1,objoff_2E(a0)

return_2BC84:
	rts
; ===========================================================================

loc_2BC86:
	move.w	(SlotMachine_Reward).w,d0
	bpl.w	loc_2BD4E
	tst.w	objoff_2E(a0)
	bpl.s	+
	move.w	#$64,objoff_2E(a0)
+
	tst.w	objoff_2E(a0)
	beq.w	+
	btst	#0,(Timer_frames+1).w
	beq.w	loc_2BD48
	cmpi.w	#$10,objoff_30(a0)
	bhs.w	loc_2BD48
	jsrto	(SingleObjLoad).l, JmpTo10_SingleObjLoad
	bne.w	loc_2BD48
	move.l	#ObjD3,(a1) ; load objD3
	move.l	#ObjD3_MapUnc_2B8D4,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZBonusSpike,0,0),art_tile(a1)
	jsrto	(Adjust2PArtPointer2).l, JmpTo6_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.w	#$1E,casino_prize_display_delay(a1)
	move.w	objoff_32(a0),objoff_32(a1)
	addi.w	#$90,objoff_32(a0)
	move.w	x_pos(a0),casino_prize_machine_x_pos(a1)
	move.w	y_pos(a0),casino_prize_machine_y_pos(a1)
	move.w	objoff_32(a1),d0
	jsrto	(CalcSine).l, JmpTo12_CalcSine
	asr.w	#1,d1
	add.w	casino_prize_machine_x_pos(a1),d1
	move.w	d1,casino_prize_x_pos(a1)
	move.w	d1,x_pos(a1)
	asr.w	#1,d0
	add.w	casino_prize_machine_y_pos(a1),d0
	move.w	d0,casino_prize_y_pos(a1)
	move.w	d0,y_pos(a1)
	lea	objoff_30(a0),a2
	move.l	a2,objoff_2E(a1)
	move.w	parent(a0),parent(a1)
	addq.w	#1,objoff_30(a0)
	subq.w	#1,objoff_2E(a0)
+
	tst.w	objoff_30(a0)
	beq.w	loc_2BE2E

loc_2BD48:
	addq.w	#1,(Bonus_Countdown_3).w
	rts
; ===========================================================================

loc_2BD4E:
	beq.w	+
	btst	#0,(Timer_frames+1).w
	beq.w	return_2BDF6
	cmpi.w	#$10,objoff_30(a0)
	bhs.w	return_2BDF6
	jsrto	(SingleObjLoad).l, JmpTo10_SingleObjLoad
	bne.w	return_2BDF6
	move.l	#ObjDC,(a1) ; load objDC
	move.l	#Obj25_MapUnc_12382,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a1)
	jsrto	(Adjust2PArtPointer2).l, JmpTo6_Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#8,width_pixels(a1)
	move.w	#$1A,casino_prize_display_delay(a1)
	move.w	objoff_32(a0),objoff_32(a1)
	addi.w	#$89,objoff_32(a0)
	move.w	x_pos(a0),casino_prize_machine_x_pos(a1)
	move.w	y_pos(a0),casino_prize_machine_y_pos(a1)
	move.w	objoff_32(a1),d0
	jsrto	(CalcSine).l, JmpTo12_CalcSine
	asr.w	#1,d1
	add.w	casino_prize_machine_x_pos(a1),d1
	move.w	d1,casino_prize_x_pos(a1)
	move.w	d1,x_pos(a1)
	asr.w	#1,d0
	add.w	casino_prize_machine_y_pos(a1),d0
	move.w	d0,casino_prize_y_pos(a1)
	move.w	d0,y_pos(a1)
	lea	objoff_30(a0),a2
	move.l	a2,objoff_2E(a1)
	move.w	parent(a0),parent(a1)
	addq.w	#1,objoff_30(a0)
	subq.w	#1,(SlotMachine_Reward).w
+
	tst.w	objoff_30(a0)
	beq.s	loc_2BE2E

return_2BDF6:
	rts
; ===========================================================================

loc_2BDF8:
	tst.b	render_flags(a0)
	bpl.s	loc_2BE2E
	tst.b	subtype(a0)
	beq.s	loc_2BE28
	move.w	a1,objoff_42(a0)
	cmpi.b	#$18,(SlotMachine_Routine).w	; Is it the null routine?
	beq.w	loc_2BC86						; Branch if yes
	move.b	(Vint_runcount+3).w,d0
	andi.w	#$F,d0
	bne.s	+	; rts
	move.w	#SndID_CasinoBonus,d0
	jsr	(PlaySound).l
+
	rts
; ===========================================================================

loc_2BE28:
	subq.w	#1,2(a2)
	bpl.s	loc_2BE5E

loc_2BE2E:
	move.w	#0,objoff_30(a0)
	move.b	#0,anim(a0)
	move.b	#0,objoff_2E(a1)
	bclr	d6,status(a0)
	bclr	#3,status(a1)
	bset	#1,status(a1)
	move.w	#$400,y_vel(a1)
	addq.w	#2,(a2)+
	move.w	#$1E,(a2)
	rts
; ===========================================================================

loc_2BE5E:
	move.w	2(a2),d0
	andi.w	#$F,d0
	bne.s	+	; rts
	move.w	#SndID_CasinoBonus,d0
	jsr	(PlaySound).l
	moveq	#10,d0
	movea.w	a1,a3
	jsr	(AddPoints2).l
	jsrto	(SingleObjLoad).l, JmpTo10_SingleObjLoad
	bne.s	+	; rts
	move.l	#Obj29,(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#0,mapping_frame(a1)
+
	rts
; ===========================================================================

loc_2BE9C:
	subq.w	#1,2(a2)
	bpl.s	+	; rts
	clr.w	(a2)
	tst.b	subtype(a0)
	beq.s	+	; rts
	clr.w	(SlotMachineInUse).w
+
	rts
; ===========================================================================
; animation script
; off_2BEB0:
Ani_objD6:	offsetTable
		offsetTableEntry.w byte_2BEB4	; 0
		offsetTableEntry.w byte_2BEB7	; 1
byte_2BEB4:	dc.b  $F,  0,$FF
	rev02even
byte_2BEB7:	dc.b   1,  1,  0,$FF
	even
; ------------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------------
ObjD6_MapUnc_2BEBC:	BINCLUDE "mappings/sprite/objD6_b.bin"
           even
; ===========================================================================


; ------------------------------------------------------------------------------
; runs the slot machines in CNZ
; ------------------------------------------------------------------------------

slot_rout = 0
slot_timer = 1
slot_index = 3
slots_targ = 4
slot1_targ = 4
slot23_targ = 5
slots_data = 6
slot1_index = slots_data
slot1_offset = slots_data+1
slot1_speed = slots_data+2
slot1_rout = slots_data+3
slot2_index = slots_data+4
slot2_offset = slots_data+5
slot2_speed = slots_data+6
slot2_rout = slots_data+7
slot3_index = slots_data+8
slot3_offset = slots_data+9
slot3_speed = slots_data+10
slot3_rout = slots_data+11

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_2BF24:
SlotMachine:
	lea	(SlotMachineVariables).w,a4
	moveq	#0,d0
	move.b	slot_rout(a4),d0
	jmp	SlotMachine_JmpTable(pc,d0.w)
; ===========================================================================
; loc_2BF32:
SlotMachine_JmpTable: ;;
	jmp	SlotMachine_Routine1		; $00
	jmp	SlotMachine_Routine2		; $04
	jmp	SlotMachine_Routine3		; $08
	jmp	SlotMachine_Routine4		; $0C
	jmp	SlotMachine_Routine5		; $10
	jmp	SlotMachine_Routine6		; $14
	rts									; $18
; ===========================================================================
; loc_2BF4C:
SlotMachine_Routine1:
	movea.l	a4,a1						; Copy destination

	moveq	#8,d0						; 18 bytes, in words
-	clr.w	(a1)+
	dbf	d0,-

	move.b	(Vint_runcount+3).w,d0		; 'Random' seed
	move.b	d0,slot1_index(a4)			; Only last 3 bits matter
	ror.b	#3,d0						; Remove last 3 bits
	move.b	d0,slot2_index(a4)			; Again, only last 3 bits matter
	ror.b	#3,d0						; Remove 3 more bits (only have 2 bits now!)
	move.b	d0,slot3_index(a4)			; Only 3 bits matter, but we only have 2 anyway
	move.b	#8,slot1_offset(a4)			; This will set a draw from start of tile
	move.b	#8,slot2_offset(a4)			; This will set a draw from start of tile
	move.b	#8,slot3_offset(a4)			; This will set a draw from start of tile
	move.b	#8,slot1_speed(a4)			; Initial rolling speed
	move.b	#8,slot2_speed(a4)			; Initial rolling speed
	move.b	#8,slot3_speed(a4)			; Initial rolling speed
	move.b	#1,slot_timer(a4)			; Roll each slot once
	ADDQ.b	#4,slot_rout(a4)			; => SlotMachine_Routine2
	rts
; ===========================================================================
; loc_2BF9A:
SlotMachine_Routine2:
	jsr	SlotMachine_DrawSlot		; Draw the slots
	tst.b	slot_timer(a4)				; Are we still rolling?
	beq.s	+							; Branch if not
	rts
; ===========================================================================
+
	move.b	#$18,slot_rout(a4)			; => null routine (rts)
	clr.w	slot1_speed(a4)				; Stop slot 1
	clr.w	slot2_speed(a4)				; Stop slot 2
	clr.w	slot3_speed(a4)				; Stop slot 3
	rts
; ===========================================================================
; loc_2BFBA:
SlotMachine_Routine3:
	move.b	(Vint_runcount+3).w,d0		; 'Random' seed
	andi.b	#7,d0						; Only want last 3 bits
	subq.b	#4,d0						; Subtract 4...
	addi.b	#$30,d0						; ... then add $30 (why not just add $2C?)
	move.b	d0,slot1_speed(a4)			; This is our starting speed for slot 1
	move.b	(Vint_runcount+3).w,d0		; 'Random' seed
	rol.b	#4,d0						; Get top nibble...
	andi.b	#7,d0						; ... but discard what was the sign bit
	subq.b	#4,d0						; Subtract 4...
	addi.b	#$30,d0						; ... then add $30 (why not just add $2C?)
	move.b	d0,slot2_speed(a4)			; This is our starting speed for slot 2
	move.b	(Vint_runcount+2).w,d0		; 'Random' seed
	andi.b	#7,d0						; Only want last 3 bits
	subq.b	#4,d0						; Subtract 4...
	addi.b	#$30,d0						; ... then add $30 (why not just add $2C?)
	move.b	d0,slot3_speed(a4)			; This is our starting speed for slot 3
	move.b	#2,slot_timer(a4)			; Roll each slot twice under these conditions
	clr.b	slot_index(a4)				; => SlotMachine_Subroutine1
	clr.b	slot1_rout(a4)				; => SlotMachine_Routine5_1
	clr.b	slot2_rout(a4)				; => SlotMachine_Routine5_1
	clr.b	slot3_rout(a4)				; => SlotMachine_Routine5_1
	ADDQ.b	#4,slot_rout(a4)			; => SlotMachine_Routine4
	move.b	(Vint_runcount+3).w,d0		; 'Random' seed
	ror.b	#3,d0						; Mess it around
	lea	(SlotTargetValues).l,a2

-	sub.b	(a2),d0						; Subtract from random seed
	bcs.s	+							; Branch if result is less than zero
	addq.w	#3,a2						; Advance 3 bytes
	bra.s	-							; Keep looping
; ===========================================================================
+
	cmpi.b	#-1,(a2)					; Is the previous value -1?
	beq.s	+							; Branch if yes (end of array)
	move.b	1(a2),slot1_targ(a4)		; Target value for slot 1
	move.b	2(a2),slot23_targ(a4)		; Target values for slots 2 and 3
	rts
; ===========================================================================
+
	move.b	d0,d1						; Copy our 'random' value
	andi.w	#7,d1						; Want only last 3 bits
	lea	(SlotSequence1).l,a1			; Slot sequence array for slot 1
	move.b	(a1,d0.w),slot1_targ(a4)	; Uhhh... use d0 as array index? This should have been d1! Anyway, set slot 1 target
	ror.b	#3,d0						; Rotate it
	move.b	d0,d1						; Copy it
	andi.w	#7,d1						; Want only last 3 bits
	lea	(SlotSequence2).l,a1			; Slot sequence array for slot 2
	move.b	(a1,d1.w),d2				; Use as array index
	lsl.b	#4,d2						; Move to high nibble
	ror.b	#3,d0						; Rotate it again
	andi.w	#7,d0						; Want only last 3 bits
	lea	(SlotSequence3).l,a1			; Slot sequence array for slot 3
	or.b	(a1,d0.w),d2				; Combine with earlier value
	move.b	d2,slot23_targ(a4)			; Target values for slots 2 and 3
	rts
; ===========================================================================
; loc_2C070:
SlotMachine_Routine4:
	jsr	SlotMachine_DrawSlot
	tst.b	slot_timer(a4)				; Are slots still going?
	beq.s	+							; Branch if not
	rts
; ===========================================================================
+
	addi.b	#$30,slot1_speed(a4)		; Increase slot 1 speed
	addi.b	#$30,slot2_speed(a4)		; Increase slot 2 speed
	addi.b	#$30,slot3_speed(a4)		; Increase slot 3 speed
	move.b	(Vint_runcount+3).w,d0		; 'Random' seed
	andi.b	#$F,d0						; Want only low nibble
	addi.b	#$C,d0						; Increase by $C
	move.b	d0,slot_timer(a4)			; New value for slot timer
	clr.b	2(a4)						; Clear otherwise unused variable
	ADDQ.b	#4,slot_rout(a4)			; => SlotMachine_Routine5
	rts
; ===========================================================================
; loc_2C0A8:
SlotMachine_Routine5:
	jsr	SlotMachine_DrawSlot
	cmpi.b	#$C,slot1_rout(a4)			; Is slot done?
	bne.s	+							; Branch if not
	cmpi.b	#$C,slot2_rout(a4)			; Is slot done?
	bne.s	+							; Branch if not
	cmpi.b	#$C,slot3_rout(a4)			; Is slot done?
	beq.w	SlotMachine_Routine6		; Branch if yes
+
	moveq	#0,d0						; Clear d0
	move.b	slot_index(a4),d0			; Get current slot index
	lea	slots_data(a4),a1				; a1 = pointer to slots data
	adda.w	d0,a1						; a1 = pointer to current slot data
	lea	(SlotSequence1).l,a3			; Get pointer to slot sequences
	add.w	d0,d0						; Turn into index
	adda.w	d0,a3						; Get sequence for this slot
	moveq	#0,d0						; Clear d0 again
	move.b	slot1_rout-slot1_index(a1),d0	; Slot routine
	jmp	SlotMachine_Routine5_JmpTable(pc,d0.w)
; ===========================================================================
; loc_2C0E6
SlotMachine_Routine5_JmpTable: ;;
	jmp	SlotMachine_Routine5_1		; $00
	jmp	SlotMachine_Routine5_2		; $04
	jmp	SlotMachine_Routine5_3		; $08
	jmp	SlotMachine_Routine5_4		; $0C
; ===========================================================================
;loc_2C0F6
SlotMachine_GetTargetForSlot:
	move.w	slots_targ(a4),d1			; Get target slot faces
	move.b	slot_index(a4),d0			; Get current slot index
	beq.s	+							; Branch if zero
	lsr.w	d0,d1						; Shift slot face into position
+
	andi.w	#7,d1						; Only 8 slot faces
	cmpi.b	#5,d1						; Is this above bar?
	bgt.s	+							; Branch if yes
	rts
; ===========================================================================
+
	subq.b	#2,d1						; Wrap back to ring/bar
	rts
; ===========================================================================
;loc_2C112
SlotMachine_ChangeTarget:
	move.w	#$FFF0,d2					; Kept faces mask
	andi.w	#$F,d1						; New slot target
	move.b	slot_index(a4),d0			; Get current slot
	beq.s	+							; Branch if it is slot 0
	lsl.w	d0,d1						; Shift new slot target into position
	rol.w	d0,d2						; Shift kept faces mask into position
+
	and.w	d2,slots_targ(a4)			; Mask off current slot
	or.w	d1,slots_targ(a4)			; Put in new value for it
	andi.w	#$777,slots_targ(a4)		; Slots are only 0-7
	rts
; ===========================================================================
; loc_2C134:
SlotMachine_Routine5_1:
	tst.b	slot_index(a4)				; Is this slot 1?
	bne.s	+							; Branch if not
	tst.b	slot_timer(a4)				; Is timer positive or zero?
	bmi.s	++							; Branch if not
	rts
; ===========================================================================
+
	cmpi.b	#8,slot1_rout-slot2_index(a1)	; Is previous slot in state SlotMachine_Routine5_3 or SlotMachine_Routine5_4?
	bge.s	+							; Branch if yes
	rts
; ===========================================================================
+
	bsr.s	SlotMachine_GetTargetForSlot
	move.w	(a1),d0						; Get current slot index/offset
	subi.w	#$A0,d0						; Subtract 20 lines (2.5 tiles) from it
	lsr.w	#8,d0						; Get effective slot index
	andi.w	#7,d0						; Only want 3 bits
	move.b	(a3,d0.w),d0				; Get face from sequence
	cmp.b	d1,d0						; Are we close to target?
	beq.s	+							; Branch if yes
	rts
; ===========================================================================
+
	addq.b	#4,slot1_rout-slot1_index(a1)	; => SlotMachine_Routine5_2
	move.b	#$60,slot1_speed-slot1_index(a1)	; Decrease slot speed
	rts
; ===========================================================================
; loc_2C170:
SlotMachine_Routine5_2:
	bsr.s	SlotMachine_GetTargetForSlot
	move.w	(a1),d0						; Get current slot index/offset
	addi.w	#$F0,d0						; Add 30 lines (3.75 tiles) to it
	andi.w	#$700,d0					; Limit to 8 faces
	lsr.w	#8,d0						; Get effective slot index
	move.b	(a3,d0.w),d0				; Get face from sequence
	cmp.b	d0,d1						; Are we this close to target?
	beq.s	loc_2C1AE					; Branch if yes
	cmpi.b	#$20,slot1_speed-slot1_index(a1)	; Is slot speed more than $20?
	bls.s	+							; Branch if not
	subi.b	#$C,slot1_speed-slot1_index(a1)		; Reduce slot speed
+
	cmpi.b	#$18,slot1_speed-slot1_index(a1)	; Is slot speed $18 or less?
	bgt.s	+							; Branch if not
	rts
; ===========================================================================
+
	cmpi.b	#$80,slot1_offset-slot1_index(a1)	; Is offset $80 or less?
	bls.s	+							; Branch if yes
	rts
; ===========================================================================
+
	subq.b	#2,slot1_speed-slot1_index(a1)		; Reduce slot speed
	rts
; ===========================================================================

loc_2C1AE:
	move.w	(a1),d0						; Get current slot index/offset
	addi.w	#$80,d0						; Subtract 16 lines (2 tiles) to it
	move.w	d0,d1						; Copy to d1
	andi.w	#$700,d1					; Limit to 8 faces
	subi.w	#$10,d1						; Subtract 2 lines (1/4 tile) from it
	move.w	d1,(a1)						; Store new value for index/offset
	lsr.w	#8,d0						; Convert to index
	andi.w	#7,d0						; Limit to 8 faces
	move.b	(a3,d0.w),d1				; Get face from sequence
	jsr	SlotMachine_ChangeTarget	; Set slot index to face number, indtead of sequence index
	move.b	#-8,slot1_speed-slot1_index(a1)	; Rotate slowly on the other direction
	addq.b	#4,slot1_rout-slot1_index(a1)	; => SlotMachine_Routine5_3
	rts
; ===========================================================================
; loc_2C1DA:
SlotMachine_Routine5_3:
	tst.b	slot1_offset-slot1_index(a1)	; Is offset zero?
	beq.s	+							; Branch if yes
	rts
; ===========================================================================
+
	clr.b	slot1_speed-slot1_index(a1)	; Stop slot
	addq.b	#4,slot1_rout-slot1_index(a1)	; => SlotMachine_Routine5_4
	rts
; ===========================================================================
; return_2C1EC:
SlotMachine_Routine5_4:
	rts
; ===========================================================================
; loc_2C1EE:
SlotMachine_Routine6:
	clr.w	slot1_speed(a4)			; Stop slot 1
	clr.w	slot2_speed(a4)			; Stop slot 2
	clr.w	slot3_speed(a4)			; Stop slot 3
	clr.b	slot_timer(a4)			; Stop drawing the slots
	jsr	SlotMachine_ChooseReward
	move.b	#$18,slot_rout(a4)		; => null routine (rts)
	rts
; ===========================================================================
; loc_2C20A
SlotMachine_DrawSlot:
	moveq	#0,d0					; Clear d0
	move.b	slot_index(a4),d0		; d0 = index of slot to draw
	lea	slots_data(a4),a1			; a1 = pointer to slots data
	adda.w	d0,a1					; a1 = pointer to current slot data
	lea	(SlotSequence1).l,a3		; Get slot sequence
	adda.w	d0,a3					; Add offset...
	adda.w	d0,a3					; ... twice
	jmp	BranchTo_SlotMachine_Subroutine(pc,d0.w)
; ===========================================================================

BranchTo_SlotMachine_Subroutine ; BranchTo
	jmp	SlotMachine_Subroutine1		; $00
	jmp	SlotMachine_Subroutine2		; $04
;	jmp	SlotMachine_Subroutine3		; $08
;SlotMachine_Subroutine3:
	clr.b	slot_index(a4)			; => SlotMachine_Subroutine1
	subq.b	#1,slot_timer(a4)		; Decrease timer
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_CNZSlotPics_3),d2	; DMA destination
	bra.s	+
; ===========================================================================
; loc_2C23A:
SlotMachine_Subroutine1:
	addq.b	#4,slot_index(a4)		; => SlotMachine_Subroutine2
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_CNZSlotPics_1),d2	; DMA destination
	jmp	+
; ===========================================================================
; loc_2C246:
SlotMachine_Subroutine2:
	addq.b	#4,slot_index(a4)		; => SlotMachine_Subroutine3
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_CNZSlotPics_2),d2	; DMA destination
+
	move.w	(a1),d0					; Get last pixel offset
	move.b	2(a1),d1				; Get slot rotation speed
	ext.w	d1						; Extend to word
	sub.w	d1,(a1)					; Modify pixel offset
	move.w	(a1),d3					; Get current pixel offset
	andi.w	#$7F8,d0				; Get only desired bits of last pixel offset
	andi.w	#$7F8,d3				; Get only desired bits of current pixel offset
	cmp.w	d0,d3					; Are those equal?
	bne.s	+						; Branch if not (need new picture)
	rts
; ---------------------------------------------------------------------------
+
	jsr	SlotMachine_GetPixelRow	; Get pointer to pixel row
	lea	(CnzCopressionBufferStart).w,a1	; Destination for pixel rows

	move.w	#4*8-1,d1				; Slot picture is 4 tiles
-	move.l	$80(a2),$80(a1)			; Copy pixel row for second column
	move.l	$100(a2),$100(a1)		; Copy pixel row for third column
	move.l	$180(a2),$180(a1)		; Copy pixel row for fourth column
	move.l	(a2)+,(a1)+				; Copy pixel row for first column, advance destination to next line
	addq.b	#8,d3					; Increase offset by 8 (byte operation)
	bne.s	+						; If the result is not zero, branch
	addi.w	#$100,d3				; Advance to next slot picture
	andi.w	#$700,d3				; Limit the sequence to 8 pictures
	jsr	SlotMachine_GetPixelRow	; Need pointer to next pixel row
+
	dbf	d1,-						; Loop for aoo pixel rows


	;move.l	a1,d1	; Source
	move.l	#(CnzCopressionBufferStart)&$FFFFFF,d1 ; :T
	tst.w	(Two_player_mode).w
	beq.s	+
	addi.w	#tiles_to_bytes(ArtTile_ArtUnc_CNZSlotPics_1_2p-ArtTile_ArtUnc_CNZSlotPics_1),d2
+
	move.w	#tiles_to_bytes(16)/2,d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	rts
; ===========================================================================
; loc_2C2B8
SlotMachine_GetPixelRow:
	move.w	d3,d0					; d0 = pixel offset into slot picture
	lsr.w	#8,d0					; Convert offset into index
	andi.w	#7,d0					; Limit each sequence to 8 pictures
	move.b	(a3,d0.w),d0			; Get slot pic id
	andi.w	#7,d0					; Get only lower 3 bits; leaves space for 2 more images
	ror.w	#7,d0					; Equal to shifting left 9 places, or multiplying by 4*4 tiles, in bytes
	lea	(ArtUnc_CNZSlotPics).l,a2	; Load slot pictures
	adda.w	d0,a2					; a2 = pointer to first tile of slot picture
	move.w	d3,d0					; d0 = d3
	andi.w	#$F8,d0					; Strip high word (picture index)
	lsr.w	#1,d0					; Convert into bytes
	adda.w	d0,a2					; a2 = pointer to desired pixel row
	rts
; ==========================================================================
; loc_2C2DE:
SlotMachine_ChooseReward:
	move.b	slot23_targ(a4),d2		; Get slots 2 and 3
	move.b	d2,d3					; Copy to d3
	andi.w	#$F0,d2					; Strip off slot 3 nibble
	lsr.w	#4,d2					; Shift slot 2 to position
	andi.w	#$F,d3					; Strip off slot 2 nibble
	moveq	#0,d0					; Clear d0
	cmp.b	slot1_targ(a4),d2		; Are slots 1 and 2 equal?
	bne.s	+						; Branch if not
	addq.w	#4,d0
+
	cmp.b	slot1_targ(a4),d3		; Are slots 1 and 3 equal?
	bne.s	+						; Branch if not
	addq.w	#8,d0
+
	jmp	SlotMachine_ChooseReward_JmpTable(pc,d0.w)
; ==========================================================================
; loc_2C304:
SlotMachine_ChooseReward_JmpTable: ;;
	jmp	SlotMachine_Unmatched1	; $00
	jmp	SlotMachine_Match12		; $04
	jmp	SlotMachine_Match13		; $08
; ==========================================================================
; SlotMachine_TripleMatch:
	move.w	d2,d0					; d0 = reward index
	jsr	SlotMachine_GetReward
	move.w	d0,slots_targ(a4)		; Store reward
	rts
; ===========================================================================
;loc_2C31C
SlotMachine_Match13:
	cmpi.b	#3,d3					; is slot 3 a jackpot?
	bne.s	+						; Branch if not
	move.w	d2,d0					; Slot 2 is reward index
	jsr	SlotMachine_GetReward
	jsr	SlotMachine_QuadrupleUp
	move.w	d0,slots_targ(a4)		; Store reward
	rts
; ===========================================================================
+
	cmpi.b	#3,d2					; Is slot 2 a jackpot?
	bne.w	SlotMachine_Unmatched1	; Branch if not
	move.w	d3,d0					; Slot 3 is reward index
	jsr	SlotMachine_GetReward
	jsr	SlotMachine_DoubleUp
	move.w	d0,slots_targ(a4)		; Store reward
	rts
; ===========================================================================
;loc_2C34A
SlotMachine_Match12:
	cmpi.b	#3,d2					; Is slot 2 a jackpot?
	bne.s	+						; Branch if not
	move.w	d3,d0					; Slot 3 is reward index
	bsr.s	SlotMachine_GetReward
	jsr	SlotMachine_QuadrupleUp
	move.w	d0,slots_targ(a4)		; Store reward
	rts
; ===========================================================================
+
	cmpi.b	#3,d3					; Is slot 3 a jackpot?
	bne.w	SlotMachine_Unmatched1	; Branch if not
	move.w	d2,d0					; Slot 2 is reward index
	bsr.s	SlotMachine_GetReward
	jsr	SlotMachine_DoubleUp
	move.w	d0,slots_targ(a4)		; Store reward
	rts
; ===========================================================================
;loc_2C374
SlotMachine_Unmatched1:
	cmp.b	d2,d3					; Are slots 2 and 3 equal?
	bne.s	SlotMachine_CheckBars	; Branch if not
	cmpi.b	#3,slot1_targ(a4)		; Is slot 1 a jackpot?
	bne.s	+						; Branch if not
	move.w	d2,d0					; Use slot 2 as reward index
	bsr.s	SlotMachine_GetReward
	jsr	SlotMachine_DoubleUp
	move.w	d0,slots_targ(a4)		; Store reward
	rts
; ===========================================================================
+
	cmpi.b	#3,d2					; Is slot 2 a jackpot?
	bne.s	SlotMachine_CheckBars	; Branch if not
	move.b	slot1_targ(a4),d0		; Get slot 1 face
	andi.w	#$F,d0					; Strip high nibble
	bsr.s	SlotMachine_GetReward
	jsr	SlotMachine_QuadrupleUp
	move.w	d0,slots_targ(a4)		; Store reward
	rts
; ===========================================================================
;loc_2C3A8
SlotMachine_CheckBars:
	moveq	#2,d1					; Number of rings per bar
	moveq	#0,d0					; Start with zero
	cmpi.b	#5,slot1_targ(a4)		; Is slot 1 a bar?
	bne.s	+						; Branch if not
	add.w	d1,d0					; Gain 2 rings
+
	cmpi.b	#5,d2					; Is slot 2 a bar?
	bne.s	+						; Branch if not
	add.w	d1,d0					; Gain 2 rings
+
	cmpi.b	#5,d3					; Is slot 3 a bar?
	bne.s	+						; Branch if not
	add.w	d1,d0					; Gain 2 rings
+
	move.w	d0,slots_targ(a4)		; Store reward
	; For bars, the code past this line is useless. There should be an rts here.

;loc_2C3CA
SlotMachine_GetReward:
	add.w	d0,d0					; Convert to index
	lea	(SlotRingRewards).l,a2		; Ring reward array
	move.w	(a2,d0.w),d0			; Get ring reward
	rts
; ===========================================================================
;loc_2C3D8
SlotMachine_QuadrupleUp:
	asl.w	#2,d0					; Quadruple reward
	rts
; ===========================================================================
;loc_2C3DC
SlotMachine_DoubleUp:
	add.w	d0,d0					; Double reward
	rts

; ===========================================================================
; data for the slot machines
;byte_2C3E0
SlotRingRewards:	dc.w   30,  25,  -1, 150,  10,  20
	rev02even
;byte_2C3EC
SlotTargetValues:	dc.b   8, 3,$33,  $12, 0,$00,  $12, 1,$11  ,$24, 2,$22
					dc.b $1E, 4,$44,  $1E, 5,$55,  $FF,$F,$FF
	rev02even
;byte_2C401
SlotSequence1:	dc.b   3,  0,  1,  4,  2,  5,  4,  1
	rev02even
;byte_2C409
SlotSequence2:	dc.b   3,  0,  1,  4,  2,  5,  0,  2
	rev02even
;byte_2C411
SlotSequence3:	dc.b   3,  0,  1,  4,  2,  5,  4,  1
	even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo10_SingleObjLoad ; JmpTo
	jmp	(SingleObjLoad).l
JmpTo29_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo10_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo6_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo54_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo12_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo7_SolidObject_Always_SingleCharacter ; JmpTo
	jmp	(SolidObject_Always_SingleCharacter).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object D7 - Bumper from Casino Night Zone
; ----------------------------------------------------------------------------
; Sprite_2C448:
ObjD7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD7_Index(pc,d0.w),d1
	jmp	ObjD7_Index(pc,d1.w)
; ===========================================================================
; off_2C456:
ObjD7_Index:	offsetTable
		offsetTableEntry.w ObjD7_Init	; 0
		offsetTableEntry.w ObjD7_Main	; 2
; ===========================================================================
; loc_2C45A:
ObjD7_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD7_MapUnc_2C626,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZHexBumper,2,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo55_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	#$CA,collision_flags(a0)
	btst	#0,status(a0)
	beq.s	+
	move.b	#1,objoff_38(a0)
+
	move.w	x_pos(a0),d0
	move.w	d0,d1
	subi.w	#$60,d0
	move.w	d0,objoff_34(a0)
	addi.w	#$60,d1
	move.w	d1,objoff_36(a0)
; loc_2C4AC:
ObjD7_Main:
	move.b	collision_property(a0),d0
	beq.w	ObjD7_MainContinued
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#0,collision_property(a0)
	beq.s	+
	bsr.s	ObjD7_BouncePlayerOff
+
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	+
	bsr.s	ObjD7_BouncePlayerOff
+
	clr.b	collision_property(a0)
	jmp	ObjD7_MainContinued
; ===========================================================================
; loc_2C4D8:
ObjD7_BouncePlayerOff:
	move.w	x_pos(a0),d1
	move.w	y_pos(a0),d2
	sub.w	x_pos(a1),d1
	sub.w	y_pos(a1),d2
	jsr	(CalcAngle).l
	addi.b	#$20,d0
	andi.w	#$C0,d0
	cmpi.w	#$40,d0
	beq.s	ObjD7_BounceDown
	cmpi.w	#$80,d0
	beq.s	ObjD7_BounceRight
	cmpi.w	#$C0,d0
	beq.s	ObjD7_BounceUp
	move.w	#-$800,x_vel(a1)
	move.b	#2,anim(a0)
	bra.s	ObjD7_BounceEnd
; ===========================================================================
; loc_2C516:
ObjD7_BounceDown:
	subi.w	#$200,x_vel(a1)
	tst.w	d1
	bpl.s	+
	addi.w	#$400,x_vel(a1)
+
	move.w	#-$800,y_vel(a1)
	move.b	#1,anim(a0)
	bra.s	ObjD7_BounceEnd
; ===========================================================================
; loc_2C534:
ObjD7_BounceRight:
	move.w	#$800,x_vel(a1)
	move.b	#2,anim(a0)
	bra.s	ObjD7_BounceEnd
; ===========================================================================
; loc_2C542:
ObjD7_BounceUp:
	subi.w	#$200,x_vel(a1)
	tst.w	d1
	bpl.s	+
	addi.w	#$400,x_vel(a1)
+
	move.w	#$800,y_vel(a1)
	move.b	#1,anim(a0)
; loc_2C55E:
ObjD7_BounceEnd:
	bset	#1,status(a1)
	bclr	#4,status(a1)
	bclr	#5,status(a1)
	clr.b	jumping(a1)
	move.w	#SndID_Bumper,d0
	jmp	(PlaySound).l
; ===========================================================================
; loc_2C57E:
ObjD7_MainContinued:
	lea	(Ani_objD7).l,a1
	jsrto	(AnimateSprite).l, JmpTo11_AnimateSprite
	tst.b	subtype(a0)
	beq.w	JmpTo30_MarkObjGone
	tst.b	objoff_38(a0)
	beq.s	loc_2C5AE
	move.w	x_pos(a0),d0
	subq.w	#1,d0
	cmp.w	objoff_34(a0),d0
	bne.s	+
	move.b	#0,objoff_38(a0)
+
	move.w	d0,x_pos(a0)
	bra.s	loc_2C5C4
; ===========================================================================

loc_2C5AE:
	move.w	x_pos(a0),d0
	addq.w	#1,d0
	cmp.w	objoff_36(a0),d0
	bne.s	+
	move.b	#1,objoff_38(a0)
+
	move.w	d0,x_pos(a0)

loc_2C5C4:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmpto	(DisplaySprite).l, JmpTo30_DisplaySprite
; ---------------------------------------------------------------------------
+
	move.w	objoff_34(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bls.s	+
	move.w	objoff_36(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	loc_2C5F8
+
	jmp	(DisplaySprite).l
; ===========================================================================

loc_2C5F8:
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	jmp	(DeleteObject).l

    if removeJmpTos
JmpTo30_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
    endif
; ===========================================================================
; animation script
; off_2C610:
Ani_objD7:	offsetTable
		offsetTableEntry.w byte_2C616	; 0
		offsetTableEntry.w byte_2C619	; 1
		offsetTableEntry.w byte_2C61F	; 2
byte_2C616:	dc.b  $F,  0,$FF
	rev02even
byte_2C619:	dc.b   3,  1,  0,  1,$FD,  0
	rev02even
byte_2C61F:	dc.b   3,  2,  0,  2,$FD,  0
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD7_MapUnc_2C626:	BINCLUDE "mappings/sprite/objD7.bin"
         even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo30_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo30_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo11_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo55_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object D8 - Block thingy from CNZ that disappears after 3 hits (UFO saucer-shaped)
; ----------------------------------------------------------------------------
; Sprite_2C6AC:
ObjD8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjD8_Index(pc,d0.w),d1
	jmp	ObjD8_Index(pc,d1.w)
; ===========================================================================
; off_2C6BA:
ObjD8_Index:	offsetTable
		offsetTableEntry.w ObjD8_Init	; 0
		offsetTableEntry.w loc_2C6FC	; 2
		offsetTableEntry.w loc_2C884	; 4
; ===========================================================================
; loc_2C6C0:
ObjD8_Init:
	addq.b	#2,routine(a0)
	move.l	#ObjD8_MapUnc_2C8C4,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo56_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#1,priority(a0)
	move.b	#$D7,collision_flags(a0)
	move.b	subtype(a0),d0
	rol.b	#2,d0
	andi.b	#3,d0
	move.b	d0,anim(a0)

loc_2C6FC:
	move.b	collision_property(a0),d0
	bne.w	loc_2C70A
	tst.w	objoff_34(a0)
	beq.s	loc_2C740

loc_2C70A:
	lea	objoff_34(a0),a4
	tst.b	(a4)
	beq.s	loc_2C716
	subq.b	#1,(a4)
	bra.s	loc_2C724
; ===========================================================================

loc_2C716:
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#0,collision_property(a0)
	beq.s	loc_2C724
	bsr.s	loc_2C74E

loc_2C724:
	addq.w	#1,a4
	tst.b	(a4)
	beq.s	loc_2C72E
	subq.b	#1,(a4)
	bra.s	loc_2C73C
; ===========================================================================

loc_2C72E:
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#1,collision_property(a0)
	beq.s	loc_2C73C
	bsr.s	loc_2C74E

loc_2C73C:
	clr.b	collision_property(a0)

loc_2C740:
	lea	(Ani_objD8).l,a1
	jsrto	(AnimateSprite).l, JmpTo12_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo31_MarkObjGone
; ===========================================================================

loc_2C74E:
	move.b	mapping_frame(a0),d0
	subq.b	#3,d0
	beq.s	loc_2C75C
	bcc.s	loc_2C77A
	addq.b	#3,d0
	bne.s	loc_2C77A

loc_2C75C:
	move.b	#3,anim(a0)
	move.w	#-$700,y_vel(a1)
	move.w	y_pos(a0),d2
	sub.w	y_pos(a1),d2
	bpl.s	BranchTo_loc_2C806
	neg.w	y_vel(a1)

BranchTo_loc_2C806 ; BranchTo
	jmp	loc_2C806
; ===========================================================================

loc_2C77A:
	subq.b	#1,d0
	bne.s	loc_2C7EC
	move.b	#4,anim(a0)
	move.w	#$20,d3
	btst	#0,status(a0)
	bne.s	loc_2C794
	move.w	#$60,d3

loc_2C794:
	move.w	x_vel(a1),d1
	move.w	y_vel(a1),d2
	jsr	(CalcAngle).l
	sub.w	d3,d0
	mvabs.w	d0,d1
	neg.w	d0
	add.w	d3,d0
	cmpi.b	#$40,d1
	bhs.s	loc_2C7BE
	cmpi.b	#$38,d1
	blo.s	loc_2C7D0
	move.w	d3,d0
	bra.s	loc_2C7D0
; ===========================================================================

loc_2C7BE:
	subi.w	#$80,d1
	neg.w	d1
	cmpi.b	#$38,d1
	blo.s	loc_2C7D0
	move.w	d3,d0
	addi.w	#$80,d0

loc_2C7D0:
	jsr	(CalcSine).l
	muls.w	#-$700,d1
	asr.l	#8,d1
	move.w	d1,x_vel(a1)
	muls.w	#-$700,d0
	asr.l	#8,d0
	move.w	d0,y_vel(a1)
	bra.s	loc_2C806
; ===========================================================================

loc_2C7EC:
	move.b	#5,anim(a0)
	move.w	#-$700,x_vel(a1)
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	bpl.s	loc_2C806
	neg.w	x_vel(a1)

loc_2C806:
	bset	#1,status(a1)
	bclr	#4,status(a1)
	bclr	#5,status(a1)
	clr.b	jumping(a1)
	move.w	#SndID_BonusBumper,d0
	jsr	(PlaySound).l
	movea.w	a1,a3
	moveq	#4,d3
	moveq	#1,d0
	subi.w	#palette_line_1,art_tile(a0)
	bcc.s	loc_2C85C
	addi.w	#palette_line_1,art_tile(a0)
	move.b	#4,routine(a0)
	lea	(CNZ_saucer_data).w,a1
	move.b	subtype(a0),d1
	andi.w	#$3F,d1		; This means CNZ_saucer_data is only $40 bytes large
	lea	(a1,d1.w),a1
	addq.b	#1,(a1)
	cmpi.b	#3,(a1)
	blo.s	loc_2C85C
	moveq	#2,d3
	moveq	#50,d0

loc_2C85C:
	jsr	(AddPoints2).l
	jsrto	(SingleObjLoad).l, JmpTo11_SingleObjLoad
	bne.s	loc_2C87E
	move.l	#Obj29,(a1) ; load obj29
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	d3,mapping_frame(a1)

loc_2C87E:
	move.b	#4,(a4)
	rts
; ===========================================================================

loc_2C884:
	lea	(Ani_objD8).l,a1
	jsrto	(AnimateSprite).l, JmpTo12_AnimateSprite
	cmpi.b	#3,anim(a0)
	blo.w	JmpTo46_DeleteObject
	jmpto	(MarkObjGone).l, JmpTo31_MarkObjGone

    if removeJmpTos
JmpTo46_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
; animation script
; off_2C89C:
Ani_objD8:	offsetTable
		offsetTableEntry.w byte_2C8A8	; 0
		offsetTableEntry.w byte_2C8AB	; 1
		offsetTableEntry.w byte_2C8AE	; 2
		offsetTableEntry.w byte_2C8B1	; 3
		offsetTableEntry.w byte_2C8B7	; 4
		offsetTableEntry.w byte_2C8BD	; 5
byte_2C8A8:	dc.b  $F,  0,$FF
	rev02even
byte_2C8AB:	dc.b  $F,  1,$FF
	rev02even
byte_2C8AE:	dc.b  $F,  2,$FF
	rev02even
byte_2C8B1:	dc.b   3,  3,  0,  3,$FD,  0
	rev02even
byte_2C8B7:	dc.b   3,  4,  1,  4,$FD,  1
	rev02even
byte_2C8BD:	dc.b   3,  5,  2,  5,$FD,  2
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjD8_MapUnc_2C8C4:	BINCLUDE "mappings/sprite/objD8.bin"
 even
; ===========================================================================

    if ~~removeJmpTos
JmpTo46_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo11_SingleObjLoad ; JmpTo
	jmp	(SingleObjLoad).l
JmpTo31_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo12_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo56_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif

