
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 68 - Block with a spike that comes out of each side sequentially from MTZ
; ----------------------------------------------------------------------------
spikearoundblock_initial_x_pos =	objoff_34
spikearoundblock_initial_y_pos =	objoff_36
spikearoundblock_offset =		objoff_38 ; offset from the center
spikearoundblock_position =		objoff_3A ; 0 = retracted or expanding, 1 = expanded or retracting
spikearoundblock_waiting =		objoff_30 ; 0 = moving, 1 = waiting
; Sprite_27594:
Obj68:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj68_Index(pc,d0.w),d1
	jmp	Obj68_Index(pc,d1.w)
; ===========================================================================
; off_275A2:
Obj68_Index:	offsetTable
		offsetTableEntry.w Obj68_Init	; 0
		offsetTableEntry.w Obj68_Block	; 2
		offsetTableEntry.w Obj68_Spike	; 4
; ===========================================================================
; loc_275A8:
Obj68_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj68_Obj6D_MapUnc_27750,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSpikeBlock,3,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo31_Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	jsrto	(SingleObjLoad2).l, JmpTo12_SingleObjLoad2
	bne.s	+
	move.l	(a0),(a1) ; load obj68
	addq.b	#4,routine(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	x_pos(a1),spikearoundblock_initial_x_pos(a1)
	move.w	y_pos(a1),spikearoundblock_initial_y_pos(a1)
	move.l	mappings(a0),mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MtzSpike,1,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#$10,width_pixels(a1)
	move.b	#4,priority(a1)
	move.w	(Timer_frames).w,d0
	lsr.w	#6,d0
	move.w	d0,d1
	andi.w	#1,d0
	move.w	d0,spikearoundblock_position(a1)
	lsr.w	#1,d1
	add.b	subtype(a0),d1
	andi.w	#3,d1
	move.b	d1,routine_secondary(a1)
	move.b	d1,mapping_frame(a1)
	lea	(Obj68_CollisionFlags).l,a2
	move.b	(a2,d1.w),collision_flags(a1)
+
	move.b	#4,mapping_frame(a0)
; loc_2764A:
Obj68_Block:
	move.w	#$1B,d1
	move.w	#$10,d2
	move.w	#$11,d3
	move.w	x_pos(a0),d4
	jsrto	(SolidObject).l, JmpTo11_SolidObject
	jmpto	(MarkObjGone).l, JmpTo20_MarkObjGone
; ===========================================================================
; loc_27662:
Obj68_Spike:
	jsr	Obj68_Spike_Action
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	add.w	d0,d0
	move.w	Obj68_Spike_Directions(pc,d0.w),d1
	jsr	Obj68_Spike_Directions(pc,d1.w)
	move.w	spikearoundblock_initial_x_pos(a0),d0
	jmpto	(MarkObjGone2).l, JmpTo2_MarkObjGone2
; ===========================================================================
; off_2767E:
Obj68_Spike_Directions: offsetTable
	offsetTableEntry.w Obj68_Spike_Up	; 0
	offsetTableEntry.w Obj68_Spike_Right	; 1
	offsetTableEntry.w Obj68_Spike_Down	; 2
	offsetTableEntry.w Obj68_Spike_Left	; 3
; ===========================================================================
; These routines update the position of the spike.
; ===========================================================================
; loc_27686:
Obj68_Spike_Up:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	neg.w	d0
	add.w	spikearoundblock_initial_y_pos(a0),d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
; loc_27698:
Obj68_Spike_Right:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	add.w	spikearoundblock_initial_x_pos(a0),d0
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
; loc_276A8:
Obj68_Spike_Down:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	add.w	spikearoundblock_initial_y_pos(a0),d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================
; loc_276B8:
Obj68_Spike_Left:
	moveq	#0,d0
	move.b	spikearoundblock_offset(a0),d0
	neg.w	d0
	add.w	spikearoundblock_initial_x_pos(a0),d0
	move.w	d0,x_pos(a0)
	rts
; ===========================================================================
; loc_276CA:
Obj68_Spike_Action:
	tst.w	spikearoundblock_waiting(a0)
	beq.s	+
	move.b	(Timer_frames+1).w,d0
	andi.b	#$3F,d0
	bne.s	Obj68_Spike_Action_End
	clr.w	spikearoundblock_waiting(a0)
	tst.b	render_flags(a0)	; is the spike on the screen?
	bpl.s	+			; if not, branch
	move.w	#SndID_SpikesMove,d0
	jsr	(PlaySound).l
+
	tst.w	spikearoundblock_position(a0)
	beq.s	Obj68_Spike_Expanding
; Obj68_Spike_Retracting:
	subi.w	#$800,spikearoundblock_offset(a0)	; retract the spike
	bcc.s	Obj68_Spike_Action_End
	move.w	#0,spikearoundblock_offset(a0)
	move.w	#0,spikearoundblock_position(a0)
	move.w	#1,spikearoundblock_waiting(a0)
	addq.b	#1,routine_secondary(a0)
	andi.b	#3,routine_secondary(a0)
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.b	d0,mapping_frame(a0)
	move.b	Obj68_CollisionFlags(pc,d0.w),collision_flags(a0)
	rts
; ===========================================================================
; loc_2772A:
Obj68_Spike_Expanding:
	addi.w	#$800,spikearoundblock_offset(a0)	; expand the spike
	cmpi.w	#$2000,spikearoundblock_offset(a0)	; did it reach full expansion?
	blo.s	Obj68_Spike_Action_End			; if not, return
	move.w	#$2000,spikearoundblock_offset(a0)
	move.w	#1,spikearoundblock_position(a0)
	move.w	#1,spikearoundblock_waiting(a0)
; return_2774A:
Obj68_Spike_Action_End:
	rts
; ===========================================================================
; byte_2774C:
Obj68_CollisionFlags:
	dc.b $84	; 0
	dc.b $A6	; 1
	dc.b $84	; 2
	dc.b $A6	; 3
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj68_Obj6D_MapUnc_27750:	BINCLUDE "mappings/sprite/obj68.bin"
      even
