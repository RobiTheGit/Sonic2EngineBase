

ARZSwingingPLatformTimer = objoff_3A
ARZSwingStartCountdownFlag = objoff_41
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 15 - Swinging platform from Aquatic Ruin Zone
; ----------------------------------------------------------------------------
; Sprite_FC9C:
Obj15:

	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj15_Index(pc,d0.w),d1
	jmp	Obj15_Index(pc,d1.w)

; ===========================================================================
; off_FCBC: Obj15_States:
Obj15_Index:	offsetTable
		offsetTableEntry.w Obj15_Init		;  0
		offsetTableEntry.w Obj15_State2		;  2
		offsetTableEntry.w Obj15_Display	;  4
		offsetTableEntry.w Obj15_State4		;  6
		offsetTableEntry.w Obj15_State5		;  8
		offsetTableEntry.w Obj15_State6		; $A
		offsetTableEntry.w Obj15_State7		; $C
; ===========================================================================
; loc_FCCA:
Obj15_Init:
	addq.b	#2,routine(a0)  ;Obj15_State2
	move.l	#Obj15_MapUnc_101E8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_OOZSwingPlat,2,0),art_tile(a0)
	move.b	#4,render_flags(a0) ; set normal sprites
	move.b	#3,priority(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#$10,y_radius(a0)
	move.w	y_pos(a0),objoff_3C(a0)
	move.w	x_pos(a0),objoff_3E(a0)
	cmpi.b	#mystic_cave_zone,(Current_Zone).w
	bne.s	.ifNotMysticCave
	move.l	#Obj15_Obj7A_MapUnc_10256,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	move.b	#$18,width_pixels(a0)
	move.b	#8,y_radius(a0)
 .ifNotMysticCave:
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	.IfNotAquaticRuins
	move.l	#Obj15_Obj83_MapUnc_1021E,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#8,y_radius(a0)
 .IfNotAquaticRuins:

	moveq	#0,d1
	move.b	subtype(a0),d1 ; dump subtype ram to data reg
	bpl.s	.IfSubtypeIs0
	addq.b	#4,routine(a0) ; this leads to Obj15_State4 ; after the init start already incressed to 2 results to routine 6
 .IfSubtypeIs0:
	move.b	d1,d4  ; get substype values
	andi.b	#$70,d4     ;  $70 to it
	andi.w	#$F,d1   ; H what
	move.w	x_pos(a0),d2  ; get x
	move.w	y_pos(a0),d3  ; get y
	jsrto	(SingleObjLoad2).l, JmpTo2_SingleObjLoad2 ; get a1 location
	bne.w	.MoveInit_Swing   ; if failed go branch
	move.l	#DisplaySprite,(a1) ; load obj15  ; go to display sprite (Works as DisplaySprite3) Here because s3k object manager and priority
	move.l	mappings(a0),mappings(a1)   ; copy a0 maps to a1 (chains)
	move.w	art_tile(a0),art_tile(a1)   ; same with art tile
	move.b	#3,priority(a1) ; chains priority
	move.b	#4,render_flags(a1)
	cmpi.b	#$20,d4     ; if the distance i assume is 20
	bne.s	.IfNotSubtype20  ; branch
	move.b	#4,priority(a1)     ; init the platform
	move.b	#$10,width_pixels(a1)
	move.b	#$50,y_radius(a1)
	bset	#4,render_flags(a1)
	move.b	#3,mapping_frame(a1)
	move.w	d2,x_pos(a1)
	addi.w	#$40,d3
	move.w	d3,y_pos(a1)
	addi.w	#$48,d3
	move.w	d3,y_pos(a0)
	bra.s	.Unk_init_Addresses ; sets a1 (child) to $34 sst
; ===========================================================================
 .IfNotSubtype20:
	bset	#6,render_flags(a1)  ; set subsprites
	move.b	#$48,mainspr_width(a1)  ; set each subsrptie wdth
	move.b	d1,mainspr_childsprites(a1)      ; d1 is substype aka chain links size
	subq.b	#1,d1            ; subtranct 1
	lea	sub2_x_pos(a1),a2  ; a1 subsprite x  to a2

 .Loop_SwinignDistance:
	move.w	d2,(a2)+	; sub?_x_pos
	move.w	d3,(a2)+	; sub?_y_pos
	move.w	#1,(a2)+	; sub2_mapframe
	addi.w	#$10,d3
	dbf	d1,.Loop_SwinignDistance

	move.b	#2,sub2_mapframe(a1)  ; set a subsprite mapping frame
	move.w	sub6_x_pos(a1),x_pos(a1) ; get subrite number 6 to our actual x and y
	move.w	sub6_y_pos(a1),y_pos(a1)
	move.w	d2,sub6_x_pos(a1)   ; if d2 is x and d3 is y (i assume)then make the subsprite frame copy that a0 x and y location
	move.w	d3,sub6_y_pos(a1)
	move.b	#1,mainspr_mapframe(a1)   ; set a main map frame (wich one idk)
	addi.w	#8,d3                   ; add 8 to a0 y
	move.w	d3,y_pos(a0)            ; dump that to y for a0
	move.b	#$50,mainspr_height(a1)  ; its height
	bset	#4,render_flags(a1)   ; wtf not a subsprite
 .Unk_init_Addresses:
	move.l	a1,objoff_34(a0)    ; get whatever a1 is to $34 sst
.MoveInit_Swing
	move.w	#$8000,angle(a0)
	move.w	#0,objoff_42(a0)
	move.b	subtype(a0),d1
	andi.w	#$70,d1
	move.b	d1,subtype(a0)
	cmpi.b	#$40,d1
	bne.s	Obj15_State2
	move.l	#Obj15_MapUnc_102DE,mappings(a0)
	move.b	#$A7,collision_flags(a0)

; loc_FE50:
Obj15_State2:                ; platform data
	move.w	x_pos(a0),-(sp)
	bsr.w	sub_FE70
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#0,d3
	move.b	y_radius(a0),d3
	addq.b	#1,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject2).l, JmpTo_PlatformObject2
	bra.w	OnScreenTestSwingingPLatform

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_FE70:

	moveq	#0,d0
	moveq	#0,d1
	move.b	(Oscillating_Data+$18).w,d0 ; swinging movement
	move.b	subtype(a0),d1
	beq.s	loc_FEC2
	cmpi.b	#$10,d1
	bne.s	.CheckSubstypesSwinginPlatforms
	cmpi.b	#$3F,d0
	beq.s	.PlayPtfmKnock
	bhs.s	loc_FEC2
	moveq	#$40,d0
	bra.s	loc_FEC2
; ===========================================================================
;/                dummied out code
 .PlayPtfmKnock:
	move.w	#SndID_PlatformKnock,d0
	jsr	(PlaySoundLocal).l
	moveq	#$40,d0
	bra.s	loc_FEC2
; ===========================================================================
  .CheckSubstypesSwinginPlatforms:
	cmpi.b	#$20,d1
	beq.w	ReturnDoNothing	; rts
	cmpi.b	#$30,d1
	bne.s	.SwingSineUnk1
	cmpi.b	#$41,d0
	beq.s	.PlayPtfmKnock ;-
	blo.s	loc_FEC2
	moveq	#$40,d0
	bra.s	loc_FEC2
; ===========================================================================
.SwingSineUnk1:
	cmpi.b	#$40,d1
	bne.s	loc_FEC2
	bsr.w	loc_FF6E

loc_FEC2:
	move.b	objoff_32(a0),d1
	cmp.b	d0,d1
	beq.w	ReturnDoNothing	; rts
	move.b	d0,objoff_32(a0)
	move.w	#$80,d1
	btst	#0,status(a0)
	beq.s	TestToNegateSwing
	neg.w	d0
	add.w	d1,d0
 TestToNegateSwing:
	jsrto	(CalcSine).l, JmpTo2_CalcSine
	move.w	objoff_3C(a0),d2
	move.w	objoff_3E(a0),d3
	moveq	#0,d6
	movea.l	objoff_34(a0),a1
	move.b	mainspr_childsprites(a1),d6
	subq.w	#1,d6
	bcs.s	ReturnDoNothing	; rts
	swap	d0
	swap	d1
	asr.l	#4,d0
	asr.l	#4,d1
	moveq	#0,d4
	moveq	#0,d5
	lea	sub2_x_pos(a1),a2

SwingPlatofmrOT_SetSubSprs:
	movem.l	d4-d5,-(sp)
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	d5,(a2)+	; sub?_x_pos
	move.w	d4,(a2)+	; sub?_y_pos
	movem.l	(sp)+,d4-d5
	add.l	d0,d4
	add.l	d1,d5
	addq.w	#next_subspr-4,a2
	dbf	d6,SwingPlatofmrOT_SetSubSprs

	movem.l	d4-d5,-(sp)
	swap	d4
	swap	d5
	add.w	d2,d4
	add.w	d3,d5
	move.w	sub6_x_pos(a1),d2
	move.w	sub6_y_pos(a1),d3
	move.w	d5,sub6_x_pos(a1)
	move.w	d4,sub6_y_pos(a1)
	move.w	d2,x_pos(a1)
	move.w	d3,y_pos(a1)
	movem.l	(sp)+,d4-d5
	asr.l	#1,d0
	asr.l	#1,d1
	add.l	d0,d4
	add.l	d1,d5
	swap	d4
	swap	d5
	add.w	objoff_3C(a0),d4
	add.w	objoff_3E(a0),d5
	move.w	d4,y_pos(a0)
	move.w	d5,x_pos(a0)
 ReturnDoNothing:
	rts
; End of function sub_FE70

; ===========================================================================

loc_FF6E:
	tst.w	ARZSwingingPLatformTimer(a0)
	beq.s	.keepswinging
	subq.w	#1,ARZSwingingPLatformTimer(a0)

	bra.w	loc_10006
; ===========================================================================
 .keepswinging:
	tst.b	objoff_38(a0)
	bne.s	.TestForFlag
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	objoff_3E(a0),d0
	addi.w	#$20,d0
	cmpi.w	#$40,d0
	bhs.s	loc_10006
	tst.w	(Debug_placement_mode).w
	bne.w	loc_10006
	move.b	#1,objoff_38(a0)
 .TestForFlag:
	tst.b	ARZSwingStartCountdownFlag(a0)
	beq.s	.IgnoreAfterSimpleSettinng
	move.w	objoff_42(a0),d0
	addi.w	#8,d0
	move.w	d0,objoff_42(a0)
	add.w	d0,angle(a0)
	cmpi.w	#$200,d0
	bne.s	loc_10006
	move.w	#0,objoff_42(a0)
	move.w	#$8000,angle(a0)
	move.b	#0,ARZSwingStartCountdownFlag(a0)
	move.w	#$3C,ARZSwingingPLatformTimer(a0)
	bra.s	loc_10006
; ===========================================================================
 .IgnoreAfterSimpleSettinng:
	move.w	objoff_42(a0),d0
	subi.w	#8,d0
	move.w	d0,objoff_42(a0)
	add.w	d0,angle(a0)
	cmpi.w	#$FE00,d0
	bne.s	loc_10006
	move.w	#0,objoff_42(a0)
	move.w	#$4000,angle(a0)
	move.b	#1,ARZSwingStartCountdownFlag(a0)
; loc_10000:
	move.w	#$3C,ARZSwingingPLatformTimer(a0)

loc_10006:
	move.b	angle(a0),d0
	rts
; ===========================================================================
;loc_1000C
OnScreenTestSwingingPLatform:
	tst.w	(Two_player_mode).w
	beq.s	.If1PMode
	bra.w	DisplaySprite
; ===========================================================================
 .If1PMode:
	move.w	objoff_3E(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	.IfNotWithinScreenRange
	bra.w	DisplaySprite
; ===========================================================================
.IfNotWithinScreenRange:
	movea.l	objoff_34(a0),a1 ; get the ram address (.Unk_init_Addresses)
	bsr.w	DeleteObject2 ; delete a1
	bra.w	DeleteObject  ; delete a1 and a0 alltogther
; ===========================================================================

Obj15_Display: ;;
	bra.w	DisplaySprite
; ===========================================================================

; loc_1003E:
Obj15_State4:
	move.w	x_pos(a0),-(sp)
	bsr.w	sub_FE70
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#0,d3
	move.b	y_radius(a0),d3
	addq.b	#1,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject2).l, JmpTo_PlatformObject2
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.w	BranchTo_OnScreenTestSwingingPLatform
	tst.b	(Oscillating_Data+$18).w
	bne.w	BranchTo_OnScreenTestSwingingPLatform
	jsrto	(SingleObjLoad2).l, JmpTo2_SingleObjLoad2
	bne.w	loc_100E4
	moveq	#0,d0

	move.w	#bytesToLcnt(object_size),d1
.loop:	move.l	(a0,d0.w),(a1,d0.w)
	addq.w	#4,d0
	dbf	d1,.loop
    if object_size&3
	move.w	(a0,d0.w),(a1,d0.w)
    endif

	move.b	#$A,routine(a1)
	cmpi.b	#aquatic_ruin_zone,(Current_Zone).w
	bne.s	.notARZ
	addq.b	#2,routine(a1)
 .notARZ:
	move.w	#$200,x_vel(a1)
	btst	#0,status(a0)
	beq.s	.ifNotLeftFacing
	neg.w	x_vel(a1)
 .ifNotLeftFacing:
	bset	#1,status(a1)
	move.w	a0,d0
	subi.w	#Object_RAM,d0
        lsr.w	#6,d0
	move.b	Dvisiton_4a(pc,d0.w),d0
	bmi.s	Fail_Divisiton

	andi.w	#(Object_RAM_End-Object_RAM)/object_size-1,d0
	move.w	a1,d1
	subi.w	#Object_RAM,d1

	lsr.w	#6,d1			; divide by $40
	move.b	Dvisiton_4a(pc,d1.w),d1		; load the right number of objects from table
	bmi.s	Fail_Divisiton			; if negative, we have failed!

	andi.w	#(Object_RAM_End-Object_RAM)/object_size-1,d1
	lea     (MainCharacter).w,a2
	cmp.w	interact(a2),a0
	bne.s	.NotSonicINteraction
	move.w	a1,interact(a2)
 .NotSonicINteraction:
        lea     (Sidekick).w,a2
	cmp.w	interact(a2),a0
	bne.s	loc_100E4
	move.w	a1,interact(a2)

loc_100E4:
	move.b	#3,mapping_frame(a0)
	addq.b	#2,routine(a0)
	andi.b	#$E7,status(a0)

BranchTo_OnScreenTestSwingingPLatform ; BranchTo
	bra.w	OnScreenTestSwingingPLatform
Fail_Divisiton:
          rts
Dvisiton_4a:	dc.b -1
.a :=	1		; .a is the object slot we are currently processing
.b :=	1		; .b is used to calculate when there will be a conversion error due to object_size being > $40

	rept (Dynamic_Object_RAM_End-Dynamic_object_RAM)/object_size-1
		if (object_size * (.a-1)) / $40 > .b+1	; this line checks, if there would be a conversion error
			dc.b .a-1, .a-1			; and if is, it generates 2 entries to correct for the error
		else
			dc.b .a-1
		endif

.b :=		(object_size * (.a-1)) / $40		; this line adjusts .b based on the iteration count to check
.a :=		.a+1					; run interation counter
	endm
	even
; ===========================================================================
; loc_100F8:
Obj15_State5:
	bsr.w	sub_FE70
	bra.w	OnScreenTestSwingingPLatform

; ===========================================================================
; loc_10100:
Obj15_State6:
	move.w	x_pos(a0),-(sp)
	btst	#1,status(a0)
	beq.s	.IgnoreSwingBreakDownIFnotbit1
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	cmpi.w	#$720,y_pos(a0)
	blo.s   .IfNotReachingYBound
	move.w	#$720,y_pos(a0)
	bclr	#1,status(a0)
	move.w	#0,x_vel(a0)
	move.w	#0,y_vel(a0)
	move.w	y_pos(a0),objoff_3C(a0)
	bra.s	.IfNotReachingYBound
; ===========================================================================
.IgnoreSwingBreakDownIFnotbit1
	moveq	#0,d0
	move.b	(Oscillating_Data+$14).w,d0
	lsr.w	#1,d0
	add.w	objoff_3C(a0),d0
	move.w	d0,y_pos(a0)
 .IfNotReachingYBound:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#0,d3
	move.b	y_radius(a0),d3
	addq.b	#1,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject2).l, JmpTo_PlatformObject2
	bra.w	MarkObjGone

; ===========================================================================
; loc_10166:
Obj15_State7:
	move.w	x_pos(a0),-(sp)
	bsr.w	ObjectMove
	btst	#1,status(a0)
	beq.s	.KeepFallingMidAir
	addi.w	#$18,y_vel(a0)
	move.w	(Water_Level_2).w,d0
	cmp.w	y_pos(a0),d0
	bhi.s	.BranchToPlatformSolids
	move.w	d0,y_pos(a0)
	move.w	d0,objoff_3C(a0)
	bclr	#1,status(a0)
	move.w	#$100,x_vel(a0)
	move.w	#0,y_vel(a0)
	bra.s	.BranchToPlatformSolids
; ===========================================================================
.KeepFallingMidAir
	moveq	#0,d0
	move.b	(Oscillating_Data+$14).w,d0
	lsr.w	#1,d0
	add.w	objoff_3C(a0),d0
	move.w	d0,y_pos(a0)
	tst.w	x_vel(a0)
	beq.s	.BranchToPlatformSolids
	moveq	#0,d3
	move.b	width_pixels(a0),d3
	jsrto	(ObjCheckRightWallDist).l, JmpTo_ObjCheckRightWallDist
	tst.w	d1
	bpl.s	.BranchToPlatformSolids
	add.w	d1,x_pos(a0)
	move.w	#0,x_vel(a0)
 .BranchToPlatformSolids:
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	moveq	#0,d3
	move.b	y_radius(a0),d3
	addq.b	#1,d3
	move.w	(sp)+,d4
	jsrto	(PlatformObject2).l, JmpTo_PlatformObject2
	bra.w	MarkObjGone
; ===========================================================================
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj15_MapUnc_101E8:	BINCLUDE "mappings/sprite/obj15_a.bin"
                         even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj15_Obj83_MapUnc_1021E:	BINCLUDE "mappings/sprite/obj83.bin"
                              even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj15_Obj7A_MapUnc_10256:	offsetTable
	offsetTableEntry.w word_1025E
	offsetTableEntry.w word_10270
	offsetTableEntry.w word_1027A
	offsetTableEntry.w word_1028C
word_1025E:	dc.w 2
	dc.w $F809, $6060, $6030, $FFE8
	dc.w $F809, $6860, $6830, 0
word_10270:	dc.w 1
		dc.w $F805, $6066, $6033, $FFF8
word_1027A:	dc.w 2
		dc.w $E805, $406A, $4035, $FFF4
		dc.w $F80B, $406E, $4037, $FFF4
word_1028C:	dc.w $A
		dc.w $A805, $406A, $4035, $FFF4
		dc.w $B80B, $406E, $4037, $FFF4
		dc.w $C805, $6066, $6033, $FFF8
		dc.w $D805, $6066, $6033, $FFF8
		dc.w $E805, $6066, $6033, $FFF8
		dc.w $F805, $6066, $6033, $FFF8
		dc.w $805, $6066, $6033, $FFF8
		dc.w $1805, $6066, $6033, $FFF8
		dc.w $2805, $6066, $6033, $FFF8
		dc.w $3805, $6066, $6033, $FFF8

; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj15_MapUnc_102DE:	offsetTable
	offsetTableEntry.w	word_102E4
	offsetTableEntry.w word_10270
	offsetTableEntry.w word_1027A
word_102E4:	dc.w 2
	dc.w $F80D, $6058, $602C, $FFE0
	dc.w $F80D, $6858, $682C, 0

; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_PlatformObject2 ; JmpTo
	jmp	(PlatformObject2).l
JmpTo2_SingleObjLoad2 ; JmpTo
	jmp	(SingleObjLoad2).l
JmpTo2_CalcSine ; JmpTo
	jmp	(CalcSine).l
JmpTo_ObjCheckRightWallDist ; JmpTo
	jmp	(ObjCheckRightWallDist).l

	align 4
    endif
