



; ===========================================================================
; ----------------------------------------------------------------------------
; Object 26 - Monitor
;
; The power-ups themselves are handled by the next object. This just does the
; monitor collision and graphics.
; ----------------------------------------------------------------------------
; Obj_Monitor:
Obj26:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj26_Index(pc,d0.w),d1
	jmp	Obj26_Index(pc,d1.w)
; ===========================================================================
; obj_26_subtbl:
Obj26_Index:	offsetTable
		offsetTableEntry.w Obj26_Init			; 0
		offsetTableEntry.w Obj26_Main			; 2
		offsetTableEntry.w Obj26_Break			; 4
		offsetTableEntry.w Obj26_Animate		; 6
		offsetTableEntry.w BranchTo2_MarkObjGone	; 8
; ===========================================================================
; obj_26_sub_0: Obj_26_Init:
Obj26_Init:
	addq.b	#2,routine(a0)
	move.b	#$E,y_radius(a0)
	move.b	#$E,x_radius(a0)
	move.l	#Obj26_MapUnc_12D36,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#$F,width_pixels(a0)

	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	bclr	#7,2(a2,d0.w)
	btst	#0,2(a2,d0.w)	; if this bit is set it means the monitor is already broken
	beq.s	+
	move.b	#8,routine(a0)	; set monitor to 'broken' state
	move.b	#$B,mapping_frame(a0)
	rts
; ---------------------------------------------------------------------------
+
	move.b	#$46,collision_flags(a0)
	move.b	subtype(a0),anim(a0)	; subtype = icon to display
	tst.w	(Two_player_mode).w	; is it two player mode?
	beq.s	Obj26_Main		; if not, branch
	move.b	#9,anim(a0)		; use '?' icon
;obj_26_sub_2:
Obj26_Main:
                bsr.s   Obj_MonitorFall
         	move.w	#$19,d1			; Monitor's width
		move.w	#$10,d2
		move.w	d2,d3
		addq.w	#1,d3
		move.w	x_pos(a0),d4
		lea	(Player_1).w,a1
		moveq	#p1_standing_bit,d6
		movem.l	d1-d4,-(sp)
		bsr.w	SolidObject_Monitor_Sonic
		movem.l	(sp)+,d1-d4
		lea	(Player_2).w,a1
		moveq	#p2_standing_bit,d6
		bsr.w	SolidObject_Monitor_Tails

Obj26_Animate:
	lea	(Ani_obj26).l,a1
	bsr.w	AnimateSprite

BranchTo2_MarkObjGone
	bra.w	MarkObjGone

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; sub_12756:
SolidObject_Monitor_SonicKnux:
SolidObject_Monitor_Sonic:
                 btst	d6,status(a0)		; Is Sonic/Knux standing on the monitor?
		bne.w	Monitor_ChkOverEdge	; If so, branch
		cmpi.b	#2,anim(a1)		; Is Sonic/Knux in their rolling animation?
		beq.s	locret_1D6BC		; If so, return
		cmpi.b	#2,character_id(a1)	; Is character Knuckles?
		bne.s	loc_1D6BE		; If not, branch
		cmpi.b	#1,double_jump_flag(a1)	; Is Knuckles gliding?
		beq.s	locret_1D6BC		; If so, return
		cmpi.b	#3,double_jump_flag(a1)	; Is Knuckles sliding after gliding?
		bne.s	loc_1D6BE		; If not, branch

locret_1D6BC:
		rts
; ---------------------------------------------------------------------------

loc_1D6BE:
		jmp	SolidObject_cont
; End of function SolidObject_Monitor_Sonic
Obj_MonitorFall:
		move.b	routine_secondary(a0),d0
		beq.s	locret_1D694
		btst	#1,render_flags(a0)	; Is monitor upside down?
		bne.s	Obj_MonitorFallUpsideDown ; If so, branch
		bsr.w	MoveSprite
		tst.w	y_vel(a0)		; Is monitor moving up?
		bmi.s	locret_1D694		; If so, return
		jsr	(ObjCheckFloorDist).l
		tst.w	d1			; Is monitor in the ground?
		beq.s	.inground		; If so, branch
		bpl.s	locret_1D694		; if not, return

	.inground:
		add.w	d1,y_pos(a0)		; Move monitor out of the ground
		clr.w	y_vel(a0)
		clr.b	routine_secondary(a0)	; Stop monitor from falling
		rts
Obj_MonitorFallUpsideDown:
		bsr.w	MoveSprite2
		subi.w	#$38,y_vel(a0)
		tst.w	y_vel(a0)		; Is monitor moving down?
		bpl.s	locret_1D694		; If so, return
		jsr	(ObjCheckCeilingDist).l
		tst.w	d1			; Is monitor in the ground (ceiling)?
		beq.s	.inground		; If so, branch
		bpl.s	locret_1D694		; if not, return

	.inground:
		sub.w	d1,y_pos(a0)		; Move monitor out of the ground
		clr.w	y_vel(a0)
		clr.b	routine_secondary(a0)	; Stop monitor from falling

locret_1D694:
		rts
; End of function Obj_MonitorFall
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; sub_12768:
SolidObject_Monitor_Tails:
                btst	d6,status(a0)		; Is Tails standing on the monitor?
		bne.s	Monitor_ChkOverEdge	; If so, branch
		tst.w	(Two_player_mode).w	; Are we in competition mode?
		beq.w	SolidObject_cont	; If not, branch
		cmpi.b	#2,anim(a1)		; Is Tails in his rolling animation?
		bne.w	SolidObject_cont	; If not, branch
	rts
; End of function SolidObject_Monitor_Tails

; ---------------------------------------------------------------------------
; Checks if the player has walked over the edge of the monitor.
; ---------------------------------------------------------------------------
;loc_12782:
Monitor_ChkOverEdge:
Obj26_ChkOverEdge:
                move.w	d1,d2
		add.w	d2,d2
		btst	#1,status(a1)		; Is the character in the air?
		bne.s	.notonmonitor		; If so, branch
		; Check if character is standing on
		move.w	x_pos(a1),d0
		sub.w	x_pos(a0),d0
		add.w	d1,d0
		bmi.s	.notonmonitor		; Branch, if character is behind the left edge of the monitor
		cmp.w	d2,d0
		blo.s	Monitor_CharStandOn	; Branch, if character is not beyond the right edge of the monitor

	.notonmonitor:
		; if the character isn't standing on the monitor
		bclr	#3,status(a1)		; Clear 'on object' bit
		bset	#1,status(a1)		; Set 'in air' bit
		bclr	d6,status(a0)		; Clear 'standing on' bit for the current character
		moveq	#0,d4
		rts
; ---------------------------------------------------------------------------

Monitor_CharStandOn:
		move.w	d4,d2
		bsr.w	MvSonicOnPtfm
		moveq	#0,d4
		rts
; End of function SolidObject_Monitor_Tails
; ===========================================================================
;obj_26_sub_4:
Obj26_Break:
		move.b	status(a0),d0
		andi.b	#standing_mask|pushing_mask,d0	; Is someone touching the monitor?
		beq.s	Obj26_SpawnIcon		; If not, branch
		move.b	d0,d1
		andi.b	#p1_standing|p1_pushing,d1	; Is it the main character?
		beq.s	.notmainchar			; If not, branch
		andi.b	#$D7,(Player_1+status).w
		ori.b	#2,(Player_1+status).w		; Prevent main character from walking in the air

	.notmainchar:
		andi.b	#p2_standing|p2_pushing,d0	; Is it the sidekick?
		beq.s	Obj26_SpawnIcon		; If not, branch
		andi.b	#$D7,(Player_2+status).w
		ori.b	#2,(Player_2+status).w		; Prevent sidekick from walking in the air
;loc_127EC:
Obj26_SpawnIcon:
	andi.b	#3,status(a0)
	addq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	bsr.w	SingleObjLoad
	bne.s	Obj26_SpawnSmoke
	move.L	#Obj2E,(a1) ; load obj2E
	move.w	x_pos(a0),x_pos(a1)		; Set icon's position
	move.w	y_pos(a0),y_pos(a1)
	move.b	anim(a0),anim(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	status(a0),status(a1)
	move.w	parent(a0),parent(a1)
;loc_1281E:
Obj26_SpawnSmoke:
	bsr.w	SingleObjLoad
	bne.s	+
	move.l	#Obj27,(a1) ; load obj27
	addq.b	#2,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	bset	#0,2(a2,d0.w)	; mark monitor as destroyed
	move.b	#$A,anim(a0)
	bra.w	DisplaySprite
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 2E - Monitor contents (code for power-up behavior and rising image)
; ----------------------------------------------------------------------------

Obj2E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj2E_Index(pc,d0.w),d1
	jmp	Obj2E_Index(pc,d1.w)
; ===========================================================================
; off_12862:
Obj2E_Index:	offsetTable
		offsetTableEntry.w Obj2E_Init	; 0
		offsetTableEntry.w Obj2E_Raise	; 2
		offsetTableEntry.w Obj2E_Wait	; 4
; ===========================================================================
; Object initialization. Called if routine counter == 0.
; loc_12868:
Obj2E_Init:
	addq.b	#2,routine(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#$24,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#8,width_pixels(a0)
	move.w	#-$300,y_vel(a0)
	moveq	#0,d0
	move.b	anim(a0),d0

	tst.w	(Two_player_mode).w	; is it two player mode?
	beq.s	loc_128C6		; if not, branch
	; give 'random' item in two player mode
	move.w	(Timer_frames).w,d0	; use the timer to determine which item
	andi.w	#7,d0	; and 7 means there are 8 different items
	addq.w	#1,d0	; add 1 to prevent getting the static monitor
	tst.w	(Two_player_items).w	; are monitors set to 'teleport only'?
	beq.s	+			; if not, branch
	moveq	#8,d0			; force contents to be teleport
+	; keep teleport monitor from causing unwanted effects
	cmpi.w	#8,d0	; teleport?
	bne.s	+	; if not, branch
	move.b	(Update_HUD_timer).w,d1
	add.b	(Update_HUD_timer_2P).w,d1
	cmpi.b	#2,d1	; is either player done with the act?
	beq.s	+	; if not, branch
	moveq	#7,d0	; give invincibility, instead
+
	move.b	d0,anim(a0)
;loc_128C6:
loc_128C6:			; Determine correct mappings offset.
	addq.b	#1,d0
	move.b	d0,mapping_frame(a0)
	movea.l	#Obj26_MapUnc_12D36,a1
	add.b	d0,d0
	adda.w	(a1,d0.w),a1
	addq.w	#2,a1
	move.l	a1,mappings(a0)
; loc_128DE:
Obj2E_Raise:
	bsr.s	+
	bra.w	DisplaySprite

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

+
	tst.w	y_vel(a0)	; is icon still floating up?
	bpl.w	+		; if not, branch
	bsr.w	ObjectMove	; update position
	addi.w	#$18,y_vel(a0)	; reduce upward speed
	rts
; ---------------------------------------------------------------------------

+
	addq.b	#2,routine(a0)
	move.w	#$1D,anim_frame_duration(a0)
	movea.w	parent(a0),a1 ; a1=character
	lea	(Monitors_Broken).w,a2
	cmpa.w	#MainCharacter,a1	; did Sonic break the monitor?
	beq.s	+			; if yes, branch
	lea	(Monitors_Broken_2P).w,a2

+
	moveq	#0,d0
	move.b	anim(a0),d0
	add.w	d0,d0
	move.w	Obj2E_Types(pc,d0.w),d0
	jmp	Obj2E_Types(pc,d0.w)
; End of function

; ===========================================================================
Obj2E_Types:	offsetTable
		offsetTableEntry.w robotnik_monitor	; 0 - Static
		offsetTableEntry.w sonic_1up		; 1 - Sonic 1-up
		offsetTableEntry.w tails_1up		; 2 - Tails 1-up
		offsetTableEntry.w robotnik_monitor	; 3 - Robotnik
		offsetTableEntry.w super_ring		; 4 - Super Ring
		offsetTableEntry.w super_shoes		; 5 - Speed Shoes
		offsetTableEntry.w shield_monitor	; 6 - Shield
		offsetTableEntry.w invincible_monitor	; 7 - Invincibility
		offsetTableEntry.w teleport_monitor	; 8 - Teleport
		offsetTableEntry.w qmark_monitor	; 9 - Question mark
; ===========================================================================
; ---------------------------------------------------------------------------
; Robotnik Monitor
; hurts the player
; ---------------------------------------------------------------------------
; badnik_monitor:
robotnik_monitor:
	addq.w	#1,(a2)
	bra.w	Touch_ChkHurt2
; ===========================================================================
; ---------------------------------------------------------------------------
; Sonic 1up Monitor
; gives Sonic an extra life, or Tails in a 'Tails alone' game
; ---------------------------------------------------------------------------
sonic_1up:
	addq.w	#1,(Monitors_Broken).w
	addq.b	#1,(Life_count).w
	addq.b	#1,(Update_HUD_lives).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l	; Play extra life music
; ===========================================================================
; ---------------------------------------------------------------------------
; Tails 1up Monitor
; gives Tails an extra life in two player mode
; ---------------------------------------------------------------------------
tails_1up:
	addq.w	#1,(Monitors_Broken_2P).w
	addq.b	#1,(Life_count_2P).w
	addq.b	#1,(Update_HUD_lives_2P).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l	; Play extra life music
; ===========================================================================
; ---------------------------------------------------------------------------
; Super Ring Monitor
; gives the player 10 rings
; ---------------------------------------------------------------------------
super_ring:
	addq.w	#1,(a2)

    if gameRevision=0
	lea	(Ring_count).w,a2
	lea	(Update_HUD_rings).w,a3
	lea	(Extra_life_flags).w,a4
	cmpa.w	#MainCharacter,a1
	beq.s	+
	lea	(Ring_count_2P).w,a2
	lea	(Update_HUD_rings_2P).w,a3
	lea	(Extra_life_flags_2P).w,a4
+	; give player 10 rings
	addi.w	#10,(a2)
    else
	lea	(Ring_count).w,a2
	lea	(Update_HUD_rings).w,a3
	lea	(Extra_life_flags).w,a4
	lea	(Rings_Collected).w,a5
	cmpa.w	#MainCharacter,a1
	beq.s	+
	lea	(Ring_count_2P).w,a2
	lea	(Update_HUD_rings_2P).w,a3
	lea	(Extra_life_flags_2P).w,a4
	lea	(Rings_Collected_2P).w,a5
+
	addi.w	#10,(a5)
	cmpi.w	#999,(a5)
	blo.s	+
	move.w	#999,(a5)

+	; give player 10 rings and max out at 999
	addi.w	#10,(a2)
	cmpi.w	#999,(a2)
	blo.s	+
	move.w	#999,(a2)
    endif

+
	ori.b	#1,(a3)
	cmpi.w	#100,(a2)
	blo.s	+		; branch, if player has less than 100 rings
	bset	#1,(a4)		; set flag for first 1up
	beq.s	ChkPlayer_1up	; branch, if not yet set
	cmpi.w	#200,(a2)
	blo.s	+		; branch, if player has less than 200 rings
	bset	#2,(a4)		; set flag for second 1up
	beq.s	ChkPlayer_1up	; branch, if not yet set
+
	move.w	#SndID_Ring,d0
	jmp	(PlayMusic).l
; ---------------------------------------------------------------------------
;loc_129D4:
ChkPlayer_1up:
	; give 1up to correct player
	cmpa.w	#MainCharacter,a1
	beq.w	sonic_1up
	bra.w	tails_1up
; ===========================================================================
; ---------------------------------------------------------------------------
; Super Sneakers Monitor
; speeds the player up temporarily
; ---------------------------------------------------------------------------
super_shoes:
	addq.w	#1,(a2)
	bset	#status_sec_hasSpeedShoes,status_secondary(a1)	; give super sneakers status
	move.b	#$96,speedshoes_time(a1)
	cmpa.w	#MainCharacter,a1	; did the main character break the monitor?
	bne.s	super_shoes_Tails	; if not, branch
	cmpi.w	#2,(Player_mode).w	; is player using Tails?
	beq.s	super_shoes_Tails	; if yes, branch
	move.w	#$C00,(Sonic_top_speed).w	; set stats
	move.w	#$18,(Sonic_acceleration).w
	move.w	#$80,(Sonic_deceleration).w
	bra.s	+
; ---------------------------------------------------------------------------
;loc_12A10:
super_shoes_Tails:
	move.w	#$C00,(Tails_top_speed).w
	move.w	#$18,(Tails_acceleration).w
	move.w	#$80,(Tails_deceleration).w
+
	move.w	#MusID_SpeedUp,d0
	jmp	(PlayMusic).l	; Speed up tempo
; ===========================================================================
; ---------------------------------------------------------------------------
; Shield Monitor
; gives the player a shield that absorbs one hit
; ---------------------------------------------------------------------------
shield_monitor:
	addq.w	#1,(a2)
	bset	#status_sec_hasShield,status_secondary(a1)	; give shield status
	move.w	#SndID_Shield,d0
	jsr	(PlayMusic).l
	tst.b	parent+1(a0)
	bne.s	+
	move.l	#Obj38,(Sonic_Shield).w ; load Obj38 (shield) at $FFFFD180
	move.w	a1,(Sonic_Shield+parent).w
	rts
; ---------------------------------------------------------------------------
+	; give shield to sidekick
	move.l	#Obj38,(Tails_Shield).w ; load Obj38 (shield) at $FFFFD1C0
	move.w	a1,(Tails_Shield+parent).w
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Invincibility Monitor
; makes the player temporarily invincible
; ---------------------------------------------------------------------------
invincible_monitor:
	addq.w	#1,(a2)
	tst.b	(Super_Sonic_flag).w	; is Sonic super?
	bne.s	+++	; rts		; if yes, branch
	bset	#status_sec_isInvincible,status_secondary(a1)	; give invincibility status
	move.b	#$96,invincibility_time(a1) ; 20 seconds
	tst.b	(Current_Boss_ID).w	; don't change music during boss battles
	bne.s	+
	cmpi.b	#$C,air_left(a1)	; or when drowning
	bls.s	+
	move.w	#MusID_Invincible,d0
	jsr	(PlayMusic).l
+
	tst.b	parent+1(a0)
	bne.s	+
	move.l	#Obj35,(Sonic_InvincibilityStars).w ; load Obj35 (invincibility stars) at $FFFFD200
	move.w	a1,(Sonic_InvincibilityStars+parent).w
	rts
; ---------------------------------------------------------------------------
+	; give invincibility to sidekick
	move.l	#Obj35,(Tails_InvincibilityStars).w ; load Obj35 (invincibility stars) at $FFFFD300
	move.w	a1,(Tails_InvincibilityStars+parent).w
+
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Teleport Monitor
; swaps both players around
; ---------------------------------------------------------------------------
;loc_12AA6:
teleport_monitor:
	addq.w	#1,(a2)
	cmpi.b	#6,(MainCharacter+routine).w	; is player 1 dead or respawning?
	bhs.s	+				; if yes, branch
	cmpi.b	#6,(Sidekick+routine).w		; is player 2 dead or respawning?
	blo.s	swap_players			; if not, branch
+	; can't teleport if either player is dead
	rts

; ---------------------------------------------------------------------------
; Routine to make both players swap positions
; and handle anything else that needs to be done
; ---------------------------------------------------------------------------
swap_players:
	lea	(teleport_swap_table).l,a3
	moveq	#(teleport_swap_table_end-teleport_swap_table)/6-1,d2	; amount of entries in table - 1

process_swap_table:
	movea.w	(a3)+,a1	; address for main character
	movea.w	(a3)+,a2	; address for sidekick
	move.w	(a3)+,d1	; amount of word length data to be swapped

-	; swap data between the main character and the sidekick d1 times
	move.w	(a1),d0
	move.w	(a2),(a1)+
	move.w	d0,(a2)+
	dbf	d1,-

	dbf	d2,process_swap_table	; process remaining entries in the list

	move.b	#AniIDSonAni_Run,(MainCharacter+prev_anim).w	; force Sonic's animation to restart
	move.b	#AniIDTailsAni_Run,(Sidekick+prev_anim).w	; force Tails' animation to restart
    if gameRevision>0
	move.b	#0,(MainCharacter+mapping_frame).w
	move.b	#0,(Sidekick+mapping_frame).w
    endif
	move.b	#-1,(Sonic_LastLoadedDPLC).w
	move.b	#-1,(Tails_LastLoadedDPLC).w
	move.b	#-1,(TailsTails_LastLoadedDPLC).w
	lea	(unk_F786).w,a1
	lea	(unk_F789).w,a2

	moveq	#2,d1
-	move.b	(a1),d0
	move.b	(a2),(a1)+
	move.b	d0,(a2)+
	dbf	d1,-

	subi.w	#$180,(Camera_Y_pos).w
	subi.w	#$180,(Camera_Y_pos_P2).w
	move.w	(MainCharacter+art_tile).w,d0
	andi.w	#drawing_mask,(MainCharacter+art_tile).w
	tst.w	(Sidekick+art_tile).w
	bpl.s	+
	ori.w	#high_priority,(MainCharacter+art_tile).w
+
	andi.w	#drawing_mask,(Sidekick+art_tile).w
	tst.w	d0
	bpl.s	+
	ori.w	#high_priority,(Sidekick+art_tile).w
+
	move.b	#1,(Camera_Max_Y_Pos_Changing).w
	lea	(Dynamic_Object_RAM).w,a1
	moveq	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d1

; process objects:
swap_loop_objects:
	cmpi.l	#Obj03,(a1) ; is it obj84 (pinball mode switcher)?
	beq.s	+ ; if yes, branch
	cmpi.l	#Obj03,(a1) ; is it obj03 (collision plane switcher)?
	bne.s	++ ; if not, branch further

+
	move.b	objoff_38(a1),d0
	move.b	objoff_39(a1),objoff_38(a1)
	move.b	d0,objoff_39(a1)

+
	cmpi.l	#ObjD6,(a1) ; is it objD6 (CNZ point giver)?
	bne.s	+ ; if not, branch
	move.l	objoff_34(a1),d0
	move.l	objoff_38(a1),objoff_34(a1)
	move.l	d0,objoff_38(a1)

+
	cmpi.l	#Obj85,(a1) ; is it obj85 (CNZ pressure spring)?
	bne.s	+ ; if not, branch
	move.b	objoff_3A(a1),d0
	move.b	objoff_3B(a1),objoff_3A(a1)
	move.b	d0,objoff_3B(a1)

+
	lea	next_object(a1),a1 ; look at next object ; a1=object
	dbf	d1,swap_loop_objects ; loop


	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#Obj38,(Sonic_Shield).w ; load Obj38 (shield) at $FFFFD180
	move.w	a1,(Sonic_Shield+parent).w
	move.L	#Obj35,(Sonic_InvincibilityStars).w ; load Obj35 (invincibility stars) at $FFFFD200
	move.w	a1,(Sonic_InvincibilityStars+parent).w
	btst	#2,status(a1)	; is Sonic spinning?
	bne.s	+		; if yes, branch
	move.b	#$13,y_radius(a1)	; set to standing height
	move.b	#9,x_radius(a1)
+
	btst	#3,status(a1)	; is Sonic on an object?
	beq.s	+		; if not, branch

	movea.w	interact(a1),a2

	bclr	#4,status(a2)
	bset	#3,status(a2)

+
	lea	(Sidekick).w,a1 ; a1=character
	move.l	#Obj38,(Tails_Shield).w ; load Obj38 (shield) at $FFFFD1C0
	move.w	a1,(Tails_Shield+parent).w
	move.l	#Obj35,(Tails_InvincibilityStars).w ; load Obj35 (invincibility) at $FFFFD300
	move.w	a1,(Tails_InvincibilityStars+parent).w
	btst	#2,status(a1)	; is Tails spinning?
	bne.s	+		; if yes, branch
	move.b	#$F,y_radius(a1)	; set to standing height
	move.b	#9,x_radius(a1)

+
	btst	#3,status(a1)	; is Tails on an object?
	beq.s	+		; if not, branch

	movea.w	interact(a1),a2

	bclr	#3,status(a2)
	bset	#4,status(a2)

+
	move.b	#$40,(Teleport_timer).w
	move.b	#1,(Teleport_flag).w
	move.w	#SndID_Teleport,d0
	jmp	(PlayMusic).l
; ===========================================================================
; Table listing all the addresses for players 1 and 2 that need to be swapped
; when a teleport monitor is destroyed
;byte_12C52:
teleport_swap_table:
; 	dc.w MainCharacter+x_pos,	Sidekick+x_pos,			$1B
; 	dc.w Camera_X_pos_last,		Camera_X_pos_last_P2,		  0
; 	dc.w Obj_respawn_index,		Obj_respawn_index_P2,		  0
; 	dc.w Obj_load_addr_right,	Obj_load_addr_2,		  3
; 	dc.w Sonic_top_speed,		Tails_top_speed,		  2
; 	dc.w Ring_start_addr,		Ring_start_addr_P2,		  1
; 	dc.w CNZ_Visible_bumpers_start,	CNZ_Visible_bumpers_start_P2,  3
; 	dc.w Camera_X_pos,		Camera_X_pos_P2,		 $F
; 	dc.w Camera_X_pos_coarse,	Camera_X_pos_coarse_P2,		  0
; 	dc.w Camera_Min_X_pos,		Tails_Min_X_pos,		  3
; 	dc.w Horiz_scroll_delay_val,	Horiz_scroll_delay_val_P2,	  1
; 	dc.w Camera_Y_pos_bias,		Camera_Y_pos_bias_P2,		  0
; 	dc.w Horiz_block_crossed_flag,	Horiz_block_crossed_flag_P2,	  3
; 	dc.w Scroll_flags,		Scroll_flags_P2,		  3
; 	dc.w Camera_RAM_copy,		Camera_P2_copy,			 $F
; 	dc.w Scroll_flags_copy,		Scroll_flags_copy_P2,		  3
; 	dc.w Camera_X_pos_diff,		Camera_X_pos_diff_P2,		  1
; 	dc.w Sonic_Pos_Record_Buf,	Tails_Pos_Record_Buf,		$7F
teleport_swap_table_end:
; ===========================================================================
; ---------------------------------------------------------------------------
; '?' Monitor
; doesn't actually do anything other than increase the player's monitor score
; ---------------------------------------------------------------------------
qmark_monitor:
	addq.w	#1,(a2)
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Holds icon in place for a while, then destroys it
; ---------------------------------------------------------------------------
;loc_12CC2:
Obj2E_Wait:
	subq.w	#1,anim_frame_duration(a0)
	bmi.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; animation script
; off_12CCE:
Ani_obj26:	offsetTable
		offsetTableEntry.w Ani_obj26_Static		;  0
		offsetTableEntry.w Ani_obj26_Sonic		;  1
		offsetTableEntry.w Ani_obj26_Tails		;  2
		offsetTableEntry.w Ani_obj26_Eggman		;  3
		offsetTableEntry.w Ani_obj26_Ring		;  4
		offsetTableEntry.w Ani_obj26_Shoes		;  5
		offsetTableEntry.w Ani_obj26_Shield		;  6
		offsetTableEntry.w Ani_obj26_Invincibility	;  7
		offsetTableEntry.w Ani_obj26_Teleport		;  8
		offsetTableEntry.w Ani_obj26_QuestionMark	;  9
		offsetTableEntry.w Ani_obj26_Broken		; $A
; byte_12CE4:
Ani_obj26_Static:
	dc.b	$01	; duration
	dc.b	$00	; frame number (which sprite table to use)
	dc.b	$01	; frame number
	dc.b	$FF	; terminator
; byte_12CE8:
Ani_obj26_Sonic:
	dc.b   1,  0,  2,  2,  1,  2,  2,$FF
; byte_12CF0:
Ani_obj26_Tails:
	dc.b   1,  0,  3,  3,  1,  3,  3,$FF
; byte_12CF8:
Ani_obj26_Eggman:
	dc.b   1,  0,  4,  4,  1,  4,  4,$FF
; byte_12D00:
Ani_obj26_Ring:
	dc.b   1,  0,  5,  5,  1,  5,  5,$FF
; byte_12D08:
Ani_obj26_Shoes:
	dc.b   1,  0,  6,  6,  1,  6,  6,$FF
; byte_12D10:
Ani_obj26_Shield:
	dc.b   1,  0,  7,  7,  1,  7,  7,$FF
; byte_12D18:
Ani_obj26_Invincibility:
	dc.b   1,  0,  8,  8,  1,  8,  8,$FF
; byte_12D20:
Ani_obj26_Teleport:
	dc.b   1,  0,  9,  9,  1,  9,  9,$FF
; byte_12D28:
Ani_obj26_QuestionMark:
	dc.b   1,  0, $A, $A,  1, $A, $A,$FF
; byte_12D30:
Ani_obj26_Broken:
	dc.b   2,  0,  1, $B,$FE,  1
	even
; ---------------------------------------------------------------------------------
; Sprite Mappings - Sprite table for monitor and monitor contents (26, ??)
; ---------------------------------------------------------------------------------
; MapUnc_12D36: MapUnc_obj26:
Obj26_MapUnc_12D36:	BINCLUDE "mappings/sprite/obj26.bin"
          even
; ===========================================================================

    if gameRevision<2
	nop
    endif



