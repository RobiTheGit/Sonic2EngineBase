; =============================================================================================
; Created by Flamewing, based on S1SMPS2ASM version 1.1 by Marc Gordon (AKA Cinossu)
; =============================================================================================

; ---------------------------------------------------------------------------------------------
; Standard Octave Pitch Equates
	enum smpsPitch10lo=$88,smpsPitch09lo=$94,smpsPitch08lo=$A0,smpsPitch07lo=$AC,smpsPitch06lo=$B8
	enum smpsPitch05lo=$C4,smpsPitch04lo=$D0,smpsPitch03lo=$DC,smpsPitch02lo=$E8,smpsPitch01lo=$F4
	enum smpsPitch00=$00,smpsPitch01hi=$0C,smpsPitch02hi=$18,smpsPitch03hi=$24,smpsPitch04hi=$30
	enum smpsPitch05hi=$3C,smpsPitch06hi=$48,smpsPitch07hi=$54,smpsPitch08hi=$60,smpsPitch09hi=$6C
	enum smpsPitch10hi=$78

; ---------------------------------------------------------------------------------------------
; Note Equates
	enum nRst=$80+0,nC0,nCs0,nD0,nEb0,nE0,nF0,nFs0,nG0,nAb0,nA0,nBb0,nB0,nC1,nCs1,nD1
	enum nEb1=nD1+1,nE1,nF1,nFs1,nG1,nAb1,nA1,nBb1,nB1,nC2,nCs2,nD2,nEb2,nE2,nF2,nFs2
	enum nG2=nFs2+1,nAb2,nA2,nBb2,nB2,nC3,nCs3,nD3,nEb3,nE3,nF3,nFs3,nG3,nAb3,nA3,nBb3
	enum nB3=nBb3+1,nC4,nCs4,nD4,nEb4,nE4,nF4,nFs4,nG4,nAb4,nA4,nBb4,nB4,nC5,nCs5,nD5
	enum nEb5=nD5+1,nE5,nF5,nFs5,nG5,nAb5,nA5,nBb5,nB5,nC6,nCs6,nD6,nEb6,nE6,nF6,nFs6
	enum nG6=nFs6+1,nAb6,nA6,nBb6,nB6,nC7,nCs7,nD7,nEb7,nE7,nF7,nFs7,nG7,nAb7,nA7,nBb7
	if SonicDriverVer<=2
nMaxPSG				EQU nA5
nMaxPSG1			EQU nA5+psgdelta
nMaxPSG2			EQU nA5+psgdelta
	else
nMaxPSG				EQU nBb6-psgdelta
nMaxPSG1			EQU nBb6
nMaxPSG2			EQU nB6
	endif
; ---------------------------------------------------------------------------------------------
; PSG flutter equates
	if SonicDriverVer==1
		enum fTone_01=$01,fTone_02,fTone_03,fTone_04,fTone_05,fTone_06
		enum fTone_07=fTone_06+1,fTone_08,fTone_09
	elseif SonicDriverVer==2
		enum fTone_01=$01,fTone_02,fTone_03,fTone_04,fTone_05,fTone_06
		enum fTone_07=fTone_06+1,fTone_08,fTone_09,fTone_0A,fTone_0B,fTone_0C
		enum fTone_0D=fTone_0C+1
	else
		enum sTone_01=$01,sTone_02,sTone_03,sTone_04,sTone_05,sTone_06
		enum sTone_07=sTone_06+1,sTone_08,sTone_09,sTone_0A,sTone_0B,sTone_0C
		enum sTone_0D=sTone_0C+1,sTone_0E,sTone_0F,sTone_10,sTone_11,sTone_12
		enum sTone_13=sTone_12+1,sTone_14,sTone_15,sTone_16,sTone_17,sTone_18
		enum sTone_19=sTone_18+1,sTone_1A,sTone_1B,sTone_1C,sTone_1D,sTone_1E
		enum sTone_1F=sTone_1E+1,sTone_20,sTone_21,sTone_22,sTone_23,sTone_24
		enum sTone_25=sTone_24+1,sTone_26,sTone_27
		; For conversions:
		if SonicDriverVer==5
			enum fTone_01=$28,fTone_02,fTone_03,fTone_04,fTone_05,fTone_06
			enum fTone_07=fTone_06+1,fTone_08,fTone_09,fTone_0A,fTone_0B,fTone_0C
			enum fTone_0D=fTone_0C+1
		endif
	endif

; ---------------------------------------------------------------------------------------------
; DAC Equates

		enum dKick=$81,dSnare,dClap,dScratch,dTimpani,dHiTom,dVLowClap,dHiTimpani,dMidTimpani
		enum dLowTimpani=dMidTimpani+1,dVLowTimpani,dMidTom,dLowTom,dFloorTom,dHiClap
		enum dMidClap=dHiClap+1,dLowClap,dCrash,dRide,dCupCym,dClave,dChina
		enum dRim=dChina+1,dTimable,dLowTimbale,dCngSlp,dCowbell,dTamb,dAgogo,dLowAgogo
		enum dShaker=dLowAgogo+1,dKick2,dSnare1,dSnare3

; ---------------------------------------------------------------------------------------------
; Channel IDs for SFX
cPSG1				EQU $80
cPSG2				EQU $A0
cPSG3				EQU $C0
cNoise				EQU $E0	; Not for use in S3/S&K/S3D
cFM3				EQU $02
cFM4				EQU $04
cFM5				EQU $05
cFM6				EQU $06	; Only in S3/S&K/S3D, overrides DAC

; ---------------------------------------------------------------------------------------------
; Conversion macros and functions

conv0To256  function n,((n==0)<<8)|n
s2TempotoS1 function n,(((768-n)>>1)/(256-n))&$FF
s2TempotoS3 function n,($100-((n==0)|n))&$FF
s1TempotoS2 function n,((((conv0To256(n)-1)<<8)+(conv0To256(n)>>1))/conv0To256(n))&$FF
s1TempotoS3 function n,s2TempotoS3(s1TempotoS2(n))
s3TempotoS1 function n,s2TempotoS1(s2TempotoS3(n))
s3TempotoS2 function n,s2TempotoS3(n)

convertMainTempoMod macro mod
	if ((SourceDriver>=3)&&(SonicDriverVer>=3))||(SonicDriverVer==SourceDriver)
		dc.b	mod
	elseif SourceDriver==1
		if mod==1
			fatal "Invalid main tempo of 1 in song from Sonic 1"
		endif
		if SonicDriverVer==2
			dc.b	s1TempotoS2(mod)
		else;if SonicDriverVer>=3
			dc.b	s1TempotoS3(mod)
		endif
	elseif SourceDriver==2
		if mod==0
			fatal "Invalid main tempo of 0 in song from Sonic 2"
		endif
		if SonicDriverVer==1
			dc.b	s2TempotoS1(mod)
		else;if SonicDriverVer>=3
			dc.b	s2TempotoS3(mod)
		endif
	else;if SourceDriver>=3
		if mod==0
			message "Performing approximate conversion of Sonic 3 main tempo modifier of 0"
		endif
		if SonicDriverVer==1
			dc.b	s3TempotoS1(mod)
		else;if SonicDriverVer==2
			dc.b	s3TempotoS2(mod)
		endif
	endif
	endm

; PSG conversion to S3/S&K/S3D drivers require a tone shift of 12 semi-tones.
psgdelta	EQU 12
PSGPitchConvert macro pitch
	if (SonicDriverVer>=3)&&(SourceDriver<3)
		dc.b	(pitch+psgdelta)&$FF
	elseif (SonicDriverVer<3)&&(SourceDriver>=3)
		dc.b	(pitch-psgdelta)&$FF
	else
		dc.b	pitch
	endif
	endm

; ---------------------------------------------------------------------------------------------
; Header Macros
smpsHeaderStartSong macro ver
SourceDriver set ver
songStart set *
	endm

smpsHeaderStartSongConvert macro ver
SourceDriver set ver
songStart set *
	endm

smpsHeaderVoiceNull macro
	if songStart<>*
		fatal "Missing smpsHeaderStartSong or smpsHeaderStartSongConvert"
	endif
	dc.w	$0000
	endm

; Header - Set up Voice Location
; Common to music and SFX
smpsHeaderVoice macro loc
	if songStart<>*
		fatal "Missing smpsHeaderStartSong or smpsHeaderStartSongConvert"
	endif
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		if MOMPASS==2
		if loc<songStart
			fatal "Voice banks for Sonic 1 songs must come after the song"
		endif
		endif
		dc.w	loc-songStart
	endif
	endm

; Header - Set up Voice Location as S3's Universal Voice Bank
; Common to music and SFX
smpsHeaderVoiceUVB macro
	if songStart<>*
		fatal "Missing smpsHeaderStartSong or smpsHeaderStartSongConvert"
	endif
	if SonicDriverVer>=3
		dc.w	little_endian(z80_UniVoiceBank)
	endif
	endm

; Header macros for music (not for SFX)
; Header - Set up Channel Usage
smpsHeaderChan macro fm,psg
	dc.b	fm,psg
	endm

; Header - Set up Tempo
smpsHeaderTempo macro div,mod
	dc.b	div
	convertMainTempoMod mod
	endm

; Header - Set up DAC Channel
smpsHeaderDAC macro loc,pitch,vol
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-songStart
	endif
	if ("pitch"<>"")
		dc.b	pitch
		if ("vol"<>"")
			dc.b	vol
		else
			dc.b	$00
		endif
	else
		dc.w	$00
	endif
	endm

; Header - Set up FM Channel
smpsHeaderFM macro loc,pitch,vol
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-songStart
	endif
	dc.b	pitch,vol
	endm

; Header - Set up PSG Channel
smpsHeaderPSG macro loc,pitch,vol,mod,voice
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-songStart
	endif
	PSGPitchConvert pitch
	dc.b	vol,mod,voice
	endm

; Header macros for SFX (not for music)
; Header - Set up Tempo
smpsHeaderTempoSFX macro div
	dc.b	div
	endm

; Header - Set up Channel Usage
smpsHeaderChanSFX macro chan
	dc.b	chan
	endm

; Header - Set up FM Channel
smpsHeaderSFXChannel macro chanid,loc,pitch,vol
	if (SonicDriverVer>=3)&&(chanid==cNoise)
		fatal "Using channel ID of cNoise ($E0) in Sonic 3 driver is dangerous. Fix the song so that it turns into a noise channel instead."
	elseif (SonicDriverVer<3)&&(chanid==cFM6)
		fatal "Using channel ID of FM6 ($06) in Sonic 1 or Sonic 2 drivers is unsupported. Change it to another channel."
	endif
	dc.b	$80,chanid
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-songStart
	endif
	if (chanid&$80)<>0
		PSGPitchConvert pitch
	else
		dc.b	pitch
	endif
	dc.b	vol
	endm

; ---------------------------------------------------------------------------------------------
; Co-ord Flag Macros and Equates
; E0xx - Panning, AMS, FMS
smpsPan macro direction,amsfms
panNone set $00
panRight set $40
panLeft set $80
panCentre set $C0
panCenter set $C0 ; silly Americans :U
	dc.b $E0,direction+amsfms
	endm

; E1xx - Set channel frequency displacement to xx
smpsAlterNote macro val
	dc.b	$E1,val
	endm

; E2xx - Useless
smpsNop macro val
	if SonicDriverVer<3
		dc.b	$E2,val
	endif
	endm

; Return (used after smpsCall)
smpsReturn macro val
	if SonicDriverVer>=3
		dc.b	$F9
	else
		dc.b	$E3
	endif
	endm

; Fade in previous song (ie. 1-Up)
smpsFade macro val
	if SonicDriverVer>=3
		dc.b	$E2
		if ("val"<>"")
			dc.b	val
		else
			dc.b	$FF
		endif
		if SourceDriver<3
			smpsStop
		endif
	else
		dc.b	$E4
	endif
	endm

; E5xx - Set channel tempo divider to xx
smpsChanTempoDiv macro val
	if SonicDriverVer==5
		; New flag unique to Flamewing's modified S&K driver
		dc.b	$FF,$08,val
	elseif SonicDriverVer==3
		fatal "Coord. Flag to set tempo divider of a single channel does not exist in S3 driver. Use Flamewing's modified S&K sound driver instead."
	else
		dc.b	$E5,val
	endif
	endm

; E6xx - Alter Volume by xx
smpsAlterVol macro val
	dc.b	$E6,val
	endm

; E7 - Prevent attack of next note
smpsNoAttack	EQU $E7

; E8xx - Set note fill to xx
smpsNoteFill macro val
	if (SonicDriverVer==5)&&(SourceDriver<3)
		; Unique to Flamewing's modified driver
		dc.b	$FF,$0A,val
	else
		if (SonicDriverVer>=3)&&(SourceDriver<3)
			message "Note fill will not work as intended unless you divide the fill value by the tempo divider or complain to Flamewing to add an appropriate coordination flag for it."
		elseif (SonicDriverVer<3)&&(SourceDriver>=3)
			message "Note fill will not work as intended unless you multiply the fill value by the tempo divider or complain to Flamewing to add an appropriate coordination flag for it."
		endif
		dc.b	$E8,val
	endif
	endm

; Add xx to channel pitch
smpsAlterPitch macro val
	if SonicDriverVer>=3
		dc.b	$FB,val
	else
		dc.b	$E9,val
	endif
	endm

; Set music tempo modifier to xx
smpsSetTempoMod macro mod
	if SonicDriverVer>=3
		dc.b	$FF,$00
	else
		dc.b	$EA
	endif
	convertMainTempoMod mod
	endm

; Set music tempo divider to xx
smpsSetTempoDiv macro val
	if SonicDriverVer>=3
		dc.b	$FF,$04,val
	else
		dc.b	$EB,val
	endif
	endm

; ECxx - Set Volume to xx
smpsSetVol macro val
	if SonicDriverVer>=3
		dc.b	$E4,val
	else
		fatal "Coord. Flag to set volume (instead of volume attenuation) does not exist in S1 or S2 drivers. Complain to Flamewing to add it."
	endif
	endm

; Works on all drivers
smpsPSGAlterVol macro vol
	dc.b	$EC,vol
	endm

; Clears pushing sound flag in S1
smpsClearPush macro
	if SonicDriverVer==1
		dc.b	$ED
	else
		fatal "Coord. Flag to clear S1 push block flag does not exist in S2 or S3 drivers. Complain to Flamewing to add it."
	endif
	endm

; Stops special SFX (S1 only) and restarts overridden music track
smpsStopSpecial macro
	if SonicDriverVer==1
		dc.b	$EE
	else
		message "Coord. Flag to stop special SFX does not exist in S2 or S3 drivers. Complain to Flamewing to add it. With adequate caution, smpsStop can do this job."
		dc.b	$F2
	endif
	endm

; EFxx[yy] - Set Voice of FM channel to xx; xx < 0 means yy present
smpsSetvoice macro voice,songID
	if (SonicDriverVer>=3)&&("songID"<>"")
		dc.b	$EF,voice|$80,songID+$81
	else
		dc.b	$EF,voice
	endif
	endm

; F0wwxxyyzz - Modulation - ww: wait time - xx: modulation speed - yy: change per step - zz: number of steps
smpsModSet macro wait,speed,change,step
	dc.b	$F0
	if (SonicDriverVer>=3)&&(SourceDriver<3)
		dc.b	wait+1,speed,change,(step*speed+1)&$FF
	elseif (SonicDriverVer<3)&&(SourceDriver>=3)
		dc.b	wait-1,speed,change,conv0To256(step)/conv0To256(speed)-1
	else
		dc.b	wait,speed,change,step
	endif
	;dc.b	speed,change,step
	endm

; Turn on Modulation
smpsModOn macro
	if SonicDriverVer>=3
		dc.b	$F4,$80
	else
		dc.b	$F1
	endif
	endm

; F2 - End of channel
smpsStop macro
	dc.b	$F2
	endm

; F3xx - PSG waveform to xx
smpsPSGform macro form
	dc.b	$F3,form
	endm

; Turn off Modulation
smpsModOff macro
	if SonicDriverVer>=3
		dc.b	$FA
	else
		dc.b	$F4
	endif
	endm

; F5xx - PSG voice to xx
smpsPSGvoice macro voice
	dc.b	$F5,voice
	endm

; F6xxxx - Jump to xxxx
smpsJump macro loc
	dc.b	$F6
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-*-1
	endif
	endm

; F7xxyyzzzz - Loop back to zzzz yy times, xx being the loop index for loop recursion fixing
smpsLoop macro index,loops,loc
	dc.b	$F7
	dc.b	index,loops
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-*-1
	endif
	endm

; F8xxxx - Call pattern at xxxx, saving return point
smpsCall macro loc
	dc.b	$F8
	if SonicDriverVer<>1
		dc.w	z80_ptr(loc)
	else
		dc.w	loc-*-1
	endif
	endm

; ---------------------------------------------------------------------------------------------
; Alter Volume
smpsFMAlterVol macro val1,val2
	if (SonicDriverVer>=3)&&("val2"<>"")
		dc.b	$E5,val1,val2
	else
		dc.b	$E6,val1
	endif
	endm

; S3/S&K/S3D-only coordination flags
	if SonicDriverVer>=3
; Silences FM channel then stops as per smpsStop
smpsStopFM macro
	dc.b	$E3
	endm

; Spindash Rev
smpsSpindashRev macro
	dc.b	$E9
	endm
	
smpsPlayDACSample macro sample
	dc.b	$EA,sample
	endm
	
smpsConditionalJump macro index,loc
	dc.b	$EB
	dc.b	index
	dc.w	z80_ptr(loc)
	endm

; Set note values to xx-$40
smpsSetNote macro val
	dc.b	$ED,val
	endm

smpsFMICommand macro reg,val
	dc.b	$EE,reg,val
	endm

; Set Modulation
smpsModChange2 macro fmmod,psgmod
	dc.b	$F1,fmmod,psgmod
	endm

; Set Modulation
smpsModChange macro val
	dc.b	$F4,val
	endm

; FCxxxx - Jump to xxxx
smpsContinuousLoop macro loc
	dc.b	$FC
	dc.w	z80_ptr(loc)
	endm

smpsAlternateSMPS macro flag
	dc.b	$FD,flag
	endm

smpsFM3SpecialMode macro ind1,ind2,ind3,ind4
	dc.b	$FE,ind1,ind2,ind3,ind4
	endm

smpsPlaySound macro index
	dc.b	$FF,$01,index
	endm

smpsHaltMusic macro flag
	dc.b	$FF,$02,flag
	endm

smpsCopyData macro data,len
	fatal "Coord. Flag to copy data should not be used. Complain to Flamewing if any music uses it."
	dc.b	$FF,$03
	dc.w	little_endian(data)
	dc.b	len
	endm

smpsSSGEG macro op1,op2,op3,op4
	dc.b	$FF,$05,op1,op3,op2,op4
	endm

smpsFMFlutter macro tone,mask
	dc.b	$FF,$06,tone,mask
	endm

smpsResetSpindashRev macro val
	dc.b	$FF,$07
	endm

	; Flag ported from Ristar.
	if SonicDriverVer==5
smpsChanFMCommand macro reg,val
	dc.b	$FF,$09,reg,val
	endm
	endif

	endif

; ---------------------------------------------------------------------------------------------
; S1/S2 only coordination flag
; Sets D1L to maximum volume (minimum attenuation) and RR to maximum for operators 3 and 4 of FM1
smpsWeirdD1LRR macro
	if SonicDriverVer>=3
		; Emulate it in S3/S&K/S3D driver
		smpsFMICommand $88,$0F
		smpsFMICommand $8C,$0F
	else
		dc.b	$F9
	endif
	endm

; ---------------------------------------------------------------------------------------------
; Macros for FM instruments
; Voices - Feedback
smpsVcFeedback macro val
vcFeedback set val
	endm

; Voices - Algorithm
smpsVcAlgorithm macro val
vcAlgorithm set val
	endm

smpsVcUnusedBits macro val
vcUnusedBits set val
	endm

; Voices - Detune
smpsVcDetune macro op1,op2,op3,op4
vcDT1 set op1
vcDT2 set op2
vcDT3 set op3
vcDT4 set op4
	endm

; Voices - Coarse-Frequency
smpsVcCoarseFreq macro op1,op2,op3,op4
vcCF1 set op1
vcCF2 set op2
vcCF3 set op3
vcCF4 set op4
	endm

; Voices - Rate Scale
smpsVcRateScale macro op1,op2,op3,op4
vcRS1 set op1
vcRS2 set op2
vcRS3 set op3
vcRS4 set op4
	endm

; Voices - Attack Rate
smpsVcAttackRate macro op1,op2,op3,op4
vcAR1 set op1
vcAR2 set op2
vcAR3 set op3
vcAR4 set op4
	endm

; Voices - Amplitude Modulation
smpsVcAmpMod macro op1,op2,op3,op4
vcAM1 set op1
vcAM2 set op2
vcAM3 set op3
vcAM4 set op4
	endm

; Voices - First Decay Rate
smpsVcDecayRate1 macro op1,op2,op3,op4
vcD1R1 set op1
vcD1R2 set op2
vcD1R3 set op3
vcD1R4 set op4
	endm

; Voices - Second Decay Rate
smpsVcDecayRate2 macro op1,op2,op3,op4
vcD2R1 set op1
vcD2R2 set op2
vcD2R3 set op3
vcD2R4 set op4
	endm

; Voices - Decay Level
smpsVcDecayLevel macro op1,op2,op3,op4
vcDL1 set op1
vcDL2 set op2
vcDL3 set op3
vcDL4 set op4
	endm

; Voices - Release Rate
smpsVcReleaseRate macro op1,op2,op3,op4
vcRR1 set op1
vcRR2 set op2
vcRR3 set op3
vcRR4 set op4
	endm

; Voices - Total Level
smpsVcTotalLevel macro op1,op2,op3,op4
vcTL1 set op1
vcTL2 set op2
vcTL3 set op3
vcTL4 set op4
	dc.b	(vcUnusedBits<<6)+(vcFeedback<<3)+vcAlgorithm
;   0     1     2     3     4     5     6     7
;%1000,%1000,%1000,%1000,%1010,%1110,%1110,%1111
vcTLMask4 set ((vcAlgorithm==7)<<7)
vcTLMask3 set ((vcAlgorithm>=4)<<7)
vcTLMask2 set ((vcAlgorithm>=5)<<7)
vcTLMask1 set $80
	if SonicDriverVer==2
		dc.b	(vcDT4<<4)+vcCF4 ,(vcDT2<<4)+vcCF2 ,(vcDT3<<4)+vcCF3 ,(vcDT1<<4)+vcCF1
		dc.b	(vcRS4<<6)+vcAR4 ,(vcRS2<<6)+vcAR2 ,(vcRS3<<6)+vcAR3 ,(vcRS1<<6)+vcAR1
		dc.b	(vcAM4<<5)+vcD1R4,(vcAM2<<5)+vcD1R2,(vcAM3<<5)+vcD1R3,(vcAM1<<5)+vcD1R1
		dc.b	vcD2R4           ,vcD2R2           ,vcD2R3           ,vcD2R1
		dc.b	(vcDL4<<4)+vcRR4 ,(vcDL2<<4)+vcRR2 ,(vcDL3<<4)+vcRR3 ,(vcDL1<<4)+vcRR1
		dc.b	vcTL4|vcTLMask4  ,vcTL2|vcTLMask2  ,vcTL3|vcTLMask3  ,vcTL1|vcTLMask1
	else
		dc.b	(vcDT4<<4)+vcCF4 ,(vcDT3<<4)+vcCF3 ,(vcDT2<<4)+vcCF2 ,(vcDT1<<4)+vcCF1
		dc.b	(vcRS4<<6)+vcAR4 ,(vcRS3<<6)+vcAR3 ,(vcRS2<<6)+vcAR2 ,(vcRS1<<6)+vcAR1
		dc.b	(vcAM4<<5)+vcD1R4,(vcAM3<<5)+vcD1R3,(vcAM2<<5)+vcD1R2,(vcAM1<<5)+vcD1R1
		dc.b	vcD2R4           ,vcD2R3           ,vcD2R2           ,vcD2R1
		dc.b	(vcDL4<<4)+vcRR4 ,(vcDL3<<4)+vcRR3 ,(vcDL2<<4)+vcRR2 ,(vcDL1<<4)+vcRR1
		dc.b	vcTL4|vcTLMask4  ,vcTL3|vcTLMask3  ,vcTL2|vcTLMask2  ,vcTL1|vcTLMask1
	endif
	endm

