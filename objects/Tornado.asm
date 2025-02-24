



; ===========================================================================
; ----------------------------------------------------------------------------
; Object B2 - The Tornado (Tails' plane)
; ----------------------------------------------------------------------------
; Sprite_3A790:
ObjB2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB2_Index(pc,d0.w),d1
	jmp	ObjB2_Index(pc,d1.w)
; ===========================================================================
; off_3A79E:
ObjB2_Index:	offsetTable
		offsetTableEntry.w ObjB2_Init	;  0
		offsetTableEntry.w ObjB2_Main_SCZ	;  2
		offsetTableEntry.w ObjB2_Main_WFZ_Start	;  4
		offsetTableEntry.w ObjB2_Main_WFZ_End	;  6
		offsetTableEntry.w ObjB2_Invisible_grabber	;  8
		offsetTableEntry.w loc_3AD0C	; $A
		offsetTableEntry.w loc_3AD2A	; $C  ; seems unused
		offsetTableEntry.w loc_3AD42	; $E
; ===========================================================================
; loc_3A7AE:
ObjB2_Init:
	bsr.w	LoadSubObject
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$4E,d0
	move.b	d0,routine(a0)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	cmpi.b	#8,d0
	bhs.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#1,anim(a0)
+ ; BranchTo5_JmpTo45_DisplaySprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3A7DE:
ObjB2_Main_SCZ:
	bsr.w	ObjB2_Animate_Pilot
	tst.w	(Debug_placement_mode).w
	bne.w	ObjB2_animate
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	art_tile(a1),d0
	andi.w	#high_priority,d0
	move.w	art_tile(a0),d1
	andi.w	#drawing_mask,d1
	or.w	d0,d1
	move.w	d1,art_tile(a0)
	move.w	x_pos(a0),-(sp)
	bsr.w	ObjB2_Move_with_player
	move.b	status(a0),objoff_32(a0)
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo27_SolidObject
	bsr.w	ObjB2_Move_obbey_player
	move.b	objoff_32(a0),d0
	move.b	status(a0),d1
	andi.b	#p1_standing,d0	; 'on object' bit
	andi.b	#p1_standing,d1	; 'on object' bit
	eor.b	d0,d1
	move.b	d1,objoff_32(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a1),d1
	move.w	(Camera_X_pos).w,d0
	move.w	d0,(Camera_Min_X_pos).w
	move.w	d0,d2
	addi.w	#$11,d2
	cmp.w	d2,d1
	bhi.s	+
	addq.w	#1,d1
	move.w	d1,x_pos(a1)
+ ; loc_3A85E:
	cmpi.w	#$1400,d0
	blo.s	loc_3A878
	cmpi.w	#$1568,d1
	bhs.s	ObjB2_SCZ_Finished
	st	(Control_Locked).w
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	bra.w	loc_3A87C
; ===========================================================================

loc_3A878:
	subi.w	#$40,d0

loc_3A87C:
	move.w	d0,(Camera_Max_X_pos).w
; loc_3A880:
ObjB2_animate:
	lea	(Ani_objB2_a).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3A88E:
ObjB2_SCZ_Finished:
	bsr.w	ObjB2_Deactivate_level
	move.w	#wing_fortress_zone_act_1,(Current_ZoneAndAct).w
	bra.s	ObjB2_animate
; ===========================================================================
; loc_3A89A:
ObjB2_Main_WFZ_Start:
	bsr.w	ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3A8BA(pc,d0.w),d1
	jsr	off_3A8BA(pc,d1.w)
	lea	(Ani_objB2_a).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(Obj_DeleteOffScreen).l, Obj_DeleteOffScreen
; ===========================================================================
off_3A8BA:	offsetTable
		offsetTableEntry.w ObjB2_Main_WFZ_Start_init	; 0
		offsetTableEntry.w ObjB2_Main_WFZ_Start_main	; 2
		offsetTableEntry.w ObjB2_Main_WFZ_Start_shot_down	; 4
		offsetTableEntry.w ObjB2_Main_WFZ_Start_fall_down	; 6
; ===========================================================================
; loc_3A8C2:
ObjB2_Main_WFZ_Start_init:
	addq.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_36(a0)
	move.w	#$100,x_vel(a0)
	rts
; ===========================================================================
; loc_3A8D4:
ObjB2_Main_WFZ_Start_main:
	subq.w	#1,objoff_36(a0)
	bmi.s	+
	move.w	x_pos(a0),-(sp)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	bsr.w	loc_36776
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo27_SolidObject
	bra.w	ObjB2_Horizontal_limit
; ===========================================================================
+ ; loc_3A8FC:
	addq.b	#2,routine_secondary(a0)
	move.w	#$60,objoff_2E(a0)
	move.w	#1,objoff_36(a0)
	move.w	#$100,x_vel(a0)
	move.w	#$100,y_vel(a0)
	rts
; ===========================================================================
; loc_3A91A:
ObjB2_Main_WFZ_Start_shot_down:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#SndID_Scatter,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound
+ ; loc_3A92A:
	subq.w	#1,objoff_2E(a0)
	bmi.s	+
- ; loc_3A930:
	bsr.w	ObjB2_Align_plane
	subq.w	#1,objoff_36(a0)
	bne.w	return_37A48
	move.w	#$E,objoff_36(a0)
	bra.w	ObjB2_Main_WFZ_Start_load_smoke
; ===========================================================================
+ ; loc_3A946:
	addq.b	#2,routine_secondary(a0)
	bra.w	loc_3B7BC
; ===========================================================================
; loc_3A94E:
ObjB2_Main_WFZ_Start_fall_down:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	bra.s	-
; ===========================================================================
; loc_3A954:
ObjB2_Main_WFZ_End:
	bsr.w	ObjB2_Animate_Pilot
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	ObjB2_Main_WFZ_states(pc,d0.w),d1
	jsr	ObjB2_Main_WFZ_states(pc,d1.w)
	lea	(Ani_objB2_a).l,a1
	jmpto	(AnimateSprite).l, JmpTo25_AnimateSprite
; ===========================================================================
; off_3A970:
ObjB2_Main_WFZ_states:	offsetTable
		offsetTableEntry.w ObjB2_Wait_Leader_position	;   0
		offsetTableEntry.w ObjB2_Move_Leader_edge	;   2
		offsetTableEntry.w ObjB2_Wait_for_plane	;   4
		offsetTableEntry.w ObjB2_Prepare_to_jump	;   6
		offsetTableEntry.w ObjB2_Jump_to_plane	;   8
		offsetTableEntry.w ObjB2_Landed_on_plane	;  $A
		offsetTableEntry.w ObjB2_Approaching_ship	;  $C
		offsetTableEntry.w ObjB2_Jump_to_ship	;  $E
		offsetTableEntry.w ObjB2_Dock_on_DEZ	; $10
; ===========================================================================
; loc_3A982:
ObjB2_Wait_Leader_position:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$5EC,y_pos(a1)
	blo.s	+	; rts
	clr.w	(Ctrl_1_Logical).w
	addq.w	#1,objoff_32(a0)
	cmpi.w	#$40,objoff_32(a0)
	bhs.s	++
+ ; return_3A99E:
	rts
; ===========================================================================
+ ; loc_3A9A0:
	addq.b	#2,routine_secondary(a0)
	move.w	#$2E58,x_pos(a0)
	move.w	#$66C,y_pos(a0)
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	ObjB2_Waiting_animation
	lea	(word_3AFBC).l,a2
	bsr.w	LoadChildObject
	move.w	#$3118,x_pos(a1)
	move.w	#$3F0,y_pos(a1)
	lea	(word_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3070,x_pos(a1)
	move.w	#$3B0,y_pos(a1)
	lea	(word_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3070,x_pos(a1)
	move.w	#$430,y_pos(a1)
	lea	(word_3AFC0).l,a2
	bsr.w	LoadChildObject
	clr.w	x_pos(a1)
	clr.w	y_pos(a1)

;	lea	(UnusedPlaneObj).l,a2 ; does nothing
;	bsr.w	LoadChildObject
;	clr.w	x_pos(a1)
;	clr.w	y_pos(a1)
	rts
; ===========================================================================
; loc_3AA0E: ObjB2_Move_Leader_egde:
ObjB2_Move_Leader_edge:
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.w	#$2E30,x_pos(a1)
	bhs.s	+
	move.w	#(button_right_mask<<8)|button_right_mask,(Ctrl_1_Logical).w
	rts
; ===========================================================================
+ ; loc_3AA22:
	addq.b	#2,routine_secondary(a0)
	clr.w	(Ctrl_1_Logical).w
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	move.w	#$600,(Sonic_top_speed).w
	move.w	#$C,(Sonic_acceleration).w
	move.w	#$80,(Sonic_deceleration).w
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
; loc_3AA4C:
ObjB2_Wait_for_plane:
	cmpi.w	#$380,(Camera_BG_X_offset).w
	bhs.s	+
	clr.w	(Ctrl_1_Logical).w
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
+ ; loc_3AA5C:
	addq.b	#2,routine_secondary(a0)
	move.w	#$100,x_vel(a0)
	move.w	#-$100,y_vel(a0)
	clr.w	objoff_2E(a0)
	bra.w	ObjB2_Waiting_animation
; ===========================================================================
; loc_3AA74:
ObjB2_Prepare_to_jump:
	bsr.w	ObjB2_Waiting_animation
	addq.w	#1,objoff_2E(a0)
	cmpi.w	#$30,objoff_2E(a0)
	bne.s	+
	addq.b	#2,routine_secondary(a0)
	move.w	#(button_A_mask<<8)|button_A_mask,(Ctrl_1_Logical).w
	move.w	#$38,objoff_32(a0)
	tst.b	(Super_Sonic_flag).w
	beq.s	+
	move.w	#$28,objoff_32(a0)
+ ; loc_3AAA0:
	bsr.w	ObjB2_Align_plane
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AAA8:
ObjB2_Jump_to_plane:
	clr.w	(Ctrl_1_Logical).w
	addq.w	#1,objoff_2E(a0)
	subq.w	#1,objoff_32(a0)
	bmi.s	+
	move.w	#((button_right_mask|button_A_mask)<<8)|button_right_mask|button_A_mask,(Ctrl_1_Logical).w
+ ; loc_3AABC:
	bsr.w	ObjB2_Align_plane
	btst	#p1_standing_bit,status(a0)
	beq.s	+
	addq.b	#2,routine_secondary(a0)
	move.w	#$20,objoff_32(a0)
	lea	(Level_Layout+$0D2).w,a1
	move.l	#$501F0025,(a1)+
	lea	(Level_Layout+$1D2).w,a1
	move.l	#$25001F50,(a1)+
	lea	(Level_Layout+$BD6).w,a1
	move.l	#$501F0025,(a1)+
	lea	(Level_Layout+$CD6).w,a1
	move.l	#$25001F50,(a1)+
+ ; BranchTo6_JmpTo45_DisplaySprite:
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AAFE:
ObjB2_Landed_on_plane:
	addq.w	#1,objoff_2E(a0)
	cmpi.w	#$100,objoff_2E(a0)
	blo.s	loc_3AB18
	addq.b	#2,routine_secondary(a0)
	movea.w	objoff_3E(a0),a1 ; a1=object ??
	move.l  #loc_3AD5C,(a1)
	;move.b	#2,routine_secondary(a1)

loc_3AB18:
	clr.w	(Ctrl_1_Logical).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),x_pos(a1)
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	clr.w	inertia(a1)
	bclr	#1,status(a1)
	bclr	#2,status(a1)
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|AniIDSonAni_Wait,mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	move.b	#$13,y_radius(a1)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	#$F,y_radius(a1)
+ ; loc_3AB60:
	bsr.w	ObjB2_Align_plane
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; loc_3AB68:
ObjB2_Approaching_ship:
	clr.w	(Ctrl_1_Logical).w
	bsr.w	ObjB2_Waiting_animation
	cmpi.w	#$437,objoff_2E(a0)
	blo.s	loc_3AB8A
	addq.b	#2,routine_secondary(a0)
; loc_3AB7C:
ObjB2_Jump_to_ship:
	cmpi.w	#$447,objoff_2E(a0)
	bhs.s	loc_3AB8A
	move.w	#(button_A_mask<<8)|button_A_mask,(Ctrl_1_Logical).w

loc_3AB8A:
	cmpi.w	#$460,objoff_2E(a0)
	blo.s	ObjB2_Dock_on_DEZ
	move.b	#6,(Dynamic_Resize_Routine).w ; => LevEvents_WFZ_Routine4
	addq.b	#2,routine_secondary(a0)
	lea	(word_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3090,x_pos(a1)
	move.w	#$3D0,y_pos(a1)
	lea	(word_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$30C0,x_pos(a1)
	move.w	#$3F0,y_pos(a1)
	lea	(word_3AFB8).l,a2
	bsr.w	LoadChildObject
	move.w	#$3090,x_pos(a1)
	move.w	#$410,y_pos(a1)
; loc_3ABDE:
ObjB2_Dock_on_DEZ:
	cmpi.w	#$9C0,objoff_2E(a0)
	bhs.s	ObjB2_Start_DEZ
	move.w	objoff_2E(a0),d0
	addq.w	#1,d0
	move.w	d0,objoff_2E(a0)
	move.w	objoff_38(a0),d1
	move.w	word_3AC16(pc,d1.w),d2
	cmp.w	d2,d0
	blo.s	loc_3AC0E
	addq.w	#2,d1
	move.w	d1,objoff_38(a0)
	lea	byte_3AC2A(pc,d1.w),a1
	move.b	(a1)+,x_vel(a0)
	move.b	(a1)+,y_vel(a0)

loc_3AC0E:
	bsr.w	ObjB2_Align_plane
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
word_3AC16:
	dc.w  $1E0
	dc.w  $260	; 1
	dc.w  $2A0	; 2
	dc.w  $2C0	; 3
	dc.w  $300	; 4
	dc.w  $3A0	; 5
	dc.w  $3F0	; 6
	dc.w  $460	; 7
	dc.w  $4A0	; 8
	dc.w  $580	; 9
byte_3AC2A:
	dc.b $FF
	dc.b $FF	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	dc.b   0	; 4
	dc.b   1	; 5
	dc.b   1	; 6
	dc.b $FF	; 7
	dc.b   1	; 8
	dc.b   1	; 9
	dc.b   1	; 10
	dc.b $FF	; 11
	dc.b $FF	; 12
	dc.b   1	; 13
	dc.b $FF	; 14
	dc.b $FF	; 15
	dc.b $FF	; 16
	dc.b   1	; 17
	dc.b $FE	; 18
	dc.b   0	; 19
	dc.b   0	; 20
	dc.b   0	; 21
; ===========================================================================
; loc_3AC40:
ObjB2_Start_DEZ:
	move.w	#death_egg_zone_act_1,(Current_ZoneAndAct).w
; loc_3AC46:
ObjB2_Deactivate_level:
	move.w	#1,(Level_Inactive_flag).w
	clr.b	(Last_star_pole_hit).w
	clr.b	(Last_star_pole_hit_2P).w
	rts
; ===========================================================================
; loc_3AC56:
ObjB2_Waiting_animation:
	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#(1<<24)|(0<<16)|(AniIDSonAni_Wait<<8)|AniIDSonAni_Wait,mapping_frame(a1)
	move.w	#$100,anim_frame_duration(a1)
	rts
; ===========================================================================
; loc_3AC6A:
ObjB2_Invisible_grabber:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AC78(pc,d0.w),d1
	jmp	off_3AC78(pc,d1.w)
; ===========================================================================
off_3AC78:	offsetTable
		offsetTableEntry.w loc_3AC7E	; 0
		offsetTableEntry.w loc_3AC84	; 2
		offsetTableEntry.w loc_3ACF2	; 4
; ===========================================================================

loc_3AC7E:
	move.b	#$C7,collision_flags(a0)

loc_3AC84:
	tst.b	collision_property(a0)
	beq.s	return_3ACF0
	addq.b	#2,routine_secondary(a0)
	clr.b	collision_flags(a0)
	move.w	#(224/2)+8,(Camera_Y_pos_bias).w
	movea.w	objoff_30(a0),a1 ; a1=object
	bset	#6,status(a1)
	lea	(MainCharacter).w,a1 ; a1=character
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,x_pos(a1)
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_3ACC8
	subi.w	#$10,y_pos(a1)

loc_3ACC8:
	bset	#0,status(a1)
	bclr	#1,status(a1)
	bclr	#2,status(a1)
	move.b	#AniIDSonAni_Hang,anim(a1)
	move.b	#1,(MainCharacter+obj_control).w
	move.b	#1,(WindTunnel_holding_flag).w
	clr.w	(Ctrl_1_Logical).w

return_3ACF0:
	rts
; ===========================================================================

loc_3ACF2:
	lea	(MainCharacter).w,a1 ; a1=character
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$10,d0
	move.w	d0,x_pos(a1)
	rts
; ===========================================================================

loc_3AD0C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD1A(pc,d0.w),d1
	jmp	off_3AD1A(pc,d1.w)
; ===========================================================================
off_3AD1A:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+ ; loc_3AD1C:
	bchg	#2,status(a0)
	bne.w	return_37A48
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD2A:    ; unused object all it does is spawn and display
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3AD38(pc,d0.w),d1
	jmp	off_3AD38(pc,d1.w)
; ===========================================================================
off_3AD38:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+ ; loc_3AD3A:
       ; bsr.w	PlaneAttributeFollowPlane ; added line to see what happens
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3AD42:

	bsr.w	PlaneAttributeFollowPlane
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_3AD5C:
	bsr.w	PlaneAttributeFollowPlane
	lea	(Ani_objB2_b).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

PlaneAttributeFollowPlane:
	movea.w	objoff_30(a0),a1 ; a1=object
	move.w	x_pos(a1),d0
	subi.w	#$C,d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),d0
	addi.w	#$28,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
; loc_3AD8C:
ObjB2_Align_plane:
	move.w	x_pos(a0),-(sp)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	bsr.w	loc_36776
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jmpto	(SolidObject).l, JmpTo27_SolidObject
; ===========================================================================
; loc_3ADAA:
ObjB2_Move_with_player:
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#3,status(a1)
	beq.s	ObjB2_Move_below_player
	bsr.w	ObjB2_Move_vert
	bsr.w	ObjB2_Vertical_limit
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	bra.w	loc_36776
; ===========================================================================
; loc_3ADC6:
ObjB2_Move_below_player:
	tst.b	objoff_32(a0)
	beq.s	loc_3ADD4
	bsr.w	Obj_GetOrientationToPlayer
	move.w	d2,objoff_3C(a0)

loc_3ADD4:
	move.w	#1,d0
	move.w	objoff_3C(a0),d3
	beq.s	loc_3ADE8
	bmi.s	loc_3ADE2
	neg.w	d0

loc_3ADE2:
	add.w	d0,d3
	move.w	d3,objoff_3C(a0)

loc_3ADE8:
	move.w	x_pos(a1),d1
	add.w	d3,d1
	move.w	d1,x_pos(a0)
	bra.w	loc_36776
; ===========================================================================
; loc_3ADF6:
ObjB2_Move_vert:
	tst.b	objoff_33(a0)
	bne.s	loc_3AE16
	tst.b	objoff_32(a0)
	beq.s	return_3AE38
	st	objoff_33(a0)
	clr.b	objoff_34(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$14,objoff_35(a0)

loc_3AE16:
	subq.b	#1,objoff_35(a0)
	bpl.s	loc_3AE26
	clr.b	objoff_33(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_3AE26:
	move.w	y_vel(a0),d0
	cmpi.w	#-$100,d0
	ble.s	loc_3AE34
	addi.w	#-$20,d0

loc_3AE34:
	move.w	d0,y_vel(a0)

return_3AE38:
	rts
; ===========================================================================
; loc_3AE3A:
ObjB2_Move_obbey_player:
	lea	(MainCharacter).w,a1 ; a1=character
	btst	#3,status(a1)
	beq.s	ObjB2_Move_vert2
	tst.b	objoff_33(a0)
	bne.s	loc_3AE72
	clr.w	y_vel(a0)
	move.w	(Ctrl_1).w,d2
	move.w	#$80,d3
	andi.w	#(button_up_mask|button_down_mask)<<8,d2
	beq.s	loc_3AE72
	andi.w	#button_down_mask<<8,d2
	bne.s	loc_3AE66
	neg.w	d3

loc_3AE66:
	move.w	d3,y_vel(a0)
	bsr.w	ObjB2_Vertical_limit
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove

loc_3AE72:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#$10,d3
	add.w	d3,d2
	cmpi.w	#$20,d2
	blo.s	return_3AE9E
	mvabs.w	inertia(a1),d2
	cmpi.w	#$900,d2
	bhs.s	return_3AE9E
	tst.w	d0
	beq.s	loc_3AE94
	neg.w	d3

loc_3AE94:
	move.w	x_pos(a1),d1
	add.w	d3,d1
	move.w	d1,x_pos(a0)

return_3AE9E:
	rts
; ===========================================================================
; loc_3AEA0:
ObjB2_Move_vert2:
	tst.b	objoff_34(a0)
	bne.s	loc_3AEC0
	tst.b	objoff_32(a0)
	beq.s	return_3AE9E
	st	objoff_34(a0)
	clr.b	objoff_33(a0)
	move.w	#$200,y_vel(a0)
	move.b	#$2B,objoff_35(a0)

loc_3AEC0:
	subq.b	#1,objoff_35(a0)
	bpl.s	loc_3AED0
	clr.b	objoff_34(a0)
	clr.w	y_vel(a0)
	rts
; ===========================================================================

loc_3AED0:
	move.w	y_vel(a0),d0
	cmpi.w	#-$100,d0
	ble.s	loc_3AEDE
	addi.w	#-$20,d0

loc_3AEDE:
	move.w	d0,y_vel(a0)
	bsr.w	ObjB2_Vertical_limit
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	rts
; ===========================================================================
; loc_3AEEC:
ObjB2_Horizontal_limit:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#$10,d3
	add.w	d3,d2
	cmpi.w	#$20,d2
	blo.s	return_3AF0A
	tst.w	d0
	beq.s	loc_3AF00
	neg.w	d3

loc_3AF00:
	move.w	x_pos(a0),d1
	sub.w	d3,d1
	move.w	d1,x_pos(a1)

return_3AF0A:
	rts
; ===========================================================================
; loc_3AF0C:
ObjB2_Vertical_limit:
	move.w	(Camera_Y_pos).w,d0
	move.w	y_pos(a0),d1
	move.w	y_vel(a0),d2
	beq.s	return_3AF32
	bpl.s	loc_3AF26
	addi.w	#$34,d0
	cmp.w	d0,d1
	blo.s	loc_3AF2E
	rts
; ===========================================================================

loc_3AF26:
	addi.w	#$A8,d0
	cmp.w	d0,d1
	blo.s	return_3AF32

loc_3AF2E:
	clr.w	y_vel(a0)

return_3AF32:
	rts
; ===========================================================================
; loc_3AF34:
ObjB2_Main_WFZ_Start_load_smoke:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	+
	move.l	#ObjC3,(a1) ; load objC3
	move.b	#$90,subtype(a1) ; <== ObjC3_SubObjData
	move.w	a0,objoff_30(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+ ; return_3AF56:
	rts
; ===========================================================================
; loc_3AF58:
ObjB2_Animate_Pilot:
	subq.b	#1,objoff_3B(a0)
	bmi.s	+
	rts
; ===========================================================================
+ ; loc_3AF60:
	move.b	#8,objoff_3B(a0)
	moveq	#0,d0
	move.b	objoff_3A(a0),d0
	moveq	#Tails_pilot_frames_end-Tails_pilot_frames,d1
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	moveq	#Sonic_pilot_frames_end-Sonic_pilot_frames,d1
+ ; loc_3AF78:
	addq.b	#1,d0
	cmp.w	d1,d0
	blo.s	+
	moveq	#0,d0
+ ; loc_3AF80:
	move.b	d0,objoff_3A(a0)
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	move.b	Sonic_pilot_frames(pc,d0.w),d0
	jmpto	(LoadSonicDynPLC_Part2).l, JmpTo_LoadSonicDynPLC_Part2
; ===========================================================================
+ ; loc_3AF94:
	move.b	Tails_pilot_frames(pc,d0.w),d0
	jmpto	(LoadTailsDynPLC_Part2).l, JmpTo_LoadTailsDynPLC_Part2
; ===========================================================================
; byte_3AF9C:
Sonic_pilot_frames:
	dc.b $2D
	dc.b $2E	; 1
	dc.b $2F	; 2
	dc.b $30	; 3
Sonic_pilot_frames_end:
        even
; byte_3AFA0:
Tails_pilot_frames:
	dc.b $10
	dc.b $10	; 1
	dc.b $10	; 2
	dc.b $10	; 3
	dc.b   1	; 4
	dc.b   2	; 5
	dc.b   3	; 6
	dc.b   2	; 7
	dc.b   1	; 8
	dc.b   1	; 9
	dc.b $10	; 10
	dc.b $10	; 11
	dc.b $10	; 12
	dc.b $10	; 13
	dc.b   1	; 14
	dc.b   2	; 15
	dc.b   3	; 16
	dc.b   2	; 17
	dc.b   1	; 18
	dc.b   1	; 19
	dc.b   4	; 20
	dc.b   4	; 21
	dc.b   1	; 22
	dc.b   1	; 23
Tails_pilot_frames_end:
        even
word_3AFB8:
	dc.w objoff_42
	dc.l ObjB2
	dc.b $58
word_3AFBC:
	dc.w objoff_40   ; rocket on plane
	dc.l ObjB2
	dc.b $56
word_3AFC0:
	dc.w objoff_3E
	dc.l ObjB2
	dc.b $5C
; seems unused
UnusedPlaneObj:
	dc.w parent3
	dc.l ObjB2
	dc.b $5A
; off_3AFC8:
ObjB2_SubObjData:
	subObjData ObjB2_MapUnc_3AFF2,make_art_tile(ArtTile_ArtNem_Tornado,0,1),4,4,$60,0
; off_3AFD2:
ObjB2_SubObjData2:
	subObjData ObjB2_MapUnc_3B292,make_art_tile(ArtTile_ArtNem_TornadoThruster,0,0),4,3,$40,0
; animation script
; off_3AFDC:
Ani_objB2_a:	offsetTable
		offsetTableEntry.w byte_3AFE0	; 0
		offsetTableEntry.w byte_3AFE6	; 1
byte_3AFE0:	dc.b   0,  0,  1,  2,  3,$FF
byte_3AFE6:	dc.b   0,  4,  5,  6,  7,$FF
		even
; animation script
; off_3AFEC:
Ani_objB2_b:	offsetTable
		offsetTableEntry.w +	; 0
; byte_3AFEE:
+		dc.b   0,  1,  2,$FF
		even
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB2_MapUnc_3AFF2:	BINCLUDE "mappings/sprite/objB2_a.bin"
        even
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB2_MapUnc_3B292:	BINCLUDE "mappings/sprite/objB2_b.bin"

                 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B3 - Clouds (placeable object) from SCZ
; ----------------------------------------------------------------------------
; Sprite_3B2DE:
ObjB3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB3_Index(pc,d0.w),d1
	jmp	ObjB3_Index(pc,d1.w)
; ===========================================================================
; off_3B2EC:
ObjB3_Index:	offsetTable
		offsetTableEntry.w ObjB3_Init	; 0
		offsetTableEntry.w ObjB3_Main	; 2
; ===========================================================================
; loc_3B2F0:
ObjB3_Init:
	bsr.w	LoadSubObject
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$5E,d0
	move.w	word_3B30C(pc,d0.w),x_vel(a0)
	lsr.w	#1,d0
	move.b	d0,mapping_frame(a0)
	rts
; ===========================================================================
word_3B30C:
	dc.w  -$80
	dc.w  -$40	; 1
	dc.w  -$20	; 2
; ===========================================================================
; loc_3B312:
ObjB3_Main:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	move.w	(Tornado_Velocity_X).w,d0
	add.w	d0,x_pos(a0)
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
; off_3B322:
ObjB3_SubObjData:
	subObjData ObjB3_MapUnc_3B32C,make_art_tile(ArtTile_ArtNem_Clouds,2,0),4,6,$30,0

; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
ObjB3_MapUnc_3B32C:	BINCLUDE "mappings/sprite/objB3.bin"
               even



; ===========================================================================
; ----------------------------------------------------------------------------
; Object B4 - Vertical propeller from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B36A:
ObjB4:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB4_Index(pc,d0.w),d1
	jmp	ObjB4_Index(pc,d1.w)
; ===========================================================================
; off_3B378:
ObjB4_Index:	offsetTable
		offsetTableEntry.w ObjB4_Init	; 0
		offsetTableEntry.w ObjB4_Main	; 2
; ===========================================================================
; loc_3B37C:
ObjB4_Init:
	bsr.w	LoadSubObject
	bclr	#1,render_flags(a0)
	beq.s	+
	clr.b	collision_flags(a0)
+
	rts
; ===========================================================================
; loc_3B38E:
ObjB4_Main:
	lea	(Ani_objB4).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$1F,d0
	bne.s	+
	moveq	#SndID_Helicopter,d0
	jsrto	(PlaySoundLocal).l, JmpTo_PlaySoundLocal
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; off_3B3AC:
ObjB4_SubObjData:
	subObjData ObjB4_MapUnc_3B3BE,make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1),4,4,4,$A8
; animation script
; off_3B3B6:
Ani_objB4:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,$FF,  0
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB4_MapUnc_3B3BE:	BINCLUDE "mappings/sprite/objB4.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B5 - Horizontal propeller from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B3FA:
ObjB5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB5_Index(pc,d0.w),d1
	jmp	ObjB5_Index(pc,d1.w)
; ===========================================================================
; off_3B408:
ObjB5_Index:	offsetTable
		offsetTableEntry.w ObjB5_Init		; 0
		offsetTableEntry.w ObjB5_Main		; 2 - used in WFZ
		offsetTableEntry.w ObjB5_Animate	; 4 - used in SCZ, no effect on players
; ===========================================================================
; loc_3B40E:
ObjB5_Init:
	bsr.w	LoadSubObject
	move.b	#4,anim(a0)
	move.b	subtype(a0),d0
	subi.b	#$64,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================
; loc_3B426:
ObjB5_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B442(pc,d0.w),d1
	jsr	off_3B442(pc,d1.w)
	lea	(Ani_objB5).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
off_3B442:	offsetTable
		offsetTableEntry.w +	; 0
; ===========================================================================
+	bra.w	ObjB5_CheckPlayers
; ===========================================================================
; loc_3B448:
ObjB5_Animate:
	lea	(Ani_objB5).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; loc_3B456:
ObjB5_CheckPlayers:
	cmpi.b	#4,anim(a0)
	bne.s	++	; rts
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.w	ObjB5_CheckPlayer
	lea	(Sidekick).w,a1 ; a1=character
; loc_3B46A:
ObjB5_CheckPlayer:
	move.w	x_pos(a1),d0
	sub.w	x_pos(a0),d0
	addi.w	#$40,d0
	cmpi.w	#$80,d0
	bhs.s	++	; rts
	moveq	#0,d1
	move.b	(Oscillating_Data+$14).w,d1
	add.w	y_pos(a1),d1
	addi.w	#$60,d1
	sub.w	y_pos(a0),d1
	bcs.s	++	; rts
	cmpi.w	#$90,d1
	bhs.s	++	; rts
	subi.w	#$60,d1
	bcs.s	+
	not.w	d1
	add.w	d1,d1
+
	addi.w	#$60,d1
	neg.w	d1
	asr.w	#4,d1
	add.w	d1,y_pos(a1)
	bset	#1,status(a1)
	move.w	#0,y_vel(a1)
	move.w	#1,inertia(a1)
	tst.b	flip_angle(a1)
	bne.s	+	; rts
	move.b	#1,flip_angle(a1)
	move.b	#AniIDSonAni_Float2,anim(a1)
	move.b	#$7F,flips_remaining(a1)
	move.b	#8,flip_speed(a1)
+
	rts
; ===========================================================================
; off_3B4DE:
ObjB5_SubObjData:
	subObjData ObjB5_MapUnc_3B548,make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1),4,4,$40,0

; animation script
; off_3B4E8:
Ani_objB5:	offsetTable
		offsetTableEntry.w byte_3B4FC	; 0
		offsetTableEntry.w byte_3B506	; 1
		offsetTableEntry.w byte_3B50E	; 2
		offsetTableEntry.w byte_3B516	; 3
		offsetTableEntry.w byte_3B51C	; 4
		offsetTableEntry.w byte_3B524	; 5
		offsetTableEntry.w byte_3B52A	; 6
		offsetTableEntry.w byte_3B532	; 7
		offsetTableEntry.w byte_3B53A	; 8
		offsetTableEntry.w byte_3B544	; 9
byte_3B4FC:	dc.b   7,  0,  1,  2,  3,  4,  5,$FD,  1,  0
byte_3B506:	dc.b   4,  0,  1,  2,  3,  4,$FD,  2
byte_3B50E:	dc.b   3,  5,  0,  1,  2,$FD,  3,  0
byte_3B516:	dc.b   2,  3,  4,  5,$FD,  4
byte_3B51C:	dc.b   1,  0,  1,  2,  3,  4,  5,$FF
byte_3B524:	dc.b   2,  5,  4,  3,$FD,  6
byte_3B52A:	dc.b   3,  2,  1,  0,  5,$FD,  7,  0
byte_3B532:	dc.b   4,  4,  3,  2,  1,  0,$FD,  8
byte_3B53A:	dc.b   7,  5,  4,  3,  2,  1,  0,$FD,  9,  0
byte_3B544:	dc.b $7E,  0,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB5_MapUnc_3B548:	BINCLUDE "mappings/sprite/objB5.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B6 - Tilting platform from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B5D0:
ObjB6:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB6_Index(pc,d0.w),d1
	jmp	ObjB6_Index(pc,d1.w)
; ===========================================================================
; off_3B5DE:
ObjB6_Index:	offsetTable
		offsetTableEntry.w ObjB6_Init	; 0
		offsetTableEntry.w loc_3B602	; 2
		offsetTableEntry.w loc_3B65C	; 4
		offsetTableEntry.w loc_3B6C8	; 6
		offsetTableEntry.w loc_3B73C	; 8
; ===========================================================================
; loc_3B5E8:
ObjB6_Init:
	moveq	#0,d0
	move.b	#($35<<1),d0
	bsr.w	LoadSubObject_Part2
	move.b	subtype(a0),d0
	andi.b	#6,d0
	addq.b	#2,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================

loc_3B602:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B614(pc,d0.w),d1
	jsr	off_3B614(pc,d1.w)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
off_3B614:	offsetTable
		offsetTableEntry.w loc_3B61C	; 0
		offsetTableEntry.w loc_3B624	; 2
		offsetTableEntry.w loc_3B644	; 4
		offsetTableEntry.w loc_3B64E	; 6
; ===========================================================================

loc_3B61C:
	addq.b	#2,routine_secondary(a0)
	bra.w	loc_3B77E
; ===========================================================================

loc_3B624:
	bsr.w	loc_3B790
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F0,d0
	cmp.b	subtype(a0),d0
	beq.s	loc_3B638
	rts
; ===========================================================================

loc_3B638:
	addq.b	#2,routine_secondary(a0)
	clr.b	anim(a0)
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B644:
	lea	(Ani_objB6).l,a1
	jmpto	(AnimateSprite).l, JmpTo25_AnimateSprite
; ===========================================================================

loc_3B64E:
	move.b	#2,routine_secondary(a0)
	move.w	#$C0,objoff_2E(a0)
	rts
; ===========================================================================

loc_3B65C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B66E(pc,d0.w),d1
	jsr	off_3B66E(pc,d1.w)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
off_3B66E:	offsetTable
		offsetTableEntry.w loc_3B61C
		offsetTableEntry.w loc_3B674
		offsetTableEntry.w loc_3B6A6
; ===========================================================================

loc_3B674:
	bsr.w	loc_3B790
	subq.w	#1,objoff_2E(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.b	#$20,objoff_2E(a0)
	move.b	#3,anim(a0)
	clr.b	anim_frame(a0)
	clr.b	anim_frame_duration(a0)
	bsr.w	loc_3B7BC
	bsr.w	loc_3B7F8
	moveq	#SndID_Fire,d0
	jmpto	(PlaySound).l, JmpTo12_PlaySound
; ===========================================================================

loc_3B6A6:
	subq.b	#1,objoff_2E(a0)
	bmi.s	+
	lea	(Ani_objB6).l,a1
	jmpto	(AnimateSprite).l, JmpTo25_AnimateSprite
; ===========================================================================
+
	move.b	#2,routine_secondary(a0)
	clr.b	mapping_frame(a0)
	move.w	#$C0,objoff_2E(a0)
	rts
; ===========================================================================

loc_3B6C8:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B6DA(pc,d0.w),d1
	jsr	off_3B6DA(pc,d1.w)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
off_3B6DA:	offsetTable
		offsetTableEntry.w loc_3B6E2	; 0
		offsetTableEntry.w loc_3B6FE	; 2
		offsetTableEntry.w loc_3B72C	; 4
		offsetTableEntry.w loc_3B736	; 6
; ===========================================================================

loc_3B6E2:
	bsr.w	loc_3B790
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	bne.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$10,objoff_2E(a0)
	rts
; ===========================================================================

loc_3B6FE:
	bsr.w	loc_3B790
	subq.w	#1,objoff_2E(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.b	#0,anim(a0)
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#0,status(a0)
	tst.w	d0
	bne.s	+
	bset	#0,status(a0)
+
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B72C:
	lea	(Ani_objB6).l,a1
	jmpto	(AnimateSprite).l, JmpTo25_AnimateSprite
; ===========================================================================

loc_3B736:
	clr.b	routine_secondary(a0)
	rts
; ===========================================================================

loc_3B73C:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3B74E(pc,d0.w),d1
	jsr	off_3B74E(pc,d1.w)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
off_3B74E:	offsetTable
		offsetTableEntry.w loc_3B756	; 0
		offsetTableEntry.w loc_3B764	; 2
		offsetTableEntry.w loc_3B644	; 4
		offsetTableEntry.w loc_3B64E	; 6
; ===========================================================================

loc_3B756:
	addq.b	#2,routine_secondary(a0)
	move.b	#2,mapping_frame(a0)
	bra.w	loc_3B77E
; ===========================================================================

loc_3B764:
	bsr.w	loc_3B7A6
	subq.w	#1,objoff_2E(a0)
	bmi.s	loc_3B770
	rts
; ===========================================================================

loc_3B770:
	addq.b	#2,routine_secondary(a0)
	move.b	#4,anim(a0)
	bra.w	loc_3B7BC
; ===========================================================================

loc_3B77E:
	move.b	subtype(a0),d0
	andi.w	#$F0,d0
	move.b	d0,subtype(a0)
	move.w	d0,objoff_2E(a0)
	rts
; ===========================================================================

loc_3B790:
	move.w	x_pos(a0),-(sp)
	move.w	#$23,d1
	move.w	#4,d2
	move.w	#4,d3
	move.w	(sp)+,d4
	jmpto	(SolidObject).l, JmpTo27_SolidObject
; ===========================================================================

loc_3B7A6:
	move.w	x_pos(a0),-(sp)
	move.w	#$F,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	(sp)+,d4
	jmpto	(SolidObject).l, JmpTo27_SolidObject
; ===========================================================================

loc_3B7BC:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_3B7F6
	bclr	#p1_standing_bit,status(a0)
	beq.s	loc_3B7DE
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#3,status(a1)
	bset	#1,status(a1)

loc_3B7DE:
	bclr	#p2_standing_bit,status(a0)
	beq.s	return_3B7F6
	lea	(Sidekick).w,a1 ; a1=character
	bclr	#4,status(a1)
	bset	#1,status(a1)

return_3B7F6:
	rts
; ===========================================================================

loc_3B7F8:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	+
	move.l	#ObjB7,(a1)  ; load objB7 (huge unused vertical laser!)
	move.b	#$72,subtype(a1) ; <== ObjB7_SubObjData
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================
; off_3B818:
ObjB6_SubObjData:
	subObjData ObjB6_MapUnc_3B856,make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1),4,4,$10,0

; animation script
; off_3B822:
Ani_objB6:	offsetTable
		offsetTableEntry.w byte_3B830	; 0
		offsetTableEntry.w byte_3B836	; 1
		offsetTableEntry.w byte_3B83A	; 2
		offsetTableEntry.w byte_3B840	; 3
		offsetTableEntry.w byte_3B846	; 4
		offsetTableEntry.w byte_3B84C	; 5
		offsetTableEntry.w byte_3B850	; 6
byte_3B830:	dc.b   3,  1,  2,$FD,  1,  0
byte_3B836:	dc.b $3F,  2,$FD,  2
byte_3B83A:	dc.b   3,  2,  1,  0,$FA,  0
byte_3B840:	dc.b   1,  0,  1,  2,  3,$FF
byte_3B846:	dc.b   3,  1,  0,$FD,  5,  0
byte_3B84C:	dc.b $3F,  0,$FD,  6
byte_3B850:	dc.b   3,  0,  1,  2,$FA,  0
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB6_MapUnc_3B856:	BINCLUDE "mappings/sprite/objB6.bin"
          even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B7 - Unused huge vertical laser from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B8A6:
ObjB7:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB7_Index(pc,d0.w),d1
	jmp	ObjB7_Index(pc,d1.w)
; ===========================================================================
; off_3B8B4:
ObjB7_Index:	offsetTable
		offsetTableEntry.w ObjB7_Init	; 0
		offsetTableEntry.w ObjB7_Main	; 2
; ===========================================================================
; loc_3B8B8:
ObjB7_Init:
	bsr.w	LoadSubObject
	move.b	#$20,objoff_2E(a0)
	rts
; ===========================================================================
; loc_3B8C4:
ObjB7_Main:
	subq.b	#1,objoff_2E(a0)
	beq.w	JmpTo65_DeleteObject
	bchg	#0,objoff_2F(a0)
	beq.w	return_37A48
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; off_3B8DA:
ObjB7_SubObjData:
	subObjData ObjB7_MapUnc_3B8E4,make_art_tile(ArtTile_ArtNem_WfzVrtclLazer,2,1),4,4,$18,$A9
ObjB7_MapUnc_3B8E4:	BINCLUDE "mappings/sprite/objB7.bin"
                  even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B8 - Wall turret from WFZ
; ----------------------------------------------------------------------------
; Sprite_3B968:
ObjB8:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB8_Index(pc,d0.w),d1
	jmp	ObjB8_Index(pc,d1.w)
; ===========================================================================
; off_3B976:
ObjB8_Index:	offsetTable
		offsetTableEntry.w ObjB8_Init	; 0
		offsetTableEntry.w loc_3B980	; 2
		offsetTableEntry.w loc_3B9AA	; 4
; ===========================================================================
; BranchTo5_LoadSubObject
ObjB8_Init:
	bra.w	LoadSubObject
; ===========================================================================

loc_3B980:
	tst.b	render_flags(a0)
	bpl.s	+
	bsr.w	Obj_GetOrientationToPlayer
	tst.w	d1
	beq.s	+
	addi.w	#$60,d2
	cmpi.w	#$C0,d2
	blo.s	++
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#2,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9AA:
	bsr.w	Obj_GetOrientationToPlayer
	moveq	#0,d6
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	blo.s	loc_3B9C0
	move.w	d0,d6
	lsr.w	#1,d6
	addq.w	#1,d6

loc_3B9C0:
	move.b	d6,mapping_frame(a0)
	subq.w	#1,objoff_2E(a0)
	bne.s	+
	move.w	#$60,objoff_2E(a0)
	bsr.w	loc_3B9D8
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3B9D8:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	+	; rts
	move.l	#Obj98,(a1)  ; load obj98
	move.b	#3,mapping_frame(a1)
	move.b	#$8E,subtype(a1) ; <== ObjB8_SubObjData2
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	lea_	Obj98_WallTurretShotMove,a2
	move.l	a2,objoff_2E(a1)
	moveq	#0,d0
	move.b	mapping_frame(a0),d0
	lsl.w	#2,d0
	lea	byte_3BA2A(pc,d0.w),a2
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,x_pos(a1)
	move.b	(a2)+,d0
	ext.w	d0
	add.w	d0,y_pos(a1)
	move.b	(a2)+,x_vel(a1)
	move.b	(a2)+,y_vel(a1)
+
	rts
; ===========================================================================
byte_3BA2A:
	dc.b   0
	dc.b $18	; 1
	dc.b   0	; 2
	dc.b   1	; 3
	dc.b $EF	; 4
	dc.b $10	; 5
	dc.b $FF	; 6
	dc.b   1	; 7
	dc.b $11	; 8
	dc.b $10	; 9
	dc.b   1	; 10
	dc.b   1	; 11
	even
; off_3BA36:
ObjB8_SubObjData:
	subObjData ObjB8_Obj98_MapUnc_3BA46,make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0),4,4,$10,0
; animation script
; off_3BA40:
Ani_WallTurretShot: offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   2,  3,  4,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB8_Obj98_MapUnc_3BA46:	BINCLUDE "mappings/sprite/objB8.bin"
      even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B9 - Laser from WFZ that shoots down the Tornado
; ----------------------------------------------------------------------------
; Sprite_3BABA:
ObjB9:

        move.l  #Laser_Main,(a0)
	bra.w	LoadSubObject
; ===========================================================================

Laser_Main:
	tst.b	render_flags(a0)
	bmi.s	MoveLasterAndSound
	bra.w	MoveLaser_Display
; ===========================================================================
MoveLasterAndSound:
	move.l  #MoveLaser_Display,(a0)
	move.w	#-$1000,x_vel(a0)
	moveq	#SndID_LargeLaser,d0
	jsr	(PlaySound).l
; ===========================================================================

MoveLaser_Display:
	jsr	(ObjectMove).l
	move.w	x_pos(a0),d0
	move.w	(Camera_X_pos).w,d1
	subi.w	#$40,d1
	cmp.w	d1,d0
	blt.w	JmpTo65_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; off_3BB0E:
ObjB9_SubObjData:
	subObjData ObjB9_MapUnc_3BB18,make_art_tile(ArtTile_ArtNem_WfzHrzntlLazer,2,1),4,1,$60,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjB9_MapUnc_3BB18:	BINCLUDE "mappings/sprite/objB9.bin"
        even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BA - Wheel from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BB4C:
ObjBA:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBA_Index(pc,d0.w),d1
	jmp	ObjBA_Index(pc,d1.w)
; ===========================================================================
; off_3BB5A:
ObjBA_Index:	offsetTable
		offsetTableEntry.w ObjBA_Init	; 0
		offsetTableEntry.w ObjBA_Main	; 2
; ===========================================================================
; BranchTo7_LoadSubObject
ObjBA_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo14_JmpTo39_MarkObjGone
ObjBA_Main:
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB66:
ObjBA_SubObjData:
	subObjData ObjBA_MapUnc_3BB70,make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBA_MapUnc_3BB70:	BINCLUDE "mappings/sprite/objBA.bin"
     even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BB - Removed object (unknown, unused)
; ----------------------------------------------------------------------------
; Sprite_3BB7C:
ObjBB:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBB_Index(pc,d0.w),d1
	jmp	ObjBB_Index(pc,d1.w)
; ===========================================================================
; off_3BB8A:
ObjBB_Index:	offsetTable
		offsetTableEntry.w ObjBB_Init	; 0
		offsetTableEntry.w ObjBB_Main	; 2
; ===========================================================================
; BranchTo8_LoadSubObject
ObjBB_Init:
	bra.w	LoadSubObject
; ===========================================================================
; BranchTo15_JmpTo39_MarkObjGone
ObjBB_Main:
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; off_3BB96:
ObjBB_SubObjData:
	subObjData ObjBB_MapUnc_3BBA0,make_art_tile(ArtTile_ArtNem_Unknown,1,0),4,4,$C,9
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBB_MapUnc_3BBA0:	BINCLUDE "mappings/sprite/objBB.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BC - Fire coming out of Robotnik's ship in WFZ
; ----------------------------------------------------------------------------
; Sprite_3BBBC:
ObjBC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBC_Index(pc,d0.w),d1
	jmp	ObjBC_Index(pc,d1.w)
; ===========================================================================
; off_3BBCA:
ObjBC_Index:	offsetTable
		offsetTableEntry.w ObjBC_Init
		offsetTableEntry.w ObjBC_Main
; ===========================================================================
; loc_3BBCE:
ObjBC_Init:
	bsr.w	LoadSubObject
	move.w	x_pos(a0),objoff_30(a0)
	rts
; ===========================================================================
; loc_3BBDA:
ObjBC_Main:
	move.w	objoff_30(a0),d0
	move.w	(Camera_BG_X_offset).w,d1
	cmpi.w	#$380,d1
	bhs.w	JmpTo65_DeleteObject
	add.w	d1,d0
	move.w	d0,x_pos(a0)
	bchg	#0,objoff_2E(a0)
	beq.w	return_37A48
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; off_3BBFE:
ObjBC_SubObjData2:
	subObjData ObjBC_MapUnc_3BC08,make_art_tile(ArtTile_ArtNem_WfzThrust,2,0),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBC_MapUnc_3BC08:	BINCLUDE "mappings/sprite/objBC.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BD - Ascending/descending metal platforms from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BC1C:
ObjBD:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBD_Index(pc,d0.w),d1
	jmp	ObjBD_Index(pc,d1.w)
; ===========================================================================
; off_3BC2A:
ObjBD_Index:	offsetTable
		offsetTableEntry.w ObjBD_Init	; 0
		offsetTableEntry.w loc_3BC3C	; 2
		offsetTableEntry.w loc_3BC50	; 4
; ===========================================================================
; loc_3BC30:
ObjBD_Init:
	addq.b	#2,routine(a0)
	move.w	#1,objoff_2E(a0)
	rts
; ===========================================================================

loc_3BC3C:
	subq.w	#1,objoff_2E(a0)
	bne.s	+
	move.w	#$40,objoff_2E(a0)
	bsr.w	loc_3BCF8
+
	jmpto	(MarkObjGone3).l, JmpTo8_MarkObjGone3
; ===========================================================================

loc_3BC50:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3BC62(pc,d0.w),d1
	jsr	off_3BC62(pc,d1.w)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
off_3BC62:	offsetTable
		offsetTableEntry.w loc_3BC6C	; 0
		offsetTableEntry.w loc_3BCAC	; 2
		offsetTableEntry.w loc_3BCB6	; 4
		offsetTableEntry.w loc_3BCCC	; 6
		offsetTableEntry.w loc_3BCD6	; 8
; ===========================================================================

loc_3BC6C:
	bsr.w	LoadSubObject
	move.b	#2,mapping_frame(a0)
	subq.b	#2,routine(a0)
	addq.b	#2,routine_secondary(a0)
	move.w	#$C7,objoff_2E(a0)
	btst	#0,render_flags(a0)
	beq.s	loc_3BC92
	move.w	#$1C7,objoff_2E(a0)

loc_3BC92:
	moveq	#0,d0
	move.b	subtype(a0),d0
	subi.b	#$7E,d0
	move.b	d0,subtype(a0)
	move.w	word_3BCA8(pc,d0.w),y_vel(a0)
	rts
; ===========================================================================
word_3BCA8:
	dc.w -$100
	dc.w  $100	; 1
; ===========================================================================

loc_3BCAC:
	lea	(Ani_objBD).l,a1
	jmpto	(AnimateSprite).l, JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCB6:
	subq.w	#1,objoff_2E(a0)
	bmi.s	loc_3BCC0
	bra.w	loc_3BCDE
; ===========================================================================

loc_3BCC0:
	addq.b	#2,routine_secondary(a0)
	move.b	#1,anim(a0)
	rts
; ===========================================================================

loc_3BCCC:
	lea	(Ani_objBD).l,a1
	jmpto	(AnimateSprite).l, JmpTo25_AnimateSprite
; ===========================================================================

loc_3BCD6:
	bsr.w	loc_3B7BC
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

loc_3BCDE:
	move.w	x_pos(a0),-(sp)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	move.w	#$23,d1
	move.w	#4,d2
	move.w	#5,d3
	move.w	(sp)+,d4
	jmpto	(PlatformObject).l, JmpTo9_PlatformObject
; ===========================================================================

loc_3BCF8:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	+	; rts
	move.l	#ObjBD,(a1); load objBD
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)
	move.b	subtype(a0),subtype(a1)
	move.b	render_flags(a0),render_flags(a1)
+
	rts
; ===========================================================================
; off_3BD24:
ObjBD_SubObjData:
	subObjData ObjBD_MapUnc_3BD3E,make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1),4,4,$18,0
; animation script
; off_3BD2E:
Ani_objBD:	offsetTable
		offsetTableEntry.w byte_3BD32	; 0
		offsetTableEntry.w byte_3BD38	; 1
byte_3BD32:	dc.b   3,  2,  1,  0,$FA,  0
byte_3BD38:	dc.b   1,  0,  1,  2,$FA
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBD_MapUnc_3BD3E:	BINCLUDE "mappings/sprite/objBD.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BE - Lateral cannon (temporary platform that pops in/out) from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BD7A:
ObjBE:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBE_Index(pc,d0.w),d1
	jmp	ObjBE_Index(pc,d1.w)
; ===========================================================================
; off_3BD88:
ObjBE_Index:	offsetTable
		offsetTableEntry.w ObjBE_Init	;  0
		offsetTableEntry.w loc_3BDA2	;  2
		offsetTableEntry.w loc_3BDC6	;  4
		offsetTableEntry.w loc_3BDD4	;  6
		offsetTableEntry.w loc_3BDC6	;  8
		offsetTableEntry.w loc_3BDF4	; $A
; ===========================================================================
; loc_3BD94:
ObjBE_Init:
	moveq	#0,d0
	move.b	#($41<<1),d0
	bsr.w	LoadSubObject_Part2
	bra.w	loc_3B77E
; ===========================================================================

loc_3BDA2:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#$F0,d0
	cmp.b	subtype(a0),d0
	beq.s	+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	clr.b	anim(a0)
	move.w	#$A0,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDC6:
	lea	(Ani_objBE).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDD4:
	subq.w	#1,objoff_2E(a0)
	beq.s	+
	bsr.w	loc_3BE04
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine(a0)
	move.b	#1,anim(a0)
	bsr.w	loc_3B7BC
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BDF4:
	move.b	#2,routine(a0)
	move.w	#$40,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3BE04:
	move.b	mapping_frame(a0),d0
	cmpi.b	#3,d0
	beq.s	+
	cmpi.b	#4,d0
	bne.w	loc_3B7BC
+
	move.w	x_pos(a0),-(sp)
	move.w	#$23,d1
	move.w	#$18,d2
	move.w	#$19,d3
	move.w	(sp)+,d4
	jmpto	(PlatformObject).l, JmpTo9_PlatformObject
; ===========================================================================
; off_3BE2C:
ObjBE_SubObjData:
	subObjData ObjBE_MapUnc_3BE46,make_art_tile(ArtTile_ArtNem_WfzGunPlatform,3,1),4,4,$18,0
; animation script
; off_3BE36:
Ani_objBE:	offsetTable
		offsetTableEntry.w byte_3BE3A	; 0
		offsetTableEntry.w byte_3BE40	; 1
byte_3BE3A:	dc.b   5,  0,  1,  2,  3,$FC
byte_3BE40:	dc.b   5,  3,  2,  1,  0,$FC
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBE_MapUnc_3BE46:	BINCLUDE "mappings/sprite/objBE.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object BF - Rotaty-stick badnik from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BEAA:
ObjBF:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjBF_Index(pc,d0.w),d1
	jmp	ObjBF_Index(pc,d1.w)
; ===========================================================================
; off_3BEB8:
ObjBF_Index:	offsetTable
		offsetTableEntry.w ObjBF_Init		; 0
		offsetTableEntry.w ObjBF_Animate	; 2
; ===========================================================================
; BranchTo9_LoadSubObject
ObjBF_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3BEC0:
ObjBF_Animate:
	lea	(Ani_objBF).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; off_3BECE:
ObjBE_SubObjData2:
	subObjData ObjBF_MapUnc_3BEE0,make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1),4,4,4,4
; animation script
; off_3BED8:
Ani_objBF:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,  2,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjBF_MapUnc_3BEE0:	BINCLUDE "mappings/sprite/objBF.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C0 - Speed launcher from WFZ
; ----------------------------------------------------------------------------
; Sprite_3BF04:
ObjC0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC0_Index(pc,d0.w),d1
	jmp	ObjC0_Index(pc,d1.w)
; ===========================================================================
; off_3BF12:
ObjC0_Index:	offsetTable
		offsetTableEntry.w ObjC0_Init	; 0
		offsetTableEntry.w ObjC0_Main	; 2
; ===========================================================================
; loc_3BF16:
ObjC0_Init:
	move.w	#($43<<1),d0
	bsr.w	LoadSubObject_Part2
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#4,d0
	btst	#0,status(a0)
	bne.s	+
	neg.w	d0
+
	move.w	x_pos(a0),d1
	move.w	d1,objoff_38(a0)
	add.w	d1,d0
	move.w	d0,objoff_36(a0)
; loc_3BF3E:
ObjC0_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3BF60(pc,d0.w),d1
	jsr	off_3BF60(pc,d1.w)
	move.w	#$10,d1
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	(PlatformObject).l, JmpTo9_PlatformObject
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
off_3BF60:	offsetTable
		offsetTableEntry.w loc_3BF66
		offsetTableEntry.w loc_3BFD8
		offsetTableEntry.w loc_3C062
; ===========================================================================

loc_3BF66:
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+++	; rts
	addq.b	#2,routine_secondary(a0)
	move.w	#$C00,x_vel(a0)
	move.w	#$80,objoff_34(a0)
	btst	#0,status(a0)
	bne.s	+
	neg.w	x_vel(a0)
	neg.w	objoff_34(a0)
+
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	move.b	status(a0),d0
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	andi.b	#p2_standing,d0
	beq.s	+	; rts
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	rts
; ===========================================================================

loc_3BFB4:
	clr.w	inertia(a1)
	clr.w	x_vel(a1)
	move.w	x_pos(a0),x_pos(a1)
	bclr	#0,status(a1)
	btst	#0,status(a0)
	bne.s	+
	bset	#0,status(a1)
+
	rts
; ===========================================================================

loc_3BFD8:
	move.w	objoff_34(a0),d0
	add.w	d0,x_vel(a0)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	move.w	objoff_36(a0),d0
	sub.w	x_pos(a0),d0
	btst	#0,status(a0)
	beq.s	+
	neg.w	d0
+
	tst.w	d0
	bpl.s	loc_3C034
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	return_3C01E
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	+
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3BFB4
+
	andi.b	#p2_standing,d0
	beq.s	return_3C01E
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3BFB4

return_3C01E:
	rts
; ===========================================================================

loc_3C020:
	move.w	x_vel(a0),x_vel(a1)
	move.w	#-$400,y_vel(a1)
	bset	#1,status(a1)
	rts
; ===========================================================================

loc_3C034:
	addq.b	#2,routine_secondary(a0)
	move.w	objoff_36(a0),x_pos(a0)
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	loc_3C062
	move.b	d0,d1
	andi.b	#p1_standing,d1
	beq.s	loc_3C056
	lea	(MainCharacter).w,a1 ; a1=character
	bsr.s	loc_3C020

loc_3C056:
	andi.b	#p2_standing,d0
	beq.s	loc_3C062
	lea	(Sidekick).w,a1 ; a1=character
	bsr.s	loc_3C020

loc_3C062:
	move.w	x_pos(a0),d0
	moveq	#4,d1
	tst.w	objoff_34(a0)	; if objoff_34(a0) is positive,
	spl	d2		; then set d2 to $FF, else set d2 to $00
	bmi.s	+
	neg.w	d1
+
	add.w	d1,d0
	cmp.w	objoff_38(a0),d0
	bhs.s	+
	not.b	d2
+
	tst.b	d2
	bne.s	+
	clr.b	routine_secondary(a0)
	move.w	objoff_38(a0),d0
+
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
; off_3C08E:
ObjC0_SubObjData:
	subObjData ObjC0_MapUnc_3C098,make_art_tile(ArtTile_ArtNem_WfzLaunchCatapult,1,0),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC0_MapUnc_3C098:	BINCLUDE "mappings/sprite/objC0.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C1 - Breakable plating from WFZ
; (and what sonic hangs onto on the back of Robotnic's getaway ship)
; ----------------------------------------------------------------------------
; Sprite_3C0AC:
ObjC1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC1_Index(pc,d0.w),d1
	jmp	ObjC1_Index(pc,d1.w)
; ===========================================================================
; off_3C0BA:
ObjC1_Index:	offsetTable
		offsetTableEntry.w ObjC1_Init	; 0
		offsetTableEntry.w ObjC1_Main	; 2
		offsetTableEntry.w ObjC1_Breakup	; 4
; ===========================================================================
; loc_3C0C0:
ObjC1_Init:
	move.w	#($44<<1),d0
	bsr.w	LoadSubObject_Part2
	moveq	#0,d0
	move.b	subtype(a0),d0
	mulu.w	#$3C,d0
	move.w	d0,objoff_34(a0)

ObjC1_Main:
	tst.b	objoff_36(a0)
	beq.s	loc_3C140
	tst.w	objoff_34(a0)
	beq.s	+
	subq.w	#1,objoff_34(a0)
	beq.s	loc_3C12E
+
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	y_pos(a0),d0
	subi.w	#$18,d0
	btst	#button_up,(Ctrl_1_Held).w
	beq.s	+
	subq.w	#1,y_pos(a1)
	cmp.w	y_pos(a1),d0
	blo.s	+
	move.w	d0,y_pos(a1)
+
	addi.w	#$30,d0
	btst	#button_down,(Ctrl_1_Held).w
	beq.s	+
	addq.w	#1,y_pos(a1)
	cmp.w	y_pos(a1),d0
	bhs.s	+
	move.w	d0,y_pos(a1)
+
	move.b	(Ctrl_1_Press_Logical).w,d0
	andi.w	#button_B_mask|button_C_mask|button_A_mask,d0
	beq.s	BranchTo16_JmpTo39_MarkObjGone

loc_3C12E:
	clr.b	collision_flags(a0)
	clr.b	(MainCharacter+obj_control).w
	clr.b	(WindTunnel_holding_flag).w
	clr.b	objoff_36(a0)
	bra.s	loc_3C19A
; ===========================================================================

loc_3C140:
	tst.b	collision_property(a0)
	beq.s	BranchTo16_JmpTo39_MarkObjGone
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	cmp.w	x_pos(a1),d0
	bhs.s	BranchTo16_JmpTo39_MarkObjGone
	clr.b	collision_property(a0)
	cmpi.b	#4,routine(a1)
	bhs.s	BranchTo16_JmpTo39_MarkObjGone
	clr.w	x_vel(a1)
	clr.w	y_vel(a1)
	move.w	x_pos(a0),d0
	subi.w	#$14,d0
	move.w	d0,x_pos(a1)
	bset	#0,status(a1)
	move.b	#AniIDSonAni_Hang,anim(a1)
	move.b	#1,(MainCharacter+obj_control).w
	move.b	#1,(WindTunnel_holding_flag).w
	move.b	#1,objoff_36(a0)

BranchTo16_JmpTo39_MarkObjGone
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3C19A:
	lea	(byte_3C1E4).l,a4
	lea	(byte_3C1E0).l,a2
	bsr.w	loc_3C1F4

ObjC1_Breakup:
	tst.b	objoff_43(a0)
	beq.s	+
	subq.b	#1,objoff_43(a0)
	bra.s	++
; ===========================================================================
+
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	addi.w	#8,y_vel(a0)
	lea	(Ani_objC1).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
+
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; animation script
; off_3C1D6:
Ani_objC1:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  2,  3,  4,  5,  1,$FF
		even

; unknown
byte_3C1E0:
	dc.b   0
	dc.b   4	; 1
	dc.b $18	; 2
	dc.b $20	; 3
byte_3C1E4:
	dc.w  -$10
	dc.w  -$10	; 2
	dc.w  -$10	; 4
	dc.w   $10	; 6
	dc.w  -$30	; 8
	dc.w  -$10	; 10
	dc.w  -$30	; 12
	dc.w   $10	; 14
; ===========================================================================

loc_3C1F4:
	move.w	x_pos(a0),d2
	move.w	y_pos(a0),d3
	move.b	priority(a0),d4
	subq.b	#1,d4
	moveq	#3,d1
	movea.l	a0,a1
	bra.s	loc_3C20E
; ===========================================================================

loc_3C208:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	loc_3C26C

loc_3C20E:
	move.b	#4,routine(a1)
	move.L	(a0),(a1) ; load obj
	move.l	mappings(a0),mappings(a1)
	move.w	art_tile(a0),art_tile(a1)
	move.b	#$84,render_flags(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	(a4)+,d0
	add.w	d2,d0
	move.w	d0,x_pos(a1)
	move.w	(a4)+,d0
	add.w	d3,d0
	move.w	d0,y_pos(a1)
	move.b	d4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#1,mapping_frame(a1)
	move.w	#-$400,x_vel(a1)
	move.w	#0,y_vel(a1)
	move.b	(a2)+,objoff_43(a1)
	dbf	d1,loc_3C208

loc_3C26C:
	move.w	#SndID_SlowSmash,d0
	jmp	(PlaySound).l
; ===========================================================================
; off_3C276:
ObjC1_SubObjData:
	subObjData ObjC1_MapUnc_3C280,make_art_tile(ArtTile_ArtNem_BreakPanels,3,1),4,4,$40,$E1
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC1_MapUnc_3C280:	BINCLUDE "mappings/sprite/objC1.bin"
 even
; ===========================================================================
; ----------------------------------------------------------------------------
; Object C2 - Rivet thing you bust to get into ship at the end of WFZ
; ----------------------------------------------------------------------------
; Sprite_3C328:
ObjC2:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC2_Index(pc,d0.w),d1
	jmp	ObjC2_Index(pc,d1.w)
; ===========================================================================
; off_3C336:
ObjC2_Index:	offsetTable
		offsetTableEntry.w ObjC2_Init	; 0
		offsetTableEntry.w ObjC2_Main	; 2
; ===========================================================================
; BranchTo10_LoadSubObject
ObjC2_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_3C33E:
ObjC2_Main:
	move.b	(MainCharacter+anim).w,objoff_34(a0)
	move.w	x_pos(a0),-(sp)
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#9,d3
	move.w	(sp)+,d4
	jsrto	(SolidObject).l, JmpTo27_SolidObject
	btst	#p1_standing_bit,status(a0)
	bne.s	ObjC2_Bust
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; loc_3C366:
ObjC2_Bust:
	cmpi.b	#2,objoff_34(a0)
	bne.s	+
	move.w	#$2880,(Camera_Min_X_pos).w
	bclr	#p1_standing_bit,status(a0)
	move.l	#Obj27,(a0); load 0bj27 (transform into explosion)
	move.b	#2,routine(a0)
	bset	#1,(MainCharacter+status).w
	bclr	#3,(MainCharacter+status).w
	lea	(Level_Layout+$850).w,a1	; alter the level layout
	move.l	#$8A707172,(a1)+
	move.w	#$7374,(a1)+
	lea	(Level_Layout+$950).w,a1
	move.l	#$6E787978,(a1)+
	move.w	#$787A,(a1)+
	move.b	#1,(Screen_redraw_flag).w
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; off_3C3B8:
ObjC2_SubObjData:
	subObjData ObjC2_MapUnc_3C3C2,make_art_tile(ArtTile_ArtNem_WfzSwitch,1,1),4,4,$10,0
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC2_MapUnc_3C3C2:	BINCLUDE "mappings/sprite/objC2.bin"
                    even
Invalid_SubObjData2:

; ===========================================================================
; ----------------------------------------------------------------------------
; Object C3,C4 - Plane's smoke from WFZ
; ----------------------------------------------------------------------------
; Sprite_3C3D6:
ObjC3:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC3_Index(pc,d0.w),d1
	jmp	ObjC3_Index(pc,d1.w)
; ===========================================================================
; off_3C3E4:
ObjC3_Index:	offsetTable
		offsetTableEntry.w ObjC3_Init
		offsetTableEntry.w ObjC3_Main
; ===========================================================================
; loc_3C3E8:
ObjC3_Init:
	bsr.w	LoadSubObject
	move.b	#7,anim_frame_duration(a0)
	jsrto	(RandomNumber).l, JmpTo6_RandomNumber
	move.w	(RNG_seed).w,d0
	andi.w	#$1C,d0
	sub.w	d0,x_pos(a0)
	addi.w	#$10,y_pos(a0)
	move.w	#-$100,y_vel(a0)
	move.w	#-$100,x_vel(a0)
	rts
; ===========================================================================
; loc_3C416:
ObjC3_Main:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	beq.w	JmpTo65_DeleteObject
+
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; off_3C438:
ObjC3_SubObjData:
	subObjData Obj27_MapUnc_21120,make_art_tile(ArtTile_ArtKosM_Explosion,0,0),4,5,$C,0
