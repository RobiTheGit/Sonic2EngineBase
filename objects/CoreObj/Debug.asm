; ===========================================================================
; ---------------------------------------------------------------------------
; When debug mode is currently in use
; ---------------------------------------------------------------------------
; loc_41A78:
DebugMode:
	moveq	#0,d0
	move.b	(Debug_placement_mode).w,d0
	move.w	Debug_Index(pc,d0.w),d1
	jmp	Debug_Index(pc,d1.w)
; ===========================================================================
; off_41A86:
Debug_Index:	offsetTable
		offsetTableEntry.w Debug_Init	; 0
		offsetTableEntry.w Debug_Main	; 2
; ===========================================================================
; loc_41A8A: Debug_Main:
Debug_Init:
	addq.b	#2,(Debug_placement_mode).w
	move.w	(Camera_Min_Y_pos).w,(Camera_Min_Y_pos_Debug_Copy).w
	move.w	(Camera_Max_Y_pos).w,(Camera_Max_Y_pos_Debug_Copy).w
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	bne.s	+
	move.w	#0,(Camera_Min_X_pos).w
	move.w	#$3FFF,(Camera_Max_X_pos).w
+
	andi.w	#$7FF,(MainCharacter+y_pos).w
	andi.w	#$7FF,(Camera_Y_pos).w
	andi.w	#$7FF,(Camera_BG_Y_pos).w
	clr.b	(Scroll_lock).w
	move.b	#0,mapping_frame(a0)
	move.b	#AniIDSonAni_Walk,anim(a0)
	; S1 leftover
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode? (you can't enter debug mode in S2's special stage)
	bne.s	.islevel	; if not, branch
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	bra.s	.selectlist
; ===========================================================================
.islevel:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.selectlist:
	lea	(JmpTbl_DbgObjLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	cmp.b	(Debug_object).w,d6
	bhi.s	+
	move.b	#0,(Debug_object).w
+
	bsr.w	LoadDebugObjectSprite
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#1,(Debug_Speed).w
; loc_41B0C:
Debug_Main:
	; S1 leftover
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; special stage mode? (you can't enter debug mode in S2's special stage)
	beq.s	.isntlevel	; if yes, branch

	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.isntlevel:
	lea	(JmpTbl_DbgObjLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	bsr.w	Debug_Control
	jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41B34:
Debug_Control:
;Debug_ControlMovement:
	moveq	#0,d4
	move.w	#1,d1
	move.b	(Ctrl_1_Press).w,d4
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
	bne.s	Debug_Move
	move.b	(Ctrl_1_Held).w,d0
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
	bne.s	Debug_ContinueMoving
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#$F,(Debug_Speed).w
	bra.w	Debug_ControlObjects
; ===========================================================================
; loc_41B5E:
Debug_ContinueMoving:
	subq.b	#1,(Debug_Accel_Timer).w
	bne.s	Debug_TimerNotOver
	move.b	#1,(Debug_Accel_Timer).w
	addq.b	#1,(Debug_Speed).w
	bne.s	Debug_Move
	move.b	#-1,(Debug_Speed).w
; loc_41B76:
Debug_Move:
	move.b	(Ctrl_1_Held).w,d4
; loc_41B7A:
Debug_TimerNotOver:
	moveq	#0,d1
	move.b	(Debug_Speed).w,d1
	addq.w	#1,d1
	swap	d1
	asr.l	#4,d1
	move.l	y_pos(a0),d2
	move.l	x_pos(a0),d3

	; Move up
	btst	#button_up,d4
	beq.s	.upNotHeld
	sub.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Min_Y_pos).w,d0
	swap	d0
	cmp.l	d0,d2
	bge.s	.minYPosNotReached
	move.l	d0,d2
.minYPosNotReached:
; loc_41BA4:
.upNotHeld:
	; Move down
	btst	#button_down,d4
	beq.s	.downNotHeld
	add.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#224-1,d0
	swap	d0
	cmp.l	d0,d2
	blt.s	.maxYPosNotReached
	move.l	d0,d2
.maxYPosNotReached:
; loc_41BBE:
.downNotHeld:
	; Move left
	btst	#button_left,d4
	beq.s	.leftNotHeld
	sub.l	d1,d3
	bcc.s	.minXPosNotReached
	moveq	#0,d3
.minXPosNotReached:
; loc_41BCA:
.leftNotHeld:
	; Move right
	btst	#button_right,d4
	beq.s	.rightNotHeld
	add.l	d1,d3
; loc_41BD2:
.rightNotHeld:
	move.l	d2,y_pos(a0)
	move.l	d3,x_pos(a0)
; loc_41BDA:
Debug_ControlObjects:
;Debug_CycleObjectsBackwards:
	btst	#button_A,(Ctrl_1_Held).w
	beq.s	Debug_SpawnObject
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_CycleObjects
	; Cycle backwards though object list
	subq.b	#1,(Debug_object).w
	bcc.s	BranchTo_LoadDebugObjectSprite
	add.b	d6,(Debug_object).w
	bra.s	BranchTo_LoadDebugObjectSprite
; ===========================================================================
; loc_41BF6:
Debug_CycleObjects:
	btst	#button_A,(Ctrl_1_Press).w
	beq.s	Debug_SpawnObject
	; Cycle forwards though object list
	addq.b	#1,(Debug_object).w
	cmp.b	(Debug_object).w,d6
	bhi.s	BranchTo_LoadDebugObjectSprite
	move.b	#0,(Debug_object).w

BranchTo_LoadDebugObjectSprite ; BranchTo
	bra.w	LoadDebugObjectSprite
; ===========================================================================
; loc_41C12:
Debug_SpawnObject:
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_ExitDebugMode
	; Spawn object
	jsr	(SingleObjLoad).l
	bne.s	Debug_ExitDebugMode
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	render_flags(a0),status(a1)
	andi.b	#$7F,status(a1)
;	move.b	mappings(a0),d0
 ;       move.l  d0,(a1) ; load obj
	;moveq	#0,d0
	;move.b	(Debug_object).w,d0
	;lsl.w	#3,d0
	;move.b	4(a2,d0.w),subtype(a1)
         moveq	#0,d0
	move.b	(Debug_object).w,d0
	add.w	d0,d0
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	move.b	4(a2,d0.w),subtype(a1)
	move.l	(a2,d0.w),(a1)
	rts
; ===========================================================================
; loc_41C56:
Debug_ExitDebugMode:

	btst	#button_B,(Ctrl_1_Press).w
	beq.w	return_41CB6
	; Exit debug mode
	moveq	#0,d0
	move.w	d0,(Debug_placement_mode).w
	    bsr.w    Hud_Base
    move.b    #1,(Update_HUD_rings).w
    move.b    #1,(Update_HUD_score).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#Mapunc_Sonic,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtUnc_Sonic,0,0),art_tile(a1)

; loc_41C82:
.notTwoPlayerMode:
	bsr.s	Debug_ResetPlayerStats
	move.b	#$13,y_radius(a1)
    cmpi.w    #2,(Player_mode).w
    bne.s    .notTails
    move.b    #$F,y_radius(a1)
    move.l    #MapUnc_Tails,mappings(a1)
    move.w    #make_art_tile(ArtTile_ArtUnc_Tails,0,0),art_tile(a1)

.notTails:
	move.b	#9,x_radius(a1)
	move.w	(Camera_Min_Y_pos_Debug_Copy).w,(Camera_Min_Y_pos).w
	move.w	(Camera_Max_Y_pos_Debug_Copy).w,(Camera_Max_Y_pos).w

return_41CB6:
	rts
; End of function Debug_Control


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CB8:
Debug_ResetPlayerStats:
	move.b	d0,anim(a1)
	move.w	d0,x_sub(a1) ; subpixel x
	move.w	d0,y_sub(a1) ; subpixel y
	move.b	d0,obj_control(a1)
	move.b	d0,spindash_flag(a1)
	move.w	d0,x_vel(a1)
	move.w	d0,y_vel(a1)
	move.w	d0,inertia(a1)
	; note: this resets the 'is underwater' flag, causing the bug where
	; if you enter Debug Mode underwater, and exit it above-water, Sonic
	; will still move as if he's underwater
	;move.b	#2,status(a1)
	;move.b	#2,routine(a1)
	;move.b	#0,routine_secondary(a1)
	rts
; End of function Debug_ResetPlayerStats


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CEC:
LoadDebugObjectSprite:
         moveq	#0,d0
	move.b	(Debug_object).w,d0
	add.w	d0,d0
	move.w	d0,d1
	lsl.w	#2,d0
	add.w	d1,d0
	move.l	4(a2,d0.w),mappings(a0)
	move.w	8(a2,d0.w),art_tile(a0)
	move.b	(a2,d0.w),mapping_frame(a0)
	rts
; End of function LoadDebugObjectSprite

; ===========================================================================
; ---------------------------------------------------------------------------
; OBJECT DEBUG LISTS

; The jump table goes by level ID, so Metropolis Zone's list is repeated to
; account for its third act. Hidden Palace Zone uses Oil Ocean Zone's list.
; ---------------------------------------------------------------------------
JmpTbl_DbgObjLists: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w DbgObjList_Test	; 0
	zoneOffsetTableEntry.w DbgObjList_Test	; 1
	zoneOffsetTableEntry.w DbgObjList_Test	; 2
	zoneOffsetTableEntry.w DbgObjList_Test	; 3
	zoneOffsetTableEntry.w DbgObjList_Test	; 4
	zoneOffsetTableEntry.w DbgObjList_Test	; 5
	zoneOffsetTableEntry.w DbgObjList_Test	; 6
	zoneOffsetTableEntry.w DbgObjList_Test	; 7
	zoneOffsetTableEntry.w DbgObjList_Test	; 8
	zoneOffsetTableEntry.w DbgObjList_Test	; 9
	zoneOffsetTableEntry.w DbgObjList_Test	; $A
	zoneOffsetTableEntry.w DbgObjList_Test	; $B
	zoneOffsetTableEntry.w DbgObjList_Test	; $C
	zoneOffsetTableEntry.w DbgObjList_Test	; $D
	zoneOffsetTableEntry.w DbgObjList_Test	; $E
	zoneOffsetTableEntry.w DbgObjList_Test	; $F
	zoneOffsetTableEntry.w DbgObjList_Test	; $10
    zoneTableEnd

; macro for a debug object list header
; must be on the same line as a label that has a corresponding _End label later
dbglistheader macro {INTLABEL}
__LABEL__ label *
	dc.w ((__LABEL___End - __LABEL__ - 2) >> 3)
    endm

; macro to define debug list object data
dbglistobj macro   obj, mapaddr, subtype, frame, vram
	dc.l frame<<24|obj
	dc.l subtype<<24|mapaddr
	dc.w vram
    endm


DbgObjList_Test: dbglistheader

	dbglistobj Obj26,	Obj26_MapUnc_12D36,   4,   5, make_art_tile(ArtTile_ArtNem_Powerups,0,0) ; obj26 = monitor
	dbglistobj Obj3E,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_Test_End
    if ~~removeJmpTos
JmpTo66_Adjust2PArtPointer ; JmpTo
	jmp	(Adjust2PArtPointer).l

	align 4
    endif
