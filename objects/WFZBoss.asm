; ===========================================================================
SecondRoutine_WFZBoss = $3C  ;  ; byte  its routine sec varable that gets called by ani script
WFZFlickerVarable = $13  ;   ; byte ; used to interupt displaying giving a flickery look
WFZBoss_ShootOut = $2D    ; byte
WFZ_BossParent =  $2E    ;word
WFZCountDown =   $2E   ;word   ; timer for events
Child_Refrence_WFZ = $30 ; word ; main things for the parents (mother object)
HitCount_WFZ =    $34 ;word
Max_LeftVarable =  $36   ;word
Max_RightVarable =  $38  ;word
parent_LaerShooters = $3A  ; word
WFZParentCustomize = $46   ; word laser and stuff parent
Small_PlatformsParent = $3E ; word
RobotnickParentAddr =  $44  ; word
; ----------------------------------------------------------------------------
; Object C5 - WFZ boss
; ----------------------------------------------------------------------------
; Sprite_3C442:
ObjC5:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	ObjC5_Index(pc,d0.w),d1
	jmp	ObjC5_Index(pc,d1.w)
; ===========================================================================
ObjC5_Index:	offsetTable
		offsetTableEntry.w ObjC5_Init			;   0 - Main loading sequence
		offsetTableEntry.w ObjC5_LaserCase		;   2 - Laser case (inside is laser)
		offsetTableEntry.w ObjC5_LaserWall		;   4 - Laser wall
		offsetTableEntry.w ObjC5_PlatformReleaser	;   6 - Platform releaser
		offsetTableEntry.w ObjC5_Platform		;   8 - Platform
		offsetTableEntry.w ObjC5_PlatformHurt		;  $A - Invisible object that gets the platform's spikes to hurt sonic
		offsetTableEntry.w ObjC5_LaserShooter		;  $C - Laser shooter
		offsetTableEntry.w ObjC5_Laser			;  $E - Laser
		; robotnick on platform object
		offsetTableEntry.w ObjC5_Robotnik		; $10 - Robotnik
		offsetTableEntry.w ObjC5_RobotnikPlatform	; $12 - Platform Robotnik's on
; ===========================================================================

ObjC5_Init:
	bsr.w	LoadSubObject
	move.b	subtype(a0),d0
	subi.b	#$90,d0
	move.b	d0,routine(a0)
	rts
; ===========================================================================

ObjC5_LaserCase:	; also the "mother" object
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_CaseIndex(pc,d0.w),d1
	jsr	ObjC5_CaseIndex(pc,d1.w)
	bra.w	ObjC5_HandleHits
; ===========================================================================
ObjC5_CaseIndex:offsetTable
		offsetTableEntry.w ObjC5_CaseBoundary		;   0 - Sets up boundaries for movement and basic things
		offsetTableEntry.w ObjC5_CaseWaitStart		;   2 - Waits for sonic to start
		offsetTableEntry.w ObjC5_CaseWaitDown		;   4 - Waits to make the laser go down
		offsetTableEntry.w ObjC5_CaseDown		;   6 - Moves the case down
		offsetTableEntry.w ObjC5_CaseXSpeed		;   8 - Sets an X speed for the case
		offsetTableEntry.w ObjC5_CaseBoundaryChk	;  $A - Checks to make sure the case doesn't go through the boundaries
		offsetTableEntry.w ObjC5_CaseAnimate		;  $C - Animates the case (opening and closing)
		offsetTableEntry.w ObjC5_CaseLSLoad		;  $E - Laser shooter loading
		offsetTableEntry.w ObjC5_CaseLSDown		; $10 - Moves the laser shooter down
		offsetTableEntry.w ObjC5_CaseWaitLoadLaser	; $12 - Waits to load the laser
		offsetTableEntry.w ObjC5_CaseWaitMove		; $14 - Waits to move (checks if laser is completely loaded (as big as it gets))
		offsetTableEntry.w ObjC5_CaseBoundaryLaserChk	; $16 - Checks boundaries when moving with the laser
		offsetTableEntry.w ObjC5_CaseLSUp		; $18 - wait for laser shooter to go back up
		offsetTableEntry.w ObjC5_CaseAnimate		; $1A - Animates the case (opening and closing)
		offsetTableEntry.w ObjC5_CaseStartOver		; $1C - Sets secondary routine to 8
		offsetTableEntry.w ObjC5_CaseDefeated		; $1E - When defeated goes here (explosions and stuff)
; ===========================================================================

ObjC5_CaseBoundary:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#0,collision_flags(a0)
	move.b	#8,collision_property(a0)	; Hit points
	move.w	#$442,d0
	move.w	d0,(Camera_Max_Y_pos_now).w
	move.w	d0,(Camera_Max_Y_pos).w
	move.w	x_pos(a0),d0
	subi.w	#$60,d0			; Max Left position
	move.w	d0,Max_LeftVarable(a0)
	addi.w	#$C0,d0			; Max Right Position
	move.w	d0,Max_RightVarable(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitStart:
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2			; How far away sonic is to start the boss
	blo.s	ObjC5_CaseStart
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStart:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$40,y_vel(a0)		; Speed at which the laser carrier goes down
	lea	(ObjC5_LaserWallData).l,a2
	bsr.w	LoadChildObject
	subi.w	#$88,x_pos(a1)		; where to load the left laser wall (x)
	addi.w	#$60,y_pos(a1)		; left laser wall (y)
	lea	(ObjC5_LaserWallData).l,a2
	bsr.w	LoadChildObject
	addi.w	#$88,x_pos(a1)		; right laser wall (x)
	addi.w	#$60,y_pos(a1)		; right laser wall (y)
	lea	(ObjC5_LaserShooterData).l,a2
	bsr.w	LoadChildObject
	lea	(ObjC5_PlatformReleaserData).l,a2
	bsr.w	LoadChildObject
	lea	(ObjC5_RobotnikData).l,a2
	bsr.w	LoadChildObject
	move.w	#$5A,WFZCountDown(a0)	; How long for the boss music to start playing and the boss to start
	moveq	#MusID_FadeOut,d0
	jsrto	(PlaySound).l, JmpTo12_PlaySound
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite

; ===========================================================================

ObjC5_CaseWaitDown:
	subq.w	#1,WFZCountDown(a0)
	bmi.s	ObjC5_CaseSpeedDown
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseSpeedDown:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$60,WFZCountDown(a0)	; How long the laser carrier goes down
	moveq	#MusID_Boss,d0
	jsrto	(PlayMusic).l, JmpTo5_PlayMusic
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseDown:
	subq.w	#1,WFZCountDown(a0)
	beq.s	ObjC5_CaseStopDown
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStopDown:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	clr.w	y_vel(a0)		; stop the laser carrier from going down
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseXSpeed:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	bsr.w	Obj_GetOrientationToPlayer
	move.w	#$100,d1		; Speed of carrier (when going back and forth before sending out laser)
	tst.w	d0
	bne.s	ObjC5_CasePMLoader
	neg.w	d1

ObjC5_CasePMLoader:
	move.w	d1,x_vel(a0)
	bset	#2,status(a0)		; makes the platform maker load
	move.w	#$70,WFZCountDown(a0)	; how long to go back and forth before letting out laser
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseBoundaryChk:			; waits and makes sure the carrier does not go beyond the limit
	subq.w	#1,WFZCountDown(a0)
	bmi.s	ObjC5_CaseOpeningAnim
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjC5_CaseBoundaryChk2
	cmp.w	Max_RightVarable(a0),d0
	bhs.s	ObjC5_CaseNegSpeed
	bra.w	ObjC5_CaseMoveDisplay
; ===========================================================================

ObjC5_CaseBoundaryChk2:
	cmp.w	Max_LeftVarable(a0),d0
	bhs.s	ObjC5_CaseMoveDisplay

ObjC5_CaseNegSpeed:
	neg.w	x_vel(a0)

ObjC5_CaseMoveDisplay:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseOpeningAnim:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	clr.b	anim(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseAnimate:
	lea	(Ani_objC5).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
; routines to set to the red case that beeps and shoots
ObjC5_CaseLSLoad:		; loads up the laser shooter (LS)

	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$E,WFZCountDown(a0)	; Time the laser shooter moves down
	movea.w	parent_LaerShooters(a0),a1 ; a1=object (laser shooter)
	move.b	#4,SecondRoutine_WFZBoss(a1)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSDown:

	subq.w	#1,WFZCountDown(a0)
	beq.s	ObjC5_CaseAddCollision
	movea.w	parent_LaerShooters(a0),a1 ; a1=object (laser shooter)
	addq.w	#1,y_pos(a1)	; laser shooter down speed
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseAddCollision:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$40,WFZCountDown(a0)	; Length before shooting laser
	bset	#4,status(a0)		; makes the hit sound and flashes happen only once when you hit it
	bset	#6,status(a0)		; makes sure collision gets restored
	move.b	#6,collision_flags(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitLoadLaser:
	subq.w	#1,WFZCountDown(a0)
	bmi.s	ObjC5_CaseLoadLaser
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLoadLaser:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	lea	(ObjC5_LaserData).l,a2
	bsr.w	LoadChildObject		; loads laser
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseWaitMove:
	movea.w	WFZParentCustomize(a0),a1 ; a1=object
	btst	#2,status(a1)		; waits to check if laser fired
	bne.s	ObjC5_CaseLaserSpeed
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLaserSpeed:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$80,WFZCountDown(a0)	; how long to move the laser
	bsr.w	Obj_GetOrientationToPlayer	; tests if sonic is to the right or left
	move.w	#$80,d1		; Speed when moving with laser
	tst.w	d0
	bne.s	ObjC5_CaseLaserSpeedSet
	neg.w	d1

ObjC5_CaseLaserSpeedSet:
	move.w	d1,x_vel(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseBoundaryLaserChk:		; make sure you stay in range when firing laser
	subq.w	#1,WFZCountDown(a0)
	bmi.s	ObjC5_CaseStopLaserDelete
	move.w	x_pos(a0),d0
	tst.w	x_vel(a0)
	bmi.s	ObjC5_CaseBoundaryLaserChk2
	cmp.w	Max_RightVarable(a0),d0
	bhs.s	ObjC5_CaseLaserStopMove
	bra.w	ObjC5_CaseLaserMoveDisplay
; ===========================================================================

ObjC5_CaseBoundaryLaserChk2:
	cmp.w	Max_LeftVarable(a0),d0
	bhs.s	ObjC5_CaseLaserMoveDisplay

ObjC5_CaseLaserStopMove:
	clr.w	x_vel(a0)	; stop moving

ObjC5_CaseLaserMoveDisplay:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStopLaserDelete:		; stops collision and deletes laser
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$E,WFZCountDown(a0)	; time for laser shooter to move back up
	bclr	#3,status(a0)
	bclr	#4,status(a0)
	bclr	#6,status(a0)
	clr.b	collision_flags(a0)	; no more collision
	movea.w	WFZParentCustomize(a0),a1 		; a1=object (laser)
	jsrto	(DeleteObject2).l, JmpTo6_DeleteObject2	; delete the laser
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseLSUp:
	subq.w	#1,WFZCountDown(a0)
	beq.s	ObjC5_CaseClosingAnim
	movea.w	parent_LaerShooters(a0),a1 ; a1=object (laser shooter)
	subq.w	#1,y_pos(a1)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseClosingAnim: ;sets which animation to do
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#1,anim(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseStartOver:
	move.b	#8,SecondRoutine_WFZBoss(a0)
	bsr.w	ObjC5_CaseXSpeed
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_CaseDefeated:
	clr.b	collision_flags(a0)
	st	collision_property(a0)
	bclr	#6,status(a0)
	subq.w	#1,HitCount_WFZ(a0)	; timer
	bmi.s	ObjC5_End
	jsrto	(Boss_LoadExplosion).l, JmpTo_Boss_LoadExplosion
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_End:	; play music and change camera speed
	moveq	#MusID_WFZ,d0
	jsrto	(PlayMusic).l, JmpTo5_PlayMusic
	move.w	#$720,d0
	move.w	d0,(Camera_Max_Y_pos_now).w
	move.w	d0,(Camera_Max_Y_pos).w
	bsr.w	JmpTo65_DeleteObject
	addq.w	#4,sp
	rts
; ===========================================================================

ObjC5_LaserWall:
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_LaserWallIndex(pc,d0.w),d1
	jsr	ObjC5_LaserWallIndex(pc,d1.w)
	tst.l	(a0)  ; is the object alive ?
	beq.w	return_37A48   ; if yea then stop collsion
	move.w	x_pos(a0),-(sp)
	move.w	#$13,d1
	move.w	#$40,d2
	move.w	#$80,d3
	move.w	(sp)+,d4
	jmpto	(SolidObject).l, JmpTo27_SolidObject
; ===========================================================================
ObjC5_LaserWallIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserWallMappings	; 0 - selects the mappings
	offsetTableEntry.w ObjC5_LaserWallWaitDelete	; 2 - Waits till set to delete (when the boss is defeated)
	offsetTableEntry.w ObjC5_LaserWallDelete	; 4 - After a little time it deletes
; ===========================================================================

ObjC5_LaserWallMappings:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#$C,mapping_frame(a0)	; loads the laser wall from the WFZ boss art
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallWaitDelete:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.s	ObjC5_LaserWallTimerSet
	bchg	#0,WFZFlickerVarable(a0)	; makes it "flash" if set it won't flash
	bne.w	return_37A48
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallTimerSet:	; sets a small timer
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#4,HitCount_WFZ(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_LaserWallDelete:
	subq.b	#1,anim_frame_duration(a0)
	bpl.w	return_37A48
	move.b	anim_frame_duration(a0),d0
	move.b	anim_frame(a0),d1
	addq.b	#2,d0
	bpl.s	ObjC5_LaserWallDisplay
	move.b	d1,anim_frame_duration(a0)
	subq.b	#1,HitCount_WFZ(a0)
	bpl.s	ObjC5_LaserWallDisplay
	move.b	#$10,HitCount_WFZ(a0)
	addq.b	#1,d1
	cmpi.b	#5,d1
	bhs.w	JmpTo65_DeleteObject
	move.b	d1,anim_frame(a0)
	move.b	d1,anim_frame_duration(a0)

ObjC5_LaserWallDisplay:
	bclr	#0,WFZFlickerVarable(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaser:
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_PlatformReleaserIndex(pc,d0.w),d1
	jmp	ObjC5_PlatformReleaserIndex(pc,d1.w)
; ===========================================================================
ObjC5_PlatformReleaserIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformReleaserInit		; 0 - Load mappings and position
	offsetTableEntry.w ObjC5_PlatformReleaserWaitDown	; 2 - Waits for laser case to move down
	offsetTableEntry.w ObjC5_PlatformReleaserDown		; 4 - Goes down until time limit is up
	offsetTableEntry.w ObjC5_PlatformReleaserLoadWait	; 6 - Waits to load the platforms (the interval of time between each is from this) and makes sure only 3 are loaded
	offsetTableEntry.w ObjC5_PlatformReleaserDelete		; 8 - Explodes then deletes
; ===========================================================================

ObjC5_PlatformReleaserInit:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#5,mapping_frame(a0)
	addq.w	#8,y_pos(a0)		; Move down a little
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserWaitDown:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object laser case
	btst	#2,status(a1)		; checks if laser case is done moving down (so it starts loading the platforms)
	bne.s	ObjC5_PlatformReleaserSetDown
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserSetDown:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$40,WFZCountDown(a0)	; time to go down
	move.w	#$40,y_vel(a0)		; speed to go down
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDown:
	subq.w	#1,WFZCountDown(a0)
	beq.s	ObjC5_PlatformReleaserStop
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserStop:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	clr.w	y_vel(a0)
	move.w	#$10,WFZCountDown(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserLoadWait:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.s	ObjC5_PlatformReleaserDestroyP
	subq.w	#1,WFZCountDown(a0)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	move.w	#$80,WFZCountDown(a0)	; Time between loading platforms
	moveq	#0,d0
	move.b	WFZBoss_ShootOut(a0),d0
	addq.b	#1,d0
	cmpi.b	#3,d0			; How many platforms to load
	blo.s	ObjC5_PlatformReleaserLoadP
	moveq	#0,d0

ObjC5_PlatformReleaserLoadP:	; P=Platforms
	move.b	d0,WFZBoss_ShootOut(a0)
	tst.b	HitCount_WFZ(a0,d0.w)
	bne.s	BranchTo8_JmpTo45_DisplaySprite
	st	HitCount_WFZ(a0,d0.w)
	lea	(ObjC5_PlatformData).l,a2
	bsr.w	LoadChildObject
	move.b	WFZBoss_ShootOut(a0),WFZBoss_ShootOut(a1)

BranchTo8_JmpTo45_DisplaySprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDestroyP: 	; P=Platforms
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	bset	#5,status(a0)		; destroy platforms
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_PlatformReleaserDelete:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object
	cmpi.l	#ObjC5,(a1)
	bne.w	JmpTo65_DeleteObject
	jsrto	(Boss_LoadExplosion).l, JmpTo_Boss_LoadExplosion
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_Platform:
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_PlatformIndex(pc,d0.w),d1
	jsr	ObjC5_PlatformIndex(pc,d1.w)
	lea	(Ani_objC5).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	tst.l	(a0)
	beq.w	return_37A48
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
ObjC5_PlatformIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformInit			; 0 - Selects mappings, anim ation, y speed and loads the object that hurts sonic (by spiky area)
	offsetTableEntry.w ObjC5_PlatformDownWait		; 2 - Wait till the platform goes down some
	offsetTableEntry.w ObjC5_PlatformTestChangeDirection	; 4 - checks if time limit is over and if so to change direction
; ===========================================================================

ObjC5_PlatformInit:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#3,anim(a0)
	move.b	#7,mapping_frame(a0)
	move.w	#$100,y_vel(a0)			; Y speed
	move.w	#$60,WFZCountDown(a0)
	lea	(ObjC5_PlatformHurtData).l,a2	; loads the invisible object that hurts sonic
	bra.w	LoadChildObject

; ===========================================================================

ObjC5_PlatformDownWait:		; waits for it to go down some
	bsr.w	ObjC5_PlatformCheckExplode
	subq.w	#1,WFZCountDown(a0)
	beq.s	ObjC5_PlatformLeft
	bra.w	ObjC5_PlatformMakeSolid
; ===========================================================================

ObjC5_PlatformLeft:			; goes left and makes a time limit (for going left)
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$60,WFZCountDown(a0)
	move.w	#-$100,x_vel(a0)		; X speed
	move.w	y_pos(a0),Max_LeftVarable(a0)
	bra.w	ObjC5_PlatformMakeSolid
; ===========================================================================

ObjC5_PlatformTestChangeDirection:
	bsr.w	ObjC5_PlatformCheckExplode
	subq.w	#1,WFZCountDown(a0)
	bne.s	ObjC5_PlatformTestLeftRight
	move.w	#$C0,WFZCountDown(a0)
	neg.w	x_vel(a0)

ObjC5_PlatformTestLeftRight:	; tests to see if a value should be added to go left or right
	moveq	#4,d0
	move.w	y_pos(a0),d1
	cmp.w	Max_LeftVarable(a0),d1
	blo.s	ObjC5_PlatformChangeY
	neg.w	d0

ObjC5_PlatformChangeY:	; give it that curving feel
	add.w	d0,y_vel(a0)
	bra.w	ObjC5_PlatformMakeSolid

ObjC5_PlatformMakeSolid:	; makes into a platform and moves
	move.w	x_pos(a0),-(sp)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	move.w	#$10,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	(PlatformObject).l, JmpTo9_PlatformObject
; ===========================================================================

ObjC5_PlatformCheckExplode:	; checks to see if platforms should explode
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.w	ObjC5_PlatformExplode
	rts
; ===========================================================================

ObjC5_PlatformExplode:
	bsr.w	loc_3B7BC
	move.l	#Obj58,(a0) ; load 0bj58 (explosion)
	clr.b	routine(a0)
	movea.w	parent_LaerShooters(a0),a1 ; a1=object (invisible hurting thing)
	jsrto	(DeleteObject2).l, JmpTo6_DeleteObject2
	addq.w	#4,sp
	rts
; ===========================================================================

ObjC5_PlatformHurt:
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_PlatformHurtIndex(pc,d0.w),d1
	jmp	ObjC5_PlatformHurtIndex(pc,d1.w)
; ===========================================================================
ObjC5_PlatformHurtIndex: offsetTable
	offsetTableEntry.w ObjC5_PlatformHurtCollision		; 0 - Gives collision that hurts sonic
	offsetTableEntry.w ObjC5_PlatformHurtFollowPlatform	; 2 - Follows around the platform and waits to be deleted
; ===========================================================================

ObjC5_PlatformHurtCollision:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#$98,collision_flags(a0)
	rts
; ===========================================================================

ObjC5_PlatformHurtFollowPlatform:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object (platform)
	btst	#5,status(a1)
	bne.w	JmpTo65_DeleteObject
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),d0
	addi.w	#$C,d0
	move.w	d0,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserShooter:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object (laser case)
	btst	#5,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_LaserShooterIndex(pc,d0.w),d1
	jmp	ObjC5_LaserShooterIndex(pc,d1.w)
; ===========================================================================
ObjC5_LaserShooterIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserShooterInit	; 0 - Loads up mappings
	offsetTableEntry.w ObjC5_LaserShooterFollow	; 2 - Goes back and forth with the laser case
	offsetTableEntry.w ObjC5_LaserShooterDown	; 4 - Laser case sets it to this routine which then makes it go down
; ===========================================================================

ObjC5_LaserShooterInit:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#4,mapping_frame(a0)
	jmp	(DisplaySprite).l
; ===========================================================================

ObjC5_LaserShooterFollow:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object (laser case)

	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	jmp	(DisplaySprite).l
; ===========================================================================

ObjC5_LaserShooterDown:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object (laser case)
	move.w	x_pos(a1),x_pos(a0)
	jmp	(DisplaySprite).l
; ===========================================================================
;------------------------------------------------------------------
;  laser wall ig orrrrrrr
;------------------------------------------------------------------
ObjC5_Laser:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object
	btst	#5,status(a1)
	bne.w	JmpTo65_DeleteObject
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_LaserIndex(pc,d0.w),d1
	jsr	ObjC5_LaserIndex(pc,d1.w)
	bchg	#0,WFZFlickerVarable(a0)
	bne.w	return_37A48
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
ObjC5_LaserIndex: offsetTable
	offsetTableEntry.w ObjC5_LaserInit	; 0 - Loads mappings and collision and such
	offsetTableEntry.w ObjC5_LaserFlash	; 2 - Makes the laser flash (gives the charging up effect)
	offsetTableEntry.w ObjC5_LaseWaitShoot	; 4 - Waits a little to launch the laser when it's done flickering (charging)
	offsetTableEntry.w ObjC5_LaserShoot	; 6 - Shoots down the laser untill it's fully shot out
	offsetTableEntry.w ObjC5_LaserMove	; 8 - Moves with laser case and shooter
; ===========================================================================

ObjC5_LaserInit:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#$D,mapping_frame(a0)
	move.b	#4,priority(a0)
	move.b	#0,collision_flags(a0)
	addi.w	#$10,y_pos(a0)
	move.b	#$C,anim_frame(a0)
	subq.w	#3,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserFlash:
	bset	#0,WFZFlickerVarable(a0)
	subq.b	#1,anim_frame_duration(a0)
	bpl.s	ObjC5_LaserNoLaser
	move.b	anim_frame_duration(a0),d0
	addq.b	#2,d0
	bpl.s	ObjC5_LaserFlicker
	move.b	anim_frame(a0),d0
	subq.b	#1,d0
	beq.s	ObjC5_LaseNext
	move.b	d0,anim_frame(a0)
	move.b	d0,anim_frame_duration(a0)

ObjC5_LaserFlicker:	; this is what makes the laser flicker before being fully loaded (covering laser shooter)
	bclr	#0,WFZFlickerVarable(a0)

ObjC5_LaserNoLaser: ; without this the laser would just stay on the shooter not going down
	rts
; ===========================================================================

ObjC5_LaseNext:		; just sets up a time to wait for the laser to shoot when it's loaded and done flickering
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$40,WFZCountDown(a0)
	rts
; ===========================================================================

ObjC5_LaseWaitShoot:
	subq.w	#1,WFZCountDown(a0)
	bmi.s	ObjC5_LaseStartShooting
	rts
; ===========================================================================

ObjC5_LaseStartShooting:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	addi.w	#$10,y_pos(a0)
	rts
; ===========================================================================

ObjC5_LaserShoot:
	moveq	#0,d0
	move.b	WFZBoss_ShootOut(a0),d0
	addq.b	#1,d0
	cmpi.b	#5,d0
	bhs.s	ObjC5_LaseShotOut
	addi.w	#$10,y_pos(a0)
	move.b	d0,WFZBoss_ShootOut(a0)
	move.b	ObjC5_LaserMappingsData(pc,d0.w),mapping_frame(a0)
	move.b	ObjC5_LaserCollisionData(pc,d0.w),collision_flags(a0)
	rts
; ===========================================================================

ObjC5_LaseShotOut:	; laser is fully shot out and lets the laser case know so it moves
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$80,WFZCountDown(a0)
	bset	#2,status(a0)
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object (laser case)
	bset	#3,status(a1)
	rts
; ===========================================================================
ObjC5_LaserMappingsData:
	dc.b  $E
	dc.b  $F	; 1
	dc.b $10	; 2
	dc.b $11	; 3
	dc.b $12	; 4
	dc.b   0	; 5
ObjC5_LaserCollisionData:
	dc.b $86
	dc.b $AB	; 1
	dc.b $AC	; 2
	dc.b $AD	; 3
	dc.b $AE	; 4
	dc.b   0	; 5
; ===========================================================================

ObjC5_LaserMove:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object
	move.w	x_pos(a1),x_pos(a0)
	rts
; ===========================================================================

ObjC5_Robotnik:
	moveq	#0,d0
	move.b	SecondRoutine_WFZBoss(a0),d0
	move.w	ObjC5_RobotnikIndex(pc,d0.w),d1
	jmp	ObjC5_RobotnikIndex(pc,d1.w)
; ===========================================================================
ObjC5_RobotnikIndex: offsetTable
	offsetTableEntry.w ObjC5_RobotnikInit		; 0 - Loads art, animation and position
	offsetTableEntry.w ObjC5_RobotnikAnimate	; 2 - Animates Robotnik and waits till the case is defeated
	offsetTableEntry.w ObjC5_RobotnikDown		; 4 - Goes down until timer is up
; ===========================================================================

ObjC5_RobotnikInit:
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.b	#0,mapping_frame(a0)
	move.b	#1,anim(a0)
	move.w	#$2C60,x_pos(a0)
	move.w	#$4E6,y_pos(a0)
	lea	(ObjC5_RobotnikPlatformData).l,a2
	bsr.w	LoadChildObject
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikAnimate:
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object (laser case)
	btst	#5,status(a1)
	bne.s	ObjC5_RobotnikTimer
	lea	(Ani_objC5_objC6).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikTimer:		; Increase routine and set timer
	addq.b	#2,SecondRoutine_WFZBoss(a0)
	move.w	#$C0,WFZCountDown(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikDown:
	subq.w	#1,WFZCountDown(a0)
	bmi.s	ObjC5_RobotnikDelete
	addq.w	#1,y_pos(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================

ObjC5_RobotnikDelete:		; Deletes robotnik and the platform he's on
	movea.w	WFZParentCustomize(a0),a1 ; a1=object (Robotnik Platform)
	jsrto	(DeleteObject2).l, JmpTo6_DeleteObject2
	bra.w	JmpTo65_DeleteObject
; ===========================================================================

ObjC5_RobotnikPlatform:	; Just displays the platform and move accordingly to the robotnik object
	movea.w	Child_Refrence_WFZ(a0),a1 ; a1=object (robotnik)
	move.w	y_pos(a1),d0
	addi.w	#$26,d0
	move.w	d0,y_pos(a0)
	jmpto	(DisplaySprite).l, JmpTo45_DisplaySprite
; ===========================================================================
	; some unused/dead code, At one point it appears a section of the platform was solid
	move.w	x_pos(a0),-(sp)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	move.w	#$F,d1
	move.w	#8,d2
	move.w	#8,d3
	move.w	(sp)+,d4
	jmpto	(PlatformObject).l, JmpTo9_PlatformObject
; ===========================================================================

ObjC5_HandleHits:
	tst.b	collision_property(a0)
	beq.s	ObjC5_NoHitPointsLeft
	tst.b	collision_flags(a0)
	bne.s	return_3CC3A
	tst.b	HitCount_WFZ(a0)
	bne.s	ObjC5_FlashSetUp
	btst	#6,status(a0)
	beq.s	return_3CC3A
	move.b	#$20,HitCount_WFZ(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l

ObjC5_FlashSetUp:
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	ObjC5_FlashCollisionRestore
	move.w	#$EEE,d0

ObjC5_FlashCollisionRestore:
	move.w	d0,(a1)
	subq.b	#1,HitCount_WFZ(a0)
	bne.s	return_3CC3A
	btst	#4,status(a0)	; makes sure the boss doesn't need collision
	beq.s	return_3CC3A
	move.b	#6,collision_flags(a0)	; restore collision

return_3CC3A:
	rts
; ===========================================================================

ObjC5_NoHitPointsLeft:	; when the boss is defeated this tells it what to do
	moveq	#100,d0
	jsr	AddPoints
	clr.b	collision_flags(a0)
	move.w	#$EF,HitCount_WFZ(a0)
	move.b	#$1E,SecondRoutine_WFZBoss(a0)
	bset	#5,status(a0)
	bclr	#6,status(a0)
	rts
; ===========================================================================
ObjC5_LaserWallData:
	dc.w WFZ_BossParent
	dc.l ObjC5
	dc.b $94
	even
ObjC5_PlatformData:
	dc.w WFZParentCustomize
	dc.l ObjC5
	dc.b $98
	even
ObjC5_PlatformHurtData:
	dc.w parent_LaerShooters
	dc.l ObjC5
	dc.b $9A
	even
ObjC5_LaserShooterData:
	dc.w parent_LaerShooters
	dc.l ObjC5
	dc.b $9C
	even
ObjC5_PlatformReleaserData:
	dc.w Small_PlatformsParent
	dc.l ObjC5
	dc.b $96
	even
ObjC5_LaserData:
	dc.w WFZParentCustomize
	dc.l ObjC5
	dc.b $9E
	even
ObjC5_RobotnikData:
	dc.w RobotnickParentAddr
	dc.l ObjC5
	dc.b $A0
	even
ObjC5_RobotnikPlatformData:
	dc.w WFZParentCustomize
	dc.l ObjC5
	dc.b $A2
        even
; off_3CC80:
ObjC5_SubObjData:		; Laser Case
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),4,4,$20,0
; off_3CC8A:
ObjC5_SubObjData2:		; Laser Walls
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),4,1,8,0
; off_3CC94:
ObjC5_SubObjData3:		; Platforms, platform releaser, laser and laser shooter
	subObjData ObjC5_MapUnc_3CCD8,make_art_tile(ArtTile_ArtNem_WFZBoss,0,0),4,5,$10,0
; off_3CC9E:
ObjC6_SubObjData2:		; Robotnik
	subObjData ObjC6_MapUnc_3D0EE,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,5,$20,0
; off_3CCA8:
ObjC5_SubObjData4:		; Robotnik platform
	subObjData ObjC5_MapUnc_3CEBC,make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1),4,5,$20,0

; animation script
; off_3CCB2:
Ani_objC5:	offsetTable
		offsetTableEntry.w byte_3CCBA	; 0
		offsetTableEntry.w byte_3CCC4	; 1
		offsetTableEntry.w byte_3CCCC	; 2
		offsetTableEntry.w byte_3CCD0	; 3
byte_3CCBA:	dc.b   5,  0,  1,  2,  3,  3,  3,  3,$FA,  0
byte_3CCC4:	dc.b   3,  3,  2,  1,  0,  0,$FA,  0
byte_3CCCC:	dc.b   3,  5,  6,$FF
byte_3CCD0:	dc.b   3,  7,  8,  9, $A, $B,$FF
		even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC5_MapUnc_3CCD8:	BINCLUDE "mappings/sprite/objC5_a.bin"
           even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
ObjC5_MapUnc_3CEBC:	BINCLUDE "mappings/sprite/objC5_b.bin"
                  even
