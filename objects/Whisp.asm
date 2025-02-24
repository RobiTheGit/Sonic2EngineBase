

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8C - Whisp (blowfly badnik) from ARZ
; ----------------------------------------------------------------------------

obj8C_timer = objoff_2E
obj8C_attacks_remaining = objoff_2F

; Sprite_36924:
Obj8C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8C_Index(pc,d0.w),d1
	jmp	Obj8C_Index(pc,d1.w)
; ===========================================================================
; off_36932: Obj8C_States:
Obj8C_Index:	offsetTable
		offsetTableEntry.w Obj8C_Init                  ; 0
		offsetTableEntry.w Obj8C_WaitUntilOnscreen     ; 1
		offsetTableEntry.w Obj8C_ChasePlayer           ; 2
		offsetTableEntry.w Obj8C_WaitUntilTimerExpires ; 3
		offsetTableEntry.w Obj8C_FlyAway               ; 4
; ===========================================================================
; loc_3693C:
Obj8C_Init:
	jsr	LoadSubObject
	move.b	#$10,obj8C_timer(a0)
	move.b	#4,obj8C_attacks_remaining(a0)
	rts
; ===========================================================================
; loc_3694E:
Obj8C_WaitUntilOnscreen:
	tst.b	render_flags(a0)
	bmi.s	loc_36970
	jmp	Obj8C_Animate
; ===========================================================================
; loc_36958:
Obj8C_WaitUntilTimerExpires:
	subq.b	#1,obj8C_timer(a0)
	bmi.s	loc_36970
; loc_3695E:
Obj8C_Animate:
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================

loc_36970:
	subq.b	#1,obj8C_attacks_remaining(a0)
	bpl.s	loc_36996
	move.b	#8,routine(a0)
	bclr	#0,status(a0)
	clr.w	y_vel(a0)
	move.w	#-$200,x_vel(a0)
	move.w	#-$200,y_vel(a0)
	jmp	Obj8C_FlyAway
; ===========================================================================

loc_36996:
	move.b	#4,routine(a0)
	move.w	#-$100,y_vel(a0)
	move.b	#96,obj8C_timer(a0)
; loc_369A8:
Obj8C_ChasePlayer:
	subq.b	#1,obj8C_timer(a0)
	bmi.s	loc_369F8
	jsr	Obj_GetOrientationToPlayer
	bclr	#0,status(a0)
	tst.w	d0
	beq.s	loc_369C2
	bset	#0,status(a0)

loc_369C2:
	move.w	Obj8C_MovementDeltas(pc,d0.w),d2
	add.w	d2,x_vel(a0)
	move.w	Obj8C_MovementDeltas(pc,d1.w),d2
	add.w	d2,y_vel(a0)
	move.w	#$200,d0
	move.w	d0,d1
	jsr	Obj_CapSpeed
	jsr	(ObjectMove).l
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; word_369F4:
Obj8C_MovementDeltas:
	dc.w -$10
	dc.w  $10
; ===========================================================================

loc_369F8:
	move.b	#6,routine(a0)
	jsr	(RandomNumber).l
	move.l	(RNG_seed).w,d0
	andi.b	#$1F,d0
	move.b	d0,obj8C_timer(a0)
	jsr	Obj_MoveStop
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; loc_36A26:
Obj8C_FlyAway:
	jsr	(ObjectMove).l
	lea	(Ani_obj8C).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; off_36A3E:
Obj8C_SubObjData:
	subObjData Obj8C_MapUnc_36A4E,make_art_tile(ArtTile_ArtNem_Whisp,1,1),4,4,$C,$B
; animation script
; off_36A48:
Ani_obj8C:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   1,  0,  1,$FF
		even
; ------------------------------------------------------------------------
; sprite mappings
; ------------------------------------------------------------------------
Obj8C_MapUnc_36A4E:	BINCLUDE "mappings/sprite/obj8C.bin"
     even
