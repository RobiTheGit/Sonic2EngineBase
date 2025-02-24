


ObjCapsuleFlag = objoff_44
ObjCapsuleTimer = objoff_38
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 3E - Egg prison
; ----------------------------------------------------------------------------
; Sprite_3F1E4:
Obj3E_ObjLoadData:
        ; addr,childdy,width,prio,frame
        dc.l   loc_3F278
	dc.b   0        ;child dy
        dc.b   $20,  4,  0 ;0

        dc.l   ObjCapsuleButton
        dc.b   $28
        dc.b   $10,  5,  4 ; 1

        dc.l   Obj_CapsuleFlyingPartical
        dc.b   $18
        dc.b    8,  3,  5 ;2

        dc.l   loc_3F3A8
        dc.b   0
        dc.b   $20,  4,  0 ; 3
Obj3E_ObjLoadData_End:
Obj3E:
;	moveq	#0,d0
;	move.b	routine(a0),d0
;	move.w	Obj3E_Index(pc,d0.w),d1
;	jmp	Obj3E_Index(pc,d1.w)

; ===========================================================================
; off_3F1F2:
;Obj3E_Index:	offsetTable
;		offsetTableEntry.w loc_3F212	;  0
;		offsetTableEntry.w loc_3F278	;  2
;		offsetTableEntry.w ObjCapsuleButton	;  4
;		offsetTableEntry.w Obj_CapsuleFlyingPartical	;  6
;		offsetTableEntry.w loc_3F3A8	;  8
;		offsetTableEntry.w loc_3F406	; $A
; ----------------------------------------------------------------------------
; byte_3F1FE:

;	dc.b $28,  4,$10,  5,  4	; 5
;	dc.b $18,  6,  8,  3,  5	; 10  ; flying partical object ( when you hit the button)
;	dc.b   0,  8,$20,  4,  0	; 15  ; unused ?
; ===========================================================================

loc_3F212:
	movea.l	a0,a1
	lea	objoff_2C(a0),a3 ; then objoff_44 is a parent and parent 3 is a child and then parent 2 is a child then you hit $4A then death
	lea	Obj3E_ObjLoadData(pc),a2
	moveq	#(Obj3E_ObjLoadData_End-Obj3E_ObjLoadData)/$8-1,d1
	bra.s	loc_3F228
; ===========================================================================

loc_3F220:
	jsr	(SingleObjLoad).l
	bne.s	loc_3F272
	move.w	a1,(a3)+

loc_3F228:
        move.l	(a2)+,(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	y_pos(a0),objoff_46(a1)
	move.l	#Obj3E_MapUnc_3F436,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Capsule,1,0),art_tile(a1)
	move.b	#$84,render_flags(a1)
	moveq	#0,d0
	move.b	(a2)+,d0
	sub.w	d0,y_pos(a1)
	move.w	y_pos(a1),objoff_46(a1)
	move.b	(a2)+,width_pixels(a1)
	move.b	(a2)+,priority(a1)
	move.b	(a2)+,mapping_frame(a1)

loc_3F272:
	dbf	d1,loc_3F220
	rts
; ===========================================================================

loc_3F278:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_3F2AE(pc,d0.w),d1
	jsr	off_3F2AE(pc,d1.w)
	move.w	#$2B,d1
	move.w	#$18,d2
	move.w	#$18,d3
	move.w	x_pos(a0),d4
	jsr	(SolidObject).l
	lea	(Ani_Obj_EggPrison).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
off_3F2AE:	offsetTable
		offsetTableEntry.w loc_3F2B4	; 0
		offsetTableEntry.w loc_3F2FC	; 2
		offsetTableEntry.w return_3F352	; 4
; ===========================================================================

loc_3F2B4:
	movea.w	objoff_2C(a0),a1 ; a1=object
	tst.b	ObjCapsuleFlag(a1)
	beq.s	++	; rts
	movea.w	objoff_2E(a0),a2 ; a2=object
	jsr	(SingleObjLoad).l
	bne.s	+
	move.l	#Obj27,(a1) ; load obj
	addq.b	#2,routine(a1)
	move.w	x_pos(a2),x_pos(a1)
	move.w	y_pos(a2),y_pos(a1)
+
	move.w	#-$400,y_vel(a2)
	move.w	#$800,x_vel(a2)
	addq.b	#2,routine_secondary(a2) ; go to return_3F352
	move.w	#$1D,ObjCapsuleTimer(a0)
	addq.b	#2,routine_secondary(a0) ; go to loc_3F2FC
+
	rts
; ===========================================================================

loc_3F2FC:
	subq.w	#1,ObjCapsuleTimer(a0)
	bpl.s	return_3F352
	move.b	#1,anim(a0)
	moveq	#7,d6
	move.w	#$9A,d5
	moveq	#-$1C,d4

-	jsr	(SingleObjLoad).l
	bne.s	+
	move.l	#Obj28,(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	add.w	d4,x_pos(a1)
	move.b	#1,objoff_3C(a1) ; 38
	addq.w	#7,d4
	move.w	d5,objoff_3A(a1) ;36
	subq.w	#8,d5
	dbf	d6,-
+
	movea.w	objoff_30(a0),a2 ; a2=object
	move.w	#$B4,anim_frame_duration(a2)
	addq.b	#2,routine_secondary(a2)
	addq.b	#2,routine_secondary(a0)

return_3F352:
	rts
; ===========================================================================
         ; object that displays and sets a flag when standing on it
ObjCapsuleButton:
	move.w	#$1B,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	x_pos(a0),d4
	jsr	(SolidObject).l
	move.w	objoff_46(a0),y_pos(a0)
	move.b	status(a0),d0
	andi.b	#standing_mask,d0
	beq.s	+
	addq.w	#8,y_pos(a0)
	clr.b	(Update_HUD_timer).w
	move.b	#1,ObjCapsuleFlag(a0)
+
	jmp	(MarkObjGone).l
; ===========================================================================
        ; small object partical that falls   and uhh gets an y and x speed from parent
Obj_CapsuleFlyingPartical:
	tst.b	routine_secondary(a0)
	beq.s	+
	tst.b	render_flags(a0)
	bpl.w	JmpTo66_DeleteObject
	jsr	(ObjectMoveAndFall).l
+
	jmp	(MarkObjGone).l

    if removeJmpTos
JmpTo66_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
    endif
; ===========================================================================
     ; idk object
loc_3F3A8:

	tst.b	routine_secondary(a0) ; was the anim reset ?
	beq.s	return_3F404           ; if not do nothing if it is then start spawning animals
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	loc_3F3F4
	jsr	(SingleObjLoad).l
	bne.s	loc_3F3F4
	move.l	#Obj28,(a1) ; load obj
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	jsr	(RandomNumber).l
	andi.w	#$1F,d0
	subq.w	#6,d0
	tst.w	d1
	bpl.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a1)
	move.b	#1,objoff_3C(a1)  ; 38
	move.w	#$C,objoff_3A(a1) ; 36

loc_3F3F4:
	subq.b	#1,anim_frame_duration(a0)
	bne.s	return_3F404
	move.l	#loc_3F406,(a0) ; go to loc_3F406
	move.b	#$B4,anim_frame_duration(a0)

return_3F404:
	rts
; ===========================================================================

loc_3F406:
	moveq	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d0
	move.l	#Obj28,d1
	lea	(Dynamic_Object_RAM).w,a1

-	cmp.l	(a1),d1
	beq.s	+	; rts
	lea	next_object(a1),a1 ; a1=object
	dbf	d0,-

	jsr	(Load_EndOfAct).l
	jmp	(DeleteObject).l
; ===========================================================================
+	rts
; ===========================================================================
; animation script
; off_3F428:
Ani_Obj_EggPrison:	offsetTable
		offsetTableEntry.w byte_3F42C	; 0
		offsetTableEntry.w byte_3F42F	; 1
byte_3F42C:	dc.b  $F,  0,$FF
		rev02even
byte_3F42F:	dc.b   3,  0,  1,  2,  3,$FE,  1
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj3E_MapUnc_3F436:	BINCLUDE "mappings/sprite/obj3E.bin"
        even
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo66_DeleteObject ; JmpTo
	jmp	(DeleteObject).l
JmpTo20_SingleObjLoad ; JmpTo
	jmp	(SingleObjLoad).l

	align 4
    endif
