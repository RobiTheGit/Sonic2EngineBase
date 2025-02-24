


; ===========================================================================
; ----------------------------------------------------------------------------
; Object B0 - Sonic on the Sega screen
; ----------------------------------------------------------------------------
; Sprite_3A1DC:
ObjB0:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB0_Index(pc,d0.w),d1
	jmp	ObjB0_Index(pc,d1.w)
; ===========================================================================
; off_3A1EA:
ObjB0_Index:	offsetTable
		offsetTableEntry.w ObjB0_Init		;  0
		offsetTableEntry.w ObjB0_RunLeft	;  2
		offsetTableEntry.w ObjB0_MidWipe	;  4
		offsetTableEntry.w ObjB0_RunRight	;  6
		offsetTableEntry.w ObjB0_EndWipe	;  8
		offsetTableEntry.w return_3A3F6		; $A
; ===========================================================================

ObjB0_Init:
	bsr.w	LoadSubObject
	move.w	#$1E8,x_pixel(a0)
	move.w	#$F0,y_pixel(a0)
	move.w	#$B,objoff_2E(a0)
	move.w	#2,(SegaScr_VInt_Subrout).w
	bset	#0,render_flags(a0)
	bset	#0,status(a0)

	; Initialize streak horizontal offsets for Sonic going left.
	; 9 full lines (8 pixels) + 6 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 6)).w,a1
	lea	Streak_Horizontal_offsets(pc),a2
	moveq	#0,d0
	moveq	#$22,d6	; Number of streaks-1
-	move.b	(a2)+,d0
	add.w	d0,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-

	lea	off_3A294(pc),a1 ; pointers to mapping DPLC data
	lea	(ArtUnc_Sonic).l,a3
	lea	(Chunk_Table).l,a5
	moveq	#4-1,d5 ; there are 4 mapping frames to loop over

	; this copies the tiles that we want to scale up from ROM to RAM
;loc_3A246:
;CopySpriteTilesToRAMForSegaScreen:
-	movea.l	(a1)+,a2
	move.w	(a2)+,d6 ; get the number of pieces in this mapping frame
	subq.w	#1,d6
-	move.w	(a2)+,d0
	move.w	d0,d1
	; Depending on the exact location (and size) of the art being used,
	; you may encounter an overflow in the original code which garbles
	; the enlarged Sonic. The following code fixes this:
    if 1==0
	andi.l	#$FFF,d0
	lsl.l	#5,d0
	lea	(a3,d0.l),a4 ; source ROM address of tiles to copy
    else
	andi.w	#$FFF,d0
	lsl.w	#5,d0
	lea	(a3,d0.w),a4 ; source ROM address of tiles to copy
    endif
	andi.w	#$F000,d1 ; abcd000000000000
	rol.w	#4,d1	  ; (this calculation can be done smaller and faster
	addq.w	#1,d1	  ; by doing rol.w #7,d1 addq.w #7,d1
	lsl.w	#3,d1	  ; instead of these 4 lines)
	subq.w	#1,d1	  ; 000000000abcd111 ; number of dwords to copy minus 1
-	move.l	(a4)+,(a5)+
	dbf	d1,- ; copy all of the pixels in this piece into the temp buffer
	dbf	d6,-- ; loop per piece in the frame
	dbf	d5,--- ; loop per mapping frame

	; this scales up the tiles by 2
;ScaleUpSpriteTiles:
	move.w	d7,-(sp)
	moveq	#0,d0
	moveq	#0,d1
	lea	SonicRunningSpriteScaleData(pc),a6
	moveq	#4*2-1,d7 ; there are 4 sprite mapping frames with 2 pieces each
-	movea.l	(a6)+,a1 ; source in RAM of tile graphics to enlarge
	movea.l	(a6)+,a2 ; destination in RAM of enlarged graphics
	move.b	(a6)+,d0 ; width of the sprite piece to enlarge (minus 1)
	move.b	(a6)+,d1 ; height of the sprite piece to enlarge (minus 1)
	bsr.w	Scale_2x
	dbf	d7,- ; loop over each piece
	move.w	(sp)+,d7

	rts
; ===========================================================================
	; These next four things are pointers to Sonic's dereferenced
	; DPLC entries of his "running animation" frames for the SEGA screen.
	; I want that DPLC data split into a binary file for use with editors,
	; but unfortunately there's no way to refer to BINCLUDE'd bytes
	; from within AS, so I put an educated guess (default) here and
	; run an external program (fixpointer.exe) to fix it later.
; WARNING: the build script needs editing if you rename this label
off_3A294:
	dc.l (MapRUnc_Sonic+$33A)	;dc.l word_7181A
	dc.l (MapRUnc_Sonic+$340)	;dc.l word_71820
	dc.l (MapRUnc_Sonic+$346)	;dc.l word_71826
	dc.l (MapRUnc_Sonic+$34C)	;dc.l word_7182C

map_piece macro width,height
	dc.l copysrc,copydst
	dc.b width-1,height-1
copysrc := copysrc + tiles_to_bytes(width * height)
copydst := copydst + tiles_to_bytes(width * height) * 2 * 2
    endm
;word_3A2A4:
SonicRunningSpriteScaleData:
copysrc := Chunk_Table
copydst := Chunk_Table + $B00
SegaScreenScaledSpriteDataStart = copydst
	rept 4 ; repeat 4 times since there are 4 frames to scale up
	; piece 1 of each frame (the smaller top piece):
	map_piece 3,2
	; piece 2 of each frame (the larger bottom piece):
	map_piece 4,4
	endm
SegaScreenScaledSpriteDataEnd = copydst
	if copysrc > SegaScreenScaledSpriteDataStart
	fatal "Scale copy source overran allocated size. Try changing the initial value of copydst to Chunk_Table+$\{copysrc-Chunk_Table}"
	endif
; ===========================================================================

ObjB0_RunLeft:
	subi.w	#$20,x_pos(a0)
	subq.w	#1,objoff_2E(a0)
	bmi.s	loc_3A312
	bsr.w	ObjB0_Move_Streaks_Left
	lea	(Ani_objB0).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_3A312:
	addq.b	#2,routine(a0)
	move.w	#$C,objoff_2E(a0)
	move.b	#1,objoff_30(a0)
	move.b	#-1,objoff_31(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjB0_MidWipe:
	tst.w	objoff_2E(a0)
	beq.s	loc_3A33A
	subq.w	#1,objoff_2E(a0)
	bsr.w	ObjB0_Move_Streaks_Left

loc_3A33A:
	lea	word_3A49E(pc),a1
	bsr.w	loc_3A44E
	bne.s	loc_3A346
	rts
; ===========================================================================

loc_3A346:
	addq.b	#2,routine(a0)
	bchg	#0,render_flags(a0)
	move.w	#$B,objoff_2E(a0)
	move.w	#4,(SegaScr_VInt_Subrout).w
	subi.w	#$28,x_pos(a0)
	bchg	#0,render_flags(a0)
	bchg	#0,status(a0)

	; This clears a lot more than the horizontal scroll buffer, which is $400 bytes.
	; This is because the loop counter is erroneously set to $400, instead of ($400/4)-1.
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf_End+$C04	; Bug: That '+$C04' shouldn't be there; accidentally clears an additional $C04 bytes

	; Initialize streak horizontal offsets for Sonic going right.
	; 9 full lines (8 pixels) + 7 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 7)).w,a1
	lea	Streak_Horizontal_offsets(pc),a2
	moveq	#0,d0
	moveq	#$22,d6	; Number of streaks-1

loc_3A38A:
	move.b	(a2)+,d0
	sub.w	d0,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,loc_3A38A
	rts
; ===========================================================================

ObjB0_RunRight:
	subq.w	#1,objoff_2E(a0)
	bmi.s	loc_3A3B4
	addi.w	#$20,x_pos(a0)
	bsr.w	ObjB0_Move_Streaks_Right
	lea	(Ani_objB0).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

loc_3A3B4:
	addq.b	#2,routine(a0)
	move.w	#$C,objoff_2E(a0)
	move.b	#1,objoff_30(a0)
	move.b	#-1,objoff_31(a0)
	rts
; ===========================================================================

ObjB0_EndWipe:
	tst.w	objoff_2E(a0)
	beq.s	loc_3A3DA
	subq.w	#1,objoff_2E(a0)
	bsr.w	ObjB0_Move_Streaks_Right

loc_3A3DA:
	lea	word_3A514(pc),a1
	bsr.w	loc_3A44E
	bne.s	loc_3A3E6
	rts
; ===========================================================================

loc_3A3E6:
	addq.b	#2,routine(a0)
	st	(SegaScr_PalDone_Flag).w
	move.b	#SndID_SegaSound,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound

return_3A3F6:
	rts
; ===========================================================================
; ----------------------------------------------------------------------------
; Object B1 - Object that hides TM symbol on JP region
; ----------------------------------------------------------------------------
; Sprite_3A3F8:
ObjB1:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjB1_Index(pc,d0.w),d1
	jmp	ObjB1_Index(pc,d1.w)
; ===========================================================================
; off_3A406:
ObjB1_Index:	offsetTable
		offsetTableEntry.w ObjB1_Init	; 0
		offsetTableEntry.w ObjB1_Main	; 2
; ===========================================================================
; loc_3A40A:
ObjB1_Init:
	bsr.w	LoadSubObject
	move.b	#4,mapping_frame(a0)
	move.w	#$174,x_pixel(a0)
	move.w	#$D8,y_pixel(a0)
	rts
; ===========================================================================
; BranchTo4_JmpTo45_DisplaySprite
ObjB1_Main:
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjB0_Move_Streaks_Left:
	; 9 full lines (8 pixels) + 6 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 6)).w,a1

	move.w	#$22,d6	; Number of streaks-1
-	subi.w	#$20,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-
	rts
; ===========================================================================

ObjB0_Move_Streaks_Right:
	; 9 full lines (8 pixels) + 7 pixels, 2-byte interleaved entries for PNT A and PNT B
	lea	(Horiz_Scroll_Buf + 2 * 2 * (9 * 8 + 7)).w,a1

	move.w	#$22,d6	; Number of streaks-1
-	addi.w	#$20,(a1)
	addq.w	#2 * 2 * 2,a1	; Advance to next streak 2 pixels down
	dbf	d6,-
	rts
; ===========================================================================

loc_3A44E:
	subq.b	#1,objoff_30(a0)
	bne.s	loc_3A496
	moveq	#0,d0
	move.b	objoff_31(a0),d0
	addq.b	#1,d0
	cmp.b	1(a1),d0
	blo.s	loc_3A468
	tst.b	3(a1)
	bne.s	loc_3A49A

loc_3A468:
	move.b	d0,objoff_31(a0)
	move.b	0(a1),objoff_30(a0)
	lea	6(a1),a2		; This loads a palette: Sega Screen 2.bin or Sega Screen 3.bin
	moveq	#0,d1
	move.b	2(a1),d1
	move.w	d1,d2
	tst.w	d0
	beq.s	loc_3A48C

loc_3A482:
	subq.b	#1,d0
	beq.s	loc_3A48A
	add.w	d2,d1
	bra.s	loc_3A482
; ===========================================================================

loc_3A48A:
	adda.w	d1,a2

loc_3A48C:
	movea.w	4(a1),a3

loc_3A490:
	move.w	(a2)+,(a3)+
	subq.w	#2,d2
	bne.s	loc_3A490

loc_3A496:
	moveq	#0,d0
	rts
; ===========================================================================

loc_3A49A:
	moveq	#1,d0
	rts
; ===========================================================================

; probably some sort of description of how to use the following palette
word_3A49E:
	dc.b   4	; 0	; How many frames before each iteration
	dc.b   7	; 1	; How many iterations
	dc.b $10	; 2	; Number of colors * 2 to skip each iteration
	dc.b $FF	; 3	; Some sort of flag
	dc.w Normal_palette+$10	; 4	; First target palette entry

; Palette for the SEGA screen (background and pre-wipe foreground) (7 frames)
;pal_3A4A4:
	BINCLUDE	"art/palettes/Sega Screen 2.bin"
                      even

; probably some sort of description of how to use the following palette
word_3A514:
	dc.b   4	; 0	; How many frames before each iteration
	dc.b   7	; 1	; How many iterations
	dc.b $10	; 2	; Number of colors * 2 to skip each iteration
	dc.b $FF	; 3	; Some sort of flag
	dc.w Normal_palette	; 4	; First target palette entry

; Palette for the SEGA screen (wiping and post-wipe foreground) (7 frames)
;pal_3A51A:
	BINCLUDE	"art/palettes/Sega Screen 3.bin"
                   even
; off_3A58A:
ObjB0_SubObjData:
	subObjData ObjB1_MapUnc_3A5A6,make_art_tile(ArtTile_ArtUnc_Giant_Sonic,2,1),0,1,$10,0

; off_3A594:
ObjB1_SubObjData:
	subObjData ObjB1_MapUnc_3A5A6,make_art_tile(ArtTile_ArtNem_Sega_Logo+2,0,0),0,2,8,0

; animation script
; off_3A59E:
Ani_objB0:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   0,  0,  1,  2,  3,$FF
		even

; ------------------------------------------------------------------------------
; sprite mappings
; Gigantic Sonic (2x size) mappings for the SEGA screen
; also has the "trademark hider" mappings
; ------------------------------------------------------------------------------
ObjB1_MapUnc_3A5A6:	BINCLUDE "mappings/sprite/objB1.bin"
         even
; ===========================================================================
;loc_3A68A
SegaScr_VInt:
	move.w	(SegaScr_VInt_Subrout).w,d0
	beq.w	return_37A48
	clr.w	(SegaScr_VInt_Subrout).w
	move.w	off_3A69E-2(pc,d0.w),d0
	jmp	off_3A69E(pc,d0.w)
; ===========================================================================
off_3A69E:	offsetTable
		offsetTableEntry.w loc_3A6A2	; 0
		offsetTableEntry.w loc_3A6D4	; 2
; ===========================================================================

loc_3A6A2:
	dma68kToVDP SegaScreenScaledSpriteDataStart,tiles_to_bytes(ArtTile_ArtUnc_Giant_Sonic),\
	            SegaScreenScaledSpriteDataEnd-SegaScreenScaledSpriteDataStart,VRAM

	lea	ObjB1_Streak_fade_to_right(pc),a1
	; 9 full lines ($100 bytes each) plus $28 8-pixel cells
	move.l	#vdpComm(VRAM_SegaScr_Plane_A_Name_Table + planeLocH80($28,9),VRAM,WRITE),d0	; $49500003
	bra.w	loc_3A710
; ===========================================================================

loc_3A6D4:
	dmaFillVRAM 0,VRAM_SegaScr_Plane_A_Name_Table,VRAM_SegaScr_Plane_Table_Size ; clear Plane A pattern name table

	lea	ObjB1_Streak_fade_to_left(pc),a1
	; $49A00003; 9 full lines ($100 bytes each) plus $50 8-pixel cells
	move.l	#vdpComm(VRAM_SegaScr_Plane_A_Name_Table + planeLocH80($50,9),VRAM,WRITE),d0
	bra.w	loc_3A710
loc_3A710:
	lea	(VDP_data_port).l,a6
	; This is the line delta; for each line, the code below
	; writes $30 entries, leaving $50 untouched.
	move.l	#vdpCommDelta(planeLocH80(0,1)),d6	; $1000000
	moveq	#7,d1	; Inner loop: repeat 8 times
	moveq	#9,d2	; Outer loop: repeat $A times
-
	move.l	d0,4(a6)	; Send command to VDP: set address to write to
	move.w	d1,d3		; Reset inner loop counter
	movea.l	a1,a2		; Reset data pointer
-
	move.w	(a2)+,d4	; Read one pattern name table entry
	bclr	#$A,d4		; Test bit $A and clear (flag for end of line)
	beq.s	+			; Branch if bit was clear
	bsr.w	loc_3A742	; Fill rest of line with this set of pixels
+
	move.w	d4,(a6)		; Write PNT entry
	dbf	d3,-
	add.l	d6,d0		; Point to the next VRAM area to be written to
	dbf	d2,--
	rts
; ===========================================================================

loc_3A742:
	moveq	#$28,d5		; Fill next $29 entries...
-
	move.w	d4,(a6)		; ... using the PNT entry that had bit $A set
	dbf	d5,-
	rts
; ===========================================================================
; Pattern A name table entries, with special flag detailed below
; These are used for the streaks, and point to VRAM in the $1000-$10FF range
ObjB1_Streak_fade_to_right:
	dc.w make_block_tile(ArtTile_ArtNem_Trails+0,0,0,1,1)	; 0
	dc.w make_block_tile(ArtTile_ArtNem_Trails+1,0,0,1,1)	; 2
	dc.w make_block_tile(ArtTile_ArtNem_Trails+2,0,0,1,1)	; 4
	dc.w make_block_tile(ArtTile_ArtNem_Trails+3,0,0,1,1)	; 6
	dc.w make_block_tile(ArtTile_ArtNem_Trails+4,0,0,1,1)	; 8
	dc.w make_block_tile(ArtTile_ArtNem_Trails+5,0,0,1,1)	; 10
	dc.w make_block_tile(ArtTile_ArtNem_Trails+6,0,0,1,1)	; 12
	dc.w make_block_tile(ArtTile_ArtNem_Trails+7,0,0,1,1) | (1 << $A)	; 14	; Bit $A is used as a flag to use this tile $29 times
ObjB1_Streak_fade_to_left:
	dc.w make_block_tile(ArtTile_ArtNem_Trails+7,0,0,1,1) | (1 << $A)	;  0	; Bit $A is used as a flag to use this tile $29 times
	dc.w make_block_tile(ArtTile_ArtNem_Trails+6,0,0,1,1)	; 2
	dc.w make_block_tile(ArtTile_ArtNem_Trails+5,0,0,1,1)	; 4
	dc.w make_block_tile(ArtTile_ArtNem_Trails+4,0,0,1,1)	; 6
	dc.w make_block_tile(ArtTile_ArtNem_Trails+3,0,0,1,1)	; 8
	dc.w make_block_tile(ArtTile_ArtNem_Trails+2,0,0,1,1)	; 10
	dc.w make_block_tile(ArtTile_ArtNem_Trails+1,0,0,1,1)	; 12
	dc.w make_block_tile(ArtTile_ArtNem_Trails+0,0,0,1,1)	; 14
Streak_Horizontal_offsets:
	dc.b $12
	dc.b   4	; 1
	dc.b   4	; 2
	dc.b   2	; 3
	dc.b   2	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b   0	; 7
	dc.b   0	; 8
	dc.b   0	; 9
	dc.b   0	; 10
	dc.b   0	; 11
	dc.b   0	; 12
	dc.b   0	; 13
	dc.b   0	; 14
	dc.b   4	; 15
	dc.b   4	; 16
	dc.b   6	; 17
	dc.b  $A	; 18
	dc.b   8	; 19
	dc.b   6	; 20
	dc.b   4	; 21
	dc.b   4	; 22
	dc.b   4	; 23
	dc.b   4	; 24
	dc.b   6	; 25
	dc.b   6	; 26
	dc.b   8	; 27
	dc.b   8	; 28
	dc.b  $A	; 29
	dc.b  $A	; 30
	dc.b  $C	; 31
	dc.b  $E	; 32
	dc.b $10	; 33
	dc.b $16	; 34
	dc.b   0	; 35
