

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 5D - CPZ boss
; ----------------------------------------------------------------------------
; OST Variables:
Obj5D_timer2		= objoff_2E
Obj5D_pipe_segments	= $12 ;objoff_30   ; 2 bytes
Obj5D_status		= $45 ;objoff_31
Obj5D_status2		= $46 ;objoff_32
Obj5D_x_vel		= $46     ;objoff_32	; and $2F
Obj5D_x_pos_next	= $40 ;objoff_34
Obj5D_timer		= $40 ;objoff_34
SecondaryRoutineCpzBoss = $30 ; 1 byte
Obj5D_y_offset		= $31 ;objoff_35
Obj5D_timer3		= $32 ;;objoff_36
Obj5D_parent		= $34 ;objoff_38
Obj5D_y_pos_next	= $38 ;objoff_3C
Obj5D_defeat_timer	= $3C ;objoff_40
Obj5D_flag		= $3C ;objoff_40
Obj5D_timer4		= $3C ;objoff_40
Obj5D_invulnerable_time	= $3E ;objoff_42
Obj5D_hover_counter	= $3F ;objoff_43

; Sprite_2D734:
Obj5D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj5D_Index(pc,d0.w),d1
	jmp	Obj5D_Index(pc,d1.w)
; ===========================================================================
; off_2D742:
Obj5D_Index:	offsetTable
		offsetTableEntry.w Obj5D_Init		;   0
		offsetTableEntry.w Obj5D_Main		;   2
		offsetTableEntry.w Obj5D_Pipe		;   4
		offsetTableEntry.w Obj5D_Pipe_Pump	;   6
		offsetTableEntry.w Obj5D_Pipe_Retract	;   8
		offsetTableEntry.w Obj5D_Dripper	;  $A
		offsetTableEntry.w Obj5D_Gunk		;  $C
		offsetTableEntry.w Obj5D_PipeSegment	;  $E
		offsetTableEntry.w Obj5D_Container	; $10
		offsetTableEntry.w Obj5D_Pump		; $12
		offsetTableEntry.w Obj5D_FallingParts	; $14
		offsetTableEntry.w Obj5D_Robotnik	; $16
		offsetTableEntry.w Obj5D_Flame		; $18
		offsetTableEntry.w Obj5D_1A		; $1A
; ===========================================================================
; loc_2D75E:
Obj5D_Init:
	; main vehicle
	move.l	#Obj5D_MapUnc_2ED8C,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Eggpod_3,1,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.w	#$2B80,x_pos(a0)
	move.w	#$4B0,y_pos(a0)
	move.b	#3,priority(a0)
	move.b	#$F,collision_flags(a0)
	move.b	#8,collision_property(a0)
	addq.b	#2,routine(a0)	; => Obj5D_Main
	move.w	x_pos(a0),Obj5D_x_pos_next(a0)
	move.w	y_pos(a0),Obj5D_y_pos_next(a0)
	bclr	#3,Obj5D_status(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo60_Adjust2PArtPointer

	; robotnik sitting in his eggmobile
	jsr	(SingleObjLoad2).l
	bne.w	loc_2D8AC
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	a1,Obj5D_parent(a0)
	move.l	#Obj5D_MapUnc_2ED8C,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Eggpod_3,0,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#3,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$16,routine(a1)	; => Obj5D_Robotnik
	move.b	#1,anim(a1)
	move.b	render_flags(a0),render_flags(a1)
	jsrto	(Adjust2PArtPointer2).l, JmpTo8_Adjust2PArtPointer2
	tst.b	subtype(a0)
	bmi.w	loc_2D8AC

	; eggmobile's exhaust flame
	jsr	(SingleObjLoad2).l
	bne.w	loc_2D8AC
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EE88,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_EggpodJets_1,0,0),art_tile(a1)
	jsrto	(Adjust2PArtPointer2).l, JmpTo8_Adjust2PArtPointer2
	move.b	#1,anim_frame_duration(a0)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#3,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$18,routine(a1)	; => Obj5D_Flame
	move.b	render_flags(a0),render_flags(a1)

	; large pump mechanism on top of eggmobile
	jsr	(SingleObjLoad2).l
	bne.s	loc_2D8AC
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$12,routine(a1)	; => Obj5D_Pump

loc_2D8AC:
	; glass container that dumps mega mack on player
	jsr	(SingleObjLoad2).l
	bne.s	loc_2D908
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	subi.w	#$38,y_pos(a1)
	subi.w	#$10,x_pos(a1)
	move.w	#-$10,Obj5D_x_vel(a1)
	addi.b	#$10,routine(a1)	; => Obj5D_Container
	move.b	#6,anim(a1)

loc_2D908:
	; pipe used to suck mega mack from tube below
	jsr	(SingleObjLoad2).l
	bne.s	return_2D94C
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)		; => Obj5D_Pipe

return_2D94C:
	rts
; ===========================================================================

Obj5D_Main:
	jsr	Obj5D_LookAtChar
	moveq	#0,d0
	move.b	SecondaryRoutineCpzBoss(a0),d0
	move.w	Obj5D_Main_Index(pc,d0.w),d1
	jsr	Obj5D_Main_Index(pc,d1.w)
	lea	(Ani_obj5D_b).l,a1
	jsr	(AnimateSprite).l
	move.b	status(a0),d0
	andi.b	#3,d0
	andi.b	#$FC,render_flags(a0)
	or.b	d0,render_flags(a0)
	jmp	(DisplaySprite).l
; ===========================================================================
Obj5D_Main_Index:	offsetTable
		offsetTableEntry.w Obj5D_Main_0	;  0
		offsetTableEntry.w Obj5D_Main_2	;  2
		offsetTableEntry.w Obj5D_Main_4	;  4
		offsetTableEntry.w Obj5D_Main_6	;  6
		offsetTableEntry.w Obj5D_Main_8	;  8
		offsetTableEntry.w Obj5D_Main_A	; $A
		offsetTableEntry.w Obj5D_Main_C	; $C
; ===========================================================================
; Makes the boss look in Sonic's direction under certain circumstances.

Obj5D_LookAtChar:
	cmpi.b	#8,SecondaryRoutineCpzBoss(a0)
	bge.s	+
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bgt.s	++
	bclr	#0,status(a0)
+
	rts
; ---------------------------------------------------------------------------
+
	bset	#0,status(a0)
	rts
; ===========================================================================

Obj5D_Main_8:
	subq.w	#1,Obj5D_defeat_timer(a0)
	bpl.w	Obj5D_Main_Explode
	bset	#0,status(a0)
	bclr	#7,status(a0)
	clr.w	x_vel(a0)
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Main_A
	move.w	#-$26,Obj5D_defeat_timer(a0)
	rts
; ===========================================================================

Obj5D_Main_A:
	addq.w	#1,Obj5D_defeat_timer(a0)
	beq.s	+
	bpl.s	++
	addi.w	#$18,y_vel(a0)
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	clr.w	y_vel(a0)
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	cmpi.w	#$30,Obj5D_defeat_timer(a0)
	blo.s	+
	beq.s	++
	cmpi.w	#$38,Obj5D_defeat_timer(a0)
	blo.s	Obj5D_Main_A_End
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Main_C
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	subi.w	#8,y_vel(a0)
	bra.s	Obj5D_Main_A_End
; ---------------------------------------------------------------------------
+
	clr.w	y_vel(a0)
	jsrto	(PlayLevelMusic).l, JmpTo_PlayLevelMusic
	jsrto	(LoadPLC_AnimalExplosion).l, JmpTo_LoadPLC_AnimalExplosion

Obj5D_Main_A_End:
	jsr	Obj5D_Main_Move
	jmp	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_Main_C:
	bset	#6,Obj5D_status2(a0)
	move.w	#$400,x_vel(a0)
	move.w	#-$40,y_vel(a0)
	cmpi.w	#$2C30,(Camera_Max_X_pos).w
	bhs.s	+
	addq.w	#2,(Camera_Max_X_pos).w
	bra.s	Obj5D_Main_C_End
; ===========================================================================
+
	tst.b	render_flags(a0)
	bpl.s	Obj5D_Main_Delete

Obj5D_Main_C_End:
	jsr	Obj5D_Main_Move
	jmp	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_Main_Delete:
	addq.l	#4,sp
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	jsr	(DeleteObject2).l

    if removeJmpTos
JmpTo51_DeleteObject ; JmpTo
    endif

	jmp	(DeleteObject).l
; ===========================================================================

Obj5D_Main_0:
	move.w	#$100,y_vel(a0)
	jsr	Obj5D_Main_Move
	cmpi.w	#$4C0,Obj5D_y_pos_next(a0)
	bne.s	Obj5D_Main_Pos_and_Collision
	move.w	#0,y_vel(a0)
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Main_2

Obj5D_Main_Pos_and_Collision:
	; do hovering motion using sine wave
	move.b	Obj5D_hover_counter(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	Obj5D_y_pos_next(a0),d0		; get y position for next frame, add sine value
	move.w	d0,y_pos(a0)			; set y and x positions
	move.w	Obj5D_x_pos_next(a0),x_pos(a0)
	addq.b	#2,Obj5D_hover_counter(a0)

	cmpi.b	#8,SecondaryRoutineCpzBoss(a0)	; exploding or retreating?
	bhs.s	return_2DAE8			; if yes, branch
	tst.b	status(a0)
	bmi.s	Obj5D_Defeated		; branch, if boss is defeated
	tst.b	collision_flags(a0)
	bne.s	return_2DAE8		; branch, if collisions are not turned off

	; if collisions are turned off, it means the boss was hit
	tst.b	Obj5D_invulnerable_time(a0)
	bne.s	+			; branch, if still invulnerable
	move.b	#$20,Obj5D_invulnerable_time(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l
+
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0		; color black
	tst.w	(a1)	; test palette entry
	bne.s	+	; branch, if it's not black
	move.w	#$EEE,d0	; color white
+
	move.w	d0,(a1)		; set color for flashing effect
	subq.b	#1,Obj5D_invulnerable_time(a0)
	bne.s	return_2DAE8
	move.b	#$F,collision_flags(a0)	; restore collisions
	bclr	#1,Obj5D_status(a0)

return_2DAE8:
	rts
; ===========================================================================
; called when status bit 7 is set (check Touch_Enemy_Part2)

Obj5D_Defeated:
	moveq	#100,d0
	jsrto	(AddPoints).l, JmpTo2_AddPoints
	move.b	#8,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Main_8
	move.w	#$B3,Obj5D_defeat_timer(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.b	#4,anim(a1)
	moveq	#PLCID_Capsule,d0
	jmpto	(LoadPLC).l, JmpTo5_LoadPLC
; ===========================================================================
	rts
; ===========================================================================

Obj5D_Main_Move:
	move.l	Obj5D_x_pos_next(a0),d2
	move.l	Obj5D_y_pos_next(a0),d3
	move.w	x_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d2
	move.w	y_vel(a0),d0
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d2,Obj5D_x_pos_next(a0)
	move.l	d3,Obj5D_y_pos_next(a0)
	rts
; ===========================================================================
; Creates an explosion every 8 frames at a random position relative to boss.

Obj5D_Main_Explode:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	+	; rts
	jsr	(SingleObjLoad).l
	bne.s	+	; rts
	move.l	#Obj58,(a1) ; load obj58
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	move.w	d0,d1
	moveq	#0,d1
	move.b	d0,d1
	lsr.b	#2,d1
	subi.w	#$20,d1
	add.w	d1,x_pos(a1)
	lsr.w	#8,d0
	lsr.b	#2,d0
	subi.w	#$20,d0
	add.w	d0,y_pos(a1)
+
	rts
; ===========================================================================
; Creates an explosion.

Obj5D_Main_Explode2:
	jsr	(SingleObjLoad).l
	bne.s	+	; rts
	move.l	#Obj58,(a1) ; load obj58
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================

Obj5D_Main_2:
	btst	#3,Obj5D_status(a0)	; is boss on the left side of the arena?
	bne.s	+			; if yes, branch
	move.w	#$2B30,d0	; right side of arena
	bra.s	++
; ---------------------------------------------------------------------------
+
	move.w	#$2A50,d0	; left side of arena
+
	move.w	d0,d1
	sub.w	Obj5D_x_pos_next(a0),d0
	bpl.s	+
	neg.w	d0	; get absolute value
+
	cmpi.w	#3,d0
	ble.s	Obj5D_Main_2_Stop	; branch, if boss is within 3 pixels to his target
	cmp.w	Obj5D_x_pos_next(a0),d1
	bgt.s	Obj5D_Main_2_MoveRight

;Obj5D_Main_2_MoveLeft:
	move.w	#-$300,x_vel(a0)
	bra.s	Obj5D_Main_2_End
; ---------------------------------------------------------------------------

Obj5D_Main_2_MoveRight:
	move.w	#$300,x_vel(a0)

Obj5D_Main_2_End:
	jsr	Obj5D_Main_Move
	jmp	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_Main_2_Stop:
	cmpi.w	#$4C0,Obj5D_y_pos_next(a0)
	bne.w	Obj5D_Main_Pos_and_Collision
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Main_4
	bchg	#3,Obj5D_status(a0)	; indicate boss is now at the other side
	bset	#0,Obj5D_status2(a0)	; action 0
	jmp	Obj5D_Main_Pos_and_Collision
; ===========================================================================
; when status2 bit 0 set, wait for something

Obj5D_Main_4:
	btst	#0,Obj5D_status2(a0)	; action 0?
	beq.s	+			; if not, branch
	jmp	Obj5D_Main_Pos_and_Collision
; ---------------------------------------------------------------------------
+
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Main_6
	jmp	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_Main_6:
	move.w	(MainCharacter+x_pos).w,d0
	addi.w	#$4C,d0
	cmp.w	Obj5D_x_pos_next(a0),d0
	bgt.s	Obj5D_Main_6_MoveRight
	beq.w	Obj5D_Main_Pos_and_Collision

;Obj5D_Main_6_MoveLeft:
	subi.l	#$10000,Obj5D_x_pos_next(a0)	; move left one pixel
	; stop at left boundary
	cmpi.w	#$2A28,Obj5D_x_pos_next(a0)
	bgt.w	Obj5D_Main_Pos_and_Collision
	move.w	#$2A28,Obj5D_x_pos_next(a0)
	jmp	Obj5D_Main_Pos_and_Collision
; ---------------------------------------------------------------------------

Obj5D_Main_6_MoveRight:
	addi.l	#$10000,Obj5D_x_pos_next(a0)	; move right one pixel
	; stop at right boundary
	cmpi.w	#$2B70,Obj5D_x_pos_next(a0)
	blt.w	Obj5D_Main_Pos_and_Collision
	move.w	#$2B70,Obj5D_x_pos_next(a0)
	jmp	Obj5D_Main_Pos_and_Collision
; ===========================================================================

Obj5D_FallingParts:
	cmpi.b	#-7,Obj5D_timer(a0)
	beq.s	+
	subi.b	#1,Obj5D_timer(a0)
	bgt.w	JmpTo34_DisplaySprite
	jsr	Obj5D_Main_Explode2
	move.b	#-7,Obj5D_timer(a0)
	move.w	#$1E,Obj5D_timer2(a0)
+
	subq.w	#1,Obj5D_timer2(a0)
	bpl.w	JmpTo34_DisplaySprite
	move.w	x_vel(a0),d0
	add.w	d0,x_pos(a0)
	move.l	y_pos(a0),d3
	move.w	y_vel(a0),d0
	addi.w	#$38,y_vel(a0)
	ext.l	d0
	asl.l	#8,d0
	add.l	d0,d3
	move.l	d3,y_pos(a0)
	cmpi.l	#$5800000,d3
	bhs.w	JmpTo51_DeleteObject
	jmpto	(MarkObjGone).l, JmpTo35_MarkObjGone
; ===========================================================================

Obj5D_Pump:
	btst	#7,status(a0)
	bne.s	+
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.b	status(a1),status(a0)
	movea.l	#Ani_Obj5D_Dripper,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ---------------------------------------------------------------------------
+
	moveq	#$22,d3
	move.b	#$78,Obj5D_timer(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	d3,mapping_frame(a0)
	move.b	#$14,routine(a0)	; => Obj5D_FallingParts
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a0)
	move.w	#-$380,y_vel(a0)
	moveq	#1,d2
	addq.w	#1,d3

-
	jsr	(SingleObjLoad).l
	bne.w	JmpTo51_DeleteObject
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.b	d3,mapping_frame(a1)
	move.b	#$14,routine(a1)	; => Obj5D_FallingParts
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	status(a0),status(a1)
	move.b	render_flags(a0),render_flags(a1)
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a1)
	move.w	#-$380,y_vel(a1)
	swap	d0
	addi.b	#$1E,d0
	andi.w	#$7F,d0
	move.b	d0,Obj5D_timer(a1)
	addq.w	#1,d3
	dbf	d2,-
	rts
; ===========================================================================
; Object to control the pipe's actions before pumping starts.

Obj5D_Pipe:
	moveq	#0,d0
	move.b	SecondaryRoutineCpzBoss(a0),d0
	move.w	Obj5D_Pipe_Index(pc,d0.w),d1
	jmp	Obj5D_Pipe_Index(pc,d1.w)
; ===========================================================================
Obj5D_Pipe_Index:	offsetTable
		offsetTableEntry.w Obj5D_Pipe_0	; 0
		offsetTableEntry.w Obj5D_Pipe_2_Load	; 2
; ===========================================================================
; wait for main vehicle's action 0

Obj5D_Pipe_0:
	movea.l	Obj5D_parent(a0),a1	; parent = main vehicle ; a1=object
	btst	#0,Obj5D_status2(a1)	; parent's action 0?
	bne.s	+			; if yes, branch
	; else, do nothing
	rts
; ---------------------------------------------------------------------------
+
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi.w	#$18,y_pos(a0)
	move.w	#$C,Obj5D_pipe_segments(a0)
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Pipe_2_Load
	movea.l	a0,a1
	bra.s	Obj5D_Pipe_2_Load_Part2		; skip initial loading setup
; ===========================================================================
; load pipe segments, first object controls rest of pipe
; objects not loaded in a loop => one segment loaded per frame
; pipe extends gradually

Obj5D_Pipe_2_Load:
	jsr	(SingleObjLoad2).l
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	move.l	a0,Obj5D_parent(a1)

Obj5D_Pipe_2_Load_Part2:
	subq.w  #1,Obj5D_pipe_segments(a0)	; is pipe fully extended?
	blt.s   Obj5D_Pipe_2_Load_End		; if yes, branch

	move.l	#Obj5D,(a1)	; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#5,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)

	; calculate y position for current pipe segment
	move.w	Obj5D_pipe_segments(a0),d0
	subi.w	#$B,d0	; $B = maximum number of pipe segments -1, result is always negative or zero
	neg.w	d0	; positive value needed
	lsl.w	#3,d0	; multiply with 8
	move.w	d0,Obj5D_y_pos_next(a1)
	add.w	d0,y_pos(a1)
	move.b	#1,anim(a1)
	cmpi.b	#2,SecondaryRoutineCpzBoss(a1)
	beq.w	Obj5D_PipeSegment	; only true for the first object
	move.b	#$E,routine(a1)	; => Obj5D_PipeSegment
	jmp	Obj5D_PipeSegment
; ===========================================================================
; once all pipe segments have been loaded, switch to pumping routine

Obj5D_Pipe_2_Load_End:
	move.b	#0,SecondaryRoutineCpzBoss(a0)
	move.b	#6,routine(a0)	; => Obj5D_Pipe_Pump_0
	jmp	Obj5D_PipeSegment
; ===========================================================================
; Object to control the pipe's actions while pumping.

Obj5D_Pipe_Pump:
	moveq	#0,d0
	move.b	SecondaryRoutineCpzBoss(a0),d0
	move.w	Obj5D_Pipe_Pump_Index(pc,d0.w),d1
	jmp	Obj5D_Pipe_Pump_Index(pc,d1.w)
; ===========================================================================
Obj5D_Pipe_Pump_Index:	offsetTable
		offsetTableEntry.w Obj5D_Pipe_Pump_0	; 0
		offsetTableEntry.w Obj5D_Pipe_Pump_2	; 2
		offsetTableEntry.w Obj5D_Pipe_Pump_4	; 4
; ===========================================================================
; prepares for pumping animation

Obj5D_Pipe_Pump_0:
	jsr	(SingleObjLoad2).l
	bne.w	Obj5D_PipeSegment
	move.b	#$E,routine(a0)	; => Obj5D_PipeSegment	; temporarily turn control object into a pipe segment
	move.b	#6,routine(a1)
	move.b	#2,SecondaryRoutineCpzBoss(a1)	; => Obj5D_Pipe_Pump_2
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.b	#2,Obj5D_timer3(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)

	; starting position for pumping animation
	move.w	#$B*8,d0
	move.b	d0,Obj5D_y_offset(a1)
	add.w	d0,y_pos(a1)
	move.b	#2,anim(a1)
	move.l	a0,Obj5D_parent(a1)	; address of control object
	move.b	#$12,Obj5D_timer(a1)
	jsr	(SingleObjLoad2).l
	bne.s	BranchTo_Obj5D_PipeSegment
	move.l	#Obj5D,(a1) ; load obj5D
	move.b	#$A,routine(a1)	; => Obj5D_Dripper
	move.l	Obj5D_parent(a0),Obj5D_parent(a1)

BranchTo_Obj5D_PipeSegment ; BranchTo
	jmp	Obj5D_PipeSegment
; ===========================================================================
; do pumping animation

Obj5D_Pipe_Pump_2:
	movea.l	Obj5D_parent(a0),a1	; parent = pipe segment (control object) ; a1=object
	movea.l	Obj5D_parent(a1),a2	; parent = main vehicle ; a2=object
	btst	#7,status(a2)		; has boss been defeated?
	bne.w	JmpTo51_DeleteObject	; if yes, branch
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)

	subi.b	#1,Obj5D_timer(a0)	; animation timer
	bne.s	Obj5D_Pipe_Pump_2_End
	; when timer reaches zero
	move.b	#$12,Obj5D_timer(a0)	; reset animation timer
	subi.b	#8,Obj5D_y_offset(a0)	; move one segment up
	bgt.s	Obj5D_Pipe_Pump_2_End
	bmi.s	+	; pumping sequence is over when y offset becomes negative

	; one final delay when last segment is reached
	move.b	#3,anim(a0)
	move.b	#$C,Obj5D_timer(a0)
	bra.s	Obj5D_Pipe_Pump_2_End
; ---------------------------------------------------------------------------
+	; when pumping sequence is over
	move.b	#6,Obj5D_timer(a0)
	move.b	#4,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Pipe_Pump_4
	rts
; ---------------------------------------------------------------------------

Obj5D_Pipe_Pump_2_End:
	; set y position based on y offset
	moveq	#0,d0
	move.b	Obj5D_y_offset(a0),d0
	add.w	d0,y_pos(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Pipe_Pump_4:
	subi.b	#1,Obj5D_timer(a0)	; wait a few frames
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	subq.b	#1,Obj5D_timer3(a0)
	beq.s	+
	move.b	#2,anim(a0)
	move.b	#$12,Obj5D_timer(a0)
	move.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Pipe_Pump_2
	move.b	#$B*8,Obj5D_y_offset(a0)
+
	; set control object's routine
	movea.l	Obj5D_parent(a0),a1	; parent = pipe segment (control object) ; a1=object
	move.b	#8,routine(a1)		; => Obj5D_Pipe_Retract
	move.b	#$B*8,Obj5D_y_offset(a1)
	jmp	JmpTo51_DeleteObject
; ===========================================================================
; Object to control the pipe's actions after pumping is finished.

Obj5D_Pipe_Retract:
	tst.b	Obj5D_flag(a0)	; is flag set?
	bne.s	loc_2DFEE	; if yes, branch

	moveq	#0,d0
	move.b	Obj5D_y_offset(a0),d0
	add.w	y_pos(a0),d0	; get y pos of current pipe segment
	lea	(MainCharacter).w,a1 ; a1=object
	moveq	#(Dynamic_Object_RAM_End-Object_RAM)/object_size-1,d1

Obj5D_Pipe_Retract_Loop:
	cmp.w	y_pos(a1),d0			; compare object's y position with current y offset
	beq.s	Obj5D_Pipe_Retract_ChkID	; if they match, branch
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,Obj5D_Pipe_Retract_Loop	; continue as long as there are object slots left
	bra.s	Obj5D_PipeSegment
; ===========================================================================

loc_2DFD8:
	st	Obj5D_flag(a0)
	bra.s	Obj5D_PipeSegment
; ===========================================================================

Obj5D_Pipe_Retract_ChkID:
	;moveq	#0,d7
	cmp.l	#Obj5D,(a1)	; is object a subtype of the CPZ Boss?
	beq.s	loc_2DFF0	; if yes, branch
	dbf	d1,Obj5D_Pipe_Retract_Loop
	bra.s	Obj5D_PipeSegment
; ===========================================================================

loc_2DFEE:
	movea.l	a0,a1

loc_2DFF0:
	bset	#7,status(a1)	; mark segment for deletion
	subi.b	#8,Obj5D_y_offset(a0)	; position of next segment up
	beq.s	loc_2DFD8

Obj5D_PipeSegment:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a2 ; a2=object
	btst	#7,status(a2)		; has boss been defeated?
	bne.s	Obj5D_PipeSegment_End	; if yes, branch

	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	cmpi.b	#4,SecondaryRoutineCpzBoss(a0)
	bne.s	+
	addi.w	#$18,y_pos(a0)
+
	btst	#7,status(a0)			; is object marked for deletion?
	bne.s	BranchTo_JmpTo51_DeleteObject	; if yes, branch
	move.w	Obj5D_y_pos_next(a0),d0
	add.w	d0,y_pos(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

BranchTo_JmpTo51_DeleteObject ; BranchTo
	jmp	JmpTo51_DeleteObject
; ===========================================================================

Obj5D_PipeSegment_End:
	move.b	#$14,routine(a0)
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a0)
	move.w	#-$380,y_vel(a0)
	swap	d0
	addi.b	#$1E,d0
	andi.w	#$7F,d0
	move.b	d0,Obj5D_timer(a0)
	jmpto	(DisplaySprite).l, JmpTo34_DisplaySprite
; ===========================================================================

Obj5D_Dripper:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	moveq	#0,d0
	move.b	SecondaryRoutineCpzBoss(a0),d0
	move.w	Obj5D_Dripper_States(pc,d0.w),d1
	jmp	Obj5D_Dripper_States(pc,d1.w)
; ===========================================================================
Obj5D_Dripper_States:	offsetTable
		offsetTableEntry.w Obj5D_Dripper_0	; 0
		offsetTableEntry.w Obj5D_Dripper_2	; 2
		offsetTableEntry.w Obj5D_Dripper_4	; 4
; ===========================================================================

Obj5D_Dripper_0:
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Dripper_2
	move.l	#Obj5D,(a1) ; load 0bj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#4,priority(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	#$F,Obj5D_timer(a0)
	move.b	#4,anim(a0)

Obj5D_Dripper_2:
	subq.b	#1,Obj5D_timer(a0)
	bne.s	+
	move.b	#5,anim(a0)
	move.b	#4,Obj5D_timer(a0)
	addq.b	#2,SecondaryRoutineCpzBoss(a0)
	subi.w	#$24,y_pos(a0)
	subi.w	#2,x_pos(a0)
	rts
; ---------------------------------------------------------------------------
+
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Dripper_4:
	subq.b	#1,Obj5D_timer(a0)
	bne.s	+
	move.b	#0,SecondaryRoutineCpzBoss(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	bset	#1,Obj5D_status2(a1)
	addq.b	#1,Obj5D_timer4(a0)
	cmpi.b	#$C,Obj5D_timer4(a0)
	bge.w	JmpTo51_DeleteObject
	rts
; ---------------------------------------------------------------------------
+
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	subi.w	#$24,y_pos(a0)
	subi.w	#2,x_pos(a0)
	btst	#0,render_flags(a0)
	beq.s	+
	addi.w	#4,x_pos(a0)
+
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Container:
	moveq	#0,d0
	move.b	SecondaryRoutineCpzBoss(a0),d0
	move.w	Obj5D_Container_States(pc,d0.w),d1
	jmp	Obj5D_Container_States(pc,d1.w)
; ===========================================================================
Obj5D_Container_States:	offsetTable
		offsetTableEntry.w Obj5D_Container_Init	; 0
		offsetTableEntry.w Obj5D_Container_Main	; 2
		offsetTableEntry.w Obj5D_Container_Floor	; 4
		offsetTableEntry.w Obj5D_Container_Extend	; 6
		offsetTableEntry.w Obj5D_Container_Floor2	; 8
		offsetTableEntry.w Obj5D_Container_FallOff	; A
; ===========================================================================

Obj5D_Container_Init:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	btst	#7,Obj5D_status2(a1)
	bne.s	+
	bset	#7,Obj5D_status2(a1)
	jsr	(SingleObjLoad2).l
	bne.s	+
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$10,routine(a1)
	move.b	#4,SecondaryRoutineCpzBoss(a1)	; => Obj5D_Container_Floor
	move.b	#9,anim(a1)
+
	jsr	(SingleObjLoad2).l
	bne.s	+
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	addi.b	#$10,routine(a1)
	move.b	#6,SecondaryRoutineCpzBoss(a1)	; => Obj5D_Container_Extend
+
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Container_Main

Obj5D_Container_Main:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	subi.w	#$38,y_pos(a0)
	btst	#7,status(a0)
	bne.s	loc_2E2E0
	btst	#2,Obj5D_status2(a1)
	beq.s	+
	jsr	loc_2E4CE
	jsr	loc_2E3F2
	bra.s	loc_2E2AC
; ---------------------------------------------------------------------------
+
	btst	#5,Obj5D_status2(a1)
	beq.s	loc_2E2AC
	subq.w	#1,Obj5D_timer2(a0)
	bne.s	loc_2E2AC
	bclr	#5,Obj5D_status2(a1)
	bset	#3,Obj5D_status2(a1)
	bset	#4,Obj5D_status2(a1)

loc_2E2AC:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.w	Obj5D_x_vel(a0),d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

loc_2E2E0:
	move.b	#$A,SecondaryRoutineCpzBoss(a0)
	bra.s	loc_2E2AC
; ===========================================================================

Obj5D_Container_FallOff:
	move.l	d7,-(sp)
	move.b	#$1E,Obj5D_timer(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	subi.w	#$38,y_pos(a0)
	move.w	Obj5D_x_vel(a0),d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a0)
	move.b	#$20,mapping_frame(a0)
	move.b	#$14,routine(a0)
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a0)
	move.w	#-$380,y_vel(a0)
	moveq	#0,d7
	move.w	Obj5D_x_vel(a0),d0
	addi.w	#$18,d0
	bge.s	loc_2E356
	addi.w	#$18,d0
	bge.s	loc_2E354
	addi.w	#$18,d0
	bge.s	loc_2E352
	addq.w	#1,d7

loc_2E352:
	addq.w	#1,d7

loc_2E354:
	addq.w	#1,d7

loc_2E356:
	subq.w	#1,d7
	bmi.w	loc_2E3E6

loc_2E35C:
	jsr	(SingleObjLoad).l
	bne.w	JmpTo51_DeleteObject
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.b	#$21,mapping_frame(a1)
	move.b	#$14,routine(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addi.w	#8,y_pos(a1)
	move.w	d7,d2
	add.w	d2,d2
	move.w	word_2E3EC(pc,d2.w),d3
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d3
+
	add.w	d3,x_pos(a1)
	jsr	(RandomNumber).l
	asr.w	#8,d0
	asr.w	#6,d0
	move.w	d0,x_vel(a1)
	move.w	#-$380,y_vel(a1)
	swap	d0
	addi.b	#$1E,d0
	andi.w	#$7F,d0
	move.b	d0,Obj5D_timer(a1)
	dbf	d7,loc_2E35C

loc_2E3E6:
	move.l	(sp)+,d7

    if removeJmpTos
JmpTo34_DisplaySprite ; JmpTo
    endif

	jmpto	(DisplaySprite).l, JmpTo34_DisplaySprite
; ===========================================================================
word_2E3EC:
	dc.w   $18
	dc.w   $30	; 1
	dc.w   $48	; 2
; ===========================================================================

loc_2E3F2:
	btst	#3,Obj5D_status2(a1)
	bne.w	return_2E4CC
	btst	#4,Obj5D_status2(a1)
	bne.w	return_2E4CC
	cmpi.w	#-$14,Obj5D_x_vel(a0)
	blt.s	+
	btst	#1,Obj5D_status(a1)
	beq.w	return_2E4CC
	bclr	#1,Obj5D_status(a1)
	bset	#2,Obj5D_status(a1)
	bra.s	loc_2E464
; ---------------------------------------------------------------------------
+
	cmpi.w	#-$40,Obj5D_x_vel(a0)
	bge.w	return_2E4CC
	move.w	(MainCharacter+x_pos).w,d1
	subi.w	#8,d1
	btst	#0,render_flags(a0)
	beq.s	+
	add.w	Obj5D_x_vel(a0),d1
	sub.w	x_pos(a0),d1
	bgt.w	return_2E4CC
	cmpi.w	#-$18,d1
	bge.s	loc_2E464
	rts
; ---------------------------------------------------------------------------
+
	sub.w	Obj5D_x_vel(a0),d1
	sub.w	x_pos(a0),d1
	blt.s	return_2E4CC
	cmpi.w	#$18,d1
	bgt.s	return_2E4CC

loc_2E464:
	bset	#5,Obj5D_status2(a1)
	bclr	#2,Obj5D_status2(a1)
	move.w	#$12,Obj5D_timer2(a0)
	jsr	(SingleObjLoad2).l
	bne.s	return_2E4CC
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.b	#$10,routine(a1)
	move.b	#8,SecondaryRoutineCpzBoss(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#5,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#$B,anim(a1)
	move.w	#$24,Obj5D_timer2(a1)

return_2E4CC:
	rts
; ===========================================================================

loc_2E4CE:
	moveq	#1,d0
	btst	#4,Obj5D_status2(a1)
	bne.s	+
	moveq	#-1,d0
+
	cmpi.w	#-$10,Obj5D_x_vel(a0)
	bne.s	loc_2E552
	bclr	#4,Obj5D_status2(a1)
	beq.s	loc_2E552
	bclr	#2,Obj5D_status2(a1)
	clr.b	SecondaryRoutineCpzBoss(a0)
	movea.l	a1,a2
	jsr	(SingleObjLoad2).l
	bne.s	return_2E550
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	Obj5D_parent(a0),Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,1,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#4,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#4,routine(a1)
	move.b	#0,SecondaryRoutineCpzBoss(a0)
	bra.s	return_2E550
; ===========================================================================
	move.b	#$A,routine(a1)
	move.l	Obj5D_parent(a0),Obj5D_parent(a1)

return_2E550:
	rts
; ===========================================================================

loc_2E552:
	move.w	Obj5D_x_vel(a0),d1
	cmpi.w	#-$28,d1
	bge.s	loc_2E59C
	cmpi.w	#-$40,d1
	bge.s	loc_2E594
	move.b	#8,anim(a0)
	cmpi.w	#-$58,d1
	blt.s	loc_2E57E
	bgt.s	loc_2E578
	btst	#4,Obj5D_status2(a1)
	beq.s	return_2E57C

loc_2E578:
	add.w	d0,Obj5D_x_vel(a0)

return_2E57C:
	rts
; ===========================================================================

loc_2E57E:
	move.w	#-$58,Obj5D_x_vel(a0)
	btst	#0,render_flags(a0)
	beq.s	loc_2E578
	move.w	#$58,Obj5D_x_vel(a0)
	bra.s	loc_2E578
; ===========================================================================

loc_2E594:
	move.b	#7,anim(a0)
	bra.s	loc_2E578
; ===========================================================================

loc_2E59C:
	move.b	#6,anim(a0)
	bra.s	loc_2E578
; ===========================================================================

Obj5D_Container_Extend:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	Obj5D_parent(a1),d0
	beq.w	JmpTo51_DeleteObject
	movea.l	d0,a1 ; a1=object
	bclr	#3,Obj5D_status2(a1)
	beq.s	+
	move.b	#$C,routine(a0)
	move.b	#0,SecondaryRoutineCpzBoss(a0)
	move.b	#$87,collision_flags(a0)
	bra.s	Obj5D_Container_Floor_End
; ----------------------------------------------------------------------------
+
	bclr	#1,Obj5D_status2(a1)
	bne.s	+
	tst.b	anim(a0)
	bne.s	Obj5D_Container_Floor_End
	rts
; ---------------------------------------------------------------------------
+
	tst.b	anim(a0)
	bne.s	+
	move.b	#$B,anim(a0)
+
	addi.b	#1,anim(a0)
	cmpi.b	#$17,anim(a0)
	blt.s	Obj5D_Container_Floor_End
	bclr	#0,Obj5D_status2(a1)
	bset	#2,Obj5D_status2(a1)
	bra.s	Obj5D_Container_Floor_End
; ===========================================================================

Obj5D_Container_Floor:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	btst	#5,Obj5D_status2(a1)
	beq.s	Obj5D_Container_Floor_End
	cmpi.b	#9,anim(a0)
	bne.s	Obj5D_Container_Floor_End
	move.b	#$A,anim(a0)

Obj5D_Container_Floor_End:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.b	status(a1),status(a0)
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Container_Floor2:
	btst	#7,status(a0)
	bne.w	JmpTo51_DeleteObject
	subq.w	#1,Obj5D_timer2(a0)
	beq.w	JmpTo51_DeleteObject
	bra.s	Obj5D_Container_Floor_End
; ===========================================================================

Obj5D_Gunk:
	moveq	#0,d0
	move.b	SecondaryRoutineCpzBoss(a0),d0
	move.w	Obj5D_Gunk_States(pc,d0.w),d1
	jmp	Obj5D_Gunk_States(pc,d1.w)
; ===========================================================================
Obj5D_Gunk_States:	offsetTable
		offsetTableEntry.w Obj5D_Gunk_Init	; 0
		offsetTableEntry.w Obj5D_Gunk_Main	; 2
		offsetTableEntry.w Obj5D_Gunk_Droplets	; 4
		offsetTableEntry.w Obj5D_Gunk_6	; 6
		offsetTableEntry.w Obj5D_Gunk_8	; 8
; ===========================================================================

Obj5D_Gunk_Init:
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Gunk_Main
	move.b	#$20,y_radius(a0)
	move.b	#$19,anim(a0)
	move.w	#0,y_vel(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	btst	#2,Obj5D_status(a1)
	beq.s	Obj5D_Gunk_Main
	bclr	#2,Obj5D_status(a1)
	move.b	#6,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Gunk_6
	move.w	#9,Obj5D_timer2(a0)

Obj5D_Gunk_Main:
	jsrto	(ObjectMoveAndFall).l, JmpTo3_ObjectMoveAndFall
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bmi.s	+	; branch, if hit the floor
	cmpi.w	#$518,y_pos(a0)
	bge.s	Obj5D_Gunk_OffScreen	; branch, if fallen off screen
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================
+
	add.w	d1,y_pos(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	bset	#2,Obj5D_status2(a1)
	bset	#4,Obj5D_status2(a1)
	move.b	#2,SecondaryRoutineCpzBoss(a1)
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Gunk_Droplets
	move.b	#0,subtype(a0)
	move.w	#SndID_MegaMackDrop,d0
	jsrto	(PlaySound).l, JmpTo5_PlaySound
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Gunk_OffScreen:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1
	bset	#2,Obj5D_status2(a1)
	bset	#4,Obj5D_status2(a1)
	move.b	#2,SecondaryRoutineCpzBoss(a1)
	jmp	JmpTo51_DeleteObject
; ===========================================================================

Obj5D_Gunk_6:
	subi.w	#1,Obj5D_timer2(a0)
	bpl.s	+
	move.b	#2,priority(a0)
	move.b	#$25,mapping_frame(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addq.b	#2,SecondaryRoutineCpzBoss(a0)	; => Obj5D_Gunk_8
	move.b	#8,anim_frame_duration(a0)
	bra.s	Obj5D_Gunk_8
; ===========================================================================
+
	jsrto	(ObjectMove).l, JmpTo23_ObjectMove
	lea	(Ani_Obj5D_Dripper).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Gunk_8:
	subi.b	#1,anim_frame_duration(a0)
	bpl.s	+
	addi.b	#1,mapping_frame(a0)
	move.b	#8,anim_frame_duration(a0)
	cmpi.b	#$27,mapping_frame(a0)
	bgt.w	Obj5D_Gunk_OffScreen
	blt.s	+
	addi.b	#$C,anim_frame_duration(a0)
+
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	movea.l	Obj5D_parent(a1),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	jmp	(DisplaySprite).l
; ===========================================================================

Obj5D_Gunk_Droplets:
	moveq	#0,d0
	move.b	subtype(a0),d0
	bne.w	Obj5D_Gunk_Droplets_Move
	addi.w	#$18,y_pos(a0)
	addi.w	#$C,x_pos(a0)
	btst	#0,render_flags(a0)
	beq.s	+
	subi.w	#$18,x_pos(a0)
+
	move.b	#4,y_radius(a0)
	move.b	#4,x_radius(a0)
	addq.b	#1,subtype(a0)
	move.b	#9,mapping_frame(a0)
	move.w	y_vel(a0),d0
	lsr.w	#1,d0
	neg.w	d0
	move.w	d0,y_vel(a0)
	jsr	(RandomNumber).l
	asr.w	#6,d0
	bmi.s	+
	addi.w	#$200,d0
+
	addi.w	#-$100,d0
	move.w	d0,x_vel(a0)
	move.b	#0,collision_flags(a0)
	moveq	#3,d3

Obj5D_Gunk_Droplets_Loop:
	jsr	(SingleObjLoad2).l
	bne.w	BranchTo_JmpTo34_DisplaySprite
	move.l	#Obj5D,(a1) ; load obj5D
	move.l	a0,Obj5D_parent(a1)
	move.l	#Obj5D_MapUnc_2EADC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_CPZBoss,3,0),art_tile(a1)
	move.b	#4,render_flags(a1)
	move.b	#$20,width_pixels(a1)
	move.b	#2,priority(a1)
	move.l	x_pos(a0),x_pos(a1)
	move.l	y_pos(a0),y_pos(a1)
	move.b	#4,y_radius(a1)
	move.b	#4,x_radius(a1)
	move.b	#9,mapping_frame(a1)
	move.b	#$C,routine(a1)
	move.b	#4,SecondaryRoutineCpzBoss(a1)
	move.b	#1,subtype(a1)
	move.w	y_vel(a0),y_vel(a1)
	move.b	collision_flags(a0),collision_flags(a1)
	jsr	(RandomNumber).l
	asr.w	#6,d0
	bmi.s	+
	addi.w	#$80,d0
+
	addi.w	#-$80,d0
	move.w	d0,x_vel(a1)
	swap	d0
	andi.w	#$3FF,d0
	sub.w	d0,y_vel(a1)
	dbf	d3,Obj5D_Gunk_Droplets_Loop

BranchTo_JmpTo34_DisplaySprite ; BranchTo
	jmpto	(DisplaySprite).l, JmpTo34_DisplaySprite
; ===========================================================================

Obj5D_Gunk_Droplets_Move:
	jsrto	(ObjectMoveAndFall).l, JmpTo3_ObjectMoveAndFall
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bmi.s	+
	jmpto	(MarkObjGone).l, JmpTo35_MarkObjGone
; ---------------------------------------------------------------------------
+
	jmp	JmpTo51_DeleteObject
; ===========================================================================

	; a bit of unused/dead code here
	add.w	d1,y_pos(a0) ; a0=object
	move.w	y_vel(a0),d0
	lsr.w	#1,d0
	neg.w	d0
	move.w	d0,y_vel(a0)
	jmpto	(DisplaySprite).l, JmpTo34_DisplaySprite

; ===========================================================================

Obj5D_Robotnik:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	move.b	Obj5D_invulnerable_time(a1),d0
	cmpi.b	#$1F,d0
	bne.s	+
	move.b	#2,anim(a0)
+
	cmpi.b	#4,(MainCharacter+routine).w
	beq.s	+
	cmpi.b	#4,(Sidekick+routine).w
	bne.s	Obj5D_Robotnik_End
+
	move.b	#3,anim(a0)

Obj5D_Robotnik_End:
	lea	(Ani_obj5D_b).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================
byte_2E94A:
	dc.b   0
	dc.b $FF	; 1
	dc.b   1	; 2
	dc.b   0	; 3
; ===========================================================================

Obj5D_Flame:
	btst	#7,status(a0)
	bne.s	loc_2E9A8
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.b	status(a1),status(a0)
	move.b	render_flags(a1),render_flags(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	loc_2E996
	move.b	#1,anim_frame_duration(a0)
	move.b	Obj5D_timer2(a0),d0
	addq.b	#1,d0
	cmpi.b	#2,d0
	ble.s	+
	moveq	#0,d0
+
	move.b	byte_2E94A(pc,d0.w),mapping_frame(a0)
	move.b	d0,Obj5D_timer2(a0)

loc_2E996:
	cmpi.b	#-1,mapping_frame(a0)
	bne.w	JmpTo34_DisplaySprite
	move.b	#0,mapping_frame(a0)
	rts
; ===========================================================================

loc_2E9A8:
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	btst	#6,Obj5D_status2(a1)
	bne.s	+
	rts
; ===========================================================================
+
	addq.b	#2,SecondaryRoutineCpzBoss(a0)
	move.l	#Obj5D_MapUnc_2EEA0,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_EggpodJets_1,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo60_Adjust2PArtPointer
	move.b	#0,mapping_frame(a0)
	move.b	#5,anim_frame_duration(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi.w	#4,y_pos(a0)
	subi.w	#$28,x_pos(a0)
	rts
; ===========================================================================

Obj5D_1A:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	BranchTo2_JmpTo34_DisplaySprite
	move.b	#5,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#4,mapping_frame(a0)
	bne.w	BranchTo2_JmpTo34_DisplaySprite
	move.b	#0,mapping_frame(a0)
	movea.l	Obj5D_parent(a0),a1 ; a1=object
	move.l	(a1),d0
	beq.w	JmpTo51_DeleteObject	; branch, if parent object is gone
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi.w	#4,y_pos(a0)
	subi.w	#$28,x_pos(a0)

BranchTo2_JmpTo34_DisplaySprite
	jmpto	(DisplaySprite).l, JmpTo34_DisplaySprite
; ===========================================================================
; animation script
; off_2EA3C:
Ani_Obj5D_Dripper:	offsetTable
		offsetTableEntry.w byte_2EA72	;   0
		offsetTableEntry.w byte_2EA75	;   1
		offsetTableEntry.w byte_2EA78	;   2
		offsetTableEntry.w byte_2EA7D	;   3
		offsetTableEntry.w byte_2EA81	;   4
		offsetTableEntry.w byte_2EA88	;   5
		offsetTableEntry.w byte_2EA8B	;   6
		offsetTableEntry.w byte_2EA8E	;   7
		offsetTableEntry.w byte_2EA91	;   8
		offsetTableEntry.w byte_2EA94	;   9
		offsetTableEntry.w byte_2EA97	;  $A
		offsetTableEntry.w byte_2EAA3	;  $B
		offsetTableEntry.w byte_2EAAE	;  $C
		offsetTableEntry.w byte_2EAB1	;  $D
		offsetTableEntry.w byte_2EAB4	;  $E
		offsetTableEntry.w byte_2EAB7	;  $F
		offsetTableEntry.w byte_2EABA	; $10
		offsetTableEntry.w byte_2EABD	; $11
		offsetTableEntry.w byte_2EAC0	; $12
		offsetTableEntry.w byte_2EAC3	; $13
		offsetTableEntry.w byte_2EAC6	; $14
		offsetTableEntry.w byte_2EAC9	; $15
		offsetTableEntry.w byte_2EACC	; $16
		offsetTableEntry.w byte_2EACF	; $17
		offsetTableEntry.w byte_2EAD2	; $18
		offsetTableEntry.w byte_2EAD5	; $19
		offsetTableEntry.w byte_2EAD9	; $1A
byte_2EA72:	dc.b  $F,  0,$FF
	rev02even
byte_2EA75:	dc.b  $F,  1,$FF
	rev02even
byte_2EA78:	dc.b   5,  2,  3,  2,$FF
	rev02even
byte_2EA7D:	dc.b   5,  2,  3,$FF
	rev02even
byte_2EA81:	dc.b   2,  4,  5,  6,  7,  8,$FF
	rev02even
byte_2EA88:	dc.b   3,  9,$FF
	rev02even
byte_2EA8B:	dc.b  $F, $A,$FF
	rev02even
byte_2EA8E:	dc.b  $F,$1C,$FF
	rev02even
byte_2EA91:	dc.b  $F,$1E,$FF
	rev02even
byte_2EA94:	dc.b  $F, $B,$FF
	rev02even
byte_2EA97:	dc.b   3, $C, $C, $D, $D, $D, $D, $D, $C, $C,$FD,  9
	rev02even
byte_2EAA3:	dc.b   3, $E, $E, $F, $F, $F, $F, $F, $E, $E,$FF
	rev02even
byte_2EAAE:	dc.b  $F,$10,$FF
	rev02even
byte_2EAB1:	dc.b  $F,$11,$FF
	rev02even
byte_2EAB4:	dc.b  $F,$12,$FF
	rev02even
byte_2EAB7:	dc.b  $F,$13,$FF
	rev02even
byte_2EABA:	dc.b  $F,$14,$FF
	rev02even
byte_2EABD:	dc.b  $F,$15,$FF
	rev02even
byte_2EAC0:	dc.b  $F,$16,$FF
	rev02even
byte_2EAC3:	dc.b  $F,$17,$FF
	rev02even
byte_2EAC6:	dc.b  $F,$18,$FF
	rev02even
byte_2EAC9:	dc.b  $F,$19,$FF
	rev02even
byte_2EACC:	dc.b  $F,$1A,$FF
	rev02even
byte_2EACF:	dc.b  $F,$1B,$FF
	rev02even
byte_2EAD2:	dc.b  $F,$1C,$FF
	rev02even
byte_2EAD5:	dc.b   1,$1D,$1F,$FF
	rev02even
byte_2EAD9:	dc.b  $F,$1E,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_CPZBoss
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EADC:	BINCLUDE "mappings/sprite/obj5D_a.bin"
                    even
; animation script
; off_2ED5C:
Ani_obj5D_b:	offsetTable
		offsetTableEntry.w byte_2ED66	; 0
		offsetTableEntry.w byte_2ED69	; 1
		offsetTableEntry.w byte_2ED6D	; 2
		offsetTableEntry.w byte_2ED76	; 3
		offsetTableEntry.w byte_2ED7F	; 4
byte_2ED66:	dc.b  $F,  0,$FF
	rev02even
byte_2ED69:	dc.b   7,  1,  2,$FF
	rev02even
byte_2ED6D:	dc.b   7,  5,  5,  5,  5,  5,  5,$FD,  1
	rev02even
byte_2ED76:	dc.b   7,  3,  4,  3,  4,  3,  4,$FD,  1
	rev02even
byte_2ED7F:	dc.b  $F,  6,  6,  6,  6,  6,  6,  6,  6,  6,  6,$FD,  1
	even

; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_Eggpod
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2ED8C:	BINCLUDE "mappings/sprite/obj5D_b.bin"
 even
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_EggpodJets
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EE88:	BINCLUDE "mappings/sprite/obj5D_c.bin"
 even
; ----------------------------------------------------------------------------
; sprite mappings - uses ArtNem_BossSmoke
; ----------------------------------------------------------------------------
Obj5D_MapUnc_2EEA0:	BINCLUDE "mappings/sprite/obj5D_d.bin"
 even
; ===========================================================================

    if ~~removeJmpTos
JmpTo34_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
JmpTo51_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo35_MarkObjGone ; JmpTo
	jmp	(MarkObjGone).l
JmpTo5_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo8_Adjust2PArtPointer2 ; JmpTo
	jmp	(Adjust2PArtPointer2).l
JmpTo5_LoadPLC ; JmpTo
	jmp	(LoadPLC).l
JmpTo2_AddPoints ; JmpTo
	jmp	(AddPoints).l
JmpTo60_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_PlayLevelMusic ; JmpTo
	jmp	(PlayLevelMusic).l
JmpTo_LoadPLC_AnimalExplosion ; JmpTo
	jmp	(LoadPLC_AnimalExplosion).l
JmpTo3_ObjectMoveAndFall ; JmpTo
	jmp	(ObjectMoveAndFall).l
; loc_2EF12:
JmpTo23_ObjectMove ; JmpTo
	jmp	(ObjectMove).l

	align 4
    endif
