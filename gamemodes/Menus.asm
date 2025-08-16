; ===========================================================================
; loc_7D50:
TwoPlayerResults:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)	; PNT A base: $C000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9001,(a6)		; Scroll table size: 64x32

	clearRAM Sprite_Table_Input,Sprite_Table_Input_End
	clearRAM VSRslts_Object_RAM,VSRslts_Object_RAM_End

	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_1P2PWins),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_1P2PWins).l,a0
	bsr.w	NemDec
	lea	(Chunk_Table).l,a1
	lea	(MapEng_MenuBack).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,3,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#$27,d1
	moveq	#$1B,d2
	jsrto	(PlaneMapToVRAM_H40).l, PlaneMapToVRAM_H40
	move.w	(Results_Screen_2P).w,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,d0
	lea	TwoPlayerResultsPointers(pc),a2
	movea.l	(a2,d0.w),a0
	movea.l	4(a2,d0.w),a2
	lea	(Chunk_Table).l,a1
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec
	jsr	(a2)	; dynamic call! to Setup2PResults_Act, Setup2PResults_Zone, Setup2PResults_Game, Setup2PResults_SpecialAct, or Setup2PResults_SpecialZone, assuming the pointers in TwoPlayerResultsPointers have not been changed
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(tiles_to_bytes(ArtTile_TwoPlayerResults),VRAM,WRITE),d0
	moveq	#$27,d1
	moveq	#$1B,d2
	jsrto	(PlaneMapToVRAM_H40).l, PlaneMapToVRAM_H40
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo_Dynamic_Normal
	move	#$2700,sr
	lea	(Std1PLCload).l,a2
	   jsr	SubLoopPLCentry
	move	#$2300,sr
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	moveq	#0,d0
	move.b	#MusID_2PResult,d0
	cmp.w	(Level_Music).w,d0
	beq.s	+
	move.w	d0,(Level_Music).w
	bsr.w	PlayMusic
+
	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.l	(Vscroll_Factor).w
	clr.l	(Vscroll_Factor_P2).w
	clr.l	(Vscroll_Factor_P2_HInt).w
	move.l	#Obj21,(VSResults_HUD).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack

-	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo_Dynamic_Normal
	jsr	(RunObjects).l
	jsr	(BuildSprites).l
	bsr.w	RunPLC_RAM
	tst.l	(Plc_Buffer).w
	bne.s	-
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	beq.s	-			; stay on that screen until either player presses start

	move.w	(Results_Screen_2P).w,d0 ; were we at the act results screen? (VsRSID_Act)
	bne.w	TwoPlayerResultsDone_Zone ; if not, branch
	tst.b	(Current_Act).w		; did we just finish act 1?
	bne.s	+			; if not, branch
	addq.b	#1,(Current_Act).w	; go to the next act
	move.b	#1,(Current_Act_2P).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	moveq	#0,d0
	move.l	d0,(Score).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	rts
; ===========================================================================
+	; Displays results for the zone
	move.b	#2,(Current_Act_2P).w
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	bsr.s	sub_7F9A
	bsr.s	sub_7F9A
	move.b	(a4),d1
	sub.b	1(a4),d1
	beq.s	+		; if there's a tie, branch
	move.w	#VsRSID_Zone,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+	; There's a tie, play a special stage
	move.b	(Current_Zone_2P).w,d0
	addq.b	#1,d0
	move.b	d0,(Current_Special_Stage).w
	move.w	#VsRSID_SS,(Results_Screen_2P).w
	move.b	#1,(SpecialStage_flag_2P).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_7F9A:
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	beq.s	++
	bcs.s	+
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	addq.b	#1,1(a4)
+
	addq.w	#2,a5
	rts
; End of function sub_7F9A

; ===========================================================================

; loc_7FB2:
TwoPlayerResultsDone_Zone:
	subq.w	#1,d0			; were we at the zone results screen? (VsRSID_Zone)
	bne.s	TwoPlayerResultsDone_Game ; if not, branch

; loc_7FB6:
TwoPlayerResultsDone_ZoneOrSpecialStages:
	lea	(Results_Data_2P).w,a4
	moveq	#0,d0
	moveq	#0,d1
    rept 3
	move.w	(a4)+,d0
	add.l	d0,d1
	move.w	(a4)+,d0
	add.l	d0,d1
	addq.w	#2,a4
    endm
	move.w	(a4)+,d0
	add.l	d0,d1
	move.w	(a4)+,d0
	add.l	d0,d1
	swap	d1
	tst.w	d1	; have all levels been completed?
	bne.s	+	; if not, branch
	move.w	#VsRSID_Game,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+
	tst.b	(Game_Over_2P).w
	beq.s	+		; if there's a Game Over, clear the results
	lea	(Results_Data_2P).w,a1

	moveq	#bytesToWcnt(Results_Data_2P_End-Results_Data_2P),d0
-	move.w	#-1,(a1)+
	dbf	d0,-

	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
+
	move.b	#GameModeID_2PLevelSelect,(Game_Mode).w ; => LevelSelectMenu2P
	rts
; ===========================================================================
; loc_8020:
TwoPlayerResultsDone_Game:
	subq.w	#1,d0	; were we at the game results screen? (VsRSID_Game)
	bne.s	TwoPlayerResultsDone_SpecialStage ; if not, branch
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================
; loc_802C:
TwoPlayerResultsDone_SpecialStage:
	subq.w	#1,d0			; were we at the special stage results screen? (VsRSID_SS)
	bne.w	TwoPlayerResultsDone_SpecialStages ; if not, branch
	cmpi.b	#3,(Current_Zone_2P).w	; do we come from the special stage "zone"?
	beq.s	+			; if yes, branch
	move.w	#VsRSID_Zone,(Results_Screen_2P).w ; show zone results after tiebreaker special stage
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
+
	tst.b	(Current_Act_2P).w
	beq.s	+
	cmpi.b	#2,(Current_Act_2P).w
	beq.s	loc_80AC
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	bsr.s	sub_8094
	bsr.s	sub_8094
	move.b	(a4),d1
	sub.b	1(a4),d1
	bne.s	loc_80AC
+
	addq.b	#1,(Current_Act_2P).w
	addq.b	#1,(Current_Special_Stage).w
	move.w	#VsRSID_SS,(Results_Screen_2P).w
	move.b	#1,(SpecialStage_flag_2P).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	move.w	#1,(Two_player_mode).w
	move.w	#0,(Level_Music).w
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8094:
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	beq.s	++
	bcs.s	+
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	addq.b	#1,1(a4)
+
	addq.w	#2,a5
	rts
; End of function sub_8094

; ===========================================================================

loc_80AC:
	move.w	#VsRSID_SSZone,(Results_Screen_2P).w
	move.b	#GameModeID_2PResults,(Game_Mode).w ; => TwoPlayerResults
	rts
; ===========================================================================
; loc_80BA: BranchTo_loc_7FB6:
TwoPlayerResultsDone_SpecialStages:
	; we were at the special stages results screen (VsRSID_SSZone)
	bra.w	TwoPlayerResultsDone_ZoneOrSpecialStages

; ===========================================================================
; ----------------------------------------------------------------------------
; Object 21 - Score/Rings/Time display (in 2P results)
; ----------------------------------------------------------------------------
; Sprite_80BE:
Obj21: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj21_Index(pc,d0.w),d1
	jmp	Obj21_Index(pc,d1.w)
; ===========================================================================
; JmpTbl_80CC: Obj21_States:
Obj21_Index:	offsetTable
		offsetTableEntry.w Obj21_Init	; 0
		offsetTableEntry.w Obj21_Main	; 2
; ---------------------------------------------------------------------------
; word_80D0:
Obj21_PositionTable:
	;	 x,    y
	dc.w $F0, $148
	dc.w $F0, $130
	dc.w $E0, $148
	dc.w $F0, $148
	dc.w $F0, $148
; ===========================================================================
; loc_80E4:
Obj21_Init:
	addq.b	#2,routine(a0) ; => Obj21_Main
	move.w	(Results_Screen_2P).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.l	Obj21_PositionTable(pc,d0.w),x_pixel(a0) ; and y_pixel(a0)
	move.l	#Obj21_MapUnc_8146,mappings(a0)
 	move.w	#make_art_tile(ArtTile_ArtNem_1P2PWins,0,0),art_tile(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo2_Adjust2PArtPointer
	move.b	#0,render_flags(a0)
	move.b	#0,priority(a0)
	moveq	#2,d1
	move.b	(SS_Total_Won).w,d0	; d0 = SS_Total_Won_1P
	sub.b	(SS_Total_Won+1).w,d0	;    - SS_Total_Won_2P
	beq.s	++
	bcs.s	+
	moveq	#0,d1
	bra.s	++
; ---------------------------------------------------------------------------
+
	moveq	#1,d1
+
	move.b	d1,mapping_frame(a0)

; loc_812C:
Obj21_Main:
	andi.w	#tile_mask,art_tile(a0)
	btst	#3,(Vint_runcount+3).w
	beq.s	JmpTo4_DisplaySprite
	ori.w	#palette_line_1,art_tile(a0)

JmpTo4_DisplaySprite ; JmpTo
	jmp	(DisplaySprite).l
; ===========================================================================
; --------------------------------------------------------------------------
; sprite mappings
; --------------------------------------------------------------------------
Obj21_MapUnc_8146:	BINCLUDE "mappings/sprite/obj21.bin"
		 even
; ===========================================================================

; loc_819A:
Setup2PResults_Act:
	move.w	#$1F2,d2
	moveq	#0,d0
	bsr.w	sub_8672
	move.w	#$216,d2
	moveq	#0,d1
	move.b	(Current_Act_2P).w,d1
	addq.b	#1,d1
	bsr.w	sub_86B0
	move.w	#$33E,d2
	move.l	(Score).w,d1
	bsr.w	sub_86F6
	move.w	#$352,d2
	move.l	(Score_2P).w,d1
	bsr.w	sub_86F6
	move.w	#$3DA,d2
	moveq	#0,d0
	move.w	(Timer_minute_word).w,d1
	bsr.w	sub_86B0
	move.w	#$3E0,d2
	moveq	#0,d1
	move.b	(Timer_second).w,d1
	bsr.w	sub_86B0
	move.w	#$3E6,d2
	moveq	#0,d1
	move.b	(Timer_frame).w,d1
	mulu.w	#$1B0,d1
	lsr.l	#8,d1
	bsr.w	sub_86B0
	move.w	#$3EE,d2
	moveq	#0,d0
	move.w	(Timer_minute_word_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$3F4,d2
	moveq	#0,d1
	move.b	(Timer_second_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$3FA,d2
	moveq	#0,d1
	move.b	(Timer_centisecond_2P).w,d1
	mulu.w	#$1B0,d1
	lsr.l	#8,d1
	bsr.w	sub_86B0
	move.w	#$486,d2
	moveq	#0,d0
	move.w	(Ring_count).w,d1
	bsr.w	sub_86B0
	move.w	#$49A,d2
	move.w	(Ring_count_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$526,d2
	moveq	#0,d0
	move.w	(Rings_Collected).w,d1
	bsr.w	sub_86B0
	move.w	#$53A,d2
	move.w	(Rings_Collected_2P).w,d1
	bsr.w	sub_86B0
	move.w	#$5C6,d2
	moveq	#0,d0
	move.w	(Monitors_Broken).w,d1
	bsr.w	sub_86B0
	move.w	#$5DA,d2
	move.w	(Monitors_Broken_2P).w,d1
	bsr.w	sub_86B0
	bsr.w	sub_8476
	move.w	#$364,d2
	move.w	#$6000,d0
	move.l	(Score).w,d1
	sub.l	(Score_2P).w,d1
	bsr.w	sub_8652
	move.w	#$404,d2
	move.l	(Timer_2P).w,d1
	sub.l	(Timer).w,d1
	bsr.w	sub_8652
	move.w	#$4A4,d2
	moveq	#0,d1
	move.w	(Ring_count).w,d1
	sub.w	(Ring_count_2P).w,d1
	bsr.w	sub_8652
	move.w	#$544,d2
	moveq	#0,d1
	move.w	(Rings_Collected).w,d1
	sub.w	(Rings_Collected_2P).w,d1
	bsr.w	sub_8652
	move.w	#$5E4,d2
	moveq	#0,d1
	move.w	(Monitors_Broken).w,d1
	sub.w	(Monitors_Broken_2P).w,d1
	bsr.w	sub_8652
	move.w	#$706,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a4),d1
	bsr.w	sub_86B0
	move.w	#$70E,d2
	moveq	#0,d1
	move.b	1(a4),d1
	bsr.w	sub_86B0
	move.w	(a4),(SS_Total_Won).w
	rts
; ===========================================================================
; loc_82FA:
Setup2PResults_Zone:
	move.w	#$242,d2
	moveq	#0,d0
	bsr.w	sub_8672
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$398,d6
	bsr.w	sub_854A
	move.w	#$488,d6
	bsr.w	sub_854A
	move.w	#$618,d6
	bsr.w	sub_854A
	rts
; ===========================================================================
; loc_8328:
Setup2PResults_Game:
	lea	(Results_Data_2P).w,a5
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$208,d6
	bsr.w	sub_84C4
	move.w	#$258,d6
	bsr.w	sub_84C4
	move.w	#$2A8,d6
	bsr.w	sub_84C4
	move.w	#$348,d6
	bsr.w	sub_84C4
	move.w	#$398,d6
	bsr.w	sub_84C4
	move.w	#$3E8,d6
	bsr.w	sub_84C4
	move.w	#$488,d6
	bsr.w	sub_84C4
	move.w	#$4D8,d6
	bsr.w	sub_84C4
	move.w	#$528,d6
	bsr.w	sub_84C4
	move.w	#$5C8,d6
	bsr.w	sub_84C4
	move.w	#$618,d6
	bsr.w	sub_84C4
	move.w	#$668,d6
	bsr.w	sub_84C4
	move.w	#$70A,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a4),d1
	bsr.w	sub_86B0
	move.w	#$710,d2
	moveq	#0,d1
	move.b	1(a4),d1
	bsr.w	sub_86B0
	rts
; ===========================================================================
; loc_83B0:
Setup2PResults_SpecialAct:
	move.w	#$266,d2
	moveq	#0,d1
	move.b	(Current_Act_2P).w,d1
	addq.b	#1,d1
	bsr.w	sub_86B0
	move.w	#$4D6,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer).w,d1		; P1 SS act 1 rings
	bsr.w	sub_86B0
	move.w	#$4E6,d2
	move.w	(SS2p_RingBuffer+2).w,d1	; P2 SS act 1 rings
	bsr.w	sub_86B0
	move.w	#$576,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer+4).w,d1	; P1 SS act 2 rings
	bsr.w	sub_86B0
	move.w	#$586,d2
	move.w	(SS2p_RingBuffer+6).w,d1	; P2 SS act 2 rings
	bsr.w	sub_86B0
	move.w	#$616,d2
	moveq	#0,d0
	move.w	(SS2p_RingBuffer+8).w,d1	; P1 SS act 3 rings
	bsr.w	sub_86B0
	move.w	#$626,d2
	move.w	(SS2p_RingBuffer+$A).w,d1	; P2 SS act 3 rings
	bsr.w	sub_86B0
	bsr.w	sub_8476
	move.w	#$6000,d0
	move.w	#$4F0,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer).w,d1		; P1 SS act 1 rings
	sub.w	(SS2p_RingBuffer+2).w,d1	; P2 SS act 1 rings
	bsr.w	sub_8652
	move.w	#$590,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer+4).w,d1	; P1 SS act 2 rings
	sub.w	(SS2p_RingBuffer+6).w,d1	; P2 SS act 2 rings
	bsr.w	sub_8652
	move.w	#$630,d2
	moveq	#0,d1
	move.w	(SS2p_RingBuffer+8).w,d1	; P1 SS act 3 rings
	sub.w	(SS2p_RingBuffer+$A).w,d1	; P2 SS act 3 rings
	bsr.w	sub_8652
	move.w	(a4),(SS_Total_Won).w
	rts
; ===========================================================================
; loc_8452:
Setup2PResults_SpecialZone:
	bsr.w	sub_84A4
	lea	(SS_Total_Won).w,a4
	clr.w	(a4)
	move.w	#$4D4,d6
	bsr.w	sub_85CE
	move.w	#$574,d6
	bsr.w	sub_85CE
	move.w	#$614,d6
	bsr.w	sub_85CE
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8476:
	lea	(EHZ_Results_2P).w,a4
	move.b	(Current_Zone_2P).w,d0
	beq.s	+
	lea	(MCZ_Results_2P).w,a4
	subq.b	#1,d0
	beq.s	+
	lea	(CNZ_Results_2P).w,a4
	subq.b	#1,d0
	beq.s	+
	lea	(SS_Results_2P).w,a4
+
	moveq	#0,d0
	move.b	(Current_Act_2P).w,d0
	add.w	d0,d0
	lea	(a4,d0.w),a4
	clr.w	(a4)
	rts
; End of function sub_8476


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_84A4:
	lea	(EHZ_Results_2P).w,a5
	move.b	(Current_Zone_2P).w,d0
	beq.s	+	; rts
	lea	(MCZ_Results_2P).w,a5
	subq.b	#1,d0
	beq.s	+	; rts
	lea	(CNZ_Results_2P).w,a5
	subq.b	#1,d0
	beq.s	+	; rts
	lea	(SS_Results_2P).w,a5
+
	rts
; End of function sub_84A4


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_84C4:
	move.w	(a5),d0
	bmi.s	+
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addq.w	#8,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$12,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================
+
	addq.w	#4,d6
	not.w	d0
	bne.s	+
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$16,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.w	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================
+
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$16,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_84C4


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_854A:
	move.w	(a5),d0
	bmi.s	loc_8582
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addq.w	#8,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$C,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================

loc_8582:
	not.w	d0
	bne.s	loc_85A6
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.w	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================

loc_85A6:
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_854A


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_85CE:
	move.w	(a5),d0
	bmi.s	+
	move.w	d6,d2
	moveq	#0,d0
	moveq	#0,d1
	move.b	(a5),d1
	bsr.w	sub_86B0
	addi.w	#$C,d6
	move.w	d6,d2
	moveq	#0,d1
	move.b	1(a5),d1
	bsr.w	sub_86B0
	addi.w	#$10,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; ===========================================================================
+
	not.w	d0
	bne.s	loc_862C
	lea	(Text2P_NoGame).l,a1
	move.w	d6,d2
	addq.w	#4,d2
	bsr.w	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	lea	(Text2P_Blank).l,a1
	bsr.s	loc_8698
	addq.w	#2,a5
	rts
; ===========================================================================

loc_862C:
	moveq	#0,d0
	lea	(Text2P_GameOver).l,a1
	move.w	d6,d2
	bsr.s	loc_8698
	addi.w	#$14,d6
	move.w	d6,d2
	move.w	#$6000,d0
	moveq	#0,d1
	move.b	(a5),d1
	sub.b	1(a5),d1
	bsr.w	sub_8652
	addq.w	#2,a5
	rts
; End of function sub_85CE


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8652:
	lea	(Text2P_Tied).l,a1
	beq.s	++
	bcs.s	+
	lea	(Text2P_1P).l,a1
	addq.b	#1,(a4)
	bra.s	++
; ===========================================================================
+
	lea	(Text2P_2P).l,a1
	addq.b	#1,1(a4)
+
	bra.s	loc_8698
; End of function sub_8652


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_8672:
	lea	(Text2P_EmeraldHill).l,a1
	move.b	(Current_Zone_2P).w,d1
	beq.s	loc_8698
	lea	(Text2P_MysticCave).l,a1
	subq.b	#1,d1
	beq.s	loc_8698
	lea	(Text2P_CasinoNight).l,a1
	subq.b	#1,d1
	beq.s	loc_8698
	lea	(Text2P_SpecialStage).l,a1

loc_8698:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	moveq	#0,d1

	move.b	(a1)+,d1
-	move.b	(a1)+,d0
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; End of function sub_8672


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_86B0:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	lea	(word_86F0).l,a3
	moveq	#0,d2

	moveq	#2,d5
-	moveq	#0,d3
	move.w	(a3)+,d4

-	sub.w	d4,d1
	bcs.s	+
	addq.w	#1,d3
	bra.s	-
; ---------------------------------------------------------------------------
+
	add.w	d4,d1
	tst.w	d5
	beq.s	++
	tst.w	d3
	beq.s	+
	moveq	#1,d2
+
	tst.w	d2
	beq.s	++
+
	addi.b	#$10,d3
	move.b	d3,d0
	move.w	d0,(a2)
+
	addq.w	#2,a2
	dbf	d5,--

	rts
; End of function sub_86B0

; ===========================================================================
word_86F0:
	dc.w   100
	dc.w	10	; 1
	dc.w	 1	; 2

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_86F6:
	lea	(Chunk_Table).l,a2
	lea	(a2,d2.w),a2
	lea	(dword_8732).l,a3
	moveq	#0,d2

	moveq	#5,d5
-	moveq	#0,d3
	move.l	(a3)+,d4

-	sub.l	d4,d1
	bcs.s	+
	addq.w	#1,d3
	bra.s	-
; ===========================================================================
+
	add.l	d4,d1
	tst.w	d3
	beq.s	+
	moveq	#1,d2
+
	tst.w	d2
	beq.s	+
	addi.b	#$10,d3
	move.b	d3,d0
	move.w	d0,(a2)
+
	addq.w	#2,a2
	dbf	d5,--

	rts
; End of function sub_86F6

; ===========================================================================
dword_8732:
	dc.l 100000
	dc.l  10000
	dc.l   1000
	dc.l    100
	dc.l	10
	dc.l	 1

	; set the character set for menu text
	charset '@',"\27\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55"
	charset '0',"\16\17\18\19\20\21\22\23\24\25"
	charset '*',$1A
	charset ':',$1C
	charset '.',$1D
	charset ' ',0

	; Menu text
menutxt	macro	text
	dc.b	strlen(text)-1
	dc.b	text
	endm
Text2P_EmeraldHill:		menutxt		"EMERALD HILL"	; byte_874A:
	even
Text2P_MysticCave:		menutxt		" MYSTIC CAVE"	; byte_8757:
	even
Text2P_CasinoNight:		menutxt		"CASINO NIGHT"	; byte_8764:
	even
Text2P_SpecialStage:	menutxt		"SPECIAL STAGE"	; byte_8771:
	even
Text2P_Special:			menutxt		"   SPECIAL  "	; byte_877F:
	even
Text2P_Zone:			menutxt		"ZONE "		; byte_878C:
	even
Text2P_Stage:			menutxt		"STAGE"		; byte_8792:
	even
Text2P_GameOver:		menutxt		"GAME OVER"	; byte_8798:
	even
Text2P_TimeOver:		menutxt		"TIME OVER"
	even
Text2P_NoGame:			menutxt		"NO GAME"	; byte_87AC:
	even
Text2P_Tied:			menutxt		"TIED"		; byte_87B4:
	even
Text2P_1P:				menutxt		" 1P"		; byte_87B9:
	even
Text2P_2P:				menutxt		" 2P"		; byte_87BD:
	even
Text2P_Blank:			menutxt		"    "		; byte_87C1:
	even
	charset ; reset character set

; ------------------------------------------------------------------------
; MENU ANIMATION SCRIPT
; ------------------------------------------------------------------------
;word_87C6:
Anim_SonicMilesBG:	zoneanimstart
	; Sonic/Miles animated background
	zoneanimdecl  -1, ArtUnc_MenuBack,    1,  6, $A
	dc.b   0,$C7
	dc.b  $A,  5
	dc.b $14,  5
	dc.b $1E,$C7
	dc.b $14,  5
	dc.b  $A,  5
	even

	zoneanimend

; off_87DC:
TwoPlayerResultsPointers:
VsResultsScreen_Act:	dc.l Map_2PActResults, Setup2PResults_Act
VsResultsScreen_Zone:	dc.l Map_2PZoneResults, Setup2PResults_Zone
VsResultsScreen_Game:	dc.l Map_2PGameResults, Setup2PResults_Game
VsResultsScreen_SS:	dc.l Map_2PSpecialStageActResults, Setup2PResults_SpecialAct
VsResultsScreen_SSZone:	dc.l Map_2PSpecialStageZoneResults, Setup2PResults_SpecialZone


    if ~~removeJmpTos
JmpTo2_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l
JmpTo_Dynamic_Normal ; JmpTo
	jmp	(Dynamic_Normal).l

	align 4
    endif




; ===========================================================================
; loc_8BD4:
MenuScreen:
	bsr.w	Pal_FadeToBlack
	move	#$2700,sr
	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	ClearScreen
	lea	(VDP_control_port).l,a6
	move.w	#$8004,(a6)		; H-INT disabled
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
	move.w	#$8400|(VRAM_Menu_Plane_B_Name_Table/$2000),(a6)	; PNT B base: $E000
	move.w	#$8200|(VRAM_Menu_Plane_A_Name_Table/$400),(a6)		; PNT A base: $C000
	move.w	#$8700,(a6)		; Background palette/color: 0/0
	move.w	#$8C81,(a6)		; H res 40 cells, no interlace, S/H disabled
	move.w	#$9001,(a6)		; Scroll table size: 64x32
	   move.w	#$9200,(a6)		; Disable window
	clearRAM Sprite_Table_Input,Sprite_Table_Input_End
	clearRAM Menus_Object_RAM,Menus_Object_RAM_End

	; load background + graphics of font/LevSelPics
	clr.w	(VDP_Command_Buffer).w
	move.l	#VDP_Command_Buffer,(VDP_Command_Buffer_Slot).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_FontStuff),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_FontStuff).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_MenuBox),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_MenuBox).l,a0
	bsr.w	NemDec
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_LevelSelectPics),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_LevelSelectPics).l,a0
	bsr.w	NemDec
	lea	(Chunk_Table).l,a1
	lea	(MapEng_MenuBack).l,a0
	move.w	#make_art_tile(ArtTile_VRAM_Start,3,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_B_Name_Table,VRAM,WRITE),d0
	moveq	#$27,d1
	moveq	#$1B,d2
	jsrto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40	; fullscreen background

	cmpi.b	#GameModeID_OptionsMenu,(Game_Mode).w	; options menu?
	beq.w	MenuScreen_Options	; if yes, branch

	cmpi.b	#GameModeID_LevelSelect,(Game_Mode).w	; level select menu?
	beq.w	MenuScreen_LevelSelect	; if yes, branch

;MenuScreen_LevSel2P:
	lea	(Chunk_Table).l,a1
	lea	(MapEng_LevSel2P).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$198).l,a1
	lea	(MapEng_LevSel2P).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,1,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$330).l,a1
	lea	(MapEng_LevSelIcon).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_LevelSelectPics,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$498).l,a2

	moveq	#$F,d1
-	move.w	#$207B,(a2)+
	dbf	d1,-

	bsr.w	Update2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	bsr.w	ClearOld2PLevSelSelection
	addq.b	#1,(Current_Zone_2P).w
	andi.b	#3,(Current_Zone_2P).w
	clr.w	(Player_mode).w
	clr.b	(Current_Act_2P).w
	clr.w	(Results_Screen_2P).w	; VsRSID_Act
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	clr.b	(Game_Over_2P).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	lea	(Normal_palette_line3).w,a1
	lea	(Target_palette_line3).w,a2

	moveq	#bytesToLcnt($20),d1
-	move.l	(a1),(a2)+
	clr.l	(a1)+
	dbf	d1,-

	move.b	#MusID_Options,d0
	jsrto	(PlayMusic).l, JmpTo_PlayMusic
	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack

;loc_8DA8:
LevelSelect2P_Main:
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move	#$2700,sr
	bsr.w	ClearOld2PLevSelSelection
	bsr.w	LevelSelect2P_Controls
	bsr.w	Update2PLevSelSelection
	move	#$2300,sr
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	bne.s	LevelSelect2P_PressStart
	bra.w	LevelSelect2P_Main
; ===========================================================================
;loc_8DE2:
LevelSelect2P_PressStart:
	bsr.w	Chk2PZoneCompletion
	bmi.s	loc_8DF4
	move.w	#SndID_Error,d0
	jsrto	(PlaySound).l, JmpTo_PlaySound
	bra.w	LevelSelect2P_Main
; ===========================================================================

loc_8DF4:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	add.w	d0,d0
	move.w	LevelSelect2P_LevelOrder(pc,d0.w),d0
	bmi.s	loc_8E3A
	move.w	d0,(Current_ZoneAndAct).w
	move.w	#1,(Two_player_mode).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#0,(Last_star_pole_hit).w
	move.b	#0,(Last_star_pole_hit_2P).w
	moveq	#0,d0
	move.l	d0,(Score).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	rts
; ===========================================================================

loc_8E3A:
	move.b	#4,(Current_Special_Stage).w
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	moveq	#1,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	rts
; ===========================================================================
; word_8E52:
LevelSelect2P_LevelOrder:
	dc.w	emerald_hill_zone_act_1
	dc.w	mystic_cave_zone_act_1
	dc.w	casino_night_zone_act_1
	dc.w	$FFFF

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_8E5A:
LevelSelect2P_Controls:
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	move.b	d0,d1
	andi.b	#button_up_mask|button_down_mask,d0
	beq.s	+
	bchg	#1,(Current_Zone_2P).w

+
	andi.b	#button_left_mask|button_right_mask,d1
	beq.s	+	; rts
	bchg	#0,(Current_Zone_2P).w
+
	rts
; End of function LevelSelect2P_Controls

; ---------------------------------------------------------------------------
; Subroutine to update the 2P level select selection graphically
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8E7E:
Update2PLevSelSelection:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	lsl.w	#4,d0	; 16 bytes per entry
	lea	(LevSel2PIconData).l,a3
	lea	(a3,d0.w),a3
	move.w	#$6000,d0	; highlight text
	lea	(Chunk_Table+$48).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$94).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$D8).l,a2
	movea.l	4(a3),a1
	bsr.w	Chk2PZoneCompletion	; has the zone been completed?
	bmi.s	+	; if not, branch
	lea	(Chunk_Table+$468).l,a1	; display large X instead of icon
+
	moveq	#2,d1
-	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	lea	$1A(a2),a2
	dbf	d1,-

	lea	(Chunk_Table).l,a1
	move.l	(a3)+,d0
	moveq	#$10,d1
	moveq	#$B,d2
	jsrto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40
	lea	(Pal_LevelIcons).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a1
	lea	(Normal_palette_line3).w,a2

	moveq	#bytesToLcnt(palette_line_size),d1
-	move.l	(a1)+,(a2)+
	dbf	d1,-

	rts
; End of function Update2PLevSelSelection

; ---------------------------------------------------------------------------
; Subroutine to check if a 2P zone has been completed
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8EFE:
Chk2PZoneCompletion:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	; multiply d0 by 6
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	add.w	d0,d0
	lea	(Results_Data_2P).w,a5
	lea	(a5,d0.w),a5
	move.w	(a5),d0
	add.w	2(a5),d0
	rts
; End of function Chk2PZoneCompletion

; ---------------------------------------------------------------------------
; Subroutine to clear the old 2P level select selection
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8F1C:
ClearOld2PLevSelSelection:
	moveq	#0,d0
	move.b	(Current_Zone_2P).w,d0
	lsl.w	#4,d0
	lea	(LevSel2PIconData).l,a3
	lea	(a3,d0.w),a3
	moveq	#0,d0
	lea	(Chunk_Table+$1E0).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$22C).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$270).l,a2
	lea	(Chunk_Table+$498).l,a1
	bsr.w	Chk2PZoneCompletion
	bmi.s	+
	lea	(Chunk_Table+$468).l,a1
+
	moveq	#2,d1
-	move.l	(a1)+,(a2)+
	move.l	(a1)+,(a2)+
	lea	$1A(a2),a2
	dbf	d1,-

	lea	(Chunk_Table+$198).l,a1
	move.l	(a3)+,d0
	moveq	#$10,d1
	moveq	#$B,d2
	jmpto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40
; End of function ClearOld2PLevSelSelection

; ===========================================================================
; off_8F7E:
LevSel2PIconData:

; macro to declare icon data for a 2P level select icon
iconData macro txtlabel,txtlabel2,vramAddr,iconPal,iconAddr
	dc.l txtlabel, txtlabel2	; text locations
	dc.l vdpComm(vramAddr,VRAM,WRITE)	; VRAM location to place data
	dc.l iconPal<<24|iconAddr	; icon palette and plane data location
    endm

	iconData	Text2P_EmeraldHill,Text2P_Zone,VRAM_Plane_A_Name_Table+planeLocH40(2,2),0,$FF0330
	iconData	Text2P_MysticCave,Text2P_Zone,VRAM_Plane_A_Name_Table+planeLocH40(22,2),5,$FF03A8
	iconData	Text2P_CasinoNight,Text2P_Zone,VRAM_Plane_A_Name_Table+planeLocH40(2,15),6,$FF03C0
	iconData	Text2P_Special,Text2P_Stage,VRAM_Plane_A_Name_Table+planeLocH40(22,15),$C,$FF0450

; ---------------------------------------------------------------------------
; Common menu screen subroutine for transferring text to RAM

; ARGUMENTS:
; d0 = starting art tile
; a1 = data source
; a2 = destination
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_8FBE:
MenuScreenTextToRAM:
	moveq	#0,d1
	move.b	(a1)+,d1
-	move.b	(a1)+,d0
	move.w	d0,(a2)+
	dbf	d1,-
	rts
; End of function MenuScreenTextToRAM

; ===========================================================================
; loc_8FCC:
MenuScreen_Options:
	lea	(Chunk_Table).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,0,0),d0
	bsr.w	EniDec
	lea	(Chunk_Table+$160).l,a1
	lea	(MapEng_Options).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_MenuBox,1,0),d0
	bsr.w	EniDec
	clr.b	(Options_menu_box).w
	bsr.w	OptionScreen_DrawSelected
	addq.b	#1,(Options_menu_box).w
	bsr.w	OptionScreen_DrawUnselected
	clr.b	(Options_menu_box).w
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal
	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade
	move.b	#MusID_Options,d0
	jsrto	(PlayMusic).l, JmpTo_PlayMusic
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.w	(Correct_cheat_entries).w
	clr.w	(Correct_cheat_entries_2).w
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l
	bsr.w	Pal_FadeFromBlack
; loc_9060:
OptionScreen_Main:
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint
	move	#$2700,sr
	bsr.w	OptionScreen_DrawUnselected
	bsr.w	OptionScreen_Controls
	bsr.w	OptionScreen_DrawSelected
	move	#$2300,sr
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0
	bne.s	OptionScreen_Select
	bra.w	OptionScreen_Main
; ===========================================================================
; loc_909A:
OptionScreen_Select:
	move.b	(Options_menu_box).w,d0
	bne.s	OptionScreen_Select_Not1P
	; Start a single player game
	moveq	#0,d0
	move.w	d0,(Two_player_mode).w
	move.w	d0,(Two_player_mode_copy).w
	move.w	d0,(Current_ZoneAndAct).w	; emerald_hill_zone_act_1
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	rts
; ===========================================================================
; loc_90B6:
OptionScreen_Select_Not1P:
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================
; loc_90D8:
OptionScreen_Select_Other:
	; When pressing START on the sound test option, return to the SEGA screen
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_90E0:
OptionScreen_Controls:
	moveq	#0,d2
	move.b	(Options_menu_box).w,d2
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_up,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	#1,d2

+
	btst	#button_down,d0
	beq.s	+
	addq.b	#1,d2
	cmpi.b	#2,d2
	blo.s	+
	moveq	#0,d2

+
	move.b	d2,(Options_menu_box).w
	lsl.w	#2,d2
	move.b	OptionScreen_Choices(pc,d2.w),d3 ; number of choices for the option
	movea.l	OptionScreen_Choices(pc,d2.w),a1 ; location where the choice is stored (in RAM)
	move.w	(a1),d2
	btst	#button_left,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	d3,d2

+
	btst	#button_right,d0
	beq.s	+
	addq.b	#1,d2
	cmp.b	d3,d2
	bls.s	+
	moveq	#0,d2

+
    cmpi.b    #1,(Options_menu_box).w
    bne.s    ++
	btst    #button_A,d0
        beq.s   +
        addi.b  #$10,d2
        bcc.s   +
        moveq   #0,d2

+
    btst    #button_B,d0
    beq.s    +
    subi.b    #$10,d2
 ;   andi.b    #$7F,d2

+
	move.w	d2,(a1)
	cmpi.b	#1,(Options_menu_box).w
	bne.s	+	; rts
	andi.w	#button_C_mask,d0
	beq.s	+	; rts
	move.w	(Sound_test_sound).w,d0
	;addi.w	#$80,d0
	jsrto	(PlayMusic).l, JmpTo_PlayMusic
	lea	(level_select_cheat).l,a0
	lea	(continues_cheat).l,a2
	lea	(Level_select_flag).w,a1	; Also Slow_motion_flag
	moveq	#0,d2	; flag to tell the routine to enable the continues cheat
	bsr.w	CheckCheats

+
	rts
; End of function OptionScreen_Controls

; ===========================================================================
; word_917A:
OptionScreen_Choices:
	dc.l (3-1)<<24|(Player_option&$FFFFFF)
	dc.l $ff<<24|(Sound_test_sound&$FFFFFF)

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


;sub_9186
OptionScreen_DrawSelected:
	bsr.w	OptionScreen_SelectTextPtr
	moveq	#0,d1
	move.b	(Options_menu_box).w,d1
	lsl.w	#3,d1
	lea	(OptScrBoxData).l,a3
	lea	(a3,d1.w),a3
	move.w	#palette_line_3,d0
	lea	(Chunk_Table+$30).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$B6).l,a2
	moveq	#0,d1
	cmpi.b	#1,(Options_menu_box).w
	beq.s	+
	move.b	(Options_menu_box).w,d1
	lsl.w	#2,d1
	lea	OptionScreen_Choices(pc),a1
	movea.l	(a1,d1.w),a1
	move.w	(a1),d1
	lsl.w	#2,d1
+
	movea.l	(a4,d1.w),a1
	bsr.w	MenuScreenTextToRAM
	cmpi.b	#1,(Options_menu_box).w
	bne.s	+
	lea	(Chunk_Table+$C2).l,a2
	bsr.w	OptionScreen_HexDumpSoundTest
+
	lea	(Chunk_Table).l,a1
	move.l	(a3)+,d0
	moveq	#$15,d1
	moveq	#7,d2
	jmpto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40
; ===========================================================================

;loc_91F8
OptionScreen_DrawUnselected:
	bsr.w	OptionScreen_SelectTextPtr
	moveq	#0,d1
	move.b	(Options_menu_box).w,d1
	lsl.w	#3,d1
	lea	(OptScrBoxData).l,a3
	lea	(a3,d1.w),a3
	moveq	#palette_line_0,d0
	lea	(Chunk_Table+$190).l,a2
	movea.l	(a3)+,a1
	bsr.w	MenuScreenTextToRAM
	lea	(Chunk_Table+$216).l,a2
	moveq	#0,d1
	cmpi.b	#1,(Options_menu_box).w
	beq.s	+
	move.b	(Options_menu_box).w,d1
	lsl.w	#2,d1
	lea	OptionScreen_Choices(pc),a1
	movea.l	(a1,d1.w),a1
	move.w	(a1),d1
	lsl.w	#2,d1

+
	movea.l	(a4,d1.w),a1
	bsr.w	MenuScreenTextToRAM
	cmpi.b	#1,(Options_menu_box).w
	bne.s	+
	lea	(Chunk_Table+$222).l,a2
	bsr.w	OptionScreen_HexDumpSoundTest

+
	lea	(Chunk_Table+$160).l,a1
	move.l	(a3)+,d0
	moveq	#$15,d1
	moveq	#7,d2
	jmpto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40
; ===========================================================================

;loc_9268
OptionScreen_SelectTextPtr:
	lea	(off_92D2).l,a4
	tst.b	(Graphics_Flags).w
	bpl.s	+
	lea	(off_92DE).l,a4

+
	cmpi.b	#1,(Options_menu_box).w
	bne.s	+	; rts
	lea	(off_92F2).l,a4

+
	rts
; ===========================================================================

;loc_9296
OptionScreen_HexDumpSoundTest:
	move.w	(Sound_test_sound).w,d1
	move.b	d1,d2
	lsr.b	#4,d1
	bsr.s	+
	move.b	d2,d1

+
	andi.w	#$F,d1
	cmpi.b	#$A,d1
	blo.s	+
	addi.b	#4,d1

+
	addi.b	#$10,d1
	move.b	d1,d0
	move.w	d0,(a2)+
	rts
; ===========================================================================
; off_92BA:
OptScrBoxData:

; macro to declare the data for an options screen box
boxData macro txtlabel,vramAddr
	dc.l txtlabel, vdpComm(vramAddr,VRAM,WRITE)
    endm

	boxData	TextOptScr_PlayerSelect,VRAM_Plane_A_Name_Table+planeLocH40(9,4)
	boxData	TextOptScr_SoundTest,VRAM_Plane_A_Name_Table+planeLocH40(9,12)

off_92D2:
	dc.l TextOptScr_SonicAndMiles
	dc.l TextOptScr_SonicAlone
	dc.l TextOptScr_MilesAlone
off_92DE:
	dc.l TextOptScr_SonicAndTails
	dc.l TextOptScr_SonicAlone
	dc.l TextOptScr_TailsAlone
off_92EA:
	dc.l TextOptScr_AllKindsItems
	dc.l TextOptScr_TeleportOnly
off_92F2:
	dc.l TextOptScr_0
; ===========================================================================
; macro for generating level select strings
levselstr macro str
	save
	codepage	LEVELSELECT
	dc.b strlen(str)-1, str
	restore
    endm

; codepage for level select
	save
	codepage LEVELSELECT
	charset '0','9', 16
	charset 'A','Z', 30
	charset 'a','z', 30
	charset '*', 26
	charset $A9, 27	; '?'
	charset ':', 28
	charset '.', 29
	charset ' ',  0
	restore
planeLocH28 function col,line,(($50 * line) + (2 * col))

; loc_92F6:
MenuScreen_LevelSelect:
	; Load foreground (sans zone icon)
	lea	(Chunk_Table).l,a1
	lea	(MapEng_LevSel).l,a0	; 2 bytes per 8x8 tile, compressed
	move.w	#make_art_tile(ArtTile_VRAM_Start,0,0),d0
	bsr.w	EniDec
		save
		codepage	LEVELSELECT	; This is here so we can use '*' instead of '$1A'

		lea	(Chunk_Table).l,a3
		lea	(LevelSelectText).l,a1
		lea	(LevSel_MappingOffsets).l,a5
		moveq	#0,d0
		move.w	#$D-1,d1		; This is how many entries there are in LevelSelectText

	.writezone:
		move.w	(a5)+,d3	; Get relative address in plane map to write to
		lea	(a3,d3.w),a2	; Get absolute address
		moveq	#0,d2
		move.b	(a1)+,d2	; Get length of string
		move.w	d2,d3		; Store it

	.writeletter:
		move.b	(a1)+,d0	; Get character from string
		;ori.w	#make_art_tile($000,0,0),d0
		move.w	d0,(a2)+	; Send it to plane map
		dbf	d2,.writeletter	; Loop for entire string
		cmpi.W	#$5,d1
		ble.s	.righthandside
		move.w	#$D,d2		; Maximum length of string
		bra.S	.calculatespaces
	.righthandside:
		move.w	#$C,d2		; Maximum length of string
	.calculatespaces:
		sub.w	d3,d2		; Get remaining space in string
		bcs.s	.stringfull	; If there is none, skip ahead

	.blankloop:
		move.w	#make_art_tile(' ',0,0),(a2)+	; Full the remaining space with blank characters
		dbf	d2,.blankloop

	.stringfull:
		move.w	#make_art_tile('1',0,0),(a2)	; Write (act) '1'
		lea	$28*2(a2),a2	; Next line
		move.w	#make_art_tile('2',0,0),(a2)	; Write (act) '2'
		dbf	d1,.writezone

		; Assuming the last line was the sound test...
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act) '2'
		lea	-$28*2(a2),a2	; Go back to (act) '1'
		move.w	#make_art_tile('*',0,0),(a2)	; Replace that with '*'

		lea	-$28*4(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
		lea	-$28*2(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
		lea	-$28*4(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
		lea	-$28*2(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
		lea	-$28*4(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
		lea	-$28*2(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
		lea	-$28*4(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
		lea	-$28*2(a2),a2	; Go back to (act)
		move.w	#make_art_tile(' ',0,0),(a2)	; Get rid of (act)
	
		; Overwrite duplicate LAVA REEF 1/2 with 3/4 (obviously, S3 didn't do this)
		move.w	#make_art_tile('3',0,0),(RAM_start+planeLocH28($24,5)).l

		restore


	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE),d0
	moveq	#$27,d1
	moveq	#$1B,d2	; 40x28 = whole screen
	jsrto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40	; display patterns

	; Draw sound test number
	moveq	#palette_line_0,d3
	bsr.w	LevelSelect_DrawSoundNumber
	bsr.w	LevelSelect_DrawPlayerOption

	; Load zone icon
	lea	(Chunk_Table+$8C0).l,a1
	lea	(MapEng_LevSelIcon).l,a0
	move.w	#make_art_tile(ArtTile_ArtNem_LevelSelectPics,0,0),d0
	bsr.w	EniDec

	bsr.w	LevelSelect_DrawIcon

	clr.w	(Player_mode).w
	clr.w	(Results_Screen_2P).w	; VsRSID_Act
	clr.b	(Level_started_flag).w
	clr.w	(Anim_Counters).w

	; Animate background (loaded back in MenuScreen)
	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal	; background

	moveq	#PalID_Menu,d0
	bsr.w	PalLoad_ForFade

	lea	(Normal_palette_line3).w,a1
	lea	(Target_palette_line3).w,a2

	moveq	#bytesToLcnt(palette_line_size),d1
-	move.l	(a1),(a2)+
	clr.l	(a1)+
	dbf	d1,-

	move.b	#MusID_Options,d0
	jsrto	(PlayMusic).l, JmpTo_PlayMusic

	move.w	#(30*60)-1,(Demo_Time_left).w	; 30 seconds
	clr.w	(Two_player_mode).w
	clr.l	(Camera_X_pos).w
	clr.l	(Camera_Y_pos).w
	clr.w	(Correct_cheat_entries).w
	clr.w	(Correct_cheat_entries_2).w

	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint

	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l

	bsr.w	Pal_FadeFromBlack

;loc_93AC:
LevelSelect_Main:	; routine running during level select
	move.b	#VintID_Menu,(Vint_routine).w
	bsr.w	WaitForVint

	move	#$2700,sr

	moveq	#palette_line_0-palette_line_0,d3	; palette line << 13
	bsr.w	LevelSelect_MarkFields	; unmark fields
	bsr.w	LevSelControls	; possible change selected fields
	move.w	#palette_line_3-palette_line_0,d3	; palette line << 13
	bsr.w	LevelSelect_MarkFields	; mark fields

	bsr.w	LevelSelect_DrawIcon

	move	#$2300,sr

	lea	(Anim_SonicMilesBG).l,a2
	jsrto	(Dynamic_Normal).l, JmpTo2_Dynamic_Normal

	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	andi.b	#button_start_mask,d0	; start pressed?
	bne.s	LevelSelect_PressStart	; yes
	bra.w	LevelSelect_Main	; no
; ===========================================================================

;loc_93F0:
LevelSelect_PressStart:
	move.w	(Level_select_zone).w,d0
	add.w	d0,d0
	move.w	LevelSelect_Order(pc,d0.w),d0
	bmi.w	LevelSelect_Return	; sound test
	cmpi.w	#$4000,d0
	bne.s	LevelSelect_StartZone

;LevelSelect_SpecialStage:
	move.b	#GameModeID_SpecialStage,(Game_Mode).w ; => SpecialStage
	clr.w	(Current_ZoneAndAct).w
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	move.w	(Player_option).w,(Player_mode).w
	rts
; ===========================================================================

;loc_944C:
LevelSelect_Return:
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================
; -----------------------------------------------------------------------------
; Level Select Level Order

; One entry per item in the level select menu. Just set the value for the item
; you want to link to the level/act number of the level you want to load when
; the player selects that item.
; -----------------------------------------------------------------------------
;Misc_9454:
LevelSelect_Order:
	dc.w	emerald_hill_zone_act_1		;  0
	dc.w	emerald_hill_zone_act_2		;  1
	dc.w	chemical_plant_zone_act_1	;  2
	dc.w	chemical_plant_zone_act_2	;  3
	dc.w	aquatic_ruin_zone_act_1		;  4
	dc.w	aquatic_ruin_zone_act_2		;  5
	dc.w	casino_night_zone_act_1		;  6
	dc.w	casino_night_zone_act_2		;  7
	dc.w	hill_top_zone_act_1			;  8
	dc.w	hill_top_zone_act_2			;  9
	dc.w	mystic_cave_zone_act_1		; 10
	dc.w	mystic_cave_zone_act_2		; 11
	dc.w	oil_ocean_zone_act_1		; 12
	dc.w	oil_ocean_zone_act_2		; 13
	dc.w	metropolis_zone_act_1		; 14
	dc.w	metropolis_zone_act_2		; 15
	dc.w	metropolis_zone_act_3		; 16
	dc.w	sky_chase_zone_act_1		; 17
	dc.w	wing_fortress_zone_act_1	; 18
	dc.w	death_egg_zone_act_1		; 19
	dc.w	level_select_special_stage	; 20
	dc.w	level_select_exit			; 21
; ===========================================================================

;loc_9480:
LevelSelect_StartZone:
	andi.w	#$3FFF,d0
	move.w	d0,(Current_ZoneAndAct).w
	move.b	#GameModeID_Level,(Game_Mode).w ; => Level (Zone play mode)
	move.b	#3,(Life_count).w
	move.b	#3,(Life_count_2P).w
	moveq	#0,d0
	move.w	d0,(Ring_count).w
	move.l	d0,(Timer).w
	move.l	d0,(Score).w
	move.w	d0,(Ring_count_2P).w
	move.l	d0,(Timer_2P).w
	move.l	d0,(Score_2P).w
	move.b	d0,(Continue_count).w
	move.l	#5000,(Next_Extra_life_score).w
	move.l	#5000,(Next_Extra_life_score_2P).w
	move.b	#MusID_FadeOut,d0
	jsrto	(PlaySound).l, JmpTo_PlaySound
	moveq	#0,d0
	move.w	d0,(Two_player_mode_copy).w
	move.w	d0,(Two_player_mode).w
	rts

; ===========================================================================
; ---------------------------------------------------------------------------
; Change what you're selecting in the level select
; ---------------------------------------------------------------------------
; loc_94DC:
LevSelControls:
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_up_mask|button_down_mask,d1
	bne.s	+	; up/down pressed
	subq.w	#1,(LevSel_HoldTimer).w
	bpl.s	LevSelControls_CheckLR

+
	move.w	#$B,(LevSel_HoldTimer).w
	move.b	(Ctrl_1_Held).w,d1
	andi.b	#button_up_mask|button_down_mask,d1
	beq.s	LevSelControls_CheckLR	; up/down not pressed, check for left & right
	move.w	(Level_select_zone).w,d0
	btst	#button_up,d1
	beq.s	+
	subq.w	#1,d0	; decrease by 1
	bcc.s	+	; >= 0?
	moveq	#$15,d0	; set to $15

+
	btst	#button_down,d1
	beq.s	+
	addq.w	#1,d0	; yes, add 1
	cmpi.w	#$16,d0
	blo.s	+	; smaller than $16?
	moveq	#0,d0	; if not, set to 0

+
	move.w	d0,(Level_select_zone).w
	rts
; ===========================================================================
; loc_9522:
LevSelControls_CheckLR:
	cmpi.w	#$15,(Level_select_zone).w	; are we in the sound test?
	bne.s	LevSelControls_SwitchSide	; no
	move.w	(Sound_test_sound).w,d0
	move.b	(Ctrl_1_Press).w,d1
	btst	#button_left,d1
	beq.s	+
	subq.b	#1,d0
;	bcc.s	+
;	moveq	#$7F,d0

+
	btst	#button_right,d1
	beq.s	+
	addq.b	#1,d0
;	cmpi.w	#$80,d0
;	blo.s	+
;	moveq	#0,d0

+
	btst    #button_A,d1
        beq.s   +
        addi.b  #$10,d0
        bcc.s   +
        moveq   #0,d0


+
    btst    #button_B,d1
    beq.s    +
    subi.b    #$10,d0
;    andi.b    #$7F,d0

+
	move.w	d0,(Sound_test_sound).w
	andi.w	#button_C_mask,d1
	beq.s	+	; rts
	move.w	(Sound_test_sound).w,d0
	;addi.w	#$80,d0
	jsrto	(PlayMusic).l, JmpTo_PlayMusic
	lea	(debug_cheat).l,a0
	lea	(super_sonic_cheat).l,a2
	lea	(Debug_options_flag).w,a1	; Also S1_hidden_credits_flag
	moveq	#1,d2	; flag to tell the routine to enable the Super Sonic cheat
	bsr.w	CheckCheats

+
	rts
; ===========================================================================
; loc_958A:
LevSelControls_SwitchSide:	; not in soundtest, not up/down pressed
	move.b	(Ctrl_1_Press).w,d1
	andi.b	#button_left_mask|button_right_mask,d1
	beq.s	LevSelControls_SwitchPlayerOption				; no direction key pressed
	move.w	(Level_select_zone).w,d0	; left or right pressed
	move.b	LevelSelect_SwitchTable(pc,d0.w),d0 ; set selected zone according to table
	move.w	d0,(Level_select_zone).w
LevSelControls_SwitchPlayerOption:
	btst	#button_C,(Ctrl_1_Press).w	; is C pressed?
	beq.s	+							; if not, branch
	addq.w	#1,(Player_option).w		; select next character
	cmpi.w	#2,(Player_option).w		; did we go over the limit?
	bls.s	+							; if not, branch
	clr.w	(Player_option).w			; reset to 0
+
	rts
; ===========================================================================
;byte_95A2:
LevelSelect_SwitchTable:
	dc.b $E
	dc.b $F		; 1
	dc.b $11	; 2
	dc.b $11	; 3
	dc.b $12	; 4
	dc.b $12	; 5
	dc.b $13	; 6
	dc.b $13	; 7
	dc.b $14	; 8
	dc.b $14	; 9
	dc.b $15	; 10
	dc.b $15	; 11
	dc.b $C		; 12
	dc.b $D		; 13
	dc.b 0		; 14
	dc.b 1		; 15
	dc.b 1		; 16
	dc.b 2		; 17
	dc.b 4		; 18
	dc.b 6		; 19
	dc.b 8		; 20
	dc.b $A		; 21
	even
; ===========================================================================

;loc_95B8:
LevelSelect_MarkFields:
	lea	(Chunk_Table).l,a4
	lea	(LevSel_MarkTable).l,a5
	lea	(VDP_data_port).l,a6
	moveq	#0,d0
	move.w	(Level_select_zone).w,d0
	lsl.w	#2,d0
	lea	(a5,d0.w),a3
	moveq	#0,d0
	move.b	(a3),d0
	mulu.w	#$50,d0
	moveq	#0,d1
	move.b	1(a3),d1
	add.w	d1,d0
	lea	(a4,d0.w),a1
	moveq	#0,d1
	move.b	(a3),d1
	lsl.w	#7,d1
	add.b	1(a3),d1
	addi.w	#VRAM_Plane_A_Name_Table,d1
	lsl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
	swap	d1
	move.l	d1,4(a6)

	moveq	#$D,d2
-	move.w	(a1)+,d0
	add.w	d3,d0
	move.w	d0,(a6)
	dbf	d2,-

	addq.w	#2,a3
	moveq	#0,d0
	move.b	(a3),d0
	beq.s	+
	mulu.w	#$50,d0
	moveq	#0,d1
	move.b	1(a3),d1
	add.w	d1,d0
	lea	(a4,d0.w),a1
	moveq	#0,d1
	move.b	(a3),d1
	lsl.w	#7,d1
	add.b	1(a3),d1
	addi.w	#VRAM_Plane_A_Name_Table,d1
	lsl.l	#2,d1
	lsr.w	#2,d1
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d1
	swap	d1
	move.l	d1,4(a6)
	move.w	(a1)+,d0
	add.w	d3,d0
	move.w	d0,(a6)

+
	cmpi.w	#$15,(Level_select_zone).w
	beq.w	LevelSelect_DrawSoundNumber
	bra.w	LevelSelect_DrawPlayerOption
	rts
; ===========================================================================
;loc_965A:
LevelSelect_DrawSoundNumber:
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(34,18),VRAM,WRITE),(VDP_control_port).l
	move.w	(Sound_test_sound).w,d0
	move.b	d0,d2
	lsr.b	#4,d0
	bsr.s	+
	move.b	d2,d0

+
	andi.w	#$F,d0
	cmpi.b	#$A,d0
	blo.s	+
	addi.b	#4,d0

+
	addi.b	#$10,d0
	add.w	d3,d0
	move.w	d0,(a6)
	rts
LevelSelect_DrawPlayerOption:
    move.l    #vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(4,24),VRAM,WRITE),(VDP_control_port).l
    move.w   (Player_option).w,d0
	move.b	d0,d2
	lsr.b	#4,d0
	bsr.s	+
	move.b	d2,d0

+
	andi.w	#$F,d0
	cmpi.b	#$A,d0
	blo.s	+
	addi.b	#4,d0

+
	addi.b	#$10,d0
	add.w	d3,d0
	move.w	d0,(a6)
	rts

; ===========================================================================

;loc_9688:
LevelSelect_DrawIcon:
	move.w	(Level_select_zone).w,d0
	lea	(LevSel_IconTable).l,a3
	lea	(a3,d0.w),a3
	lea	(Chunk_Table+$8C0).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#3,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	lea	(a1,d0.w),a1
	move.l	#vdpComm(VRAM_Plane_A_Name_Table+planeLocH40(27,22),VRAM,WRITE),d0
	moveq	#3,d1
	moveq	#2,d2
	jsrto	(PlaneMapToVRAM_H40).l, JmpTo_PlaneMapToVRAM_H40
	lea	(Pal_LevelIcons).l,a1
	moveq	#0,d0
	move.b	(a3),d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a1
	lea	(Normal_palette_line3).w,a2

	moveq	#bytesToLcnt(palette_line_size),d1
-	move.l	(a1)+,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
;byte_96D8
Icon_EHZ = 0
Icon_CPZ = 7
Icon_ARZ = 8
Icon_CNZ = 6
Icon_HTZ = 2
Icon_MCZ = 5
Icon_OOZ = 4
Icon_MTZ = 1
Icon_SCZ = 9
Icon_WFZ = $A
Icon_DEZ = $B
Icon_SpecStag  = $C
Icon_SoundTest = $E
Icon_HPZ = 3
Icon_X = $D
LevSel_IconTable:
	dc.b   Icon_EHZ,Icon_EHZ		;0	EHZ
	dc.b   Icon_CPZ,Icon_CPZ		;2	CPZ
	dc.b   Icon_ARZ,Icon_ARZ		;4	ARZ
	dc.b   Icon_CNZ,Icon_CNZ		;6	CNZ
	dc.b   Icon_HTZ,Icon_HTZ		;8	HTZ
	dc.b   Icon_MCZ,Icon_MCZ		;$A	MCZ
	dc.b   Icon_OOZ,Icon_OOZ		;$C	OOZ
	dc.b   Icon_MTZ,Icon_MTZ,Icon_MTZ	;$E	MTZ
	dc.b   Icon_SCZ				;$11	SCZ
	dc.b   Icon_WFZ				;$12	WFZ
	dc.b   Icon_DEZ				;$13	DEZ
	dc.b   Icon_SpecStag			;$14	Special Stage
	dc.b   Icon_SoundTest			;$15	Sound Test
	even
;byte_96EE:
LevSel_MarkTable:	; 4 bytes per level select entry
; line primary, 2*column ($E fields), line secondary, 2*column secondary (1 field)
	dc.b   3,  6,  3,$24	;0
	dc.b   3,  6,  4,$24
	dc.b   6,  6,  6,$24
	dc.b   6,  6,  7,$24
	dc.b   9,  6,  9,$24	;4
	dc.b   9,  6, $A,$24
	dc.b  $C,  6, $C,$24
	dc.b  $C,  6, $D,$24
	dc.b  $F,  6, $F,$24	;8
	dc.b  $F,  6,$10,$24
	dc.b $12,  6,$12,$24
	dc.b $12,  6,$13,$24
	dc.b $15,  6,$15,$24	;$C
	dc.b $15,  6,$16,$24
; --- second column ---
	dc.b   3,$2C,  3,$48
	dc.b   3,$2C,  4,$48
	dc.b   3,$2C,  5,$48	;$10
	dc.b   6,$2C,  0,  0
	dc.b   9,$2C,  0,  0
	dc.b  $C,$2C,  0,  0
	dc.b  $F,$2C,  0,  0	;$14
	dc.b $12,$2C,$12,$48
	


LevSel_MappingOffsets:
		dc.w planeLocH28(3,3)
		dc.w planeLocH28(3,6)
		dc.w planeLocH28(3,9)
		dc.w planeLocH28(3,$C)
		dc.w planeLocH28(3,$F)
		dc.w planeLocH28(3,$12)
		dc.w planeLocH28(3,$15)

		dc.w planeLocH28($16,3)
		dc.w planeLocH28($16,6)
		dc.w planeLocH28($16,9)
		dc.w planeLocH28($16,$C)
		dc.w planeLocH28($16,$F)
		dc.w planeLocH28($16,$12)

LevelSelectText:
		levselstr "EMERALD HILL"
		levselstr "CHEMICAL PLANT"
		levselstr "AQUATIC RUIN"
		levselstr "CASINO NIGHT"
		levselstr "HILL TOP"
		levselstr "MYSTIC CAVE"
		levselstr "OIL OCEAN"
		levselstr "METROPOLIS"
		levselstr "SKY CHASE"
		levselstr "WING FORTRESS"
		levselstr "DEATH EGG"
		levselstr "SPECIAL STAGE"
		levselstr "SOUND TEST  *"
		even
; ===========================================================================
; loc_9746:
CheckCheats:	; This is called from 2 places: the options screen and the level select screen
	move.w	(Correct_cheat_entries).w,d0	; Get the number of correct sound IDs entered so far
	adda.w	d0,a0				; Skip to the next entry
	move.w	(Sound_test_sound).w,d0		; Get the current sound test sound
	cmp.b	(a0),d0				; Compare it to the cheat
	bne.s	+				; If they're different, branch
	addq.w	#1,(Correct_cheat_entries).w	; Add 1 to the number of correct entries
	tst.b	1(a0)				; Is the next entry 0?
	bne.s	++				; If not, branch
	move.w	#$101,(a1)			; Enable the cheat
	move.b	#SndID_Ring,d0			; Play the ring sound
	jsrto	(PlaySound).l, JmpTo_PlaySound
+
	move.w	#0,(Correct_cheat_entries).w	; Clear the number of correct entries
+
	move.w	(Correct_cheat_entries_2).w,d0	; Do the same procedure with the other cheat
	adda.w	d0,a2
	move.w	(Sound_test_sound).w,d0
	cmp.b	(a2),d0
	bne.s	++
	addq.w	#1,(Correct_cheat_entries_2).w
	tst.b	1(a2)
	bne.s	+++	; rts
	tst.w	d2				; Test this to determine which cheat to enable
	bne.s	+				; If not 0, branch
	move.b	#$F,(Continue_count).w		; Give 15 continues
	move.b	#SndID_ContinueJingle,d0	; Play the continue jingle
	jsrto	(PlayMusic).l, JmpTo_PlayMusic
	bra.s	++
; ===========================================================================
+
	move.w	#7,(Got_Emerald).w		; Give 7 emeralds to the player
	move.b	#MusID_Emerald,d0		; Play the emerald jingle
	jsrto	(PlayMusic).l, JmpTo_PlayMusic
+
	move.w	#0,(Correct_cheat_entries_2).w	; Clear the number of correct entries
+
	rts
; ===========================================================================

level_select_cheat:	dc.b $19, $65,   9, $17,   0	; 17th September 1965, Yuji Naka's birthdate
	even
; byte_97B7
continues_cheat:	dc.b   1,   1,   2,   4,   0	; 24th November, Sonic 2's release date in the EU and US: "Sonic 2sday"
	even
debug_cheat:		dc.b   1,   9,   9,   2,   1,   1,   2,   4,   0	; 24th November 1992, Sonic 2's release date in the EU and US: "Sonic 2sday"
	even
; byte_97C5
super_sonic_cheat:	dc.b   4,   1,   2,   6,   0	; Book of Genesis, 41:26
	even

	; set the character set for menu text
	charset '@',"\27\30\31\32\33\34\35\36\37\38\39\40\41\42\43\44\45\46\47\48\49\50\51\52\53\54\55"
	charset '0',"\16\17\18\19\20\21\22\23\24\25"
	charset '*',$1A
	charset ':',$1C
	charset '.',$1D
	charset ' ',0
	; options screen menu text

TextOptScr_PlayerSelect:	menutxt	"* PLAYER SELECT *"	; byte_97CA:
TextOptScr_SonicAndMiles:	menutxt	"SONIC AND MILES"	; byte_97DC:
TextOptScr_SonicAndTails:	menutxt	"SONIC AND TAILS"	; byte_97EC:
TextOptScr_SonicAlone:		menutxt	"SONIC ALONE    "	; byte_97FC:
TextOptScr_MilesAlone:		menutxt	"MILES ALONE    "	; byte_980C:
TextOptScr_TailsAlone:		menutxt	"TAILS ALONE    "	; byte_981C:

TextOptScr_VsModeItems:		menutxt	"WHY YOU POKING   "	; byte_982C:
TextOptScr_AllKindsItems:	menutxt	"AROUND HERE YOU"	; byte_983E:
TextOptScr_TeleportOnly:	menutxt	"CANT BE HERE   "	; byte_984E:

TextOptScr_SoundTest:		menutxt	"*  SOUND TEST   *"	; byte_985E:
TextOptScr_0:				menutxt	"      00       "	; byte_9870:

	charset ; reset character set



    if ~~removeJmpTos
JmpTo_PlaySound ; JmpTo
	jmp	(PlaySound).l
JmpTo_PlayMusic ; JmpTo
	jmp	(PlayMusic).l
; loc_9C70: JmpTo_PlaneMapToVRAM
JmpTo_PlaneMapToVRAM_H40 ; JmpTo
	jmp	(PlaneMapToVRAM_H40).l
JmpTo2_Dynamic_Normal ; JmpTo
	jmp	(Dynamic_Normal).l

	align 4
    endif
