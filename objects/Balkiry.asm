



; ===========================================================================
; ----------------------------------------------------------------------------
; Object AC - Balkiry (jet badnik) from SCZ
; ----------------------------------------------------------------------------
; Sprite_3937A:
ObjAC:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjAC_Index(pc,d0.w),d1
	jmp	ObjAC_Index(pc,d1.w)
; ===========================================================================
; off_39388:
ObjAC_Index:	offsetTable
		offsetTableEntry.w ObjAC_Init	; 0
		offsetTableEntry.w ObjAC_Main	; 2
; ===========================================================================
; loc_3938C:
ObjAC_Init:
	bsr.w	LoadSubObject
	move.b	#1,mapping_frame(a0)
	move.w	#-$300,x_vel(a0)
	bclr	#1,render_flags(a0)
	beq.s	+
	move.w	#-$500,x_vel(a0)
+
	lea_	Ani_obj9C,a1
	movea.l	a1,objoff_32(a0)
	bsr.w	MakeChildJetThing
	move.b  #0,objoff_12(a1)
	rts
; ===========================================================================
; loc_393B6:
ObjAC_Main:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	bsr.w	loc_36776
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
; off_393C2:
ObjAC_SubObjData:
	subObjData ObjAC_MapUnc_393CC,make_art_tile(ArtTile_ArtNem_Balkrie,0,0),4,4,$20,8
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjAC_MapUnc_393CC:	BINCLUDE "mappings/sprite/objAC.bin"
                even
MakeChildJetThing:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	+	; rts
	move.l	#Obj9C,(a1) ; load obj9C
	move.b	#6,mapping_frame(a1)
	move.b	#$1A,subtype(a1) ; <== Obj9C_SubObjData
	move.w	a0,objoff_30(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	objoff_32(a0),objoff_32(a1)
+
	rts
