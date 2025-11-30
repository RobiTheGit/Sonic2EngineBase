



; ----------------------------------------------------------------------------
; Object 18 - Stationary floating platform from ARZ, EHZ and HTZ
; ----------------------------------------------------------------------------
; Sprite_104AC:
Obj18:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj18_Index(pc,d0.w),d1
	jmp	Obj18_Index(pc,d1.w)
; ===========================================================================
; off_104BA:
Obj18_Index:	offsetTable
		offsetTableEntry.w Obj18_Init			; 0
		offsetTableEntry.w loc_1056A			; 2
		offsetTableEntry.w BranchTo3_DeleteObject	; 4
		offsetTableEntry.w loc_105A8			; 6
		offsetTableEntry.w loc_105D4			; 8
; ===========================================================================
;word_104C4:
Obj18_InitData:
	;    width_pixels
	;	 frame
	dc.b $20, 0
	dc.b $20, 1
	dc.b $20, 2
	dc.b $40, 3
	dc.b $30, 4
; ===========================================================================
; loc_104CE:
Obj18_Init:
	addq.b	#2,routine(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#3,d0
	andi.w	#$E,d0
	lea	Obj18_InitData(pc,d0.w),a2
	move.b	(a2)+,width_pixels(a0)
	move.b	(a2)+,mapping_frame(a0)
	move.l	#Obj18_MapUnc_107F6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj18_MapUnc_1084E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
+
	move.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.w	y_pos(a0),objoff_30(a0)
	move.w	y_pos(a0),objoff_38(a0)
	move.w	x_pos(a0),objoff_36(a0)
	move.w	#$80,angle(a0)
	tst.b	subtype(a0)
	bpl.s	++
	addq.b	#6,routine(a0)
	andi.b	#$F,subtype(a0)
	move.b	#$30,y_radius(a0)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	+
	move.b	#$28,y_radius(a0)
+
	bset	#4,render_flags(a0)
	bra.w	loc_105D4
; ===========================================================================
+
	andi.b	#$F,subtype(a0)

loc_1056A:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	tst.b	objoff_3C(a0)
	beq.s	++
	subq.b	#4,objoff_3C(a0)
	bra.s	++
; ===========================================================================
+
	cmpi.b	#$40,objoff_3C(a0)
	beq.s	+
	addq.b	#4,objoff_3C(a0)
+
	move.w	x_pos(a0),-(sp)
	bsr.w	sub_10638
	bsr.w	sub_1061E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#8,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject).l, JmpTo_PlatformObject
	bra.s	loc_105B0
; ===========================================================================

loc_105A8:
	bsr.w	sub_10638
	bsr.w	sub_1061E

loc_105B0:
	tst.w	(Two_player_mode).w
	beq.s	+
	bra.w	DisplaySprite
; ===========================================================================
+
	move.w	objoff_36(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.s	BranchTo3_DeleteObject
	bra.w	DisplaySprite
; ===========================================================================

BranchTo3_DeleteObject
	bra.w	DeleteObject
; ===========================================================================

loc_105D4:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	tst.b	objoff_3C(a0)
	beq.s	++
	subq.b	#4,objoff_3C(a0)
	bra.s	++
; ===========================================================================
+
	cmpi.b	#$40,objoff_3C(a0)
	beq.s	+
	addq.b	#4,objoff_3C(a0)
+
	move.w	x_pos(a0),-(sp)
	bsr.w	sub_10638
	bsr.w	sub_1061E
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	addi.w	#$B,d1
	moveq	#0,d2
	move.b	y_radius(a0),d2
	move.w	d2,d3
	addq.w	#1,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo_SolidObject
	bra.s	loc_105B0

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1061E:
	move.b	objoff_3C(a0),d0
	jsrto	(CalcSine).l, JmpTo3_CalcSine
	move.w	#$400,d1
	muls.w	d1,d0
	swap	d0
	add.w	objoff_30(a0),d0
	move.w	d0,y_pos(a0)
	rts
; End of function sub_1061E


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_10638:
	moveq	#0,d0
	move.b	subtype(a0),d0
	andi.w	#$F,d0
	add.w	d0,d0
	move.w	Obj18_Behaviours(pc,d0.w),d1
	jmp	Obj18_Behaviours(pc,d1.w)
; End of function sub_10638

; ===========================================================================
; off_1064C:
Obj18_Behaviours: offsetTable
	offsetTableEntry.w return_10668	;  0
	offsetTableEntry.w loc_1067A	;  1
	offsetTableEntry.w loc_106C0	;  2
	offsetTableEntry.w loc_106D8	;  3
	offsetTableEntry.w loc_10702	;  4
	offsetTableEntry.w loc_1066A	;  5
	offsetTableEntry.w loc_106B0	;  6
	offsetTableEntry.w loc_10778	;  7
	offsetTableEntry.w loc_107A4	;  8
	offsetTableEntry.w return_10668	;  9
	offsetTableEntry.w loc_107BC	; $A
	offsetTableEntry.w loc_107D6	; $B
	offsetTableEntry.w loc_106A2	; $C
	offsetTableEntry.w loc_10692	; $D
; ===========================================================================

return_10668:
	rts
; ===========================================================================

loc_1066A:
	move.w	objoff_36(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	bra.s	loc_10686
; ===========================================================================

loc_1067A:
	move.w	objoff_36(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1

loc_10686:
	ext.w	d1
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	bra.w	loc_107EE
; ===========================================================================

loc_10692:
	move.w	objoff_38(a0),d0
	move.b	(Oscillating_Data+$C).w,d1
	neg.b	d1
	addi.b	#$30,d1
	bra.s	loc_106CC
; ===========================================================================

loc_106A2:
	move.w	objoff_38(a0),d0
	move.b	(Oscillating_Data+$C).w,d1
	subi.b	#$30,d1
	bra.s	loc_106CC
; ===========================================================================

loc_106B0:
	move.w	objoff_38(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	bra.s	loc_106CC
; ===========================================================================

loc_106C0:
	move.w	objoff_38(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1

loc_106CC:
	ext.w	d1
	add.w	d1,d0
	move.w	d0,objoff_30(a0)
	bra.w	loc_107EE
; ===========================================================================

loc_106D8:
	tst.w	objoff_3E(a0)
	bne.s	loc_106F0
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+	; rts
	move.w	#$1E,objoff_3E(a0)
/
	rts
; ===========================================================================

loc_106F0:
	subq.w	#1,objoff_3E(a0)
	bne.s	-	; rts
	move.w	#$20,objoff_3E(a0)
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_10702:
	tst.w	objoff_3E(a0)
	beq.s	loc_10730
	subq.w	#1,objoff_3E(a0)
	bne.s	loc_10730
	bclr	#p1_standing_bit,status(a0)
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_1075E
+
	bclr	#p2_standing_bit,status(a0)
	beq.s	+
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	sub_1075E
+
	move.b	#6,routine(a0)

loc_10730:
	move.l	objoff_30(a0),d3
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d3,objoff_30(a0)
	addi.w	#$38,y_vel(a0)
	move.w	(Camera_Max_Y_pos_now).w,d0
	addi.w	#$120,d0
	cmp.w	objoff_30(a0),d0
	bhs.s	+	; rts
	move.b	#4,routine(a0)
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1075E:
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	move.w	y_vel(a0),y_vel(a1)
	rts
; End of function sub_1075E

; ===========================================================================

loc_10778:
	tst.w	objoff_3E(a0)
	bne.s	loc_10798
	lea	(ButtonVine_Trigger).w,a2
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsr.w	#4,d0
	tst.b	(a2,d0.w)
	beq.s	+	; rts
	move.w	#$3C,objoff_3E(a0)
/
	rts
; ===========================================================================

loc_10798:
	subq.w	#1,objoff_3E(a0)
	bne.s	-	; rts
	addq.b	#1,subtype(a0)
	rts
; ===========================================================================

loc_107A4:
	subq.w	#2,objoff_30(a0)
	move.w	objoff_38(a0),d0
	subi.w	#$200,d0
	cmp.w	objoff_30(a0),d0
	bne.s	+	; rts
	clr.b	subtype(a0)
+
	rts
; ===========================================================================

loc_107BC:
	move.w	objoff_38(a0),d0
	move.b	angle(a0),d1
	subi.b	#$40,d1
	ext.w	d1
	asr.w	#1,d1
	add.w	d1,d0
	move.w	d0,objoff_30(a0)
	bra.w	loc_107EE
; ===========================================================================

loc_107D6:
	move.w	objoff_38(a0),d0
	move.b	angle(a0),d1
	neg.b	d1
	addi.b	#$40,d1
	ext.w	d1
	asr.w	#1,d1
	add.w	d1,d0
	move.w	d0,objoff_30(a0)

loc_107EE:
	move.b	(Oscillating_Data+$18).w,angle(a0)
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj18_MapUnc_107F6:	BINCLUDE "mappings/sprite/obj18_a.bin"
      even
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj18_MapUnc_1084E:	BINCLUDE "mappings/sprite/obj18_b.bin"
       even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo3_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
JmpTo_SolidObject ; JmpTo
	jmp	(SolidObject).l

	align 4
    endif




; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1A - Collapsing platform from HPZ (and GHZ)
; also supports OOZ, but never made use of
;
; Unlike Object 1F, this supports sloped platforms and subtype-dependant
; mappings. Both are used by GHZ, the latter to allow different shading
; on right-facing ledges.
; ----------------------------------------------------------------------------
; Sprite_108BC:
Obj1A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1A_Index(pc,d0.w),d1
	jmp	Obj1A_Index(pc,d1.w)
; ===========================================================================
; off_108CA:
Obj1A_Index:	offsetTable
		offsetTableEntry.w Obj1A_Init		; 0
		offsetTableEntry.w Obj1A_Main		; 2
		offsetTableEntry.w Obj1A_Fragment	; 4
; ===========================================================================

collapsing_platform_delay_pointer = objoff_38
collapsing_platform_delay_counter = objoff_3C
collapsing_platform_stood_on_flag = objoff_3E
collapsing_platform_slope_pointer = objoff_40

; loc_108D0:
Obj1A_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj1A_MapUnc_10C6C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#7,collapsing_platform_delay_counter(a0)
	move.b	subtype(a0),mapping_frame(a0)
	move.l	#Obj1A_DelayData,collapsing_platform_delay_pointer(a0)
	cmpi.b	#hidden_palace_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1A_MapUnc_1101C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HPZPlatform,2,0),art_tile(a0)
	move.b	#$30,width_pixels(a0)
	move.l	#Obj1A_HPZ_SlopeData,collapsing_platform_slope_pointer(a0)
	move.l	#Obj1A_HPZ_DelayData,collapsing_platform_delay_pointer(a0)
	bra.s	Obj1A_Main
; ===========================================================================
+
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1F_MapUnc_110C6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0),art_tile(a0)
	move.b	#$40,width_pixels(a0)
	move.l	#Obj1A_OOZ_SlopeData,collapsing_platform_slope_pointer(a0)
	bra.s	Obj1A_Main
; ===========================================================================
+
	move.l	#Obj1A_GHZ_SlopeData,collapsing_platform_slope_pointer(a0)
	move.b	#$34,width_pixels(a0)
	move.b	#$38,y_radius(a0)
	bset	#4,render_flags(a0)
; loc_1097C:
Obj1A_Main:
	tst.b	collapsing_platform_stood_on_flag(a0)
	beq.s	+
	tst.b	collapsing_platform_delay_counter(a0)
	beq.w	Obj1A_CreateFragments	; time up; collapse
	subq.b	#1,collapsing_platform_delay_counter(a0)
+
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	sub_1099E
	move.b	#1,collapsing_platform_stood_on_flag(a0)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_1099E:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	movea.l	collapsing_platform_slope_pointer(a0),a2 ; a2=object
	move.w	x_pos(a0),d4
	jsrto	(SlopedPlatform).l, JmpTo_SlopedPlatform
	bra.w	MarkObjGone
; End of function sub_1099E

; ===========================================================================
; loc_109B4:
Obj1A_Fragment:
	tst.b	collapsing_platform_delay_counter(a0)
	beq.s	Obj1A_FragmentFall	; time up; collapse
	tst.b	collapsing_platform_stood_on_flag(a0)
	bne.s	+
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
+
	bsr.w	sub_1099E
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bne.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_109DC
	lea	(Sidekick).w,a1 ; a1=character

sub_109DC:
	btst	#3,status(a1)
	beq.s	+
	bclr	#3,status(a1)
	bclr	#5,status(a1)
	move.b	#AniIDSonAni_Run,prev_anim(a1)	; Force player's animation to restart
+
	rts
; End of function sub_109DC

; ===========================================================================
; loc_109F8:
Obj1A_FragmentFall:
	bsr.w	ObjectMoveAndFall
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 1F - Collapsing platform from ARZ, MCZ and OOZ (and MZ, SLZ and SBZ)
; ----------------------------------------------------------------------------
; Sprite_10A08:
Obj1F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj1F_Index(pc,d0.w),d1
	jmp	Obj1F_Index(pc,d1.w)
; ===========================================================================
; off_10A16:
Obj1F_Index:	offsetTable
		offsetTableEntry.w Obj1F_Init		; 0
		offsetTableEntry.w Obj1F_Main		; 2
		offsetTableEntry.w Obj1F_Fragment	; 4
; ===========================================================================
; loc_10A1C:
Obj1F_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj1F_MapUnc_10F0C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MZ_Platform,2,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	move.b	#7,collapsing_platform_delay_counter(a0)
	move.b	#$44,width_pixels(a0)
	lea	(Obj1F_DelayData_EvenSubtype).l,a4
	btst	#0,subtype(a0)
	beq.s	+
	lea	(Obj1F_DelayData_OddSubtype).l,a4
+
	move.l	a4,collapsing_platform_delay_pointer(a0)
	cmpi.b	#oil_ocean_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1F_MapUnc_110C6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0),art_tile(a0)
	move.b	#$40,width_pixels(a0)
	move.l	#Obj1F_OOZ_DelayData,collapsing_platform_delay_pointer(a0)
+
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.s	+
	move.l	#Obj1F_MapUnc_11106,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MCZCollapsePlat,3,0),art_tile(a0)
	move.b	#$20,width_pixels(a0)
	move.l	#Obj1F_MCZ_DelayData,collapsing_platform_delay_pointer(a0)
+
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	Obj1F_Main
	move.l	#Obj1F_MapUnc_1115E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,2,0),art_tile(a0)
	move.b	#$20,width_pixels(a0)
	move.l	#Obj1F_ARZ_DelayData,collapsing_platform_delay_pointer(a0)
; loc_10AD6:
Obj1F_Main:
	tst.b	collapsing_platform_stood_on_flag(a0)
	beq.s	+
	tst.b	collapsing_platform_delay_counter(a0)
	beq.w	Obj1F_CreateFragments	; time up; collapse
	subq.b	#1,collapsing_platform_delay_counter(a0)
+
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	sub_10AF8
	move.b	#1,collapsing_platform_stood_on_flag(a0)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_10AF8:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	jsrto	(PlatformObject).l, JmpTo2_PlatformObject
	bra.w	MarkObjGone
; End of function sub_10AF8

; ===========================================================================
; loc_10B0E:
Obj1F_Fragment:
	tst.b	collapsing_platform_delay_counter(a0)
	beq.s	Obj1F_FragmentFall	; time up; collapse
	tst.b	collapsing_platform_stood_on_flag(a0)
	bne.s	+
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bra.w	DisplaySprite
; ===========================================================================
+
	bsr.w	sub_10AF8
	subq.b	#1,collapsing_platform_delay_counter(a0)
	bne.s	+	; rts
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	sub_10B36
	lea	(Sidekick).w,a1 ; a1=character

sub_10B36:
	btst	#3,status(a1)
	beq.s	+	; rts
	bclr	#3,status(a1)
	bclr	#5,status(a1)
	move.b	#AniIDSonAni_Run,prev_anim(a1)	; Force player's animation to restart
+
	rts
; End of function sub_10B36

; ===========================================================================
; loc_10B52:
Obj1F_FragmentFall:
	bsr.w	ObjectMoveAndFall
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; loc_10B62:
Obj1F_CreateFragments:
	addq.b	#1,mapping_frame(a0)
	bra.s	+
; ===========================================================================
; loc_10B68:
Obj1A_CreateFragments:
	addq.b	#2,mapping_frame(a0)
+
	movea.l	collapsing_platform_delay_pointer(a0),a4
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	add.w	d0,d0
	movea.l	mappings(a0),a3
	adda.w	(a3,d0.w),a3
	move.w	(a3)+,d1
	subq.w	#1,d1
	bset	#5,render_flags(a0)
	move.l	(a0),d4
	move.b	render_flags(a0),d5
	movea.l	a0,a1
	bra.s	+
; ===========================================================================
-	bsr.w	SingleObjLoad
	bne.s	+++
	addq.w	#8,a3
+
	move.b	#4,routine(a1)
	move.l	d4,(a1) ; load obj1F
	move.l	a3,mappings(a1)
	move.b	d5,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	priority(a0),priority(a1)
	move.b	width_pixels(a0),width_pixels(a1)
	move.b	y_radius(a0),y_radius(a1)
	move.b	(a4)+,collapsing_platform_delay_counter(a1)
	cmpa.l	a0,a1
	bhs.s	+
	bsr.w	DisplaySprite2
+	dbf	d1,-
+
	bsr.w	DisplaySprite
	move.w	#SndID_Smash,d0
	jmp	(PlaySound).l
; ===========================================================================
; Delay data for obj1A in all but HPZ:
;byte_10BF2:
Obj1A_DelayData:
	dc.b $1C,$18,$14,$10,$1A,$16,$12, $E, $A,  6,$18,$14,$10, $C,  8,  4
	dc.b $16,$12, $E, $A,  6,  2,$14,$10, $C; 16
	rev02even
; Delay data for obj1A in HPZ:
;byte_10C0B:
Obj1A_HPZ_DelayData:
	dc.b $18,$1C,$20,$1E,$1A,$16,  6, $E,$14,$12, $A,  2
	rev02even
; Delay data for obj1F even subtypes in all levels without more specific data:
;byte_10C17:
Obj1F_DelayData_EvenSubtype:
	dc.b $1E,$16, $E,  6,$1A,$12, $A,  2
	rev02even
; Delay data for obj1F odd subtypes in all levels without more specific data:
;byte_10C1F:
Obj1F_DelayData_OddSubtype:
	dc.b $16,$1E,$1A,$12,  6, $E, $A,  2
	rev02even
; Delay data for obj1F in OOZ:
;byte_10C27:
Obj1F_OOZ_DelayData:
	dc.b $1A,$12, $A,  2,$16, $E,  6
	rev02even
; Delay data for obj1F in MCZ:
;byte_10C2E:
Obj1F_MCZ_DelayData:
	dc.b $1A,$16,$12, $E, $A,  2
	rev02even
; Delay data for obj1F in ARZ:
;byte_10C34:
Obj1F_ARZ_DelayData:
	dc.b $16,$1A,$18,$12,  6, $E, $A,  2
	rev02even
; S1 remnant: Height data for GHZ collapsing platform (unused):
;byte_10C3C:
Obj1A_GHZ_SlopeData:
	dc.b $20,$20,$20,$20,$20,$20,$20,$20,$21,$21,$22,$22,$23,$23,$24,$24
	dc.b $25,$25,$26,$26,$27,$27,$28,$28,$29,$29,$2A,$2A,$2B,$2B,$2C,$2C; 16
	dc.b $2D,$2D,$2E,$2E,$2F,$2F,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30; 32
	even
; -------------------------------------------------------------------------------
; unused sprite mappings (GHZ)
; -------------------------------------------------------------------------------
Obj1A_MapUnc_10C6C:	BINCLUDE "mappings/sprite/obj1A_a.bin"
          even
; ----------------------------------------------------------------------------
; unused sprite mappings (MZ, SLZ, SBZ)
; ----------------------------------------------------------------------------
Obj1F_MapUnc_10F0C:	BINCLUDE "mappings/sprite/obj1F_a.bin"
               even
; Slope data for platforms.
;byte_10FDC:
Obj1A_OOZ_SlopeData:
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	even
;byte_10FEC:
Obj1A_HPZ_SlopeData
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	dc.b $10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10,$10
	even
; ----------------------------------------------------------------------------
; sprite mappings (HPZ)
; ----------------------------------------------------------------------------
Obj1A_MapUnc_1101C:	BINCLUDE "mappings/sprite/obj1A_b.bin"
         even
; ----------------------------------------------------------------------------
; sprite mappings (OOZ)
; ----------------------------------------------------------------------------
Obj1F_MapUnc_110C6:	BINCLUDE "mappings/sprite/obj1F_b.bin"
     even
; -------------------------------------------------------------------------------
; sprite mappings (MCZ)
; -------------------------------------------------------------------------------
Obj1F_MapUnc_11106:	BINCLUDE "mappings/sprite/obj1F_c.bin"
          even
; -------------------------------------------------------------------------------
; sprite mappings (ARZ)
; -------------------------------------------------------------------------------
Obj1F_MapUnc_1115E:	BINCLUDE "mappings/sprite/obj1F_d.bin"
          even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_SlopedPlatform ; JmpTo
	jmp	(SlopedPlatform).l
JmpTo2_PlatformObject ; JmpTo
	jmp	(PlatformObject).l

	align 4
    endif



