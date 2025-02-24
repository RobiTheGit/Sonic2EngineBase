; ===========================================================================
;loc_3FCC4:
AniArt_Load:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	PLC_DYNANM+2(pc,d0.w),d1
	lea	PLC_DYNANM(pc,d1.w),a2
	move.w	PLC_DYNANM(pc,d0.w),d0
	jmp	PLC_DYNANM(pc,d0.w)





; ---------------------------------------------------------------------------
; ZONE ANIMATION PROCEDURES AND SCRIPTS
;
; Each zone gets two entries in this jump table. The first entry points to the
; zone's animation procedure (usually Dynamic_Normal, but some zones have special
; procedures for complicated animations). The second points to the zone's animation
; script.
;
; Note that Animated_Null is not a valid animation script, so don't pair it up
; with anything except Dynamic_Null, or bad things will happen (for example, a bus error exception).
; ---------------------------------------------------------------------------
PLC_DYNANM: zoneOrderedOffsetTable 2,2		; Zone ID
	zoneOffsetTableEntry.w Dynamic_Normal	; $00
	zoneOffsetTableEntry.w Animated_EHZ

	zoneOffsetTableEntry.w Dynamic_Null	; $01
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Null	; $02
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Null	; $03
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Normal	; $04
	zoneOffsetTableEntry.w Animated_MTZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $05
	zoneOffsetTableEntry.w Animated_MTZ

	zoneOffsetTableEntry.w Dynamic_Null	; $06
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_HTZ	; $07
	zoneOffsetTableEntry.w Animated_HTZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $08
	zoneOffsetTableEntry.w Animated_HPZ

	zoneOffsetTableEntry.w Dynamic_Null	; $09
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Normal	; $0A
	zoneOffsetTableEntry.w Animated_OOZ

	zoneOffsetTableEntry.w Dynamic_Null	; $0B
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_CNZ	; $0C
	zoneOffsetTableEntry.w Animated_CNZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $0D
	zoneOffsetTableEntry.w Animated_CPZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $0E
	zoneOffsetTableEntry.w Animated_DEZ

	zoneOffsetTableEntry.w Dynamic_ARZ	; $0F
	zoneOffsetTableEntry.w Animated_ARZ

	zoneOffsetTableEntry.w Dynamic_Null	; $10
	zoneOffsetTableEntry.w Animated_Null
    zoneTableEnd
; ===========================================================================

Dynamic_Null:
	rts
; ===========================================================================

Dynamic_HTZ:
	tst.w	(Two_player_mode).w
	bne.w	Dynamic_Normal
	lea	(Anim_Counters).w,a3
	moveq	#0,d0
	move.w	(Camera_X_pos).w,d1
	neg.w	d1
	asr.w	#3,d1
	move.w	(Camera_X_pos).w,d0
	lsr.w	#4,d0
	add.w	d1,d0
	subi.w	#$10,d0
	divu.w	#$30,d0
	swap	d0
	cmp.b	1(a3),d0
	beq.s	BranchTo_loc_3FE5C
	move.b	d0,1(a3)
	move.w	d0,d2
	andi.w	#7,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	andi.w	#$38,d2
	lsr.w	#2,d2
	add.w	d2,d0
	lea	word_3FD9C(pc,d0.w),a4
	moveq	#5,d5
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZMountains),d4

loc_3FD7C:
	moveq	#-1,d1
	move.w	(a4)+,d1
	andi.l	#$FFFFFF,d1
	move.w	d4,d2
	moveq	#tiles_to_bytes(4)/2,d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	addi.w	#$80,d4
	dbf	d5,loc_3FD7C

BranchTo_loc_3FE5C ; BranchTo
	bra.w	loc_3FE5C
; ===========================================================================
; HTZ mountain art main RAM addresses?
word_3FD9C:
	dc.w   $80, $180, $280, $580, $600, $700	; 6
	dc.w   $80, $180, $280, $580, $600, $700	; 12
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 18
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 24
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 30
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 36
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 42
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 48
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 54
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 60
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 66
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 72
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 78
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 84
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 90
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 96
; ===========================================================================

loc_3FE5C:
	lea	(TempArray_LayerDef).w,a1
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#3,d2
	move.l	a2,-(sp)
	lea	(ArtUnc_HTZClouds).l,a0
	lea	(Chunk_Table+$7C00).l,a2
	moveq	#$F,d1

loc_3FE78:
	move.w	(a1)+,d0
	neg.w	d0
	add.w	d2,d0
	andi.w	#$1F,d0
	lsr.w	#1,d0
	bcc.s	loc_3FE8A
	addi.w	#$200,d0

loc_3FE8A:
	lea	(a0,d0.w),a4
	lsr.w	#1,d0
	bcs.s	loc_3FEB4
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	suba.w	#$C0,a2
	adda.w	#$20,a0
	dbf	d1,loc_3FE78
	bra.s	loc_3FEEC
; ===========================================================================

loc_3FEB4:
    rept 3
      rept 4
	move.b	(a4)+,(a2)+
      endm
	adda.w	#$3C,a2
    endm
    rept 4
	move.b	(a4)+,(a2)+
    endm
	suba.w	#$C0,a2
	adda.w	#$20,a0
	dbf	d1,loc_3FE78

loc_3FEEC:
	move.l	#(Chunk_Table+$7C00) & $FFFFFF,d1
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZClouds),d2
	move.w	#tiles_to_bytes(8)/2,d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	movea.l	(sp)+,a2
	addq.w	#2,a3
	bra.w	loc_3FF30
; ===========================================================================

Dynamic_CNZ:
	tst.b	(Current_Boss_ID).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	lea	(Animated_CNZ).l,a2
	tst.w	(Two_player_mode).w
	beq.s	Dynamic_Normal
	lea	(Animated_CNZ_2P).l,a2
	bra.s	Dynamic_Normal
; ===========================================================================

Dynamic_ARZ:
	tst.b	(Current_Boss_ID).w
	beq.s	Dynamic_Normal
	rts
; ===========================================================================

Dynamic_Normal:
	lea	(Anim_Counters).w,a3

loc_3FF30:
	move.w	(a2)+,d6	; Get number of scripts in list
	; S&K checks for empty lists, here
;	bpl.s	.listnotempty	; If there are any, continue
;	rts
;.listnotempty:

; loc_3FF32:
.loop:
	subq.b	#1,(a3)		; Tick down frame duration
	bcc.s	.nextscript	; If frame isn't over, move on to next script

;.nextframe:
	moveq	#0,d0
	move.b	1(a3),d0	; Get current frame
	cmp.b	6(a2),d0	; Have we processed the last frame in the script?
	blo.s	.notlastframe
	moveq	#0,d0		; If so, reset to first frame
	move.b	d0,1(a3)	; ''
; loc_3FF48:
.notlastframe:
	addq.b	#1,1(a3)	; Consider this frame processed; set counter to next frame
	move.b	(a2),(a3)	; Set frame duration to global duration value
	bpl.s	.globalduration
	; If script uses per-frame durations, use those instead
	add.w	d0,d0
	move.b	9(a2,d0.w),(a3)	; Set frame duration to current frame's duration value
; loc_3FF56:
.globalduration:
; Prepare for DMA transfer
	; Get relative address of frame's art
	move.b	8(a2,d0.w),d0	; Get tile ID
	lsl.w	#5,d0		; Turn it into an offset
	; Get VRAM destination address
	move.w	4(a2),d2
	; Get ROM source address
	move.l	(a2),d1		; Get start address of animated tile art
	andi.l	#$FFFFFF,d1
	add.l	d0,d1		; Offset into art, to get the address of new frame
	; Get size of art to be transferred
	moveq	#0,d3
	move.b	7(a2),d3
	lsl.w	#4,d3		; Turn it into actual size (in words)
	; Use d1, d2 and d3 to queue art for transfer
	jsr	(QueueDMATransfer).l
; loc_3FF78:
.nextscript:
	move.b	6(a2),d0	; Get total size of frame data
	tst.b	(a2)		; Is per-frame duration data present?
	bpl.s	.globalduration2; If not, keep the current size; it's correct
	add.b	d0,d0		; Double size to account for the additional frame duration data
; loc_3FF82:
.globalduration2:
	addq.b	#1,d0
	andi.w	#$FE,d0		; Round to next even address, if it isn't already
	lea	8(a2,d0.w),a2	; Advance to next script in list
	addq.w	#2,a3		; Advance to next script's slot in a3 (usually Anim_Counters)
	dbf	d6,.loop
	rts
; ===========================================================================
; ZONE ANIMATION SCRIPTS
;
; The Dynamic_Normal subroutine uses these scripts to reload certain tiles,
; thus animating them. All the relevant art must be uncompressed, because
; otherwise the subroutine would spend so much time waiting for the art to be
; decompressed that the VBLANK window would close before all the animating was done.

;    zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
;	-1			Global frame duration. If -1, then each frame will use its own duration, instead
;	ArtUnc_Flowers1		Source address
;	ArtTile_ArtUnc_Flowers1	Destination VRAM address
;	6			Number of frames
;	2			Number of tiles to load into VRAM for each frame

;    dc.b   0,$7F		; Start of the script proper
;	0			Tile ID of first tile in ArtUnc_Flowers1 to transfer
;	$7F			Frame duration. Only here if global duration is -1

; loc_3FF94:
Animated_EHZ:	zoneanimstart
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
	dc.b   0,$7F		; Start of the script proper
	dc.b   2,$13
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers2, ArtTile_ArtUnc_Flowers2, 8, 2
	dc.b   2,$7F
	dc.b   0, $B
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2,  5
	dc.b   0,  5
	dc.b   2,  5
	dc.b   0,  5
	even
	; Flowers
	zoneanimdecl 7, ArtUnc_Flowers3, ArtTile_ArtUnc_Flowers3, 2, 2
	dc.b   0
	dc.b   2
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers4, ArtTile_ArtUnc_Flowers4, 8, 2
	dc.b   0,$7F
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2, $B
	even
	; Pulsing thing against checkered background
	zoneanimdecl -1, ArtUnc_EHZPulseBall, ArtTile_ArtUnc_EHZPulseBall, 6, 2
	dc.b   0,$17
	dc.b   2,  9
	dc.b   4, $B
	dc.b   6,$17
	dc.b   4, $B
	dc.b   2,  9
	even

	zoneanimend

Animated_MTZ:	zoneanimstart
	; Spinning metal cylinder
	zoneanimdecl 0, ArtUnc_MTZCylinder, ArtTile_ArtUnc_MTZCylinder, 8,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $40
	dc.b $50
	dc.b $60
	dc.b $70
	even
	; lava
	zoneanimdecl $D, ArtUnc_Lava, ArtTile_ArtUnc_Lava, 6,$C
	dc.b   0
	dc.b  $C
	dc.b $18
	dc.b $24
	dc.b $18
	dc.b  $C
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_1, 4, 6
	dc.b   0,$13
	dc.b   6,  7
	dc.b  $C,$13
	dc.b   6,  7
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_2, 4, 6
	dc.b  $C,$13
	dc.b   6,  7
	dc.b   0,$13
	dc.b   6,  7
	even

	zoneanimend

Animated_HTZ:	zoneanimstart
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
	dc.b   0,$7F
	dc.b   2,$13
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers2, ArtTile_ArtUnc_Flowers2, 8, 2
	dc.b   2,$7F
	dc.b   0, $B
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2,  5
	dc.b   0,  5
	dc.b   2,  5
	dc.b   0,  5
	even
	; Flowers
	zoneanimdecl 7, ArtUnc_Flowers3, ArtTile_ArtUnc_Flowers3, 2, 2
	dc.b   0
	dc.b   2
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers4, ArtTile_ArtUnc_Flowers4, 8, 2
	dc.b   0,$7F
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2, $B
	even
	; Pulsing thing against checkered background
	zoneanimdecl -1, ArtUnc_EHZPulseBall, ArtTile_ArtUnc_EHZPulseBall, 6, 2
	dc.b   0,$17
	dc.b   2,  9
	dc.b   4, $B
	dc.b   6,$17
	dc.b   4, $B
	dc.b   2,  9
	even

	zoneanimend

; word_4009C: Animated_OOZ:
Animated_HPZ:	zoneanimstart
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_1, 6, 8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_2, 6, 8
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_3, 6, 8
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	even

	zoneanimend

; word_400C8:  Animated_OOZ2:
Animated_OOZ:	zoneanimstart
	; Pulsing ball from OOZ
	zoneanimdecl -1, ArtUnc_OOZPulseBall, ArtTile_ArtUnc_OOZPulseBall, 4, 4
	dc.b   0, $B
	dc.b   4,  5
	dc.b   8,  9
	dc.b   4,  3
	even
	; Square rotating around ball in OOZ
	zoneanimdecl 6, ArtUnc_OOZSquareBall1, ArtTile_ArtUnc_OOZSquareBall1, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Square rotating around ball
	zoneanimdecl 6, ArtUnc_OOZSquareBall2, ArtTile_ArtUnc_OOZSquareBall2, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil1, ArtTile_ArtUnc_Oil1, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil2, ArtTile_ArtUnc_Oil2, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even

	zoneanimend

Animated_CNZ:	zoneanimstart
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_2, $10,$10
	dc.b   0,$C7
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,$C7
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	dc.b   0,  5
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,  5
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	even
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_1, $10,$10
	dc.b $70,  5
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,  5
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	dc.b $70,$C7
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,$C7
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	even

	zoneanimend

; word_40160:
Animated_CNZ_2P:	zoneanimstart
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_2_2p, $10,$10
	dc.b   0,$C7
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,$C7
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	dc.b   0,  5
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,  5
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	even
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_1_2p, $10,$10
	dc.b $70,  5
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,  5
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	dc.b $70,$C7
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,$C7
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	even

	zoneanimend

Animated_CPZ:	zoneanimstart
	; Animated background section in CPZ and DEZ
	zoneanimdecl 4, ArtUnc_CPZAnimBack, ArtTile_ArtUnc_CPZAnimBack, 8, 2
	dc.b   0
	dc.b   2
	dc.b   4
	dc.b   6
	dc.b   8
	dc.b  $A
	dc.b  $C
	dc.b  $E
	even

	zoneanimend

Animated_DEZ:	zoneanimstart
	; Animated background section in CPZ and DEZ
	zoneanimdecl 4, ArtUnc_CPZAnimBack, ArtTile_ArtUnc_DEZAnimBack, 8, 2
	dc.b   0
	dc.b   2
	dc.b   4
	dc.b   6
	dc.b   8
	dc.b  $A
	dc.b  $C
	dc.b  $E
	even

	zoneanimend

Animated_ARZ:	zoneanimstart
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall1, ArtTile_ArtUnc_Waterfall1_2, 2, 4
	dc.b   0
	dc.b   4
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall1, ArtTile_ArtUnc_Waterfall1_1, 2, 4
	dc.b   4
	dc.b   0
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall2, ArtTile_ArtUnc_Waterfall2, 2, 4
	dc.b   0
	dc.b   4
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall3, ArtTile_ArtUnc_Waterfall3, 2, 4
	dc.b   0
	dc.b   4
	even

	zoneanimend

Animated_Null:
	; invalid
; ===========================================================================

; ---------------------------------------------------------------------------
; Unused mystery function
; In CPZ, within a certain range of camera X coordinates spanning
; exactly 2 screens (a boss fight or cutscene?),
; once every 8 frames, make the entire screen refresh and do... SOMETHING...
; (in 2 separate 512-byte blocks of memory, move around a bunch of bytes)
; Maybe some abandoned scrolling effect?
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40200:
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
-	rts
; ===========================================================================
; this shifts all blocks of the chunks $EA-$ED and $FA-$FD one block to the
; left and the last block in each row (chunk $ED/$FD) to the beginning
; i.e. rotates the blocks to the left by one
+
	move.w	(Camera_X_pos).w,d0
	cmpi.w	#$1940,d0
	blo.s	-	; rts
	cmpi.w	#$1F80,d0
	bhs.s	-	; rts
	subq.b	#1,(CPZ_UnkScroll_Timer).w
	bpl.s	-	; rts	; do it every 8th frame
	move.b	#7,(CPZ_UnkScroll_Timer).w
	move.b	#1,(Screen_redraw_flag).w
	lea	(Chunk_Table+$7500).l,a1 ; chunks $EA-$ED, $FFFF7500 - $FFFF7700
	bsr.s	+
	lea	(Chunk_Table+$7D00).l,a1 ; chunks $FA-$FD, $FFFF7D00 - $FFFF7F00
+
	move.w	#7,d1

-	move.w	(a1),d0
    rept 3			; do this for 3 chunks
      rept 7
	move.w	2(a1),(a1)+	; shift 1st line of chunk by 1 block to the left (+3*14 bytes)
      endm
	move.w	$72(a1),(a1)+	; first block of next chunk to the left into previous chunk (+3*2 bytes)
	adda.w	#$70,a1		; go to next chunk (+336 bytes)
    endm
      rept 7			; now do it for the 4th chunk
	move.w	2(a1),(a1)+	; shift 1st line of chunk by 1 block to the left (+14 bytes)
      endm
	move.w	d0,(a1)+ 	; move 1st block of 1st chunk to last block of last chunk (+2 bytes, subsubtotal = 400 bytes)
	suba.w	#$180,a1 	; go to the next row in the first chunk (-384 bytes, subtotal = -16 bytes)
	dbf	d1,- 		; now do this again for rows 2-8 in these chunks
				; 400 + 7 * (-16) = 512 byte range was affected
	rts
; ===========================================================================
; loc_402D4:
LoadAnimatedBlocks:
	cmpi.b	#hill_top_zone,(Current_Zone).w
	bne.s	+
	bsr.w	PatchHTZTiles
	move.b	#-1,(Anim_Counters+1).w
	move.w	#-1,(TempArray_LayerDef+$20).w
+
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.b	#-1,(Anim_Counters+1).w
+

	rts

; ===========================================================================
; loc_407C0:
PatchHTZTiles:
	lea	(ArtNem_HTZCliffs).l,a0
	lea	(Object_RAM+$800).w,a4
	jsrto	(NemDecToRAM).l, JmpTo2_NemDecToRAM
	lea	(Object_RAM+$800).w,a1
	lea_	word_3FD9C,a4
	moveq	#0,d2
	moveq	#7,d4

loc_407DA:
	moveq	#5,d3

loc_407DC:
	moveq	#-1,d0
	move.w	(a4)+,d0
	movea.l	d0,a2
	moveq	#$1F,d1

loc_407E4:
	move.l	(a1),(a2)+
	move.l	d2,(a1)+
	dbf	d1,loc_407E4
	dbf	d3,loc_407DC
	adda.w	#$C,a4
	dbf	d4,loc_407DA
	rts
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_NemDecToRAM ; JmpTo
	jmp	(NemDecToRAM).l

	align 4
    endif



