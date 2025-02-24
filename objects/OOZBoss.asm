


; ===========================================================================
; ----------------------------------------------------------------------------
; Object 55 - OOZ boss
; ----------------------------------------------------------------------------
; OST Variables:
Obj55_status			= $2B	; bitfield
Obj55_anim_frame_duration	= $2C	; number of frames the laser shooter displays its shooting frame
Obj55_shot_count		= objoff_34	; number of lasers the shooter fires during its attack phase
Obj55_laser_pos			= objoff_2E	; bitfield, each of the first four bits stands for one of the possible y positions a laser can be fired from

Obj55_Wave_delay	= objoff_30	; time before the next part of the wave is created
Obj55_Wave_parent	= objoff_32	; pointer to main vehicle
Obj55_Wave_count	= objoff_2F	; number of waves to make
OOZ_HitCount = $40
; Sprite_32F90:
Obj55:
	moveq	#0,d0
	move.b	boss_subtype(a0),d0
	move.w	Obj55_Index(pc,d0.w),d1
	jmp	Obj55_Index(pc,d1.w)

; ===========================================================================
; off_32F9E:
Obj55_Index:	offsetTable
		offsetTableEntry.w Obj55_Init		; 0 - Init
		offsetTableEntry.w Obj55_Main		; 2 - Main Vehicle
		offsetTableEntry.w Obj55_LaserShooter	; 4 - Laser Shooter
		offsetTableEntry.w Obj55_SpikeChain	; 6 - Spiked Chain
		offsetTableEntry.w Obj55_Laser		; 8 - Laser
; ===========================================================================
; loc_32FA8:
Obj55_Init:
	move.l	#Obj55_MapUnc_33756,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	bset	#6,render_flags(a0)	; object consists of multiple sprites
	move.b	#0,mainspr_childsprites(a0)
	addq.b	#2,boss_subtype(a0)	; => Obj55_Main
	move.b	#$F,collision_flags(a0)
	move.b	#8,OOZ_HitCount(a0)
	move.b	#8,boss_hitcount2(a0) ; this gets overlapped so it cant be used here but it gets used as a boss hit box the real hit count is OOZ_HitCount
	move.b	#$40,mainspr_width(a0)
	rts
; ===========================================================================
; loc_32FE6:
Obj55_Main:
	moveq	#0,d0
	move.b	boss_routine(a0),d0
	move.w	Obj55_Main_Index(pc,d0.w),d1
	jmp	Obj55_Main_Index(pc,d1.w)
; ===========================================================================
; off_32FF4:
Obj55_Main_Index:	offsetTable
		offsetTableEntry.w Obj55_Main_Init	; 0 - boss' initial state
		offsetTableEntry.w Obj55_Main_Surface	; 2 - moving up
		offsetTableEntry.w Obj55_Main_Wait	; 4 - stay in place for a while
		offsetTableEntry.w Obj55_Main_Dive	; 6 - moving down
		offsetTableEntry.w Obj55_Main_Defeated	; 8 - boss defeated and escaping
; ===========================================================================
; loc_32FFE:
Obj55_Main_Init:
	move.w	#$2940,(Boss_X_pos).w
	bclr	#0,render_flags(a0)	; face right
	move.w	(MainCharacter+x_pos).w,d1
	cmpi.w	#$293A,d1	; is player on the left side of the arena?
	bhs.s	+		; if not, branch
	bchg	#0,render_flags(a0)	; face left
+
	move.w	#$2D0,y_pos(a0)
	move.w	#$2D0,(Boss_Y_pos).w
	move.b	#8,mainspr_mapframe(a0)
	move.b	#1,mainspr_childsprites(a0)
	addq.b	#2,boss_routine(a0)	; => Obj55_Main_Surface
	move.w	#-$80,(Boss_Y_vel).w
	move.b	#$F,collision_flags(a0)
	move.w	x_pos(a0),sub2_x_pos(a0)
	move.w	y_pos(a0),sub2_y_pos(a0)
	clr.b	boss_sine_count(a0)
	clr.b	Obj55_status(a0)
	move.b	#8,sub2_mapframe(a0)
	lea	(Boss_AnimationArray).w,a2
	move.b	#5,(a2)+
	move.b	#0,(a2)+
	move.b	#1,(a2)+
	move.b	#0,(a2)
	move.b	#0,(Boss_CollisionRoutine).w
	rts
; ===========================================================================
; loc_33078:
Obj55_Main_Surface:
	jsr	Boss_MoveObject
	move.w	(Boss_X_pos).w,x_pos(a0)
	jsr	Obj55_HoverPos
	cmpi.w	#$290,(Boss_Y_pos).w	; has boss reached its target position?
	bhs.w	Obj55_Main_End		; if not, branch
	move.w	#$290,(Boss_Y_pos).w
	addq.b	#2,boss_routine(a0)	; => Obj55_Main_Wait
	move.w	#$A8,(Boss_Countdown).w
	btst	#7,Obj55_status(a0)	; was boss hit?
	bne.w	Obj55_Main_End		; if yes, branch
	lea	(Boss_AnimationArray).w,a2
	move.b	#$10,(a2)+
	move.b	#0,(a2)
	jmp	Obj55_Main_End
; ===========================================================================
; loc_330BA:
Obj55_Main_Wait:
	btst	#7,Obj55_status(a0)	; was boss hit?
	bne.s	+			; if yes, branch
	jsr	Obj55_HoverPos
	subi.w	#1,(Boss_Countdown).w	; hover in place for a while
	bpl.w	Obj55_Main_End
	lea	(Boss_AnimationArray).w,a2
	move.b	#5,(a2)+
	move.b	#0,(a2)
+
	addq.b	#2,boss_routine(a0)	; => Obj55_Main_Dive
	move.w	#-$40,(Boss_Y_vel).w	; bob up a little before diving
	jmp	Obj55_Main_End
; ===========================================================================
; does the hovering effect
; loc_330EA:
Obj55_HoverPos:
	move.b	boss_sine_count(a0),d0
	jsr	(CalcSine).l
	asr.w	#7,d1
	add.w	(Boss_Y_pos).w,d1
	move.w	d1,y_pos(a0)
	addq.b	#4,boss_sine_count(a0)
	rts
; ===========================================================================
; loc_33104:
Obj55_Main_Dive:
	jsr	Boss_MoveObject
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	btst	#6,Obj55_status(a0)	; is boss done rising?
	bne.s	Obj55_Main_Dive_Part2	; if yes, branch
	cmpi.w	#$28C,(Boss_Y_pos).w	; has boss reached initial destination (rising before diving)?
	bhs.w	Obj55_Main_End		; if not, branch
	move.w	#$28C,(Boss_Y_pos).w
	move.w	#$80,(Boss_Y_vel).w
	ori.b	#$40,Obj55_status(a0)	; set diving bit
	jmp	Obj55_Main_End
; ===========================================================================
; loc_3313C:
Obj55_Main_Dive_Part2:
	cmpi.w	#$2D0,(Boss_Y_pos).w	; has boss reached its target position?
	blo.s	Obj55_Main_End		; if yes, branch
	move.w	#$2D0,(Boss_Y_pos).w
	clr.b	boss_routine(a0)
	addq.b	#2,boss_subtype(a0)	; => Obj55_LaserShooter
	btst	#7,Obj55_status(a0)	; was boss hit?
	beq.s	Obj55_Main_End		; if not, branch
	addq.b	#2,boss_subtype(a0)	; => Obj55_SpikeChain

; loc_3315E:
Obj55_Main_End:
	jsr	Obj55_HandleHits
	lea	(Ani_obj55).l,a1
	jsr	AnimateBoss
	jsr	Obj55_AlignSprites
	jmpto	(DisplaySprite).l, JmpTo41_DisplaySprite
; ===========================================================================
; loc_33174:
Obj55_HandleHits:
	jsr	Boss_HandleHits
	cmpi.b	#$1F,boss_invulnerable_time(a0)
	bne.s	return_33192
	lea	(Boss_AnimationArray).w,a1
	andi.b	#$F0,(a1)
	ori.b	#3,(a1)
	ori.b	#$80,Obj55_status(a0)	; set boss hit bit
	subq.b  #1,OOZ_HitCount(a0)
	bne.s    return_33192        ; if hit count is 0 then mark destroyed
        jmp	Boss_Defeat
return_33192:
	rts
; ===========================================================================
; loc_33194:
Obj55_AlignSprites:
	move.w	x_pos(a0),d0
	move.w	y_pos(a0),d1
	move.w	d0,sub2_x_pos(a0)
	move.w	d1,sub2_y_pos(a0)
	rts
; ===========================================================================
; loc_331A6:
Obj55_Main_Defeated:
	clr.w	(Normal_palette_line2+2).w	; set color to black
	subq.w	#1,(Boss_Countdown).w		; wait for a while
	bmi.s	Obj55_Main_Defeated_Part2	; branch, if wait is over
	cmpi.w	#$1E,(Boss_Countdown).w		; has boss waited for a certain ammount of time?
	bhs.s	Obj55_Explode			; if not, branch
	move.b	#$B,mainspr_mapframe(a0)	; use defeated animation
	jmpto	(DisplaySprite).l, JmpTo41_DisplaySprite
; ===========================================================================
; loc_331C2:
Obj55_Explode:
	jsr	Boss_LoadExplosion
	jmpto	(DisplaySprite).l, JmpTo41_DisplaySprite
; ===========================================================================
; loc_331CA:
Obj55_Main_Defeated_Part2:
	tst.b	(Boss_defeated_flag).w	; has boss been defeated?
	bne.s	Obj55_ReleaseCamera	; if yes, branch
	jsrto	(PlayLevelMusic).l, JmpTo8_PlayLevelMusic
	jsrto	(LoadPLC_AnimalExplosion).l, JmpTo8_LoadPLC_AnimalExplosion
	move.b	#1,(Boss_defeated_flag).w

; loc_331DE:
Obj55_ReleaseCamera:
	cmpi.w	#$2A20,(Camera_Max_X_pos).w	; has camera reached its destination?
	bhs.s	Obj55_ChkDelete			; if yes, branch
	addq.w	#2,(Camera_Max_X_pos).w		; else, move camera some more
	bra.s	Obj55_Defeated_Sink
; ===========================================================================
; loc_331EC:
Obj55_ChkDelete:
	move.w	#$2A20,(Camera_Max_X_pos).w
	cmpi.w	#$2D0,y_pos(a0)			; has boss reached its target position?
	bhs.s	BranchTo_JmpTo62_DeleteObject	; if yes, branch

; loc_331FA:
Obj55_Defeated_Sink:
	addi.w	#1,y_pos(a0)
	bsr.s	Obj55_AlignSprites
	jmpto	(DisplaySprite).l, JmpTo41_DisplaySprite
; ===========================================================================
    if removeJmpTos
JmpTo62_DeleteObject ; JmpTo
    endif

BranchTo_JmpTo62_DeleteObject ; BranchTo
	jmpto	(DeleteObject).l, JmpTo62_DeleteObject
; ===========================================================================
; loc_3320A:
Obj55_LaserShooter:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj55_LaserShooter_Index(pc,d0.w),d1
	jmp	Obj55_LaserShooter_Index(pc,d1.w)
; ===========================================================================
; off_33218:
Obj55_LaserShooter_Index:	offsetTable
		offsetTableEntry.w Obj55_LaserShooter_Init		; 0 - laser shooter's initial state
		offsetTableEntry.w Obj55_LaserShooter_Rise		; 2 - moving up
		offsetTableEntry.w Obj55_LaserShooter_ChooseTarget	; 4 - stay in place for a while
		offsetTableEntry.w Obj55_LaserShooter_Aim		; 6 - move towards target and shoot
		offsetTableEntry.w Obj55_LaserShooter_Lower		; 8 - moving down
; ===========================================================================
; loc_33222:
Obj55_LaserShooter_Init:
	clr.w	(Normal_palette_line2+2).w	; reset palette flash
	move.w	#$2940,(Boss_X_pos).w
	bclr	#0,render_flags(a0)
	move.w	(MainCharacter+x_pos).w,d1
	cmpi.w	#$293A,d1		; is player left from center?
	blo.s	+			; if yes, branch
	bchg	#0,render_flags(a0)
+
	move.w	#$2B0,(Boss_Y_pos).w
	move.w	#$2B0,y_pos(a0)
	move.b	#2,routine(a0)	; => Obj55_LaserShooter_Rise
	move.b	#$8A,collision_flags(a0)
	move.b	#5,mainspr_mapframe(a0)
	moveq	#7,d0
	moveq	#7,d2
	moveq	#0,d4
	move.w	(Boss_Y_pos).w,d5

-	; initialize chain
	addi.w	#$F,d5
	move.b	d0,sub2_mapframe(a0,d4.w)
	move.w	d5,sub2_y_pos(a0,d4.w)
	addq.w	#next_subspr,d4
	dbf	d2,-

	move.b	#8,mainspr_childsprites(a0)
	move.w	#-$80,(Boss_Y_vel).w
	move.b	#0,Obj55_laser_pos(a0)
	move.b	#1,(Boss_CollisionRoutine).w
	rts
; ===========================================================================
; loc_33296:
Obj55_LaserShooter_Rise:
	jsr	Boss_MoveObject
	cmpi.w	#$240,(Boss_Y_pos).w	; has laser shooter reached its destination?
	bhs.w	Obj55_LaserShooter_End	; if not, branch
	move.w	#$240,(Boss_Y_pos).w
	move.w	#0,(Boss_Y_vel).w
	move.b	#4,routine(a0)	; => Obj55_LaserShooter_ChooseTarget
	move.w	#$80,(Boss_Countdown).w
	move.b	#3,Obj55_shot_count(a0)	; prepare to shoot 3 lasers
	jmp	Obj55_LaserShooter_End
; ===========================================================================
; loc_332C6:
Obj55_LaserShooter_ChooseTarget:
	subq.b	#1,Obj55_anim_frame_duration(a0)	; is firing animation finished?
	bne.s	+					; if not, branch
	move.b	#5,mainspr_mapframe(a0)	; reset animation frame to not firing
+
	subi.w	#1,(Boss_Countdown).w	; wait for a while
	bne.w	Obj55_LaserShooter_End	; branch, as long as wait isn't over
	subi.b	#1,Obj55_shot_count(a0)		; decrement number of shots left
	bmi.s	Obj55_LaserShooter_DoneShooting	; branch, if no shots left
	jsrto	(RandomNumber).l, JmpTo5_RandomNumber

-	; find first valid firing position
	addq.b	#1,d0			; next position
	andi.w	#3,d0			; limit to 4 possible values
	btst	d0,Obj55_laser_pos(a0)	; was a laser already shot in this position?
	bne.s	-			; if yes, branch

	bset	d0,Obj55_laser_pos(a0)	; set posion as used
	add.w	d0,d0
	move.w	Obj55_LaserTargets(pc,d0.w),(Boss_Countdown).w	; set target positon
	move.b	#6,routine(a0)	; => Obj55_LaserShooter_Aim
	jsr	Obj55_MoveTowardTarget
	jmp	Obj55_LaserShooter_End
; ===========================================================================
; loc_3330C:
Obj55_LaserShooter_DoneShooting:
	move.w	#$80,(Boss_Y_vel).w
	move.b	#8,routine(a0)	; => Obj55_LaserShooter_Lower
	jmp	Obj55_LaserShooter_End
; ===========================================================================
; word_3331C:
Obj55_LaserTargets:
	dc.w  $238	; 0
	dc.w  $230	; 2
	dc.w  $240	; 4
	dc.w  $25F	; 6
; ===========================================================================
; loc_33324:
Obj55_LaserShooter_Aim:
	jsr	Boss_MoveObject
	move.w	(Boss_Countdown).w,d0
	tst.w	(Boss_Y_vel).w			; is laser shooter moving up?
	bmi.s	Obj55_LaserShooter_Aim_MovingUp	; if yes, branch
	cmp.w	(Boss_Y_pos).w,d0	; has laser shooter reached its destination?
	blo.s	Obj55_LaserShooter_Fire	; if yes, branch
	jmp	Obj55_LaserShooter_End
; ===========================================================================
; loc_3333C:
Obj55_LaserShooter_Aim_MovingUp:
	cmp.w	(Boss_Y_pos).w,d0	; has laser shooter reached its destination?
	blo.w	Obj55_LaserShooter_End	; if not, branch

; loc_33342:
Obj55_LaserShooter_Fire:
	move.w	#0,(Boss_Y_vel).w
	move.b	#8,Obj55_anim_frame_duration(a0)
	move.b	#6,mainspr_mapframe(a0)	; use firing frame
	jsrto	(SingleObjLoad).l, JmpTo18_SingleObjLoad
	bne.w	Obj55_LaserShooter_End
	move.l	#Obj55,(a1)  ; load obj55
	move.b	#8,boss_subtype(a1)	; => Obj55_Laser
	move.w	a0,Obj55_Wave_parent(a1)
	move.b	#SndID_LaserBurst,d0
	jsrto	(PlaySound).l, JmpTo11_PlaySound
	move.b	#4,routine(a0)	; => Obj55_LaserShooter_ChooseTarget
	move.w	#$28,(Boss_Countdown).w
	move.w	#-$80,(Boss_Y_vel).w
	jmp	Obj55_LaserShooter_End
; ===========================================================================
; loc_33388:
Obj55_LaserShooter_Lower:
	subq.b	#1,Obj55_anim_frame_duration(a0)	; is firing animation finished?
	bne.s	+					; if not, branch
	move.b	#5,mainspr_mapframe(a0)	; reset animation frame to not firing
+
	jsr	Boss_MoveObject
	cmpi.w	#$2B0,(Boss_Y_pos).w	; has laser shooter reached its destination?
	blo.w	Obj55_LaserShooter_End	; if not, branch
	move.w	#$2B0,(Boss_Y_pos).w
	move.w	#0,(Boss_Y_vel).w
	move.b	#0,routine(a0)     ;reset its things
	move.b	#0,boss_routine(a0)  ; reset the boss
	move.b	#2,boss_subtype(a0)	; => Obj55_Main_Init
	rts
; ===========================================================================
; loc_333BA:
Obj55_LaserShooter_End:
	jsr	Obj55_LaserShooter_FacePlayer
	jsr	Obj55_LaserShooter_Wind
	jmpto	(DisplaySprite).l, JmpTo41_DisplaySprite
; ===========================================================================
; sets the laser shooter's y velocity so that it moves toward its target
; loc_333C6:
Obj55_MoveTowardTarget:
	move.w	(Boss_Countdown).w,d0
	sub.w	(Boss_Y_pos).w,d0
	bpl.s	Obj55_LaserShooter_MoveUp	; branch, if laser shooter is below target
	move.w	#-$80,(Boss_Y_vel).w
	rts
; ===========================================================================
; loc_333D8:
Obj55_LaserShooter_MoveUp:
	move.w	#$80,(Boss_Y_vel).w
	rts
; ===========================================================================
; loc_333E0:
Obj55_LaserShooter_FacePlayer:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	blt.s	Obj55_LaserShooter_FaceLeft	; branch, if player is to the left
	subi.w	#8,d0		; allow an 8 pixel margin
	blt.s	return_333F6
	bset	#0,render_flags(a0)

return_333F6:
	rts
; ===========================================================================
; loc_333F8:
Obj55_LaserShooter_FaceLeft:
	addi.w	#8,d0		; allow an 8 pixel margin
	bgt.s	return_333F6
	bclr	#0,render_flags(a0)
	rts
; ===========================================================================
; creates the twisting effect
; loc_33406:
Obj55_LaserShooter_Wind:
	move.w	(Boss_X_pos).w,d5
	move.w	(Boss_Y_pos).w,d6
	move.b	boss_sine_count(a0),d3
	move.b	d3,d0
	jsr	Obj55_LaserShooter_CalcSineRelative
	move.w	d1,x_pos(a0)
	move.w	d0,y_pos(a0)
	addi.b	#2,boss_sine_count(a0)
	moveq	#7,d2
	moveq	#0,d4

-	addi.w	#$F,d6
	subi.b	#$10,d3
	jsr	Obj55_LaserShooter_CalcSineRelative
	move.w	d1,sub2_x_pos(a0,d4.w)
	move.w	d0,sub2_y_pos(a0,d4.w)
	addq.w	#next_subspr,d4
	dbf	d2,-
	rts
; ===========================================================================
; loc_33446:
Obj55_LaserShooter_CalcSineRelative:
	move.b	d3,d0
	jsrto	(CalcSine).l, JmpTo13_CalcSine
	asr.w	#4,d1
	add.w	d5,d1
	asr.w	#6,d0
	add.w	d6,d0
	rts
; ===========================================================================
; loc_33456:

Obj55_SpikeChain:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj55_SpikeChain_Index(pc,d0.w),d1
	jmp	Obj55_SpikeChain_Index(pc,d1.w)
; ===========================================================================
; off_33464:
Obj55_SpikeChain_Index:	offsetTable
		offsetTableEntry.w Obj55_SpikeChain_Init	; 0 - spiked chain's initial state
		offsetTableEntry.w Obj55_SpikeChain_Main	; 2 - spiked chain moving at an arc
; ===========================================================================
; loc_33468:
Obj55_SpikeChain_Init:
	clr.w	(Normal_palette_line2+2).w	; reset palette flash
	move.w	#$28C0,(Boss_X_pos).w
	bclr	#0,render_flags(a0)
	move.w	(MainCharacter+x_pos).w,d1
	cmpi.w	#$293A,d1	; is player on the left side of the arena?
	blo.s	+		; if yes, branch
	move.w	#$29C0,(Boss_X_pos).w
	bset	#0,render_flags(a0)
+
	move.w	#$2A0,(Boss_Y_pos).w
	move.b	#2,mainspr_mapframe(a0)
	move.b	#$8A,collision_flags(a0)
	addq.b	#2,routine(a0)	; => Obj55_SpikeChain_Main
	move.b	#$80,mainspr_width(a0)
	clr.b	boss_sine_count(a0)
	moveq	#7,d0
	moveq	#7,d1
	moveq	#0,d2

-	move.b	d1,sub2_mapframe(a0,d2.w)
	addq.w	#next_subspr,d2
	dbf	d0,-

	move.b	#8,mainspr_childsprites(a0)
	move.b	#2,(Boss_CollisionRoutine).w
	rts
; ===========================================================================
; loc_334CC:
Obj55_SpikeChain_Main:
	jsr	Obj55_SpikeChain_Move
	cmpi.b	#$FE,boss_sine_count(a0)	; has chain reached a certain angle?
	blo.s	Obj55_SpikeChain_End		; if not, branch
	move.b	#0,routine(a0)
	move.b	#4,boss_subtype(a0)	; => Obj55_LaserShooter_Init
	rts
; ===========================================================================
; loc_334E6:
Obj55_SpikeChain_End:
	jsr	Obj55_SpikeChain_SetAnimFrame
	jmpto	(DisplaySprite).l, JmpTo41_DisplaySprite
; ===========================================================================
; loc_334EE:
Obj55_SpikeChain_Move:
	move.b	boss_sine_count(a0),d0
	addi.b	#$40,d0
	move.b	d0,d3
	jsr	Obj55_SpikeChain_Rotate
	move.w	d1,x_pos(a0)
	move.w	d0,y_pos(a0)
	addi.b	#1,boss_sine_count(a0)
	moveq	#7,d2
	moveq	#0,d4

-	subi.b	#6,d3
	jsr	Obj55_SpikeChain_Rotate
	move.w	d1,sub2_x_pos(a0,d4.w)
	move.w	d0,sub2_y_pos(a0,d4.w)
	addq.w	#next_subspr,d4
	dbf	d2,-
	rts
; ===========================================================================
; loc_33526:
Obj55_SpikeChain_Rotate:
	move.b	d3,d0
	jsrto	(CalcSine).l, JmpTo13_CalcSine
	muls.w	#$68,d1
	asr.l	#8,d1
	btst	#0,render_flags(a0)
	bne.s	+
	neg.w	d1
+
	add.w	(Boss_X_pos).w,d1
	muls.w	#$68,d0
	asr.l	#8,d0
	add.w	(Boss_Y_pos).w,d0
	rts
; ===========================================================================
; loc_3354C:
Obj55_SpikeChain_SetAnimFrame:
	move.b	boss_sine_count(a0),d0
	moveq	#$15,d1
	cmpi.b	#$52,d0
	blo.s	+
	moveq	#3,d1
	cmpi.b	#$6B,d0
	blo.s	+
	moveq	#2,d1
	cmpi.b	#-$6E,d0
	blo.s	+
	moveq	#4,d1
+
	move.b	d1,mainspr_mapframe(a0)
	rts
; ===========================================================================
; loc_33570:
Obj55_Laser:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj55_Laser_Index(pc,d0.w),d0
	jmp	Obj55_Laser_Index(pc,d0.w)
; ===========================================================================
; off_3357E:
Obj55_Laser_Index:	offsetTable
		offsetTableEntry.w Obj55_Laser_Init			; 0 - Init
		offsetTableEntry.w Obj55_Laser_Main			; 2 - Laser moving horizontally
		offsetTableEntry.w Obj55_Wave				; 4 - Energy wave that moves along the ground
		offsetTableEntry.w BranchTo2_JmpTo62_DeleteObject	; 6 - Delete (triggered by an animation)
; ===========================================================================
; loc_33586:
Obj55_Laser_Init:
	addq.b	#2,routine_secondary(a0)	; => Obj55_Laser_Main
	move.l	#Obj55_MapUnc_33756,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#4,priority(a0)
	movea.w	Obj55_Wave_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	#$C,mapping_frame(a0)
	move.w	#-$20,d0
	move.w	#-$400,x_vel(a0)
	btst	#0,render_flags(a1)
	beq.s	+
	neg.w	d0
	neg.w	x_vel(a0)
+
	add.w	d0,x_pos(a0)
	move.b	#$AF,collision_flags(a0)
	rts
; ===========================================================================
; loc_335DE:
Obj55_Laser_Main:
	jsr	Obj55_Laser_ChkGround
	jsrto	(ObjectMove).l, JmpTo25_ObjectMove
	cmpi.w	#$2870,x_pos(a0)	; has laser moved off screen going left?
	blo.w	JmpTo62_DeleteObject	; if yes, branch
	cmpi.w	#$2A10,x_pos(a0)	; has laser moved off screen going right?
	bhs.w	JmpTo62_DeleteObject	; if yes, branch
	jmpto	(DisplaySprite).l, JmpTo41_DisplaySprite
; ===========================================================================
; checks if laser hit the ground
; loc_335FE:
Obj55_Laser_ChkGround:
	cmpi.w	#$250,y_pos(a0)		; is laser on ground level?
	blo.s	return_33626		; if not, branch
	tst.w	x_vel(a0)			; is laser moving left?
	bmi.w	Obj55_Laser_ChkGroundLeft	; if yes, branch
	move.w	x_pos(a0),d0
	cmpi.w	#$2980,d0
	bhs.s	return_33626
	cmpi.w	#$297C,d0
	blo.w	return_33626
	move.w	#$2988,d1		; wave's start position
	bra.s	Obj55_Laser_CreateWave
; ===========================================================================

return_33626:
	rts
; ===========================================================================
; loc_33628:
Obj55_Laser_ChkGroundLeft:
	move.w	x_pos(a0),d0
	cmpi.w	#$2900,d0
	blo.s	return_3363E
	cmpi.w	#$2904,d0
	bhs.s	return_3363E
	move.w	#$28F8,d1		; wave's start position
	bra.s	Obj55_Laser_CreateWave
; ===========================================================================

return_3363E:
	rts
; ===========================================================================
; loc_33640:
Obj55_Laser_CreateWave:
	jsrto	(SingleObjLoad).l, JmpTo18_SingleObjLoad
	bne.s	return_336B0
	move.l	#Obj55,(a1)  ; load obj55
	move.b	#8,boss_subtype(a1)
	move.b	#4,routine_secondary(a1)	; => Obj55_Wave
	move.b	#$8B,collision_flags(a1)
	move.b	#2,anim(a1)
	move.b	#$D,mapping_frame(a1)
	move.w	#0,y_vel(a1)
	move.l	#Obj55_MapUnc_33756,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZBoss,0,0),art_tile(a1)
	jsrto	(Adjust2PArtPointer).l, JmpTo63_Adjust2PArtPointer
	ori.b	#4,render_flags(a1)
	move.b	#2,priority(a1)
	move.w	#5,Obj55_Wave_delay(a1)
	move.b	#7,Obj55_Wave_count(a1)
	move.w	x_vel(a0),x_vel(a1)
	move.w	d1,x_pos(a1)
	move.w	#$250,y_pos(a1)
	move.b	#SndID_LaserFloor,d0
	jsrto	(PlaySound).l, JmpTo11_PlaySound

return_336B0:
	rts
; ===========================================================================
; loc_336B2:
Obj55_Wave:
	subq.w	#1,Obj55_Wave_delay(a0)
	bpl.s	Obj55_Wave_End
	move.w	#$C7,Obj55_Wave_delay(a0)
	subq.b	#1,Obj55_Wave_count(a0)
	bmi.s	Obj55_Wave_End
	jsrto	(SingleObjLoad2).l, JmpTo24_SingleObjLoad2
	bne.s	Obj55_Wave_End
	moveq	#0,d0

	move.w	#bytesToLcnt(object_size),d1

-	move.l	(a0,d0.w),(a1,d0.w)	; make new object a copy of this one
	addq.w	#4,d0
	dbf	d1,-
    if object_size&3
	move.w	(a0,d0.w),(a1,d0.w)	; make new object a copy of this one
    endif

	move.w	#5,Obj55_Wave_delay(a1)
	move.w	#$200,anim(a1)
	move.w	#$10,d0		; place new wave object 16 pixels next to current one
	tst.w	x_vel(a1)	; is object going left?
	bpl.s	+		; if not, branch
	neg.w	d0		; flip offset
+
	add.w	d0,x_pos(a1)	; set position
	move.b	#SndID_LaserFloor,d0
	jsrto	(PlaySound).l, JmpTo11_PlaySound

Obj55_Wave_End:
	lea	(Ani_obj55).l,a1
	jsrto	(AnimateSprite).l, JmpTo22_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo38_MarkObjGone
; ===========================================================================

BranchTo2_JmpTo62_DeleteObject
	jmp	JmpTo62_DeleteObject
; ===========================================================================
; animation script
; off_33712:
Ani_obj55:	offsetTable
		offsetTableEntry.w byte_3371E
		offsetTableEntry.w byte_33738
		offsetTableEntry.w byte_3373B
		offsetTableEntry.w byte_3374D
		offsetTableEntry.w byte_33750
		offsetTableEntry.w byte_33753
byte_3371E:
	dc.b   9,  8,  8,  8,  8,  9,  9,  9,  9,  8,  8,  8,  8,  9,  9,  9
	dc.b   9,  8,  8,  8,  8,  9,  9,  9,  9,$FF; 16
	rev02even
byte_33738:
	dc.b  $F,  1,$FF
	rev02even
byte_3373B:
	dc.b   1, $D,$11, $E,$12, $F,$13,$10,$14,$14,$10,$13, $F,$12, $E,$11
	dc.b  $D,$FA	; 16
	rev02even
byte_3374D:
	dc.b  $F, $A,$FF
	rev02even
byte_33750:
	dc.b  $F, $B,$FF
	rev02even
byte_33753:
	dc.b  $F,  8,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj55_MapUnc_33756:	BINCLUDE "mappings/sprite/obj55.bin"
; ===========================================================================
                    even
    if ~~removeJmpTos
JmpTo41_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo62_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo18_SingleObjLoad ; JmpTo
	jmp	(SingleObjLoad).l
JmpTo38_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo11_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo24_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo22_AnimateSprite ; JmpTo
	jmp	(AnimateSprite).l
JmpTo5_RandomNumber ; JmpTo
	jmp	(RandomNumber).l
JmpTo63_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo13_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo8_PlayLevelMusic ; JmpTo
	jmp	(PlayLevelMusic).l
JmpTo8_LoadPLC_AnimalExplosion ; JmpTo
	jmp	(LoadPLC_AnimalExplosion).l
; loc_338E4:
JmpTo25_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
