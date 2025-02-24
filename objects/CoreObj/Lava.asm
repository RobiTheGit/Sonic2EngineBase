


; ===========================================================================
; ----------------------------------------------------------------------------
; Object 31 - Lava collision marker
; ----------------------------------------------------------------------------
; Sprite_20DEC:
Obj31:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj31_Index(pc,d0.w),d1
	jmp	Obj31_Index(pc,d1.w)
; ===========================================================================
; off_20DFA: Obj31_States:
Obj31_Index:	offsetTable
		offsetTableEntry.w Obj31_Init	; 0
		offsetTableEntry.w Obj31_Main	; 2
; ---------------------------------------------------------------------------
; byte_20DFE:
Obj31_CollisionFlagsBySubtype:
	dc.b $96	; 0
	dc.b $94	; 1
	dc.b $95	; 2
	dc.b   0	; 3
; ===========================================================================
; loc_20E02:
Obj31_Init:
	addq.b	#2,routine(a0) ; => Obj31_Main
	moveq	#0,d0
	move.b	subtype(a0),d0
	move.b	Obj31_CollisionFlagsBySubtype(pc,d0.w),collision_flags(a0)
	move.l	#Obj31_MapUnc_20E6C,mappings(a0)
	tst.w	(Debug_placement_mode).w
	beq.s	+
	move.l	#Obj31_MapUnc_20E74,mappings(a0)
+
	move.w	#make_art_tile(ArtTile_ArtNem_Powerups,0,1),art_tile(a0)
	move.b	#$84,render_flags(a0)
	move.b	#$80,width_pixels(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),mapping_frame(a0)

; loc_20E46:
Obj31_Main:
	tst.w	(Two_player_mode).w
	bne.s	+
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo18_DeleteObject
+
	tst.w	(Debug_placement_mode).w
	beq.s	+	; rts
	jsrto	(DisplaySprite).l, JmpTo10_DisplaySprite
+
	rts
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite non-mappings
; -------------------------------------------------------------------------------
Obj31_MapUnc_20E6C:	BINCLUDE "mappings/sprite/obj31_a.bin"
            even
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj31_MapUnc_20E74:	BINCLUDE "mappings/sprite/obj31_b.bin"
; ===========================================================================
                 even


