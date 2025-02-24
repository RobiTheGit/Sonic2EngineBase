; 3E is unused as well as 12 and 13
Grabber_Timer = $2C ;$44      ; word
Grabber_Timer_lowbyte =  Grabber_Timer+1
GrabberParent = $2E ;parent3      ; word
GrabberFlags_2 = $2B ;$46
GrabberMainChildRefrence = $30
Grabber_Flags = $33 ;$40    ; byte
Grabber_SonicGrabFlag = $34 ;$3D  ; byte
Unk_Controlerflag = $35
ButtonMashValue = $36 ; byte
Grabber_UnkFlag_3 = $37
GrabberStringRefrence = $38 ; word
Grabber_Saved_Restored_y_vel = $3A ; word
Grabber_UnkFlags = $3D ; byte ????

Grabber_Character_Store = $40   ; word
Grabber_ControlsStored = $42

Grabber_RespawnAddr_customCharacterAddr = $44 ; word
GrabbedCharacterAddr = $46 ;word


; ----------------------------------------------------------------------------
; Object A7 - Grabber (spider badnik) from CPZ
; ----------------------------------------------------------------------------
; Sprite_38DBA:
ObjA7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA7_Index(pc,d0.w),d1
	jmp	ObjA7_Index(pc,d1.w)
; ===========================================================================
; off_38DC8:
ObjA7_Index:	offsetTable
		offsetTableEntry.w ObjA7_Init	; 0
		offsetTableEntry.w ObjA7_Main	; 2
; ===========================================================================
; loc_38DCC:
ObjA7_Init:
	bsr.w	LoadSubObject
	move.w	#-$40,d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	move.w	d0,x_vel(a0)
	move.w	#$FF,Grabber_Timer(a0)
	move.b	#2,Grabber_SonicGrabFlag(a0)
	lea	(word_391E0).l,a2
	bsr.w	LoadChildObject
	lea	(word_391E4).l,a2
	bsr.w	LoadChildObject
	lea	(word_391E8).l,a2
	bra.w	LoadChildObject
; ===========================================================================
; loc_38E0C:
ObjA7_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_38E46(pc,d0.w),d1
	jsr	off_38E46(pc,d1.w)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	moveq	#0,d0
	moveq	#$10,d1
	movea.w	GrabberParent(a0),a1 ; a1=object
	bsr.w	Obj_AlignChildXY
	movea.w	parent(a0),a1 ; a1=object
	move.w	x_pos(a0),x_pos(a1)
	movea.w	GrabberStringRefrence(a0),a1 ; a1=object
	move.w	x_pos(a0),x_pos(a1)
	lea	GrabberStringRefrence(a0),a2 ; a2=object
	bra.w	GrabberMarkObjGone
; ===========================================================================
off_38E46:	offsetTable
		offsetTableEntry.w loc_38E52	;  0
		offsetTableEntry.w loc_38E9A	;  2
		offsetTableEntry.w loc_38EB4	;  4
		offsetTableEntry.w loc_38F3E	;  6
		offsetTableEntry.w loc_38F58	;  8
		offsetTableEntry.w BranchTo_ObjA7_CheckExplode	; $A
; ===========================================================================

loc_38E52:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$40,d2
	cmpi.w	#$80,d2
	bhs.s	loc_38E66
	cmpi.w	#-$80,d3
	bhi.s	loc_38E84

loc_38E66:
	subq.w	#1,Grabber_Timer(a0)
	bpl.s	return_38E82
	move.w	#$FF,Grabber_Timer(a0)
	neg.w	x_vel(a0)
	bchg	#0,render_flags(a0)
	bchg	#0,status(a0)

return_38E82:
	rts
; ===========================================================================

loc_38E84:
	addq.b	#2,routine_secondary(a0)
	move.w	x_vel(a0),Grabber_Saved_Restored_y_vel(a0)
	clr.w	x_vel(a0)
	move.b	#$10,GrabberMainChildRefrence(a0)
	rts
; ===========================================================================

loc_38E9A:
	subq.b	#1,GrabberMainChildRefrence(a0)
	bmi.s	loc_38EA2
	rts
; ===========================================================================

loc_38EA2:
	addq.b	#2,routine_secondary(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$40,GrabberMainChildRefrence(a0)
	rts
; ===========================================================================

loc_38EB4:
	tst.b	Grabber_Flags(a0)
	bne.s	ObjA7_GrabCharacter
	subq.b	#1,GrabberMainChildRefrence(a0)
	beq.s	loc_38ED6
	cmpi.b	#$20,GrabberMainChildRefrence(a0)
	bne.s	loc_38ECC
	neg.w	y_vel(a0)

loc_38ECC:
	lea	(Ani_objA7).l,a1
	jmpto	(AnimateSprite).l, JmpTo25_AnimateSprite
; ===========================================================================

loc_38ED6:
	move.b	#0,routine_secondary(a0)
	clr.w	y_vel(a0)
	move.w	Grabber_Saved_Restored_y_vel(a0),x_vel(a0)
	move.b	#0,mapping_frame(a0)
	rts
; ===========================================================================

;loc_38EEE:
ObjA7_GrabCharacter:
	addq.b	#2,routine_secondary(a0)
	movea.w	Grabber_Character_Store(a0),a1
	move.b	#$81,obj_control(a1)
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.b	#AniIDSonAni_Float,anim(a1)
	move.b	#1,mapping_frame(a0)
	tst.w	y_vel(a0)
	bmi.s	loc_38F2A
	neg.w	y_vel(a0)
	move.b	GrabberMainChildRefrence(a0),d0
	subi.b	#$40,d0
	neg.w	d0
	addq.b	#1,d0
	move.b	d0,GrabberMainChildRefrence(a0)

loc_38F2A:
	move.b	#1,Grabber_Timer(a0)
	move.b	#$10,Grabber_Timer_lowbyte(a0) ;set blinking timer
	move.b	#$20,ButtonMashValue(a0)
	rts
; ===========================================================================

loc_38F3E:
	bsr.w	ObjA7_CheckExplode
	bsr.w	loc_390BC
	subq.b	#1,GrabberMainChildRefrence(a0)
	beq.s	loc_38F4E
	rts
; ===========================================================================

loc_38F4E:
	addq.b	#2,routine_secondary(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_38F58:
	bsr.w	ObjA7_CheckExplode
	bra.w	loc_390BC

;----------------------------------------------------------------------
BranchTo_ObjA7_CheckExplode
	bra.w	ObjA7_CheckExplode
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A8 - Grabber's legs from CPZ
; ----------------------------------------------------------------------------
; Sprite_38F66:
ObjA8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA8_Index(pc,d0.w),d1
	jmp	ObjA8_Index(pc,d1.w)
; ===========================================================================
; off_38F74:
ObjA8_Index:	offsetTable
		offsetTableEntry.w ObjA8_Init	; 0
		offsetTableEntry.w loc_38F88	; 2
		offsetTableEntry.w loc_38FE8	; 4
		offsetTableEntry.w loc_39022	; 6
; ===========================================================================
; loc_38F7C:
ObjA8_Init:
	bsr.w	LoadSubObject
	move.b	#3,mapping_frame(a0)
	rts
; ===========================================================================

loc_38F88:
	movea.w	GrabberMainChildRefrence(a0),a1 ; a1=object
	cmpi.l	#ObjA7,(a1)
	bne.w	JmpTo65_DeleteObject
	bsr.w	InheritParentXYFlip
	movea.w	GrabberMainChildRefrence(a0),a1 ; a1=object
	move.b	mapping_frame(a1),d0
	addq.b	#3,d0
	move.b	d0,mapping_frame(a0)
	move.b	collision_property(a0),d0
	beq.s	BranchTo2_JmpTo45_DisplaySprite
	clr.b	collision_property(a0)
	cmpi.b	#4,routine_secondary(a1)
	bne.s	BranchTo2_JmpTo45_DisplaySprite
	andi.b	#3,d0
	beq.s	BranchTo2_JmpTo45_DisplaySprite
	clr.b	collision_flags(a0)
	addq.b	#2,routine(a0)
	add.w	d0,d0
	st	Grabber_Flags(a1)
	move.w	word_38FE0-6(pc,d0.w),Grabber_Character_Store(a1)
	move.w	word_38FE0(pc,d0.w),Grabber_ControlsStored(a1)

BranchTo2_JmpTo45_DisplaySprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
		dc.w MainCharacter	; -2
		dc.w Sidekick	; -1
word_38FE0:	dc.w MainCharacter	; 0
		dc.w Ctrl_1_Held	; 1
		dc.w Ctrl_2_Held	; 2
		dc.w Ctrl_1_Held	; 3
; ===========================================================================

loc_38FE8:
	movea.w	GrabberMainChildRefrence(a0),a1 ; a1=object
	move.w	Grabber_Character_Store(a1),d0
	beq.s	loc_3901A
	movea.w	d0,a2 ; a2=object
	cmpi.l	#ObjA7,(a1)
	bne.s	loc_3900A
	move.w	x_pos(a0),x_pos(a2)
	move.w	y_pos(a0),y_pos(a2)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_3900A:
	move.b	#0,obj_control(a2)
	bset	#1,status(a2)
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_3901A:
	addq.b	#2,routine(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_39022:
	movea.w	GrabberMainChildRefrence(a0),a1 ; a1=object
	cmpi.l	#ObjA7,(a1) ; compare to objA7
	bne.w	JmpTo65_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object A9 - The little hanger box thing a Grabber's string comes out of
; ----------------------------------------------------------------------------
; Sprite_39032:
ObjA9:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjA9_Index(pc,d0.w),d1
	jmp	ObjA9_Index(pc,d1.w)
; ===========================================================================
; off_39040:
ObjA9_Index:	offsetTable
		offsetTableEntry.w ObjA9_Init	; 0
		offsetTableEntry.w ObjA9_Main	; 2
; ===========================================================================
; loc_39044:
ObjA9_Init:
	bsr.w	LoadSubObject
	move.b	#2,mapping_frame(a0)
	subi.w	#$C,y_pos(a0)
	rts
; ===========================================================================
; loc_39056:
ObjA9_Main:
	movea.w	GrabberMainChildRefrence(a0),a1 ; a1=object
	cmpi.l	#ObjA7,(a1) ; compare to objA7 (grabber badnik)
	bne.w	JmpTo65_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object AA - The thin white string a Grabber hangs from
; ----------------------------------------------------------------------------
; Sprite_39066:
ObjAA:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAA_Index(pc,d0.w),d1
	jmp	ObjAA_Index(pc,d1.w)
; ===========================================================================
; off_39074:
ObjAA_Index:	offsetTable
		offsetTableEntry.w ObjAA_Init	; 0
		offsetTableEntry.w ObjAA_Main	; 2
; ===========================================================================
; loc_39078:
ObjAA_Init:
	bsr.w	LoadSubObject
	subq.w	#8,y_pos(a0)
	rts
; ===========================================================================
; loc_39082:
ObjAA_Main:
	movea.w	GrabberMainChildRefrence(a0),a1 ; a1=object
	cmpi.l	#ObjA7,(a1) ; compare to objA7 (grabber badnik)
	bne.w	JmpTo65_DeleteObject
	move.w	y_pos(a1),d0
	sub.w	y_pos(a0),d0
	bmi.s	+
	lsr.w	#4,d0
	move.b	d0,mapping_frame(a0)
+
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite

; ===========================================================================

; ===========================================================================
; ----------------------------------------------------------------------------
; Object AB - Removed object (unknown, unused)
; ----------------------------------------------------------------------------
; Sprite_390A2:
ObjAB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAB_Index(pc,d0.w),d1
	jmp	ObjAB_Index(pc,d1.w)
; ===========================================================================
; off_390B0:
ObjAB_Index:	offsetTable
		offsetTableEntry.w ObjAB_Init
		offsetTableEntry.w ObjAB_Main
; ===========================================================================
; BranchTo4_LoadSubObject
ObjAB_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo10_JmpTo39_MarkObjGone
ObjAB_Main:
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; END OF OBJECT AB


; ---------------------------------------------------------------------------
; Some subroutine for the Grabber badnik
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

loc_390BC:
	movea.w	GrabbedCharacterAddr(a0),a1 ; a1=object
	move.w	(a1),d0
	tst.b	Unk_Controlerflag(a0)
	beq.s	loc_390E6
	subq.b	#1,ButtonMashValue(a0)
	beq.s	loc_390FA
	move.b	Grabber_UnkFlag_3(a0),d1
	andi.b	#$C,d0
	beq.s	return_390E4
	cmp.b	d1,d0
	beq.s	return_390E4
	move.b	d0,Grabber_UnkFlag_3(a0)
	addq.b	#1,GrabberFlags_2(a0)

return_390E4:
	rts
; ---------------------------------------------------------------------------
loc_390E6:
	andi.b	#$C,d0
	beq.s	return_390E4
	nop
	st	Unk_Controlerflag(a0)
	move.b	d0,Grabber_UnkFlag_3(a0)
	nop
	rts
; ---------------------------------------------------------------------------
loc_390FA:
	cmpi.b	#4,GrabberFlags_2(a0)
	blo.s	+
	move.b	#$A,routine_secondary(a0)
	clr.w	y_vel(a0)
	clr.b	collision_flags(a0)
	movea.w	Grabber_RespawnAddr_customCharacterAddr(a0),a2 ; a2=object
	move.b	#0,obj_control(a2)
	bset	#1,status(a2)
	move.b	#AniIDSonAni_Walk,anim(a2)
	clr.w	Grabber_RespawnAddr_customCharacterAddr(a0)
+
	move.b	#$20,ButtonMashValue(a0)
	clr.b	Unk_Controlerflag(a0)
	clr.b	GrabberFlags_2(a0)
	rts
; End of subroutine loc_390BC

; ---------------------------------------------------------------------------
; Grabber death check subroutine
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_3913A:
ObjA7_CheckExplode:
	subq.b	#1,Grabber_Timer(a0)
	bne.s	+
	move.b	Grabber_Timer_lowbyte(a0),Grabber_Timer(a0)
	subq.b	#1,Grabber_Timer_lowbyte(a0)
	beq.s	ObjA7_Poof
	bchg	#palette_bit_0,art_tile(a0)
+
	rts
; ---------------------------------------------------------------------------
; loc_39154:
ObjA7_Poof:
	move.l	#Obj27,(a0) ; load 0bj27 (transform into explosion)
	move.b	#2,routine(a0)
	bset	#palette_bit_0,art_tile(a0)
	move.w	Grabber_RespawnAddr_customCharacterAddr(a0),d0
	beq.s	+
	movea.w	d0,a2 ; a2=object
	move.b	#0,Grabber_Timer(a2)
	bset	#1,status(a2)
	move.b	#$B,collision_flags(a0)
+
	rts
; End of subroutine ObjA7_CheckExplode
; ===========================================================================

; ---------------------------------------------------------------------------
; Yet another subroutine for the Grabber badnik
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

GrabberMarkObjGone:
	tst.w	(Two_player_mode).w
	beq.s	.not2Pmode
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
 .not2Pmode:
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	.NotWithingScreen
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ---------------------------------------------------------------------------
 .NotWithingScreen:
	lea	(Object_Respawn_Table).w,a3
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	.RememberStateFlagIsOff
	bclr	#7,2(a3,d0.w)
 .RememberStateFlagIsOff:
	tst.b	Grabber_UnkFlags(a0)
	beq.s	+
	movea.w	Grabber_RespawnAddr_customCharacterAddr(a0),a3
	move.b	#0,Grabber_Timer(a3)
	bset	#1,status(a3)
+
	moveq	#0,d6
	move.b	Grabber_SonicGrabFlag(a0),d6

-	movea.w	(a2)+,a1
	jsrto	(DeleteObject2).l, JmpTo6_DeleteObject2
	dbf	d6,-

	bra.w	JmpTo65_DeleteObject
; End of subroutine loc_39182

; ===========================================================================

word_391E0:
	dc.w parent
	dc.l ObjA9
	dc.b $3A
	even
word_391E4:
	dc.w GrabberParent
	dc.l ObjA8
	dc.b $38
	even
word_391E8:
	dc.w GrabberStringRefrence
	dc.l ObjAA
	dc.b $3C
	even
; off_391EC:
ObjA7_SubObjData:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,4,$10,$B
; off_391F6:
ObjA7_SubObjData2:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,1,$10,$D7
; off_39200:
ObjA8_SubObjData:
	subObjData ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,4,4,0
; off_3920A:
ObjA8_SubObjData2:
	subObjData ObjAA_MapUnc_39228,make_art_tile(ArtTile_ArtNem_Grabber,1,1),4,5,4,0
; animation script
; off_39214:
Ani_objA7:	offsetTable
		offsetTableEntry.w byte_39216	; 0
byte_39216:
	dc.b   7,  0,  1,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings - objA7,objA8,objA9
; ----------------------------------------------------------------------------
ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A: offsetTable
	offsetTableEntry.w word_3923A	; 0
	offsetTableEntry.w word_39254	; 1
	offsetTableEntry.w word_3926E	; 2
	offsetTableEntry.w word_39278	; 3
	offsetTableEntry.w word_39282	; 4
	offsetTableEntry.w word_3928C	; 5
	offsetTableEntry.w word_39296	; 6
; -------------------------------------------------------------------------------
; sprite mappings - objAA (string of various lengths)
; -------------------------------------------------------------------------------
ObjAA_MapUnc_39228: offsetTable
	offsetTableEntry.w word_392A0	; 0
	offsetTableEntry.w word_392AA	; 1
	offsetTableEntry.w word_392B4	; 2
	offsetTableEntry.w word_392C6	; 3
	offsetTableEntry.w word_392D8	; 4
	; Unused - The spider badnik never goes down enough for these to appear
	offsetTableEntry.w word_3930C	; 5	; This is in the wrong place - this should be frame 6
	offsetTableEntry.w word_392F2	; 6	; This is in the wrong place - this should be frame 5
	offsetTableEntry.w word_3932E	; 7
	offsetTableEntry.w word_3932E	; 8	; This should point to word_39350
word_3923A:
	dc.w 3
	dc.w $F801,    0,    0,$FFE5
	dc.w $F80D,    2,    1,$FFED; 4
	dc.w  $809,  $1D,   $E,$FFF1; 8
word_39254:
	dc.w 3
	dc.w $F801,    0,    0,$FFE5
	dc.w $F80D,    2,    1,$FFED; 4
	dc.w  $80D,  $23,  $11,$FFF1; 8
word_3926E:
	dc.w 1
	dc.w $FC00,   $A,    5,$FFFC
word_39278:
	dc.w 1
	dc.w $F809,   $F,    7,$FFF9
word_39282:
	dc.w 1
	dc.w $F80D,  $15,   $A,$FFF9
word_3928C:
	dc.w 1
	dc.w $FC00,  $2B,  $15,$FFFC
word_39296:
	dc.w 1
	dc.w $FC00,  $2C,  $16,$FFFC
word_392A0:
	dc.w 1
	dc.w	 1,   $B,    5,$FFFC
word_392AA:
	dc.w 1
	dc.w	 3,   $B,    5,$FFFC
word_392B4:
	dc.w 2
	dc.w	 1,   $B,    5,$FFFC
	dc.w $1003,   $B,    5,$FFFC; 4
word_392C6:
	dc.w 2
	dc.w	 3,   $B,    5,$FFFC
	dc.w $2003,   $B,    5,$FFFC; 4
word_392D8:
	dc.w 3
	dc.w	 1,   $B,    5,$FFFC
	dc.w $1003,   $B,    5,$FFFC; 4
	dc.w $3003,   $B,    5,$FFFC; 8
word_392F2:
	dc.w 3
	dc.w	 3,   $B,    5,$FFFC
	dc.w $2003,   $B,    5,$FFFC; 4
	dc.w $4003,   $B,    5,$FFFC; 8
word_3930C:
	dc.w 4
	dc.w	 1,   $B,    5,$FFFC
	dc.w $1003,   $B,    5,$FFFC; 4
	dc.w $3003,   $B,    5,$FFFC; 8
	dc.w $5003,   $B,    5,$FFFC; 12
word_3932E:
	dc.w 4
	dc.w	 3,   $B,    5,$FFFC
	dc.w $2003,   $B,    5,$FFFC; 4
	dc.w $4003,   $B,    5,$FFFC; 8
	dc.w $6003,   $B,    5,$FFFC; 12
; Unused frame
;word_39350:
	dc.w 5
	dc.w	 1,   $B,    5,$FFFC
	dc.w $1003,   $B,    5,$FFFC; 4
	dc.w $3003,   $B,    5,$FFFC; 8
	dc.w $5003,   $B,    5,$FFFC; 12
	dc.w $7003,   $B,    5,$FFFC; 16
