; ===========================================================================
; loc_3A2:
GameModesArray: ;;
GameMode_SegaScreen:	dc.l	SegaScreen		; SEGA screen mode
GameMode_TitleScreen:	dc.l	TitleScreen		; Title screen mode
GameMode_Demo:		dc.l	Level			; Demo mode
GameMode_Level:		dc.l	Level			; Zone play mode
GameMode_SpecialStage:	dc.l	SpecialStage		; Special stage play mode
GameMode_ContinueScreen:dc.l	ContinueScreen		; Continue mode
GameMode_2PResults:	dc.l	TwoPlayerResults	; 2P results mode
GameMode_2PLevelSelect:	dc.l	LevelSelectMenu2P	; 2P level select mode
GameMode_EndingSequence:dc.l	JmpTo_EndingSequence	; End sequence mode
GameMode_OptionsMenu:	dc.l	OptionsMenu		; Options mode
GameMode_LevelSelect:	dc.l	LevelSelectMenu		; Level select mode
GameMode_save_screen:	dc.l	s3_save_screen
; ===========================================================================
    if skipChecksumCheck=0	; checksum error code
; loc_3CE:
ChecksumError:
	move.l	d1,-(sp)
	bsr.w	VDPSetupGame
	move.l	(sp)+,d1
	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l ; set VDP to CRAM write
	moveq	#$3F,d7
; loc_3E2:
Checksum_Red:
	move.w	#$E,(VDP_data_port).l ; fill palette with red
	dbf	d7,Checksum_Red	; repeat $3F more times
; loc_3EE:
ChecksumFailed_Loop:
	bra.s	ChecksumFailed_Loop
    endif
; ===========================================================================
; loc_3F0:
LevelSelectMenu2P: ;;
	jmp	(MenuScreen).l
; ===========================================================================
; loc_3F6:
JmpTo_EndingSequence ; JmpTo
	jmp	(EndingSequence).l
; ===========================================================================
; loc_3FC:
OptionsMenu: ;;
	jmp	(MenuScreen).l
; ===========================================================================
; loc_402:
LevelSelectMenu: ;;
	jmp	(MenuScreen).l
; ===========================================================================
