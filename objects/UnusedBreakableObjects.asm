
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3B - Purple rock (leftover from S1)
; ----------------------------------------------------------------------------
; Sprite_15CC8:
Obj3B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3B_Index(pc,d0.w),d1
	jmp	Obj3B_Index(pc,d1.w)
; ===========================================================================
; off_15CD6:
Obj3B_Index:	offsetTable
		offsetTableEntry.w Obj3B_Init	; 0
		offsetTableEntry.w Obj3B_Main	; 2
; ===========================================================================
; loc_15CDA:
Obj3B_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj3B_MapUnc_15D2E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_GHZ_Purple_Rock,3,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#$13,width_pixels(a0)
	move.b	#4,priority(a0)
; loc_15D02:
Obj3B_Main:
	move.w	#$1B,d1
	move.w	#$10,d2
	move.w	#$10,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	DeleteObject
	jmp	DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj3B_MapUnc_15D2E:	BINCLUDE "mappings/sprite/obj3B.bin"
                even
    if ~~removeJmpTos
	align 4
    endif
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3C - Breakable wall (leftover from S1) (mostly unused)
; ----------------------------------------------------------------------------
; Sprite_15D44:
Obj3C:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3C_Index(pc,d0.w),d1
	jsr	Obj3C_Index(pc,d1.w)
	jmp	MarkObjGone
; ===========================================================================
; off_15D56:
Obj3C_Index:	offsetTable
		offsetTableEntry.w Obj3C_Init		; 0
		offsetTableEntry.w Obj3C_Main		; 2
		offsetTableEntry.w Obj3C_Fragment	; 4
; ===========================================================================
; loc_15D5C:
Obj3C_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj3C_MapUnc_15ECC,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BreakWall,2,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),mapping_frame(a0)
; loc_15D8A:
Obj3C_Main:
	move.w	(MainCharacter+x_vel).w,objoff_34(a0)
	move.w	#$1B,d1
	move.w	#$20,d2
	move.w	#$20,d3
	move.w	x_pos(a0),d4
	bsr.w	SolidObject
	btst	#5,status(a0)
	bne.s	+
-	rts
; ===========================================================================
+
	lea	(MainCharacter).w,a1 ; a1=character
	cmpi.b	#2,anim(a1)
	bne.s	-	; rts
	mvabs.w	objoff_34(a0),d0
	cmpi.w	#$480,d0
	blo.s	-	; rts
	move.w	objoff_34(a0),x_vel(a1)
	addq.w	#4,x_pos(a1)
	lea	(Obj3C_FragmentSpeeds_LeftToRight).l,a4
	move.w	x_pos(a0),d0
	cmp.w	x_pos(a1),d0
	blo.s	+
	subi.w	#8,x_pos(a1)
	lea	(Obj3C_FragmentSpeeds_RightToLeft).l,a4
+
	move.w	x_vel(a1),inertia(a1)
	bclr	#5,status(a0)
	bclr	#5,status(a1)
	bsr.s	BreakObjectToPieces
; loc_15E02:
Obj3C_Fragment:
	bsr.w	ObjectMove
	addi.w	#$70,y_vel(a0)
	tst.b	render_flags(a0)
	bpl.w	DeleteObject
	jmp	DisplaySprite

; sub_15E18:
BreakObjectToPieces:	; splits up one object into its current mapping frame pieces
	moveq	#0,d0	; Clear d0
	move.b	mapping_frame(a0),d0; move mappings of the wall into d0
	add.w	d0,d0	;multiply this by 2
	movea.l	mappings(a0),a3	;move the mappings (not frame) into a3 so we know how to break the wall tiles
	adda.w	(a3,d0.w),a3	; put address of appropriate frame to a3
	move.w	(a3)+,d1	; amount of pieces the frame consists of
	subq.w	#1,d1	;subtract 1 from the pieces to prevet invalid mappings
	bset	#5,render_flags(a0)	;Tell the game that the mappings only consiost of 1 sprite peice
	lea	(a0),a1	;Make a subobject for the particles
	bra.s	.InitObject	;initialize the particles
; ===========================================================================
; loc_15E3E:
.Loop:
	jsr	SingleObjLoad2	;Load a new object
	bne.s	.BreakSound	;Play the breakable wall smahing sound effect
	addq.w	#8,a3	; next mapping piece
; loc_15E46:
.InitObject:
	move.b	#4,routine(a1)	;Set the rouinte to be fragmenting
	move.l	(a0),(a1) ; load object with ID of parent object and routine 4
	move.l	a3,mappings(a1);move a peice of the object as the mappings for this sprite
	move.b	render_flags(a0),render_flags(a1)	;keep render flags consistent between the parent & child
	move.w	x_pos(a0),x_pos(a1)	;Go to parent X position
	move.w	y_pos(a0),y_pos(a1)	;Go to parent Y position
	move.w	art_tile(a0),art_tile(a1)	;Keep all of the art data the same between parent & child
	move.w	(a4)+,x_vel(a1)	;Move the fragment x speed into the x velocity of the particle
	move.w	(a4)+,y_vel(a1)	;same, but for the Y velocity instead of the X velocity
	dbf	d1,.Loop	;repeat
.BreakSound:
	move.w	#SndID_SlowSmash,d0	;Move the smashing sound into d0
	jmp	(PlaySound).l	;Play the sound in d0
; End of function BreakObjectToPieces

; ===========================================================================
; word_15E8C:
FragmentSpeeds_LeftToRight:
	;	x_vel,y_vel
	dc.w  $400,-$500	; 0
	dc.w  $600,-$100	; 2
	dc.w  $600, $100	; 4
	dc.w  $400, $500	; 6
	dc.w  $600,-$600	; 8
	dc.w  $800,-$200	; 10
	dc.w  $800, $200	; 12
	dc.w  $600, $600	; 14
; word_15EAC:
FragmentSpeeds_RightToLeft:
	dc.w -$600,-$600	; 0
	dc.w -$800,-$200	; 2
	dc.w -$800, $200	; 4
	dc.w -$600, $600	; 6
	dc.w -$400,-$500	; 8
	dc.w -$600,-$100	; 10
	dc.w -$600, $100	; 12
	dc.w -$400, $500	; 14
	even
; ===========================================================================
; word_15E8C:
Obj3C_FragmentSpeeds_LeftToRight:
	;    x_vel,y_vel
	dc.w  $400,-$500	; 0
	dc.w  $600,-$100	; 2
	dc.w  $600, $100	; 4
	dc.w  $400, $500	; 6
	dc.w  $600,-$600	; 8
	dc.w  $800,-$200	; 10
	dc.w  $800, $200	; 12
	dc.w  $600, $600	; 14
; word_15EAC:
Obj3C_FragmentSpeeds_RightToLeft:
	dc.w -$600,-$600	; 0
	dc.w -$800,-$200	; 2
	dc.w -$800, $200	; 4
	dc.w -$600, $600	; 6
	dc.w -$400,-$500	; 8
	dc.w -$600,-$100	; 10
	dc.w -$600, $100	; 12
	dc.w -$400, $500	; 14
; -------------------------------------------------------------------------------
; Unused sprite mappings
; -------------------------------------------------------------------------------
Obj3C_MapUnc_15ECC:	BINCLUDE "mappings/sprite/obj3C.bin"
          even
; ===========================================================================
	jmp	ObjNull
