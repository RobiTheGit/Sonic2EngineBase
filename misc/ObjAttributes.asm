SetUp_ObjAttributesSlotted:
		moveq	#0,d0
		move.w	(a1)+,d1		; Maximum number of objects that can be made in this array
		move.w	d1,d2
		move.w	(a1)+,d3		; Base VRAM offset of object
		move.w	(a1)+,d4		; Amount to add to base VRAM offset for each slot
		moveq	#0,d5
		move.w	(a1)+,d5		; Index of slot array to use
		lea	(Slotted_object_bits).w,a2
		adda.w	d5,a2			; Get the address of the array to use
		move.b	(a2),d5
		beq.s	loc_84FE4		; If array is clear, just make the object

loc_84FBC:
		lsr.b	#1,d5			; Check slot (each bit)
		bcc.s	loc_84FE4		; If clear, make object
		addq.w	#1,d0			; Increment bit number
		add.w	d4,d3			; Add VRAM offset
		dbf	d1,loc_84FBC		; Repeat max times
		moveq	#0,d0
		move.l	d0,(a0)
		move.l	d0,$10(a0)
		move.l	d0,$14(a0)
		move.b	d0,$2C(a0)
		move.b	d0,4(a0)
		move.w	d0,$2A(a0)		; If no open slots, then destroy this object period
		addq.w	#8,sp
		rts
; ---------------------------------------------------------------------------

loc_84FE4:
		bset	d0,(a2)			; Turn this slot on
		move.b	d0,$3B(a0)
		move.w	a2,$3C(a0)		; Keep track of slot address and bit number
		move.w	d3,$A(a0)		; Use correct VRAM offset
		move.l	(a1)+,$C(a0)	; Mapping address
		move.w	(a1)+,8(a0)		; Priority
		move.b	(a1)+,7(a0)		; Width
		move.b	(a1)+,6(a0)		; Height
		move.b	(a1)+,$22(a0)	; Frame number
		move.b	(a1)+,$28(a0)	; Collision number
		bset	#2,$2A(a0)		; Turn object slotting on
		move.b	#-1,$3A(a0)		; CHECKLATER
		bset	#2,4(a0)		; Use screen coordinates
		addq.b	#2,5(a0)		; Next routine
		rts
; End of function SetUp_ObjAttributesSlotted

CreateChild1_Normal:
		moveq	#0,d2				; Includes positional offset data
		move.w	(a2)+,d6

loc_84064:
		jsr	(SingleObjLoad2).l
		bne.s	locret_840AE
		move.w	a0,$46(a1)			; Parent RAM address into $46
		move.l	$C(a0),$C(a1)
		move.w	$A(a0),$A(a1)		; Mappings and VRAM offset copied from parent object
		move.l	(a2)+,(a1)			; Object address
		move.b	d2,$2C(a1)			; Index of child object (done sequentially for each object)
		move.w	$10(a0),d0
		move.b	(a2)+,d1			; X Positional offset
		move.b	d1,$42(a1)			; $42 has the X offset
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$10(a1)			; Apply offset to new position
		move.w	$14(a0),d0
		move.b	(a2)+,d1			; Same as above for Y
		move.b	d1,$43(a1)			; $43 has the Y offset
		ext.w	d1
		add.w	d1,d0
		move.w	d0,$14(a1)			; Apply offset
		addq.w	#2,d2				; Add 2 to index
		dbf	d6,loc_84064			; Loop
		moveq	#0,d0

locret_840AE:
		rts
; End of function CreateChild1_Normal

SetUp_ObjAttributes:
		move.l	(a1)+,$C(a0)		; Mappings location

SetUp_ObjAttributes2:
		move.w	(a1)+,$A(a0)		; VRAM offset

SetUp_ObjAttributes3:
		move.w	(a1)+,8(a0)			; Priority
		move.b	(a1)+,7(a0)			; Width
		move.b	(a1)+,6(a0)			; Height
		move.b	(a1)+,$22(a0)		; Mappings frame
		move.b	(a1)+,$28(a0)		; Collision Number
		bset	#2,4(a0)			; Object uses world coordinates
		addq.b	#2,5(a0)			; Increase routine counter

locret_8405E:
		rts
; End of function SetUp_ObjAttributes
; =============== S U B R O U T I N E =======================================


Obj_Wait:
		subq.w	#1,$2E(a0)
		bmi.s	loc_84892
		rts
; ---------------------------------------------------------------------------

loc_84892:
		movea.l	$34(a0),a1
		jmp	(a1)
; End of function Obj_Wait


; =============== S U B R O U T I N E =======================================


ObjHitFloor_DoRoutine:
		tst.w	$1A(a0)
		bmi.s	locret_848AA
		jsr	(ObjCheckFloorDist).l
		tst.w	d1
		bmi.s	loc_848AC
		beq.s	loc_848AC

locret_848AA:
		rts
; ---------------------------------------------------------------------------

loc_848AC:
		add.w	d1,$14(a0)
		movea.l	$34(a0),a1
		jmp	(a1)
; End of function ObjHitFloor_DoRoutine


; =============== S U B R O U T I N E =======================================


ObjHitFloor2_DoRoutine:
		move.w	$18(a0),d3
		ext.l	d3
		lsl.l	#8,d3
		add.l	$10(a0),d3
		swap	d3
		jsr	(ObjCheckFloorDist2).l
		cmpi.w	#-1,d1
		blt.s	loc_848DE
		cmpi.w	#$C,d1
		bge.s	loc_848DE
		add.w	d1,$14(a0)
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_848DE:
		movea.l	$34(a0),a1
		jsr	(a1)
		moveq	#1,d0
		rts
; End of function ObjHitFloor2_DoRoutine


; =============== S U B R O U T I N E =======================================


ObjHitWall_DoRoutine:
		jsr	(ObjCheckRightWallDist).l
		tst.w	d1
		bmi.s	loc_848F4
		rts
; ---------------------------------------------------------------------------

loc_848F4:
		add.w	d1,$10(a0)
		movea.l	$34(a0),a1
		jmp	(a1)
; End of function ObjHitWall_DoRoutine

; ---------------------------------------------------------------------------

ObjHitWall2_DoRoutine:
		jsr	(ObjCheckLeftWallDist).l
		tst.w	d1
		bmi.s	loc_8490A
		rts
; ---------------------------------------------------------------------------

loc_8490A:
		add.w	d1,$10(a0)
		movea.l	$34(a0),a1
		jmp	(a1)
; ---------------------------------------------------------------------------

Draw_And_Touch_Sprite:
	;	jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite:
		movea.w	$46(a0),a1
		btst	#7,$2A(a1)
		bne.w	Go_Delete_Sprite
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite:
		movea.w	$46(a0),a1
		btst	#7,$2A(a1)
		bne.w	Go_Delete_Sprite
	;	jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_CheckParent:
		movea.w	$46(a0),a1
		btst	#7,$2A(a1)
		bne.w	Go_Delete_Sprite
		rts
; ---------------------------------------------------------------------------

Child_AddToTouchList:
		movea.w	$46(a0),a1
		btst	#7,$2A(a1)
		bne.w	Go_Delete_Sprite
	;	jmp	(Add_SpriteToCollisionResponseList).l
; ---------------------------------------------------------------------------

Child_Remember_Draw_Sprite:
		movea.w	$46(a0),a1
		btst	#7,$2A(a1)
		bne.s	loc_84984
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_84984:
		jsr	Remove_From_TrackingSlot
		jmp	Go_Delete_Sprite
; ---------------------------------------------------------------------------

Child_Draw_Sprite2:
		movea.w	$46(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_8499E
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8499E:
		jmp	Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2:
		movea.w	$46(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_849C2
		btst	#7,$2A(a1)
		bne.s	loc_849BC
		jsr	(locret_848AA).l

loc_849BC:
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_849C2:
		jmp	Go_Delete_Sprite_2
; ---------------------------------------------------------------------------

Child_Draw_Sprite_FlickerMove:
		movea.w	$46(a0),a1
		btst	#7,$2A(a1)
		bne.s	loc_849D8
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_849D8:
		bset	#7,$2A(a0)
		move.l	#Obj_FlickerMove,(a0)
		clr.b	$28(a0)
		jsr	Set_IndexedVelocity
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_Draw_Sprite2_FlickerMove:
		movea.w	$46(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_849D8
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite_FlickerMove:
		movea.w	$46(a0),a1
		btst	#7,$2A(a1)
		bne.s	loc_849D8
	;	jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

Child_DrawTouch_Sprite2_FlickerMove:
		movea.w	$46(a0),a1
		btst	#4,$38(a1)
		bne.s	loc_849D8
		btst	#7,$2A(a1)
		beq.s	loc_84A3C
		bset	#7,$2A(a0)
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_84A3C:
	;	jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------
Obj_FlickerMove:
		jsr	(ObjectMoveAndFall).l
		move.w	$10(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.w	Go_Delete_Sprite_3
		move.w	$14(a0),d0
		sub.w	(Camera_Y_pos).w,d0
		addi.w	#$80,d0
		cmpi.w	#$200,d0
		bhi.w	Go_Delete_Sprite_3
		bchg	#6,$38(a0)
		beq.w	locret_8405E
		jmp	(Draw_Sprite).l

Go_Delete_Sprite:
		move.l	#Delete_Current_Sprite,(a0)
		bset	#7,$2A(a0)
		rts
Set_IndexedVelocity:
		moveq	#0,d1
		move.b	subtype(a0),d1
		add.w	d1,d1
		add.w	d1,d0
		lea	Obj_VelocityIndex(pc,d0.w),a1
		move.w	(a1)+,x_vel(a0)
		move.w	(a1)+,y_vel(a0)
		btst	#0,render_flags(a0)
		beq.s	locret_852F2
		neg.w	x_vel(a0)

locret_852F2:
		rts
; End of function Set_IndexedVelocity

; ---------------------------------------------------------------------------
Obj_VelocityIndex:	dc.w  $FF00, $FF00
		dc.w   $100, $FF00
		dc.w  $FE00, $FE00
		dc.w   $200, $FE00
		dc.w  $FD00, $FE00
		dc.w   $300, $FE00
		dc.w  $FE00, $FE00
		dc.w      0, $FE00
		dc.w  $FC00, $FD00
		dc.w   $400, $FD00
		dc.w   $300, $FD00
		dc.w  $FC00, $FD00
		dc.w   $400, $FD00
		dc.w  $FE00, $FE00
		dc.w   $200, $FE00
		dc.w      0, $FF00
		dc.w  $FFC0, $F900
		dc.w  $FF80, $F900
		dc.w  $FE80, $F900
		dc.w  $FF00, $F900
		dc.w  $FE00, $F900
		dc.w  $FD80, $F900
		dc.w  $FD00, $F900
		dc.w      0, $FF00
		dc.w  $FF00, $FF00
		dc.w   $100, $FF00
		dc.w  $FE00, $FF00
		dc.w   $200, $FF00
		dc.w  $FE00, $FE00
		dc.w   $200, $FE00
		dc.w  $FD00, $FE00
		dc.w   $300, $FE00
		dc.w  $FD00, $FD00
		dc.w   $300, $FD00
		dc.w  $FC00, $FD00
		dc.w   $400, $FD00
		dc.w  $FE00, $FD00
		dc.w   $200, $FD00

; =============== S U B R O U T I N E =======================================
; End of function Go_Delete_Sprite
Go_Delete_SpriteSlotted2:
		move.l	#Delete_Current_Sprite,(a0)
		bset	#7,$2A(a0)
 Remove_From_TrackingSlot:
		move.b	$3B(a0),d0
		movea.w	$3C(a0),a1
		bclr	d0,(a1)
		rts
; End of function Remove_From_TrackingSlot
Set_VelocityXTrackSonic:
		lea	(MainCharacter).w,a1
		jsr	Find_OtherObject
		bclr	#0,4(a0)
		tst.w	d0
		beq.s	loc_85430
		neg.w	d4
		bset	#0,4(a0)

loc_85430:
		move.w	d4,$18(a0)
		rts
; End of function Set_VelocityXTrackSonic
Swing_UpAndDown_Count:
		jsr	Swing_UpAndDown
		tst.w	d3
		beq.s	locret_84888
		move.b	$39(a0),d2
		subq.b	#1,d2
		move.b	d2,$39(a0)
		bmi.s	loc_84886
		moveq	#0,d0
		rts
; ---------------------------------------------------------------------------

loc_84886:
		moveq	#1,d0

locret_84888:
		rts
; End of function Swing_UpAndDown_Count
Animate_RawMultiDelayFlipX:
		movea.l	$30(a0),a1
; End of function Animate_RawMultiDelayFlipX
Animate_RawNoSSTMultiDelayFlipX:
		subq.b	#1,$24(a0)
		bpl.s	loc_84646
		moveq	#0,d0
		move.b	$23(a0),d0
		addq.w	#2,d0
		move.b	d0,$23(a0)
		moveq	#0,d1
		move.b	(a1,d0.w),d1
		bmi.s	loc_845CC
		bclr	#6,d1
		beq.s	loc_84638
		bchg	#0,4(a0)

loc_84638:
		move.b	d1,$22(a0)
		move.b	1(a1,d0.w),$24(a0)
		moveq	#1,d2
		rts
; ---------------------------------------------------------------------------

loc_84646:
		moveq	#0,d2
		rts
; End of function Animate_RawNoSSTMultiDelayFlipX

Animate_RawMultiDelay:
		movea.l	$30(a0),a1
; End of function Animate_RawMultiDelay


; =============== S U B R O U T I N E =======================================


Animate_RawNoSSTMultiDelay:
		subq.b	#1,$24(a0)
		bpl.s	loc_845C8
		moveq	#0,d0
		move.b	$23(a0),d0
		addq.w	#2,d0
		move.b	d0,$23(a0)
		moveq	#0,d1
		move.b	(a1,d0.w),d1
		bmi.s	loc_845CC
		move.b	d1,$22(a0)
		move.b	1(a1,d0.w),$24(a0)
		moveq	#1,d2
		rts
; ---------------------------------------------------------------------------

loc_845C8:
		moveq	#0,d2
		rts
; ---------------------------------------------------------------------------

loc_845CC:
		neg.b	d1
		jsr	loc_845D2+2(pc,d1.w)

loc_845D2:
		clr.b	$23(a0)
		rts
; End of function Animate_RawNoSSTMultiDelay
Swing_UpAndDown:
		move.w	$40(a0),d0	; Acceleration
		move.w	$1A(a0),d1  ; Velocity
		move.w	$3E(a0),d2  ; Maximum acceleration before "swinging"
		moveq	#0,d3
		btst	#0,$38(a0)
		bne.s	loc_84812
		neg.w	d0			; Apply upward acceleration
		add.w	d0,d1
		neg.w	d2
		cmp.w	d2,d1
		bgt.s	loc_84824
		bset	#0,$38(a0)
		neg.w	d0
		neg.w	d2
		moveq	#1,d3

loc_84812:
		add.w	d0,d1		; Apply downward acceleration
		cmp.w	d2,d1
		blt.s	loc_84824
		bclr	#0,$38(a0)
		neg.w	d0
		add.w	d0,d1
		moveq	#1,d3

loc_84824:
		move.w	d1,$1A(a0)
		rts
; End of function Swing_UpAndDown

Animate_Raw:
		movea.l	$30(a0),a1
; End of function Animate_Raw


; =============== S U B R O U T I N E =======================================


Animate_RawNoSST:
		subq.b	#1,$24(a0)
		bpl.s	locret_84426
		moveq	#0,d0
		move.b	$23(a0),d0
		addq.w	#1,d0
		move.b	d0,$23(a0)
		moveq	#0,d1
		move.b	1(a1,d0.w),d1
		bmi.s	loc_84428
		move.b	(a1),$24(a0)
		move.b	d1,$22(a0)

locret_84426:
		rts
; ---------------------------------------------------------------------------

loc_84428:
		neg.b	d1
		jsr	loc_8442E+2(pc,d1.w)

loc_8442E:
		clr.b	$23(a0)
		rts
; End of function Animate_RawNoSST
Refresh_ChildPositionAdjusted:
		movea.w	$46(a0),a1
		move.w	$10(a1),d0
		move.b	$42(a0),d1
		ext.w	d1
		bclr	#0,4(a0)
		btst	#0,4(a1)
		beq.s	loc_843D2
		neg.w	d1
		bset	#0,4(a0)

loc_843D2:
		add.w	d1,d0
		move.w	d0,$10(a0)
		move.w	$14(a1),d0
		move.b	$43(a0),d1
		ext.w	d1
		bclr	#1,4(a0)
		btst	#1,4(a1)
		beq.s	loc_843F8
		neg.w	d1
		bset	#1,4(a0)

loc_843F8:
		add.w	d1,d0
		move.w	d0,$14(a0)
		rts
; End of function Refresh_ChildPositionAdjusted

Find_OtherObject:
		moveq	#0,d0			; d0 = 0 if other object is left of calling object, 2 if right of it
		moveq	#0,d1			; d1 = 0 if other object is above calling object, 2 if below it
		move.w	x_pos(a0),d2
		sub.w	x_pos(a1),d2
		bpl.s	loc_84BAE
		neg.w	d2
		addq.w	#2,d0

loc_84BAE:
		moveq	#0,d1
		move.w	y_pos(a0),d3
		sub.w	y_pos(a1),d3
		bpl.s	locret_84BBE
		neg.w	d3
		addq.w	#2,d1

locret_84BBE:
		rts
; End of function Find_OtherObject
; =============== S U B R O U T I N E =======================================


Go_Delete_Sprite_2:
		move.l	#Delete_Current_Sprite,(a0)
		bset	#4,$38(a0)
		rts
; End of function Go_Delete_Sprite_2

; ---------------------------------------------------------------------------

Go_Delete_Sprite_3:
		move.l	#Delete_Current_Sprite,(a0)
		bset	#7,$2A(a0)
		bset	#4,$38(a0)
		rts

Obj_Fireworm:
	;	jsr	(Obj_WaitOffscreen).l
		moveq	#0,d0
		move.b	5(a0),d0
		move.w	off_8F76A(pc,d0.w),d1
		jsr	off_8F76A(pc,d1.w)
		jmp	(MarkObjGone).l
; ---------------------------------------------------------------------------
off_8F76A:	offsetTable
                offsetTableEntry.w loc_8F770
		offsetTableEntry.w loc_8F77A
		offsetTableEntry.w locret_8F7A2
; ---------------------------------------------------------------------------

loc_8F770:
		lea	ObjDat3_8F9DE(pc),a1
		jmp	(SetUp_ObjAttributes).l
; ---------------------------------------------------------------------------

loc_8F77A:
		jsr	(Find_SonicTails).l
		cmpi.w	#$80,d2
		blo.s	loc_8F788
		rts
; ---------------------------------------------------------------------------

loc_8F788:
		move.b	#4,5(a0)
		lea	ChildObjDat_8FA0E(pc),a2
		jsr	(CreateChild1_Normal).l
		bne.s	locret_8F7A0
		move.b	$2C(a0),$2C(a1)

locret_8F7A0:
		rts
; ---------------------------------------------------------------------------

locret_8F7A2:
		rts
; ---------------------------------------------------------------------------

loc_8F7A4:
		moveq	#0,d0
		move.b	5(a0),d0
		move.w	off_8F7E0(pc,d0.w),d1
		jsr	off_8F7E0(pc,d1.w)
	;	lea	(DPLCPtr_8FA38).l,a2
	;	jsr	(Perform_DPLC).l
		move.w	$10(a0),d0
		andi.w	#-$80,d0
		sub.w	(Camera_X_pos_coarse).w,d0
		cmpi.w	#$280,d0
		bhi.s	loc_8F7DA
		;jsr	(Add_SpriteToCollisionResponseList).l
		jmp	(Draw_Sprite).l
; ---------------------------------------------------------------------------

loc_8F7DA:
		jmp	(Go_Delete_SpriteSlotted2).l
; ---------------------------------------------------------------------------

off_8F7E0:      offsetTable
          	offsetTableEntry.w loc_8F7EA
		offsetTableEntry.w loc_8F7F4
		offsetTableEntry.w loc_8F812
		offsetTableEntry.w loc_8F862
		offsetTableEntry.w loc_8F89A
; ---------------------------------------------------------------------------

loc_8F7EA:
		lea	ObjDat4_8F9EA(pc),a1
		jsr	(SetUp_ObjAttributesSlotted).l

loc_8F7F4:
		move.b	#4,5(a0)
		move.w	#3,$2E(a0)
		move.l	#loc_8F81E,$34(a0)
		move.w	#-$100,d4
		jmp	(Set_VelocityXTrackSonic).l
; ---------------------------------------------------------------------------

loc_8F812:
		jsr	(ObjectMove).l
		jmp	(Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8F81E:
		move.b	#1,$22(a0)
		lea	ChildObjDat_8FA16(pc),a2
		jsr	(CreateChild1_Normal).l

loc_8F82E:
		move.b	#6,5(a0)
		move.w	#-$100,$42(a0)
		move.l	#byte_8FA40,$30(a0)

loc_8F842:
		move.b	#8,$39(a0)
		move.w	#$80,d0
		move.w	d0,$3E(a0)
		move.w	d0,$1A(a0)
		move.w	#8,$40(a0)
		bclr	#0,$38(a0)
		rts
; ---------------------------------------------------------------------------

loc_8F862:
		jsr	(Swing_UpAndDown_Count).l
		bne.s	loc_8F876
		jsr	(ObjectMove).l
		jmp	(Animate_RawMultiDelay).l
; ---------------------------------------------------------------------------

loc_8F876:
		move.b	#8,5(a0)
		move.w	$18(a0),$44(a0)
		move.w	$42(a0),$1A(a0)
		neg.w	$42(a0)
		clr.w	$2E(a0)
		clr.b	$23(a0)
		clr.b	$24(a0)
		rts
; ---------------------------------------------------------------------------

loc_8F89A:
		lea	byte_8FA4D(pc),a1
		jsr	(Animate_RawNoSSTMultiDelayFlipX).l
		addq.w	#1,$2E(a0)
		tst.w	$44(a0)
		bmi.s	loc_8F8C6
		move.w	$18(a0),d0
		subi.w	#$10,d0
		cmpi.w	#-$100,d0
		ble.s	loc_8F8DE
		move.w	d0,$18(a0)
		jmp	(ObjectMove).l
; ---------------------------------------------------------------------------

loc_8F8C6:
		move.w	$18(a0),d0
		addi.w	#$10,d0
		cmpi.w	#$100,d0
		bge.s	loc_8F8DE
		move.w	d0,$18(a0)
		jmp	(ObjectMove).l
; ---------------------------------------------------------------------------

loc_8F8DE:
		move.b	#6,5(a0)
		clr.b	$23(a0)
		clr.b	$24(a0)
		jmp	loc_8F842
; ---------------------------------------------------------------------------

loc_8F8F0:
		moveq	#0,d0
		move.b	5(a0),d0
		move.w	off_8F906(pc,d0.w),d1
		jsr	off_8F906(pc,d1.w)
		moveq	#0,d0
		jmp	(Child_DrawTouch_Sprite_FlickerMove).l
; ---------------------------------------------------------------------------
off_8F906:	dc.w loc_8F910-off_8F906
		dc.w loc_8F948-off_8F906
		dc.w loc_8F948-off_8F906
		dc.w loc_8F862-off_8F906
		dc.w loc_8F89A-off_8F906
; ---------------------------------------------------------------------------

loc_8F910:
		lea	ObjDat3_8F9FC(pc),a1
		jsr	(SetUp_ObjAttributes).l
		moveq	#0,d0
		move.b	$2C(a0),d0
		move.w	word_8F940(pc,d0.w),$2E(a0)
		move.l	#loc_8F94E,$34(a0)
		movea.w	$46(a0),a1
		move.w	$18(a1),$18(a0)
		move.b	4(a1),4(a0)
		rts
; ---------------------------------------------------------------------------
word_8F940:	dc.w $B
		dc.w $16
		dc.w $21
		dc.w $2C
; ---------------------------------------------------------------------------

loc_8F948:
		jmp	(Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8F94E:
		lea	ChildObjDat_8FA30(pc),a2
		jsr	(CreateChild1_Normal).l
		jmp	loc_8F82E
; ---------------------------------------------------------------------------

loc_8F95C:
		jsr	(Refresh_ChildPositionAdjusted).l
		moveq	#0,d0
		move.b	5(a0),d0
		move.w	off_8F976(pc,d0.w),d1
		jsr	off_8F976(pc,d1.w)
		jmp	(Child_DrawTouch_Sprite).l
; ---------------------------------------------------------------------------
off_8F976:	dc.w loc_8F97C-off_8F976
		dc.w loc_8F99E-off_8F976
		dc.w loc_8F9C8-off_8F976
; ---------------------------------------------------------------------------

loc_8F97C:
		lea	word_8FA08(pc),a1
		jsr	(SetUp_ObjAttributes3).l
		move.l	#byte_8FA56,$30(a0)
		move.l	#loc_8F9A4,$34(a0)
		bset	#4,$2B(a0)
		rts
; ---------------------------------------------------------------------------

loc_8F99E:
		jmp	(Animate_Raw).l
; ---------------------------------------------------------------------------

loc_8F9A4:
		move.b	#4,5(a0)
		move.b	#7,$22(a0)
		jsr	(RandomNumber).l
		andi.w	#$3F,d0
		move.w	d0,$2E(a0)
		move.l	#loc_8F9CE,$34(a0)
		rts
; ---------------------------------------------------------------------------

loc_8F9C8:
		jmp	(Obj_Wait).l
; ---------------------------------------------------------------------------

loc_8F9CE:
		move.b	#2,5(a0)
		move.l	#loc_8F9A4,$34(a0)
		rts
; ---------------------------------------------------------------------------
ObjDat3_8F9DE:	dc.l Map_FirewormSegments
		dc.w $E512
		dc.w $280
		dc.b $C
		dc.b $C
		dc.b 0
		dc.b 0
ObjDat4_8F9EA:	dc.w 1
		dc.w $A500
		dc.w 9
		dc.w 0
		dc.l Map_Fireworm
		dc.w $180
		dc.b $C
		dc.b $C
		dc.b 0
		dc.b $1A
ObjDat3_8F9FC:	dc.l Map_FirewormSegments
		dc.w $A512
		dc.w $200
		dc.b 8
		dc.b 8
		dc.b 1
		dc.b $98
word_8FA08:	dc.w $180
		dc.b 8
		dc.b 8
		dc.b 3
		dc.b $98
ChildObjDat_8FA0E:dc.w 0
		dc.l loc_8F7A4
		dc.w $F8
ChildObjDat_8FA16:dc.w 3
		dc.l loc_8F8F0
		dc.w 0
		dc.l loc_8F8F0
		dc.w 0
		dc.l loc_8F8F0
		dc.w 0
		dc.l loc_8F8F0
		dc.w 0
ChildObjDat_8FA30:dc.w 0
		dc.l loc_8F95C
		dc.w $F2
DPLCPtr_8FA38:	dc.l ArtUnc_Fireworm
		dc.l DPLC_Fireworm
byte_8FA40:	dc.b    1,   3
		dc.b    1,   6
		dc.b    2,   8
		dc.b    3,   1
		dc.b  $F8,  $A
		dc.b    3, $7F
		dc.b  $FC
byte_8FA4D:	dc.b    3,   7
		dc.b    2,   7
		dc.b  $42,   7
		dc.b    3, $7F
		dc.b  $FC
byte_8FA56:	dc.b    3,   4
		dc.b    4,   5
		dc.b    6, $F4
             rev02even

Find_SonicTails:
		moveq	#0,d0			; d0 = 0 if Sonic/Tails is left of object, 2 if right of object
		moveq	#0,d1			; d1 = 0 if Sonic/Tails is above object, 2 if below object
		lea	(MainCharacter).w,a1
		move.w	$10(a0),d2
		sub.w	$10(a1),d2
		bpl.s	loc_84B2E
		neg.w	d2
		addq.w	#2,d0

loc_84B2E:
		lea	(Sidekick).w,a2
		move.w	$10(a0),d3
		sub.w	$10(a2),d3
		bpl.s	loc_84B40
		neg.w	d3
		addq.w	#2,d1

loc_84B40:
		cmp.w	d3,d2
		bls.s	loc_84B4A
		movea.l	a2,a1
		move.w	d1,d0
		move.w	d3,d2

loc_84B4A:
		moveq	#0,d1
		move.w	$14(a0),d3
		sub.w	$14(a1),d3
		bpl.s	locret_84B5A
		neg.w	d3
		addq.w	#2,d1

locret_84B5A:
		rts
; End of function Find_SonicTails

Perform_DPLC:
		moveq	#0,d0
		move.b	$22(a0),d0		; Get the frame number
		cmp.b	$3A(a0),d0		; If frame number remains the same as before, don't do anything
		beq.s	locret_8506E
		move.b	d0,$3A(a0)
		movea.l	(a2)+,a3		; Source address of art
		move.w	$A(a0),d4
		andi.w	#$7FF,d4		; Isolate tile location offset
		lsl.w	#5,d4			; Convert to VRAM address
		movea.l	(a2)+,a2		; Address of DPLC script
		add.w	d0,d0
		adda.w	(a2,d0.w),a2	; Apply offset to script
		move.w	(a2)+,d5		; Get number of DMA transactions
		moveq	#0,d3

loc_8504A:
		move.w	(a2)+,d3		; Art source offset
		move.l	d3,d1
		andi.w	#$FFF0,d1		; Isolate all but lower 4 bits
		add.w	d1,d1
		add.l	a3,d1			; Get final source address of art
		move.w	d4,d2			; Destination VRAM address
		andi.w	#$F,d3
		addq.w	#1,d3
		lsl.w	#4,d3			; d3 is the total number of words to transfer (maximum 16 tiles per transaction)
		add.w	d3,d4
		add.w	d3,d4
		jsr	(QueueDMATransfer).l	; Add to queue
		dbf	d5,loc_8504A		; Keep going

locret_8506E:
		rts
