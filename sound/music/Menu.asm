Snd_Menu_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice	SaveScreenVoices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $40

	smpsHeaderDAC       Snd_Menu_DAC
	smpsHeaderFM        Snd_Menu_FM1,	$0C, $12
	smpsHeaderFM        Snd_Menu_FM2,	$0C, $19
	smpsHeaderFM        Snd_Menu_FM3,	$0C, $19
	smpsHeaderFM        Snd_Menu_FM4,	$0C, $19
	smpsHeaderFM        Snd_Menu_FM5,	$0C, $19
	smpsHeaderPSG       Snd_Menu_PSG1,	$00, $06, $00, fTone_0C
	smpsHeaderPSG       Snd_Menu_PSG2,	$00, $06, $00, fTone_0C
	smpsHeaderPSG       Snd_Menu_PSG3,	$00, $04, $00, fTone_0C


Snd_Menu_DAC:
	dc.b	dKick, $12
	dc.b	dSnare, $12
	dc.b	dClap, $12
	dc.b	dScratch, $12
	dc.b	dTimpani, $12*2
	dc.b	dHiTom, $12
	dc.b	dVLowClap, $12
	dc.b	dHiTimpani, $12*2
	dc.b	dMidTimpani, $12*2
	dc.b	dLowTimpani, $12*2
	dc.b	dVLowTimpani, $12*2
	dc.b	dMidTom, $12
	dc.b	dLowTom, $12
	dc.b	dFloorTom, $12
	dc.b	dHiClap, $12
	dc.b	dMidClap, $12
	dc.b	dLowClap, $12
	dc.b	dCrash, $12
	dc.b	dRide, $12*2
	dc.b	dCupCym, $12*2
	dc.b	dClave, $12
	dc.b	dChina, $12*2
	dc.b	dRim, $12
	dc.b	dTimable, $12
	dc.b	dLowTimbale, $12
	dc.b	dCngSlp, $12
	dc.b	dCowbell, $12
	dc.b	dTamb, $12
	dc.b	dAgogo, $12
	dc.b	dLowAgogo, $12
	dc.b	dShaker, $12
	dc.b	dKick2, $12
	dc.b	dSnare1, $12
	dc.b	dSnare3, $12
; FM1 Data
Snd_Menu_FM1:
; FM2 Data
Snd_Menu_FM2:
; FM3 Data
Snd_Menu_FM3:
; FM4 Data
Snd_Menu_FM4:
; FM5 Data
Snd_Menu_FM5:
; PSG1 Data
Snd_Menu_PSG1:
; PSG2 Data
Snd_Menu_PSG2:
; PSG3 Data
Snd_Menu_PSG3:
	smpsStop

SaveScreenVoices:
