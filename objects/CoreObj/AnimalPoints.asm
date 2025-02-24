
; ===========================================================================
; ----------------------------------------------------------------------------
; Object 27 - An explosion, giving off an animal and 100 points
; ----------------------------------------------------------------------------
; Sprite_21088:
Obj27:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj27_Index(pc,d0.w),d1
	jmp	Obj27_Index(pc,d1.w)
; ===========================================================================
; off_21096: Obj27_States:
Obj27_Index:	offsetTable
		offsetTableEntry.w Obj27_InitWithAnimal	; 0
		offsetTableEntry.w Obj27_Init		; 2
		offsetTableEntry.w Obj27_Main		; 4
; ===========================================================================
; loc_2109C: Obj27_Init:
Exploation_High_Priority:
	move.l	#Obj27_Main,(a0) ;
	move.l	#Obj27_MapUnc_21120,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKosM_Explosion,0,0),art_tile(a0)
	jmp   Exploation_Settings
Obj27_InitWithAnimal:
	addq.b	#2,routine(a0) ; => Obj27_Init
	jsrto	(SingleObjLoad).l, JmpTo2_SingleObjLoad
	bne.s	Obj27_Init
	move.l	#Obj28,(a1) ; load obj28 (Animal and 100 points)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	objoff_42(a0),objoff_42(a1)	; Set by Touch_KillEnemy

; loc_210BE: Obj27_Init2:
Obj27_Init:
	addq.b	#2,routine(a0) ; => Obj27_Main
	move.l	#Obj27_MapUnc_21120,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKosM_Explosion,0,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#1,priority(a0)
Exploation_Settings:
	move.b	#0,collision_flags(a0)
	move.b	#$C,width_pixels(a0)
	move.b	#3,anim_frame_duration(a0)
	move.b	#0,mapping_frame(a0)
	move.w	#SndID_Explosion,d0
	jmp	(PlaySound).l

; loc_21102:
Obj27_Main:
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	+
	move.b	#7,anim_frame_duration(a0)
	addq.b	#1,mapping_frame(a0)
	cmpi.b	#5,mapping_frame(a0)
	beq.w	JmpTo18_DeleteObject
+
	jmpto	(DisplaySprite).l, JmpTo10_DisplaySprite
; ===========================================================================
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj27_MapUnc_21120:	BINCLUDE "mappings/sprite/obj27.bin"
                      even

