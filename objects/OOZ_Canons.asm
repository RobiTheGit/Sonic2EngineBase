

BlockTHingLaunchBits = $2E
SonicStoredAnim = $30
TailsStoredAnim = $31
SonicLastSpeed_3D = $32
TailsLastSpeed_3D = $34
Launcher_Bits = $36
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3D - Block thingy in OOZ that launches you into the round ball things
; ----------------------------------------------------------------------------
; Sprite_24DD0:
Obj3D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3D_Index(pc,d0.w),d1
	jmp	Obj3D_Index(pc,d1.w)
; ===========================================================================
; off_24DDE:
Obj3D_Index:	offsetTable
		offsetTableEntry.w Obj3D_Init			; 0
		offsetTableEntry.w Obj3D_Main			; 2
		offsetTableEntry.w Obj3D_Fragment		; 4
		offsetTableEntry.w Obj3D_InvisibleLauncher	; 6
; ===========================================================================
; loc_24DE6:
Obj3D_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj3D_MapUnc_250BA,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_StripedBlocksVert,3,0),art_tile(a0)
	tst.b	subtype(a0)
	beq.s	+
	move.w	#make_art_tile(ArtTile_ArtNem_StripedBlocksHoriz,3,0),art_tile(a0)
	move.b	#2,mapping_frame(a0)
+

	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	bset	#7,status(a0)
	move.b	#4,priority(a0)
; loc_24E26:
Obj3D_Main:
	move.b	(MainCharacter+anim).w,SonicStoredAnim(a0)
	move.b	(Sidekick+anim).w,TailsStoredAnim(a0)
	move.w	(MainCharacter+y_vel).w,SonicLastSpeed_3D(a0)
	move.w	(Sidekick+y_vel).w,TailsLastSpeed_3D(a0)
	move.w	#$1B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo7_SolidObject
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	loc_24E60

BranchTo_JmpTo13_MarkObjGone
	jmpto	(MarkObjGone).l, JmpTo13_MarkObjGone
; ===========================================================================

loc_24E60:
	cmpi.b	#standing_mask,d0
	bne.s	loc_24E96
	cmpi.b	#AniIDSonAni_Roll,SonicStoredAnim(a0)
	beq.s	loc_24E76
	cmpi.b	#AniIDSonAni_Roll,TailsStoredAnim(a0)
	bne.s	BranchTo_JmpTo13_MarkObjGone

loc_24E76:
	lea	(MainCharacter).w,a1 ; a1=character
	move.b	SonicStoredAnim(a0),d0
	move.w	SonicLastSpeed_3D(a0),d1
	bsr.s	loc_24EB2
	lea	(Sidekick).w,a1 ; a1=character
	move.b	TailsStoredAnim(a0),d0
	move.w	TailsLastSpeed_3D(a0),d1
	bsr.s	loc_24EB2
	jmp	loc_24F04
; ===========================================================================

loc_24E96:
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	loc_24EE8
	cmpi.b	#AniIDSonAni_Roll,SonicStoredAnim(a0)
	bne.s	BranchTo_JmpTo13_MarkObjGone
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	SonicLastSpeed_3D(a0),d1
	bsr.s	loc_24EB8
	bra.s	loc_24F04
; ===========================================================================

loc_24EB2:
	cmpi.b	#AniIDSonAni_Roll,d0
	bne.s	loc_24ED4

loc_24EB8:
	bset	#2,status(a1)
	move.b	#$E,y_radius(a1)
	move.b	#7,x_radius(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	d1,y_vel(a1)

loc_24ED4:
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#2,routine(a1)
	rts
; ===========================================================================

loc_24EE8:
	andi.b	#p2_standing,d0
	beq.w	BranchTo_JmpTo13_MarkObjGone
	cmpi.b	#AniIDSonAni_Roll,TailsStoredAnim(a0)
	bne.w	BranchTo_JmpTo13_MarkObjGone
	lea	(Sidekick).w,a1 ; a1=character
	move.w	TailsLastSpeed_3D(a0),d1
	bsr.s	loc_24EB8

loc_24F04:
	andi.b	#~standing_mask,status(a0)
	jsrto	(SingleObjLoad2).l, JmpTo9_SingleObjLoad2
	bne.s	loc_24F28
	moveq	#0,d0
	move.w	#bytesToLcnt(objoff_30),d1 ; copys obj ram from og slot to new ones copies only the first $2E ssts

loc_24F16:
	move.l	(a0,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,loc_24F16
	move.b	#6,routine(a1)

loc_24F28:
	lea	(word_2507A).l,a4
	addq.b	#1,mapping_frame(a0)
	moveq	#$F,d1
	move.w	#$18,d2
	jsrto	(BreakObjectToPieces).l, JmpTo2_BreakObjectToPieces
; loc_24F3C:
Obj3D_Fragment:
	jsrto	(ObjectMove).l, JmpTo10_ObjectMove
	addi.w	#$18,y_vel(a0)
	tst.b	render_flags(a0)
	bpl.w	JmpTo26_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo14_DisplaySprite

; ===========================================================================
; loc_24F52:
Obj3D_InvisibleLauncher:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	BlockTHingLaunchBits(a0),a4
	bsr.s	loc_24F74
	lea	(Sidekick).w,a1 ; a1=character
	lea	Launcher_Bits(a0),a4
	bsr.s	loc_24F74
	move.b	BlockTHingLaunchBits(a0),d0
	add.b	Launcher_Bits(a0),d0
	beq.w	JmpTo3_MarkObjGone3
	rts
; ===========================================================================

loc_24F74:
	moveq	#0,d0
	move.b	(a4),d0
	move.w	off_24F80(pc,d0.w),d0
	jmp	off_24F80(pc,d0.w)
; ===========================================================================
off_24F80:	offsetTable
		offsetTableEntry.w loc_24F84	; 0
		offsetTableEntry.w loc_25036	; 2
; ===========================================================================

loc_24F84:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.w	return_25034
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	tst.b	subtype(a0)
	beq.s	loc_24FAA
	addi.w	#$10,d1

loc_24FAA:
	cmpi.w	#$10,d1
	bhs.w	return_25034
	cmpa.w	#Sidekick,a1
	bne.s	loc_24FC2
	cmpi.w	#4,(Tails_CPU_routine).w ; TailsCPU_Flying
	beq.w	return_25034

loc_24FC2:
	addq.b	#2,(a4)
	move.b	#$81,obj_control(a1)
	move.b	#AniIDSonAni_Roll,anim(a1)
	move.w	#$800,inertia(a1)
	tst.b	subtype(a0)
	beq.s	loc_24FF0   ; beq
	move.w	x_pos(a0),x_pos(a1)
	move.w	#0,x_vel(a1)
	move.w	#-$800,y_vel(a1)
	bra.s	loc_25002
; ===========================================================================

loc_24FF0:
	move.w	y_pos(a0),y_pos(a1)
	move.w	#$800,x_vel(a1)
	move.w	#0,y_vel(a1)

loc_25002:
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bset	#1,status(a1)
	bset	#3,status(a1)

	movea.w	a0,interact(a1)
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l

return_25034:
	rts
; ===========================================================================

loc_25036:
	tst.b	render_flags(a1)
	bmi.s	Obj3D_MoveCharacter
	move.b	#0,obj_control(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#0,(a4)
	rts
; ===========================================================================
; update the position of Sonic/Tails from the block thing to the launcher
; loc_25054:
Obj3D_MoveCharacter:
	move.l	x_pos(a1),d2
	move.l	y_pos(a1),d3
	move.w	x_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,x_pos(a1)
	move.l	d3,y_pos(a1)
	rts
; ===========================================================================
word_2507A:
	dc.w -$400,-$400 ; 0
	dc.w -$200,-$400 ; 2
	dc.w  $200,-$400 ; 4
	dc.w  $400,-$400 ; 6
	dc.w -$3C0,-$200 ; 8
	dc.w -$1C0,-$200 ; 10
	dc.w  $1C0,-$200 ; 12
	dc.w  $3C0,-$200 ; 14
	dc.w -$380, $200 ; 16
	dc.w -$180, $200 ; 18
	dc.w  $180, $200 ; 20
	dc.w  $380, $200 ; 22
	dc.w -$340, $400 ; 24
	dc.w -$140, $400 ; 26
	dc.w  $140, $400 ; 28
	dc.w  $340, $400 ; 30
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj3D_MapUnc_250BA:	BINCLUDE "mappings/sprite/obj3D.bin"
       even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo14_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo26_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo13_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo9_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo3_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
JmpTo22_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo2_BreakObjectToPieces ; JmpTo
	jmp	(BreakObjectToPieces).l
JmpTo7_SolidObject ; JmpTo
	jmp	(SolidObject).l
; loc_2523C:
JmpTo10_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    else
JmpTo3_MarkObjGone3 ; JmpTo
	jmp	(MarkObjGone3).l
JmpTo26_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
; Unused
;JmpTo13_MarkObjGone
	jmp	(MarkObjGone).l
    endif


RoundBall_BitField = BlockTHingLaunchBits

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 48 - Round ball thing from OOZ that fires you off in a different direction (sphere)
; ----------------------------------------------------------------------------
; Sprite_25244:
Obj48:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj48_Index(pc,d0.w),d1
	jsr	Obj48_Index(pc,d1.w)
	move.b	BlockTHingLaunchBits(a0),d0
	add.b	Launcher_Bits(a0),d0
	beq.w	JmpTo14_MarkObjGone
	jmpto	(DisplaySprite).l, JmpTo15_DisplaySprite

    if removeJmpTos
JmpTo14_MarkObjGone
	jmp	(MarkObjGone).l
    endif
; ===========================================================================
; off_25262:
Obj48_Index:	offsetTable
		offsetTableEntry.w Obj48_Init	; 0
		offsetTableEntry.w Obj48_Main	; 2
; ===========================================================================
; byte_25266:
Obj48_Properties:
	;      render_flags
	;	   objoff_3F
	dc.b   4,  0	; 0
	dc.b   6,  7	; 2
	dc.b   7,  0	; 4
	dc.b   5,  7	; 6
	dc.b   5,  0	; 8
	dc.b   4,  7	; 10
	dc.b   6,  0	; 12
	dc.b   7,  7	; 14
; ===========================================================================
; loc_25276:
Obj48_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj48_MapUnc_254FE,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_LaunchBall,3,0),art_tile(a0)

	move.b	subtype(a0),d0
	andi.w	#$F,d0
	btst	#0,status(a0)
	beq.s	+
	addq.w	#4,d0
+
	add.w	d0,d0
	move.b	Obj48_Properties(pc,d0.w),render_flags(a0)
	move.b	Obj48_Properties+1(pc,d0.w),objoff_3F(a0)
	beq.s	+
	move.b	#1,objoff_3E(a0)
+
	move.b	objoff_3F(a0),mapping_frame(a0)
	move.b	#$28,width_pixels(a0)
	move.b	#1,priority(a0)
; loc_252C6:
Obj48_Main:
	lea	(MainCharacter).w,a1 ; a1=character
	lea	RoundBall_BitField(a0),a4
	moveq	#RoundBall_BitField,d2 ;aurora feilds said this is fine so :P
	bsr.s	loc_252DC
	lea	(Sidekick).w,a1 ; a1=character
	lea	Launcher_Bits(a0),a4
	moveq	#Launcher_Bits,d2

loc_252DC:
	moveq	#0,d0
	move.b	(a4),d0
	move.w	Obj48_Modes(pc,d0.w),d0
	jmp	Obj48_Modes(pc,d0.w)
; ===========================================================================
; off_252E8:
Obj48_Modes:	offsetTable
		offsetTableEntry.w loc_252F0	; 0
		offsetTableEntry.w loc_253C6	; 2
		offsetTableEntry.w loc_25474	; 4
		offsetTableEntry.w loc_254F2	; 6
; ===========================================================================

loc_252F0:
	tst.w	(Debug_placement_mode).w
	bne.w	return_253C4
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$10,d0
	cmpi.w	#$20,d0
	bhs.w	return_253C4
	move.w	y_pos(a1),d1
	sub.w	y_pos(a0),d1
	addi.w	#$10,d1
	cmpi.w	#$20,d1
	bhs.w	return_253C4
	cmpa.w	#Sidekick,a1
	bne.s	+
	cmpi.w	#4,(Tails_CPU_routine).w	; TailsCPU_Flying
	beq.w	return_253C4
+
	cmpi.b	#6,routine(a1)
	bhs.w	return_253C4
	tst.w	(Debug_placement_mode).w
	bne.w	return_253C4
	btst	#3,status(a1)
	beq.s	+

	movea.w	interact(a1),a3

	move.b	#0,(a3,d2.w)
+

	movea.w	a0,interact(a1)
	addq.b	#2,(a4)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#$81,obj_control(a1)
	move.b	#2,anim(a1)
	move.w	#$1000,inertia(a1)
	move.w	#0,x_vel(a1)
	move.w	#0,y_vel(a1)
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bset	#1,status(a1)
	bset	#3,status(a1)
	move.b	objoff_3F(a0),mapping_frame(a0)
	move.w	#SndID_Roll,d0
	jsr	(PlaySound).l

return_253C4:
	rts
; ===========================================================================

loc_253C6:
	tst.b	objoff_3E(a0)
	bne.s	loc_253EE
	cmpi.b	#7,mapping_frame(a0)
	beq.s	loc_25408
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	return_253EC
	move.w	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#7,mapping_frame(a0)
	beq.s	loc_25408

return_253EC:
	rts
; ===========================================================================

loc_253EE:
	tst.b	mapping_frame(a0)
	beq.s	loc_25408
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	return_253EC
	move.w	#7,anim_frame_duration(a0)
	subq.b	#1,mapping_frame(a0)
	beq.s	loc_25408
	rts
; ===========================================================================

loc_25408:
	addq.b	#2,(a4)
	move.b	subtype(a0),d0
	addq.b	#1,d0
	btst	#0,status(a0)
	beq.s	+
	subq.b	#2,d0
+
	andi.w	#3,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	word_25464(pc,d0.w),x_vel(a1)
	move.w	word_25464+2(pc,d0.w),y_vel(a1)
	move.w	#3,anim_frame_duration(a0)
	tst.b	subtype(a0)
	bpl.s	return_25462
	move.b	#0,obj_control(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#0,jumping(a1)
	move.b	#2,routine(a1)
	move.b	#6,(a4)
	move.w	#7,objoff_3C(a0)

return_25462:
	rts
; ===========================================================================
word_25464:
	dc.w	  0,-$1000
	dc.w  $1000,     0	; 2
	dc.w	  0, $1000	; 4
	dc.w -$1000,     0	; 6
; ===========================================================================

loc_25474:
	tst.b	render_flags(a1)
	bmi.s	loc_25492
	move.b	#0,obj_control(a1)
	bset	#1,status(a1)
	bclr	#3,status(a1)
	move.b	#0,(a4)
	rts
; ===========================================================================

loc_25492:
	cmpi.b	#2,RoundBall_BitField(a0)
	beq.s	Obj48_MoveCharacter
	cmpi.b	#2,Launcher_Bits(a0)
	beq.s	Obj48_MoveCharacter
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	Obj48_MoveCharacter
	move.w	#1,anim_frame_duration(a0)
	tst.b	objoff_3E(a0)
	beq.s	loc_254C2
	cmpi.b	#7,mapping_frame(a0)
	beq.s	Obj48_MoveCharacter
	addq.b	#1,mapping_frame(a0)
	bra.s	Obj48_MoveCharacter
; ===========================================================================

loc_254C2:
	tst.b	mapping_frame(a0)
	beq.s	Obj48_MoveCharacter
	subq.b	#1,mapping_frame(a0)

; update the position of Sonic/Tails between launchers
; loc_254CC:
Obj48_MoveCharacter:
	move.l	x_pos(a1),d2
	move.l	y_pos(a1),d3
	move.w	x_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a1),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,x_pos(a1)
	move.l	d3,y_pos(a1)
	rts
; ===========================================================================

loc_254F2:
	subq.w	#1,objoff_3C(a0)
	bpl.s	+	; rts
	move.b	#0,(a4)
+
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj48_MapUnc_254FE:	BINCLUDE "mappings/sprite/obj48.bin"
         even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo15_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo14_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo23_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif



