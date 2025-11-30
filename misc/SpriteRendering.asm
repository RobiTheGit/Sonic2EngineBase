; ---------------------------------------------------------------------------
; Subroutine to make an object move and fall downward increasingly fast
; This moves the object horizontally and vertically
; and also applies gravity to its speed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16380:
ObjectFall:
MoveSprite:
ObjectMoveAndFall:
	    	move.w	x_vel(a0),d0	; load x speed
		ext.l	d0
		lsl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,x_pos(a0)	; add x speed to x position	; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
		move.w	y_vel(a0),d0	; load y speed
		addi.w	#$38,y_vel(a0)	; increase vertical speed (apply gravity)
		ext.l	d0
		lsl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
		add.l	d0,y_pos(a0)	; add old y speed to y position	; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
	rts
; End of function ObjectMoveAndFall
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; ---------------------------------------------------------------------------
; Subroutine translating object speed to update object position
; This moves the object horizontally and vertically
; but does not apply gravity to it
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_163AC:
SpeedToPos:
MoveSprite2:
ObjectMove:
	move.w	x_vel(a0),d0	; load horizontal speed
	ext.l	d0
	lsl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,x_pos(a0)	; add to x-axis position	; note this affects the subpixel position x_sub(a0) = 2+x_pos(a0)
	move.w	y_vel(a0),d0	; load vertical speed
	ext.l	d0
	lsl.l	#8,d0		; shift velocity to line up with the middle 16 bits of the 32-bit position
	add.l	d0,y_pos(a0)	; add to y-axis position	; note this affects the subpixel position y_sub(a0) = 2+y_pos(a0)
	rts
; End of function ObjectMove


; ---------------------------------------------------------------------------
; Routines to mark an enemy/monitor/ring/platform as destroyed
; ---------------------------------------------------------------------------

; ===========================================================================
; input: a0 = the object
; loc_163D2:
MarkObjGone:
	;tst.w	(Two_player_mode).w	; is it two player mode?
	;beq.s	+			; if not, branch
	;bra.w	DisplaySprite
;+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.w	+
	bra.w	DisplaySprite

+	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: d0 = the object's x position
; loc_1640A:
MarkObjGone2:
	;tst.w	(Two_player_mode).w
	;beq.s	+
	;bra.w	DisplaySprite
;+
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: a0 = the object
; does nothing instead of calling DisplaySprite in the case of no deletion
; loc_1643E:
MarkObjGone3:
	;tst.w	(Two_player_mode).w
	;beq.s	+
	;rts
;+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.s	+
	rts
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
	bra.w	DeleteObject
; ===========================================================================
; input: a0 = the object
; loc_16472:
MarkObjGone_P1:
	;tst.w	(Two_player_mode).w
	;bne.s	MarkObjGone_P2
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$80+320+$40+$80,d0	; This gives an object $80 pixels of room offscreen before being unloaded (the $40 is there to round up 320 to a multiple of $80)
	bhi.w	+
	bra.w	DisplaySprite
+
	lea	(Object_Respawn_Table).w,a2
	moveq	#0,d0
	move.b	respawn_index(a0),d0
	beq.s	+
	bclr	#7,2(a2,d0.w)
+
;	bra.w	DeleteObject
; ---------------------------------------------------------------------------
; input: a0 = the object
; loc_164A6:
;MarkObjGone_P2:
;	move.w	x_pos(a0),d0
;	andi.w	#$FF00,d0
;	move.w	d0,d1
;	sub.w	(Camera_X_pos_coarse).w,d0
;	cmpi.w	#$300,d0
;	bhi.w	+
;	bra.w	DisplaySprite
;+
;	sub.w	(Camera_X_pos_coarse_P2).w,d1
;	cmpi.w	#$300,d1
;	bhi.w	+
;	bra.w	DisplaySprite
;+
;	lea	(Object_Respawn_Table).w,a2
;	moveq	#0,d0
;	move.b	respawn_index(a0),d0
;	beq.s	+
;	bclr	#7,2(a2,d0.w)
;+
;	bra.w	DeleteObject ; useless branch...

; ---------------------------------------------------------------------------
; Subroutine to delete an object
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; freeObject:
Delete_Current_Sprite:
DeleteObject:
	movea.l	a0,a1

; sub_164E8:
DeleteObject2:
	moveq	#0,d1

	moveq	#bytesToLcnt(next_object),d0 ; we want to clear up to the next object
	; delete the object by setting all of its bytes to 0
-	move.l	d1,(a1)+
	dbf	d0,-
    if object_size&3
	move.w	d1,(a1)+
    endif

	rts
; End of function DeleteObject2





Draw_Sprite:
		lea	(Sprite_Table_Input).w,a1
		adda.w	priority(a0),a1

loc_1ABCE:
		cmpi.w	#$7E,(a1)
		bhs.s	loc_1ABDC
		addq.w	#2,(a1)
		adda.w	(a1),a1
		move.w	a0,(a1)

locret_1ABDA:
		rts
; ---------------------------------------------------------------------------

loc_1ABDC:
		cmpa.w	#Sprite_table_input+($80*7),a1
		beq.s	locret_1ABDA
		adda.w	#$80,a1
		bra.s	loc_1ABCE
; End of function Draw_Sprite
; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16512:
DisplaySprite:
	lea	(Sprite_Table_Input).w,a1
	moveq	#0,d0
	move.b	priority(a0),d0
	add.w	d0,d0
	move.w	PriorityId(pc,d0.w),d0     ; get values
	adda.w	d0,a1
	cmpi.w	#$7E,(a1)
	bcc.s	return_16510
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

return_16510:
	rts
; End of function DisplaySprite
PriorityId:	dc.w	0
		dc.w	$80
		dc.w	$100
		dc.w	$180
		dc.w	$200
		dc.w	$280
		dc.w	$300
		dc.w	$380
		even
; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16512:
DisplaySprite2:
	lea	(Sprite_Table_Input).w,a2
	moveq	#0,d0
	move.b	priority(a1),d0
	add.w	d0,d0
	move.w	PriorityId(pc,d0.w),d0     ; get values

	adda.w	d0,a2
	cmpi.w	#$7E,(a2)
	bcc.s	return_1652E
	addq.w	#2,(a2)
	adda.w	(a2),a2
	move.w	a1,(a2)

return_1652E:
	rts
; End of function DisplaySprite2
; End of function DisplaySprite2

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; and d0 is already (priority/2)&$380
; ---------------------------------------------------------------------------

; loc_16530:
DisplaySprite3:
	lea	(Sprite_Table_Input).w,a1
	adda.w	d0,a1
	cmpi.w	#$7E,(a1)
	bhs.s	return_16542
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

return_16542:
	rts

; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16544:
AnimateSprite:
	moveq	#0,d0
	move.b	anim(a0),d0		; move animation number to d0
	cmp.b	prev_anim(a0),d0	; is animation set to change?
	beq.s	Anim_Run		; if not, branch
	move.b	d0,prev_anim(a0)	; set prev anim to current current
	clr.b	anim_frame(a0)	; reset animation
	clr.b	anim_frame_duration(a0)	; reset frame duration
; loc_16560:
Anim_Run:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	Anim_Wait	; if time remains, branch
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),anim_frame_duration(a0)	; load frame duration
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	bmi.s	Anim_End_FF		; if animation is complete, branch
; loc_1657C:
Anim_Next:
	andi.b	#$7F,d0			; clear sign bit
	move.b	d0,mapping_frame(a0)	; load sprite number
	move.b	status(a0),d1		;* match the orientaion dictated by the object
	andi.b	#3,d1			;* with the orientation used by the object engine
	andi.b	#$FC,render_flags(a0)	;*
	or.b	d1,render_flags(a0)	;*
	addq.b	#1,anim_frame(a0)	; next frame number
; return_1659A:
Anim_Wait:
	rts
; ===========================================================================
; loc_1659C:
Anim_End_FF:
	addq.b	#1,d0		; is the end flag = $FF ?
	bne.s	Anim_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165AC:
Anim_End_FE:
	addq.b	#1,d0	; is the end flag = $FE ?
	bne.s	Anim_End_FD	; if not, branch
	move.b	2(a1,d1.w),d0	; read the next byte in the script
	sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
	sub.b	d0,d1
	move.b	1(a1,d1.w),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165C0:
Anim_End_FD:
	addq.b	#1,d0		; is the end flag = $FD ?
	bne.s	Anim_End_FC	; if not, branch
	move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
	rts
; ===========================================================================
; loc_165CC:
Anim_End_FC:
	addq.b	#1,d0	; is the end flag = $FC ?
	bne.s	Anim_End_FB	; if not, branch
	addq.b	#2,routine(a0)	; jump to next routine
	clr.b	anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	rts
; ===========================================================================
; loc_165E0:
Anim_End_FB:
	addq.b	#1,d0	; is the end flag = $FB ?
	bne.s	Anim_End_FA	; if not, branch
	clr.b	anim_frame(a0)	; reset animation
	clr.b	routine_secondary(a0)	; reset 2nd routine counter
	rts
; ===========================================================================
; loc_165F0:
Anim_End_FA:
	addq.b	#1,d0	; is the end flag = $FA ?
	bne.s	Anim_End_F9	; if not, branch
	addq.b	#2,routine_secondary(a0)	; jump to next routine
	rts
; ===========================================================================
; loc_165FA:
Anim_End_F9:
	addq.b	#1,d0	; is the end flag = $F9 ?
	bne.s	Anim_End	; if not, branch
	addq.b	#2,objoff_2E(a0)	; Actually obj89_arrow_routine
; return_16602:
Anim_End:
	rts
; End of function AnimateSprite

Render_Sprites:
	   ; 	tst.w	(Competition_mode).w
	;	bne.w	Render_Sprites_CompetitionMode
		moveq	#$4F,d7
		moveq	#0,d6
		lea	(Sprite_Table_Input).w,a5
		lea	(Camera_X_pos_copy).w,a3
		lea	(Sprite_Table).w,a6
	;	tst.b	(Level_started_flag).w
	;	beq.s	loc_1AD4A
	;	jsr	(BuildHUD).l
	;	jsr	(BuildRings).l

loc_1AD4A:
		tst.w	(a5)
		beq.w	Render_Sprites_NextLevel
		lea	2(a5),a4

loc_1AD54:
		movea.w	(a4)+,a0 ; a0=object
		andi.b	#$7F,render_flags(a0)	; clear on-screen flag
		move.b	render_flags(a0),d6
		move.w	x_pos(a0),d0
		move.w	y_pos(a0),d1
		btst	#6,d6		; is the multi-draw flag set?
		bne.w	loc_1AE58	; if it is, branch
		btst	#2,d6		; is this to be positioned by screen coordinates?
		beq.s	loc_1ADB2	; if it is, branch
		;cmpi.b  #$9A,d6  ; is it an object that doesnt need rendering ?
		;beq.w   BuildS2FragmentSprite
		tst.b   width_pixels(a0) ; is there a wdth ?
		bne.s   use_wdth          ; no then use collsion size data
		move.b	x_radius(a0),width_pixels(a0)
use_wdth:
		moveq	#0,d2
		move.b	width_pixels(a0),d2
Render_x_Object:
		sub.w	(a3),d0
		move.w	d0,d3
		add.w	d2,d3		; is the object right edge to the left of the screen?
		bmi.s	Render_Sprites_NextObj	; if it is, branch
		move.w	d0,d3
		sub.w	d2,d3
		cmpi.w	#320,d3		; is the object left edge to the right of the screen?
		bge.s	Render_Sprites_NextObj	; if it is, branch
		addi.w	#128,d0
		sub.w	4(a3),d1
		tst.b   height_pixels(a0) ; has rendering sprite been filled up aka no more free ssts flag
		bne.s   use_Height
	       	move.b	y_radius(a0),height_pixels(a0)
use_Height
		move.b	height_pixels(a0),d2
DoNormal_Render:
		add.w	d2,d1
		and.w	(Screen_Y_wrap_value).w,d1
		move.w	d2,d3
		add.w	d2,d2
		addi.w	#224,d2
		cmp.w	d2,d1
		bhs.s	Render_Sprites_NextObj	; if the object is below the screen
		addi.w	#128,d1
		sub.w	d3,d1

loc_1ADB2:
		ori.b	#$80,render_flags(a0)	; set on-screen flag
		tst.w	d7
		bmi.s	Render_Sprites_NextObj
		movea.l	mappings(a0),a1
		moveq	#0,d4
		btst	#5,d6		; is the static mappings flag set?
		bne.s	loc_1ADD8	; if it is, branch
		move.b	mapping_frame(a0),d4
		add.w	d4,d4
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4		; get number of pieces
		bmi.s	Render_Sprites_NextObj	; if there are 0 pieces, branch

loc_1ADD8:
		move.w	art_tile(a0),d5
		jsr	sub_1AF6C(pc)

Render_Sprites_NextObj:
		subq.w	#2,(a5)		; decrement object count
		bne.w	loc_1AD54	; if there are objects left, repeat

Render_Sprites_NextLevel:
;		cmpa.l	#Sprite_Table_Input,a5
;		bne.s	+
;		jsr	(sub_1CB68).l

;+
		lea	$80(a5),a5	; load next priority level
		cmpa.l	#Player_1,a5
		blo.w	loc_1AD4A
		move.w	d7,d6
		bmi.s	loc_1AE18
		moveq	#0,d0

loc_1AE10:
		move.w	d0,(a6)
		addq.w	#8,a6
		dbf	d7,loc_1AE10

loc_1AE18:
		subi.w	#$4F,d6
		neg.w	d6
		move.b	d6,(Sprites_drawn).w
		tst.w	(Spritemask_flag).w
		beq.s	locret_1AE56
		cmpi.b	#6,(Player_1+routine).w
		bhs.s	loc_1AE34
		clr.w	(Spritemask_flag).w

loc_1AE34:
		lea	(Sprite_Table-4).w,a0
		move.w	#$7C0,d0
		moveq	#$4E,d1

loc_1AE3E:
		addq.w	#8,a0
		cmp.w	(a0),d0
		dbeq	d1,loc_1AE3E
		bne.s	locret_1AE56
		move.w	#1,2(a0)
		clr.w	art_tile(a0)
		subq.w	#1,d1
		bpl.s	loc_1AE3E

locret_1AE56:
		rts
; ---------------------------------------------------------------------------

loc_1AE58:
		btst	#2,d6		; is this to be positioned by screen coordinates?
		bne.s	loc_1AEA2	; if it is, branch
		moveq	#0,d2

		; check if object is within X bounds
		move.b	width_pixels(a0),d2
		subi.w	#128,d0
		move.w	d0,d3
		add.w	d2,d3
		bmi.w	Render_Sprites_NextObj
		move.w	d0,d3
		sub.w	d2,d3
		cmpi.w	#320,d3
		bge.w	Render_Sprites_NextObj
		addi.w	#128,d0

		; check if object is within Y bounds
		move.b	height_pixels(a0),d2
		subi.w	#128,d1
		move.w	d1,d3
		add.w	d2,d3
		bmi.w	Render_Sprites_NextObj
		move.w	d1,d3
		sub.w	d2,d3
		cmpi.w	#224,d3
		bge.w	Render_Sprites_NextObj
		addi.w	#128,d1
		bra.s	loc_1AEE4
; ---------------------------------------------------------------------------

loc_1AEA2:
		moveq	#0,d2
		move.b	width_pixels(a0),d2
		sub.w	(a3),d0
		move.w	d0,d3
		add.w	d2,d3
		bmi.w	Render_Sprites_NextObj
		move.w	d0,d3
		sub.w	d2,d3
		cmpi.w	#$140,d3
		bge.w	Render_Sprites_NextObj
		addi.w	#$80,d0
		sub.w	4(a3),d1 ;???????
		move.b	height_pixels(a0),d2
		add.w	d2,d1
		and.w	(Screen_Y_wrap_value).w,d1
		move.w	d2,d3
		add.w	d2,d2
		addi.w	#$E0,d2
		cmp.w	d2,d1
		bhs.w	Render_Sprites_NextObj
		addi.w	#$80,d1
		sub.w	d3,d1

loc_1AEE4:
		ori.b	#$80,4(a0)
		tst.w	d7
		bmi.w	Render_Sprites_NextObj
		move.w	$A(a0),d5
		movea.l	$C(a0),a2
		moveq	#0,d4
		move.b	$22(a0),d4
		beq.s	loc_1AF1C
		add.w	d4,d4
		lea	(a2),a1
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	loc_1AF1C
		move.w	d6,d3
		jsr	sub_1B070(pc)
		move.w	d3,d6
		tst.w	d7
		bmi.w	Render_Sprites_NextObj

loc_1AF1C:
		move.w	mainspr_childsprites_S3K(a0),d3
		subq.w	#1,d3
		bcs.w	Render_Sprites_NextObj
		lea	$18(a0),a0

loc_1AF2A:
		move.w	(a0)+,d0
		move.w	(a0)+,d1
		btst	#2,d6
		beq.s	loc_1AF46
		sub.w	(a3),d0
		addi.w	#$80,d0
		sub.w	4(a3),d1
		addi.w	#$80,d1
		and.w	(Screen_Y_wrap_value).w,d1

loc_1AF46:
		addq.w	#1,a0
		moveq	#0,d4
		move.b	(a0)+,d4
		add.w	d4,d4
		lea	(a2),a1
		adda.w	(a1,d4.w),a1
		move.w	(a1)+,d4
		subq.w	#1,d4
		bmi.s	loc_1AF62
		move.w	d6,-(sp)
		jsr	sub_1B070(pc)
		move.w	(sp)+,d6

loc_1AF62:
     ;           cmpi.l  #Obj15,(a0)
    ;            beq.s   +
   ;             swap	d0
  ;       	dbf	d0,loc_1AF2A
 ;        	rts
;+
		tst.w	d7
		dbmi	d3,loc_1AF2A
		bra.w	Render_Sprites_NextObj
; End of function Render_Sprites


; =============== S U B R O U T I N E =======================================


sub_1AF6C:
		lsr.b	#1,d6
		bcs.s	loc_1AF9E
		lsr.b	#1,d6
		bcs.w	loc_1B038

loc_1AF76:
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d1,d2
		move.w	d2,(a6)+
		move.b	(a1)+,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		add.w	d0,d2
		andi.w	#$1FF,d2
		bne.s	loc_1AF94
		addq.w	#1,d2

loc_1AF94:
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1AF76
		rts
; ---------------------------------------------------------------------------

loc_1AF9E:
		lsr.b	#1,d6
		bcs.s	loc_1AFE8

loc_1AFA2:
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d1,d2
		move.w	d2,(a6)+
		move.b	(a1)+,d6
		move.b	d6,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$800,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		neg.w	d2
		move.b	byte_1AFD8(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		andi.w	#$1FF,d2
		bne.s	loc_1AFCE
		addq.w	#1,d2

loc_1AFCE:
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1AFA2
		rts
; ---------------------------------------------------------------------------
byte_1AFD8:	dc.b 8
		dc.b 8
		dc.b 8
		dc.b 8
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $18
		dc.b $18
		dc.b $18
		dc.b $18
		dc.b $20
		dc.b $20
		dc.b $20
		dc.b $20
; ---------------------------------------------------------------------------

loc_1AFE8:
		move.b	(a1)+,d2
		ext.w	d2
		neg.w	d2
		move.b	(a1),d6
		move.b	byte_1B028(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2
		move.w	d2,(a6)+
		move.b	(a1)+,d6
		move.b	d6,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$1800,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		neg.w	d2
		move.b	byte_1AFD8(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		andi.w	#$1FF,d2
		bne.s	loc_1B01E
		addq.w	#1,d2

loc_1B01E:
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1AFE8
		rts
; ---------------------------------------------------------------------------
byte_1B028:	dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
		dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
		dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
		dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
; ---------------------------------------------------------------------------

loc_1B038:
		move.b	(a1)+,d2
		ext.w	d2
		neg.w	d2
		move.b	(a1)+,d6
		move.b	d6,2(a6)
		move.b	byte_1B028(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2
		move.w	d2,(a6)+
		addq.w	#2,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$1000,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		add.w	d0,d2
		andi.w	#$1FF,d2
		bne.s	loc_1B066
		addq.w	#1,d2

loc_1B066:
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1B038
		rts
; End of function sub_1AF6C


; =============== S U B R O U T I N E =======================================


sub_1B070:
		lsr.b	#1,d6
		bcs.s	loc_1B0C2
		lsr.b	#1,d6
		bcs.w	loc_1B19C

loc_1B07A:
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B0BA
		cmpi.w	#$160,d2
		bhs.s	loc_1B0BA
		move.w	d2,(a6)+
		move.b	(a1)+,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B0B2
		cmpi.w	#$1C0,d2
		bhs.s	loc_1B0B2
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1B07A
		rts
; ---------------------------------------------------------------------------

loc_1B0B2:
		subq.w	#6,a6
		dbf	d4,loc_1B07A
		rts
; ---------------------------------------------------------------------------

loc_1B0BA:
		addq.w	#5,a1
		dbf	d4,loc_1B07A
		rts
; ---------------------------------------------------------------------------

loc_1B0C2:
		lsr.b	#1,d6
		bcs.s	loc_1B12C

loc_1B0C6:
		move.b	(a1)+,d2
		ext.w	d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B114
		cmpi.w	#$160,d2
		bhs.s	loc_1B114
		move.w	d2,(a6)+
		move.b	(a1)+,d6
		move.b	d6,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$800,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		neg.w	d2
		move.b	byte_1B11C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B10C
		cmpi.w	#$1C0,d2
		bhs.s	loc_1B10C
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1B0C6
		rts
; ---------------------------------------------------------------------------

loc_1B10C:
		subq.w	#6,a6
		dbf	d4,loc_1B0C6
		rts
; ---------------------------------------------------------------------------

loc_1B114:
		addq.w	#5,a1
		dbf	d4,loc_1B0C6
		rts
; ---------------------------------------------------------------------------
byte_1B11C:	dc.b 8
		dc.b 8
		dc.b 8
		dc.b 8
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $10
		dc.b $18
		dc.b $18
		dc.b $18
		dc.b $18
		dc.b $20
		dc.b $20
		dc.b $20
		dc.b $20
; ---------------------------------------------------------------------------

loc_1B12C:
		move.b	(a1)+,d2
		ext.w	d2
		neg.w	d2
		move.b	(a1),d6
		move.b	byte_1B18C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B184
		cmpi.w	#$160,d2
		bhs.s	loc_1B184
		move.w	d2,(a6)+
		move.b	(a1)+,d6
		move.b	d6,(a6)+
		addq.w	#1,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$1800,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		neg.w	d2
		move.b	byte_1B11C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B17C
		cmpi.w	#$1C0,d2
		bhs.s	loc_1B17C
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1B12C
		rts
; ---------------------------------------------------------------------------

loc_1B17C:
		subq.w	#6,a6
		dbf	d4,loc_1B12C
		rts
; ---------------------------------------------------------------------------

loc_1B184:
		addq.w	#5,a1
		dbf	d4,loc_1B12C
		rts
; ---------------------------------------------------------------------------
byte_1B18C:	dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
		dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
		dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
		dc.b 8
		dc.b $10
		dc.b $18
		dc.b $20
; ---------------------------------------------------------------------------

loc_1B19C:
		move.b	(a1)+,d2
		ext.w	d2
		neg.w	d2
		move.b	(a1)+,d6
		move.b	d6,2(a6)
		move.b	byte_1B18C(pc,d6.w),d6
		sub.w	d6,d2
		add.w	d1,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B1EC
		cmpi.w	#$160,d2
		bhs.s	loc_1B1EC
		move.w	d2,(a6)+
		addq.w	#2,a6
		move.w	(a1)+,d2
		add.w	d5,d2
		eori.w	#$1000,d2
		move.w	d2,(a6)+
		move.w	(a1)+,d2
		add.w	d0,d2
		cmpi.w	#$60,d2
		bls.s	loc_1B1E4
		cmpi.w	#$1C0,d2
		bhs.s	loc_1B1E4
		move.w	d2,(a6)+
		subq.w	#1,d7
		dbmi	d4,loc_1B19C
		rts
; ---------------------------------------------------------------------------

loc_1B1E4:
		subq.w	#6,a6
		dbf	d4,loc_1B19C
		rts
; ---------------------------------------------------------------------------

loc_1B1EC:
		addq.w	#4,a1
		dbf	d4,loc_1B19C
		rts
; End of function sub_1B070

; ---------------------------------------------------------------------------


Render_Sprites_CompetitionMode:
      rts
; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) to proper Megadrive sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16604:
BuildSprites:
	lea	(Sprite_Table).w,a2
	moveq	#0,d5
	moveq	#0,d4
	tst.b	(Level_started_flag).w
	beq.s	+
	jsrto	(BuildHUD).l, JmpTo_BuildHUD
	bsr.w	BuildRings
+
	lea	(Sprite_Table_Input).w,a4
	moveq	#7,d7	; 8 priority levels
; loc_16628:
BuildSprites_LevelLoop:
	tst.w	(a4)	; does this level have any objects?
	beq.w	BuildSprites_NextLevel	; if not, check the next one
	moveq	#2,d6
; loc_16630:
BuildSprites_ObjLoop:
	movea.w	(a4,d6.w),a0 ; a0=object
	andi.b	#$7F,render_flags(a0)	; clear on-screen flag
	move.b	render_flags(a0),d0
	move.b	d0,d4
	btst	#6,d0	; is the multi-draw flag set?
	bne.w	BuildSprites_MultiDraw	; if it is, branch
	andi.w	#$C,d0	; is this to be positioned by screen coordinates?
	beq.s	BuildSprites_ScreenSpaceObj	; if it is, branch
	;lea	(Camera_X_pos_copy).w,a1
	moveq	#0,d0
	move.b	width_pixels(a0),d0
	move.w	x_pos(a0),d3
	sub.w	Camera_X_pos_copy.w,d3
	move.w	d3,d1
	add.w	d0,d1	; is the object right edge to the left of the screen?
	bmi.w	BuildSprites_NextObj	; if it is, branch
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1	; is the object left edge to the right of the screen?
	bge.w	BuildSprites_NextObj	; if it is, branch
	addi.w	#128,d3
	btst	#4,d4		; is the accurate Y check flag set?
	beq.s	BuildSprites_ApproxYCheck	; if not, branch
	moveq	#0,d0
	move.b	y_radius(a0),d0
	move.w	y_pos(a0),d2
	sub.w	Camera_Y_pos_copy.w,d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.s	BuildSprites_NextObj	; if the object is above the screen
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.s	BuildSprites_NextObj	; if the object is below the screen
	addi.w	#128,d2
	bra.s	BuildSprites_DrawSprite
; ===========================================================================
; loc_166A6:
BuildSprites_ScreenSpaceObj:
	move.w	y_pixel(a0),d2
	move.w	x_pixel(a0),d3
	bra.s	BuildSprites_DrawSprite
; ===========================================================================
; loc_166B0:
BuildSprites_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	Camera_Y_pos_copy.w,d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	cmpi.w	#-32+128,d2	; assume Y radius to be 32 pixels
	blo.s	BuildSprites_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_NextObj
; loc_166CC:
BuildSprites_DrawSprite:
	movea.l	mappings(a0),a1
	moveq	#0,d1
	btst	#5,d4	; is the static mappings flag set?
	bne.s	+	; if it is, branch
	move.b	mapping_frame(a0),d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1	; get number of pieces
	bmi.s	++	; if there are 0 pieces, branch
+
	bsr.w	DrawSprite	; draw the sprite
+
	ori.b	#$80,render_flags(a0)	; set on-screen flag
; loc_166F2:
BuildSprites_NextObj:
	addq.w	#2,d6	; load next object
	subq.w	#2,(a4)	; decrement object count
	bne.w	BuildSprites_ObjLoop	; if there are objects left, repeat
; loc_166FA:
BuildSprites_NextLevel:
	lea	$80(a4),a4	; load next priority level
	dbf	d7,BuildSprites_LevelLoop	; loop
	move.b	d5,(Sprite_count).w
	cmpi.b	#80,d5	; was the sprite limit reached?
	beq.s	+	; if it was, branch
	move.l	#0,(a2)	; set link field to 0
	rts
+
	move.b	#0,-5(a2)	; set link field to 0
	rts
; ===========================================================================
; loc_1671C:
BuildSprites_MultiDraw:
	;move.l	a4,-(sp)
;	lea	(Camera_X_pos).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0

	; check if object is within X bounds
	move.b	mainspr_width(a0),d0	; load pixel width
	move.w	x_pos(a0),d3
	sub.w	Camera_X_pos_copy.w,d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_MultiDraw_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.w	BuildSprites_MultiDraw_NextObj
	addi.w	#128,d3

	; check if object is within Y bounds
	btst	#4,d4
	beq.s	+
	moveq	#0,d0
	move.b	mainspr_height(a0),d0	; load pixel height
	move.w	y_pos(a0),d2
	sub.w	Camera_Y_pos_copy.w,d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_MultiDraw_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_MultiDraw_NextObj
	addi.w	#128,d2
	bra.s	++
+
	move.w	y_pos(a0),d2
	sub.w	Camera_Y_pos_copy,d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_MultiDraw_NextObj
+
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1	; get current frame
	beq.s	+
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite	; draw the sprite
	move.w	(sp)+,d4
+
	ori.b	#$80,render_flags(a0)	; set onscreen flag
	lea	sub2_x_pos(a0),a6
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0	; get child sprite count
	subq.w	#1,d0		; if there are 0, go to next object
	bcs.s	BuildSprites_MultiDraw_NextObj

-	swap	d0
	move.w	(a6)+,d3	; get X pos
	sub.w	Camera_X_pos_copy.w,d3
	addi.w	#128,d3
	move.w	(a6)+,d2	; get Y pos
	sub.w	Camera_Y_pos_copy,d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1	; get mapping frame
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite
	move.w	(sp)+,d4
+
	swap	d0
	dbf	d0,-	; repeat for number of child sprites
; loc_16804:
BuildSprites_MultiDraw_NextObj:
	;movea.l	(sp)+,a4
	bra.w	BuildSprites_NextObj
; End of function BuildSprites


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1680A:
ChkDrawSprite:
	cmpi.b	#80,d5		; has the sprite limit been reached?
	blo.s	DrawSprite_Cont	; if it hasn't, branch
	rts	; otherwise, return
; End of function ChkDrawSprite


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16812:
DrawSprite:
	movea.w	art_tile(a0),a3
	cmpi.b	#80,d5
	bhs.s	DrawSprite_Done
; loc_1681C:
DrawSprite_Cont:
	btst	#0,d4	; is the sprite to be X-flipped?
	bne.s	DrawSprite_FlipX	; if it is, branch
	btst	#1,d4	; is the sprite to be Y-flipped?
	bne.w	DrawSprite_FlipY	; if it is, branch
; loc__1682A:
DrawSprite_Loop:
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set sprite size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0	; avoid activating sprite masking
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,DrawSprite_Loop	; repeat for next sprite
; return_16852:
DrawSprite_Done:
	rts
; ===========================================================================
; loc_16854:
DrawSprite_FlipX:
	btst	#1,d4	; is it to be Y-flipped as well?
	bne.w	DrawSprite_FlipXY	; if it is, branch

-	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4	; store size for later use
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$800,d0	; toggle X flip flag
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0	; negate X offset
	move.b	CellOffsets_XFlip(pc,d4.w),d4
	sub.w	d4,d0	; subtract sprite size
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168B4:
DrawSprite_FlipY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1000,d0	; toggle Y flip flag
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,DrawSprite_FlipY
	rts
; ===========================================================================
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip2:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168FC:
DrawSprite_FlipXY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1800,d0	; toggle X and Y flip flags
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0
	move.b	CellOffsets_XFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_FlipXY
	rts
; End of function DrawSprite

; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip2:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; ===========================================================================
