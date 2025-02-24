
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8D - Grounder in wall, from ARZ
; ----------------------------------------------------------------------------
; Sprite_36A76:
; note from lava you dont have to do this bc you only need the wall one the no wall one is just a moto bug tbh
ObjGrounderNotInWall:
       move.b  #1,routine_secondary(a0) ; set the in wall flag
Obj8D:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8D_Index(pc,d0.w),d1
	jmp	Obj8D_Index(pc,d1.w)
; ===========================================================================
; off_36A84:
Obj8D_Index:	offsetTable
		offsetTableEntry.w Obj8D_Init		;  0
		offsetTableEntry.w loc_36ADC		;  2
		offsetTableEntry.w Obj8D_Animate	;  4
		offsetTableEntry.w loc_36B0E		;  6
		offsetTableEntry.w loc_36B34		;  8
		offsetTableEntry.w loc_36B6A		; $A
; ===========================================================================
; loc_36A90:
Obj8D_Init:
	jsr	LoadSubObject
	bclr	#1,render_flags(a0)
	beq.s	+
	bclr	#1,status(a0)
	andi.w	#drawing_mask,art_tile(a0)
+
	move.b	#$14,y_radius(a0)
	move.b	#$10,x_radius(a0)
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)
+
	tst.b  routine_secondary(a0)
	beq.w	loc_36C64
	move.b	#6,routine(a0)
	rts
; ===========================================================================

loc_36ADC:
	jsr	Obj_GetOrientationToPlayer
	abs.w	d2
	cmpi.w	#$60,d2
	bls.s	+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	st	objoff_2F(a0)
	jsr	loc_36C2C
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; loc_36B00:
Obj8D_Animate:
	lea	(Ani_obj8D_b).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B0E:
	addq.b	#2,routine(a0)
	jsr	Obj_GetOrientationToPlayer
	move.w	Obj8D_Directions(pc,d0.w),x_vel(a0)
	bclr	#0,status(a0)
	tst.w	d0
	beq.s	+
	bset	#0,status(a0)
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; word_36B30:
Obj8D_Directions:
	dc.w -$100
	dc.w  $100	; 1
; ===========================================================================

loc_36B34:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jsr	(ObjCheckFloorDist).l
	cmpi.w	#-1,d1
	blt.s	loc_36B5C
	cmpi.w	#$C,d1
	bge.s	loc_36B5C
	add.w	d1,y_pos(a0)
	lea	(Ani_obj8D_a).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B5C:
	addq.b	#2,routine(a0)
	move.b	#$3B,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B6A:
	subq.b	#1,objoff_2E(a0)
	bmi.s	loc_36B74
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36B74:
	move.b	#8,routine(a0)
	neg.w	x_vel(a0)
	bchg	#0,status(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 8F - Wall behind which Grounder hides, from ARZ
; ----------------------------------------------------------------------------
; Sprite_36B88:
Obj8F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj8F_Index(pc,d0.w),d1
	jmp	Obj8F_Index(pc,d1.w)
; ===========================================================================
; off_36B96:
Obj8F_Index:	offsetTable
		offsetTableEntry.w Obj8F_Init	; 0
		offsetTableEntry.w loc_36BA6	; 2
		offsetTableEntry.w Obj8F_Move	; 4
; ===========================================================================
; loc_36B9C:
Obj8F_Init:
	jsr	LoadSubObject
	clr.w	art_tile(a0)
	rts
; ===========================================================================

loc_36BA6:
	movea.w	objoff_30(a0),a1 ; a1=object
	tst.b	objoff_2F(a1)
	bne.s	+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	objoff_32(a0),d0
	move.b	Obj8F_Directions(pc,d0.w),x_vel(a0)
	move.b	Obj8F_Directions+1(pc,d0.w),y_vel(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; byte_36BCC:
Obj8F_Directions:
	dc.b  1,-2	; 0
	dc.b  1,-1	; 2
	dc.b -1,-2	; 4
	dc.b -1,-1	; 6
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 90 - Rocks thrown by Grounder behind wall, from ARZ
; ----------------------------------------------------------------------------
; Sprite_36BD4:
Obj90:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj90_Index(pc,d0.w),d1
	jmp	Obj90_Index(pc,d1.w)
; ===========================================================================
; off_36BE2:
Obj90_Index:	offsetTable
		offsetTableEntry.w Obj90_Init	; 0
		offsetTableEntry.w Obj90_Move	; 2
; ===========================================================================
; loc_36BE6:
Obj90_Init:
	jsr	LoadSubObject
	move.w	#make_art_tile(ArtTile_ArtNem_Grounder,2,0),art_tile(a0)
	move.w	objoff_32(a0),d0
	move.b	Obj90_Directions(pc,d0.w),x_vel(a0)
	move.b	Obj90_Directions+1(pc,d0.w),y_vel(a0)
	lsr.w	#1,d0
	move.b	Obj90_Frames(pc,d0.w),mapping_frame(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================
; byte_36C0C:
Obj90_Frames:
	dc.b   0
	dc.b   2	; 1
	dc.b   0	; 2
	dc.b   1	; 3
	dc.b   0	; 4
	dc.b   0	; 5
; ===========================================================================
; byte_36C12:
Obj90_Directions:
	dc.b  -1, -4
	dc.b   4, -3	; 2
	dc.b   2,  0	; 4
	dc.b  -3, -1	; 6
	dc.b  -3, -3	; 8
; ===========================================================================
; loc_36C1C:
Obj8F_Move:
Obj90_Move:
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	jsrto	(ObjectMoveAndFall).l, JmpTo8_ObjectMoveAndFall
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36C2C:
	moveq	#0,d1

	moveq	#4,d6
-	jsrto	(SingleObjLoad).l, JmpTo19_SingleObjLoad
	bne.s	+	; rts
	jsr	loc_36C40
	dbf	d6,-
+
	rts
; ===========================================================================

loc_36C40:
	move.l	#Obj90,(a1) ; load obj90
	move.b	#6,subtype(a1) ; <== Obj90_SubObjData2
	move.w	a0,objoff_30(a1)
	move.w	d1,objoff_32(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	addq.w	#2,d1
	rts
; ===========================================================================

loc_36C64:
	moveq	#0,d1

	moveq	#3,d6
-	jsrto	(SingleObjLoad).l, JmpTo19_SingleObjLoad
	bne.s	+	; rts
	jsr	loc_36C78
	dbf	d6,-
+
	rts
; ===========================================================================

loc_36C78:
	move.l	#Obj8F,(a1) ; load obj8F
	move.b	#4,subtype(a1) ; <== Obj90_SubObjData
	move.w	a0,objoff_30(a1)
	move.w	d1,objoff_32(a1)
	move.l	x_pos(a0),d0
	swap	d0
	moveq	#0,d2
	move.b	byte_36CBC(pc,d1.w),d2
	ext.w	d2
	add.w	d2,d0
	swap	d0
	move.l	d0,x_pos(a1)
	move.l	y_pos(a0),d0
	swap	d0
	moveq	#0,d2
	move.b	byte_36CBC+1(pc,d1.w),d2
	ext.w	d2
	add.w	d2,d0
	swap	d0
	move.l	d0,y_pos(a1)
	addq.w	#2,d1
	rts
; ===========================================================================
byte_36CBC:
	dc.b    0,-$14
	dc.b  $10,  -4	; 2
	dc.b    0,  $C	; 4
	dc.b -$10,  -4	; 6
; off_36CC4:
Obj8D_SubObjData:
	subObjData Obj8D_MapUnc_36CF0,make_art_tile(ArtTile_ArtNem_Grounder,1,1),4,5,$10,2
; off_36CCE:
Obj90_SubObjData:
	subObjData Obj90_MapUnc_36D00,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),$84,4,$10,0
; off_36CD8:
Obj90_SubObjData2:
	subObjData Obj90_MapUnc_36CFA,make_art_tile(ArtTile_ArtNem_Grounder,1,1),$84,4,8,0

; animation script
Ani_obj8D_a:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   3,  2,  3,  4,$FF
		even
; animation script
; off_36CEA:
Ani_obj8D_b:	offsetTable
		offsetTableEntry.w +
+		dc.b   7,  0,  1,$FC
		even
; -----------------------------------------------------------------------------
; sprite mappings (obj8D)
; -----------------------------------------------------------------------------
Obj8D_MapUnc_36CF0: offsetTable
	offsetTableEntry.w word_36D02	; 0
	offsetTableEntry.w word_36D24	; 2
	offsetTableEntry.w word_36D46	; 4
	offsetTableEntry.w word_36D58	; 6
	offsetTableEntry.w word_36D6A	; 8
; -----------------------------------------------------------------------------
; sprite mappings (obj90)
; -----------------------------------------------------------------------------
Obj90_MapUnc_36CFA: offsetTable
	offsetTableEntry.w word_36D7C	; 0
	offsetTableEntry.w word_36D86	; 2
	offsetTableEntry.w word_36D90	; 4
; -----------------------------------------------------------------------------
; sprite mappings (obj90)
; -----------------------------------------------------------------------------
Obj90_MapUnc_36D00: offsetTable
	offsetTableEntry.w word_36D9A	; 0
word_36D02:
	dc.w 4
	dc.w $F400,    0,    0,$FFF8
	dc.w $FC06,    1,    0,$FFF0 ; 4
	dc.w $F400, $800, $800,	   0 ; 8
	dc.w $FC06, $801, $800,	   0 ; 12
word_36D24:
	dc.w 4
	dc.w $EC00,    7,    3,$FFF8
	dc.w $F407,    8,    4,$FFF0 ; 4
	dc.w $EC00, $807, $803,	   0 ; 8
	dc.w $F407, $808, $804,	   0 ; 12
word_36D46:
	dc.w 2
	dc.w $EC0F,  $10,    8,$FFF0
	dc.w  $C0C,  $20,  $10,$FFF0 ; 4
word_36D58:
	dc.w 2
	dc.w $EC0F,  $10,    8,$FFF0
	dc.w  $C0C,  $24,  $12,$FFF0 ; 4
word_36D6A:
	dc.w 2
	dc.w $EC0F,  $10,    8,$FFF0
	dc.w  $C0C,  $28,  $14,$FFF0 ; 4
word_36D7C:
	dc.w 1
	dc.w $F805,  $2C,  $16,$FFF8
word_36D86:
	dc.w 1
	dc.w $FC00,  $30,  $18,$FFFC
word_36D90:
	dc.w 1
	dc.w $FC00,  $31,  $18,$FFFC
word_36D9A:
	dc.w 2
	dc.w $F805,$4093,$4049,$FFF0
	dc.w $F805,$4097,$404B,	   0 ; 4
; ===========================================================================
