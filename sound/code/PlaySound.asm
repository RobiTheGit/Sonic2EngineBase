
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; JumpTo load the sound driver
; sub_130A:
JmpTo_SoundDriverLoad ; JmpTo
	nop
	jmp	(SoundDriverLoad).l
; End of function JmpTo_SoundDriverLoad

; ===========================================================================
; unused mostly-leftover subroutine to load the sound driver
; SoundDriverLoadS1:
	move.w	#$100,(Z80_Bus_Request).l ; stop the Z80
	move.w	#$100,(Z80_Reset).l ; reset the Z80
	lea	(Z80_RAM).l,a1
	move.b	#$F3,(a1)+	; di
	move.b	#$F3,(a1)+	; di
	move.b	#$C3,(a1)+	; jp
	move.b	#0,(a1)+	; jp address low byte
	move.b	#0,(a1)+	; jp address high byte
	move.w	#0,(Z80_Reset).l
	nop
	nop
	nop
	nop
	move.w	#$100,(Z80_Reset).l ; reset the Z80
	move.w	#0,(Z80_Bus_Request).l ; start the Z80
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; If Music_to_play is clear, move d0 into Music_to_play,
; else move d0 into Music_to_play_2.
; sub_135E:
PlayMusic:
	stopZ80
	move.b	d0,(Z80_RAM+zAbsVar.SFXToPlay).l
	startZ80
	rts
; End of function PlayMusic


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1370
Play_Sound:
Play_Sound_2:
PlaySound:
	stopZ80
	move.b	d0,(Z80_RAM+zAbsVar.SFXUnknown).l
	startZ80
	rts
; End of function PlaySound


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; play a sound in alternating speakers (as in the ring collection sound)
; sub_1376:
PlaySoundStereo:
	stopZ80
	move.b	d0,(Z80_RAM+zAbsVar.SFXStereoToPlay).l
	startZ80
	rts
; End of function PlaySoundStereo


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; play a sound if the source is onscreen
; sub_137C:
PlaySoundLocal:
	tst.b	render_flags(a0)
	bpl.s	+	; rts
	stopZ80
	move.b	d0,(Z80_RAM+zAbsVar.SFXToPlay).l
	startZ80
+
	rts
; End of function PlaySoundLocal
