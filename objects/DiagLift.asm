

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 16 - Diagonally moving lift from HTZ
; ----------------------------------------------------------------------------
; Sprite_21DAC:
Obj16:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj16_Index(pc,d0.w),d1
	jmp	Obj16_Index(pc,d1.w)
; ===========================================================================
; off_21DBA:
Obj16_Index:	offsetTable
		offsetTableEntry.w Obj16_Init	; 0
		offsetTableEntry.w Obj16_Main	; 2
; ===========================================================================
; loc_21DBE:
Obj16_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj16_MapUnc_21F14,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_HtzZipline,2,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo14_Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#0,mapping_frame(a0)
	move.b	#1,priority(a0)
	move.w	x_pos(a0),objoff_34(a0)
	move.w	y_pos(a0),objoff_36(a0)
	move.b	#$40,y_radius(a0)
	bset	#4,render_flags(a0)
	moveq	#0,d0
	move.b	subtype(a0),d0
	lsl.w	#3,d0
	move.w	d0,objoff_38(a0)
; loc_21E10:
Obj16_Main:
	move.w	x_pos(a0),-(sp)
	jsr	Obj16_RunSecondaryRoutine
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	#-$28,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject).l, JmpTo3_PlatformObject
	jmpto	(MarkObjGone).l, JmpTo5_MarkObjGone
; ===========================================================================
; loc_21E2C:
Obj16_RunSecondaryRoutine:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj16_Main_States(pc,d0.w),d1
	jmp	Obj16_Main_States(pc,d1.w)
; ===========================================================================
; off_21E3A:
Obj16_Main_States: offsetTable
	offsetTableEntry.w Obj16_Wait	; 0
	offsetTableEntry.w Obj16_Slide	; 2
	offsetTableEntry.w Obj16_Fall	; 4
; ===========================================================================
; loc_21E40:
Obj16_Wait:
	move.b	status(a0),d0	; get the status flags
	andi.b	#standing_mask,d0	; is one of the players standing on it?
	beq.s	++		; if not, branch
	addq.b	#2,routine_secondary(a0)
	move.w	#$200,x_vel(a0)
	btst	#0,status(a0)
	beq.s	+
	neg.w	x_vel(a0)
+
	move.w	#$100,y_vel(a0)
+
	rts
; ===========================================================================
; loc_21E68:
Obj16_Slide:
	move.w	(Timer_frames).w,d0
	andi.w	#$F,d0	; play the sound only every 16 frames
	bne.s	+
	move.w	#SndID_HTZLiftClick,d0
	jsr	(PlaySound).l
+
	jsrto	(ObjectMove).l, JmpTo4_ObjectMove
	subq.w	#1,objoff_38(a0)
	bne.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	move.b	#2,mapping_frame(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	jsrto	(SingleObjLoad2).l, JmpTo4_SingleObjLoad2
	bne.s	+	; rts
	move.l	#Obj1C,(a1) ; load obj1C
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#6,subtype(a1)
+	rts
; ===========================================================================
; loc_21EC2:
Obj16_Fall:
	jsrto	(ObjectMove).l, JmpTo4_ObjectMove
	addi.w	#$38,y_vel(a0)
	move.w	(Camera_Max_Y_pos_now).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0
	bhs.s	+++	; rts
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	++
	bclr	#p1_standing_bit,status(a0)
	beq.s	+
	bclr	#3,(MainCharacter+status).w
	bset	#1,(MainCharacter+status).w
+
	bclr	#p2_standing_bit,status(a0)
	beq.s	+
	bclr	#3,(Sidekick+status).w
	bset	#1,(Sidekick+status).w
+
	move.w	#$4000,x_pos(a0)
+
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj16_MapUnc_21F14:	BINCLUDE "mappings/sprite/obj16.bin"
          even
; ===========================================================================

    if ~~removeJmpTos
JmpTo5_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo4_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo14_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo3_PlatformObject ; JmpTo
	jmp	(PlatformObject).l
; loc_22010:
JmpTo4_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif


