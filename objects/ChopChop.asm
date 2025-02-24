
; ----------------------------------------------------------------------------
; Object 91 - Chop Chop (piranha/shark badnik) from ARZ
; ----------------------------------------------------------------------------
; OST Variables:
Obj91_move_timer	= objoff_2E	; time to wait before turning around
Obj91_bubble_timer	= objoff_30	; time to wait before producing a bubble
; Sprite_36DAC:
Obj91:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj91_Index(pc,d0.w),d1
	jmp	Obj91_Index(pc,d1.w)
; ===========================================================================
; off_36DBA:
Obj91_Index:	offsetTable
		offsetTableEntry.w Obj91_Init		; 0 - Initialize object variables
		offsetTableEntry.w Obj91_Main		; 2 - Moving back and forth until Sonic or Tails approach
		offsetTableEntry.w Obj91_Waiting	; 4 - Stopped, opening and closing mouth
		offsetTableEntry.w Obj91_Charge		; 6 - Charging at Sonic or Tails
; ===========================================================================
; loc_36DC2:
Obj91_Init:
	jsr	LoadSubObject
	move.w	#$200,Obj91_move_timer(a0)
	move.w	#$50,Obj91_bubble_timer(a0)
	moveq	#$40,d0		; enemy speed
	btst	#0,status(a0)	; is enemy facing left?
	bne.s	+		; if not, branch
	neg.w	d0		; else reverse movement direction
+
	move.w	d0,x_vel(a0)	; set speed
	rts
; ===========================================================================
; loc_36DE4:
Obj91_Main:
	subq.b	#1,Obj91_bubble_timer(a0)
	bne.s	+			; branch, if timer isn't done counting down
	jsr	Obj91_MakeBubble
+
	subq.w	#1,Obj91_move_timer(a0)
	bpl.s	+			; branch, if timer isn't done counting down
	move.w	#$200,Obj91_move_timer(a0)	; else, reset timer...
	bchg	#0,status(a0)		; ... change direction...
	bchg	#0,render_flags(a0)
	neg.w	x_vel(a0)		; ... and reverse movement
+
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jsr	Obj_GetOrientationToPlayer
	move.w	d2,d4
	move.w	d3,d5
	jsr	Obj91_TestCharacterPos	; are Sonic or Tails close enough to attack?
	bne.s	Obj91_PrepareCharge	; if yes, prepare to charge at them
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36E20
Obj91_PrepareCharge:
	addq.b	#2,routine(a0)	; => Obj91_Waiting
	move.b	#$10,Obj91_move_timer(a0)	; time to wait before charging at the player
	clr.w	x_vel(a0)		; stop movement
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36E32:
Obj91_Waiting:
	subq.b	#1,Obj91_move_timer(a0)
	bmi.s	Obj91_MoveTowardsPlayer		; branch, if wait time is over
	jmp	Obj91_Animate
; ===========================================================================
; loc_36E3C:
Obj91_MoveTowardsPlayer:
	addq.b	#2,routine(a0)	; => Obj91_Charge
	jsr	Obj_GetOrientationToPlayer
	lsr.w	#1,d0		; set speed based on closest character
	move.b	Obj91_HorizontalSpeeds(pc,d0.w),x_vel(a0)	; horizontal
	addi.w	#$10,d3
	cmpi.w	#$20,d3		; is closest character withing $10 pixels above or $F pixels below?
	blo.s	+		; if not, branch
	lsr.w	#1,d1		; set speed based on closest character
	move.b	Obj91_VerticalSpeeds(pc,d1.w),1+y_vel(a0)	; vertical
+
	jmp	Obj91_Animate
; ===========================================================================
; byte_36E62:
Obj91_HorizontalSpeeds:
	dc.b  -2	; 0 - player is left from object -> move left
	dc.b   2	; 1 - player is right from object -> move right
; byte_36E64:
Obj91_VerticalSpeeds:
	dc.b $80	; 0 - player is above object -> ... move down?
	dc.b $80	; 1 - player is below object -> move down
; ===========================================================================
; loc_36E66:
Obj91_Charge:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
; loc_36E6A:
Obj91_Animate:
	lea	(Ani_obj91).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36E78:
Obj91_MakeBubble:
	move.w	#$50,Obj91_bubble_timer(a0)	; reset timer
	jsrto	(SingleObjLoad).l, JmpTo19_SingleObjLoad
	bne.s	return_36EB0
	move.l	#Obj90,(a1) ; load obj
	move.b	#6,subtype(a1) ; <== Obj90_SubObjData2
	move.w	x_pos(a0),x_pos(a1)	; align objects horizontally
	moveq	#$14,d0			; load x-offset
	btst	#0,render_flags(a0)	; is object facing left?
	beq.s	+			; if not, branch
	neg.w	d0			; else mirror offset
+
	add.w	d0,x_pos(a1)		; add horizontal offset
	move.w	y_pos(a0),y_pos(a1)	; align objects vertically
	addq.w	#6,y_pos(a1)		; move object 6 pixels down

return_36EB0:
	rts
; ===========================================================================
; loc_36EB2:
Obj91_TestCharacterPos:
	addi.w	#$20,d3
	cmpi.w	#$40,d3			; is character too low?
	bhs.s	Obj91_DoNotCharge	; if yes, branch
	tst.w	d2			; is character to the left?
	bmi.s	Obj91_TestPosLeft	; if yes, branch
	tst.w	x_vel(a0)		; is object moving left, towards character?
	bpl.s	Obj91_DoNotCharge	; if not, branch
	jmp	Obj91_TestHorizontalDist
; ===========================================================================
; loc_36ECA:
Obj91_TestPosLeft:
	tst.w	x_vel(a0)		; is object moving right, towards character?
	bmi.s	Obj91_DoNotCharge	; if not, branch
	neg.w	d2			; get absolute value

; loc_36ED2:
Obj91_TestHorizontalDist:
	cmpi.w	#$20,d2			; is distance less than $20?
	blo.s	Obj91_DoNotCharge	; if yes, don't attack
	cmpi.w	#$A0,d2			; is distance less than $A0?
	blo.s	Obj91_PlayerInRange	; if yes, attack

; loc_36EDE:
Obj91_DoNotCharge:
	moveq	#0,d2			; -> don't charge at player
	rts
; ===========================================================================
; loc_36EE2:
Obj91_PlayerInRange:
	moveq	#1,d2			; -> charge at player
	rts
; ===========================================================================
; off_36EE6:
Obj91_SubObjData:
	subObjData Obj91_MapUnc_36EF6,make_art_tile(ArtTile_ArtNem_ChopChop,1,0),4,4,$10,2

; animation script
; off_36EF0:
Ani_obj91:	offsetTable
		offsetTableEntry.w +
+		dc.b   4,  0,  1,$FF	; 0
		even
; --------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------
Obj91_MapUnc_36EF6:	BINCLUDE "mappings/sprite/obj91.bin"

                   even

